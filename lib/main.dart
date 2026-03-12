import 'package:flutter/material.dart';
import 'package:hiv/features/splash/ui/splash_screen.dart';


void main() {
  runApp(const HivApp());
}

class HivApp extends StatelessWidget {
  const HivApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
