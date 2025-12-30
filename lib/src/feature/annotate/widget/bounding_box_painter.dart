import 'package:flutter/material.dart';

class BoundingBoxPainter extends CustomPainter {
  final List<Rect> boxes;
  final Rect? drawingBox; // The box currently being created
  final int? selectedIndex; // Index of the selected box (for green styling)
  final double handleSize;
  final double scale;

  BoundingBoxPainter({
    required this.boxes,
    this.drawingBox,
    this.selectedIndex,
    required this.handleSize,
    required this.scale,
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

    // HELPER: Transform Image Coordinates -> Screen Coordinates
    Rect scaleRect(Rect r) {
      return Rect.fromLTRB(
        r.left * scale,
        r.top * scale,
        r.right * scale,
        r.bottom * scale,
      );
    }

    // 2. Draw existing boxes
    for (int i = 0; i < boxes.length; i++) {
      // Scale the stored box to match the current screen size
      final rect = scaleRect(boxes[i]);
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
        // We pass the ALREADY SCALED rect here, so handles draw at screen positions
        _drawHandles(canvas, rect, handlePaint);
      }
    }

    // 3. Draw the active "drawing" box (Red)
    if (drawingBox != null) {
      canvas.drawRect(
        scaleRect(drawingBox!), // Scale this one too
        Paint()
          ..color = Colors.redAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );
    }
  }

  void _drawHandles(Canvas canvas, Rect rect, Paint paint) {
    // The handle size remains fixed on the screen (does not scale with the image)
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
