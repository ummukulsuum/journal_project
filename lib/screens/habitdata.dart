import 'package:flutter/material.dart';

class HabitData {
  // Current values for each habit
  static Map<String, Map<String, dynamic>> habits = {
    "Code Practice": {"type": "count", "value": 0},
    "Read Docs": {"type": "time", "value": 0},
    "Push Commits": {"type": "count", "value": 0},
    "Daily Standup": {"type": "time", "value": 0},
    "Refactor Code": {"type": "count", "value": 0},
    "Learn New Tech": {"type": "time", "value": 0},
    "Write Documentation": {"type": "count", "value": 0},
    "Debugging": {"type": "count", "value": 0},
    "Take Break": {"type": "time", "value": 0},
  };

  static Map<String, Map<String, dynamic>> habitDetails = {
    "Code Practice": {"icon": Icons.code, "color": Color.fromARGB(255, 85, 53, 42)},
    "Read Docs": {"icon": Icons.menu_book, "color": Color(0xFFBCAAA4)},
    "Push Commits": {"icon": Icons.cloud_upload, "color": Color(0xFFA1887F)},
    "Daily Standup": {"icon": Icons.group, "color": Color(0xFF8D6E63)},
    "Refactor Code": {"icon": Icons.build, "color": Color(0xFF795548)},
    "Learn New Tech": {"icon": Icons.lightbulb, "color": Color(0xFF6D4C41)},
    "Write Documentation": {"icon": Icons.edit_note, "color": Color(0xFF5D4037)},
    "Debugging": {"icon": Icons.bug_report, "color": Color(0xFF4E342E)},
    "Take Break": {"icon": Icons.coffee, "color": Color(0xFF3E2723)},
  };
}
