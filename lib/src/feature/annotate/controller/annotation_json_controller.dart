import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final annotationJsonControllerProvider =
    Provider.family<AnnotationJsonController, String>((ref, projectPath) {
      return AnnotationJsonController(projectPath: projectPath);
    });

class AnnotationJsonController {
  AnnotationJsonController({required String projectPath})
    : _annotationFilePath = "$projectPath/temp/annotations.json";

  final String _annotationFilePath;

  /// ------------------------------------------------------------
  /// CREATE FILE IF NOT EXISTS
  /// ------------------------------------------------------------
  void _createAnnotationFileIfNotExists() {
    final file = File(_annotationFilePath);

    if (!file.existsSync()) {
      file.parent.createSync(recursive: true);
      file.writeAsStringSync(
        const JsonEncoder.withIndent('  ').convert({"annotations": []}),
      );
    }
  }

  /// ------------------------------------------------------------
  /// SAVE ANNOTATIONS FOR A SINGLE IMAGE
  /// (Overwrites boxes if imagePath already exists)
  /// ------------------------------------------------------------
  void saveAnnotations({required String imagePath, required List<Rect> boxes}) {
    final file = File(_annotationFilePath);
    _createAnnotationFileIfNotExists();

    final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;

    final List annotations = data["annotations"] ?? [];

    // Remove existing entry for this image (if any)
    annotations.removeWhere((item) => item["imagePath"] == imagePath);

    // Add updated annotation
    annotations.add({
      "imagePath": imagePath,
      "boxes": boxes.map((rect) {
        return {
          "x": rect.left,
          "y": rect.top,
          "width": rect.width,
          "height": rect.height,
        };
      }).toList(),
    });

    data["annotations"] = annotations;

    file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
  }

  /// ------------------------------------------------------------
  /// LOAD ANNOTATIONS FOR A SINGLE IMAGE
  /// ------------------------------------------------------------
  Future<List<Rect>> loadAnnotations({required String imagePath}) async {
    final file = File(_annotationFilePath);

    if (!await file.exists()) return [];

    final data = jsonDecode(await file.readAsString()) as Map<String, dynamic>;

    final List annotations = data["annotations"] ?? [];

    final imageEntry = annotations.firstWhere(
      (item) => item["imagePath"] == imagePath,
      orElse: () => null,
    );

    if (imageEntry == null) return [];

    final List boxes = imageEntry["boxes"] ?? [];

    return boxes.map<Rect>((b) {
      return Rect.fromLTWH(
        (b["x"] as num).toDouble(),
        (b["y"] as num).toDouble(),
        (b["width"] as num).toDouble(),
        (b["height"] as num).toDouble(),
      );
    }).toList();
  }
}
