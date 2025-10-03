import 'package:flutter/material.dart';

Widget journals() {
  return Column(
    children: [
      Container(
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFFD7CCC8), // light brown
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      const SizedBox(height: 16),
      Container(
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFFBCAAA4), // medium brown
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      const SizedBox(height: 16),
      Container(
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFFA1887F), // soft brown
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      const SizedBox(height: 16),
      Container(
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFF8D6E63), // warm brown
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      const SizedBox(height: 16),
      Container(
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFF6D4C41), // deep brown
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ],
  );
}
