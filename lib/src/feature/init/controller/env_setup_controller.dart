// src/feature/init/controller/env_setup_controller.dart

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/feature/init/state/env_setup_state.dart';
import 'package:tmai_pro/src/utils/path_builder.dart';

const String _kRepoUrl = "https://github.com/nsharmahack3r/tmai_core.git";

final envSetupControllerProvider =
    StateNotifierProvider<EnvSetupController, EnvSetupState>(
      (ref) => EnvSetupController(),
    );

class EnvSetupController extends StateNotifier<EnvSetupState> {
  EnvSetupController() : super(EnvSetupState.initial()) {
    // Optional: Automatically start setup on creation
    // init();
  }

  Future<void> init() async {
    // 1. Reset State
    state = state.copyWith(
      ready: false,
      message: "Initializing engine...",
      progress: 0.05,
      error: null,
    );

    try {
      final envPath = await PathBuilder.globalEnvPath();
      final repoPath = await PathBuilder.globalRepoPath();

      // --- STEP 1: Python Venv Setup (30%) ---
      await _setupVenv(envPath);

      // --- STEP 2: Git Repo Setup (60%) ---
      await _setupRepo(repoPath);

      // --- STEP 3: Dependencies (90%) ---
      await _installDependencies(envPath, repoPath);

      // --- STEP 4: Finish ---
      state = state.copyWith(
        ready: true,
        message: "TMAI Engine Ready",
        progress: 1.0,
      );
    } catch (e) {
      state = state.copyWith(
        ready: false,
        error: e.toString(),
        message: "Setup Failed",
        progress: 0.0,
      );
    }
  }

  Future<void> _setupVenv(String envPath) async {
    state = state.copyWith(
      message: "Checking Python Environment...",
      progress: 0.1,
    );

    // Check if python executable exists in the target venv folder
    final pythonExe = '$envPath\\Scripts\\python.exe';
    if (await File(pythonExe).exists()) {
      state = state.copyWith(message: "Environment found.", progress: 0.3);
      return;
    }

    state = state.copyWith(
      message: "Creating virtual environment...",
      progress: 0.2,
    );

    // We assume 'python' is in the global Windows PATH.
    // If not, you might need to bundle a standalone python zip.
    final result = await Process.run('python', ['-m', 'venv', envPath]);

    if (result.exitCode != 0) {
      throw Exception("Failed to create venv: ${result.stderr}");
    }

    state = state.copyWith(progress: 0.3);
  }

  Future<void> _setupRepo(String repoPath) async {
    state = state.copyWith(
      message: "Checking training scripts...",
      progress: 0.4,
    );

    final bool isGitRepo = await Directory('$repoPath\\.git').exists();

    if (!isGitRepo) {
      // Clone
      state = state.copyWith(message: "Downloading scripts...", progress: 0.5);

      // Ensure directory exists
      await Directory(repoPath).create(recursive: true);

      final result = await Process.run('git', ['clone', _kRepoUrl, repoPath]);
      if (result.exitCode != 0) {
        throw Exception("Git clone failed: ${result.stderr}");
      }
    } else {
      // Pull updates
      state = state.copyWith(message: "Updating scripts...", progress: 0.5);

      final result = await Process.run('git', ['-C', repoPath, 'pull']);
      if (result.exitCode != 0) {
        // We don't throw here, just log warning, in case user is offline
        print("Warning: Git pull failed (offline?): ${result.stderr}");
      }
    }

    state = state.copyWith(progress: 0.6);
  }

  Future<void> _installDependencies(String envPath, String repoPath) async {
    state = state.copyWith(
      message: "Installing dependencies (this may take a while)...",
      progress: 0.7,
    );

    final pipExe = '$envPath\\Scripts\\pip.exe';
    final requirements = '$repoPath\\requirements.txt';

    // Verify requirements file exists
    if (!await File(requirements).exists()) {
      throw Exception("requirements.txt not found at $requirements");
    }

    // Run pip install
    final result = await Process.run(pipExe, ['install', '-r', requirements]);

    if (result.exitCode != 0) {
      throw Exception("Pip install failed: ${result.stderr}");
    }

    state = state.copyWith(progress: 0.9);
  }
}
