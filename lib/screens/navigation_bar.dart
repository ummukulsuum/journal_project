import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:journally/screens/daily_zen.dart';
import 'package:journally/screens/habitt_tracker.dart';
import 'package:journally/screens/home_page.dart';
import 'package:journally/screens/journals_page.dart';


class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int _currentIndex = 0;
   List<Widget> body =  [HomePage(),JournalsPage() , DailyZen(),HabitTrackerPage()];

   List<Color> buttonColors = [
  Color.fromRGBO(121, 85, 72, 1),
  Color.fromRGBO(93, 64, 55, 1), 
  Color.fromRGBO(141, 110, 99, 1), 
  Color.fromRGBO(93, 64, 55, 1), 
];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: body[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60,
        backgroundColor:  Color.fromARGB(0, 189, 44, 44),
        color: Colors.white,
        buttonBackgroundColor: buttonColors[_currentIndex],
        animationDuration:  Duration(milliseconds: 300),
        items: [
          Icon(
            Icons.home,
            size: 30,
            color: _currentIndex == 0 ? Colors.white :   Color.fromRGBO(93, 64, 55, 1), 
          ),
          Icon(
            Icons.menu_book_rounded,
            size: 30,
            color: _currentIndex == 1 ? Colors.white :   Color.fromRGBO(93, 64, 55, 1), 
          ),
          Icon(
            Icons.search,
            size: 30,
            color: _currentIndex == 2 ? Colors.white :   Color.fromRGBO(93, 64, 55, 1), 

          ),
          Icon(
            Icons.hourglass_bottom_rounded,
            size: 30,
            color: _currentIndex == 3 ? Colors.white :   Color.fromRGBO(93, 64, 55, 1), 
          ),
          
         
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}