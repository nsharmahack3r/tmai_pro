import 'package:flutter/material.dart';

class VersionFragment extends StatelessWidget {
  const VersionFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text("Versions", style: TextStyle(fontSize: 24))],
      ),
    );
  }
}
