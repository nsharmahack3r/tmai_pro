// annotate_view.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/entity_models/enums/box_handle.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/annotate/controller/annotate_view_controller.dart';
import 'package:tmai_pro/src/feature/annotate/controller/annotation_preview_controller.dart';
import 'package:tmai_pro/src/feature/annotate/state/annotation_view_state.dart';
import 'package:tmai_pro/src/feature/annotate/widget/annotate_view_navigator.dart';
import 'package:tmai_pro/src/feature/annotate/widget/annotation_tool_widget.dart';
import 'package:tmai_pro/src/feature/annotate/widget/bounding_box_painter.dart';

class AnnotateView extends ConsumerStatefulWidget {
  const AnnotateView({super.key, required this.project});

  static const routePath = '/annotate';
  final Project project;

  @override
  ConsumerState<AnnotateView> createState() => _AnnotateViewState();
}

class _AnnotateViewState extends ConsumerState<AnnotateView> {
  // Config constant
  final double _handleSize = 12.0;

  @override
  Widget build(BuildContext context) {
    // 1. WATCH the state to rebuild when boxes change
    final state = ref.watch(annotateViewControllerProvider(widget.project));

    // 2. READ the controller to call methods (prevent unnecessary rebuilds)
    final controller = ref.read(
      annotateViewControllerProvider(widget.project).notifier,
    );

    return PopScope(
      onPopInvokedWithResult: (willpop, _) async {
        ref
            .read(
              annotationPreviewControllerProvider(widget.project.path).notifier,
            )
            .reload();
        controller.saveCurrnetImage();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Bounding Box Editor')),
        body: Row(
          children: [
            // -----------------------------------------------------------
            // LEFT SIDE: Drawing Area (Expanded)
            // -----------------------------------------------------------
            SizedBox(
              width: 200,
              child: ThumbnailViewNavigator(project: widget.project),
            ),
            Expanded(
              child: Container(
                color: Colors.grey[50], // Background for the drawing area
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      "Click empty space to draw. Click a box to select & resize.",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),

                    // THE CANVAS
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // 1. If no image is loaded, show placeholder
                          if (state.currentImagePath.isEmpty) {
                            return const Center(child: Text("No images found"));
                          }

                          // 2. Load the file
                          final imageFile = File(state.currentImagePath);

                          return Center(
                            child: Image.file(
                              imageFile,
                              fit: BoxFit.contain,
                              // CHANGED: Back to frameBuilder (loadingBuilder is not supported for Files)
                              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                // Check if image is ready (frame is not null)
                                if (wasSynchronouslyLoaded || frame != null) {
                                  return Stack(
                                    children: [
                                      // Layer A: The actual Image
                                      child,

                                      // Layer B: The Transparent Drawing Canvas
                                      Positioned.fill(
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            // 1. Wait for controller to load dimensions
                                            if (state.currentImageSize ==
                                                null) {
                                              return const SizedBox();
                                            }

                                            // 2. Calculate Scale
                                            final double scale =
                                                constraints.maxWidth /
                                                state.currentImageSize!.width;

                                            final imageSize = Size(
                                              constraints.maxWidth,
                                              constraints.maxHeight,
                                            );

                                            return GestureDetector(
                                              onPanStart: (details) =>
                                                  _onPanStart(
                                                    details,
                                                    controller,
                                                    state,
                                                    scale,
                                                  ),
                                              onPanUpdate: (details) =>
                                                  _onPanUpdate(
                                                    details,
                                                    controller,
                                                    state,
                                                    imageSize,
                                                    scale,
                                                  ),
                                              onPanEnd: (details) => _onPanEnd(
                                                details,
                                                controller,
                                                state,
                                                scale,
                                              ),
                                              child: CustomPaint(
                                                painter: BoundingBoxPainter(
                                                  boxes: state.boxes,
                                                  drawingBox: state.drawingBox,
                                                  selectedIndex:
                                                      state.selectedHandleIndex,
                                                  handleSize: _handleSize,
                                                  scale: scale,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                // Show loader while waiting for the first frame
                                return const CircularProgressIndicator();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnnotationToolWidget(project: widget.project),
          ],
        ),
      ),
    );
  }

  void _onPanStart(
    DragStartDetails details,
    AnnotateViewController controller,
    AnnotationViewState state,
    double scale,
  ) {
    // Convert Screen Pixel -> Image Pixel
    final pos = details.localPosition / scale;

    if (state.selectedHandleIndex != null) {
      // Check handles using the unscaled stored box vs unscaled pos
      final handle = _getHandleAtPoint(
        state.boxes[state.selectedHandleIndex!].rect,
        pos,
        scale,
      );
      if (handle != BoxHandle.none) {
        controller.setBoxHandle(handle);
        return;
      }
    }

    bool foundBox = false;
    for (int i = state.boxes.length - 1; i >= 0; i--) {
      if (state.boxes[i].rect.contains(pos)) {
        controller.setSelectedHandleIndex(i);
        controller.setBoxHandle(BoxHandle.none);
        foundBox = true;
        break;
      }
    }

    if (!foundBox) {
      controller.setSelectedHandleIndex(null);
      controller.setStartPoint(pos);
      controller.setDrawingBox(Rect.fromPoints(pos, pos));
    }
  }

  void _onPanUpdate(
    DragUpdateDetails details,
    AnnotateViewController controller,
    AnnotationViewState state,
    Size limits,
    double scale,
  ) {
    // 1. Clamp to Screen Limits first
    final double dx = details.localPosition.dx.clamp(0.0, limits.width);
    final double dy = details.localPosition.dy.clamp(0.0, limits.height);

    // 2. Convert Clamped Screen Pixel -> Image Pixel
    final clampedPos = Offset(dx, dy) / scale;

    if (state.selectedHandleIndex != null &&
        state.activeHandle != BoxHandle.none) {
      final currentRect = state.boxes[state.selectedHandleIndex!].rect;
      Rect newRect = currentRect;

      switch (state.activeHandle) {
        case BoxHandle.topLeft:
          newRect = Rect.fromPoints(clampedPos, currentRect.bottomRight);
          break;
        case BoxHandle.topRight:
          newRect = Rect.fromPoints(currentRect.bottomLeft, clampedPos);
          break;
        case BoxHandle.bottomLeft:
          newRect = Rect.fromPoints(clampedPos, currentRect.topRight);
          break;
        case BoxHandle.bottomRight:
          newRect = Rect.fromPoints(currentRect.topLeft, clampedPos);
          break;
        case BoxHandle.none:
          break;
      }
      controller.updateBox(
        state.selectedHandleIndex!,
        state.boxes[state.selectedHandleIndex!].copyWith(rect: newRect),
      );
    } else if (state.drawingBox != null && state.startPoint != null) {
      // Use the clampedPos for the end point of the drawing box
      controller.setDrawingBox(Rect.fromPoints(state.startPoint!, clampedPos));
    }
  }

  void _onPanEnd(
    DragEndDetails details,
    AnnotateViewController controller,
    AnnotationViewState state,
    double scale,
  ) {
    if (state.drawingBox != null) {
      // DEFINITION: Minimum allowed size on SCREEN (in pixels)
      const double minScreenSize = 5.0;

      // 2. Calculate the visual size on screen
      final double screenWidth = state.drawingBox!.width * scale;
      final double screenHeight = state.drawingBox!.height * scale;

      // CHECK: Is the box visually large enough?
      if (screenWidth >= minScreenSize && screenHeight >= minScreenSize) {
        controller.addBox(state.drawingBox!);
        // Auto-select the newly created box
        // Note: state.boxes here is the OLD list. The new index will be length of current list.
        controller.setSelectedHandleIndex(state.boxes.length);
      }

      controller.setDrawingBox(null);
      controller.setStartPoint(null);
    }

    controller.setBoxHandle(BoxHandle.none);
  }

  BoxHandle _getHandleAtPoint(Rect rect, Offset point, double scale) {
    // We must adjust the hit radius.
    // If the image is zoomed out (small scale), a 12px screen handle covers MORE image pixels.
    final double effectiveRadius = _handleSize / scale;

    if ((point - rect.topLeft).distance <= effectiveRadius) {
      return BoxHandle.topLeft;
    }
    if ((point - rect.topRight).distance <= effectiveRadius) {
      return BoxHandle.topRight;
    }
    if ((point - rect.bottomLeft).distance <= effectiveRadius) {
      return BoxHandle.bottomLeft;
    }
    if ((point - rect.bottomRight).distance <= effectiveRadius) {
      return BoxHandle.bottomRight;
    }

    return BoxHandle.none;
  }
}
