
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:journally/screens/habitt_tracker.dart';
import 'package:journally/screens/home_page.dart';

import 'package:journally/screens/journals_page.dart';
import 'package:journally/screens/account_page.dart';
import 'package:journally/screens/pie_chart.dart';

class Bottomnavbar extends StatefulWidget {
  final int initialIndex; 
  const Bottomnavbar({super.key, this.initialIndex = 0}); 

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  late int currentIndex;

  List<Widget> body = [
    HomePage(),
    JournalsPage(),
    PieChartPage(),
    HabitTrackerPage(),
    AccountPage(),
  ];

  List<Color> buttonColors = [
    const Color.fromRGBO(121, 85, 72, 1),
    const Color.fromRGBO(93, 64, 55, 1),
    const Color.fromRGBO(141, 110, 99, 1),
    const Color.fromRGBO(93, 64, 55, 1),
    const Color.fromRGBO(181, 136, 122, 1),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex; // ✅ use the passed index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        height: 60,
        color: const Color.fromRGBO(206, 181, 172, 1),
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: buttonColors[currentIndex],
        animationDuration: const Duration(milliseconds: 300),
        items: [
          Icon(
            Icons.home,
            size: 30,
            color: currentIndex == 0
                ? Colors.white
                : const Color.fromRGBO(93, 64, 55, 1),
          ),
          Icon(
            Icons.menu_book_rounded,
            size: 30,
            color: currentIndex == 1
                ? Colors.white
                : const Color.fromRGBO(93, 64, 55, 1),
          ),
          Icon(
            Icons.pie_chart_rounded,
            size: 30,
            color: currentIndex == 2
                ? Colors.white
                : const Color.fromRGBO(93, 64, 55, 1),
          ),
          Icon(
            Icons.hourglass_bottom_rounded,
            size: 30,
            color: currentIndex == 3
                ? Colors.white
                : const Color.fromRGBO(93, 64, 55, 1),
          ),
          Icon(
            Icons.account_circle,
            size: 30,
            color: currentIndex == 4
                ? Colors.white
                : const Color.fromRGBO(93, 64, 55, 1),
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
