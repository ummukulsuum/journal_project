import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:journally/main.dart'; // for placesBox

class PieChartPage extends StatelessWidget {
  const PieChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get data from Hive
    final allPlaces = placesBox.values.toList();

    final visitedCount = allPlaces.where((p) => p.isVisited == true).length;
    final unvisitedCount = allPlaces.where((p) => p.isVisited == false).length;
    final wishlistCount = allPlaces.where((p) => p.isFavourite == true).length;

    final total = visitedCount + unvisitedCount + wishlistCount;

    if (total == 0) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Travel Summary'),
          backgroundColor: const Color.fromARGB(255, 195, 204, 213),
        ),
        body: const Center(
          child: Text(
            "No data available yet.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: const Text(
          "Travel Summary",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: const Color.fromARGB(255, 195, 204, 213),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 280,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      color: Colors.blue.shade900, // Dark Blue for Visited
                      value: visitedCount.toDouble(),
                      title: "Visited\n$visitedCount",
                      radius: 80,
                      titleStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: Colors.blueGrey.shade600, // Medium Gray-Blue for Unvisited
                      value: unvisitedCount.toDouble(),
                      title: "Unvisited\n$unvisitedCount",
                      radius: 80,
                      titleStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: Colors.blueGrey.shade300, // Light Gray-Blue for Wishlist
                      value: wishlistCount.toDouble(),
                      title: "Wishlist\n$wishlistCount",
                      radius: 80,
                      titleStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Tap a section to see details",
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
