import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

final previewControllerProvider =
    StateNotifierProvider.family<
      PreviewController,
      PreviewControllerState,
      Project
    >((ref, Project project) {
      return PreviewController(project: project);
    });

class PreviewController extends StateNotifier<PreviewControllerState> {
  PreviewController({required Project project})
    : _project = project,
      super(PreviewControllerState.initial());

  final Project _project;

  Future<void> loadImages() async {
    state = state.copyWith(loading: true);

    try {
      final rawImagesPath = "${_project.path}/raw_images";
      final dir = Directory(rawImagesPath);

      if (!dir.existsSync()) {
        state = state.copyWith(imagePaths: [], loading: false);
        return;
      }

      final allowedExtensions = ['.jpg', '.jpeg', '.png'];

      final images = dir
          .listSync()
          .whereType<File>()
          .where(
            (file) => allowedExtensions.contains(
              p.extension(file.path).toLowerCase(),
            ),
          )
          .map((file) => file.path)
          .toList();

      images.sort();

      state = state.copyWith(imagePaths: images, loading: false);
    } catch (e) {
      state = PreviewControllerState(
        imagePaths: [],
        loading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

class PreviewControllerState {
  final List<String> imagePaths;
  final bool loading;
  final String? errorMessage;

  PreviewControllerState({
    required this.imagePaths,
    required this.loading,
    this.errorMessage,
  });

  PreviewControllerState copyWith({List<String>? imagePaths, bool? loading}) {
    return PreviewControllerState(
      imagePaths: imagePaths ?? this.imagePaths,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
    );
  }

  factory PreviewControllerState.initial() {
    return PreviewControllerState(
      imagePaths: [],
      loading: false,
      errorMessage: null,
    );
  }

  PreviewControllerState setError({String? errorMessage}) {
    return PreviewControllerState(
      imagePaths: imagePaths,
      loading: loading,
      errorMessage: errorMessage,
    );
  }
}
