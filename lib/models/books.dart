class Book {
  final int id;
  final String title;
  final String author;
  final String coverUrl;
  final double rating;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.rating,
  });

  factory Book.fromJson(Map<String, dynamic> json, String baseUrl) {
    String imagePath = json['cover'] ?? '';
    String finalUrl;

    // PERBAIKAN: Cek apakah path gambar adalah path aset lokal atau URL dari server
    if (imagePath.startsWith('assets/')) {
      finalUrl = imagePath; // Langsung gunakan jika sudah path aset
    } else if (imagePath.isNotEmpty) {
      finalUrl =
          '$baseUrl/storage/$imagePath'; // Bangun URL lengkap jika dari server
    } else {
      // Fallback jika tidak ada gambar sama sekali
      finalUrl = 'assets/pageIcon/slide1.png'; // Pastikan Anda punya gambar ini
    }

    return Book(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Tanpa Judul',
      author: json['penulis'] ?? 'Penulis Tidak Diketahui',
      coverUrl: finalUrl,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
