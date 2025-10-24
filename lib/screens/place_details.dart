import 'dart:io';
import 'package:flutter/material.dart';
import 'package:journally/models/place_model.dart';
import 'package:journally/screens/place_dialog.dart';

class PlaceDetailPage extends StatefulWidget {
  final PlaceModel place;
  final Function(PlaceModel) onUpdate;
  final VoidCallback onDelete;

  const PlaceDetailPage({
    required this.place,
    required this.onUpdate,
    required this.onDelete,
    super.key,
  });

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  late PlaceModel place;

  @override
  void initState() {
    super.initState();
    place = widget.place;
  }

  void _editPlace() async {
    final editedPlace = await showDialog<PlaceModel>(
      context: context,
      builder: (_) => AddPlaceDialog(existingPlace: place),
    );

    if (editedPlace != null) {
      setState(() => place = editedPlace);
      widget.onUpdate(editedPlace);
    }
  }

  void _deletePlace() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Place"),
        content: const Text("Are you sure you want to delete this place?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onDelete();
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 220, 237, 249),
        title: Text(place.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: _editPlace,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _deletePlace,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (place.imagePath.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(place.imagePath),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 24),
              if (place.notes.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(73, 167, 205, 204),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    place.notes,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF333333),
                      height: 1.5,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
