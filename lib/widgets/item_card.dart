import 'package:flutter/material.dart';
import 'package:fnv/Screens/detail_screen.dart';
import 'package:fnv/model/candi.dart';

class ItemCard extends StatelessWidget {
  // TODO: 1. Deklarasikan variabel yang dibuuthkan dan pasang pada konstruktor
  final Candi candi;

  const ItemCard({super.key, required this.candi});

  @override
  Widget build(BuildContext context) {
    // TODO: 6. Implementasikan routing ke DetailScreen
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(candi: candi)),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(15),
        ),
        margin: EdgeInsets.all(4),
        elevation: 1,
        // TODO: 2. Tetapkan parameter shape, margin, dan elevatiion dari cari
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO: 3. Image
            Expanded(
              // TODO: 7. Implementasikan Hero Animation
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  candi.imageAsset,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // TODO: 4. Text
            Padding(
              padding: EdgeInsets.only(left: 16, top: 8),
              child: Text(
                candi.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            // TODO: 5. Text
            Padding(
              padding: EdgeInsets.only(left: 16, bottom: 8),
              child: Text(candi.type, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}
