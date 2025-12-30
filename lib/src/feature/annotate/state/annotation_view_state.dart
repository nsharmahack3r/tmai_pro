import 'dart:ui';
import 'package:tmai_pro/src/entity_models/enums/box_handle.dart';

class AnnotationViewState {
  final List<String> images;

  // CHANGED: Track index instead of path string
  final int selectedImageIndex;

  final List<Rect> boxes;
  final int? selectedHandleIndex;
  final BoxHandle activeHandle;

  // Temporary drawing state
  final Rect? drawingBox;
  final Offset? startPoint;
  final Size? currentImageSize;

  AnnotationViewState({
    required this.images,
    required this.selectedImageIndex,
    required this.boxes,
    this.selectedHandleIndex,
    this.activeHandle = BoxHandle.none,
    this.drawingBox,
    this.startPoint,
    this.currentImageSize,
  });

  // HELPER GETTER: safely get the current path
  String get currentImagePath {
    if (images.isNotEmpty &&
        selectedImageIndex >= 0 &&
        selectedImageIndex < images.length) {
      return images[selectedImageIndex];
    }
    return '';
  }

  // INITIAL STATE FACTORY
  factory AnnotationViewState.initial() {
    return AnnotationViewState(
      images: [],
      selectedImageIndex: 0, // Default to 0
      boxes: [],
      selectedHandleIndex: null,
      activeHandle: BoxHandle.none,
      drawingBox: null,
      startPoint: null,
    );
  }

  // STANDARD COPYWITH
  AnnotationViewState copyWith({
    List<String>? images,
    int? selectedImageIndex, // CHANGED
    List<Rect>? boxes,
    int? selectedHandleIndex,
    BoxHandle? activeHandle,
    Rect? drawingBox,
    Offset? startPoint,
    // Helper to allow setting nullable fields to null
    bool setSelectedIndexToNull = false,
    bool setDrawingBoxToNull = false,
    bool setStartPointToNull = false,
    Size? currentImageSize,
  }) {
    return AnnotationViewState(
      images: images ?? this.images,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
      boxes: boxes ?? this.boxes,
      // If force null is true, use null. Else use new value. If new value is null, use old value.
      selectedHandleIndex: setSelectedIndexToNull
          ? null
          : (selectedHandleIndex ?? this.selectedHandleIndex),
      activeHandle: activeHandle ?? this.activeHandle,
      drawingBox: setDrawingBoxToNull ? null : (drawingBox ?? this.drawingBox),
      startPoint: setStartPointToNull ? null : (startPoint ?? this.startPoint),
      currentImageSize: currentImageSize ?? this.currentImageSize,
    );
  }
}
