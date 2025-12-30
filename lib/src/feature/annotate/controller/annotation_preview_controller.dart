import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/feature/annotate/state/annotation_preview_state.dart';
import 'package:tmai_pro/src/utils/path_builder.dart';
import 'package:path/path.dart' as p;

final annotationPreviewControllerProvider =
    StateNotifierProvider.family<
      AnnotationPreviewController,
      AnnotationPreviewState,
      String
    >((ref, projectPath) {
      return AnnotationPreviewController(projectPath: projectPath);
    });

class AnnotationPreviewController
    extends StateNotifier<AnnotationPreviewState> {
  AnnotationPreviewController({required String projectPath})
    : _projectPath = projectPath,
      super(AnnotationPreviewState.initial()) {
    reload();
  }

  final String _projectPath;

  void reload() {
    loadAnnotations();
    loadImagePaths();
  }

  void loadImagePaths() {
    final rawImagesDir = Directory(
      PathBuilder.rawImagesDir(projectPath: _projectPath),
    );

    if (!rawImagesDir.existsSync()) {
      // No images directory → reset state
      return;
    }

    final imagePaths =
        rawImagesDir
            .listSync(recursive: false)
            .whereType<File>()
            .where((file) {
              final ext = p.extension(file.path).toLowerCase();
              return ext == '.jpg' || ext == '.jpeg' || ext == '.png';
            })
            .map((file) => file.path.replaceAll('/', '\\'))
            .toList()
          ..sort();

    if (imagePaths.isEmpty) {
      state = state.copyWith(imagePaths: const [], currentIndex: 0);
      return;
    }

    state = state.copyWith(imagePaths: imagePaths, currentIndex: 0);
  }

  void loadAnnotations() {
    final annotationFilePath = PathBuilder.temporaryAnnotationJson(
      projectPath: _projectPath,
    );

    final annotationFile = File(annotationFilePath);

    final data = annotationFile.existsSync()
        ? annotationFile.readAsStringSync()
        : '{}';

    final jsonData = jsonDecode(data) as Map<String, dynamic>;
    final List<String> annotatedImagePaths = [];

    if (jsonData['annotations'] != null) {
      if (jsonData['annotations'].isEmpty) {
        return;
      }

      final Map<String, dynamic> annotationData = {};
      for (final json in jsonData['annotations']) {
        final imagePath = json['imagePath'] as String;
        annotationData[imagePath] = json['boxes'];
        if (json['boxes'] != null && (json['boxes'] as List).isNotEmpty) {
          annotatedImagePaths.add(imagePath);
        }
      }
      state = state.copyWith(
        annotations: annotationData,
        annotatedImagePaths: annotatedImagePaths,
      );
    }
  }

  void selectImage(String path) {
    final index = state.imagePaths.indexOf(path);
    if (index != -1) {
      state = state.copyWith(currentIndex: index);
    }
  }

  void clearSelection() {
    state = state.copyWith(currentIndex: -1);
  }
}
