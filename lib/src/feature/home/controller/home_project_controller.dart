import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/services/db_services.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

final homeProjectControllerProvider = Provider<HomeProjectController>((ref) {
  return HomeProjectController(dbServices: ref.watch(dbServiceProvider));
});

class HomeProjectController {
  final DbServices _dbServices;

  HomeProjectController({required DbServices dbServices})
    : _dbServices = dbServices;

  Future<int> createNewProject({
    required String projectName,
    required String path,
  }) async {
    print("Called to create new project");
    final currentTime = DateTime.now();

    try {
      final projectId = await _dbServices.createProject(
        Project(
          title: projectName,
          createdAt: currentTime,
          updatedAt: currentTime,
          path: path,
        ),
      );

      return projectId;
    } catch (e) {
      print(e);
      return -1;
    }
  }

  Future<String> getLocalProjectPath() async {
    try {
      // Ask user to pick a directory on desktop
      final selectedDirectory = await FilePicker.platform.getDirectoryPath();

      print("Dir path selected: $selectedDirectory");

      if (selectedDirectory == null) {
        // User cancelled directory selection
        return '';
      }

      final projectDir = Directory(selectedDirectory);

      // Ensure directory exists
      if (!projectDir.existsSync()) {
        projectDir.createSync(recursive: true);
      }
      return projectDir.path;
    } catch (e) {
      return '';
    }
  }
}
