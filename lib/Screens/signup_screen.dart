import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fnv/Screens/signin_screen.dart';
import 'package:fnv/main.dart';
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
    final url = Uri.parse(
      "https://food-api-omega-eight.vercel.app/api/api/auth/register",
    );

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

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Register success!")));
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
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),

    // TODO: 2. Pasang AppBar
    appBar: AppBar(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'Registration',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.black),
    ),

    // TODO: 3. Pasang Body
    body: Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              Image.asset(
                'assets/porsche_PNG102847.png', 
                scale: 0.5,       
              ),

              const SizedBox(height: 20),

              // CARD FORM
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(
                  child: Column(
                    // TODO: 4. Atur mainAxisAlignment dan crossAxisAlignment
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        'Recipes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _fullnameController,
                        decoration: InputDecoration(
                          labelText: "Nama",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      // TODO: 5. Pasang TextFormField Nama Pengguna
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      // TODO: 6. Pasang TextFormField Kata Sandi
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: "Password",
                          errorText:
                              _errorText.isNotEmpty ? _errorText : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        obscureText: _obscurePassword,
                      ),

                      const SizedBox(height: 20),

                      // TODO: 7. Pasang ElevatedButton Sign In
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            submitRegister();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

}
