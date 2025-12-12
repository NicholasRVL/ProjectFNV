import 'package:flutter/material.dart';
import 'package:fnv/model/api_resep_makanan.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CardResep extends StatefulWidget {
  const CardResep({super.key});

  @override
  State<CardResep> createState() => _CardResepState();
}

class _CardResepState extends State<CardResep> {
  String result = "Belum ada data";
  List<ModelResep> Resep = [];

  Future<void> testGetApi() async {
    final url = Uri.parse(
      "https://food-api-omega-eight.vercel.app/api/api/recipes",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final List data = json['data'];


        setState(() {
          Resep = data.map((json) => ModelResep.fromJson(json)).toList();
          result = "${Resep.length}";
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
      appBar: AppBar(title: Text('Test API')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(result, style: TextStyle(fontSize: 16)),
          ),
          Expanded(
            child: Resep.isEmpty
                ? Center(
                    child: Text(
                      'Tidak ada data',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: Resep.length,
                    itemBuilder: (context, index) {
                      final resep = Resep[index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(resep.title ?? 'No Title'),
                          subtitle: Text(resep.description ?? 'No Description'),
                          leading:
                              resep.coverImage != null &&
                                  resep.coverImage!.isNotEmpty
                              ? Image.network(
                                  resep.coverImage!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.fastfood),
                          trailing: Text(
                            '${resep.ingredients?.length ?? 0} bahan',
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: testGetApi,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
