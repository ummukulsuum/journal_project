import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key, required String currentUserId});

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
      setState(() => profileImage = File(image.path));
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
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.redAccent),
              title: const Text("Delete Photo"),
              onTap: () async {
                Navigator.pop(context);
                setState(() => profileImage = null);
                final pref = await SharedPreferences.getInstance();
                await pref.remove('profileImage_$currentUser');
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.grey),
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
      backgroundColor: const Color(0xFFF0F0F0), 
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 195, 204, 213),
        title: Image.asset(
          'assets/images/Adobe Express - file (4).png',
          width: 160,  
          height: 60, 
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isEditingOther ? Icons.check : Icons.edit, color: Color.fromARGB(255, 18, 81, 133)),
            onPressed: () async {
              if (isEditingOther) await saveProfileData();
              setState(() => isEditingOther = !isEditingOther);
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
                  backgroundColor: const Color.fromARGB(255, 205, 231, 252),
                  child: profileImage == null
                      ? const Icon(Icons.person, size: 60, color: Color.fromARGB(255, 18, 81, 133))
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Tap to add/change profile photo",
                style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 18, 81, 133)),
              ),
              const SizedBox(height: 30),

              TextField(
                controller: nameController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Full Name",
                  prefixIcon: Icon(Icons.person, color:Color.fromARGB(255, 18, 81, 133)),
                  filled: true,
                  fillColor: Colors.blue[50],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 18, 81, 133)),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: emailController,
                readOnly: !isEditingOther,
                decoration: InputDecoration(
                  hintText: "Email ID",
                  prefixIcon: Icon(Icons.email, color: Color.fromARGB(255, 18, 81, 133)),
                  filled: true,
                  fillColor: Colors.blue[50],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 18, 81, 133)),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: dobController,
                readOnly: !isEditingOther,
                decoration: InputDecoration(
                  hintText: "Date of Birth",
                  prefixIcon: Icon(Icons.cake, color: Color.fromARGB(255, 18, 81, 133)),
                  filled: true,
                  fillColor: Colors.blue[50],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 18, 81, 133)),
                  ),
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
                            dobController.text =
                                "${picked.day}/${picked.month}/${picked.year}";
                          });
                        }
                      }
                    : null,
              ),

              const SizedBox(height: 30),

              ListTile(
                leading: const Icon(Icons.logout, color: Color.fromARGB(255, 180, 9, 9)),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Color.fromARGB(255, 180, 9, 9), fontWeight: FontWeight.w500),
                ),
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
