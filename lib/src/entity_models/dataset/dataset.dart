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

  final project = IsarLink<Project>();

  Dataset({
    this.id = Isar.autoIncrement,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.path,
    this.classes,
    this.tags,
  });

  Dataset copyWith({
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? path,
    List<String>? classes,
    List<String>? tags,
  }) {
    return Dataset(
      id: id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      path: path ?? this.path,
      classes: classes ?? this.classes,
      tags: tags ?? this.tags,
    );
  }
}
