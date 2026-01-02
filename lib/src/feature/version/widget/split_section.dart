import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/version/controller/create_version_view_controller.dart';

class SplitSection extends ConsumerWidget {
  const SplitSection({super.key, required this.project});
  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = createVersionViewControllerProvider(project);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Train / Validation / Test Split',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Define data distribution.',
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),

        // Visual Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 12,
            child: Row(
              children: [
                Expanded(
                  flex: (state.trainSplit * 100).toInt(),
                  child: Container(color: Colors.blue),
                ),
                Expanded(
                  flex: (state.valSplit * 100).toInt(),
                  child: Container(color: Colors.purple),
                ),
                Expanded(
                  flex: (state.testSplit * 100).toInt(),
                  child: Container(color: Colors.orange),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Controls
        Row(
          children: [
            Expanded(
              child: _SplitSlider(
                label: 'Train Set',
                color: Colors.blue,
                value: state.trainSplit,
                onChanged: controller.setTrainSplit,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SplitDisplay(
                label: 'Validation',
                color: Colors.purple,
                value: state.valSplit,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SplitDisplay(
                label: 'Test Set',
                color: Colors.orange,
                value: state.testSplit,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SplitSlider extends StatelessWidget {
  final String label;
  final Color color;
  final double value;
  final ValueChanged<double> onChanged;
  const _SplitSlider({
    required this.label,
    required this.color,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: 1.0,
          activeColor: color,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _SplitDisplay extends StatelessWidget {
  final String label;
  final Color color;
  final double value;
  const _SplitDisplay({
    required this.label,
    required this.color,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: LinearProgressIndicator(
            value: value,
            color: color,
            backgroundColor: Colors.grey[200],
          ),
        ),
      ],
    );
  }
}
