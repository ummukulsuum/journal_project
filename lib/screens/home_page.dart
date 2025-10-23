import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> dashboardItems = [
    {
      "title": "Wishlist",
      "icon": Icons.favorite_border,
    },
    {
      "title": "Journals",
      "icon": Icons.menu_book_rounded,
    },
    {
      "title": "Pie Chart",
      "icon": Icons.pie_chart_outline,
    },
    {
      "title": "Visited Places",
      "icon": Icons.location_on_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0), 
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 220, 237, 249),
        title: Image.asset(
          'assets/images/Adobe Express - file (4).png',
          width: 120,  
          height: 40, 
        ),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: dashboardItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 tiles per row
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            final item = dashboardItems[index];
            return GestureDetector(
              onTap: () {
                // TODO: Navigate to respective page
                print("${item['title']} tapped");
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // clean white tile
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
                        color: const Color(0xFF0B3D91), // navy circle
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item['icon'],
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
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
