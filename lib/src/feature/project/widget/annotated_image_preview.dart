import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:tmai_pro/src/feature/project/widget/preview_box_painer.dart';

class AnnotatedImagePreview extends StatelessWidget {
  const AnnotatedImagePreview({
    super.key,
    required this.imagePath,
    required this.annotations,
    required this.onClose,
  });

  final String imagePath;
  final Map<String, dynamic> annotations;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final List boxes = annotations[imagePath] ?? [];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Selected Image Details",
                style: TextStyle(fontSize: 16),
              ),
              const Spacer(),
              IconButton(icon: const Icon(Icons.close), onPressed: onClose),
            ],
          ),

          const SizedBox(height: 8),

          Expanded(
            child: FutureBuilder<ui.Image>(
              future: _loadImage(File(imagePath)),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final ui.Image image = snapshot.data!;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        Center(
                          child: Image.file(
                            File(imagePath),
                            fit: BoxFit.contain,
                          ),
                        ),

                        CustomPaint(
                          size: Size(
                            constraints.maxWidth,
                            constraints.maxHeight,
                          ),
                          painter: PreviewBoxPainter(
                            boxes: boxes,
                            imageWidth: image.width.toDouble(),
                            imageHeight: image.height.toDouble(),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 8),
          Text("Image Path: $imagePath"),
          Text("Annotations: ${boxes.length}"),
        ],
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
