import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/feature/init/controller/env_setup_controller.dart';
import 'package:tmai_pro/src/feature/init/state/env_setup_state.dart';
import 'package:tmai_pro/src/resource/assets.gen.dart';

class DependencyInstallationPage extends ConsumerWidget {
  const DependencyInstallationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the state for UI rebuilds
    final EnvSetupState state = ref.watch(envSetupControllerProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 1. Header / Logo Area
            const SizedBox(height: 24),

            Row(
              children: [
                Assets.icon.icon.image(width: 60),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "TMAI Engine Setup",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      state.message ?? "Initializing...",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: state.hasError ? Colors.red : Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),

            // 3. Progress Indicator or Error Action
            if (state.hasError)
              _buildErrorAction(state.error, ref)
            else
              _buildProgressSection(state),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(EnvSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        LinearProgressIndicator(
          value: state.progress,
          backgroundColor: Colors.grey[200],
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 12),
        Text(
          "${(state.progress * 100).toInt()}%",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorAction(String? error, WidgetRef ref) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red[100]!),
          ),
          child: Text(
            error ?? "Unknown error occurred",
            style: const TextStyle(color: Colors.red, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            // Retry the initialization
            ref.read(envSetupControllerProvider.notifier).init();
          },
          icon: const Icon(Icons.refresh),
          label: const Text("Retry Setup"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }
}

// Extension to make state checks cleaner
extension EnvSetupStateExt on EnvSetupState {
  bool get hasError => error != null && error!.isNotEmpty;
}
