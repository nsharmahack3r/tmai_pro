import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/entity_models/trained_model/train.dart';
import 'package:tmai_pro/src/feature/train/controller/train_model_controller.dart';
import 'package:tmai_pro/src/feature/train/state/train_model_state.dart';

class TrainingMonitorView extends ConsumerStatefulWidget {
  const TrainingMonitorView({super.key, required this.config});

  static const routePath = "/train-monitor";

  final TrainModel config;

  @override
  ConsumerState<TrainingMonitorView> createState() =>
      _TrainingMonitorViewState();
}

class _TrainingMonitorViewState extends ConsumerState<TrainingMonitorView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(trainingControllerProvider.notifier)
          .startTraining(widget.config);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(trainingControllerProvider);
    final controller = ref.read(trainingControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Training in Progress"),
        actions: [
          if (state.isTraining)
            IconButton(
              icon: const Icon(Icons.stop_circle_outlined, color: Colors.red),
              onPressed: () => controller.stopTraining(),
              tooltip: "Abort Training",
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Progress Header
            _buildProgressHeader(state),
            const SizedBox(height: 20),

            // 2. The Charts (Loss & mAP)
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: _buildChartCard(
                      "Training Loss",
                      state.lossHistory,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildChartCard(
                      "mAP (Accuracy)",
                      state.mapHistory,
                      Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Logs Terminal
            Expanded(flex: 1, child: _buildLogTerminal(state.logs)),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressHeader(TrainingState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Epoch ${state.currentEpoch} / ${state.totalEpochs}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("${(state.progress * 100).toInt()}% Complete"),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: state.progress,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(String title, List<FlSpot> spots, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: spots.isEmpty
                  ? const Center(child: Text("Waiting for data..."))
                  : LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: true),
                        titlesData: const FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            color: color,
                            barWidth: 3,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: color.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogTerminal(List<String> logs) {
    // Auto-scroll to bottom logic would go here with a ScrollController
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Process Logs",
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const Divider(color: Colors.white24),
          Expanded(
            child: ListView.builder(
              reverse:
                  true, // Show newest logs at bottom (visually) or top depending on preference
              itemCount: logs.length,
              itemBuilder: (context, index) {
                // Reverse index to show latest at the bottom
                final log = logs[logs.length - 1 - index];
                return Text(
                  log,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: 'Courier',
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
