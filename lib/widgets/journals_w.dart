import 'package:flutter/material.dart';

Widget journals() {
  return Column(
    children: [
      journalCard(Color(0xFFD7CCC8)),
      SizedBox(height: 16),
      journalCard(Color(0xFFBCAAA4)),
      SizedBox(height: 16),
      journalCard(Color(0xFFA1887F)),
      SizedBox(height: 16),
      journalCard(Color(0xFF8D6E63)),
      SizedBox(height: 16),
      journalCard(Color(0xFF6D4C41)),
    ],
  );
}

Widget journalCard(Color color) {
  return Stack(
    children: [
      Container(
        height: 420,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      Positioned(
        top: 8,
        right: 8,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white, size: 24),
              onPressed: () {
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white, size: 24),
              onPressed: () {
              },
            ),
          ],
        ),
      ),
    ],
  );
}
