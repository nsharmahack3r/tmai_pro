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
  final String path;
  final List<String> classes;

  final datasets = IsarLinks<Dataset>();
  final models = IsarLinks<TrainModel>();

  Project({
    this.id = Isar.autoIncrement,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.path,
    this.classes = const [],
  });

  Project copyWith({
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? path,
    List<String>? classes,
  }) {
    return Project(
      id: id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      path: path ?? this.path,
      classes: classes ?? this.classes,
    );
  }
}
