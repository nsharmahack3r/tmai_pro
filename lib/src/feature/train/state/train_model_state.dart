// src/feature/trained_model/state/training_state.dart

import 'package:fl_chart/fl_chart.dart';

class TrainingState {
  final bool isTraining;
  final double progress; // 0.0 to 1.0
  final int currentEpoch;
  final int totalEpochs;
  final double currentLoss; // For the graph
  final double currentMap; // Mean Average Precision
  final List<String> logs; // Console output for "Advanced View"
  final String? error;

  final List<FlSpot> lossHistory; // X: Epoch, Y: Loss
  final List<FlSpot> mapHistory; // X: Epoch, Y: mAP

  TrainingState({
    this.isTraining = false,
    this.progress = 0.0,
    this.currentEpoch = 0,
    this.totalEpochs = 0,
    this.currentLoss = 0.0,
    this.currentMap = 0.0,
    this.logs = const [],
    this.error,

    this.lossHistory = const [],
    this.mapHistory = const [],
  });

  // Boilerplate copyWith...
  TrainingState copyWith({
    bool? isTraining,
    double? progress,
    int? currentEpoch,
    int? totalEpochs,
    double? currentLoss,
    double? currentMap,
    List<String>? logs,
    String? error,
    List<FlSpot>? lossHistory,
    List<FlSpot>? mapHistory,
  }) {
    return TrainingState(
      isTraining: isTraining ?? this.isTraining,
      progress: progress ?? this.progress,
      currentEpoch: currentEpoch ?? this.currentEpoch,
      totalEpochs: totalEpochs ?? this.totalEpochs,
      currentLoss: currentLoss ?? this.currentLoss,
      currentMap: currentMap ?? this.currentMap,
      logs: logs ?? this.logs,
      error: error ?? this.error,
      lossHistory: lossHistory ?? this.lossHistory,
      mapHistory: mapHistory ?? this.mapHistory,
    );
  }

  factory TrainingState.initial() => TrainingState();
}
