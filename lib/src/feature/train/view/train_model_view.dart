import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmai_pro/src/common/widget/empty.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/project/view/project_view.dart';
import 'package:tmai_pro/src/feature/train/controller/train_config_controller.dart';
import 'package:tmai_pro/src/feature/train/widget/datset_version_selection_tile.dart';

class TrainModelView extends StatelessWidget {
  const TrainModelView({super.key, required this.project});

  final Project project;

  static const routePath = '/train-model';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Train Model')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Consumer(
            builder: (context, ref, child) {
              final trainingConfig = ref.watch(
                trainConfigControllerProvider(project),
              );

              final controller = ref.read(
                trainConfigControllerProvider(project).notifier,
              );

              return Row(
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        Text(
                          "Dataset Versions",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            if (trainingConfig.loading) {
                              return Center(
                                child: const CircularProgressIndicator(),
                              );
                            }

                            if (trainingConfig.datasets.isEmpty) {
                              return Center(
                                child: EmptyWidget(
                                  message:
                                      "No trainable dataset versions available",
                                  anActionTap: () {
                                    ref
                                        .read(fragmentIndexProvider.notifier)
                                        .update((state) => 3);
                                    context.pop();
                                  },
                                  actionText: "Create Dataset Version",
                                ),
                              );
                            }

                            return Flexible(
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  final dataset =
                                      trainingConfig.datasets[index];
                                  return DatasetVersionSelectionTile(
                                    dataset: dataset,
                                    selected:
                                        index ==
                                        trainingConfig.selectedDatasetIndex,
                                    onTap: () {
                                      controller.updateSelectedIndex(index);
                                    },
                                  );
                                },
                                padding: EdgeInsets.all(16),
                                separatorBuilder: (_, _) =>
                                    SizedBox(height: 12),
                                itemCount: trainingConfig.datasets.length,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  SizedBox(
                    width: 600,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ---------- Title ----------
                        const Text(
                          "Model Hyperparameters",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: trainingConfig.model,
                          decoration: const InputDecoration(
                            labelText: "Model",
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'yolov8n',
                              child: Text('YOLOv8n'),
                            ),
                            DropdownMenuItem(
                              value: 'yolov8s',
                              child: Text('YOLOv8s'),
                            ),
                            DropdownMenuItem(
                              value: 'yolov8m',
                              child: Text('YOLOv8m'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              controller.updateModel(value);
                            }
                          },
                        ),
                        const SizedBox(height: 12),

                        // ---------- Epochs ----------
                        TextFormField(
                          initialValue: trainingConfig.epochs.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Epochs",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            final v = int.tryParse(value);
                            if (v != null && v > 0) {
                              controller.updateEpochs(v);
                            }
                          },
                        ),

                        const SizedBox(height: 12),

                        // ---------- Batch Size ----------
                        DropdownButtonFormField<int>(
                          value: trainingConfig.batchSize,
                          decoration: const InputDecoration(
                            labelText: "Batch Size",
                            border: OutlineInputBorder(),
                          ),
                          items: const [8, 16, 32, 64]
                              .map(
                                (v) => DropdownMenuItem(
                                  value: v,
                                  child: Text(v.toString()),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.updateBatchSize(value);
                            }
                          },
                        ),

                        const SizedBox(height: 12),

                        // ---------- Learning Rate ----------
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Learning Rate: ${trainingConfig.learningRate.toStringAsFixed(4)}",
                              style: const TextStyle(fontSize: 14),
                            ),
                            Slider(
                              value: trainingConfig.learningRate,
                              min: 0.0001,
                              max: 0.01,
                              divisions: 100,
                              onChanged: controller.updateLearningRate,
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ---------- Optimizer ----------
                        DropdownButtonFormField<String>(
                          value: trainingConfig.optimizer,
                          decoration: const InputDecoration(
                            labelText: "Optimizer",
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'adam',
                              child: Text('Adam'),
                            ),
                            DropdownMenuItem(value: 'sgd', child: Text('SGD')),
                            DropdownMenuItem(
                              value: 'rmsprop',
                              child: Text('RMSProp'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              controller.updateOptimizer(value);
                            }
                          },
                        ),

                        const SizedBox(height: 12),

                        // ---------- Reset ----------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MaterialButton(
                              color: Colors.green,
                              onPressed:
                                  trainingConfig.selectedDatasetIndex > -1
                                  ? () {
                                      controller.saveTrainConfig().then((_) {
                                        // ignore: use_build_context_synchronously
                                        context.pop();
                                      });
                                    }
                                  : null,
                              child: const Text("Save Config"),
                            ),
                            SizedBox(width: 12),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.restart_alt),
                              label: const Text("Reset"),
                              onPressed: controller.reset,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
