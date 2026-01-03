import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/entity_models/trained_model/train.dart';
import 'package:tmai_pro/src/feature/train/state/train_config.dart';
import 'package:tmai_pro/src/services/db_services.dart';

final trainConfigControllerProvider =
    StateNotifierProvider.family<
      TrainConfigController,
      TrainingConfig,
      Project
    >((ref, project) => TrainConfigController(project: project, ref: ref));

class TrainConfigController extends StateNotifier<TrainingConfig> {
  TrainConfigController({required Project project, required Ref ref})
    : _project = project,
      _ref = ref,
      super(TrainingConfig()) {
    _loadDatasets();
  }

  final Project _project;
  final Ref _ref;

  Future<void> _loadDatasets() async {
    state = state.copyWith(loading: true);
    final datasets = await _ref
        .read(dbServiceProvider)
        .getDatasetsForProject(_project);

    state = state.copyWith(
      datasets: datasets,
      loading: false,
      selectedDatasetIndex: datasets.isNotEmpty ? 0 : null,
    );
  }

  // ---- Epochs ----
  void updateEpochs(int value) {
    state = state.copyWith(epochs: value);
  }

  // ---- Batch size ----
  void updateBatchSize(int value) {
    state = state.copyWith(batchSize: value);
  }

  // ---- Learning rate ----
  void updateLearningRate(double value) {
    state = state.copyWith(learningRate: value);
  }

  // ---- Optimizer ----
  void updateOptimizer(String value) {
    state = state.copyWith(optimizer: value);
  }

  // ---- Dataset path ----
  void updateDatasetPath(String path) {
    state = state.copyWith(datasetPath: path);
  }

  // ---- Reset to defaults (optional but useful) ----
  void reset() {
    state = TrainingConfig().copyWith(
      selectedDatasetIndex: state.selectedDatasetIndex,
      datasets: state.datasets,
    );
  }

  void updateSelectedIndex(int index) {
    state = state.copyWith(selectedDatasetIndex: index);
  }

  void updateModel(String model) {
    state = state.copyWith(model: model);
  }

  Future<void> saveTrainConfig() async {
    _ref
        .read(dbServiceProvider)
        .addModelToProject(
          TrainModel(
            name: state.model,
            modelId: state.model,
            createdAt: DateTime.now(),
            epochs: state.epochs,
            batchSize: state.batchSize,
            learningRate: state.learningRate,
            optimizer: state.optimizer,
            datasetPath: state.datasets[state.selectedDatasetIndex].path,
          ),
          _project,
        );
  }
}
