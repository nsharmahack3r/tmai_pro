import 'package:go_router/go_router.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/annotate/view/annotate_view.dart';
import 'package:tmai_pro/src/feature/home/view/home_view.dart';
import 'package:tmai_pro/src/feature/home/view/new_project.dart';
import 'package:tmai_pro/src/feature/project/view/project_view.dart';

final router = GoRouter(
  // initialLocation: AnnotateView.routePath,
  initialLocation: HomeView.routePath,
  routes: [
    GoRoute(
      path: HomeView.routePath,
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: ProjectView.routePath,
      builder: (context, state) {
        return ProjectView(projectId: state.extra as int);
      },
    ),
    GoRoute(
      path: NewProjectView.routePath,
      builder: (context, state) => const NewProjectView(),
    ),

    GoRoute(
      path: AnnotateView.routePath,
      builder: (context, state) =>
          AnnotateView(project: state.extra as Project),
    ),
  ],
);
