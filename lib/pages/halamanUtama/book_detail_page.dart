// lib/pages/book_detail_page.dart (VERSI FINAL)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:q_baca/controllers/book_detail_controller.dart';
import 'package:q_baca/models/books.dart';
import 'package:q_baca/theme/palette.dart';
import 'package:intl/intl.dart';

class BookDetailPage extends StatelessWidget {
  final int bookId;
  const BookDetailPage({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookDetailController(bookId),
      // [PERBAIKAN] Gunakan Consumer agar bisa mengakses controller di Scaffold
      child: Consumer<BookDetailController>(
        builder: (context, controller, child) {
          return Scaffold(
            backgroundColor: Palette.colorPrimary,
            body: _buildContent(
              context,
              controller,
            ), // Kirim controller ke body
            // [PERBAIKAN] Tambahkan tombol dinamis di bawah
            bottomNavigationBar: _buildBottomButton(context, controller),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, BookDetailController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (controller.errorMessage != null) {
      return Center(child: Text(controller.errorMessage!));
    }
    if (controller.book == null) {
      return const Center(child: Text('Buku tidak ditemukan.'));
    }

    final book = controller.book!;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: MediaQuery.of(context).size.height * 0.4,
          pinned: true,
          backgroundColor: Palette.colorPrimary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
            // Pastikan warnanya kontras dengan background saat di-scroll
            color: Palette.hijauButton,
          ),
          iconTheme: const IconThemeData(color: Palette.hijauButton),
          actions: [
            IconButton(
              icon: Icon(
                book.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () => controller.toggleFavorite(context),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: const EdgeInsets.fromLTRB(40, 80, 40, 20),
              child: CachedNetworkImage(
                imageUrl: book.coverUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  book.author,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  NumberFormat.currency(
                    locale: 'id',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(book.price),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Palette.hijauButton,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildInfoRow(book),
                const Divider(height: 32),
                const Text(
                  'Deskripsi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  book.description,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(height: 1.5, color: Colors.black54),
                ),
                const SizedBox(
                  height: 80,
                ), // Beri ruang agar tidak tertutup tombol
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(Book book) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [_infoChip("Rating", "${book.rating}")],
    );
  }

  Widget _infoChip(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget? _buildBottomButton(
    BuildContext context,
    BookDetailController controller,
  ) {
    if (controller.book == null)
      return null; // Hanya cek buku, biarkan loading di tombol

    final book = controller.book!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.hijauButton,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        // Nonaktifkan tombol saat loading
        onPressed: controller.isLoading
            ? null
            : () {
                if (book.isPurchased) {
                  controller.readBook(context);
                } else {
                  _showPurchaseConfirmationDialog(context, controller);
                }
              },
        child: controller.isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : Text(
                book.isPurchased ? 'Baca Buku' : 'Beli Sekarang',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  void _showPurchaseConfirmationDialog(
    BuildContext context,
    BookDetailController controller,
  ) {
    final book = controller.book!;
    final currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Pembelian'),
          content: Text(
            'Anda akan membeli "${book.title}" seharga ${currencyFormatter.format(book.price)}. Lanjutkan?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                // Tutup hanya dialog
                Navigator.of(dialogContext).pop();
              },
            ),
            // Gunakan FilledButton agar terlihat sebagai aksi utama
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Palette.hijauButton,
              ),
              child: const Text('Ya, Beli'),
              onPressed: () {
                // Tutup dialog terlebih dahulu
                Navigator.of(dialogContext).pop();
                // Kemudian jalankan fungsi pembelian
                controller.buyBook(context);
              },
            ),
          ],
        );
      },
    );
  }
}
