import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:fnv/model/api_resep_makanan.dart';
import 'package:fnv/model/model_bahan.dart';
import 'package:fnv/model/model_alat.dart';
import 'package:fnv/model/model_kategori.dart';
import 'package:fnv/model/step_model.dart';

class FormEditResep extends StatefulWidget {
  final ModelResep resep;

  const FormEditResep({super.key, required this.resep});

  @override
  State<FormEditResep> createState() => _FormEditResepState();
}

class _FormEditResepState extends State<FormEditResep> {
  final _formKey = GlobalKey<FormState>();

  final String _apiUrl =
      'https://food-api-omega-eight.vercel.app/api/api/public/recipes';

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _prepController = TextEditingController();
  final _cookController = TextEditingController();
  final _servingsController = TextEditingController();
  final _imgController = TextEditingController();

  List<ModelBahan> _ingredients = [];
  List<ModelAlat> _tools = [];
  List<StepModel> _steps = [];

  List<ModelKategori> _categories = [];
  ModelKategori? _selectedCategory;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fillInitialData();
    _fetchCategories();
  }

  void _fillInitialData() {
    final r = widget.resep;

    _titleController.text = r.title ?? '';
    _descController.text = r.description ?? '';
    _prepController.text = r.prepTime?.toString() ?? '';
    _cookController.text = r.cookTime?.toString() ?? '';
    _servingsController.text = r.servings?.toString() ?? '';
    _imgController.text = r.coverImage ?? '';

    _ingredients = List.from(r.ingredients ?? []);
    _tools = List.from(r.tools ?? []);
    _steps = List.from(r.steps ?? []);
    _selectedCategory = r.category;
  }

  Future<void> _fetchCategories() async {
    final res = await http.get(
      Uri.parse('https://food-api-omega-eight.vercel.app/api/api/categories'),
    );

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final cats = (json['data'] as List)
          .map((e) => ModelKategori.fromJson(e))
          .toList();

      setState(() {
        _categories = cats;
        if (widget.resep.category != null) {
          _selectedCategory = _categories.firstWhere(
            (c) => c.id == widget.resep.category!.id,
            orElse: () => _categories.first,
          );
        }
      });
    }
  }

  Future<void> _updateResep() async {
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
      'ingredients': _ingredients
          .map((e) => {'name': e.name, 'quantity': e.quantity, 'unit': e.unit})
          .toList(),
      'tools': _tools.map((e) => {'name': e.name}).toList(),
      'steps': _steps.asMap().entries.map((e) {
        return {
          'position': e.key + 1,
          'instruction': e.value.instruction,
          'tips': e.value.tips,
        };
      }).toList(),
    };

    final res = await http.put(
      Uri.parse('$_apiUrl/${widget.resep.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    setState(() => _isLoading = false);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Resep berhasil diupdate')));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(res.body)));
    }
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
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
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
                          'Edit Resep',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),

                        _label('Nama'),
                        _input(_titleController, required: true),

                        _label('Kategori'),
                        _categoryDropdown(),

                        _label('Tambah gambar'),
                        _input(_imgController),

                        _label('Deskripsi'),
                        _input(_descController, maxLines: 4),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Waktu persiapan'),
                                  _number(_prepController),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Waktu masak'),
                                  _number(_cookController),
                                ],
                              ),
                            ),
                          ],
                        ),

                        _label('Jumlah penyajian'),
                        _number(_servingsController),

                        const SizedBox(height: 24),

                        _section('Bahan-bahan'),
                        ..._ingredients.asMap().entries.map(_ingredientRow),
                        _addBtn(
                          'Tambah bahan',
                          () => setState(
                            () => _ingredients.add(
                              ModelBahan(name: '', quantity: '', unit: ''),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        _section('Alat memasak'),
                        ..._tools.asMap().entries.map(_toolRow),
                        _addBtn(
                          'Tambah alat',
                          () => setState(() => _tools.add(ModelAlat(name: ''))),
                        ),

                        const SizedBox(height: 24),

                        _section('Langkah memasak'),
                        ..._steps.asMap().entries.map(_stepRow),
                        _addBtn(
                          'Tambah langkah',
                          () => setState(
                            () => _steps.add(
                              StepModel(instruction: '', tips: ''),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: _updateResep,
                            child: const Text(
                              'Update',
                              style: TextStyle(color: Colors.white),
                            ),
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

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      t,
      style: TextStyle(
        fontSize: 13,
        color: Colors.grey[700],
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  Widget _input(
    TextEditingController c, {
    bool required = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        maxLines: maxLines,
        validator: required ? (v) => v!.isEmpty ? 'diisi' : null : null,
      ),
    );
  }

  Widget _number(TextEditingController c) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: c,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    ),
  );

  Widget _section(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(t, style: const TextStyle(fontWeight: FontWeight.w600)),
  );

  Widget _addBtn(String t, VoidCallback onTap) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(child: Text(t)),
    ),
  );

  Widget _categoryDropdown() => DropdownButtonFormField<ModelKategori>(
    value: _selectedCategory,
    items: _categories
        .map((e) => DropdownMenuItem(value: e, child: Text(e.name ?? '')))
        .toList(),
    onChanged: (v) => setState(() => _selectedCategory = v),
  );

  Widget _ingredientRow(MapEntry<int, ModelBahan> e) => Row(
    children: [
      Expanded(
        child: TextFormField(
          initialValue: e.value.name,
          onChanged: (v) => e.value.name = v,
          decoration: const InputDecoration(hintText: 'Nama'),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: TextFormField(
          initialValue: e.value.quantity,
          onChanged: (v) => e.value.quantity = v,
          decoration: const InputDecoration(hintText: 'Qty'),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: TextFormField(
          initialValue: e.value.unit,
          onChanged: (v) => e.value.unit = v,
          decoration: const InputDecoration(hintText: 'Unit'),
        ),
      ),
      IconButton(
        onPressed: () => setState(() => _ingredients.removeAt(e.key)),
        icon: const Icon(Icons.close, size: 20),
      ),
    ],
  );

  Widget _toolRow(MapEntry<int, ModelAlat> e) => Row(
    children: [
      Expanded(
        child: TextFormField(
          initialValue: e.value.name,
          onChanged: (v) => e.value.name = v,
          decoration: const InputDecoration(hintText: 'Nama alat'),
        ),
      ),
      IconButton(
        onPressed: () => setState(() => _tools.removeAt(e.key)),
        icon: const Icon(Icons.close, size: 20),
      ),
    ],
  );

  Widget _stepRow(MapEntry<int, StepModel> e) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey[300]!),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Column(
      children: [
        TextFormField(
          initialValue: e.value.instruction,
          onChanged: (v) => e.value.instruction = v,
          decoration: const InputDecoration(hintText: 'Instruksi'),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: e.value.tips,
          onChanged: (v) => e.value.tips = v,
          decoration: const InputDecoration(hintText: 'Tips'),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () => setState(() => _steps.removeAt(e.key)),
            icon: const Icon(Icons.delete),
          ),
        ),
      ],
    ),
  );
}
