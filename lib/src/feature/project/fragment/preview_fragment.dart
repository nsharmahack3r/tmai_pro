import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/common/widget/empty.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/project/controller/preview_controller.dart';
import 'package:tmai_pro/src/feature/project/view/project_view.dart';
import 'package:tmai_pro/src/feature/project/widget/image_preview_tile.dart';

class PreviewFragment extends ConsumerStatefulWidget {
  const PreviewFragment({super.key, required this.project});

  final Project project;

  @override
  ConsumerState<PreviewFragment> createState() => _PreviewFragmentState();
}

class _PreviewFragmentState extends ConsumerState<PreviewFragment> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Dataset Preview", style: TextStyle(fontSize: 24)),
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
                  final previewState = ref.watch(
                    previewControllerProvider(widget.project),
                  );
                  if (previewState.loading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (previewState.errorMessage != null) {
                    return Center(child: Text(previewState.errorMessage!));
                  }

                  if (previewState.imagePaths.isEmpty) {
                    return Center(
                      child: EmptyWidget(
                        message: "No Images in dataset",
                        anActionTap: () {
                          ref
                              .read(fragmentIndexProvider.notifier)
                              .update((state) => 0);
                        },
                        actionText: "Import Images",
                      ),
                    );
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: previewState.imagePaths.length,
                    itemBuilder: (context, index) {
                      final imagePath = previewState.imagePaths[index];
                      return ImagePreviewTile(imageFile: File(imagePath));
                    },
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
