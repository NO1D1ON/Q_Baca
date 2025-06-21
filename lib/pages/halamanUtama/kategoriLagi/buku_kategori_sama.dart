import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:q_baca/controllers/category_books_controller.dart';
import 'package:q_baca/models/books.dart';
import 'package:q_baca/pages/halamanUtama/book_detail_page.dart';
import 'package:q_baca/pages/halamanUtama/kategoriLagi/category.dart';

class CategoryBooksPage extends StatelessWidget {
  final Category category;
  const CategoryBooksPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // [PERBAIKAN UTAMA] Sediakan controller khusus untuk halaman ini
    return ChangeNotifierProvider(
      create: (_) => CategoryBooksController(category.id),
      child: Scaffold(
        appBar: AppBar(title: Text(category.name)),
        // Gunakan Consumer untuk listen ke controller
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

            // Jika berhasil, tampilkan daftar buku
            return ListView.builder(
              itemCount: controller.books.length,
              itemBuilder: (context, index) {
                final book = controller.books[index];
                return _buildBookListItem(context, book);
              },
            );
          },
        ),
      ),
    );
  }

  // Widget helper untuk setiap item di daftar
  Widget _buildBookListItem(BuildContext context, Book book) {
    return ListTile(
      leading: SizedBox(
        width: 50,
        height: 70,
        child: CachedNetworkImage(
          imageUrl: book.coverUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: Colors.grey[200]),
          errorWidget: (context, url, error) => const Icon(Icons.book),
        ),
      ),
      title: Text(book.title),
      subtitle: Text(book.author),
      onTap: () {
        // Navigasi ke halaman detail buku saat item diklik
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailPage(bookId: book.id),
          ),
        );
      },
    );
  }
}
