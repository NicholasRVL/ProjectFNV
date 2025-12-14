import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fnv/model/masakan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {

  final ResepMakanan masakan;

  const DetailScreen({super.key, required this.masakan});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;
  bool isSignedIn = false;

  Future<void> _toogleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //Memeriksa apakah pengguna sudah sign in
    if (!isSignedIn) {
      //Jika belum sign in, arahkan ke SignInScreen
      WidgetsBinding.instance.addPostFrameCallback((_){
        Navigator.pushReplacementNamed(context, '/signin');
      });
      return;
    }

    bool favoriteStatus = !isFavorite;
    prefs.setBool('favorite_${widget.masakan.nama}', favoriteStatus);

    setState(() {
      isFavorite = favoriteStatus;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
        children: [
          // Detail Header
          Stack(
            children: [
              // Image utama
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    widget.masakan.gambar,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Tombol back custom
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32,
                ),    
                child: Container(
                  
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[100]?.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                      icon: const Icon(
                      Icons.arrow_back,
                    ),
                  ),
                ),
              ), 
            ],
          ),
          // Detail Info 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                // Info atas (nama candi dan tombol favorit)
                Row(  
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.masakan.nama,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        _toogleFavorite();
                      }, 
                      icon: Icon(isSignedIn && isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                      color: isSignedIn && isFavorite ? Colors.red : null,),
                    )
                  ],
                ),
                // Info tengah (lokasi, dibangun, tipe)
                SizedBox(height: 16,),
                Row(children: [
                  Icon(Icons.place, color: Colors.red,),
                  SizedBox(width: 8,),
                  SizedBox(width: 70,
                      child: Text('Deskripsi', style: TextStyle(
                          fontWeight: FontWeight.bold),),),
                  Text(': ${widget.masakan.deskripsi}',),
                ],),
                Row(children: [
                  Icon(Icons.calendar_month, color: Colors.blue,),
                  SizedBox(width: 8,),
                  SizedBox(width: 70,
                    child: Text('Gambar', style: TextStyle(
                      fontWeight: FontWeight.bold),),),
                  Text(': ${widget.masakan.gambar}'),
                ],),
                Row(children: [
                  Icon(Icons.house, color: Colors.green,),
                  SizedBox(width: 8,),
                  SizedBox(width: 70,
                    child: Text('Bahan', style: TextStyle(
                      fontWeight: FontWeight.bold),),),
                  Text(': ${widget.masakan.bahan}'),
                ],),
                Row(children: [
                  Icon(Icons.house, color: Colors.green,),
                  SizedBox(width: 8,),
                  SizedBox(width: 70,
                    child: Text('Langkah', style: TextStyle(
                      fontWeight: FontWeight.bold),),),
                  Text(': ${widget.masakan.langkah}'),
                ],),
                Row(children: [
                  Icon(Icons.fire_extinguisher, color: Colors.green,),
                  SizedBox(width: 8,),
                  SizedBox(width: 70,
                    child: Text('Waktu Memasak', style: TextStyle(
                      fontWeight: FontWeight.bold),),),
                  Text(': ${widget.masakan.waktuMasak}'),
                ],),
                Row(children: [
                  Icon(Icons.fire_extinguisher, color: Colors.green,),
                  SizedBox(width: 8,),
                  SizedBox(width: 70,
                    child: Text('Tingkat Kesulitan', style: TextStyle(
                      fontWeight: FontWeight.bold),),),
                  Text(': ${widget.masakan.tingkatKesulitan}'),
                ],),
                Row(children: [
                  Icon(Icons.fire_extinguisher, color: Colors.green,),
                  SizedBox(width: 8,),
                  SizedBox(width: 70,
                    child: Text('Asal', style: TextStyle(
                      fontWeight: FontWeight.bold),),),
                  Text(': ${widget.masakan.asal}'),
                ],),
                SizedBox(height: 16,),
                Divider(color: Colors.deepPurple.shade100,),
                SizedBox(height: 16,),
                // Info bawah (deskripsi)
              ],
            ),
          ),
          // Detail Gallery
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: Colors.deepPurple.shade100,),
                Text('Galeri', style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}