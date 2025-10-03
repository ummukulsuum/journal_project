import 'package:flutter/material.dart';

class DailyZen extends StatelessWidget {
  const DailyZen({super.key});

  // 📝 List of quotes + authors + images
  final List<Map<String, String>> quotes = const [
    {
      "title": "Quote of the Day",
      "quote":
          "“I’m a greater believer in luck, and I find the harder I work the more I have of it.”",
      "author": "— Thomas Jefferson",
      "image": "assets/images/quote1.png",
    },
    {
      "title": "Morning Motivation",
      "quote":
          "“The best way to get started is to quit talking and begin doing.”",
      "author": "— Walt Disney",
      "image": "assets/images/quote2.png",
    },
    {
      "title": "Evening Reflection",
      "quote":
          "“Do not wait to strike till the iron is hot; but make it hot by striking.”",
      "author": "— William Butler Yeats",
      "image": "assets/images/quote3.png",
    },
    {
      "title": "Positive Vibes",
      "quote":
          "“Keep your face always toward the sunshine—and shadows will fall behind you.”",
      "author": "— Walt Whitman",
      "image": "assets/images/quote4.png",
    },
    {
      "title": "Daily Wisdom",
      "quote":
          "“In the middle of every difficulty lies opportunity.”",
      "author": "— Albert Einstein",
      "image": "assets/images/quote5.png",
    },
    {
      "title": "Stay Strong",
      "quote":
          "“Success is not final, failure is not fatal: it is the courage to continue that counts.”",
      "author": "— Winston Churchill",
      "image": "assets/images/quote6.png",
    },
    {
      "title": "Gratitude",
      "quote":
          "“Gratitude turns what we have into enough.”",
      "author": "— Aesop",
      "image": "assets/images/quote7.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Daily Zen",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: quotes.length,
          itemBuilder: (context, index) {
            final quote = quotes[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildQuoteCard(
                title: quote["title"]!,
                quote: quote["quote"]!,
                author: quote["author"]!,
                imagePath: quote["image"]!,
              ),
            );
          },
        ),
      ),
    );
  }

  /// 🔑 Reusable method with parameters
  Widget _buildQuoteCard({
    required String title,
    required String quote,
    required String author,
    required String imagePath,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFFFFF0F0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    quote,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    author,
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  height: 120,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
