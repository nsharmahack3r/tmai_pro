import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/project/controller/preview_controller.dart';

class PreviewFragment extends StatefulWidget {
  const PreviewFragment({super.key, required this.project});

  final Project project;

  @override
  State<PreviewFragment> createState() => _PreviewFragmentState();
}

class _PreviewFragmentState extends State<PreviewFragment> {
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

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1,
                        ),
                    itemCount: previewState.imagePaths.length,
                    itemBuilder: (context, index) {
                      final imagePath = previewState.imagePaths[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.file(File(imagePath), fit: BoxFit.cover),
                      );
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
