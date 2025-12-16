import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fnv/model/api_resep_makanan.dart';

class RecipeService {
  static const String baseUrl =
      'https://food-api-omega-eight.vercel.app/api/api';

  static Future<ModelResep> getRecipeDetail(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/recipes/$id'),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return ModelResep.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load recipe');
    }
  }
}
