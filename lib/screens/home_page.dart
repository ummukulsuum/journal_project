import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 
import 'dart:io';
import 'package:journally/screens/navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  File? _image;
  final picker = ImagePicker();

  final TextEditingController headingController = TextEditingController();
  final TextEditingController textController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
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
            icon: const Icon(Icons.check, size: 28, color: Color.fromARGB(255, 73, 27, 11)),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Bottomnavbar(initialIndex: 1)),
                (route) => false,
              );
            },
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
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today, color: Colors.brown),
                        onPressed: () => _selectDate(context),
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
                    onTap: _pickImage,
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5E6D9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.brown.shade200),
                      ),
                      child: _image == null
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
                              child: Image.file(
                                _image!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 💬 Journal Text
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
