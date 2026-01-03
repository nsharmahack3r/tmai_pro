import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmai_pro/src/common/widget/empty.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/train/view/train_model_view.dart';
import 'package:tmai_pro/src/services/db_services.dart';

class TrainFragment extends StatelessWidget {
  const TrainFragment({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Train", style: TextStyle(fontSize: 24)),
          const SizedBox(height: 12),
          // EXPANDED 1: Ensures the main container fills the available screen space
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Consumer(
                builder: (context, ref, child) {
                  final trainedModelsStream = ref
                      .read(dbServiceProvider)
                      .watchModelsForProject(project.id);

                  return StreamBuilder(
                    stream: trainedModelsStream,
                    builder: (context, snapshot) {
                      final models = snapshot.data ?? [];
                      if (models.isEmpty) {
                        return Center(
                          child: EmptyWidget(
                            message: "No trained Models Available",
                            anActionTap: () {
                              context.push(
                                TrainModelView.routePath,
                                extra: project,
                              );
                            },
                            actionText: "Train Model",
                          ),
                        );
                      }
                      return Container();
                      // return ListView.separated(itemBuilder: , separatorBuilder: separatorBuilder, itemCount: itemCount)
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
