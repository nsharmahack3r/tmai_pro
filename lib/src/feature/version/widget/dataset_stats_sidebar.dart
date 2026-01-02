import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/version/controller/create_version_view_controller.dart';
// Ensure this import points to your color utility, or use the helper method below
// import 'package:tmai_pro/src/utils/color_builder.dart';

class DatasetStatsSidebar extends ConsumerWidget {
  const DatasetStatsSidebar({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createVersionViewControllerProvider(project));
    final totalImages = state.totalImages;
    final classes = state.classes;
    final classCounts = state.classCounts;

    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(right: BorderSide(color: Colors.grey.withOpacity(0.2))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header & Total Images
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dataset Overview',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSummaryCard(context, totalImages),
              ],
            ),
          ),

          const Divider(height: 1),

          // 2. Class List Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Classes & Labels',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${classes.length}',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // 3. Scrollable Class List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: classes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final className = classes[index];
                final count = classCounts[className] ?? 0;

                // Generates a consistent color based on the class name string
                final color = _generateColorForClass(className);

                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).hoverColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    leading: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    title: Text(
                      className,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        '$count',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, int totalImages) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.photo_library_outlined,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                totalImages.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Total Images',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _generateColorForClass(String label) {
    final int hash = label.hashCode;
    final double hue = (hash.abs() % 360).toDouble();
    return HSLColor.fromAHSL(1.0, hue, 0.65, 0.50).toColor();
  }
}
