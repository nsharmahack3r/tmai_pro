import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:tmai_pro/src/entity_models/dataset/dataset.dart';
import 'package:tmai_pro/src/entity_models/dataset/dataset_summary.dart';
import 'package:tmai_pro/src/feature/annotate/controller/summary_json_controller.dart';

class DatasetVersionSelectionTile extends ConsumerWidget {
  const DatasetVersionSelectionTile({
    super.key,
    required this.dataset,
    required this.selected,
    required this.onTap,
  });

  final Dataset dataset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DatasetSummary summary = ref
        .watch(summaryJsonControllerProvider(dataset.path))
        .getSummaryJson();

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? Colors.green : Colors.grey.shade300,
            width: selected ? 3.0 : 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Dataset Name
            Text(
              dataset.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),

            const SizedBox(height: 12),

            /// Split Ratios
            _sectionTitle("Split Ratio"),
            Row(
              children: [
                _chip("Train", summary.splits.train),
                _chip("Val", summary.splits.val),
                _chip("Test", summary.splits.test),
              ],
            ),

            const SizedBox(height: 12),

            /// Image Counts
            _sectionTitle("Images"),
            Row(
              children: [
                _countTile("Train", summary.total.train),
                _countTile("Val", summary.total.val),
                _countTile("Test", summary.total.test),
              ],
            ),

            const SizedBox(height: 12),

            /// Class-wise counts
            _sectionTitle("Classes"),
            _classCounts("Train", summary.train),
            _classCounts("Val", summary.val),
            _classCounts("Test", summary.test),

            const SizedBox(height: 12),
            Text(
              "Total Boxes: ${summary.meta.totalBoxesAllSplits}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              "Created: ${_formatDate(dataset.createdAt.toLocal())}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }

  Widget _chip(String label, double value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(label: Text("$label: ${(value * 100).toStringAsFixed(0)}%")),
    );
  }

  Widget _countTile(String label, int count) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        children: [
          Text("$label:", style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 4),
          Text(count.toString()),
        ],
      ),
    );
  }

  Widget _classCounts(String split, Map<String, int> classes) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Wrap(
        spacing: 12,
        children: classes.entries.map((entry) {
          return Text(
            "$split • ${entry.key}: ${entry.value}",
            style: const TextStyle(fontSize: 12),
          );
        }).toList(),
      ),
    );
  }

  String _formatDate(DateTime date) => intl.DateFormat.yMMMd().format(date);
}
