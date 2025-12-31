import 'package:flutter/material.dart';

class PreviewBoxPainter extends CustomPainter {
  PreviewBoxPainter({
    required this.boxes,
    required this.imageWidth,
    required this.imageHeight,
  });

  final List boxes;
  final double imageWidth;
  final double imageHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Scale to fit (BoxFit.contain math)
    final scale = _getScale(size);
    final offset = _getOffset(size, scale);

    for (final box in boxes) {
      final rect = Rect.fromLTWH(
        offset.dx + (box["x"] as num).toDouble() * scale,
        offset.dy + (box["y"] as num).toDouble() * scale,
        (box["width"] as num).toDouble() * scale,
        (box["height"] as num).toDouble() * scale,
      );

      canvas.drawRect(rect, paint);
    }
  }

  double _getScale(Size size) {
    final scaleX = size.width / imageWidth;
    final scaleY = size.height / imageHeight;
    return scaleX < scaleY ? scaleX : scaleY;
  }

  Offset _getOffset(Size size, double scale) {
    final displayWidth = imageWidth * scale;
    final displayHeight = imageHeight * scale;

    final dx = (size.width - displayWidth) / 2;
    final dy = (size.height - displayHeight) / 2;

    return Offset(dx, dy);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
