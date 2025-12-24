import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/services/db_services.dart';

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
            appBar: AppBar(title: Text(project.title)),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Project ID: ${project.id}'),
                        SizedBox(height: 8),
                        Text('Title: ${project.title}'),
                        SizedBox(height: 8),
                        Text('Created At: ${project.createdAt.toLocal()}'),
                        // Add more project details here
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.grey[200],
                      child: Center(child: Text('Additional Details Here')),
                    ),
                  ),
                ],
              ),
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
