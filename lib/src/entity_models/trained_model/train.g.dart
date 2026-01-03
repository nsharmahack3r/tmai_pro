// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'train.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTrainModelCollection on Isar {
  IsarCollection<TrainModel> get trainModels => this.collection();
}

const TrainModelSchema = CollectionSchema(
  name: r'TrainModel',
  id: -7074258509332360808,
  properties: {
    r'batchSize': PropertySchema(
      id: 0,
      name: r'batchSize',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'datasetPath': PropertySchema(
      id: 2,
      name: r'datasetPath',
      type: IsarType.string,
    ),
    r'epochs': PropertySchema(
      id: 3,
      name: r'epochs',
      type: IsarType.long,
    ),
    r'learningRate': PropertySchema(
      id: 4,
      name: r'learningRate',
      type: IsarType.double,
    ),
    r'modelId': PropertySchema(
      id: 5,
      name: r'modelId',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 6,
      name: r'name',
      type: IsarType.string,
    ),
    r'optimizer': PropertySchema(
      id: 7,
      name: r'optimizer',
      type: IsarType.string,
    ),
    r'path': PropertySchema(
      id: 8,
      name: r'path',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 9,
      name: r'status',
      type: IsarType.byte,
      enumMap: _TrainModelstatusEnumValueMap,
    ),
    r'trainedAt': PropertySchema(
      id: 10,
      name: r'trainedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _trainModelEstimateSize,
  serialize: _trainModelSerialize,
  deserialize: _trainModelDeserialize,
  deserializeProp: _trainModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'project': LinkSchema(
      id: 3601993222486916946,
      name: r'project',
      target: r'Project',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _trainModelGetId,
  getLinks: _trainModelGetLinks,
  attach: _trainModelAttach,
  version: '3.1.0+1',
);

int _trainModelEstimateSize(
  TrainModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.datasetPath.length * 3;
  bytesCount += 3 + object.modelId.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.optimizer.length * 3;
  {
    final value = object.path;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _trainModelSerialize(
  TrainModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.batchSize);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.datasetPath);
  writer.writeLong(offsets[3], object.epochs);
  writer.writeDouble(offsets[4], object.learningRate);
  writer.writeString(offsets[5], object.modelId);
  writer.writeString(offsets[6], object.name);
  writer.writeString(offsets[7], object.optimizer);
  writer.writeString(offsets[8], object.path);
  writer.writeByte(offsets[9], object.status.index);
  writer.writeDateTime(offsets[10], object.trainedAt);
}

TrainModel _trainModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TrainModel(
    batchSize: reader.readLong(offsets[0]),
    createdAt: reader.readDateTime(offsets[1]),
    datasetPath: reader.readString(offsets[2]),
    epochs: reader.readLong(offsets[3]),
    id: id,
    learningRate: reader.readDouble(offsets[4]),
    modelId: reader.readString(offsets[5]),
    name: reader.readString(offsets[6]),
    optimizer: reader.readString(offsets[7]),
    path: reader.readStringOrNull(offsets[8]),
    status: _TrainModelstatusValueEnumMap[reader.readByteOrNull(offsets[9])] ??
        TrainingStatus.ready,
    trainedAt: reader.readDateTimeOrNull(offsets[10]),
  );
  return object;
}

P _trainModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (_TrainModelstatusValueEnumMap[reader.readByteOrNull(offset)] ??
          TrainingStatus.ready) as P;
    case 10:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TrainModelstatusEnumValueMap = {
  'ready': 0,
  'complete': 1,
  'error': 2,
};
const _TrainModelstatusValueEnumMap = {
  0: TrainingStatus.ready,
  1: TrainingStatus.complete,
  2: TrainingStatus.error,
};

Id _trainModelGetId(TrainModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _trainModelGetLinks(TrainModel object) {
  return [object.project];
}

void _trainModelAttach(IsarCollection<dynamic> col, Id id, TrainModel object) {
  object.project.attach(col, col.isar.collection<Project>(), r'project', id);
}

extension TrainModelQueryWhereSort
    on QueryBuilder<TrainModel, TrainModel, QWhere> {
  QueryBuilder<TrainModel, TrainModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TrainModelQueryWhere
    on QueryBuilder<TrainModel, TrainModel, QWhereClause> {
  QueryBuilder<TrainModel, TrainModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TrainModelQueryFilter
    on QueryBuilder<TrainModel, TrainModel, QFilterCondition> {
  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> batchSizeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'batchSize',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      batchSizeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'batchSize',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> batchSizeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'batchSize',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> batchSizeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'batchSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      datasetPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'datasetPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      datasetPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'datasetPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      datasetPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'datasetPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      datasetPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'datasetPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      datasetPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'datasetPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      datasetPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'datasetPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      datasetPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'datasetPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      datasetPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'datasetPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      datasetPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'datasetPath',
        value: '',
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      datasetPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'datasetPath',
        value: '',
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> epochsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'epochs',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> epochsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'epochs',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> epochsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'epochs',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> epochsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'epochs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      learningRateEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'learningRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      learningRateGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'learningRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      learningRateLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'learningRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      learningRateBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'learningRate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> modelIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      modelIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> modelIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> modelIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modelId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> modelIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'modelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> modelIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'modelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> modelIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> modelIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modelId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> modelIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelId',
        value: '',
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      modelIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modelId',
        value: '',
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> optimizerEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'optimizer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      optimizerGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'optimizer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> optimizerLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'optimizer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> optimizerBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'optimizer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      optimizerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'optimizer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> optimizerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'optimizer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> optimizerContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'optimizer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> optimizerMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'optimizer',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      optimizerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'optimizer',
        value: '',
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      optimizerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'optimizer',
        value: '',
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> pathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'path',
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> pathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'path',
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> pathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> pathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> pathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> pathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'path',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> pathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> pathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> pathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> pathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'path',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> pathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: '',
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> pathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'path',
        value: '',
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> statusEqualTo(
      TrainingStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> statusGreaterThan(
    TrainingStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> statusLessThan(
    TrainingStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> statusBetween(
    TrainingStatus lower,
    TrainingStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      trainedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'trainedAt',
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      trainedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'trainedAt',
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> trainedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trainedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition>
      trainedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'trainedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> trainedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'trainedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> trainedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'trainedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TrainModelQueryObject
    on QueryBuilder<TrainModel, TrainModel, QFilterCondition> {}

extension TrainModelQueryLinks
    on QueryBuilder<TrainModel, TrainModel, QFilterCondition> {
  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> project(
      FilterQuery<Project> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'project');
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterFilterCondition> projectIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'project', 0, true, 0, true);
    });
  }
}

extension TrainModelQuerySortBy
    on QueryBuilder<TrainModel, TrainModel, QSortBy> {
  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> sortByBatchSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batchSize', Sort.asc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> sortByBatchSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batchSize', Sort.desc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> sortByDatasetPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'datasetPath', Sort.asc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> sortByDatasetPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'datasetPath', Sort.desc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> sortByEpochs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'epochs', Sort.asc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> sortByEpochsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'epochs', Sort.desc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> sortByLearningRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningRate', Sort.asc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> sortByLearningRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningRate', Sort.desc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> sortByModelId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelId', Sort.asc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> sortByModelIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelId', Sort.desc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> sortByOptimizer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'optimizer', Sort.asc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> sortByOptimizerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'optimizer', Sort.desc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> sortByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> sortByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> sortByTrainedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trainedAt', Sort.asc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> sortByTrainedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trainedAt', Sort.desc);
    });
  }
}

extension TrainModelQuerySortThenBy
    on QueryBuilder<TrainModel, TrainModel, QSortThenBy> {
  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenByBatchSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batchSize', Sort.asc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenByBatchSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batchSize', Sort.desc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenByDatasetPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'datasetPath', Sort.asc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenByDatasetPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'datasetPath', Sort.desc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenByEpochs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'epochs', Sort.asc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenByEpochsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'epochs', Sort.desc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenByLearningRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningRate', Sort.asc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenByLearningRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningRate', Sort.desc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenByModelId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelId', Sort.asc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenByModelIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelId', Sort.desc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenByOptimizer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'optimizer', Sort.asc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenByOptimizerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'optimizer', Sort.desc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenByTrainedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trainedAt', Sort.asc);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QAfterSortBy> thenByTrainedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trainedAt', Sort.desc);
    });
  }
}

