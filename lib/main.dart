import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:journally/models/journal_model.dart';
import 'package:journally/models/place_model.dart';
import 'package:journally/screens/splash.dart';

late Box<PlaceModel> placesBox;
late Box<JournalModel> journalBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(JournalModelAdapter());
  Hive.registerAdapter(PlaceModelAdapter());

  journalBox = await Hive.openBox<JournalModel>('journalBox');
  placesBox = await Hive.openBox<PlaceModel>('placesBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
