import 'dart:convert';
import 'package:fnv/model/api_resep_makanan.dart';
import 'package:http/http.dart' as http;
import 'package:fnv/model/model_save.dart';

class ApiResepMakanan {
  static const String baseUrl =
      "https://food-api-omega-eight.vercel.app/api/api";

  /// SAVE / FAVORITE RESEP
  static Future<SaveModel?> saveResep({
    required int userId,
    required ModelResep resep,
  }) async {
    final url = Uri.parse("$baseUrl/recipes/${resep.id}/save");

    SaveModel saveModel = SaveModel(
      id: 0,
      userId: userId,
      recipeId: resep.id!,
    );

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(saveModel.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return SaveModel.fromJson(data['data']);
    } else {
      throw Exception("Gagal menyimpan resep");
    }
  }
}