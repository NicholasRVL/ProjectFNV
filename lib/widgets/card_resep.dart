import 'package:flutter/material.dart';
import 'package:fnv/model/api_resep_makanan.dart';
import 'package:fnv/Screens/detail_screen.dart';
import 'package:fnv/service/service_favorite.dart';

class CardResep extends StatelessWidget {
  final ModelResep resep;
  final int? userId;

  const CardResep({super.key, required this.resep, required this.userId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(recipeId: resep.id!),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(4),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: SizedBox.expand(
                      child:
                          resep.coverImage != null &&
                              resep.coverImage!.isNotEmpty
                          ? Image.network(resep.coverImage!, fit: BoxFit.cover)
                          : Container(
                              color: Colors.grey[300],
                              alignment: Alignment.center,
                              child: const Icon(Icons.fastfood, size: 50),
                            ),
                    ),
                  ),

                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                          size: 22,
                        ),
                        onPressed: () async {
                          if (userId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('User belum login')),
                            );
                            return;
                          }

                          try {
                            final saved = await SaveService.toggleSave(
                              userId: userId!,
                              recipeId: resep.id!,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  saved
                                      ? 'Resep disimpan'
                                      : 'Resep dihapus',
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Gagal: $e')),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 48,
              padding: const EdgeInsets.only(left: 12, top: 6, right: 8),
              alignment: Alignment.topLeft,
              child: Text(
                resep.title ?? 'No Title',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
