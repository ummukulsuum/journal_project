import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File? profileImage;
  String currentUser = '';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  bool isEditingOther = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final pref = await SharedPreferences.getInstance();
    currentUser = pref.getString('currentUser') ?? '';

    if (currentUser.isNotEmpty) {
      setState(() {
        nameController.text = pref.getString('username_$currentUser') ?? '';
        emailController.text = pref.getString('email_$currentUser') ?? '';
        dobController.text = pref.getString('dob_$currentUser') ?? '';

        String? imagePath = pref.getString('profileImage_$currentUser');
        if (imagePath != null && imagePath.isNotEmpty) {
          profileImage = File(imagePath);
        }
      });
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });
      final pref = await SharedPreferences.getInstance();
      await pref.setString('profileImage_$currentUser', image.path);
    }
  }

  void showImageOptions() {
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
                pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Delete Photo"),
              onTap: () async {
                Navigator.pop(context);
                setState(() {
                  profileImage = null;
                });
                final pref = await SharedPreferences.getInstance();
                await pref.remove('profileImage_$currentUser');
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

  Future<void> saveProfileData() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('email_$currentUser', emailController.text.trim());
    await pref.setString('dob_$currentUser', dobController.text.trim());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5E6D9),
        elevation: 0,
        title: const Text("Account", style: TextStyle(color: Colors.brown)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isEditingOther ? Icons.check : Icons.edit, color: Colors.brown),
            onPressed: () async {
              if (isEditingOther) {
                await saveProfileData();
              }
              setState(() {
                isEditingOther = !isEditingOther;
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
                onTap: showImageOptions,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: profileImage != null ? FileImage(profileImage!) : null,
                  backgroundColor: Colors.brown.shade300,
                  child: profileImage == null
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
              // Username (read-only)
              TextField(
                controller: nameController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Full Name",
                  prefixIcon: const Icon(Icons.person, color: Colors.brown),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),
              // Email
              TextField(
                controller: emailController,
                readOnly: !isEditingOther,
                decoration: InputDecoration(
                  hintText: "Email ID",
                  prefixIcon: const Icon(Icons.email, color: Colors.brown),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),
              // DOB
              TextField(
                controller: dobController,
                readOnly: !isEditingOther,
                decoration: InputDecoration(
                  hintText: "Date of Birth",
                  prefixIcon: const Icon(Icons.cake, color: Colors.brown),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onTap: isEditingOther
                    ? () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            dobController.text = "${picked.day}/${picked.month}/${picked.year}";
                          });
                        }
                      }
                    : null,
              ),
              const SizedBox(height: 30),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text("Logout", style: TextStyle(color: Colors.redAccent)),
                onTap: () async {
                  final pref = await SharedPreferences.getInstance();
                  await pref.remove('currentUser');
                  await pref.setBool('isLoggedIn', false);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
