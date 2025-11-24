import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive Flutter
import 'providers/amiibo_provider.dart';
import 'screens/main_screen.dart';
import 'models/amiibo_model.dart'; // Import Model untuk Adapter

void main() async {
  // Inisialisasi Hive
  await Hive.initFlutter();

  // Registrasi Adapter yang digenerate
  Hive.registerAdapter(AmiiboAdapter());

  // Buka box favorites
  await Hive.openBox<Amiibo>('favoritesBox');

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AmiiboProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nintendo Amiibo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: const MainScreen(),
    );
  }
}
