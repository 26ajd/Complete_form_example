import 'package:flutter/material.dart';
import 'package:complete_form_example/screens/form_screen.dart';
import 'package:complete_form_example/services/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'H.W Form',
      theme: ThemeData(
        fontFamily: 'RobotoCustom',
        primarySwatch: Colors.teal,
        brightness: Brightness.light,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: FormScreen(),
    );
  }
}
