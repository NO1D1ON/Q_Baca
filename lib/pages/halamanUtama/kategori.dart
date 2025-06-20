// lib/pages/halamanUtama/kategori.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:q_baca/pages/halamanUtama/kategoriLagi/category.dart';
// import 'package:q_baca/api/api_services.dart'; // Import service yang baru kita buat
import 'package:q_baca/theme/palette.dart';
import 'package:q_baca/pages/halamanUtama/kategoriLagi/buku_kategori_sama.dart';
import 'home_controller.dart';

// Mengubah dari 'kategori' menjadi 'KategoriPage' agar lebih standar
// dan mengubahnya menjadi StatefulWidget
class KategoriPage extends StatelessWidget {
  const KategoriPage({super.key});

  @override
  Widget build(BuildContext context) {
    // [PERBAIKAN #5] Ambil data langsung dari HomeController yang sudah ada.
    final controller = context.watch<HomeController>();

    return Scaffold(
      backgroundColor: Palette.colorPrimary,
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
        automaticallyImplyLeading: false,
      ),
      // Tidak perlu lagi FutureBuilder, kita langsung tampilkan data dari controller.
      body: _buildCategoryGrid(context, controller.categoryList),
    );
  }

  // Memisahkan logika GridView ke dalam fungsi sendiri agar lebih rapi.
  Widget _buildCategoryGrid(
    BuildContext context,
    List<Category> allCategories,
  ) {
    if (allCategories.isEmpty) {
      // Menangani kasus jika kategori belum dimuat atau kosong.
      // Ini seharusnya tidak terjadi jika pengguna datang dari HomePage, tapi bagus untuk keamanan.
      return const Center(child: Text('Tidak ada kategori ditemukan.'));
    }

    // Logika untuk menampilkan 5 kategori + "Lainnya" tetap sama.
    final apiCategories = allCategories.take(5).toList();
    final lainnyaCategory = Category(
      id: 0,
      name: 'Lainnya',
      imageUrl:
          'https://images.unsplash.com/photo-1532012197267-da84d127e765?w=500&q=80',
    );
    final displayCategories = [...apiCategories, lainnyaCategory];

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: displayCategories.length,
      itemBuilder: (context, index) {
        final category = displayCategories[index];
        return _buildCategoryCard(context, category);
      },
    );
  }

  // Fungsi _buildCategoryCard tidak perlu diubah, sudah benar.
  Widget _buildCategoryCard(BuildContext context, Category category) {
    return GestureDetector(
      onTap: () {
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
            CachedNetworkImage(
              imageUrl: category.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[300]),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
            ),
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
