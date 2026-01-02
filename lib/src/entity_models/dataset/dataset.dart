import 'package:isar/isar.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';

part 'dataset.g.dart';

@collection
class Dataset {
  final Id id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String path;
  final List<String>? classes;
  final List<String>? tags;
  final double testSplit;
  final double trainSplit;
  final double valSplit;

  final project = IsarLink<Project>();

  Dataset({
    this.id = Isar.autoIncrement,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.path,
    this.classes,
    this.tags,
    this.testSplit = 0.1,
    this.trainSplit = 0.8,
    this.valSplit = 0.1,
  });

  Dataset copyWith({
    Id? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? path,
    List<String>? classes,
    List<String>? tags,
    double? testSplit,
    double? trainSplit,
    double? valSplit,
  }) {
    return Dataset(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      path: path ?? this.path,
      classes: classes ?? this.classes,
      tags: tags ?? this.tags,
      testSplit: testSplit ?? this.testSplit,
      trainSplit: trainSplit ?? this.trainSplit,
      valSplit: valSplit ?? this.valSplit,
    );
  }
}
