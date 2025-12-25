import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';

class PreviewController extends StateNotifier<PreviewControllerState> {
  PreviewController({required Project project})
    : _project = project,
      super(PreviewControllerState.initial());

  final Project _project;

  void loadImages() {
    final rawImagesPath = "${_project.path}/raw_images";
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
