import 'package:flutter/material.dart';
import 'package:journally/screens/navigation_bar.dart';

class JournalAdd extends StatelessWidget {
  const JournalAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(212, 174, 160, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(212, 174, 160, 1),
        title: const Text("Journals"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, size: 28),
            onPressed: () {
              // Go back to Bottomnavbar with Journals tab
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) =>  Bottomnavbar(initialIndex: 1)),
                (route) => false, // remove all previous routes
              );
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Container(
            width: 350,
            height: 670,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: 40,
                  itemBuilder: (context, index) {
                    return const SizedBox(
                      height: 40,
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyle(fontSize: 16, height: 2),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Write down your thoughts...",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
