import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PathBuilder {
  const PathBuilder._();
  static String temporaryAnnotationJson({required String projectPath}) {
    return '$projectPath\\temp\\annotations.json';
  }

  static String rawImagesDir({required String projectPath}) {
    return '$projectPath\\raw_images';
  }

  static String summaryJsonPath({required String versionPath}) {
    return '$versionPath\\summary.json';
  }

  static Future<String> globalEnvPath() async {
    final Directory appDocDir = await getApplicationSupportDirectory();
    // Ensure the engine directory exists
    final engineDir = Directory('${appDocDir.path}\\engine');
    if (!await engineDir.exists()) {
      await engineDir.create(recursive: true);
    }
    return '${engineDir.path}\\venv';
  }

  static Future<String> globalRepoPath() async {
    final Directory appDocDir = await getApplicationSupportDirectory();
    return '${appDocDir.path}\\engine\\repo';
  }
}
