import 'package:flutter/material.dart';
import 'package:journally/widgets/journals_w.dart';

class JournalsPage extends StatefulWidget {
  const JournalsPage({super.key});

  @override
  State<JournalsPage> createState() => _JournalsPageState();
}

class _JournalsPageState extends State<JournalsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EDE6),
      appBar: AppBar(
        backgroundColor: Color(0xFFD4AE9F),
        title:  Text("Journals"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            journals(), // your journal widget
          ],
        ),
      ),
    );
  }
}
