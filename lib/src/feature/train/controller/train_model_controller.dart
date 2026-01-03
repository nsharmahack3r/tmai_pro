// src/feature/trained_model/controller/training_controller.dart

import 'dart:convert';
import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/entity_models/trained_model/train.dart';
import 'package:tmai_pro/src/feature/train/state/train_model_state.dart';
import 'package:tmai_pro/src/services/db_services.dart';
import 'package:tmai_pro/src/utils/path_builder.dart';

final trainingControllerProvider =
    StateNotifierProvider<TrainingController, TrainingState>((ref) {
      return TrainingController(ref: ref);
    });

class TrainingController extends StateNotifier<TrainingState> {
  TrainingController({required Ref ref})
    : _ref = ref,
      super(TrainingState.initial());

  final Ref _ref;

  Process? _process;

  Future<void> startTraining(TrainModel config) async {
    if (state.isTraining) return;

    try {
      // 1. Reset State
      state = TrainingState.initial().copyWith(
        isTraining: true,
        logs: ["Starting training process..."],
      );

      final projectPath = config.datasetPath.split('versions').first;

      // 2. Get Paths
      final globalEnv = await PathBuilder.globalEnvPath();
      final pythonExe = '$globalEnv\\Scripts\\python.exe';

      final globalRepo = await PathBuilder.globalRepoPath();
      final scriptPath = '$globalRepo\\train.py';
      final runName = "run_${DateTime.now().millisecondsSinceEpoch}";

      // We assume data.yaml exists at versionPath/data.yaml
      final dataYamlPath = '${config.datasetPath}\\data.yaml';

      // 3. Prepare Arguments
      final args = [
        scriptPath,
        '--data', dataYamlPath,
        '--project', "$projectPath\models", // "C:/.../MyProject/models"
        '--name', runName, // "model_v1"
        '--model', "${config.modelId}.pt", // "yolov8n.pt"
        '--epochs', config.epochs.toString(),
        '--batch_size', config.batchSize.toString(),
      ];

      _log("Executing: $pythonExe ${args.join(' ')}");

      // 4. Start Process
      _process = await Process.start(pythonExe, args);

      print("command : $pythonExe ${args.join(' ')}");

      final outputPath = "$projectPath\models\\$runName";
      print("OUTPUT PATH: $outputPath");
      // 5. Listen to Streams
      _process!.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(_handleStdout);

      _process!.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((err) => _log("STDERR: $err")); // Python errors often go here

      // 6. Handle Exit
      final exitCode = await _process!.exitCode;
      state = state.copyWith(isTraining: false);

      _ref
          .read(dbServiceProvider)
          .updateModel(
            config.copyWith(
              path: outputPath,
              status: exitCode == 0
                  ? TrainingStatus.complete
                  : TrainingStatus.error,

              trainedAt: DateTime.now(),
            ),
          );

      _log("Process exited with code $exitCode");
    } catch (e) {
      state = state.copyWith(isTraining: false, error: e.toString());
      _log("CRITICAL ERROR: $e");
    }
  }

  void stopTraining() {
    _process?.kill();
    state = state.copyWith(
      isTraining: false,
      logs: [...state.logs, "Stopped by user."],
    );
  }

  void _handleStdout(String line) {
    try {
      // Check if line is JSON (starts with '{')
      if (line.trim().startsWith('{')) {
        final data = jsonDecode(line);

        if (data['type'] == 'progress') {
          final epoch = (data['epoch'] as num).toDouble();
          final loss = (data['train_loss'] as num).toDouble();
          final map = (data['mAP'] as num).toDouble();
          // Update Progress Metrics
          state = state.copyWith(
            progress: (data['epoch'] as int) / (data['total_epochs'] as int),
            currentEpoch: data['epoch'],
            totalEpochs: data['total_epochs'],
            currentLoss: (data['train_loss'] as num).toDouble(),
            currentMap: (data['mAP'] as num).toDouble(),
            logs: [...state.logs, data['message'] ?? 'Processing...'],
            lossHistory: [...state.lossHistory, FlSpot(epoch, loss)],
            mapHistory: [...state.mapHistory, FlSpot(epoch, map)],
          );
        } else if (data['type'] == 'finish') {
          _log("Training Finished. Model saved at: ${data['best_model_path']}");
        } else if (data['type'] == 'error') {
          state = state.copyWith(error: data['message']);
        }
      } else {
        // Regular print() output from python
        _log(line);
      }
    } catch (e) {
      // If JSON parse fails, just treat as log
      _log(line);
    }
  }

  void _log(String message) {
    // Keep log list from growing infinitely? Maybe limit to last 100 lines.
    final newLogs = [...state.logs, message];
    if (newLogs.length > 200) newLogs.removeAt(0);

    state = state.copyWith(logs: newLogs);
  }
}
