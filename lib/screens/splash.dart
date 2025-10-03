import 'package:flutter/material.dart';
import 'package:journally/screens/login_page.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splash();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(179, 133, 107, 1.0),
      body: Center(
        child: Image.asset(
          'assets/images/journallyy.png',
          width: 330,
        ),
      ),
    );
  }
  Future splash() async {
    Future.delayed(Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    });
}
}