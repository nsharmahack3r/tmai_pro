import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tmai_pro/src/entity_models/trained_model/train.dart';
import 'package:tmai_pro/src/feature/train/view/train_monitoring_view.dart';

class TrainableConfigTile extends StatelessWidget {
  const TrainableConfigTile({super.key, required this.modelConfig});

  final TrainModel modelConfig;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Name and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        modelConfig.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'ID: ${modelConfig.modelId}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(status: modelConfig.status),
              ],
            ),
            const Divider(height: 24),

            // Hyperparameters Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ParamInfo(
                  label: 'Epochs',
                  value: modelConfig.epochs.toString(),
                ),
                _ParamInfo(
                  label: 'Batch',
                  value: modelConfig.batchSize.toString(),
                ),
                _ParamInfo(
                  label: 'L. Rate',
                  value: modelConfig.learningRate.toString(),
                ),
                _ParamInfo(label: 'Optim', value: modelConfig.optimizer),
              ],
            ),

            const SizedBox(height: 12),

            // Footer: Dataset Path (shortened)
            Row(
              children: [
                const Icon(Icons.folder_open, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    modelConfig.datasetPath,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                MaterialButton(
                  onPressed: modelConfig.status == TrainingStatus.ready
                      ? () {
                          context.push(
                            TrainingMonitorView.routePath,
                            extra: modelConfig,
                          );
                        }
                      : null,
                  color: Colors.green,
                  child: const Text('Train'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widget for displaying parameters compactly
class _ParamInfo extends StatelessWidget {
  final String label;
  final String value;

  const _ParamInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}

// Helper widget for status visualization
class _StatusBadge extends StatelessWidget {
  final TrainingStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    String text;

    switch (status) {
      case TrainingStatus.ready:
        color = Colors.blue;
        icon = Icons.schedule;
        text = 'Ready';
        break;
      case TrainingStatus.complete:
        color = Colors.green;
        icon = Icons.check_circle_outline;
        text = 'Done';
        break;
      case TrainingStatus.error:
        color = Colors.red;
        icon = Icons.error_outline;
        text = 'Error';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
