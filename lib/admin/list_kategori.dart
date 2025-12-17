import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fnv/model/model_kategori.dart';
import 'edit_kategori.dart';

class ListCategory extends StatefulWidget {
  const ListCategory({super.key});

  @override
  State<ListCategory> createState() => _ListCategoryiPageState();
}

class _ListCategoryiPageState extends State<ListCategory> {
  List<ModelKategori> categories = [];
  bool isLoading = true;

  final String apiUrl =
      'https://food-api-omega-eight.vercel.app/api/api/categories';

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List data = json['data'];

        setState(() {
          categories =
              data.map((e) => ModelKategori.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        isLoading = false;
      }
    } catch (e) {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Kategori'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : categories.isEmpty
              ? const Center(child: Text('Belum ada kategori'))
              : ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final kategori = categories[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(
                          kategori.name ?? '-',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          kategori.description ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditCategoryForm(
                                  categoryId: kategori.id!,
                                  name: kategori.name!,
                                  description: kategori.description,
                                ),
                              ),
                            );
                            if (result == true) {
                              fetchCategories();
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
