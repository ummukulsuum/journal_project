import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:journally/models/journal_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  File? image;
  final picker = ImagePicker();

  final TextEditingController headingController = TextEditingController();
  final TextEditingController textController = TextEditingController();

  late Box<JournalModel> journalsBox;
  String currentUser = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentUserAndBox();
  }

  Future<void> _loadCurrentUserAndBox() async {
    final prefs = await SharedPreferences.getInstance();
    currentUser = prefs.getString('currentUser') ?? '';
    journalsBox = await Hive.openBox<JournalModel>('journals_$currentUser');
    setState(() {});
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => image = File(pickedFile.path));
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  void saveJournal() async {
    if (headingController.text.isEmpty || textController.text.isEmpty || image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final journal = JournalModel(
      date: selectedDate,
      heading: headingController.text,
      imagePath: image!.path,
      notes: textController.text,
    );

    await journalsBox.add(journal);

    headingController.clear();
    textController.clear();
    setState(() => image = null);

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const Bottomnavbar(initialIndex: 1)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 230, 217),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 230, 217),
        title: const Text(
          "Journals",
          style: TextStyle(color: Color.fromARGB(255, 73, 27, 11)),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              size: 28,
              color: const Color.fromARGB(255, 73, 27, 11),
            ),
            onPressed: saveJournal,
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Container(
            width: 350,
            height: 670,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 📅 Date Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today, color: Colors.brown),
                        onPressed: () => selectDate(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 📝 Heading
                  TextField(
                    controller: headingController,
                    decoration: const InputDecoration(
                      labelText: "Heading",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 🖼 Add Photo
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5E6D9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.brown.shade200),
                      ),
                      child: image == null
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo, size: 40, color: Colors.brown),
                                  SizedBox(height: 8),
                                  Text("Tap to add photo"),
                                ],
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(image!, fit: BoxFit.cover, width: double.infinity),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Notes
                  TextField(
                    controller: textController,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      labelText: "Write your thoughts...",
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
