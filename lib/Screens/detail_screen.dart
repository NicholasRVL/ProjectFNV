import 'package:flutter/material.dart';
import 'package:fnv/model/api_resep_makanan.dart';
import 'package:fnv/service/detail_service.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Future<ModelResep> _recipeFuture;

  @override
  void initState() {
    super.initState();
    _recipeFuture = RecipeService.getRecipeDetail(widget.recipeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Resep')),
      body: FutureBuilder<ModelResep>(
        future: _recipeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final recipe = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    recipe.coverImage ?? '',
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  recipe.title ?? '-',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 4),

                Text(
                  '${recipe.category?.name ?? '-'}',
                  style: TextStyle(color: Colors.grey[600]),
                ),

                const SizedBox(height: 16),

                _sectionTitle('Deskripsi'),
                Text(recipe.description ?? '-'),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoChip('Prep', '${recipe.prepTime} min'),
                    _infoChip('Cook', '${recipe.cookTime} min'),
                    _infoChip('Serve', '${recipe.servings}'),
                  ],
                ),

                const SizedBox(height: 24),

                _sectionTitle('Bahan'),
                ...recipe.ingredients.map(
                  (e) => ListTile(
                    leading: const Icon(Icons.circle, size: 8),
                    title: Text('${e.quantity} ${e.unit} ${e.name}'),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),

                const SizedBox(height: 24),

                _sectionTitle('Alat'),
                Wrap(
                  spacing: 8,
                  children: recipe.tools
                      .map((tool) => Chip(label: Text(tool.name ?? '-')))
                      .toList(),
                ),

                const SizedBox(height: 24),

                _sectionTitle('Langkah-langkah'),
                ...recipe.steps.map(
                  (step) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Step ${step.position}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(step.instruction ?? '-'),
                        if (step.tips != null && step.tips!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Tips: ${step.tips}',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
