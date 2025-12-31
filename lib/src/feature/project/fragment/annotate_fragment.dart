import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/annotate/controller/annotation_preview_controller.dart';
import 'package:tmai_pro/src/feature/annotate/view/annotate_view.dart';
import 'package:tmai_pro/src/feature/annotate/widget/annotate_summary.dart';
import 'package:tmai_pro/src/feature/project/widget/annotated_image_preview.dart';
import 'package:tmai_pro/src/feature/project/widget/annotation_preview_list_tile.dart';

class AnnotateFragment extends ConsumerStatefulWidget {
  const AnnotateFragment({super.key, required this.project});

  final Project project;

  @override
  ConsumerState<AnnotateFragment> createState() => _AnnotateFragmentState();
}

class _AnnotateFragmentState extends ConsumerState<AnnotateFragment> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Annotation", style: TextStyle(fontSize: 24)),
          SizedBox(height: 12),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                //color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),

              child: Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(
                    annotationPreviewControllerProvider(widget.project.path),
                  );
                  return Row(
                    children: [
                      // All images list
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "All Images : ${state.imagePaths.length}",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Flexible(
                              child: ListView.builder(
                                itemCount: state.imagePaths.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final imagePath = state.imagePaths[index];
                                  return AnnotationPreviewListTile(
                                    imagePath: imagePath,
                                    annotations: state.annotations,
                                    onTap: () {
                                      ref
                                          .read(
                                            annotationPreviewControllerProvider(
                                              widget.project.path,
                                            ).notifier,
                                          )
                                          .selectImage(imagePath);
                                    },
                                    selected: index == state.currentIndex,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Annotated images list
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Annotated Images : ${state.annotatedImagePaths.length}",
                                    style: TextStyle(fontSize: 16),
                                  ),

                                  MaterialButton(
                                    onPressed: () {
                                      context.push(
                                        AnnotateView.routePath,
                                        extra: widget.project,
                                      );
                                    },
                                    child: Text("Annotate More"),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.annotatedImagePaths.length,
                                itemBuilder: (context, index) {
                                  final imagePath =
                                      state.annotatedImagePaths[index];
                                  return AnnotationPreviewListTile(
                                    imagePath: imagePath,
                                    annotations: state.annotations,
                                    onTap: () {
                                      ref
                                          .read(
                                            annotationPreviewControllerProvider(
                                              widget.project.path,
                                            ).notifier,
                                          )
                                          .selectImage(imagePath);
                                    },
                                    selected:
                                        state.currentIndex >= 0 &&
                                        imagePath ==
                                            state.imagePaths[state
                                                .currentIndex],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            AnnotationSummary(project: widget.project),
                            SizedBox(height: 16),
                            state.currentIndex < 0
                                ? const SizedBox.shrink()
                                : Flexible(
                                    child: AnnotatedImagePreview(
                                      imagePath:
                                          state.imagePaths[state.currentIndex],
                                      annotations: state.annotations,
                                      onClose: () {
                                        ref
                                            .read(
                                              annotationPreviewControllerProvider(
                                                widget.project.path,
                                              ).notifier,
                                            )
                                            .clearSelection();
                                      },
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
