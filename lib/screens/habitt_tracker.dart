import 'package:flutter/material.dart';
import 'package:journally/screens/habitdata.dart';
import 'package:journally/screens/pie_chart.dart';

class HabitTrackerPage extends StatefulWidget {
  const HabitTrackerPage({super.key});

  @override
  State<HabitTrackerPage> createState() => _HabitTrackerPageState();
}

class _HabitTrackerPageState extends State<HabitTrackerPage> {
  @override
  Widget build(BuildContext context) {
    final titles = HabitData.habits.keys.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EC),
      appBar: AppBar(
        backgroundColor: Colors.brown[700],
        title: const Text(
          "Habit Tracker",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.pie_chart),
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (_) => PieChartPage(
        //             onReturn: () => setState(() {}), // Refresh after returning
        //           ),
        //         ),
        //       );
        //     },
        //   )
        // ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: titles.length,
        itemBuilder: (context, index) {
          final title = titles[index];
          final icon = HabitData.habitDetails[title]!['icon'] as IconData;
          final color = HabitData.habitDetails[title]!['color'] as Color;
          final type = HabitData.habits[title]!['type'] as String;

          return HabitCard(title, icon, color, type);
        },
      ),
    );
  }

  Widget HabitCard(String title, IconData icon, Color color, String type) {
    final value = HabitData.habits[title]!['value'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.brown,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (value > 0) {
                      HabitData.habits[title]!['value'] =
                          value - (type == 'count' ? 1 : 5);
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(8),
                  backgroundColor: const Color.fromARGB(255, 212, 199, 194),
                  elevation: 0,
                ),
                child: Icon(Icons.remove, color: Colors.brown[700]),
              ),
              const SizedBox(width: 12),
              // Show current habit value
              Text(
                "$value",
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    HabitData.habits[title]!['value'] =
                        value + (type == 'count' ? 1 : 5);
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(8),
                  backgroundColor: const Color.fromARGB(255, 212, 199, 194),
                  elevation: 0,
                ),
                child: Icon(Icons.add, color: Colors.brown[700]),
              ),
            ],
          )
        ],
      ),
    );
  }
}
