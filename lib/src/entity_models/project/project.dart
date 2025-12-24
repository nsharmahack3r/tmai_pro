import 'package:isar/isar.dart';
import 'package:tmai_pro/src/entity_models/dataset/dataset.dart';
import 'package:tmai_pro/src/entity_models/trained_model/train.dart';

part 'project.g.dart';

@collection
class Project {
  final Id id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;

  final datasets = IsarLinks<Dataset>();
  final models = IsarLinks<TrainModel>();

  Project({
    this.id = Isar.autoIncrement,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });
}
