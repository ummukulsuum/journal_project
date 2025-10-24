import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:journally/screens/home_page.dart';
import 'package:journally/screens/journal_add.dart';
import 'package:journally/screens/journals_page.dart';
import 'package:journally/screens/account_page.dart';
import 'package:journally/screens/places_page.dart';


class Bottomnavbar extends StatefulWidget {
  final int initialIndex;
  final String currentUserId;

  const Bottomnavbar({
    super.key,
    this.initialIndex = 0,
    required this.currentUserId,
  });

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> body = [
      HomePage(),
      JournalAdd(currentUserId: widget.currentUserId),
      JournalsPage(currentUserId: widget.currentUserId),
      PlacesPage(),
      AccountPage(currentUserId: widget.currentUserId),
    ];

    return Scaffold(
      body: body[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        height: 60,
        color: const Color.fromARGB(255, 195, 204, 213),
        backgroundColor: const Color(0xFFF0F0F0),
        buttonBackgroundColor: const Color.fromARGB(255, 47, 70, 101),
        animationDuration: const Duration(milliseconds: 300),
        items: [
          Icon(
            Icons.home,
            size: 30,
            color: currentIndex == 0 ? Colors.white :  Color.fromARGB(255, 38, 77, 129),
          ),
          Icon(
            Icons.chat_bubble_outline,
            size: 30,
            color: currentIndex == 1 ? Colors.white : Color.fromARGB(255, 38, 77, 129),
          ),
          Icon(
            Icons.menu_book_sharp,
            size: 30,
            color: currentIndex == 2 ? Colors.white :  Color.fromARGB(255, 38, 77, 129),
          ),
          
          Icon(
            Icons.travel_explore,
            size: 30,
            color: currentIndex == 3 ? Colors.white :  Color.fromARGB(255, 38, 77, 129),
          ),
          Icon(
            Icons.account_circle,
            size: 30,
            color: currentIndex == 4 ? Colors.white : Color.fromARGB(255, 38, 77, 129),
          ),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
