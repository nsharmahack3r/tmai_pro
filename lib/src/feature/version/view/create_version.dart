import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/version/controller/create_version_view_controller.dart';
import 'package:tmai_pro/src/feature/version/controller/dataset_export_controller.dart';
import 'package:tmai_pro/src/feature/version/widget/augmentation_section.dart';
import 'package:tmai_pro/src/feature/version/widget/dataset_stats_sidebar.dart';
import 'package:tmai_pro/src/feature/version/widget/export_dialog_box.dart';
import 'package:tmai_pro/src/feature/version/widget/split_section.dart';

class CreateVersionPage extends ConsumerWidget {
  const CreateVersionPage({super.key, required this.project});

  static const routePath = '/create-version';
  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${project.title} Create Version'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: FilledButton.icon(
              onPressed: () {
                /* Handle Submit */

                final createVersionState = ref.read(
                  createVersionViewControllerProvider(project),
                );

                ref
                    .read(datasetExportControllerProvider.notifier)
                    .exportDataset(
                      project: project,
                      config: createVersionState,
                    );
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return const ExportDialogBox();
                  },
                );
              },
              icon: const Icon(Icons.rocket_launch, size: 18),
              label: const Text("Create Version"),
            ),
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DatasetStatsSidebar(project: project),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SplitSection(project: project),
                  const SizedBox(height: 48),
                  const Divider(),
                  const SizedBox(height: 32),
                  AugmentationSection(project: project),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
