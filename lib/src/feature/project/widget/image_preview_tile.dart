import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreviewTile extends StatelessWidget {
  const ImagePreviewTile({super.key, required this.imageFile});

  final File imageFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.file(imageFile),
        ),
        Container(
          padding: EdgeInsets.only(top: 4),
          child: Text(
            imageFile.path.split('/').last,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
