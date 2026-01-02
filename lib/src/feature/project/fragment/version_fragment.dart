import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmai_pro/src/common/widget/empty.dart';
import 'package:tmai_pro/src/entity_models/dataset/dataset.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/annotate/widget/annotate_summary.dart';
import 'package:tmai_pro/src/feature/project/view/project_view.dart';
import 'package:tmai_pro/src/feature/project/widget/version_list_item.dart';
import 'package:tmai_pro/src/feature/version/view/create_version.dart';
import 'package:tmai_pro/src/services/db_services.dart';
import 'package:tmai_pro/src/utils/path_builder.dart';

class VersionFragment extends StatelessWidget {
  const VersionFragment({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Versions", style: TextStyle(fontSize: 24)),
          const SizedBox(height: 12),
          // EXPANDED 1: Ensures the main container fills the available screen space
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child:
                  File(
                    PathBuilder.temporaryAnnotationJson(
                      projectPath: project.path,
                    ),
                  ).existsSync()
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 1,
                          child: AnnotationSummary(project: project),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Ready to train Dataset Versions",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () => context.push(
                                        CreateVersionPage.routePath,
                                        extra: project,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                // EXPANDED 2: Ensures the List takes remaining vertical space
                                Expanded(
                                  child: Consumer(
                                    builder: (context, ref, child) {
                                      // Use ref.watch for dependencies inside build
                                      final dbService = ref.watch(
                                        dbServiceProvider,
                                      );

                                      return StreamBuilder<List<Dataset>>(
                                        stream: dbService
                                            .watchDatasetsForProject(
                                              project.id,
                                            ),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }

                                          if (snapshot.hasError) {
                                            return Center(
                                              child: Text(
                                                'Error: ${snapshot.error}',
                                              ),
                                            );
                                          }

                                          final versions = snapshot.data ?? [];

                                          if (versions.isEmpty) {
                                            return Center(
                                              child: EmptyWidget(
                                                message:
                                                    "No versions available",
                                                anActionTap: () {
                                                  context.push(
                                                    CreateVersionPage.routePath,
                                                    extra: project,
                                                  );
                                                },
                                                actionText:
                                                    "Create new Version",
                                              ),
                                            );
                                          }

                                          return ListView.separated(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                            ),
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(height: 12),
                                            itemCount: versions.length,
                                            itemBuilder: (context, index) {
                                              return VersionListItem(
                                                dataset: versions[index],
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Consumer(
                        builder: (context, ref, child) {
                          return EmptyWidget(
                            message: "No Annotations available",
                            anActionTap: () {
                              ref
                                  .read(fragmentIndexProvider.notifier)
                                  .update((state) => 2);
                            },
                            actionText: "Annotate Images",
                          );
                        },
                      ),
                    ),
            ),
          ),
          // Bottom padding to prevent sticking to the bottom edge
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
