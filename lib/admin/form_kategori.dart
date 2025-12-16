import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String _categoryApiUrl =
    'https://food-api-omega-eight.vercel.app/api/api/categories';

class AddCategoryForm extends StatefulWidget {
  const AddCategoryForm({super.key});

  @override
  State<AddCategoryForm> createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _categoryDescriptionController =
      TextEditingController();

  String _toSlug(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  bool _isLoading = false;

  Future<void> _submitCategory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final name = _categoryNameController.text.trim();

    final payload = {
      'name': _categoryNameController.text,
      'slug': _toSlug(name),
      'description': _categoryDescriptionController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(_categoryApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kategori ditambahkan')),
        );
        Navigator.pop(context, true);
      } else {
        String message = 'Gagal menyimpan kategori (${response.statusCode})';
        try {
          final err = jsonDecode(response.body);
          if (err['message'] != null) {
            message = err['message'];
          }
        } catch (_) {}

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$message')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Eror koneksi: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    _categoryDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Admin',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tambah kategori',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildLabel('Nama kategori'),
                  TextFormField(
                    controller: _categoryNameController,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'nama',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: Colors.grey[700]!,
                          width: 1.5,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'butuh category';
                      }
                      if (value.length < 3) {
                        return 'Minimal 3 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Description (Optional)'),
                  TextFormField(
                    controller: _categoryDescriptionController,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: '',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: Colors.grey[700]!,
                          width: 1.5,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.grey[400]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'Batal',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitCategory,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Simpan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}