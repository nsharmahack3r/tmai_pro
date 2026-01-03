import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmai_pro/src/feature/home/controller/home_project_controller.dart';
import 'package:tmai_pro/src/feature/project/view/project_view.dart';

class NewProjectView extends ConsumerStatefulWidget {
  const NewProjectView({super.key});

  static const routePath = '/new_project';

  @override
  ConsumerState<NewProjectView> createState() => _NewProjectViewState();
}

class _NewProjectViewState extends ConsumerState<NewProjectView> {
  late final HomeProjectController _homeProjectController = ref.read(
    homeProjectControllerProvider,
  );

  final _projectNameController = TextEditingController();
  final _projectPathController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("New Project", style: TextStyle(fontSize: 24)),
              SizedBox(height: 24),
              TextFormField(
                controller: _projectNameController,
                decoration: InputDecoration(
                  labelText: "Project Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Project name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _projectPathController,
                decoration: InputDecoration(
                  labelText: "Path",
                  hintText:
                      "Select a folder where you want to save the project files ->",
                  border: OutlineInputBorder(),
                  suffix: InkWell(
                    child: Icon(Icons.folder, size: 24),
                    onTap: () async {
                      final path = await _homeProjectController
                          .getLocalProjectPath();

                      if (path.isNotEmpty) {
                        _projectPathController.text = path;
                      }
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Path is required';
                  }
                  return null;
                },
              ),

              SizedBox(height: 24),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      _homeProjectController
                          .createNewProject(
                            projectName: _projectNameController.text,
                            path: _projectPathController.text,
                          )
                          .then((projectId) {
                            if (projectId > 0) {
                              _projectNameController.clear();
                              _projectPathController.clear();
                            }
                            context.replace(
                              ProjectView.routePath,
                              extra: projectId,
                            );
                          });
                    },
                    child: Text("Create"),
                  ),

                  SizedBox(width: 12),

                  ElevatedButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
