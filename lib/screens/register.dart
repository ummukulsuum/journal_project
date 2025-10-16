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
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController dobcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController confirmpasscontroller = TextEditingController();

  void registerUser() async {
    String username = usernamecontroller.text.trim();
    String email = emailcontroller.text.trim();
    String dob = dobcontroller.text.trim();
    String password = passwordcontroller.text.trim();
    String confirmpassword = confirmpasscontroller.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        dob.isEmpty ||
        password.isEmpty ||
        confirmpassword.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Incomplete Fields'),
          content: Text('Please fill all fields'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (!email.endsWith('@gmail.com')) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Invalid Email'),
          content: Text('Email must be a valid @gmail.com address'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (password != confirmpassword) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Password Error'),
          content: Text('Passwords do not match'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('username', username);
    await pref.setString('email', email);
    await pref.setString('dob', dob);
    await pref.setString('password', password);
    await pref.setBool('isLoggedIn', true);
    await pref.setBool('isRegistered', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Bottomnavbar()),
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
                    height: 550,
                    width: 320,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(170, 230, 209, 188),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(103, 0, 0, 0),
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
                        SizedBox(height: 30),

                        TextField(
                          controller: usernamecontroller,
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(255, 239, 224, 211),
                            filled: true,
                            labelText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: Icon(Icons.person_outlined),
                          ),
                        ),
                        SizedBox(height: 15),

                        TextField(
                          controller: emailcontroller,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(255, 239, 224, 211),
                            filled: true,
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        SizedBox(height: 15),

                        TextField(
                          controller: dobcontroller,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            fillColor:  Color.fromARGB(255, 239, 224, 211),
                            filled: true,
                            labelText: 'Date of Birth',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon:  Icon(Icons.cake_outlined),
                          ),
                          readOnly: true,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime(
                                2006,
                              ), 
                              firstDate: DateTime(
                                2000,
                              ), 
                              lastDate: DateTime.now(),
                            );

                            if (pickedDate != null) {
                              dobcontroller.text =
                                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            }
                          },
                        ),
                        SizedBox(height: 15),

                        TextField(
                          controller: passwordcontroller,
                          obscureText: true,
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(255, 239, 224, 211),
                            filled: true,
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: Icon(Icons.lock_outline_rounded),
                          ),
                        ),
                        SizedBox(height: 15),

                        TextField(
                          controller: confirmpasscontroller,
                          obscureText: true,
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(255, 239, 224, 211),
                            filled: true,
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: Icon(Icons.lock_outline_rounded),
                          ),
                        ),
                        SizedBox(height: 20),

                        SizedBox(
                          width: 270,
                          child: ElevatedButton(
                            onPressed: registerUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(
                                255,
                                164,
                                112,
                                67,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
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
                  SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("If you already have an account, "),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: Text(
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