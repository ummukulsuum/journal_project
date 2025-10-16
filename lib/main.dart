import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:journally/models/journal_model.dart';
import 'package:journally/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive
  await Hive.initFlutter();

  Hive.registerAdapter(JournalModelAdapter());

  // Open a box to store journal objects
  await Hive.openBox<JournalModel>("JournalsBox");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SplashScreen());
  }
}
