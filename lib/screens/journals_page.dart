import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/journal_model.dart';
import 'package:image_picker/image_picker.dart';

class JournalsPage extends StatefulWidget {
  const JournalsPage({super.key});

  @override
  State<JournalsPage> createState() => _JournalsPageState();
}

class _JournalsPageState extends State<JournalsPage> {
  Box<JournalModel>? journalsBox;
  bool loading = true;
  String currentUser = '';

  @override
  void initState() {
    super.initState();
    loadUserBox();
  }

  Future<void> loadUserBox() async {
    final prefs = await SharedPreferences.getInstance();
    currentUser = prefs.getString('currentUser') ?? '';

    final String boxName = 'journals_$currentUser';

    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<JournalModel>(boxName);
    }

    journalsBox = Hive.box<JournalModel>(boxName);

    setState(() => loading = false);
  }

  void deleteJournalAt(int index) {
    journalsBox?.deleteAt(index);
  }

  Future<void> editJournalDialog(int index, JournalModel journal) async {
    final headingCtrl = TextEditingController(text: journal.heading);
    final notesCtrl = TextEditingController(text: journal.notes);
    DateTime selectedDate = journal.date;
    File? imageFile = journal.imagePath.isNotEmpty ? File(journal.imagePath) : null;
    final picker = ImagePicker();

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Journal'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: headingCtrl, decoration: const InputDecoration(labelText: 'Heading')),
                const SizedBox(height: 8),
                TextField(controller: notesCtrl, maxLines: 4, decoration: const InputDecoration(labelText: 'Notes')),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text("Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: ctx,
                          initialDate: selectedDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null) {
                          selectedDate = picked;
                          setState(() {});
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final picked = await picker.pickImage(source: ImageSource.gallery);
                    if (picked != null) {
                      imageFile = File(picked.path);
                      setState(() {});
                    }
                  },
                  child: Container(
                    height: 150,
                    color: const Color(0xFFF5E6D9),
                    child: imageFile != null ? Image.file(imageFile!, fit: BoxFit.cover) : const Center(child: Icon(Icons.add_a_photo)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                journal.heading = headingCtrl.text;
                journal.notes = notesCtrl.text;
                journal.date = selectedDate;
                journal.imagePath = imageFile?.path ?? '';
                journal.save();
                Navigator.pop(ctx);
                setState(() {});
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final box = journalsBox;
    return Scaffold(
      appBar: AppBar(title: const Text('Your Journals')),
      body: box == null || box.isEmpty
          ? const Center(child: Text('No journals yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: box.length,
              itemBuilder: (context, index) {
                final journal = box.getAt(index)!;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (journal.imagePath.isNotEmpty)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                          child: Image.file(File(journal.imagePath), height: 200, width: double.infinity, fit: BoxFit.cover),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(journal.heading, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text("${journal.date.day}/${journal.date.month}/${journal.date.year}", style: const TextStyle(color: Colors.brown)),
                            const SizedBox(height: 8),
                            Text(journal.notes),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(icon: const Icon(Icons.edit), onPressed: () => editJournalDialog(index, journal)),
                          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => deleteJournalAt(index))),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
