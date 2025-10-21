import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'navigation_bar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  void registerUser() async {
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String dob = dobController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPassController.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        dob.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Incomplete Fields'),
          content: const Text('All fields must be filled'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
if (email.isEmpty ||
    !email.endsWith('@gmail.com') ||
    email.split('@')[0].isEmpty) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Invalid Email'),
      content: const Text(
          'Email cannot be empty and must have text before @gmail.com'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
  return;
}


    if (password != confirmPassword) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Password Error'),
          content: const Text('Passwords do not match'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();

  

    await prefs.setString('username_$username', username);
    await prefs.setString('email_$username', email);
    await prefs.setString('dob_$username', dob);
    await prefs.setString('password_$username', password);
    await prefs.setBool('isRegistered_$username', true);
    await prefs.setString('currentUser', username);
    await prefs.setBool('isLoggedIn', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Bottomnavbar(currentUserId: '',)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/Gemini_Generated_Image_vpfvobvpfvobvpfv.png',
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 580,
                    width: 320,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(170, 230, 209, 188),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(103, 0, 0, 0),
                          blurRadius: 10,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/journallylogo.png',
                          width: 180,
                        ),
                        const SizedBox(height: 25),
                        // Username
                        TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            fillColor: const Color.fromARGB(255, 239, 224, 211),
                            filled: true,
                            labelText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.person_outlined),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            fillColor: const Color.fromARGB(255, 239, 224, 211),
                            filled: true,
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                        ),

                        const SizedBox(height: 15),
                        TextField(
                          controller: dobController,
                          readOnly: false,
                          decoration: InputDecoration(
                            fillColor: const Color.fromARGB(255, 239, 224, 211),
                            filled: true,
                            labelText: 'Date of Birth',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            prefixIcon: const Icon(Icons.cake_outlined),
                          ),
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());

                            DateTime initialDate = DateTime.now();
                            if (dobController.text.isNotEmpty) {
                              List<String> parts = dobController.text.split('/');
                              if (parts.length == 3) {
                                initialDate = DateTime(
                                  int.parse(parts[2]),
                                  int.parse(parts[1]),
                                  int.parse(parts[0]),
                                );
                              }
                            }

                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: initialDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );

                            dobController.text =
                                "${pickedDate?.day.toString().padLeft(2, '0')}/"
                                "${pickedDate?.month.toString().padLeft(2, '0')}/"
                                "${pickedDate?.year}";
                                                    },
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            fillColor: const Color.fromARGB(255, 239, 224, 211),
                            filled: true,
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: confirmPassController,
                          obscureText: true,
                          decoration: InputDecoration(
                            fillColor: const Color.fromARGB(255, 239, 224, 211),
                            filled: true,
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 270,
                          child: ElevatedButton(
                            onPressed: registerUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                164,
                                112,
                                67,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("If you already have an account, "),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>  LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}