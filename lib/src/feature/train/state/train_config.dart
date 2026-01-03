import 'package:tmai_pro/src/entity_models/dataset/dataset.dart';

class TrainingConfig {
  final String model;
  final int epochs;
  final int batchSize;
  final double learningRate;
  final String optimizer;
  final int selectedDatasetIndex;
  final List<Dataset> datasets;
  final bool loading;

  TrainingConfig({
    this.model = 'yolov8n',
    this.epochs = 50,
    this.batchSize = 16,
    this.learningRate = 0.001,
    this.optimizer = 'adam',
    this.selectedDatasetIndex = -1,
    this.datasets = const [],
    this.loading = false,
  });

  TrainingConfig copyWith({
    String? model,
    int? epochs,
    int? batchSize,
    double? learningRate,
    String? optimizer,
    String? datasetPath,
    int? selectedDatasetIndex,
    List<Dataset>? datasets,
    bool? loading,
  }) {
    return TrainingConfig(
      model: model ?? this.model,
      epochs: epochs ?? this.epochs,
      batchSize: batchSize ?? this.batchSize,
      learningRate: learningRate ?? this.learningRate,
      optimizer: optimizer ?? this.optimizer,
      selectedDatasetIndex: selectedDatasetIndex ?? this.selectedDatasetIndex,
      datasets: datasets ?? this.datasets,
      loading: loading ?? this.loading,
    );
  }
}
