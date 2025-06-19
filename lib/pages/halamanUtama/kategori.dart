// lib/pages/halamanUtama/kategori.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:q_baca/pages/halamanUtama/kategoriLagi/category.dart';
import 'package:q_baca/api/api_services.dart'; // Import service yang baru kita buat
import 'package:q_baca/theme/palette.dart';
import 'package:q_baca/pages/halamanUtama/kategoriLagi/buku_kategori_sama.dart';

// Mengubah dari 'kategori' menjadi 'KategoriPage' agar lebih standar
// dan mengubahnya menjadi StatefulWidget
class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  // Future untuk menyimpan hasil pemanggilan API
  late Future<List<Category>> _categoriesFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Memanggil API saat halaman pertama kali dibuka
    _categoriesFuture = _apiService.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.colorPrimary, // Sesuai dengan tema
      appBar: AppBar(
        title: const Text(
          'Kategori',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Palette.hijauButton,
          ),
        ),
        backgroundColor: Palette.colorPrimary,
        elevation: 0,
        automaticallyImplyLeading: false, // Menghilangkan tombol back
      ),
      body: FutureBuilder<List<Category>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          // 1. Saat data sedang dimuat
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Palette.hijauButton),
            );
          }
          // 2. Jika terjadi error
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // 3. Jika data tidak ditemukan atau kosong
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada kategori ditemukan.'));
          }

          // 4. Jika data berhasil dimuat
          final allCategories = snapshot.data!;

          // Ambil 5 kategori pertama dari API
          final apiCategories = allCategories.take(5).toList();

          // Buat kategori "Lainnya" secara manual
          // Ganti 'imageUrl' dengan URL gambar placeholder yang Anda inginkan
          final lainnyaCategory = Category(
            id: 0, // ID 0 atau -1 untuk menandakan ini bukan dari API
            name: 'Lainnya',
            imageUrl:
                'https://images.unsplash.com/photo-1532012197267-da84d127e765?w=500&q=80',
          );

          // Gabungkan 5 kategori dari API dengan kategori "Lainnya"
          final displayCategories = [...apiCategories, lainnyaCategory];

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 kolom, responsif secara default
              crossAxisSpacing: 16, // Jarak antar kolom
              mainAxisSpacing: 16, // Jarak antar baris
              childAspectRatio: 0.85, // Rasio aspek kartu (lebar / tinggi)
            ),
            itemCount: displayCategories.length, // Total 6 item
            itemBuilder: (context, index) {
              final category = displayCategories[index];
              return _buildCategoryCard(context, category);
            },
          );
        },
      ),
    );
  }

  // Widget untuk membangun setiap kartu kategori
  Widget _buildCategoryCard(BuildContext context, Category category) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman daftar buku dengan membawa data kategori
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryBooksPage(category: category),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Gambar Latar
            CachedNetworkImage(
              imageUrl: category.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[300]),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            // Lapisan Gelap (Scrim)
            Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
            ),
            // Teks Nama Kategori
            Center(
              child: Text(
                category.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
