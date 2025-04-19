import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_list/data.dart';
import 'package:task_list/home_screen.dart';

const String taskBoxName = "taskBox";
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PeriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Color(0xFF6200EE)));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6200EE), // Primary
          onPrimary: Color(0xFFFFFFFF), // On Primary
          primaryContainer:
              Color(0xFFBB86FC), // Optional - می‌تونه برای variant استفاده شه

          secondary: Color(0xFF03DAC6), // Secondary
          onSecondary: Color(0xFF000000), // On Secondary

          surface: Color(0xFFFFFFFF), // Surface
          onSurface: Color(0xFF000000), // On Surface

          error: Color(0xFFB00020), // Error
          onError: Color(0xFFFFFFFF), // On Error
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
