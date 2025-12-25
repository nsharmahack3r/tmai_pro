import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/project/fragment/annotate_fragment.dart';
import 'package:tmai_pro/src/feature/project/fragment/data_import_fragment.dart';
import 'package:tmai_pro/src/feature/project/fragment/preview_fragment.dart';
import 'package:tmai_pro/src/feature/project/fragment/version_fragment.dart';
import 'package:tmai_pro/src/feature/project/widget/project_naviation.dart';
import 'package:tmai_pro/src/services/db_services.dart';

final fragmentIndexProvider = StateProvider<int>((ref) => 0);

class ProjectView extends ConsumerWidget {
  const ProjectView({super.key, required this.projectId});

  static const routePath = "/project";

  final int projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectSteam = ref
        .read(dbServiceProvider)
        .watchProjectById(projectId);
    return StreamBuilder<Project?>(
      stream: projectSteam,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final project = snapshot.data!;
          return Scaffold(
            body: Row(
              children: [
                Expanded(flex: 1, child: ProjectNaviation(project: project)),
                Container(color: Colors.grey, width: 1),
                Consumer(
                  builder: (context, ref, child) {
                    final index = ref.watch(fragmentIndexProvider);

                    return Expanded(
                      flex: 4,
                      child: IndexedStack(
                        index: index,
                        children: [
                          DataImportFragment(project: project),
                          PreviewFragment(project: project),
                          AnnotateFragment(),
                          VersionFragment(),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Project View')),
            body: Center(child: Text('Error loading project')),
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text('Project View')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
