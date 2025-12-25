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
      leading: const Icon(Icons.folder),
      title: Text(project.title, style: TextStyle(fontSize: 14)),
      subtitle: Text(
        'Created on: ${_formatDate(project.createdAt.toLocal())}',
        style: TextStyle(fontSize: 12),
      ),
      onTap: () {
        context.push(ProjectView.routePath, extra: project.id);
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
