import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/annotate/controller/annotation_json_controller.dart';
import 'package:tmai_pro/src/feature/version/state/create_version_state.dart';

final createVersionViewControllerProvider =
    StateNotifierProvider.family<
      CreateVersionViewController,
      CreateVersionState,
      Project
    >(
      (ref, project) => CreateVersionViewController(
        jsonController: ref.read(
          annotationJsonControllerProvider(project.path),
        ),
        project: project,
      ),
    );

class CreateVersionViewController extends StateNotifier<CreateVersionState> {
  final AnnotationJsonController _jsonController;
  final Project _project;

  CreateVersionViewController({
    required AnnotationJsonController jsonController,
    required Project project,
  }) : _jsonController = jsonController,
       _project = project,
       super(CreateVersionState.initial()) {
    _init();
  }

  void _init() {
    final classCounts = _jsonController.loadClassCounts();
    int totalImages = 0;
    for (final key in classCounts.keys) {
      totalImages += classCounts[key] ?? 0;
    }

    state = state.copyWith(
      totalImages: totalImages,
      classCounts: classCounts,
      classes: _project.classes,
    );
  }

  // --- Split Logic ---
  void setTrainSplit(double value) {
    // value is 0.0 to 1.0
    if (value >= 1.0) return;

    // Automatically adjust val/test to fill the remainder proportionally
    // Simple logic: maintain ratio between val and test, or dump remainder into test
    double remainder = 1.0 - value;

    // Default split for remainder: 50/50 between val and test
    state = state.copyWith(
      trainSplit: value,
      valSplit: remainder / 2,
      testSplit: remainder / 2,
    );
  }

  void updateExactSplits({
    required double train,
    required double val,
    required double test,
  }) {
    // Basic validation to ensure they sum to ~1.0
    if ((train + val + test - 1.0).abs() > 0.01) return;

    state = state.copyWith(trainSplit: train, valSplit: val, testSplit: test);
  }

  // --- Augmentations ---
  void addAugmentation(AugmentationStep step) {
    state = state.copyWith(augmentations: [...state.augmentations, step]);
  }

  void removeAugmentation(int index) {
    final updatedList = [...state.augmentations];
    updatedList.removeAt(index);
    state = state.copyWith(augmentations: updatedList);
  }
}
