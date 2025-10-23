import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PlaceModel {
  String name;
  String notes;
  String imagePath;

  PlaceModel({
    required this.name,
    required this.notes,
    required this.imagePath,
  });
}

class PlacesPage extends StatefulWidget {
  const PlacesPage({super.key});

  @override
  State<PlacesPage> createState() => _PlacesPageState();
}

class _PlacesPageState extends State<PlacesPage> {
  List<PlaceModel> places = [];

  Future<void> _addPlaceDialog() async {
    final nameCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    File? imageFile;
    final picker = ImagePicker();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add New Place"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Place Name"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: notesCtrl,
                decoration: const InputDecoration(labelText: "Notes"),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final picked =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() {
                      imageFile = File(picked.path);
                    });
                  }
                },
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(imageFile!, fit: BoxFit.cover),
                        )
                      : const Center(child: Icon(Icons.add_a_photo, size: 40)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.isNotEmpty) {
                  final newPlace = PlaceModel(
                    name: nameCtrl.text,
                    notes: notesCtrl.text,
                    imagePath: imageFile?.path ?? "",
                  );
                  setState(() {
                    places.add(newPlace);
                  });
                  Navigator.pop(ctx);
                }
              },
              child: const Text("Add")),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    if (places.isEmpty) {
      return const Center(
        child: Text(
          "No places added yet",
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: places.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final place = places[index];
        return Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          shadowColor: Colors.grey.withOpacity(0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: place.imagePath.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)),
                        child: Image.file(
                          File(place.imagePath),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF0B3D91),
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12)),
                        ),
                        child: const Icon(Icons.location_on,
                            size: 40, color: Colors.white),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(place.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(place.notes,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              places.remove(place);
                            });
                          },
                          icon: const Icon(Icons.delete,
                              size: 20, color: Colors.red)),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0), 
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 220, 237, 249),
        title: Image.asset(
          'assets/images/Adobe Express - file (4).png',
          width: 120,  
          height: 40, 
        ),
      ),
      body: _buildGrid(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPlaceDialog,
        backgroundColor: const Color(0xFF0B3D91),
        child: const Icon(Icons.add),
      ),
    );
  }
}
