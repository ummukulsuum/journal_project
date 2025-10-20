
import 'package:flutter/material.dart';

class HabitTrackerPage extends StatefulWidget {
  const HabitTrackerPage({super.key});

  @override
  State<HabitTrackerPage> createState() => _HabitTrackerPageState();
}

class _HabitTrackerPageState extends State<HabitTrackerPage> {
  // Each habit now has type (count/time) and value
  Map<String, Map<String, dynamic>> habits = {
    "Drink Water": {"type": "count", "value": 0},
    "Exercise": {"type": "time", "value": 0},
    "Read 10 mins": {"type": "time", "value": 0},
    "Meditate": {"type": "time", "value": 0},
    "Write Journal": {"type": "count", "value": 0},
    "Steps Walked": {"type": "count", "value": 0},
    "Push Ups": {"type": "count", "value": 0},
  };

  final Map<String, dynamic> habitDetails = {
    "Drink Water": {"icon": Icons.water_drop, "color": Colors.blue},
    "Exercise": {"icon": Icons.fitness_center, "color": Colors.redAccent},
    "Read 10 mins": {"icon": Icons.book, "color": Colors.orange},
    "Meditate": {"icon": Icons.self_improvement, "color": Colors.green},
    "Write Journal": {"icon": Icons.edit_note, "color": Colors.brown},
    "Steps Walked": {"icon": Icons.directions_walk, "color": Colors.purple},
    "Push Ups": {"icon": Icons.sports_gymnastics, "color": Colors.indigo},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 214, 202),
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text(
          "Habit Tracker",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: habits.length,
        itemBuilder: (context, index) {
          String title = habits.keys.elementAt(index);
          IconData icon = habitDetails[title]["icon"];
          Color color = habitDetails[title]["color"];
          String type = habits[title]!["type"];

          return HabitCard(title, icon, color, type);
        },
      ),
    );
  }

  Widget HabitCard(String title, IconData icon, Color color, String type) {
    int value = habits[title]!["value"];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 3,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Icon + Title
          Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Row 2: Counter or Time Tracker
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                type == "count" ? "Count: $value" : "Time: $value min",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.brown,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    color: Colors.brown,
                    onPressed: () {
                      setState(() {
                        if (value > 0) {
                          habits[title]!["value"] =
                              value - (type == "count" ? 1 : 5);
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    color: Colors.brown,
                    onPressed: () {
                      setState(() {
                        habits[title]!["value"] =
                            value + (type == "count" ? 1 : 5);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
