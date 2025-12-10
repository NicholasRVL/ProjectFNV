import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class Recipe {
  final int id;
  final String title;
  final String category;

  Recipe({required this.id, required this.title, required this.category});
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';
  bool isFilterOpen = false;
  String selectedCategory = 'All';
  String selectedSort = 'popular';

  // Sample recipes data
  final List<Recipe> recipes = [
    Recipe(id: 1, title: 'Salmon Onigiri', category: 'Fish'),
    Recipe(id: 2, title: 'Tuna Mayo Onigiri', category: 'Fish'),
    Recipe(id: 3, title: 'Umeboshi Onigiri', category: 'Vegetable'),
    Recipe(id: 4, title: 'Kelp Onigiri', category: 'Vegetable'),
    Recipe(id: 5, title: 'Mixed Vegetables', category: 'Vegetable'),
    Recipe(id: 6, title: 'Shrimp Tempura Onigiri', category: 'Seafood'),
  ];

  List<Recipe> get filteredRecipes {
    return recipes.where((recipe) {
      final matchesSearch = recipe.title.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      final matchesCategory =
          selectedCategory == 'All' || recipe.category == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
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
              children: ['All', 'Fish', 'Vegetable', 'Seafood']
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
              children: ['popular', 'newest', 'rating']
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
      appBar: AppBar(
        title: const Text('Onigiri Recipes'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFF9EFD7),
      body: Column(
        children: [
          // Search Bar with Filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                // Search and Filter Button Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9EFD7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search recipes...',
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
            child: filteredRecipes.isNotEmpty
                ? GridView.builder(
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
                      return RecipeCard(recipe: recipe);
                    },
                  )
                : Center(
                    child: Text(
                      'No recipes found',
                      style: TextStyle(
                        color: const Color(0xFF1B2430).withOpacity(0.7),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({required this.recipe, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${recipe.title} selected')));
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF1B2430).withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.restaurant,
                  size: 40,
                  color: const Color(0xFF1B2430).withOpacity(0.5),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recipe.category,
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF1B2430).withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
