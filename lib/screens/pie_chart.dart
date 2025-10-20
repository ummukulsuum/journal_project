import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:journally/screens/habitdata.dart';

class PieChartPage extends StatefulWidget {
  final VoidCallback? onReturn;

  const PieChartPage({super.key, this.onReturn});

  @override
  State<PieChartPage> createState() => _PieChartPageState();
}

class _PieChartPageState extends State<PieChartPage> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    List<String> titles = HabitData.habits.keys.toList();
    List<Color> colors = titles
        .map((title) => HabitData.habitDetails[title]!['color'] as Color)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFECE4),
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text(
          "Habit Pie Chart",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.onReturn?.call();
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                height: 350,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 70.0,
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        if (response == null || response.touchedSection == null)
                          return;
                        setState(() {
                          touchedIndex =
                              response.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    sections: buildSections(titles, colors),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: titles.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: colors[i],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          titles[i],
                          style: const TextStyle(
                              fontSize: 14, color: Colors.brown),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${HabitData.habits[titles[i]]!['value']}',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> buildSections(List<String> titles, List<Color> colors) {
    return List.generate(titles.length, (i) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? 110.0 : 80.0; // Make sure it's double
      final value = HabitData.habits[titles[i]]!['value'] as int;

      return PieChartSectionData(
        color: colors[i],
        value: value.toDouble(),
        radius: radius,
        title: '',
      );
    });
  }
}
