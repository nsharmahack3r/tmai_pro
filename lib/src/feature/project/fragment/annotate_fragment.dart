import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/annotate/view/annotate_view.dart';

class AnnotateFragment extends StatelessWidget {
  const AnnotateFragment({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Annotate", style: TextStyle(fontSize: 24)),
          MaterialButton(
            onPressed: () {
              context.push(AnnotateView.routePath, extra: project);
            },
            child: Text("Annotate"),
          ),
        ],
      ),
    );
  }
}
