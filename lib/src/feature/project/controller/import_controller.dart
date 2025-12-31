import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:tmai_pro/src/feature/project/controller/preview_controller.dart';
import 'package:tmai_pro/src/utils/path_builder.dart';

final importFilesControllerProvider =
    Provider.family<ImportFilesController, Project>((ref, Project project) {
      return ImportFilesController(project: project, ref: ref);
    });

class ImportFilesController {
  ImportFilesController({required Project project, required Ref ref})
    : _project = project,
      _ref = ref;

  final Project _project;
  final Ref _ref;

  Future<void> importImages() async {
    final destinationPath = PathBuilder.rawImagesDir(
      projectPath: _project.path,
    );
    final destinationDir = Directory(destinationPath);

    if (!destinationDir.existsSync()) {
      destinationDir.createSync(recursive: true);
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      allowMultiple: true,
    );

    if (result == null) return;

    for (final file in result.files) {
      if (file.path == null) continue;

      final sourceFile = File(file.path!);
      final fileName = p.basename(sourceFile.path);
      final targetFile = File(p.join(destinationDir.path, fileName));

      await sourceFile.copy(targetFile.path);
      _ref.read(previewControllerProvider(_project).notifier).loadImages();
    }
  }

  Future<void> importImagesFromFolder() async {
    final destinationPath = PathBuilder.rawImagesDir(
      projectPath: _project.path,
    );
    final destinationDir = Directory(destinationPath);

    if (!destinationDir.existsSync()) {
      destinationDir.createSync(recursive: true);
    }

    final result = await FilePicker.platform.getDirectoryPath();
    if (result == null) return;

    final sourceDir = Directory(result);

    final allowedExtensions = ['.jpg', '.jpeg', '.png'];

    final imageFiles = sourceDir
        .listSync(recursive: true)
        .whereType<File>()
        .where(
          (file) =>
              allowedExtensions.contains(p.extension(file.path).toLowerCase()),
        );

    for (final file in imageFiles) {
      final fileName = p.basename(file.path);
      final targetFile = File(p.join(destinationDir.path, fileName));
      await file.copy(targetFile.path);
    }
  }
}
