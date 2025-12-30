import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/annotate/controller/annotate_view_controller.dart';
import 'package:tmai_pro/src/feature/annotate/widget/annotate_view_thmbnail.dart';

class ThumbnailViewNavigator extends ConsumerWidget {
  const ThumbnailViewNavigator({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(annotateViewControllerProvider(project.path));
    final imageFiles = state.images;
    return ListView.builder(
      itemCount: imageFiles.length,
      itemBuilder: (context, index) {
        final imageFile = imageFiles[index];
        return AnnotatorThumbnail(
          imagePath: imageFile,
          onTap: () {
            ref
                .read(annotateViewControllerProvider(project.path).notifier)
                .setSelectedImageIndex(index);
          },
          annotations: {},
          selected: index == state.selectedImageIndex,
        );
      },
    );
  }
}
