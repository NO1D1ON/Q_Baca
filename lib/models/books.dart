class Book {
  final int id;
  final String title;
  final String author;
  final String coverUrl;
  final String description;
  final double rating;
  final int price;
  final String releaseDate;
  bool isFavorite;
  bool isPurchased;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.description,
    required this.rating,
    required this.price,
    required this.releaseDate,
    this.isFavorite = false,
    required this.isPurchased,
  });

  factory Book.fromJson(Map<String, dynamic> json, String baseUrl) {
    String imagePath = json['cover'] ?? '';
    String finalUrl;

    if (imagePath.startsWith('assets/')) {
      finalUrl = imagePath;
    } else if (imagePath.isNotEmpty) {
      finalUrl = '$baseUrl/storage/$imagePath';
    } else {
      finalUrl = 'assets/pageIcon/slide1.png'; // default fallback image
    }

    double parsedRating = 0.0;
    if (json['rating'] != null) {
      parsedRating = double.tryParse(json['rating'].toString()) ?? 0.0;
    }

    int parsedPrice = 0;
    if (json['harga'] != null) {
      final priceAsDouble = double.tryParse(json['harga'].toString());
      if (priceAsDouble != null) {
        parsedPrice = priceAsDouble.toInt();
      }
    }

    return Book(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Tanpa Judul',
      author: json['penulis'] ?? 'Penulis Tidak Diketahui',
      coverUrl: finalUrl,
      description: json['description'] ?? 'Tidak ada deskripsi.',
      rating: parsedRating,
      price: parsedPrice,
      releaseDate: json['release_date'] ?? '', // <- Perbaikan utama
      isFavorite: json['is_favorited_by_user'] ?? false,
      isPurchased: json['is_purchased_by_user'] ?? false,
    );
  }
}
