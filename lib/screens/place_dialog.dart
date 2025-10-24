import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:journally/models/place_model.dart';

class AddPlaceDialog extends StatefulWidget {
  final PlaceModel? existingPlace;
  const AddPlaceDialog({this.existingPlace, super.key});

  @override
  State<AddPlaceDialog> createState() => _AddPlaceDialogState();
}

class _AddPlaceDialogState extends State<AddPlaceDialog> {
  late TextEditingController nameCtrl;
  late TextEditingController notesCtrl;
  File? imageFile;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.existingPlace?.name ?? "");
    notesCtrl = TextEditingController(text: widget.existingPlace?.notes ?? "");
    if (widget.existingPlace?.imagePath.isNotEmpty == true) {
      imageFile = File(widget.existingPlace!.imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existingPlace == null ? "Add New Place" : "Edit Place"),
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
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final picked =
                    await picker.pickImage(source: ImageSource.gallery);
                if (picked != null) setState(() => imageFile = File(picked.path));
              },
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12)),
                child: imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(imageFile!, fit: BoxFit.cover))
                    : const Center(child: Icon(Icons.add_a_photo, size: 40)),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (nameCtrl.text.isNotEmpty) {
              final newPlace = PlaceModel(
                name: nameCtrl.text,
                notes: notesCtrl.text,
                imagePath: imageFile?.path ?? "",
                dateAdded: widget.existingPlace?.dateAdded ?? DateTime.now(),
                visited: widget.existingPlace?.visited ?? false,
                isFavourite: widget.existingPlace?.isFavourite ?? false, // ✅ FIXED
              );
              Navigator.pop(context, newPlace);
            }
          },
          child: Text(widget.existingPlace == null ? "Add" : "Save"),
        ),
      ],
    );
  }
}
