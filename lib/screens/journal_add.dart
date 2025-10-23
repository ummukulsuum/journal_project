import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:journally/models/journal_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'navigation_bar.dart';

class JournalAdd extends StatefulWidget {
  const JournalAdd({super.key, required String currentUserId});

  @override
  State<JournalAdd> createState() => _HomePageState();
}

class _HomePageState extends State<JournalAdd> {
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
    loadCurrentUserAndBox();
  }

  Future<void> loadCurrentUserAndBox() async {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
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

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Bottomnavbar(
          initialIndex: 1,
          currentUserId: '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 220, 237, 249),
        title: Image.asset(
          'assets/images/Adobe Express - file (4).png',
          width: 120,  
          height: 40, 
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, size: 28, color: Color.fromARGB(255, 18, 81, 133)),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 18, 81, 133)
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today, color: Color.fromARGB(255, 18, 81, 133)),
                        onPressed: () => selectDate(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 🏷️ Heading
                  TextField(
                    controller: headingController,
                    decoration: InputDecoration(
                      labelText: "Heading",
                      labelStyle: const TextStyle(color: Color.fromARGB(255, 18, 81, 133)),
                      // focusedBorder: OutlineInputBorder(
                      //   borderSide: BorderSide(color: Colors.blue.shade700),
                      // ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 18, 81, 133)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade300),
                      ),
                      child: image == null
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo, size: 40, color:Color.fromARGB(255, 18, 81, 133)),
                                  SizedBox(height: 8),
                                  Text(
                                    "Tap to add photo",
                                    style: TextStyle(color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                image!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: textController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      labelText: "Write your thoughts...",
                      labelStyle: const TextStyle(color: Color.fromARGB(255, 18, 81, 133)),
                      alignLabelWithHint: true,
                      // focusedBorder: OutlineInputBorder(
                      //   borderSide: BorderSide(color: Colors.blue.shade700),
                      // ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 18, 81, 133)),
                      ),
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