extension TrainModelQueryWhereDistinct
    on QueryBuilder<TrainModel, TrainModel, QDistinct> {
  QueryBuilder<TrainModel, TrainModel, QDistinct> distinctByBatchSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'batchSize');
    });
  }

  QueryBuilder<TrainModel, TrainModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<TrainModel, TrainModel, QDistinct> distinctByDatasetPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'datasetPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QDistinct> distinctByEpochs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'epochs');
    });
  }

  QueryBuilder<TrainModel, TrainModel, QDistinct> distinctByLearningRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'learningRate');
    });
  }

  QueryBuilder<TrainModel, TrainModel, QDistinct> distinctByModelId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modelId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QDistinct> distinctByOptimizer(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'optimizer', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QDistinct> distinctByPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'path', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TrainModel, TrainModel, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<TrainModel, TrainModel, QDistinct> distinctByTrainedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trainedAt');
    });
  }
}

extension TrainModelQueryProperty
    on QueryBuilder<TrainModel, TrainModel, QQueryProperty> {
  QueryBuilder<TrainModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TrainModel, int, QQueryOperations> batchSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'batchSize');
    });
  }

  QueryBuilder<TrainModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<TrainModel, String, QQueryOperations> datasetPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'datasetPath');
    });
  }

  QueryBuilder<TrainModel, int, QQueryOperations> epochsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'epochs');
    });
  }

  QueryBuilder<TrainModel, double, QQueryOperations> learningRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'learningRate');
    });
  }

  QueryBuilder<TrainModel, String, QQueryOperations> modelIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modelId');
    });
  }

  QueryBuilder<TrainModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<TrainModel, String, QQueryOperations> optimizerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'optimizer');
    });
  }

  QueryBuilder<TrainModel, String?, QQueryOperations> pathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'path');
    });
  }

  QueryBuilder<TrainModel, TrainingStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<TrainModel, DateTime?, QQueryOperations> trainedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trainedAt');
    });
  }
}
