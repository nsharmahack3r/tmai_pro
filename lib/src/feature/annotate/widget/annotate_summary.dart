import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/annotate/controller/annotation_preview_controller.dart';

class AnnotationSummary extends ConsumerWidget {
  const AnnotationSummary({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(annotationPreviewControllerProvider(project.path));
    final totalImages = state.imagePaths.length;
    final annotatedImages = state.annotatedImagePaths.length;
    final List<String> classes = project.classes;
    // final List<String> classes = [
    //   'class A',
    //   'class B',
    //   'class C',
    // ]; // Placeholder
    final totalBoxes = _countTotalBoxes(state.annotations);

    final progress = totalImages > 0 ? annotatedImages / totalImages : 0.0;
    final percentage = (progress * 100).toStringAsFixed(1);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Header Section ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Annotation Summary'),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getProgressColor(progress).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$percentage% Done',
                    style: TextStyle(
                      color: _getProgressColor(progress),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- Progress Bar ---
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getProgressColor(progress),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$annotatedImages of $totalImages images annotated',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 24),

            // --- Stats Row ---
            Row(
              children: [
                _StatItem(
                  label: 'Total Boxes',
                  value: totalBoxes.toString(),
                  icon: Icons.grid_on_rounded,
                  color: Colors.blueAccent,
                  trailing: const SizedBox.shrink(),
                ),
                const SizedBox(width: 24),
                _StatItem(
                  label: 'Total Classes',
                  value: classes.length.toString(),
                  icon: Icons.category_rounded,
                  color: Colors.orangeAccent,
                  trailing: const SizedBox.shrink(),
                ),
              ],
            ),

            // --- Class List Section ---
            if (classes.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'Class Map',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Using Column instead of ListView to avoid nested scrolling issues
              Column(
                children: List.generate(classes.length, (index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: index != classes.length - 1
                          ? Border(
                              bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.1),
                              ),
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        // ID Badge
                        Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$index',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Class Name
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                classes[index],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                ' ${_countBoxForClass(state.annotations, classes[index])}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 1.0) return Colors.green;
    if (progress >= 0.5) return Colors.blue;
    return Colors.orange;
  }

  int _countTotalBoxes(Map<String, dynamic> annotations) {
    int totalBoxes = 0;
    annotations.forEach((key, value) {
      if (value is List) {
        totalBoxes += value.length;
      }
    });
    return totalBoxes;
  }

  int _countBoxForClass(Map<String, dynamic> annotations, String className) {
    int totalBoxes = 0;
    annotations.forEach((key, value) {
      if (value is List) {
        totalBoxes += value.where((b) => b["className"] == className).length;
      }
    });
    return totalBoxes;
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Widget trailing;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing,
      ],
    );
  }
}
