import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tmai_pro/src/feature/version/state/create_version_state.dart';

class AugmentationPreview extends StatelessWidget {
  const AugmentationPreview({super.key, required this.augmentations});

  final List<AugmentationStep> augmentations;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white12)),
            ),
            child: const Row(
              children: [
                Icon(Icons.visibility, color: Colors.white70, size: 16),
                SizedBox(width: 8),
                Text(
                  "Live Preview (Approximation)",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),

          // Image Area
          AspectRatio(
            aspectRatio: 1, // Square preview
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _applyAugmentations(
                    // Placeholder Image - Replace with a real sample from your controller later
                    Image.network(
                      'https://picsum.photos/400',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: Colors.grey),
                    ),
                  ),

                  // Watermark / Overlay to show "Original" vs "Augmented"
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      color: Colors.black54,
                      child: Text(
                        '${augmentations.length} Active Filters',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _applyAugmentations(Widget child) {
    Widget result = child;

    for (var aug in augmentations) {
      switch (aug.property) {
        case 'Grayscale':
          // value 1.0 = full gray
          result = ColorFiltered(
            colorFilter: ColorFilter.matrix(<double>[
              0.2126,
              0.7152,
              0.0722,
              0,
              0,
              0.2126,
              0.7152,
              0.0722,
              0,
              0,
              0.2126,
              0.7152,
              0.0722,
              0,
              0,
              0,
              0,
              0,
              1,
              0,
            ]),
            child: result,
          );
          break;
        case 'Blur':
          // value = sigma
          result = ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: aug.value, sigmaY: aug.value),
            child: result,
          );
          break;
        case 'Rotation':
          // value = degrees
          result = Transform.rotate(
            angle: aug.value * (3.14159 / 180),
            child: result,
          );
          break;
        case 'Brightness':
          // value = can be negative (darker) or positive (lighter)
          // Simple visual approximation using opacity + black/white container
          // Note: Real brightness logic is complex in Flutter, this is a hacky preview
          result = ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(aug.value.clamp(0.0, 0.5)),
              BlendMode.modulate, // This is purely illustrative
            ),
            child: result,
          );
          break;
      }
    }
    return result;
  }
}
