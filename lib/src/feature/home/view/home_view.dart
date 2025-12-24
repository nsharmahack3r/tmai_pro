import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/home/widget/project_list_tile.dart';
import 'package:tmai_pro/src/services/db_services.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  static const routePath = "/";

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  late final localDbService = ref.read(dbServiceProvider);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Flexible(
            flex: 1,
            child: StreamBuilder<List<Project>>(
              stream: localDbService.watchProjects(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final projects = snapshot.data!;
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
          Flexible(flex: 2, child: Container(color: Colors.grey)),
        ],
      ),
    );
  }
}
