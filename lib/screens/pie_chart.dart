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
    return Scaffold(
      backgroundColor:  Color.fromRGBO(255, 236, 228, 1),
      appBar: AppBar(
        title:  Text(
          "Donut Chart",
          style: TextStyle(color: Color.fromARGB(255, 82, 54, 44)),
        ),
        backgroundColor:  Color.fromARGB(255, 198, 161, 148),
      ),
      body: Center(
        child: PieChart(
          PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 85,
            borderData: FlBorderData(show: false),
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                if (pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  return;
                }

                final index =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;

                setState(() {
                  if (touchedIndex != index) {
                    touchedIndex = index;
                  }
                });
              },
            ),
            sections: _buildSections(),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    final List<Color> colors = [
       Color(0xFF4E342E),
       Color(0xFF6F4E37),
       Color(0xFF8D6E63), 
       Color(0xFFA1887F),
       Color(0xFFCBB7A2),
       Color(0xFFE0C9B7),
    ];

    final List<double> values = [16.6, 16.6, 16.6, 16.6, 16.6, 16.6];

    final List<String> titles = [
      'Drink Water',
      'Exercise',
      'Read 10 mins',
      'Meditate',
      'Write Journal',
      'Sleep Early'
    ];

    return List.generate(6, (i) {
      final bool isTouched = i == touchedIndex;
      final double radius = isTouched ? 110 : 80;
      final Color textColor =
          (i >= 4) ? const Color(0xFF3E2723) : Colors.white;

      return PieChartSectionData(
        color: colors[i],
        value: values[i],
        title: titles[i],
        radius: radius,
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        titlePositionPercentageOffset: 0.6, 
      );
    });
  }
}
