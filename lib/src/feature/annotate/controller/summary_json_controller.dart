import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/entity_models/dataset/dataset_summary.dart';
import 'package:tmai_pro/src/utils/path_builder.dart';

final summaryJsonControllerProvider =
    Provider.family<SummaryJsonController, String>((ref, versionPath) {
      return SummaryJsonController(versionPath: versionPath);
    });

class SummaryJsonController {
  final String _versionSummaryPath;

  SummaryJsonController({required String versionPath})
    : _versionSummaryPath = PathBuilder.summaryJsonPath(
        versionPath: versionPath,
      );

  String _readSummaryJson() => File(_versionSummaryPath).readAsStringSync();

  DatasetSummary getSummaryJson() =>
      DatasetSummary.fromJson(jsonDecode(_readSummaryJson()));
}
