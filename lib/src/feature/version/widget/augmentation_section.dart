import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/version/controller/create_version_view_controller.dart';
import 'package:tmai_pro/src/feature/version/state/create_version_state.dart';
import 'package:tmai_pro/src/feature/version/widget/augementation_card.dart';

class AugmentationSection extends ConsumerWidget {
  const AugmentationSection({super.key, required this.project});

  final Project project;

  // Configuration for defaults
  static final Map<String, double> _defaults = {
    'Grayscale': 1.0,
    'Blur': 1.5,
    'Brightness': 0.2,
    'Rotation': 15.0,
    'Sepia': 1.0,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = createVersionViewControllerProvider(project);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Header Section ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Preprocessing & Augmentations',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Chain of processing steps applied to training data.',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            _buildAddButton(context, controller),
          ],
        ),
        const SizedBox(height: 24),

        // --- List of Cards ---
        if (state.augmentations.isEmpty)
          _buildEmptyState()
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.augmentations.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return AugmentationCard(
                step: state.augmentations[index],
                index: index,
                onRemove: () => controller.removeAugmentation(index),
                onUpdate: (newValue) {
                  // Logic to update the specific item without removing it
                  // Ideally, your controller should have an updateAugmentation(index, value)
                  // For now, we reuse the add/remove pattern or you can add that method.
                  controller.removeAugmentation(index);
                  controller.addAugmentation(
                    AugmentationStep(
                      state.augmentations[index].property,
                      newValue,
                    ),
                  );
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildAddButton(
    BuildContext context,
    CreateVersionViewController controller,
  ) {
    return PopupMenuButton<String>(
      onSelected: (key) {
        controller.addAugmentation(AugmentationStep(key, _defaults[key]!));
      },
      itemBuilder: (context) {
        return _defaults.keys.map((key) {
          return PopupMenuItem(value: key, child: Text(key));
        }).toList();
      },
      child: Chip(
        avatar: const Icon(Icons.add, size: 18),
        label: const Text('Add Step'),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        side: BorderSide.none,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.withOpacity(0.05),
      ),
      child: Column(
        children: [
          Icon(Icons.auto_fix_off_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            "No augmentations applied",
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Images will be trained exactly as they were annotated.",
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
