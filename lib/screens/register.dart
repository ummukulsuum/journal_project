import 'package:flutter/material.dart';
import 'package:journally/screens/login_page.dart';
import 'package:journally/screens/navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernamecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController confirmpasscontroller = TextEditingController();

  void registerUser() async {
    String username = usernamecontroller.text.trim();
    String password = passwordcontroller.text.trim();
    String confirmpassword = confirmpasscontroller.text.trim();

    if (username.isEmpty || password.isEmpty || confirmpassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    if (password != confirmpassword) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    // Save data in SharedPreferences
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('username', username);
    await pref.setString('password', password);
    await pref.setBool('isLoggedIn', true);
    await pref.setBool('isRegistered', true); // <-- Added

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Bottomnavbar()));
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 450,
                  width: 320,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(170, 230, 209, 188),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/journallylogo.png', width: 180),
                      const SizedBox(height: 40),
                      TextField(
                        controller: usernamecontroller,
                        decoration: InputDecoration(
                          fillColor: const Color.fromARGB(255, 239, 224, 211),
                          filled: true,
                          labelText: 'Username',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.person_outlined),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: passwordcontroller,
                        obscureText: true,
                        decoration: InputDecoration(
                          fillColor: const Color.fromARGB(255, 239, 224, 211),
                          filled: true,
                          labelText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: confirmpasscontroller,
                        obscureText: true,
                        decoration: InputDecoration(
                          fillColor: const Color.fromARGB(255, 239, 224, 211),
                          filled: true,
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 270,
                        child: ElevatedButton(
                          onPressed: registerUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 164, 112, 67),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Sign up',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
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
                                builder: (context) => const LoginPage()));
                      },
                      child: const Text('Login',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
