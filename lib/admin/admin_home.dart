import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fnv/Screens/signin_screen.dart';
import 'package:fnv/admin/card_admin.dart';
import 'package:fnv/admin/form_kategori.dart';
import 'package:fnv/admin/form_resep.dart';
import 'package:fnv/config/api_config.dart';
import 'package:fnv/model/api_resep_makanan.dart';
import 'package:fnv/model/model_kategori.dart';
import 'package:fnv/widgets/card_resep.dart';
import 'package:fnv/service/auth_service.dart';
import 'package:fnv/Screens/profile_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fnv/model/model_user.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List<ModelResep> listResep = [];
  List<ModelKategori> listKategori = [];
  bool isLoading = true;
  String searchQuery = '';
  bool isFilterOpen = false;
  String selectedCategory = 'All';
  String selectedSort = 'popular';
  bool _showAddOptions = false;
  List<String> categories = ['All'];

  Future<void> fetchResep() async {
    final url = Uri.parse(
      "https://food-api-omega-eight.vercel.app/api/api/recipes",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List data = json['data'];

        setState(() {
          listResep = data.map((e) => ModelResep.fromJson(e)).toList();

          final apiCategories = listResep
              .map((e) => e.category?.name)
              .where((name) => name != null)
              .cast<String>()
              .toSet()
              .toList();

          categories = ['All', ...apiCategories];

          isLoading = false;
        });
      } else {
        isLoading = false;
      }
    } catch (e) {
      isLoading = false;
    }
  }

  Future<void> deleteRecipe(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Resep'),
        content: const Text('Yakin mau hapus resep ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final url = Uri.parse(
      'https://food-api-omega-eight.vercel.app/api/api/public/recipes/$id',
    );

    try {
      final response = await http.delete(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          listResep.removeWhere((r) => r.id == id);
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Resep berhasil dihapus')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal hapus (${response.statusCode})')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Terjadi error')));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchResep();
  }

  List<ModelResep> get filteredRecipes {
    final filtered = listResep.where((recipe) {
      final matchesSearch =
          recipe.title?.toLowerCase().contains(searchQuery.toLowerCase()) ??
          false;

      final matchesCategory =
          selectedCategory == 'All' ||
          recipe.category?.name == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    if (selectedSort == 'newest') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (selectedSort == 'oldest') {
      filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    return filtered;
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter & Sort',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Category'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: categories
                  .map(
                    (category) => FilterChip(
                      label: Text(category),
                      selected: selectedCategory == category,
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            const Text('Sort by'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Terbaru', 'terlama']
                  .map(
                    (sort) => FilterChip(
                      label: Text(sort),
                      selected: selectedSort == sort,
                      onSelected: (selected) {
                        setState(() {
                          selectedSort = sort;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_showAddOptions) ...[
            FloatingActionButton.extended(
              heroTag: 'addCategory',
              onPressed: () {
                setState(() {
                  _showAddOptions = false;
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddCategoryForm(),
                  ),
                );
              },

              label: const Text('Tambah Kategori'),
              icon: const Icon(Icons.category),
              backgroundColor: const Color.fromARGB(255, 0, 58, 19),
              foregroundColor: Colors.white,
            ),

            const SizedBox(height: 10),
          ],

          if (_showAddOptions) ...[
            FloatingActionButton.extended(
              heroTag: 'addRecipe',
              onPressed: () {
                setState(() {
                  _showAddOptions = false;
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FormResep()),
                );
              },
              label: const Text('Tambah Resep'),
              icon: const Icon(Icons.restaurant_menu),
              backgroundColor: const Color.fromARGB(255, 6, 54, 0),
              foregroundColor: Colors.white,
            ),
            const SizedBox(height: 10),
          ],

          FloatingActionButton(
            heroTag: 'mainFab',
            onPressed: () {
              setState(() {
                _showAddOptions = !_showAddOptions;
              });
            },
            backgroundColor: const Color(0xFF1B2430),
            child: Icon(
              _showAddOptions ? Icons.close : Icons.add,

              color: Colors.white,
            ),
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

            decoration: BoxDecoration(
              color: Colors.white,

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),

                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),

            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Onigiri',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1B2430),
                      ),
                    ),

                    InkWell(
                      borderRadius: BorderRadius.circular(20),

                      onTap: () {
                        if (AuthSession.isLoggedIn) {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(user: AuthSession.currentUser!),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) => SignInScreen(),
                            ),
                          );
                        }
                      },
                      child: CircleAvatar(
                        radius: 20,

                        backgroundColor: const Color(
                          0xFF1B2430,
                        ).withOpacity(0.1),

                        child: const Icon(
                          Icons.person,
                          color: Color(0xFF1B2430),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),

            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),

                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Cari resep...',
                            border: InputBorder.none,

                            prefixIcon: Icon(
                              Icons.search,
                              color: const Color(0xFF1B2430).withOpacity(0.5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _showFilterDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B2430),
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Icon(Icons.tune, color: Colors.white),
                    ),
                  ],
                ),
                // Active Filter Indicator
                if (selectedCategory != 'All')
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        Text(
                          'Filtered by:',
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color(0xFF1B2430).withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B2430),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            selectedCategory,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredRecipes.isEmpty
                ? Center(child: Text('Belum ada resep'))
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];
                      return CardResepAdmin(
                        resep: recipe,
                        onDelete: () => deleteRecipe(recipe.id!),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
