import 'package:flutter/material.dart';
import 'package:fnv/Screens/tesapi.dart';
import 'package:fnv/Screens/signup_screen.dart';
import 'package:fnv/Screens/signin_screen.dart';
import 'package:fnv/widgets/card_resep.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Test API",
      theme: ThemeData( 
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: SignUpScreen(),
    );
  }
}
