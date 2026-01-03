import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmai_pro/src/common/widget/empty.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/home/view/dependency_installation_page.dart';
import 'package:tmai_pro/src/feature/home/view/new_project.dart';
import 'package:tmai_pro/src/feature/home/widget/project_list_tile.dart';
import 'package:tmai_pro/src/feature/home/controller/home_project_controller.dart';
import 'package:tmai_pro/src/feature/init/controller/env_setup_controller.dart';
import 'package:tmai_pro/src/feature/init/controller/init_controller.dart';
import 'package:tmai_pro/src/resource/assets.gen.dart';
import 'package:tmai_pro/src/services/db_services.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  static const routePath = "/";

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  late final localDbService = ref.read(dbServiceProvider);
  late final homeProjectController = ref.read(homeProjectControllerProvider);
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(initControllerProvider).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ready = ref.watch(
      envSetupControllerProvider.select((state) => state.ready),
    );
    if (!ready) {
      return DependencyInstallationPage();
    }
    return Scaffold(
      body: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Assets.icon.icon.image(width: 60),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TMAI',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('dev-0.1', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(width: 1, color: Colors.grey),
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<List<Project>>(
                stream: localDbService.watchProjects(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final projects = snapshot.data!;

                  if (projects.isEmpty) {
                    return Center(
                      child: EmptyWidget(
                        message: "No Projects Available",
                        anActionTap: () {
                          context.push(NewProjectView.routePath);
                        },
                        actionText: "Create New Project",
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount:
                        projects.length, // Replace with actual project count
                    itemBuilder: (context, index) {
                      return ProjectListTile(project: projects[index]);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.push(NewProjectView.routePath);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
