import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:tmai_pro/src/entity_models/dataset/dataset.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/version/state/create_version_state.dart';
import 'package:tmai_pro/src/feature/version/state/dataset_export_state.dart';
import 'package:tmai_pro/src/services/db_services.dart';
import 'package:tmai_pro/src/utils/path_builder.dart';

// --- Helper Class for Stats Tracking ---
class _DatasetStats {
  // Tracks number of boxes per class per split: {'train': {'cat': 50, 'dog': 30}}
  final Map<String, Map<String, int>> classCounts = {
    'train': {},
    'val': {},
    'test': {},
  };

  // Tracks total images per split
  final Map<String, int> imageCounts = {'train': 0, 'val': 0, 'test': 0};

  void recordImage(String split) {
    imageCounts[split] = (imageCounts[split] ?? 0) + 1;
  }

  void recordBoxes(String split, List<dynamic> boxes) {
    final splitMap = classCounts[split]!;
    for (var box in boxes) {
      final String className = box['className'];
      splitMap[className] = (splitMap[className] ?? 0) + 1;
    }
  }
}

class AnnotationItem {
  final String imagePath;
  final List<dynamic> boxes;

  AnnotationItem(this.imagePath, this.boxes);
}

final datasetExportControllerProvider =
    StateNotifierProvider<DatasetExportController, DatasetExportState>((ref) {
      return DatasetExportController(ref: ref);
    });

class DatasetExportController extends StateNotifier<DatasetExportState> {
  DatasetExportController({required Ref ref})
    : _ref = ref,
      super(DatasetExportState());

  final Ref _ref;

  Future<void> exportDataset({
    required Project project,
    required CreateVersionState config,
  }) async {
    try {
      state = state.copyWith(
        status: ExportStatus.preparing,
        currentOperation: 'Reading annotations...',
        progress: 0.0,
      );

      final versionNumber = await _ref
          .read(dbServiceProvider)
          .getProject(project.id)
          .then((p) => p!.datasets.length);

      // --- Initialize Stats Tracker ---
      final stats = _DatasetStats();

      // --- 1. Read JSON from Disk ---
      final annotationPath = PathBuilder.temporaryAnnotationJson(
        projectPath: project.path,
      );
      final File jsonFile = File(annotationPath);

      if (!jsonFile.existsSync()) {
        throw Exception("Annotation file not found at $annotationPath");
      }

      final String content = await jsonFile.readAsString();
      final Map<String, dynamic> jsonData = jsonDecode(content);

      final List<dynamic> rawAnnotations = jsonData['annotations'] ?? [];

      List<AnnotationItem> items = rawAnnotations.map((item) {
        return AnnotationItem(
          item['imagePath'] as String,
          item['boxes'] as List<dynamic>,
        );
      }).toList();

      if (items.isEmpty) throw Exception("No annotations found.");

      // 2. Directories
      final versionPath = p.join(
        project.path,
        'versions',
        "version_$versionNumber",
      );
      state = state.copyWith(currentOperation: 'Creating directories...');
      await _createDirectoryStructure(versionPath);

      // 3. Shuffle & Split
      items.shuffle(Random());
      final total = items.length;
      final trainCount = (total * config.trainSplit).round();
      final valCount = (total * config.valSplit).round();

      // Handling list ranges safely
      final trainSet = items.sublist(0, trainCount);
      final valSet = items.sublist(
        trainCount,
        min(trainCount + valCount, total),
      );
      final testSet = items.sublist(min(trainCount + valCount, total));

      // 4. Process Splits
      state = state.copyWith(status: ExportStatus.processing);

      final totalOps =
          (trainSet.length * (1 + config.augmentations.length)) +
          valSet.length +
          testSet.length;

      int processedCount = 0;

      // TRAIN SET
      await _processSet(
        items: trainSet,
        splitName: 'train',
        versionPath: versionPath,
        project: project,
        classes: config.classes,
        augmentations: config.augmentations,
        stats: stats, // Pass stats
        onProgress: () {
          processedCount++;
          state = state.copyWith(
            progress: processedCount / totalOps,
            currentOperation:
                'Processing Train... ${(processedCount / totalOps * 100).toInt()}%',
          );
        },
      );

      // VAL SET
      await _processSet(
        items: valSet,
        splitName: 'val',
        versionPath: versionPath,
        project: project,
        classes: config.classes,
        augmentations: [],
        stats: stats, // Pass stats
        onProgress: () {
          processedCount++;
          state = state.copyWith(
            progress: processedCount / totalOps,
            currentOperation:
                'Processing Val... ${(processedCount / totalOps * 100).toInt()}%',
          );
        },
      );

      // TEST SET
      await _processSet(
        items: testSet,
        splitName: 'test',
        versionPath: versionPath,
        project: project,
        classes: config.classes,
        augmentations: [],
        stats: stats, // Pass stats
        onProgress: () {
          processedCount++;
          state = state.copyWith(
            progress: processedCount / totalOps,
            currentOperation:
                'Processing Test... ${(processedCount / totalOps * 100).toInt()}%',
          );
        },
      );

      // 5. Generate YAML
      await _generateYaml(versionPath, config.classes);

      // 6. Generate Summary JSON
      await _generateSummaryJson(versionPath, stats, config);

      state = state.copyWith(
        status: ExportStatus.completed,
        progress: 1.0,
        currentOperation: 'Export Complete!',
        outputPath: versionPath,
      );

      // 7. Save to DB
      final Dataset dataset = Dataset(
        name: "version_$versionNumber",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        path: versionPath,
        classes: config.classes,
        tags: [],
        testSplit: config.testSplit,
        trainSplit: config.trainSplit,
        valSplit: config.valSplit,
      );
      _ref.read(dbServiceProvider).addDatasetToProject(dataset, project);
    } catch (e, stack) {
      state = state.copyWith(
        status: ExportStatus.error,
        errorMessage: e.toString(),
      );
      debugPrint('Export Error: $e\n$stack');
    }
  }

