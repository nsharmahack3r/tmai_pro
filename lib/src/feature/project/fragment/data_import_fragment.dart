import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/feature/project/controller/import_controller.dart';

class DataImportFragment extends ConsumerStatefulWidget {
  const DataImportFragment({super.key, required this.project});

  final Project project;

  @override
  ConsumerState<DataImportFragment> createState() => _DataImportFragmentState();
}

class _DataImportFragmentState extends ConsumerState<DataImportFragment> {
  late final dataImportController = ref.read(
    importFilesControllerProvider(widget.project),
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Import Data", style: TextStyle(fontSize: 24)),
          SizedBox(height: 12),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                //color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.download),
                  Text("IMPORT DATA"),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey),
                        ),
                        onPressed: () {
                          dataImportController.importImages();
                        },
                        child: Text("Select File(s)"),
                      ),
                      SizedBox(width: 12),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey),
                        ),
                        onPressed: () {
                          dataImportController.importImagesFromFolder();
                        },
                        child: Text("Select Folder"),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      //color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text("Supported Formats .jpg, .png, .bmp"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
