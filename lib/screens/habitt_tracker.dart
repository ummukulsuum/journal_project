import 'package:flutter/material.dart';

class HabitTrackerPage extends StatefulWidget {
  const HabitTrackerPage({super.key});

  @override
  State<HabitTrackerPage> createState() => _HabitTrackerPageState();
}

class _HabitTrackerPageState extends State<HabitTrackerPage> {
   Map<String, bool> habits = {
    "Drink Water": false,
    "Exercise": false,
    "Read 10 mins": false,
    "Meditate": false,
    "Write Journal": false,
    "Sleep Early": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Habit Tracker",
          style: TextStyle(
            color: Color.fromARGB(255, 82, 54, 44),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 201, 166, 137),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg(6).jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Build your best self, one habit at a time ✨",
              style: TextStyle(fontSize: 16, color: Colors.brown),
            ),
            const SizedBox(height: 4),
            Text(
              "Today, September 21",
              style: TextStyle(fontSize: 14, color: Colors.brown.shade400),
            ),
            const SizedBox(height: 16),
            HabitCard(Icons.water_drop, Colors.blue, "Drink Water"),
            HabitCard(Icons.fitness_center, Colors.brown, "Exercise"),
            HabitCard(Icons.book, Colors.brown, "Read 10 mins"),
            HabitCard(Icons.self_improvement, Colors.green, "Meditate"),
            HabitCard(Icons.edit_note, Colors.orange, "Write Journal"),
            HabitCard(Icons.bedtime, Colors.purple, "Sleep Early"),
             SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget HabitCard(IconData icon, Color iconColor, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 28),
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
          const SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                value: habits[title],
                onChanged: (value) {
                  setState(() {
                    habits[title] = value ?? false;
                  });
                },
                activeColor: Colors.brown,
              ),
              const SizedBox(width: 8),
              Text(
                habits[title]! ? "Completed" : "Mark as done",
                style: TextStyle(
                  color: habits[title]! ? Colors.green : Colors.brown,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