  Future<void> _processSet({
    required List<AnnotationItem> items,
    required String splitName,
    required String versionPath,
    required Project project,
    required List<String> classes,
    required List<AugmentationStep> augmentations,
    required _DatasetStats stats, // Receive stats tracker
    required VoidCallback onProgress,
  }) async {
    for (var item in items) {
      final File sourceFile = File(item.imagePath);

      // Small delay to allow UI to breathe
      await Future.delayed(Duration.zero);

      if (!sourceFile.existsSync()) {
        onProgress();
        continue;
      }

      final bytes = await sourceFile.readAsBytes();
      final img.Image? originalImage = img.decodeImage(bytes);

      if (originalImage == null) {
        onProgress();
        continue;
      }

      final String baseName = p.basenameWithoutExtension(item.imagePath);

      // 1. ALWAYS Save Original
      await _saveImageAndLabel(
        image: originalImage,
        boxes: item.boxes,
        classes: classes,
        saveDir: p.join(versionPath, splitName),
        fileName: baseName,
      );
      // Update Stats
      stats.recordImage(splitName);
      stats.recordBoxes(splitName, item.boxes);

      onProgress();

      // 2. Loop through Augmentations
      for (var step in augmentations) {
        final augmentedImage = _applySingleAugmentation(originalImage, step);

        final String suffix =
            '_${step.property.toLowerCase().replaceAll(' ', '')}_${step.value}';
        final String augmentedName = '$baseName$suffix';

        await _saveImageAndLabel(
          image: augmentedImage,
          boxes: item.boxes,
          classes: classes,
          saveDir: p.join(versionPath, splitName),
          fileName: augmentedName,
        );

        // Update Stats for Augmented Image
        stats.recordImage(splitName);
        stats.recordBoxes(splitName, item.boxes);

        onProgress();
      }
    }
  }

  Future<void> _saveImageAndLabel({
    required img.Image image,
    required List<dynamic> boxes,
    required List<String> classes,
    required String saveDir,
    required String fileName,
  }) async {
    // Save Image
    final imgPath = p.join(saveDir, 'images', '$fileName.jpg');
    await File(imgPath).writeAsBytes(img.encodeJpg(image));

    // Save Label
    final labelPath = p.join(saveDir, 'labels', '$fileName.txt');
    final txtContent = _generateYoloLabel(
      boxes,
      classes,
      image.width,
      image.height,
    );
    await File(labelPath).writeAsString(txtContent);
  }

