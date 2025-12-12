import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // TODO: 1. Deklarasikan variabel yang dibutuhkan
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorText = '';
  bool _isSignedUp = false;
  bool _obscurePassword = true;

  Future<void> submitRegister() async {
  final url = Uri.parse("https://food-api-omega-eight.vercel.app/api/api/auth/register");

  final body = {
    "name": _fullnameController.text.trim(),
    "email": _usernameController.text.trim(),
    "password": _passwordController.text.trim(),
    "password_confirmation": _passwordController.text.trim(), 
  };

  try {
    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      print("RAW RESPONSE = ${res.body}");
      final data = jsonDecode(res.body);

      setState(() {
        _isSignedUp = true;
        _errorText = '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Register success!")),
      );

    } else {
      print("RAW RESPONSE = ${res.body}");
      final data = jsonDecode(res.body);

      setState(() {
        _errorText = data["message"] ?? "Register failed";
      });
    }
  } catch (e) {
    setState(() {
      _errorText = "Error: $e";
    });
    }
  }


  @override

  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: 2. Pasang AppBar
      appBar: AppBar(title: Text('Sign Up'),),
      // TODO: 3. Pasang Body
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              child: Column(
                // TODO: 4. Atur mainAxisAlignment dan crossAxisAlignment
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   TextFormField(
                    controller: _fullnameController,
                    decoration: InputDecoration(
                      labelText: "Nama",
                      border: OutlineInputBorder()
                    ),
                  ),
                  // TODO: 5. Pasang TextFormField Nama Pengguna
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder()
                    ),
                  ),

                  // TODO: 6. Pasang TextFormField Kata Sandi
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Kata Sandi",
                      errorText: _errorText.isNotEmpty ? _errorText : null,
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        }, 
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off
                            : Icons.visibility,
                        ),
                      ),
                    ),
                    obscureText: _obscurePassword,
                  ),
                  // TODO: 7. Pasang ElevatedButton Sign In
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: submitRegister, 
                    child: Text('Sign Up'),
                  ),
                  // TODO: 8. Pasang TextButton Sign Up
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: 'Sudah punya akun? ',
                      style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Sign in di sini',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}