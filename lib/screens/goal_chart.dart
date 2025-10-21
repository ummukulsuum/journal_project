import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:journally/models/goal_model.dart';
import 'package:fl_chart/fl_chart.dart';

class GoalChartPage extends StatelessWidget {
  final String currentUserId;
  const GoalChartPage({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    if (!Hive.isBoxOpen('goals_$currentUserId')) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final goalBox = Hive.box<GoalModel>('goals_$currentUserId');

    const Color completedColor = Color(0xFF8B5E3C);
    const Color pendingColor = Color(0xFFD2B48C);
    const Color backgroundColor = Color(0xFFF6F1ED);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Goal Progress", style: TextStyle(color: Color.fromARGB(255, 255, 239, 233))),
        backgroundColor: completedColor,
        centerTitle: true,
        elevation: 2,
      ),
      body: ValueListenableBuilder(
        valueListenable: goalBox.listenable(),
        builder: (context, Box<GoalModel> box, _) {
          final goals = box.values.toList();
          final total = goals.length;
          final completed = goals.where((g) => g.isCompleted).length;
          final pending = total - completed;

          if (total == 0) {
            return const Center(child: Text("No goals yet — add some first!", style: TextStyle(color: Colors.grey)));
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Your Progress Overview", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 40),
                SizedBox(
                  width: 250,
                  height: 250,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(value: completed.toDouble(), color: completedColor, title: "Done", radius: 60, titleStyle: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        PieChartSectionData(value: pending.toDouble(), color: pendingColor, title: "Pending", radius: 60, titleStyle: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                      centerSpaceRadius: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_legendItem(completedColor, "Completed"), const SizedBox(width: 20), _legendItem(pendingColor, "Pending")],
                ),
                const SizedBox(height: 30),
                Text("Completed: $completed / $total goals", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 15, color: Colors.black87)),
      ],
    );
  }
}
