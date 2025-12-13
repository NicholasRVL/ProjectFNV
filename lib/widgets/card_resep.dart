import 'package:flutter/material.dart';
import 'package:fnv/model/api_resep_makanan.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class CardResep extends StatelessWidget {
  final ModelResep resep;
  

  const CardResep({super.key, required this.resep});
  

  @override
  Widget build(BuildContext context) {
      print('COVER IMAGE RAW: ${resep.coverImage}');

        
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => DetailScreen(resep: resep),
        //   ),
        // );
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
              padding: const EdgeInsets.only(left: 12, top: 8),
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

            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 8),
              child: Text(

                '${resep.ingredients?.length ?? 0} bahan',
                style: const TextStyle(fontSize: 12),

              ),
            ),
          ],
        ),
      ),
    );
  }

}


   

