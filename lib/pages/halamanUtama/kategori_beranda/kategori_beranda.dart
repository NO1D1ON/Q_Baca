import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:q_baca/controllers/category_books_controller.dart';
import 'package:q_baca/models/books_model.dart';
import 'package:q_baca/pages/halamanUtama/buku/book_detail_page.dart';
import 'package:q_baca/models/category_model.dart';
import 'package:q_baca/pages/halamanUtama/beranda/home_controller.dart'; // Import untuk HomeController
import 'package:q_baca/core/palette.dart';
import 'package:q_baca/pages/halamanUtama/kategori_buku/book_list_item.dart';

class CategoryBooksPage extends StatelessWidget {
  final Category category;
  const CategoryBooksPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // [PERBAIKAN] Kirim seluruh objek 'category' ke controller
      create: (_) => CategoryBooksController(category),
      child: Scaffold(
        appBar: AppBar(
          title: Text(category.name), // Judul halaman sesuai nama kategori
        ),
        body: Consumer<CategoryBooksController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage != null) {
              return Center(child: Text(controller.errorMessage!));
            }

            if (controller.books.isEmpty) {
              return const Center(
                child: Text('Tidak ada buku dalam kategori ini.'),
              );
            }

            // Tampilkan daftar buku dalam bentuk ListView
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: controller.books.length,
              itemBuilder: (context, index) {
                final book = controller.books[index];
                // Menggunakan widget terpisah agar kode lebih rapi
                return BookListItem(book: book);
              },
            );
          },
        ),
      ),
    );
  }

  // Widget untuk loading state dengan skeleton grid
  Widget _buildLoadingGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.65,
        ),
        itemCount: 6, // Tampilkan 6 skeleton placeholder
        itemBuilder: (context, index) {
          return _buildSkeletonCard();
        },
      ),
    );
  }

  // Widget skeleton untuk loading state
  Widget _buildSkeletonCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 4),
                  Container(height: 12, width: 80, color: Colors.grey[300]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk error state
  Widget _buildErrorWidget(CategoryBooksController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Terjadi Kesalahan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => controller.fetchBooks(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.hijauButton,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Coba Lagi',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk empty state
  Widget _buildEmptyWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Belum Ada Buku',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tidak ada buku dalam kategori ${category.name} saat ini.',
              style: TextStyle(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Widget utama untuk menampilkan grid buku-buku
  Widget _buildBooksGrid(BuildContext context, List<Book> books) {
    return RefreshIndicator(
      onRefresh: () async {
        // Refresh data ketika user pull to refresh
        await context.read<CategoryBooksController>().fetchBooks();
      },
      color: Palette.hijauButton,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 kolom
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.65, // Rasio tinggi/lebar untuk card
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return _buildBookCard(context, book);
          },
        ),
      ),
    );
  }

  // Widget card untuk setiap buku
  Widget _buildBookCard(BuildContext context, Book book) {
    return InkWell(
      onTap: () {
        // [PERBAIKAN] Ambil HomeController dari parent context jika ada
        // Jika tidak ada, navigasi tanpa HomeController
        HomeController? homeController;
        try {
          homeController = context.read<HomeController>();
        } catch (e) {
          // Jika HomeController tidak ditemukan, lanjutkan tanpa controller
          homeController = null;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (newContext) {
              // Jika ada HomeController, wariskan ke halaman detail
              if (homeController != null) {
                return ChangeNotifierProvider.value(
                  value: homeController,
                  child: BookDetailPage(bookId: book.id),
                );
              } else {
                // Jika tidak ada, buat halaman detail tanpa HomeController
                return BookDetailPage(bookId: book.id);
              }
            },
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 6,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover buku
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: book.coverUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Palette.hijauButton,
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.book, size: 32, color: Colors.grey[400]),
                        const SizedBox(height: 4),
                        Text(
                          book.title.isNotEmpty
                              ? book.title[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Detail buku
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Judul buku
                    Text(
                      book.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),

                    // Author dan rating
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 12,
                              color: Colors.amber[600],
                            ),
                            const SizedBox(width: 2),
                            Text(
                              book.rating.toString(),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.amber[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
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
