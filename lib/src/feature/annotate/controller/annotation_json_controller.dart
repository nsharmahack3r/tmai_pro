import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/feature/annotate/state/annotation_view_state.dart';
import 'package:tmai_pro/src/utils/path_builder.dart';

final annotationJsonControllerProvider =
    Provider.family<AnnotationJsonController, String>((ref, projectPath) {
      return AnnotationJsonController(projectPath: projectPath);
    });

class AnnotationJsonController {
  AnnotationJsonController({required String projectPath})
    : _annotationFilePath = PathBuilder.temporaryAnnotationJson(
        projectPath: projectPath,
      );

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
  void saveAnnotations({required String imagePath, required List<BBox> boxes}) {
    final file = File(_annotationFilePath);
    _createAnnotationFileIfNotExists();

    final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;

    final List annotations = data["annotations"] ?? [];

    // Remove existing entry for this image (if any)
    annotations.removeWhere((item) => item["imagePath"] == imagePath);

    // Add updated annotation
    annotations.add({
      "imagePath": imagePath,
      "boxes": boxes.map((b) {
        return {
          "x": b.rect.left,
          "y": b.rect.top,
          "width": b.rect.width,
          "height": b.rect.height,
          "className": b.className,
        };
      }).toList(),
    });

    data["annotations"] = annotations;

    file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
  }

  /// ------------------------------------------------------------
  /// LOAD ANNOTATIONS FOR A SINGLE IMAGE
  /// ------------------------------------------------------------
  Future<List<BBox>> loadAnnotations({required String imagePath}) async {
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

    return boxes.map<BBox>((b) {
      return BBox(
        rect: Rect.fromLTWH(
          (b["x"] as num).toDouble(),
          (b["y"] as num).toDouble(),
          (b["width"] as num).toDouble(),
          (b["height"] as num).toDouble(),
        ),
        className: b["className"] ?? "default",
      );
    }).toList();
  }
}
