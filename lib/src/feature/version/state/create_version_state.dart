class CreateVersionState {
  // Split
  final double testSplit;
  final double trainSplit;
  final double valSplit;

  // dataset info

  final int totalImages;
  final List<String> classes;
  final Map<String, int> classCounts;

  // Augmentations

  final List<AugmentationStep> augmentations;

  CreateVersionState({
    required this.testSplit,
    required this.trainSplit,
    required this.valSplit,
    required this.totalImages,
    required this.classes,
    required this.classCounts,
    required this.augmentations,
  });

  CreateVersionState copyWith({
    double? testSplit,
    double? trainSplit,
    double? valSplit,
    int? totalImages,
    List<String>? classes,
    Map<String, int>? classCounts,
    List<AugmentationStep>? augmentations,
  }) {
    return CreateVersionState(
      testSplit: testSplit ?? this.testSplit,
      trainSplit: trainSplit ?? this.trainSplit,
      valSplit: valSplit ?? this.valSplit,
      totalImages: totalImages ?? this.totalImages,
      classes: classes ?? this.classes,
      classCounts: classCounts ?? this.classCounts,
      augmentations: augmentations ?? this.augmentations,
    );
  }

  factory CreateVersionState.initial() {
    return CreateVersionState(
      testSplit: 0.1,
      trainSplit: 0.8,
      valSplit: 0.1,
      totalImages: 0,
      classes: [],
      classCounts: {},
      augmentations: [],
    );
  }
}

class AugmentationStep {
  final String property;
  final double value;

  AugmentationStep(this.property, this.value);
}
