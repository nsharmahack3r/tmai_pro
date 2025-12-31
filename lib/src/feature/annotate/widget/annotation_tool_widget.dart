import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/annotate/controller/annotate_view_controller.dart';
import 'package:tmai_pro/src/feature/annotate/state/annotation_view_state.dart';
import 'package:tmai_pro/src/utils/color_builder.dart';

class AnnotationToolWidget extends ConsumerStatefulWidget {
  const AnnotationToolWidget({super.key, required this.project});

  final Project project;

  @override
  ConsumerState<AnnotationToolWidget> createState() =>
      _AnnotationToolWidgetState();
}

class _AnnotationToolWidgetState extends ConsumerState<AnnotationToolWidget> {
  late final controller = ref.read(
    annotateViewControllerProvider(widget.project).notifier,
  );

  late final _newClassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(annotateViewControllerProvider(widget.project));

    return Container(
      width: 300,
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Toolbar Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: const Text(
              "Tools",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Row(
            children: [
              IconButton(
                onPressed: () => controller.previousImage(),
                icon: const Icon(Icons.arrow_back),
              ),
              IconButton(
                onPressed: () => controller.nextImage(),
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),

          // Toolbar Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildInfoTile("Total Boxes", "${state.boxes.length}"),
                if (state.selectedHandleIndex != null) ...[
                  const Divider(),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      controller.removeSelectedBox();
                    },
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text("Delete Box"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red,
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 20),
                  const Text(
                    "No box selected",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.boxes.length,
                  itemBuilder: (context, index) {
                    final box = state.boxes[index];
                    return BoundingBoxTile(
                      box: box,
                      ontap: () {
                        controller.setSelectedHandleIndex(index);
                      },
                      selected: index == state.selectedHandleIndex,
                      onClassChanged: (className) {
                        controller.updateBox(
                          index,
                          box.copyWith(className: className),
                        );
                      },
                      classes: state.classes,
                    );
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _newClassController,
                  decoration: const InputDecoration(
                    labelText: "New Class",
                    border: OutlineInputBorder(),
                  ),
                  onFieldSubmitted: (value) {
                    if (value.isNotEmpty) {
                      controller.addNewClass(value, widget.project);
                      _newClassController.clear();
                    }
                  },
                ),
              ],
            ),
          ),

          // Toolbar Footer (Actions)
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton(
              onPressed: () => controller.clearAllBoxes(),
              child: const Text("Clear All"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class BoundingBoxTile extends StatelessWidget {
  const BoundingBoxTile({
    super.key,
    required this.box,
    required this.ontap,
    this.selected = false,
    required this.onClassChanged,
    required this.classes,
  });

  final BBox box;
  final VoidCallback ontap;
  final bool selected;
  final void Function(String) onClassChanged;
  final List<String> classes;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        margin: EdgeInsets.only(top: 8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected
                ? ColorBuilder.getRandomColorFromClassName(box.className)
                : Colors.grey,
            width: selected ? 3.0 : 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(box.className),
            ),
            Spacer(),
            DropdownButton<String>(
              underline: Container(),
              value: box.className,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              onChanged: (value) {
                if (value != null) {
                  onClassChanged(value);
                }
              },
              items: classes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
