import 'package:flutter/material.dart';
import 'package:fnv/Screens/signin_screen.dart';
import 'package:fnv/model/model_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class AuthService {
  static const String baseUrl =
      'https://food-api-omega-eight.vercel.app/api/api/auth';
  static const String _meApiUrl =
      'https://food-api-omega-eight.vercel.app/api/api/me';

  static Future<UserModel?> login(String email, String password) async {
    final response = await http.post(

      Uri.parse('$baseUrl/login'),

      headers: {'Accept': 'application/json'},

      body: {
        'email': email,
        'password': password,
      },

    );

    

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', data['token']);

      return UserModel.fromJson(data['user']);

    }

    return null;
  }


  
}


class AuthSession {
  static UserModel? currentUser;

  static bool get isLoggedIn => currentUser != null;

  static Future<void> logout() async {
    currentUser = null;
  }
}


