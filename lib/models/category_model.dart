class Category {
  final int id;
  final String name;
  final String imageUrl;
  final String slug;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json, String baseUrl) {
    String imagePath = json['image_path'] ?? '';
    String finalUrl = imagePath.isNotEmpty
        ? '$baseUrl/storage/$imagePath'
        // Fallback ke gambar placeholder jika kategori tidak punya gambar
        : 'https://pixabay.com/id/photos/terrier-yorkshire-anjing-satu-4400587/';

    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Tanpa Nama',
      imageUrl: finalUrl,
      slug: json['slug'] ?? '',
    );
  }
}
