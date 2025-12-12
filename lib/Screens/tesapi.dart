import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TestApiPage extends StatefulWidget {
  const TestApiPage({super.key});

  @override
  State<TestApiPage> createState() => _TestApiPageState();
}

class _TestApiPageState extends State<TestApiPage> {
  String result = "Belum ada data";

  Future<void> testGetApi() async {
    final url = Uri.parse("https://food-api-omega-eight.vercel.app/api/api/categories"); 
    // ganti URL sama punya kamu

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          result = data.toString();
        });
      } else {
        setState(() {
          result = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        result = "Exception: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test GET API")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: testGetApi,
              child: const Text("Tes GET API"),
            ),
            const SizedBox(height: 20),
            Text(result),
          ],
        ),
      ),
    );
  }
}
