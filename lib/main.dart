import 'package:flutter/material.dart';
import 'package:fnv/Screens/intro.dart';
import 'package:fnv/Screens/login.dart';
import 'package:fnv/Screens/registrasi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: RegistrasiScreen(),
      home: LoginScreen()
      //home: IntroScreen(),
    );
  }
}