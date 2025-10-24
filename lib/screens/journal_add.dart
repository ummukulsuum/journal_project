import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:journally/models/journal_model.dart';
import 'package:journally/screens/navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> saveJournal() async {
    if (headingController.text.isEmpty ||
        textController.text.isEmpty ||
        image == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Incomplete Fields',
            style: TextStyle(
              color: Color.fromARGB(255, 18, 81, 133),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Please fill all fields before saving.',
            style: TextStyle(color: Colors.black87),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color.fromARGB(255, 18, 81, 133),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
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
          initialIndex: 2, 
          currentUserId: '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          actions: [
            IconButton(
              icon: const Icon(
                Icons.check,
                size: 28,
                color: Color.fromARGB(255, 18, 81, 133),
              ),
              onPressed: saveJournal,
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20,top: 20),
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
                          color: Color.fromARGB(255, 18, 81, 133),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Color.fromARGB(255, 18, 81, 133),
                        ),
                        onPressed: () => selectDate(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: headingController,
                    decoration: InputDecoration(
                      labelText: "Heading",
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 18, 81, 133),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 18, 81, 133),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 18, 81, 133),
                          width: 2,
                        ),
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
                        color: Color.fromARGB(255, 195, 204, 213),
                        borderRadius: BorderRadius.circular(8),
                        // border: Border.all(color: Colors.blue.shade300),
                      ),
                      child: image == null
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo,
                                    size: 40,
                                    color: Color.fromARGB(255, 18, 81, 133),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Tap to add photo",
                                    style: TextStyle(color: Color.fromARGB(255, 28, 63, 80)),
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
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 18, 81, 133),
                      ),
                      alignLabelWithHint: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 18, 81, 133),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 18, 81, 133),
                          width: 2,
                        ),
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
