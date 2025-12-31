import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnnotationPreviewListTile extends ConsumerWidget {
  const AnnotationPreviewListTile({
    super.key,
    required this.imagePath,
    required this.annotations,
    required this.onTap,
    required this.selected,
  });

  final String imagePath;
  final Map<String, dynamic> annotations;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Image.file(
        File(imagePath),
        width: 100,
        height: 60,
        fit: BoxFit.cover,
      ),
      title: Text(imagePath.split('\\').last),
      subtitle: _subtitleBuilder(),
      onTap: onTap,
      selected: selected,
    );
  }

  Widget _subtitleBuilder() {
    if (annotations[imagePath] != null) {
      if (annotations[imagePath].isEmpty) {
        return Text('No annotations');
      } else {
        return Text('Annotations: ${annotations[imagePath].length}');
      }
    } else {
      return Text('File does not have path');
    }
  }
}
