
import 'package:flutter/material.dart';
import 'package:journally/screens/navigation_bar.dart';
import 'package:journally/screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    splash();
  }

  Future<void> splash() async {
    await Future.delayed(const Duration(seconds: 6));
    await checkLogin();
  }

  Future<void> checkLogin() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    bool isLoggedIn = pref.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  Bottomnavbar(currentUserId: '',)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      body: Center(
        child: Image.asset('assets/images/pathverseLogo.png',width: 300,),
      ),
    );
  }
}
