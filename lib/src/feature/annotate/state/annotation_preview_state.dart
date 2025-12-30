class AnnotationPreviewState {
  final List<String> imagePaths;
  final List<String> annotatedImagePaths;
  final int currentIndex;
  final bool loading;
  final Map<String, dynamic> annotations;

  AnnotationPreviewState({
    required this.imagePaths,
    required this.annotatedImagePaths,
    required this.currentIndex,
    required this.loading,
    required this.annotations,
  });

  AnnotationPreviewState copyWith({
    List<String>? imagePaths,
    List<String>? annotatedImagePaths,
    int? currentIndex,
    bool? loading,
    Map<String, dynamic>? annotations,
  }) {
    return AnnotationPreviewState(
      imagePaths: imagePaths ?? this.imagePaths,
      annotatedImagePaths: annotatedImagePaths ?? this.annotatedImagePaths,
      currentIndex: currentIndex ?? this.currentIndex,
      loading: loading ?? this.loading,
      annotations: annotations ?? this.annotations,
    );
  }

  factory AnnotationPreviewState.initial() {
    return AnnotationPreviewState(
      imagePaths: [],
      annotatedImagePaths: [],
      currentIndex: -1,
      loading: false,
      annotations: {},
    );
  }
}
