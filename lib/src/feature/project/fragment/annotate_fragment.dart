import 'package:flutter/material.dart';

class AnnotateFragment extends StatelessWidget {
  const AnnotateFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text("Annotate", style: TextStyle(fontSize: 24))],
      ),
    );
  }
}
