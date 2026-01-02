class DatasetSummary {
  final SplitRatio splits;
  final Map<String, int> train;
  final Map<String, int> val;
  final Map<String, int> test;
  final SplitTotals total;
  final MetaInfo meta;

  DatasetSummary({
    required this.splits,
    required this.train,
    required this.val,
    required this.test,
    required this.total,
    required this.meta,
  });

  factory DatasetSummary.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] as Map<String, dynamic>;

    return DatasetSummary(
      splits: SplitRatio.fromJson(summary['splits']),
      train: _parseClassMap(summary['train']),
      val: _parseClassMap(summary['val']),
      test: _parseClassMap(summary['test']),
      total: SplitTotals.fromJson(summary['total']),
      meta: MetaInfo.fromJson(summary['meta']),
    );
  }

  static Map<String, int> _parseClassMap(Map<String, dynamic> json) {
    return json.map((key, value) => MapEntry(key, value as int));
  }
}

class SplitRatio {
  final double train;
  final double val;
  final double test;

  SplitRatio({required this.train, required this.val, required this.test});

  factory SplitRatio.fromJson(Map<String, dynamic> json) {
    return SplitRatio(
      train: (json['train'] as num).toDouble(),
      val: (json['val'] as num).toDouble(),
      test: (json['test'] as num).toDouble(),
    );
  }
}

class SplitTotals {
  final int train;
  final int val;
  final int test;

  SplitTotals({required this.train, required this.val, required this.test});

  factory SplitTotals.fromJson(Map<String, dynamic> json) {
    return SplitTotals(
      train: json['train'],
      val: json['val'],
      test: json['test'],
    );
  }
}

class MetaInfo {
  final DateTime createdAt;
  final List<String> augmentationsApplied;
  final int totalBoxesAllSplits;

  MetaInfo({
    required this.createdAt,
    required this.augmentationsApplied,
    required this.totalBoxesAllSplits,
  });

  factory MetaInfo.fromJson(Map<String, dynamic> json) {
    return MetaInfo(
      createdAt: DateTime.parse(json['created_at']),
      augmentationsApplied: List<String>.from(json['augmentations_applied']),
      totalBoxesAllSplits: json['total_boxes_all_splits'],
    );
  }
}
