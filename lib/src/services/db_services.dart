import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:tmai_pro/src/entity_models/dataset/dataset.dart';
import 'package:tmai_pro/src/entity_models/project/project.dart';
import 'package:tmai_pro/src/entity_models/trained_model/train.dart';

final dbServiceProvider = Provider<DbServices>((ref) => DbServices());

class DbServices {
  late final Future<Isar> _db;

  DbServices() {
    _db = _openDB();
  }

  Future<Isar> get db async => _db;

  /* ───────────────────────── OPEN DB ───────────────────────── */

  Future<Isar> _openDB() async {
    final directory = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [ProjectSchema, DatasetSchema, TrainModelSchema],
        directory: directory.path,
        inspector: true,
      );
    }

    return Isar.getInstance()!;
  }

  /* ───────────────────────── PROJECTS ───────────────────────── */

  Future<int> createProject(Project project) async {
    final isar = await db;
    return await isar.writeTxn(() => isar.projects.put(project));
  }

  Future<List<Project>> getAllProjects() async {
    final isar = await db;
    return await isar.projects.where().findAll();
  }

  Future<Project?> getProject(Id id) async {
    final isar = await db;
    return await isar.projects.get(id);
  }

  Future<void> updateProject(Project project) async {
    final isar = await db;
    await isar.writeTxn(() => isar.projects.put(project));
  }

  Future<void> deleteProject(Id projectId) async {
    final isar = await db;

    await isar.writeTxn(() async {
      final project = await isar.projects.get(projectId);
      if (project == null) return;

      await project.datasets.load();
      await project.models.load();

      await isar.datasets.deleteAll(project.datasets.map((d) => d.id).toList());

      await isar.trainModels.deleteAll(
        project.models.map((m) => m.id).toList(),
      );

      await isar.projects.delete(projectId);
    });
  }

  /* ───────────────────────── DATASETS ───────────────────────── */

  Future<int> addDatasetToProject(Dataset dataset, Project project) async {
    final isar = await db;

    return await isar.writeTxn(() async {
      final datasetId = await isar.datasets.put(dataset);
      project.datasets.add(dataset);
      await project.datasets.save();
      return datasetId;
    });
  }

  Future<List<Dataset>> getDatasetsForProject(Project project) async {
    final isar = await db;
    final freshProject = await isar.projects.get(project.id);
    if (freshProject == null) return [];

    await freshProject.datasets.load();
    return freshProject.datasets.toList();
  }

  Future<void> updateDataset(Dataset dataset) async {
    final isar = await db;
    await isar.writeTxn(() => isar.datasets.put(dataset));
  }

  Future<void> removeDataset(Dataset dataset, Project project) async {
    final isar = await db;

    await isar.writeTxn(() async {
      project.datasets.remove(dataset);
      await project.datasets.save();
      await isar.datasets.delete(dataset.id);
    });
  }

  /* ───────────────────────── TRAINED MODELS ───────────────────────── */

  Future<int> addModelToProject(TrainModel model, Project project) async {
    final isar = await db;

    return await isar.writeTxn(() async {
      final modelId = await isar.trainModels.put(model);
      project.models.add(model);
      await project.models.save();
      return modelId;
    });
  }

  Future<List<TrainModel>> getModelsForProject(Project project) async {
    final isar = await db;
    final freshProject = await isar.projects.get(project.id);
    if (freshProject == null) return [];

    await freshProject.models.load();
    return freshProject.models.toList();
  }

  Future<void> updateModel(TrainModel model) async {
    final isar = await db;
    await isar.writeTxn(() => isar.trainModels.put(model));
  }

  Future<void> removeModel(TrainModel model, Project project) async {
    final isar = await db;

    await isar.writeTxn(() async {
      project.models.remove(model);
      await project.models.save();
      await isar.trainModels.delete(model.id);
    });
  }

  /* ───────────────────────── WATCHERS ───────────────────────── */

  // watch a single project by id
  Stream<Project?> watchProjectById(Id projectId) async* {
    final isar = await db;

    yield* isar.projects.watchObject(projectId, fireImmediately: true);
  }

  /* WATCH ALL PROJECTS */
  Stream<List<Project>> watchProjects() async* {
    final isar = await db;

    yield* isar.projects.where().watch(fireImmediately: true);
  }

  /* WATCH DATASETS FOR A PROJECT */
  Stream<List<Dataset>> watchDatasetsForProject(Id projectId) async* {
    final isar = await db;

    yield* isar.projects.watchObject(projectId, fireImmediately: true).asyncMap(
      (project) async {
        if (project == null) return <Dataset>[];
        await project.datasets.load();
        return project.datasets.toList();
      },
    );
  }

  /* WATCH MODELS FOR A PROJECT */
  Stream<List<TrainModel>> watchModelsForProject(Id projectId) async* {
    final isar = await db;

    yield* isar.projects.watchObject(projectId, fireImmediately: true).asyncMap(
      (project) async {
        if (project == null) return <TrainModel>[];
        await project.models.load();
        return project.models.toList();
      },
    );
  }

  Future<void> seedDemoData() async {
    final isar = await db;

    await isar.writeTxn(() async {
      for (int p = 1; p <= 6; p++) {
        final project = Project(
          title: 'Project $p',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final projectId = await isar.projects.put(project);
        final savedProject = await isar.projects.get(projectId);
        if (savedProject == null) continue;

        /* ───── DATASETS (3 per project) ───── */
        for (int d = 1; d <= 3; d++) {
          final dataset = Dataset(
            name: 'Project $p - Dataset $d',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            path: '/data/project_$p/dataset_$d',
            classes: ['class_a', 'class_b', 'class_c'],
            tags: ['demo', 'seed', 'p$p'],
          );

          final datasetId = await isar.datasets.put(dataset);
          final savedDataset = await isar.datasets.get(datasetId);
          if (savedDataset != null) {
            savedProject.datasets.add(savedDataset);
          }
        }

        /* ───── MODELS (5 per project) ───── */
        for (int m = 1; m <= 5; m++) {
          final model = TrainModel(
            name: 'Project $p - Model $m',
            modelId: 'yolo_v8_${p}_$m',
            trainedAt: DateTime.now(),
            path: '/models/project_$p/model_$m.pt',
          );

          final modelId = await isar.trainModels.put(model);
          final savedModel = await isar.trainModels.get(modelId);
          if (savedModel != null) {
            savedProject.models.add(savedModel);
          }
        }

        await savedProject.datasets.save();
        await savedProject.models.save();
      }
    });
  }
}
