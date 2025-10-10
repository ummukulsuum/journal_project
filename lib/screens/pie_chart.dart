import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartPage extends StatefulWidget {
  const PieChartPage({super.key});

  @override
  State<PieChartPage> createState() => _PieChartPageState();
}

class _PieChartPageState extends State<PieChartPage> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
     List<Color> colors = [
       Color(0xFF4E342E),
       Color(0xFF6F4E37),
       Color(0xFF8D6E63),
       Color(0xFFA1887F),
       Color(0xFFCBB7A2),
       Color(0xFFE0C9B7),
    ];

    List<String> titles = [
      'Drink water',
      'Exercise',
      'Read 10 mins',
      'Meditate',
      'Write journal',
      'Sleep early'
    ];

    return Scaffold(
      backgroundColor:  Color.fromRGBO(255, 236, 228, 1),
      appBar: AppBar(
        title:  Text(
          "Donut Chart",
          style: TextStyle(color: Color.fromARGB(255, 82, 54, 44)),
        ),
        backgroundColor:  Color.fromARGB(255, 198, 161, 148),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                height: 300,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 70,
                    borderData: FlBorderData(show: false),
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        if (pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          return;
                        }

                        final index = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;

                        setState(() {
                          touchedIndex = index;
                        });
                      },
                    ),
                    sections: buildSections(colors),
                  ),
                ),
              ),
            ),
             SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(titles.length, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
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
                       SizedBox(width: 10),
                      Text(
                        titles[i],
                        style:  TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> buildSections(List<Color> colors) {
    final List<double> values = [16.6, 16.6, 16.6, 16.6, 16.6, 16.6];

    return List.generate(6, (i) {
      final bool isTouched = i == touchedIndex;
      final double radius = isTouched ? 110 : 80;

      return PieChartSectionData(
        color: colors[i],
        value: values[i],
        radius: radius,
        showTitle: false,
      );
    });
  }
}
