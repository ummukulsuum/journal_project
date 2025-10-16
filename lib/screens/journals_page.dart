import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:journally/models/journal_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class JournalsPage extends StatefulWidget {
  const JournalsPage({super.key});

  @override
  State<JournalsPage> createState() => _JournalsPageState();
}

class _JournalsPageState extends State<JournalsPage> {
  late Box<JournalModel> journalsBox;

  @override
  void initState() {
    super.initState();
    journalsBox = Hive.box<JournalModel>('journalsBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE6),
      appBar: AppBar(
        title: const Text("Your Journals"),
        backgroundColor: const Color(0xFFF5EDE6),
        elevation: 0,
      ),
      body: ValueListenableBuilder(
        valueListenable: journalsBox.listenable(),
        builder: (context, Box<JournalModel> box, _) {
          if (box.values.isEmpty) {
            return const Center(child: Text("No journals yet"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: box.length,
            itemBuilder: (context, index) {
              final journal = box.getAt(index)!;
              return _buildJournalCard(journal, index);
            },
          );
        },
      ),
    );
  }

  // ✅ Journal card widget
  Widget _buildJournalCard(JournalModel journal, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFD7CCC8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🖼 Image
              if (journal.imagePath.isNotEmpty)
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.file(
                    File(journal.imagePath),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      journal.heading,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${journal.date.day}/${journal.date.month}/${journal.date.year}",
                      style: const TextStyle(color: Colors.brown),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      journal.notes,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 🗑 Delete + ✏️ Edit Buttons
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () => _editJournal(context, journal, index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () {
                    journal.delete();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✏️ Edit journal dialog
  Future<void> _editJournal(
      BuildContext context, JournalModel journal, int index) async {
    final TextEditingController headingController =
        TextEditingController(text: journal.heading);
    final TextEditingController notesController =
        TextEditingController(text: journal.notes);
    DateTime selectedDate = journal.date;
    File? imageFile = File(journal.imagePath);
    final picker = ImagePicker();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Journal"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 📅 Date Picker
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null) {
                          setState(() => selectedDate = picked);
                        }
                      },
                    ),
                  ],
                ),

                // 📝 Heading
                TextField(
                  controller: headingController,
                  decoration: const InputDecoration(labelText: "Heading"),
                ),

                // 🖼 Image Picker
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() => imageFile = File(pickedFile.path));
                    }
                  },
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    color: const Color(0xFFF5E6D9),
                    child: imageFile == null
                        ? const Center(child: Text("Tap to pick image"))
                        : Image.file(imageFile!, fit: BoxFit.cover),
                  ),
                ),

                // ✏️ Notes
                const SizedBox(height: 10),
                TextField(
                  controller: notesController,
                  maxLines: 5,
                  decoration: const InputDecoration(labelText: "Notes"),
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
                // Update data in Hive
                journal.heading = headingController.text;
                journal.notes = notesController.text;
                journal.date = selectedDate;
                journal.imagePath = imageFile!.path;

                journal.save(); // 🔥 Saves changes to Hive
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
