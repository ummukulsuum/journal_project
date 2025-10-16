import 'package:flutter/material.dart';
import 'package:journally/screens/register.dart';
import 'package:journally/screens/navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernamecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  void loginUser() async {
  String username = usernamecontroller.text.trim();
  String password = passwordcontroller.text.trim();

  if (username.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill all text fields')),
    );
    return;
  }

  final SharedPreferences pref = await SharedPreferences.getInstance();
  bool isRegistered = pref.getBool('isRegistered') ?? false;

  if (!isRegistered) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You are not registered yet!')),
    );
    return;
  }

  String savedUsername = pref.getString('username') ?? '';
  String savedPassword = pref.getString('password') ?? '';

  if (username == savedUsername && password == savedPassword) {
    await pref.setBool('isLoggedIn', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Bottomnavbar()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invalid Username or Password')),
    );
  }
}

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset('assets/images/bg(1).jpeg', fit: BoxFit.cover),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 350,
                  width: 320,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color:  Color.fromARGB(230, 240, 222, 204),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset:  Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/journallylogo.png', width: 180),
                       SizedBox(height: 40),
                      TextField(
                        controller: usernamecontroller,
                        decoration: InputDecoration(
                          fillColor:  Color.fromARGB(255, 249, 231, 215),
                          filled: true,
                          labelText: 'Username',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon:  Icon(Icons.person_outlined),
                        ),
                      ),
                       SizedBox(height: 15),
                      TextField(
                        controller: passwordcontroller,
                        obscureText: true,
                        decoration: InputDecoration(
                          fillColor:  Color.fromARGB(255, 249, 231, 215),
                          filled: true,
                          labelText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon:  Icon(Icons.lock_outline_rounded),
                        ),
                      ),
                       SizedBox(height: 20),
                      SizedBox(
                        width: 270,
                        child: ElevatedButton(
                          onPressed: loginUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  Color.fromARGB(255, 164, 112, 67),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding:  EdgeInsets.symmetric(vertical: 12),
                          ),
                          child:  Text('Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
                 SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text("If you don't have an account, "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  RegisterPage()));
                      },
                      child:  Text('Sign in',
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