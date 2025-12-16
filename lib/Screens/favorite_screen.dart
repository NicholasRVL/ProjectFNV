import 'package:flutter/material.dart';
import 'package:fnv/model/model_user.dart';
import 'package:fnv/model/api_resep_makanan.dart';
import 'package:fnv/service/service_favorite.dart';
import 'package:fnv/widgets/card_resep.dart';

class FavoriteScreen extends StatefulWidget {
  final UserModel user;

  const FavoriteScreen({super.key, required this.user});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<ModelResep>> _favoriteFuture;

  @override
  void initState() {
    super.initState();
    _favoriteFuture = FavoriteService.getUserFavorites(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Recipes'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<ModelResep>>(
        future: _favoriteFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final favorites = snapshot.data ?? [];

          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada resep disimpna',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              return CardResep(
                resep: favorites[index],
                userId: widget.user.id,
              );
            },
          );
        },
      ),
    );
  }
}
