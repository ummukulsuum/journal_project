import 'package:flutter/material.dart';

class Journalise extends StatelessWidget {
  const Journalise({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 239, 162),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 247, 239, 162),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, size: 28),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Save clicked!")));
            },
          ),
          SizedBox(width: 20),
        ],
        title:  Text("Notes"),
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: const Offset(4, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: 40,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 40,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 0.7),
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: const TextStyle(fontSize: 16, height: 2),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Start writing your notes...",
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