class ResepMakanan {
  final String id;
  final String nama;
  final String deskripsi;
  final String gambar;
  final List<String> bahan;
  final List<String> langkah;
  final String waktuMasak;
  final String tingkatKesulitan;
  final String asal;

  ResepMakanan({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.gambar,
    required this.bahan,
    required this.langkah,
    required this.waktuMasak,
    required this.tingkatKesulitan,
    required this.asal,
  });
}