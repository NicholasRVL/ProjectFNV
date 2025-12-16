import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fnv/model/model_request.dart';

class ListRequestScreen extends StatefulWidget {
  const ListRequestScreen({super.key});

  @override
  State<ListRequestScreen> createState() => _ListRequestScreenState();
}

class _ListRequestScreenState extends State<ListRequestScreen> {
  late Future<List<Request>> _requestsFuture;

  final String _baseUrl =
      'https://food-api-omega-eight.vercel.app/api/api/me/requests';

  final String _deleteBaseUrl =
      'https://food-api-omega-eight.vercel.app/api/api/me/requests';

  @override
  void initState() {
    super.initState();
    _requestsFuture = _fetchRequests();
  }

  Future<List<Request>> _fetchRequests() async {
    final Uri apiUrl = Uri.parse(_baseUrl);

    try {
      final res = await http.get(
        apiUrl,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (res.statusCode == 200) {
        if (res.body.isEmpty) return [];

        final data = jsonDecode(res.body);

        final List<dynamic> requestsJson = data['data'] ?? data;

        return requestsJson.map((json) => Request.fromJson(json)).toList();
      } else {
        String errorDetail = 'Status Code: ${res.statusCode}.';
        try {
          final errorJson = jsonDecode(res.body);
          if (errorJson.containsKey('message')) {
            errorDetail += ' API Message: ${errorJson['message']}';
          }
        } catch (_) {
          errorDetail += ' Server merespons dengan html.';
        }
        throw Exception('Gagal memuat request. $errorDetail');
      }
    } catch (e) {
      throw Exception('Kesalahan koneksi: ${e.toString()}');
    }
  }

  Future<void> _deleteRequest(int requestId) async {
    final url = '$_deleteBaseUrl/$requestId';
    debugPrint('Mengirim DELETE request ke URL: $url');

    final response = await http.delete(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request berhasil dihapus!')),
      );
      setState(() {
        _requestsFuture = _fetchRequests();
      });
    } else {
      final errorJson = jsonDecode(response.body);
      final errorMessage =
          errorJson['message'] ??
          'Gagal menghapus request. Status: ${response.statusCode}';

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  void _confirmDelete(int requestId, String title) {
    Navigator.of(context).pop();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('hapus request "$title"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteRequest(requestId);
              },
              child: const Text(
                'Hapus',
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar request'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            _requestsFuture = _fetchRequests();
          });
          return _requestsFuture;
        },
        child: FutureBuilder<List<Request>>(
          future: _requestsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error: ${snapshot.error.toString().replaceFirst('Exception: ', '')}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Tidak ada request resep yang ditemukan.'),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final request = snapshot.data![index];
                  return _buildRequestCard(request);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildRequestCard(Request request) {
    Color statusColor;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 2,
      child: ListTile(
        title: Text(
          request.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Kontak Pengirim: ${request.contact}'),
            const SizedBox(height: 4),
            Text(
              request.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          _showRequestDetail(request);
        },

      ),
    );
  }

 
  void _showRequestDetail(Request request) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(request.title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Divider(),
                const Text(
                  'Alasan:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(request.reason),
                const SizedBox(height: 8),
                const Text(
                  'Kontak:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(request.contact),
                const SizedBox(height: 8),
                const Text(
                  'Deskripsi:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(request.description),
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Color.fromARGB(255, 1, 10, 61),
              ),
              onPressed: () {
                _confirmDelete(request.id, request.title);
              },
            ),

            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
