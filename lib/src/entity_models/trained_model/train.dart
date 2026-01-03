import 'package:isar/isar.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';

part 'train.g.dart';

enum TrainingStatus { ready, complete, error }

@collection
class TrainModel {
  final Id id;
  final String name;
  final String modelId;
  final DateTime? trainedAt;
  final DateTime createdAt;
  final String? path;
  final String datasetPath;
  @enumerated
  final TrainingStatus status;

  // Hyperparameters

  final int epochs;
  final int batchSize;
  final double learningRate;
  final String optimizer;

  final project = IsarLink<Project>();

  TrainModel({
    this.id = Isar.autoIncrement,
    required this.name,
    required this.modelId,
    this.trainedAt,
    required this.createdAt,
    this.path,
    required this.datasetPath,

    // Hyperparameters
    required this.epochs,
    required this.batchSize,
    required this.learningRate,
    required this.optimizer,

    this.status = TrainingStatus.ready,
  });

  TrainModel copyWith({
    String? name,
    String? modelId,
    DateTime? trainedAt,
    String? path,
    int? id,
    TrainingStatus? status,
  }) {
    return TrainModel(
      id: id ?? this.id,
      name: name ?? this.name,
      modelId: modelId ?? this.modelId,
      trainedAt: trainedAt ?? this.trainedAt,
      path: path ?? this.path,
      createdAt: createdAt,
      datasetPath: datasetPath,

      // Hyperparameters
      epochs: epochs,
      batchSize: batchSize,
      learningRate: learningRate,
      optimizer: optimizer,
      status: status ?? this.status,
    );
  }
}
