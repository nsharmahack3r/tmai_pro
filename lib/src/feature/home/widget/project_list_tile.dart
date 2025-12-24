import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/project/view/project_view.dart';

class ProjectListTile extends StatelessWidget {
  const ProjectListTile({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(project.title),
      subtitle: Text('Created on: ${project.createdAt.toLocal()}'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        context.push(ProjectView.routePath, extra: project.id);
      },
    );
  }
}
