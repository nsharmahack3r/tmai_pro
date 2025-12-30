import 'package:flutter/material.dart';

// 1. Add this Enum to track which part of the box is being interacted with
enum BoxHandle { topLeft, topRight, bottomLeft, bottomRight, none }

class AnnotateView extends StatefulWidget {
  const AnnotateView({super.key});

  static const routePath = '/annotate';

  @override
  State<AnnotateView> createState() => _AnnotateViewState();
}

class _AnnotateViewState extends State<AnnotateView> {
  // Store completed boxes
  final List<Rect> _boxes = [];

  // Selection & Resizing State
  int? _selectedIndex; // Index of the currently selected box
  BoxHandle _activeHandle = BoxHandle.none; // Which corner is being dragged
  final double _handleSize = 12.0; // Size of the resizing corner circles

  // Drawing New Box State
  Rect? _drawingBox; // The temporary box being drawn
  Offset? _startPoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bounding Box Editor'),
        actions: [
          IconButton(
            // Change icon based on context (Delete specific vs Clear all)
            icon: Icon(
              _selectedIndex != null ? Icons.delete : Icons.delete_sweep,
            ),
            tooltip: _selectedIndex != null ? 'Delete Selected' : 'Clear All',
            onPressed: () {
              setState(() {
                if (_selectedIndex != null) {
                  // Delete only the selected box
                  _boxes.removeAt(_selectedIndex!);
                  _selectedIndex = null;
                } else {
                  // Clear everything
                  _boxes.clear();
                }
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text(
                "Click empty space to draw. Click a box to select & resize.",
              ),
              const SizedBox(height: 10),

              // EXPANDED AREA FOR DRAWING
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onPanStart: (details) => _onPanStart(details),
                      onPanUpdate: (details) => _onPanUpdate(details),
                      onPanEnd: (details) => _onPanEnd(details),
                      child: Container(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        color: Colors.grey[200], // Placeholder for an Image
                        child: CustomPaint(
                          painter: BoundingBoxPainter(
                            boxes: _boxes,
                            drawingBox: _drawingBox,
                            selectedIndex: _selectedIndex,
                            handleSize: _handleSize,
                          ),
                          size: Size.infinite,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // FOOTER INFO
              const SizedBox(height: 10),
              Text("Total Boxes: ${_boxes.length}"),
            ],
          ),
        ),
      ),
    );
  }

  /// ----------------------------------------------------------------------
  /// INTERACTION LOGIC
  /// ----------------------------------------------------------------------

  void _onPanStart(DragStartDetails details) {
    final pos = details.localPosition;

    // 1. Check if we clicked a resize handle of the SELECTED box
    if (_selectedIndex != null) {
      final handle = _getHandleAtPoint(_boxes[_selectedIndex!], pos);
      if (handle != BoxHandle.none) {
        setState(() {
          _activeHandle = handle;
        });
        return; // Stop here, we are resizing
      }
    }

    // 2. Check if we clicked inside an EXISTING box (to select it)
    bool foundBox = false;
    // Iterate backwards to check top-most boxes first
    for (int i = _boxes.length - 1; i >= 0; i--) {
      if (_boxes[i].contains(pos)) {
        setState(() {
          _selectedIndex = i;
          _activeHandle = BoxHandle.none; // Just selecting, not resizing
        });
        foundBox = true;
        break;
      }
    }

    // 3. If no handle and no box clicked, start drawing a NEW box
    if (!foundBox) {
      setState(() {
        _selectedIndex = null; // Deselect current
        _startPoint = pos;
        _drawingBox = Rect.fromPoints(pos, pos);
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final pos = details.localPosition;

    setState(() {
      // CASE A: Resizing an existing box
      if (_selectedIndex != null && _activeHandle != BoxHandle.none) {
        final currentRect = _boxes[_selectedIndex!];
        Rect newRect = currentRect;

        // Use the opposite corner as the anchor point
        switch (_activeHandle) {
          case BoxHandle.topLeft:
            newRect = Rect.fromPoints(pos, currentRect.bottomRight);
            break;
          case BoxHandle.topRight:
            newRect = Rect.fromPoints(currentRect.bottomLeft, pos);
            break;
          case BoxHandle.bottomLeft:
            newRect = Rect.fromPoints(pos, currentRect.topRight);
            break;
          case BoxHandle.bottomRight:
            newRect = Rect.fromPoints(currentRect.topLeft, pos);
            break;
          case BoxHandle.none:
            break;
        }
        _boxes[_selectedIndex!] = newRect;
      }
      // CASE B: Drawing a new box
      else if (_drawingBox != null && _startPoint != null) {
        _drawingBox = Rect.fromPoints(_startPoint!, pos);
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      // If we were drawing a new box, commit it to the list
      if (_drawingBox != null) {
        _boxes.add(_drawingBox!);
        _selectedIndex = _boxes.length - 1; // Auto-select the new box
        _drawingBox = null;
        _startPoint = null;
      }
      // Stop resizing
      _activeHandle = BoxHandle.none;
    });
  }

  // Detect if the mouse click is near a corner of the rect
  BoxHandle _getHandleAtPoint(Rect rect, Offset point) {
    final double radius = _handleSize; // Sensitivity area
    if ((point - rect.topLeft).distance <= radius) return BoxHandle.topLeft;
    if ((point - rect.topRight).distance <= radius) return BoxHandle.topRight;
    if ((point - rect.bottomLeft).distance <= radius)
      return BoxHandle.bottomLeft;
    if ((point - rect.bottomRight).distance <= radius)
      return BoxHandle.bottomRight;
    return BoxHandle.none;
  }
}

/// ----------------------------------------------------------------------
/// CUSTOM PAINTER
/// ----------------------------------------------------------------------

class BoundingBoxPainter extends CustomPainter {
  final List<Rect> boxes;
  final Rect? drawingBox; // The box currently being created
  final int? selectedIndex; // Index of the selected box (for green styling)
  final double handleSize;

  BoundingBoxPainter({
    required this.boxes,
    this.drawingBox,
    this.selectedIndex,
    required this.handleSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Define Paints
    final Paint standardPaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Paint selectedPaint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final Paint handlePaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    // 2. Draw existing boxes
    for (int i = 0; i < boxes.length; i++) {
      final rect = boxes[i];
      final bool isSelected = (i == selectedIndex);

      // Draw the Rect
      canvas.drawRect(rect, isSelected ? selectedPaint : standardPaint);

      // Optional: Draw fill
      canvas.drawRect(
        rect,
        Paint()
          ..color = (isSelected ? Colors.green : Colors.blue).withOpacity(0.1),
      );

      // Draw Resize Handles (if selected)
      if (isSelected) {
        _drawHandles(canvas, rect, handlePaint);
      }
    }

    // 3. Draw the active "drawing" box (Red)
    if (drawingBox != null) {
      canvas.drawRect(
        drawingBox!,
        Paint()
          ..color = Colors.redAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );
    }
  }

  void _drawHandles(Canvas canvas, Rect rect, Paint paint) {
    final double r = handleSize / 2;
    canvas.drawCircle(rect.topLeft, r, paint);
    canvas.drawCircle(rect.topRight, r, paint);
    canvas.drawCircle(rect.bottomLeft, r, paint);
    canvas.drawCircle(rect.bottomRight, r, paint);
  }

  @override
  bool shouldRepaint(covariant BoundingBoxPainter oldDelegate) {
    return true;
  }
}
