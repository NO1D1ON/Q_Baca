// lib/pages/book_detail_page.dart (VERSI FINAL - IMPROVED UI)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:q_baca/controllers/book_detail_controller.dart';
import 'package:q_baca/models/books_model.dart';
import 'package:q_baca/core/palette.dart';
import 'package:intl/intl.dart';
import 'dart:ui'; // Untuk ImageFilter.blur

class BookDetailPage extends StatelessWidget {
  final int bookId;
  const BookDetailPage({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookDetailController(bookId),
      child: Consumer<BookDetailController>(
        builder: (context, controller, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true, // Extend body behind app bar
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              actions: [
                if (controller.book != null)
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: Icon(
                        controller.book!.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () => controller.toggleFavorite(context),
                    ),
                  ),
              ],
            ),
            body: _buildContent(context, controller),
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
    final screenHeight = MediaQuery.of(context).size.height;
    final coverHeight = screenHeight * 0.5; // 50% dari tinggi layar

    return SingleChildScrollView(
      child: Column(
        children: [
          // Bagian Cover dengan Stack (Background blur + Cover asli)
          _buildCoverSection(book, coverHeight),

          // Bagian Detail Buku
          _buildDetailSection(book),
        ],
      ),
    );
  }

  Widget _buildCoverSection(Book book, double coverHeight) {
    return SizedBox(
      height: coverHeight,
      child: Stack(
        children: [
          // Background blur layer (lapisan paling bawah)
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: book.coverUrl,
              fit: BoxFit.cover,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    color: Colors.black.withOpacity(0.3), // Overlay gelap
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.error),
              ),
            ),
          ),

          // Cover buku asli (lapisan atas)
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 30), // Margin untuk app bar
              height: coverHeight * 0.8, // 70% dari tinggi section
              child: AspectRatio(
                aspectRatio: 3 / 4, // Rasio standar buku
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: book.coverUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(Book book) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Palette.colorPrimary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Buku
            Center(
              child: Text(
                book.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),

            // Penulis
            Center(
              child: Text(
                book.author,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Harga dan Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Harga
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Palette.hijauButton.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
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
                ),

                // Rating
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        "${book.rating}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Deskripsi
            const Text(
              'Deskripsi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              book.description,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                height: 1.6,
                color: Colors.black54,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 100), // Ruang untuk bottom button
          ],
        ),
      ),
    );
  }

  Widget? _buildBottomButton(
    BuildContext context,
    BookDetailController controller,
  ) {
    if (controller.book == null) return null;

    final book = controller.book!;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Palette.colorPrimary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.hijauButton,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
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
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Konfirmasi Pembelian'),
          content: Text(
            'Anda akan membeli "${book.title}" seharga ${currencyFormatter.format(book.price)}. Lanjutkan?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Palette.hijauButton,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Ya, Beli'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                controller.buyBook(context);
              },
            ),
          ],
        );
      },
    );
  }
}
