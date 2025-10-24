import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:journally/models/place_model.dart';
import 'package:journally/screens/place_dialog.dart';
import 'package:journally/screens/place_details.dart';

class PlacesPage extends StatefulWidget {
  const PlacesPage({super.key});

  @override
  State<PlacesPage> createState() => _PlacesPageState();
}

class _PlacesPageState extends State<PlacesPage> {
  Box<PlaceModel>? placesBox;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadPlaces();
  }

  Future<void> loadPlaces() async {
    placesBox = await Hive.openBox<PlaceModel>('placesBox');
    setState(() {
      loading = false;
    });
  }

  void _openAddPlaceDialog({PlaceModel? existingPlace, int? index}) async {
    if (placesBox == null) return;

    final newPlace = await showDialog<PlaceModel>(
      context: context,
      builder: (ctx) => AddPlaceDialog(existingPlace: existingPlace),
    );

    if (newPlace != null) {
      if (existingPlace != null && index != null) {
        await placesBox!.putAt(index, newPlace);
      } else {
        await placesBox!.add(newPlace);
      }
      setState(() {});
    }
  }

  void _deletePlace(int index) async {
    await placesBox!.deleteAt(index);
    setState(() {});
  }

  Widget _buildGrid() {
    if (placesBox == null || placesBox!.isEmpty) {
      return const Center(
        child: Text("No places added yet", style: TextStyle(fontSize: 16)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: placesBox!.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final place = placesBox!.getAt(index)!;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PlaceDetailPage(
                  place: place,
                  onUpdate: (updatedPlace) =>
                      _openAddPlaceDialog(existingPlace: place, index: index),
                  onDelete: () => _deletePlace(index),
                ),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            shadowColor: Colors.grey.withOpacity(0.3),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: place.imagePath.isNotEmpty
                      ? Image.file(
                          File(place.imagePath),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : Container(
                          color: const Color(0xFF0B3D91),
                          child: const Icon(
                            Icons.location_on,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                ),
                Positioned(
                  bottom: 5,
                  left: 13,
                  child: Text(
                    place.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black54,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 45,
                  child: GestureDetector(
                    onTap: () async {
                      place.isFavourite = !place.isFavourite;
                      await place.save();
                      setState(() {});
                    },
                    child: Icon(
                      place.isFavourite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: const Color.fromARGB(255, 179, 57, 57),
                      size: 24,
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 2,
                  child: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        _openAddPlaceDialog(existingPlace: place, index: index);
                      } else if (value == 'delete') {
                        _deletePlace(index);
                      } else if (value == 'visited') {
                        place.visited = true;
                        await place.save();
                        setState(() {});
                      } else if (value == 'unvisited') {
                        place.visited = false;
                        await place.save();
                        setState(() {});
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                      PopupMenuItem(value: 'visited', child: Text('Mark as Visited')),
                      PopupMenuItem(value: 'unvisited', child: Text('Mark as Unvisited')),
                    ],
                    icon: const Icon(
                      Icons.more_vert,
                      size: 20,
                      color: Color.fromARGB(255, 68, 75, 105),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: PreferredSize(
        preferredSize:  Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 195, 204, 213),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/Adobe Express - file (4).png',
                width: 150,
                height: 60,
              ),
            ],
          ),
        ),
      ),
      body: _buildGrid(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddPlaceDialog(),
        backgroundColor: const Color(0xFF0B3D91),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
