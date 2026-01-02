enum ExportStatus { idle, preparing, processing, finalizing, completed, error }

class DatasetExportState {
  final ExportStatus status;
  final double progress; // 0.0 to 1.0
  final String currentOperation; // e.g., "Processing image 120/500"
  final String? errorMessage;
  final String? outputPath; // Path to the generated version folder

  DatasetExportState({
    this.status = ExportStatus.idle,
    this.progress = 0.0,
    this.currentOperation = '',
    this.errorMessage,
    this.outputPath,
  });

  DatasetExportState copyWith({
    ExportStatus? status,
    double? progress,
    String? currentOperation,
    String? errorMessage,
    String? outputPath,
  }) {
    return DatasetExportState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      currentOperation: currentOperation ?? this.currentOperation,
      errorMessage: errorMessage ?? this.errorMessage,
      outputPath: outputPath ?? this.outputPath,
    );
  }
}
