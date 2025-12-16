import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:fnv/model/model_kategori.dart';
import 'package:fnv/model/model_bahan.dart';
import 'package:fnv/model/model_alat.dart';
import 'package:fnv/model/step_model.dart';
import 'package:fnv/model/api_resep_makanan.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.grey,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
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
            borderSide: BorderSide(color: Colors.grey[700]!, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
      home: const FormResep(),
    );
  }
}

class FormResep extends StatefulWidget {
  const FormResep({super.key});
  @override
  State<FormResep> createState() => _FormResepState();
}

class _FormResepState extends State<FormResep> {
  final _formKey = GlobalKey<FormState>();
  
  final String _apiUrl = 'https://food-api-omega-eight.vercel.app/api/api/recipes';
  final String _categoryApiUrl = 'https://food-api-omega-eight.vercel.app/api/api/categories';

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _prepController = TextEditingController();
  final _cookController = TextEditingController();
  final _servingsController = TextEditingController();
  final _imgController = TextEditingController();

  List<ModelBahan> _ingredients = [ModelBahan(name: '', quantity: '', unit: '')];
  List<ModelAlat> _tools = [ModelAlat(name: '')];
  List<StepModel> _steps = [StepModel(instruction: '', tips: '')];

  ModelKategori? _selectedCategory;
  List<ModelKategori> _categories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(_categoryApiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List jsonList = data is Map ? data['data'] : data;
        setState(() {
          _categories = jsonList.map((e) => ModelKategori.fromJson(e)).toList();
          if (_categories.isNotEmpty) _selectedCategory = _categories.first;
        });
      }
    } catch (e) {
      dev.log("Error categories: $e");
    }
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final payload = {
      'category_id': _selectedCategory?.id,
      'title': _titleController.text,
      'slug': _titleController.text.toLowerCase().replaceAll(' ', '-'),
      'description': _descController.text,
      'prep_time': int.tryParse(_prepController.text) ?? 0,
      'cook_time': int.tryParse(_cookController.text) ?? 0,
      'servings': int.tryParse(_servingsController.text) ?? 0,
      'cover_image': _imgController.text,
      'ingredients': _ingredients.map((e) => {'name': e.name, 'quantity': e.quantity, 'unit': e.unit}).toList(),
      'tools': _tools.map((e) => {'name': e.name}).toList(),
      'steps': _steps.asMap().entries.map((e) => {
        'position': e.key + 1,
        'instruction': e.value.instruction,
        'tips': e.value.tips
      }).toList(),
    };

    try {
      final res = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        _showSnackBar(" Resep Disimpan!", Colors.green);
      } else {
        _showSnackBar("Gagal: ${res.body}", Colors.red);
      }
    } catch (e) {
      _showSnackBar("Error: $e", Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
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
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.black))
        : SingleChildScrollView(
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
                        'Tambah resep',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildSimpleLabel('Nama'),
                      _buildSimpleTextField(_titleController, "Nama", true),
                      const SizedBox(height: 16),

                      _buildSimpleLabel('Kategori'),
                      _buildCategoryDropdown(),
                      const SizedBox(height: 16),

                      _buildSimpleLabel('Tambah gambar'),
                      _buildSimpleTextField(_imgController, "Url gambar", false),
                      const SizedBox(height: 16),

                      _buildSimpleLabel('Deskripsi'),
                      _buildSimpleTextField(_descController, "", false, maxLines: 4),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSimpleLabel('Waktu persiapan'),
                                _buildNumberField(_prepController, "menit"),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSimpleLabel('Waktu Masak'),
                                _buildNumberField(_cookController, "menit"),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildSimpleLabel('jumlah penyajian'),
                      _buildNumberField(_servingsController, "porsi"),
                      const SizedBox(height: 24),

                      _buildSectionTitle("Bahan-Bahan"),
                      ..._ingredients.asMap().entries.map((e) => _buildIngredientRow(e.key)),
                      _buildAddButton("tambah bahan", () {
                        setState(() => _ingredients.add(ModelBahan(name: '', quantity: '', unit: '')));
                      }),
                      const SizedBox(height: 24),

                      _buildSectionTitle("Alat Memasak"),
                      ..._tools.asMap().entries.map((e) => _buildToolRow(e.key)),
                      _buildAddButton("tambah alat", () {
                        setState(() => _tools.add(ModelAlat(name: '')));
                      }),
                      const SizedBox(height: 24),

                      _buildSectionTitle("Langkah Memasak"),
                      ..._steps.asMap().entries.map((e) => _buildStepRow(e.key)),
                      _buildAddButton("tambah langkah", () {
                        setState(() => _steps.add(StepModel(instruction: '', tips: '')));
                      }),
                      const SizedBox(height: 32),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                _formKey.currentState?.reset();
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: BorderSide(color: Colors.grey[400]!),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: const Text(
                                'Batal',
                                style: TextStyle(color: Colors.black87, fontSize: 15),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _submitData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black87,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: const Text(
                                'kirim',
                                style: TextStyle(color: Colors.white, fontSize: 15),
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

  // --- WIDGET BUILDERS ---

  Widget _buildSimpleLabel(String text) {
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

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSimpleTextField(TextEditingController ctrl, String hint, bool required, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        ),
        validator: required ? (v) => v!.isEmpty ? "Required" : null : null,
      ),
    );
  }

  Widget _buildNumberField(TextEditingController ctrl, String hint) {
    return TextFormField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<ModelKategori>(
      value: _selectedCategory,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: "Value",
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      ),
      items: _categories.map((k) => DropdownMenuItem(value: k, child: Text(k.name ?? ""))).toList(),
      onChanged: (v) => setState(() => _selectedCategory = v),
    );
  }

  Widget _buildIngredientRow(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              initialValue: _ingredients[index].name,
              onChanged: (v) => _ingredients[index].name = v,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Name",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: TextFormField(
              initialValue: _ingredients[index].quantity,
              onChanged: (v) => _ingredients[index].quantity = v,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Qty",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: TextFormField(
              initialValue: _ingredients[index].unit,
              onChanged: (v) => _ingredients[index].unit = v,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Unit",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _ingredients.removeAt(index)),
            icon: const Icon(Icons.close, color: Colors.grey, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildToolRow(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: _tools[index].name,
              onChanged: (v) => _tools[index].name = v,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Tool name",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _tools.removeAt(index)),
            icon: const Icon(Icons.close, color: Colors.grey, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${index + 1}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              InkWell(
                onTap: () => setState(() => _steps.removeAt(index)),
                child: Icon(Icons.close, color: Colors.grey[600], size: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: _steps[index].instruction,
            maxLines: 2,
            onChanged: (v) => _steps[index].instruction = v,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: "Instruction",
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: _steps[index].tips,
            onChanged: (v) => _steps[index].tips = v,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: "Tips (optional)",
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 18, color: Colors.grey[700]),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}