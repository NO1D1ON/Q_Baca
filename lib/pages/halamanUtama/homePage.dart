import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:q_baca/pages/halamanUtama/book_detail_page.dart';
import 'package:q_baca/pages/halamanUtama/kategoriLagi/buku_kategori_sama.dart';
import 'package:q_baca/pages/halamanUtama/kategoriLagi/category.dart';
import 'package:q_baca/pages/halamanUtama/notification_homepage.dart';
import 'package:q_baca/pages/halamanUtama/search_result_dialog.dart';
import 'package:shimmer/shimmer.dart';
import 'package:q_baca/theme/palette.dart';
import 'package:q_baca/models/books.dart';
import 'package:q_baca/pages/halamanUtama/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // [PERBAIKAN UTAMA] Kembalikan ChangeNotifierProvider ke sini.
    // Ini memastikan HomeView dan semua widget di bawahnya bisa menemukan HomeController.
    return ChangeNotifierProvider(
      create: (context) => HomeController(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.colorPrimary,
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
                    // [PERBAIKAN #1] Kirim seluruh objek 'controller' ke _buildHeader
                    _buildHeader(context, controller),
                    const SizedBox(height: 24),
                    _buildSearchBar(context),
                    const SizedBox(height: 24),
                    // _buildCategoryChips(context, controller.categoryNames),
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

  // [PERBAIKAN #2] Ubah parameter kedua dari 'String name' menjadi 'HomeController controller'
  Widget _buildHeader(BuildContext context, HomeController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // [PERBAIKAN #3] Ambil nama dari controller.greetingName
            Text(
              "Halo, ${controller.greetingName}",
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
        // [PERBAIKAN #4] Panggilan ini sekarang valid karena 'controller' sudah dikenal
        _buildNotificationButton(context, controller.hasUnreadNotifications),
      ],
    );
  }

  // Widget ini sudah benar, tidak perlu diubah
  Widget _buildNotificationButton(BuildContext context, bool hasUnread) {
    return Stack(
      children: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: Palette.hijauButton,
            size: 28,
          ),
          onPressed: () {
            // Ambil controller menggunakan context.read (karena kita tidak me-rebuild)
            // Tandai notifikasi sebagai sudah dibaca di UI
            context.read<HomeController>().markNotificationsAsRead();

            // Arahkan ke halaman notifikasi
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationPage()),
            );
          },
        ),
        if (hasUnread)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
            ),
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
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Palette.hijauButton, width: 2),
        ),
      ),

      onSubmitted: (query) {
        if (query.trim().isNotEmpty) {
          // Ambil instance HomeController yang sudah ada menggunakan context.read.
          // Kita gunakan `read` karena kita hanya memanggil fungsi, tidak perlu me-rebuild widget ini.
          final homeController = context.read<HomeController>();
          homeController.performSearch(query);

          // Tampilkan dialog
          showDialog(
            context: context,
            builder: (dialogContext) {
              // [KUNCI SOLUSI] Bungkus dialog dengan ChangeNotifierProvider.value
              // untuk "meminjamkan" controller yang sudah ada ke dialog.
              return ChangeNotifierProvider.value(
                value: homeController,
                child: const SearchResultDialog(),
              );
            },
          );
        }
      },
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
            // TextButton(
            //   onPressed: () {},
            //   child: const Text(
            //     "Lihat Semua",
            //     style: TextStyle(color: Colors.grey),
            //   ),
            // ),
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
    return InkWell(
      // [PERBAIKAN UTAMA DAN SATU-SATUNYA YANG DIPERLUKAN]
      onTap: () {
        // 1. Ambil HomeController yang sudah ada dari context saat ini.
        final homeController = context.read<HomeController>();

        // 2. Lakukan navigasi seperti biasa.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (newContext) {
              // 3. Bungkus halaman tujuan (BookDetailPage) dengan Provider.value
              //    untuk "mewariskan" HomeController yang sudah kita ambil.
              return ChangeNotifierProvider.value(
                value: homeController,
                child: BookDetailPage(bookId: book.id),
              );
            },
          ),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: book.coverUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey[200]),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              book.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
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
