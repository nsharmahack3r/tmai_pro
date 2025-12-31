import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:tmai_pro/src/feature/project/widget/preview_box_painer.dart';

class AnnotatorThumbnail extends StatelessWidget {
  const AnnotatorThumbnail({
    super.key,
    required this.imagePath,
    required this.annotations,
    required this.onTap,
    required this.selected,
  });

  final String imagePath;
  final Map<String, dynamic> annotations;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final List boxes = annotations[imagePath] ?? [];

    return InkWell(
      onTap: onTap,
      child: FutureBuilder<ui.Image>(
        future: _loadImage(File(imagePath)),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final ui.Image image = snapshot.data!;

          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: selected ? Colors.blue : Colors.grey,
                width: selected ? 3.0 : 1.0,
              ),
            ),
            width: 200,
            height: 200,
            child: Stack(
              children: [
                Center(child: Image.file(File(imagePath), fit: BoxFit.contain)),
                CustomPaint(
                  size: Size(200, 200),
                  painter: PreviewBoxPainter(
                    boxes: boxes,
                    imageWidth: image.width.toDouble(),
                    imageHeight: image.height.toDouble(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<ui.Image> _loadImage(File file) async {
    final data = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(data);
    final frame = await codec.getNextFrame();
    return frame.image;
  }
}
