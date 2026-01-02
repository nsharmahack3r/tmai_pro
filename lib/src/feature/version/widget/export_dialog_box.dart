import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/feature/version/controller/dataset_export_controller.dart';
import 'package:tmai_pro/src/feature/version/state/dataset_export_state.dart';

class ExportDialogBox extends ConsumerWidget {
  const ExportDialogBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(datasetExportControllerProvider);

    return AlertDialog(
      content: Container(
        padding: const EdgeInsets.all(16.0),
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dataset Export', style: TextStyle(fontSize: 24)),
            Text(
              "Please do not close this window until the export is complete.",
            ),
            SizedBox(height: 24),
            Row(children: [Text('Status: ', style: TextStyle(fontSize: 14))]),
            SizedBox(height: 12),
            LinearProgressIndicator(value: state.progress),
            SizedBox(height: 4),
            Row(
              children: [
                Text('Progress: ', style: TextStyle(fontSize: 14)),
                Text(
                  '${(state.progress * 100).toInt()}%',
                  style: const TextStyle(fontSize: 14),
                ),
                Spacer(),
                Text(state.currentOperation),
              ],
            ),
            SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Spacer(),
                MaterialButton(
                  color: Colors.green,
                  onPressed: state.status == ExportStatus.completed
                      ? () {
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
