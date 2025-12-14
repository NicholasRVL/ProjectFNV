import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fnv/model/api_resep_makanan.dart';

class ApiService {
  Future<List<ModelResep>> getProducts() async {
    final url = Uri.parse("https://food-api-omega-eight.vercel.app/");

    final res = await http.get(url);

    if (res.statusCode == 200) {

      List data = jsonDecode(res.body);

      return data.map((e) => ModelResep.fromJson(e)).toList();

    } else {
      
      throw Exception("Gagal mengambil data");
    }
  }
}