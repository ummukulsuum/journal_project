import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:journally/models/journal_model.dart';
// import 'package:journally/models/journal_model.g.dart';
import 'package:journally/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(JournalModelAdapter()); 

  await Hive.openBox<JournalModel>('journalsBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Journally',
      theme: ThemeData(primarySwatch: Colors.brown),
      home: const SplashScreen(),
    );
  }
}
