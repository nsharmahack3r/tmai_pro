import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/feature/init/controller/env_setup_controller.dart';

class InitController {
  InitController({required Ref ref}) : _ref = ref;
  final Ref _ref;

  Future<void> init() async {
    _ref.read(envSetupControllerProvider.notifier).init();
  }
}

// Simple provider to access the controller
final initControllerProvider = Provider((ref) => InitController(ref: ref));
