import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredRecipes = [];
  String _searchQuery = '';

  // Sample recipes for demonstration
  final List<String> _allRecipes = [
    'Onigiri Salmon',
    'Onigiri Tuna Mayonnaise',
    'Onigiri Umeboshi',
    'Onigiri Katsuobushi',
    'Onigiri Kelp',
    'Onigiri Mixed Vegetables',
  ];

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredRecipes = [];
      } else {
        _filteredRecipes = _allRecipes
            .where(
              (recipe) => recipe.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFF9EFD7),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              // Search Input
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _performSearch,
                  decoration: InputDecoration(
                    hintText: 'Search recipes...',
                    hintStyle: TextStyle(
                      color: const Color(0xFF1B2430).withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: const Color(0xFF1B2430).withOpacity(0.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Empty State or Search Results
              if (_searchQuery.isEmpty)
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.search,
                          size: 40,
                          color: const Color(0xFF1B2430).withOpacity(0.3),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Search for your favorite recipes',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF1B2430).withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                )
              else if (_filteredRecipes.isEmpty)
                Center(
                  child: Text(
                    'No recipes found',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF1B2430).withOpacity(0.7),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = _filteredRecipes[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(recipe),
                        leading: Icon(
                          Icons.restaurant,
                          color: const Color(0xFF1B2430),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
