import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/entity_models/enums/box_handle.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/annotate/controller/annotation_json_controller.dart';
import 'package:tmai_pro/src/feature/annotate/state/annotation_view_state.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:tmai_pro/src/services/db_services.dart';
import 'package:tmai_pro/src/utils/path_builder.dart';

final annotateViewControllerProvider =
    StateNotifierProvider.family<
      AnnotateViewController,
      AnnotationViewState,
      Project
    >((ref, project) {
      final jsonController = ref.read(
        annotationJsonControllerProvider(project.path),
      );
      return AnnotateViewController(
        jsonController: jsonController,
        project: project,
        ref: ref,
      );
    });

class AnnotateViewController extends StateNotifier<AnnotationViewState> {
  AnnotateViewController({
    required AnnotationJsonController jsonController,
    required Project project,
    required Ref ref,
  }) : _jsonController = jsonController,
       _project = project,
       _ref = ref,
       super(AnnotationViewState.initial()) {
    loadImages();
    if (project.classes.isNotEmpty) {
      state = state.copyWith(classes: project.classes);
    }
  }

  final AnnotationJsonController _jsonController;
  final Project _project;
  final Ref _ref;

  Future<Size> _getImageSize(String path) async {
    final file = File(path);
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frameInfo = await codec.getNextFrame();
    return Size(
      frameInfo.image.width.toDouble(),
      frameInfo.image.height.toDouble(),
    );
  }

  void setBoxHandle(BoxHandle handle) {
    state = state.copyWith(activeHandle: handle);
  }

  void addBox(Rect box) {
    state = state.copyWith(
      boxes: [
        ...state.boxes,
        BBox(rect: box),
      ],
    );
  }

  void updateBox(int index, BBox newBox) {
    final updatedBoxes = List<BBox>.from(state.boxes);
    updatedBoxes[index] = newBox;
    state = state.copyWith(boxes: updatedBoxes);
  }

  // UPDATED: Using the new copyWith flags for null safety
  void setSelectedHandleIndex(int? index) {
    state = state.copyWith(
      selectedHandleIndex: index,
      setSelectedIndexToNull: index == null,
    );
  }

  void setSelectedImageIndex(int index) {
    _switchImage(index);
  }

  void setStartPoint(Offset? point) {
    state = state.copyWith(
      startPoint: point,
      setStartPointToNull: point == null,
    );
  }

  void setDrawingBox(Rect? box) {
    state = state.copyWith(drawingBox: box, setDrawingBoxToNull: box == null);
  }

  void removeBoxAt(int index) {
    final updatedBoxes = List<BBox>.from(state.boxes)..removeAt(index);
    state = state.copyWith(boxes: updatedBoxes);
  }

  Future<void> loadImages() async {
    const supportedExtensions = {'.jpg', '.jpeg', '.png'};
    final rawImagesDir = Directory(
      PathBuilder.rawImagesDir(projectPath: _project.path),
    );

    if (!rawImagesDir.existsSync()) return;

    final images =
        rawImagesDir
            .listSync(recursive: false)
            .whereType<File>()
            .where((file) {
              final ext = p.extension(file.path).toLowerCase();
              return supportedExtensions.contains(ext);
            })
            .map((file) => file.path)
            .toList()
          ..sort(); // Good practice to sort them

    if (images.isEmpty) {
      state = state.copyWith(images: [], boxes: []);
      return;
    }

    // NEW: Get dimensions for the first image immediately
    final firstImageSize = await _getImageSize(images[0]);
    final firstBoxes = await _jsonController.loadAnnotations(
      imagePath: images[0],
    );

    state = state.copyWith(
      images: images,
      selectedImageIndex: 0,
      boxes: firstBoxes,
      currentImageSize: firstImageSize, // <--- Store Size Here
    );
  }

  Future<void> nextImage() async {
    if (state.selectedImageIndex < state.images.length - 1) {
      await _switchImage(state.selectedImageIndex + 1);
    }
  }

  Future<void> previousImage() async {
    if (state.selectedImageIndex > 0) {
      await _switchImage(state.selectedImageIndex - 1);
    }
  }

  Future<void> _switchImage(int newIndex) async {
    final currentPath = state.currentImagePath;
    final newPath = state.images[newIndex];

    // 1. Save old
    if (currentPath.isNotEmpty) {
      _jsonController.saveAnnotations(
        imagePath: currentPath,
        boxes: state.boxes,
      );
    }

    // 2. Load new data (Boxes AND Size)
    final newBoxes = await _jsonController.loadAnnotations(imagePath: newPath);
    final newSize = await _getImageSize(newPath); // <--- Fetch new size

    // 3. Update State
    state = state.copyWith(
      selectedImageIndex: newIndex,
      boxes: newBoxes,
      currentImageSize: newSize, // <--- Update Size
      selectedHandleIndex: null,
      setSelectedIndexToNull: true,
      activeHandle: BoxHandle.none,
    );
  }

  void removeSelectedBox() {
    // Safety Check: Ensure we actually have a selection
    if (state.selectedHandleIndex != null) {
      final currentBoxes = List<BBox>.from(state.boxes);

      // Safety Check: Ensure index is valid
      if (state.selectedHandleIndex! < currentBoxes.length) {
        currentBoxes.removeAt(state.selectedHandleIndex!);

        state = state.copyWith(
          boxes: currentBoxes,
          selectedHandleIndex: null, // Deselect immediately
          setSelectedIndexToNull: true,
        );
      }
    }
  }

  void clearAllBoxes() {
    state = state.copyWith(
      boxes: [],
      selectedHandleIndex: null,
      setSelectedIndexToNull: true,
    );
  }

  void setImageSize(Size size) {
    // Only update if it's different to prevent infinite loops
    if (state.currentImageSize != size) {
      state = state.copyWith(currentImageSize: size);
    }
  }

  void addNewClass(String newClass, Project project) {
    state = state.copyWith(classes: [...state.classes, newClass]);

    final newProject = project.copyWith(classes: state.classes);
    _ref.read(dbServiceProvider).updateProject(newProject);
  }

  void removeClass(String classToRemove) {
    state = state.copyWith(classes: state.classes..remove(classToRemove));
  }
}
