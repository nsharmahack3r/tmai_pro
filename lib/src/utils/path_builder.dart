class PathBuilder {
  const PathBuilder._();
  static String temporaryAnnotationJson({required String projectPath}) {
    return '$projectPath\\temp\\annotations.json';
  }

  static String rawImagesDir({required String projectPath}) {
    return '$projectPath\\raw_images';
  }
}
