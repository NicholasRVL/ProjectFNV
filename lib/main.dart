import 'package:flutter/material.dart';
import 'package:fnv/Screens/detail_screen.dart';
import 'package:fnv/model/masakan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Resep Makanan',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const HomeScreen(),
    );
  }
}

/// ================= HOME SCREEN =================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ResepMakanan> resepList = [
      ResepMakanan(
        id: '1',
        nama: 'Nasi Goreng',
        deskripsi: 'Makanan khas Indonesia yang gurih dan lezat.',
        gambar: 'https://i.imgur.com/5Aqgz7o.jpg',
        bahan: [
          'Nasi putih',
          'Telur',
          'Bawang putih',
          'Kecap manis',
          'Garam',
        ],
        langkah: [
          'Panaskan minyak',
          'Tumis bawang putih',
          'Masukkan telur',
          'Masukkan nasi dan kecap',
          'Aduk hingga matang',
        ],
        waktuMasak: '15 menit',
        tingkatKesulitan: 'Mudah',
        asal: 'Indonesia',
      ),
      ResepMakanan(
        id: '2',
        nama: 'Mie Goreng',
        deskripsi: 'Mie goreng sederhana dan nikmat.',
        gambar: 'https://i.imgur.com/9Q9ZQZz.jpg',
        bahan: ['Mie', 'Telur', 'Bumbu mie'],
        langkah: ['Rebus mie', 'Masak telur', 'Campur bumbu'],
        waktuMasak: '10 menit',
        tingkatKesulitan: 'Mudah',
        asal: 'Indonesia',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resep Makanan'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: resepList.length,
        itemBuilder: (context, index) {
          final resep = resepList[index];

          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailScreen(masakan: resep,),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Gambar
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      resep.gambar,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// Nama
                        Text(
                          resep.nama,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        /// Deskripsi
                        Text(
                          resep.deskripsi,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black54),
                        ),

                        const SizedBox(height: 10),

                        /// Info Row
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            _infoIcon(
                                Icons.timer, resep.waktuMasak),
                            _infoIcon(Icons.local_fire_department,
                                resep.tingkatKesulitan),
                            _infoIcon(
                                Icons.place, resep.asal),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoIcon(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.orange),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}