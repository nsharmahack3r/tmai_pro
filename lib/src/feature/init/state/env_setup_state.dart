class EnvSetupState {
  final bool ready;
  final String? error;
  final String? message;
  final double progress; // goes from 0.0 to 1.0

  EnvSetupState({
    required this.ready,
    this.error,
    this.message,
    this.progress = 0.0,
  });

  EnvSetupState copyWith({
    bool? ready,
    String? error,
    String? message,
    double? progress,
  }) {
    return EnvSetupState(
      ready: ready ?? this.ready,
      error: error ?? this.error,
      message: message ?? this.message,
      progress: progress ?? this.progress,
    );
  }

  factory EnvSetupState.initial() => EnvSetupState(ready: false, progress: 0.0);
}
