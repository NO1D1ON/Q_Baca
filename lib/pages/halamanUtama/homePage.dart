import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:q_baca/theme/palette.dart';
import 'package:q_baca/models/books.dart';
import 'package:q_baca/pages/halamanUtama/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:q_baca/logOut/logOut.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Langsung kembalikan HomeView. Provider-nya sudah ada di level yang lebih tinggi.
    return const HomeView();
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // [OPTIMASI] Baris `context.watch` di sini tidak lagi diperlukan
    // karena kita sudah menggunakan `Consumer` di bawah yang lebih efisien.
    // final controller = context.watch<HomeController>();

    return Container(
      color: Palette.colorPrimary,
      // `Consumer` adalah cara terbaik untuk listen ke perubahan controller
      // dan hanya me-rebuild widget yang diperlukan.
      child: Consumer<HomeController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const BerandaLoadingSkeleton();
          }

          if (controller.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.fetchHomePageData(),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          return SafeArea(
            child: RefreshIndicator(
              onRefresh: () => controller.fetchHomePageData(),
              color: Palette.hijauButton,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, controller.greetingName),
                    const SizedBox(height: 24),
                    _buildSearchBar(context),
                    const SizedBox(height: 24),
                    // [KUNCI PENYELESAIAN] Memanggil data yang TEPAT dari controller.
                    // Widget ini butuh List<String>, dan controller.categoryNames menyediakannya.
                    _buildCategoryChips(context, controller.categoryNames),
                    const SizedBox(height: 24),
                    BookCarousel(
                      title: 'Paling Banyak Dibaca',
                      books: controller.popularBooks,
                    ),
                    const SizedBox(height: 24),
                    BookCarousel(
                      title: 'Rekomendasi Untukmu',
                      books: controller.recommendedBooks,
                    ),
                    const SizedBox(height: 24),
                    BookCarousel(
                      title: 'Buku Terbaru',
                      books: controller.newBooks,
                    ),
                    const SizedBox(height: 24),
                    BookCarousel(
                      title: 'Sedang Tren',
                      books: controller.trendingBooks,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Halo, $name",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Palette.hijauButton,
              ),
            ),
            const Text(
              "Mau baca apa hari ini?",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: Palette.hijauButton,
            size: 28,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LogoutPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        hintText: 'Cari judul, penulis, atau kategori...',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onSubmitted: (query) {
        /* TODO: Implementasi pencarian API */
      },
    );
  }

  Widget _buildCategoryChips(BuildContext context, List<String> categoryNames) {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryNames.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(categoryNames[index]), // Menggunakan daftar nama
              onPressed: () {
                /* TODO: Implementasi filter */
              },
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BookCarousel extends StatelessWidget {
  final String title;
  final List<Book> books;

  const BookCarousel({super.key, required this.title, required this.books});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Palette.hijauButton,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                "Lihat Semua",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 220,
          child: books.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text("Tidak ada buku dalam kategori ini."),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: books.length,
                  itemBuilder: (context, index) => BookCard(book: books[index]),
                ),
        ),
      ],
    );
  }
}

// --- WIDGET BARU UNTUK PLACEHOLDER YANG KONSISTEN ---
class ConsistentBookPlaceholder extends StatelessWidget {
  final Book book;

  const ConsistentBookPlaceholder({super.key, required this.book});

  // Daftar warna yang telah ditentukan untuk placeholder
  static const List<Color> _placeholderColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.amber,
    Colors.indigo,
    Colors.cyan,
  ];

  @override
  Widget build(BuildContext context) {
    // Pilih warna dari daftar berdasarkan hash code dari judul buku
    // Ini memastikan setiap judul buku akan selalu mendapatkan warna yang sama
    final colorIndex = book.title.hashCode % _placeholderColors.length;
    final baseColor = _placeholderColors[colorIndex];

    // Gunakan huruf pertama dari judul sebagai inisial
    final Widget child;
    if (book.title.isNotEmpty) {
      child = Text(
        book.title[0].toUpperCase(),
        style: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: baseColor,
        ),
      );
    } else {
      // Fallback jika judul kosong
      child = Icon(Icons.book_outlined, size: 50, color: baseColor);
    }

    return Container(
      decoration: BoxDecoration(
        // Gunakan warna dasar dengan transparansi untuk latar belakang
        color: baseColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: child),
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;
  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Tapped on book: ${book.title}');
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: SizedBox(
          width: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: book.coverUrl.startsWith('assets/')
                      ? Image.asset(
                          book.coverUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return ConsistentBookPlaceholder(book: book);
                          },
                        )
                      : CachedNetworkImage(
                          imageUrl: book.coverUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              color: Palette.hijauButton,
                              strokeWidth: 2.0,
                            ),
                          ),
                          errorWidget: (context, url, error) {
                            return ConsistentBookPlaceholder(book: book);
                          },
                        ),
                ),
              ),

              // --- PERUBAHAN UNTUK MENGATASI OVERFLOW ---
              Container(
                // 1. Tambah tinggi kontainer sedikit agar lebih aman
                height: 68,
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        // 2. Atur jarak antar baris agar lebih padat dan dapat diprediksi
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // --- AKHIR PERUBAHAN ---
            ],
          ),
        ),
      ),
    );
  }
}

class BerandaLoadingSkeleton extends StatelessWidget {
  const BerandaLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 150,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 200,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: List.generate(
                3,
                (_) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    width: 80,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(
              4,
              (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 130,
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 100,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 70,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
