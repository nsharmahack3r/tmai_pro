import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tmai_pro/src/feature/version/state/create_version_state.dart';

class AugmentationCard extends StatelessWidget {
  const AugmentationCard({
    super.key,
    required this.step,
    required this.index,
    required this.onRemove,
    required this.onUpdate,
  });

  final AugmentationStep step;
  final int index;
  final VoidCallback onRemove;
  final ValueChanged<double> onUpdate;

  // Config mapping for Slider constraints
  static final Map<String, ({double min, double max})> _config = {
    'Grayscale': (min: 0.0, max: 1.0),
    'Blur': (min: 0.0, max: 10.0),
    'Brightness': (min: 0.0, max: 1.0), // 0=normal, 1=bright
    'Rotation': (min: 0.0, max: 180.0),
    'Sepia': (min: 0.0, max: 1.0),
  };

  @override
  Widget build(BuildContext context) {
    final constraints = _config[step.property] ?? (min: 0.0, max: 1.0);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Left Side: Controls ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getIconForType(step.property),
                          size: 18,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        step.property,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Intensity',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        step.value.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8,
                      ),
                    ),
                    child: Slider(
                      value: step.value.clamp(constraints.min, constraints.max),
                      min: constraints.min,
                      max: constraints.max,
                      activeColor: Colors.blueGrey,
                      inactiveColor: Colors.blueGrey.withOpacity(0.2),
                      onChanged: onUpdate,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- Vertical Divider ---
          Container(
            width: 1,
            height: 140, // Fixed height for consistency
            color: Colors.grey.withOpacity(0.1),
          ),

          // --- Right Side: Preview ---
          Container(
            width: 140,
            height: 140,
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // The Preview Logic
                        _buildPreviewImage(step),

                        // "Preview" Badge
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            color: Colors.black.withOpacity(0.6),
                            child: const Text(
                              "Preview",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: onRemove,
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete, size: 14, color: Colors.red[400]),
                        const SizedBox(width: 4),
                        Text(
                          "Remove",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.red[400],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Applies the specific filter visually using Flutter widgets
  Widget _buildPreviewImage(AugmentationStep step) {
    // Placeholder image
    Widget image = Image.network(
      'https://picsum.photos/200',
      fit: BoxFit.cover,
      errorBuilder: (c, o, s) => Container(color: Colors.grey[300]),
    );

    switch (step.property) {
      case 'Grayscale':
        return ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
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
          child: image,
        );

      case 'Sepia':
        return ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
            0.393,
            0.769,
            0.189,
            0,
            0,
            0.349,
            0.686,
            0.168,
            0,
            0,
            0.272,
            0.534,
            0.131,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
          ]),
          child: image,
        );

      case 'Blur':
        return ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: step.value, sigmaY: step.value),
          child: image,
        );

      case 'Rotation':
        return Transform.rotate(
          angle: step.value * (3.14159 / 180),
          child: image,
        );

      case 'Brightness':
        // Simulating brightness with opacity overlay
        return Stack(
          fit: StackFit.expand,
          children: [
            image,
            Container(color: Colors.white.withOpacity(step.value * 0.5)),
          ],
        );

      default:
        return image;
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Grayscale':
        return Icons.contrast;
      case 'Blur':
        return Icons.blur_on;
      case 'Rotation':
        return Icons.rotate_right;
      case 'Brightness':
        return Icons.light_mode;
      default:
        return Icons.auto_fix_high;
    }
  }
}