  img.Image _applySingleAugmentation(img.Image image, AugmentationStep step) {
    var tempImg = image.clone();

    switch (step.property) {
      case 'Grayscale':
        return img.grayscale(tempImg);
      case 'Blur':
        if (step.value > 0) {
          return img.gaussianBlur(tempImg, radius: step.value.toInt());
        }
        break;
      case 'Rotation':
        if (step.value != 0) {
          return img.copyRotate(tempImg, angle: step.value);
        }
        break;
      case 'Brightness':
        // Brightness logic here if needed
        break;
    }
    return tempImg;
  }

  String _generateYoloLabel(
    List<dynamic> boxes,
    List<String> classes,
    int imgWidth,
    int imgHeight,
  ) {
    StringBuffer buffer = StringBuffer();

    for (var box in boxes) {
      final String className = box['className'];
      final double x = (box['x'] as num).toDouble();
      final double y = (box['y'] as num).toDouble();
      final double w = (box['width'] as num).toDouble();
      final double h = (box['height'] as num).toDouble();

      final int classIndex = classes.indexOf(className);
      if (classIndex == -1) continue;

      final double centerX = x + (w / 2.0);
      final double centerY = y + (h / 2.0);

      final double normCenterX = (centerX / imgWidth).clamp(0.0, 1.0);
      final double normCenterY = (centerY / imgHeight).clamp(0.0, 1.0);
      final double normW = (w / imgWidth).clamp(0.0, 1.0);
      final double normH = (h / imgHeight).clamp(0.0, 1.0);

      buffer.writeln(
        '$classIndex ${normCenterX.toStringAsFixed(6)} ${normCenterY.toStringAsFixed(6)} ${normW.toStringAsFixed(6)} ${normH.toStringAsFixed(6)}',
      );
    }
    return buffer.toString();
  }

  Future<void> _createDirectoryStructure(String basePath) async {
    for (var split in ['train', 'val', 'test']) {
      await Directory(
        p.join(basePath, split, 'images'),
      ).create(recursive: true);
      await Directory(
        p.join(basePath, split, 'labels'),
      ).create(recursive: true);
    }
  }

  Future<void> _generateYaml(String versionPath, List<String> classes) async {
    final buffer = StringBuffer();
    buffer.writeln('train: ../train/images');
    buffer.writeln('val: ../val/images');
    buffer.writeln('test: ../test/images');
    buffer.writeln('');
    buffer.writeln('nc: ${classes.length}');
    buffer.writeln('names:');
    for (var className in classes) {
      buffer.writeln("  - '$className'");
    }
    await File(
      p.join(versionPath, 'data.yaml'),
    ).writeAsString(buffer.toString());
  }

  // --- Updated Summary Generation Method ---
  Future<void> _generateSummaryJson(
    String versionPath,
    _DatasetStats stats,
    CreateVersionState config,
  ) async {
    final Map<String, dynamic> summary = {
      "summary": {
        "splits": {
          "train": config.trainSplit,
          "val": config.valSplit,
          "test": config.testSplit,
        },
        "train": stats.classCounts['train'],
        "test": stats.classCounts['test'],
        "val": stats.classCounts['val'],
        // 'total' represents Image counts per split
        "total": {
          "train": stats.imageCounts['train'],
          "test": stats.imageCounts['test'],
          "val": stats.imageCounts['val'],
        },
        "meta": {
          "created_at": DateTime.now().toIso8601String(),
          "augmentations_applied": config.augmentations
              .map((e) => "${e.property} (${e.value})")
              .toList(),
          "total_boxes_all_splits": _sumAllBoxes(stats.classCounts),
        },
      },
    };

    final encoder = JsonEncoder.withIndent('  ');
    await File(
      p.join(versionPath, 'summary.json'),
    ).writeAsString(encoder.convert(summary));
  }

  int _sumAllBoxes(Map<String, Map<String, int>> counts) {
    int total = 0;
    counts.forEach((_, classMap) {
      classMap.forEach((_, count) => total += count);
    });
    return total;
  }
}
