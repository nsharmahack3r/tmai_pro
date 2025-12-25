import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/project/view/project_view.dart';
import 'package:tmai_pro/src/feature/project/widget/project_navigation_option.dart';

class ProjectNaviation extends ConsumerWidget {
  const ProjectNaviation({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(fragmentIndexProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(Icons.arrow_back_rounded),
            ),
            Text(project.title),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(color: Colors.grey, height: 100),

              SizedBox(height: 24),

              // Data
              Text("DATA"),

              ProjectNavigationOption(
                title: "Import",
                icon: Icons.import_export,
                onTap: () {
                  ref.read(fragmentIndexProvider.notifier).update((index) => 0);
                },
                selected: selectedIndex == 0,
              ),

              ProjectNavigationOption(
                title: "Annotate",
                icon: Icons.edit_note_outlined,
                onTap: () {
                  ref.read(fragmentIndexProvider.notifier).update((index) => 1);
                },
                selected: selectedIndex == 1,
              ),
              ProjectNavigationOption(
                title: "Version",
                icon: Icons.history,
                onTap: () {
                  ref.read(fragmentIndexProvider.notifier).update((index) => 2);
                },
                selected: selectedIndex == 2,
              ),

              SizedBox(height: 24),
              // Models
              Text("MODELS"),
              ProjectNavigationOption(
                title: "Train",
                icon: Icons.model_training,
                onTap: () {
                  // TODO: handle train navigation
                },
                selected: false,
              ),
              ProjectNavigationOption(
                title: "Visualize",
                icon: Icons.pie_chart,
                onTap: () {
                  // TODO: handle visualize navigation
                },
                selected: false,
              ),
              SizedBox(height: 24),
              // Models
              Text("DEPLOY"),
            ],
          ),
        ),
      ],
    );
  }
}
