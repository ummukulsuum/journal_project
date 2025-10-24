import 'package:flutter/material.dart';
import 'package:journally/screens/journals_page.dart';
import 'package:journally/screens/pieChart_page.dart';
import 'package:journally/screens/unvisited_page.dart';
import 'package:journally/screens/visited_page.dart';
import 'package:journally/screens/wishlist_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> dashboardItems = [
    {"title": "Unexplored", "icon": Icons.location_off_outlined},
    {"title": "Visited Places", "icon": Icons.location_on_outlined},
    {"title": "Journals", "icon": Icons.menu_book_rounded},
    {"title": "Pie Chart", "icon": Icons.pie_chart_outline},
    {"title": "Wishlist", "icon": Icons.favorite},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 195, 204, 213),
          title: Image.asset(
            'assets/images/Adobe Express - file (4).png',
            width: 150,
            height: 80,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: dashboardItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            final item = dashboardItems[index];
            return GestureDetector(
              onTap: () async {
                switch (item['title']) {
                  case "Unexplored":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UnvisitedPage(),
                      ),
                    );
                    break;
                  case "Visited Places":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VisitedPage(),
                      ),
                    );
                    break;
                  case "Journals":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            JournalsPage(currentUserId: "defaultUser"),
                      ),
                    );
                    break;
                  case "Pie Chart":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>  PieChartPage(),
                      ),
                    );
                    break;
                  case "Wishlist":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const WishlistPage(),
                      ),
                    );
                    break;
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 37, 62, 104),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item['icon'], size: 36, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 12, 56, 92),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
