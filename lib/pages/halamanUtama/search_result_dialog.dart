import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:q_baca/models/books.dart';
import 'package:q_baca/pages/halamanUtama/book_detail_page.dart';
import 'package:q_baca/pages/halamanUtama/home_controller.dart';

class SearchResultDialog extends StatelessWidget {
  const SearchResultDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: Consumer<HomeController>(
            builder: (context, controller, child) {
              if (controller.isSearching) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.searchError != null) {
                return Center(child: Text(controller.searchError!));
              }

              final result = controller.searchResult;
              if (result == null ||
                  (result.titleMatch == null &&
                      result.authorMatches.isEmpty &&
                      result.categoryMatches.isEmpty)) {
                return const Center(
                  child: Text("Maaf, pencarian tidak ditemukan."),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Hasil untuk "${result.query}"',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 20),
                    if (result.titleMatch != null)
                      _buildBookTile(context, result.titleMatch!),
                    if (result.authorMatches.isNotEmpty)
                      _buildResultSection(
                        context,
                        'Penulis',
                        result.authorMatches,
                      ),
                    if (result.categoryMatches.isNotEmpty)
                      _buildResultSection(
                        context,
                        'Kategori',
                        result.categoryMatches,
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildResultSection(
    BuildContext context,
    String title,
    List<Book> books,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 8),
        // Spread operator (...) untuk mengubah list of widgets menjadi children
        ...books.map((book) => _buildBookTile(context, book)),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            // [PERBAIKAN #1] Nonaktifkan sementara tombol ini
            onPressed: () {
              // TODO: Implementasi halaman "Lihat Semua" untuk kategori/penulis
              // Untuk saat ini, kita hanya menutup dialog
              Navigator.of(context).pop();
            },
            child: const Text('Lihat semua...'),
          ),
        ),
        const Divider(height: 20),
      ],
    );
  }

  Widget _buildBookTile(BuildContext context, Book book) {
    // Gunakan Image.network jika URL, atau Image.asset jika path lokal
    final imageWidget = book.coverUrl.startsWith('http')
        ? Image.network(
            book.coverUrl,
            width: 40,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) =>
                const Icon(Icons.book, size: 40),
          )
        : Image.asset(
            book.coverUrl,
            width: 40,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) =>
                const Icon(Icons.book, size: 40),
          );

    return ListTile(
      leading: imageWidget,
      title: Text(book.title),
      subtitle: Text(book.author),
      // [PERBAIKAN #2] Aktifkan dan perbaiki logika onTap
      onTap: () {
        Navigator.of(context).pop(); // Tutup dialog dulu
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
