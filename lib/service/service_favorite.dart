import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fnv/model/api_resep_makanan.dart';

class FavoriteService {
  static const String baseUrl =
      'https://food-api-omega-eight.vercel.app/api/api';

  static Future<List<ModelResep>> getUserFavorites(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/saves'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List data = jsonData['data'];

      return data.map((e) => ModelResep.fromJson(e)).toList();
    } else {
      throw Exception('Gagal ambil resep favorit');
    }
  }
}

class SaveService {
  static Future<bool> toggleSave({
    required int userId,
    required int recipeId,
  }) async {
    final response = await http.post(
      Uri.parse(
        'https://food-api-omega-eight.vercel.app/api/api/recipes/$recipeId/save',
      ),
      headers: {'Accept': 'application/json'},
      body: {'user_id': userId.toString()},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['saved'] == true;
    } else {
      throw Exception('Gagal menyimpan resep');
    }
  }
}
