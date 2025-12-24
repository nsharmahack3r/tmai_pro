import 'package:isar/isar.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';

part 'train.g.dart';

@collection
class TrainModel {
  final Id id;
  final String name;
  final String modelId;
  final DateTime trainedAt;
  final String? path;

  final project = IsarLink<Project>();

  TrainModel({
    this.id = Isar.autoIncrement,
    required this.name,
    required this.modelId,
    required this.trainedAt,
    this.path,
  });

  TrainModel copyWith({
    String? name,
    String? modelId,
    DateTime? trainedAt,
    String? path,
  }) {
    return TrainModel(
      id: id,
      name: name ?? this.name,
      modelId: modelId ?? this.modelId,
      trainedAt: trainedAt ?? this.trainedAt,
      path: path ?? this.path,
    );
  }
}
