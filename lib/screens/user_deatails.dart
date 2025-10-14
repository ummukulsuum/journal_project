import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'login_page.dart'; // import your LoginPage

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File? _profileImage;

  // Controllers for UI only, start empty
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  // Toggle edit mode
  bool _isEditing = true; // start in editing mode

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final XFile? photo =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (photo != null) {
      setState(() {
        _profileImage = File(photo.path);
      });
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take a Photo"),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text("Cancel"),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5E6D9),
        elevation: 0,
        title: const Text(
          "Account",
          style: TextStyle(color: Colors.brown),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit, color: Colors.brown),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing; // toggle edit mode
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _showImageOptions,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      _profileImage != null ? FileImage(_profileImage!) : null,
                  backgroundColor: Colors.brown.shade300,
                  child: _profileImage == null
                      ? const Icon(Icons.person, size: 60, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Tap to add/change profile photo",
                style: TextStyle(fontSize: 14, color: Colors.brown),
              ),
              const SizedBox(height: 30),

              // Full Name Field
              TextField(
                controller: _nameController,
                readOnly: !_isEditing,
                decoration: InputDecoration(
                  hintText: "Full Name",
                  prefixIcon: const Icon(Icons.person, color: Colors.brown),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),

              // Email Field
              TextField(
                controller: _emailController,
                readOnly: !_isEditing,
                decoration: InputDecoration(
                  hintText: "Email ID",
                  prefixIcon: const Icon(Icons.email, color: Colors.brown),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),

              // Date of Birth Field
              TextField(
                controller: _dobController,
                readOnly: !_isEditing,
                decoration: InputDecoration(
                  hintText: "Date of Birth",
                  prefixIcon: const Icon(Icons.cake, color: Colors.brown),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onTap: _isEditing
                    ? () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _dobController.text =
                                "${picked.day}/${picked.month}/${picked.year}";
                          });
                        }
                      }
                    : null,
              ),
              const SizedBox(height: 30),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title:
                    const Text("Logout", style: TextStyle(color: Colors.redAccent)),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
