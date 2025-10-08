import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:journally/screens/habitt_tracker.dart';
import 'package:journally/screens/home_page.dart';
import 'package:journally/screens/journals_page.dart';
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
    HabitTrackerPage()
  ];

  List<Color> buttonColors = [
    Color.fromRGBO(121, 85, 72, 1),
    Color.fromRGBO(93, 64, 55, 1),
    Color.fromRGBO(141, 110, 99, 1),
    Color.fromRGBO(93, 64, 55, 1),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: body[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        height: 60,
        color: Color.fromRGBO(202, 181, 173, 0.792),
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: buttonColors[currentIndex],
        animationDuration: Duration(milliseconds: 300),
        items: [
          Icon(
            Icons.home,
            size: 30,
            color: currentIndex == 0 ? Colors.white : Color.fromRGBO(93, 64, 55, 1),
          ),
          Icon(
            Icons.menu_book_rounded,
            size: 30,
            color: currentIndex == 1 ? Colors.white : Color.fromRGBO(93, 64, 55, 1),
          ),
          Icon(
            Icons.pie_chart_rounded,
            size: 30,
            color: currentIndex == 2 ? Colors.white : Color.fromRGBO(93, 64, 55, 1),
          ),
          Icon(
            Icons.hourglass_bottom_rounded,
            size: 30,
            color: currentIndex == 3 ? Colors.white : Color.fromRGBO(93, 64, 55, 1),
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
