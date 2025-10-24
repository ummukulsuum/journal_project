import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:journally/models/journal_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class JournalsPage extends StatefulWidget {
  const JournalsPage({super.key, required String currentUserId});

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
    currentUser = prefs.getString('currentUser') ?? 'defaultUser';

    final String boxName = 'journals_$currentUser';
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<JournalModel>(boxName);
    }

    journalsBox = Hive.box<JournalModel>(boxName);
    setState(() => loading = false);
  }

  void deleteJournalAt(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text(
          'Delete Journal',
          style: TextStyle(color: Color.fromARGB(255, 18, 81, 133)),
        ),
        content: const Text(
          'Are you sure you want to delete this journal?',
          style: TextStyle(color: Color.fromARGB(255, 18, 81, 133)),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color.fromARGB(255, 18, 81, 133)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 220, 237, 249),
            ),

            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      journalsBox?.deleteAt(index);
      setState(() {});
    }
  }

  Future<void> editJournalDialog(int index, JournalModel journal) async {
    final headingCtrl = TextEditingController(text: journal.heading);
    final notesCtrl = TextEditingController(text: journal.notes);
    DateTime selectedDate = journal.date;
    File? imageFile = journal.imagePath.isNotEmpty
        ? File(journal.imagePath)
        : null;
    final picker = ImagePicker();

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Edit Journal',
              style: TextStyle(color: Color.fromARGB(255, 18, 81, 133)),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: headingCtrl,
                      decoration: InputDecoration(
                        labelText: 'Heading',
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 18, 81, 133),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 18, 81, 133),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: notesCtrl,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Notes',
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 18, 81, 133),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 18, 81, 133),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 18, 81, 133),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.calendar_today,
                            color: Color.fromARGB(255, 18, 81, 133),
                          ),
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: ctx,
                              initialDate: selectedDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null) {
                              setStateDialog(() => selectedDate = picked);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final picked = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (picked != null) {
                          setStateDialog(() => imageFile = File(picked.path));
                        }
                      },
                      child: SizedBox(
                        height: 150,

                        child: imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  imageFile!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                            : const Center(
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Color.fromARGB(255, 18, 81, 133),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color.fromARGB(255, 18, 81, 133)),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 220, 237, 249),
                ),
                onPressed: () {
                  journal.heading = headingCtrl.text;
                  journal.notes = notesCtrl.text;
                  journal.date = selectedDate;
                  journal.imagePath = imageFile?.path ?? '';
                  journal.save();
                  Navigator.pop(ctx);
                  setState(() {});
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Color.fromARGB(255, 18, 81, 133)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final box = journalsBox;
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
      body: box == null || box.isEmpty
          ? const Center(
              child: Text(
                'No journals yet',
                style: TextStyle(color: Color.fromARGB(255, 11, 44, 71)),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: box.length,
              itemBuilder: (context, index) {
                final journal = box.getAt(index)!;
                final hasImage =
                    journal.imagePath.isNotEmpty &&
                    File(journal.imagePath).existsSync();

                return Card(
                  color:Color.fromARGB(255, 195, 204, 213),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasImage)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.file(
                            File(journal.imagePath),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              journal.heading,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 11, 49, 80),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${journal.date.day}/${journal.date.month}/${journal.date.year}",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 12, 54, 88),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              journal.notes,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 11, 50, 83),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Color.fromARGB(255, 18, 81, 133),
                            ),
                            onPressed: () => editJournalDialog(index, journal),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Color.fromARGB(255, 18, 81, 133),
                            ),
                            onPressed: () => deleteJournalAt(index),
                          ),
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
