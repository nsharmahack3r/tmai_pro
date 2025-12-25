import 'package:flutter/material.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';

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
            ),
          ),
        ],
      ),
    );
  }
}
