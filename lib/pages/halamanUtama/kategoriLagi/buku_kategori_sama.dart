import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:q_baca/controllers/category_books_controller.dart';
import 'package:q_baca/models/books.dart';
import 'package:q_baca/pages/halamanUtama/book_detail_page.dart';
import 'package:q_baca/pages/halamanUtama/kategoriLagi/category.dart';
import 'package:q_baca/theme/palette.dart';

class CategoryBooksPage extends StatelessWidget {
  final Category category;
  const CategoryBooksPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // [PERBAIKAN UTAMA] Sediakan controller khusus untuk halaman ini
    return ChangeNotifierProvider(
      create: (_) => CategoryBooksController(category.id),
      child: Scaffold(
        appBar: AppBar(
          title: Text(category.name),
          backgroundColor: Palette.colorPrimary,
        ),
        backgroundColor: Palette.colorPrimary,
        // Gunakan Consumer untuk listen ke controller baru
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

            // Jika berhasil, tampilkan daftar buku dalam bentuk GridView
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.6,
              ),
              itemCount: controller.books.length,
              itemBuilder: (context, index) {
                final book = controller.books[index];
                return InkWell(
                  onTap: () {
                    // TODO: Perbaiki navigasi ini agar mewariskan HomeController jika diperlukan
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookDetailPage(bookId: book.id),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: book.coverUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
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
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
