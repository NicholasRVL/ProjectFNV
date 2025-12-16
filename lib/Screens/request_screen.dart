// lib/screens/form_request_widget.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fnv/model/model_user.dart';
import 'package:fnv/service/auth_service.dart';
import 'package:fnv/model/model_request.dart';

class RequestScreen extends StatefulWidget {
  final UserModel user;

  const RequestScreen({super.key, required this.user});

  @override
  State<RequestScreen> createState() => _RequestScreenWidgetState();
}

class _RequestScreenWidgetState extends State<RequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _reasonController = TextEditingController();
  final _contactController = TextEditingController();

  bool _isLoading = false;
  final String _apiUrl =
      'https://food-api-omega-eight.vercel.app/api/api/recipe-requests';

  @override
  void initState() {
    super.initState();
    if (AuthSession.isLoggedIn) {
      _contactController.text = AuthSession.currentUser!.email;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _reasonController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    final Map<String, dynamic> payload = {
      'user_id': AuthSession.currentUser!.id,
      'title': _titleController.text,
      'description': _descriptionController.text,
      'reason': _reasonController.text,
      'contact': _contactController.text,
    };

    if (!AuthSession.isLoggedIn || AuthSession.currentUser!.id == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login dulu sana')));
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    final token = (await SharedPreferences.getInstance()).getString('token');
    final newRequest = Request(
      id: 0,
      userId: AuthSession.currentUser!.id,
      title: _titleController.text,
      description: _descriptionController.text,
      reason: _reasonController.text,
      contact: _contactController.text,
      status: 'pending',
    );

    final res = await http.post(
      Uri.parse(_apiUrl),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(newRequest.toJson()),
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('terkirim')));
      _titleController.clear();
      _descriptionController.clear();
      _reasonController.clear();
    } else {
      String errorMessage = 'Gagal mengirim';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulir Permintaan'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFormField(
                _titleController,
                'Request *',
                'Misal: Babi Panggang',
              ),
              const SizedBox(height: 15),

              _buildTextFormField(
                _descriptionController,
                'Deskripsi *',
                'Jelaskan permintaan Anda',
                maxLines: 4,
              ),
              const SizedBox(height: 15),

              _buildTextFormField(
                _reasonController,
                'Alasan',
                'Misal: saya ingin resep ini krna...',
                maxLines: 3,
              ),
              const SizedBox(height: 15),

              _buildTextFormField(
                _contactController,
                'Kontak yang Bisa Dihubungi',
                'Email atau Nomor Telepon',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: _isLoading ? null : _submitRequest,
                icon: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Icon(Icons.send),
                label: Text(
                  _isLoading ? 'Mengirim...' : 'Kirim Permintaan',
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String label,
    String hint, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label wajib diisi.';
        }
        return null;
      },
    );
  }
}
