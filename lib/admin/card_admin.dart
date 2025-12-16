import 'package:flutter/material.dart';
import 'package:fnv/model/api_resep_makanan.dart';
import 'package:fnv/Screens/detail_screen.dart';


class CardResepAdmin extends StatelessWidget {
  final ModelResep resep;
  final VoidCallback onDelete;

  const CardResepAdmin({
    super.key,
    required this.resep,
    required this.onDelete,
  });

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

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(15),

        ),


        margin: const EdgeInsets.all(4),
        elevation: 2,

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Expanded(

              child: ClipRRect(

                borderRadius: const BorderRadius.vertical(

                  top: Radius.circular(15),

                ),

                child: resep.coverImage != null &&
                
                        resep.coverImage!.isNotEmpty
                    ? Image.network(
                        resep.coverImage!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.fastfood,
                          size: 50,
                        ),
                        
                      ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(left: 12, top: 4),
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

            IconButton(
                  icon: const Icon(Icons.delete, color: Color.fromARGB(255, 1, 10, 61)),
                  onPressed: onDelete,
            ),

            
            SizedBox(height: 3),

          ],
        ),
      ),
    );
  }
}

                