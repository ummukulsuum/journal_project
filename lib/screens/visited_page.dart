import 'dart:io';
import 'package:flutter/material.dart';
import 'package:journally/main.dart';
import 'package:journally/screens/place_details.dart';

class VisitedPage extends StatelessWidget {
  const VisitedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final visitedPlaces = placesBox.values
        .where((place) => place.isVisited == true)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70), 
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 195, 204, 213),
          title: Image.asset(
            'assets/images/Adobe Express - file (4).png',
            width: 150,
            height: 80,
          ),
        ),
      ),
      body: visitedPlaces.isEmpty
          ? const Center(
              child: Text(
                "No visited places yet",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: visitedPlaces.length,
                itemBuilder: (context, index) {
                  final place = visitedPlaces[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: place.imagePath.isNotEmpty
                            ? Image.file(
                                File(place.imagePath),
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.white70,
                                ),
                              ),
                      ),
                      title: Text(
                        place.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlaceDetailPage(
                              place: place,
                              onUpdate: (updatedPlace) {
                                final index = place.key;
                                placesBox.put(index, updatedPlace);
                              },
                              onDelete: () {
                                placesBox.delete(place.key);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
