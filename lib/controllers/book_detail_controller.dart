// lib/controllers/book_detail_controller.dart (VERSI FINAL LENGKAP)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:q_baca/api/api_services.dart';
import 'package:q_baca/models/books.dart';
import 'package:q_baca/pages/halamanUtama/book_reader_page.dart';
import 'package:q_baca/theme/palette.dart'; // <-- Import halaman baru
import 'package:q_baca/pages/halamanUtama/home_controller.dart'; // [PERBAIKAN] Tambahkan import HomeController
import 'package:provider/provider.dart';
import 'package:q_baca/models/users.dart';

class BookDetailController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final int bookId;

  BookDetailController(this.bookId) {
    fetchBookDetails();
  }

  bool _isLoading = true;
  Book? _book;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  Book? get book => _book;
  String? get errorMessage => _errorMessage;

  Future<void> fetchBookDetails() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _book = await _apiService.fetchBookDetails(bookId);
    } catch (e) {
      _errorMessage = "Gagal memuat detail buku.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // [FUNGSI BARU] Untuk tombol favorit
  Future<void> toggleFavorite() async {
    if (_book == null) return;

    // 1. Update UI secara optimis untuk respons instan
    _book!.isFavorite = !_book!.isFavorite;
    notifyListeners();

    try {
      // 2. Kirim permintaan ke API
      // TODO: Buat fungsi toggleFavorite di ApiService Anda
      // await _apiService.toggleFavorite(bookId);
    } catch (e) {
      // 3. Jika gagal, kembalikan state UI ke semula
      _book!.isFavorite = !_book!.isFavorite;
      notifyListeners();
      // TODO: Tampilkan pesan error kepada pengguna
    }
  }

  // [FUNGSI BARU] Untuk tombol beli buku
  Future<void> buyBook(BuildContext context) async {
    if (_book == null) return;

    // Ambil data user dari HomeController
    final user = context.read<HomeController>().user;

    // [PERBAIKAN #1] Cek saldo di sisi aplikasi terlebih dahulu
    if (user == null || user.saldo < _book!.price) {
      _showPurchaseResultDialog(
        context: context,
        isSuccess: false,
        message: 'Saldo Anda tidak mencukupi untuk melakukan pembelian ini.',
        book: _book!,
      );
      return; // Hentikan fungsi jika saldo tidak cukup
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _apiService.buyBook(bookId);
      if (context.mounted) {
        _showPurchaseResultDialog(
          context: context,
          isSuccess: true,
          message: result['message'] ?? 'Pembelian berhasil!',
          book: _book!,
        );
        _book!.isPurchased = true;
      }
    } catch (e) {
      // [PERBAIKAN #2] Pastikan mengirim isSuccess: false saat error
      if (context.mounted) {
        _showPurchaseResultDialog(
          context: context,
          isSuccess: false,
          message: e.toString(),
          book: _book!,
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _showPurchaseResultDialog({
    required BuildContext context,
    required bool isSuccess,
    required String message,
    required Book book,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _PurchaseResultDialog(
          isSuccess: isSuccess,
          message: message,
          book: book,
        );
      },
    );
  }

  void readBook(BuildContext context) {
    if (_book == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookReaderPage(book: _book!)),
    );
  }
}

// Widget dialog tidak perlu diubah, sudah dinamis.
class _PurchaseResultDialog extends StatelessWidget {
  final bool isSuccess;
  final String message;
  final Book book;

  const _PurchaseResultDialog({
    required this.isSuccess,
    required this.message,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: isSuccess ? Colors.green.shade100 : Colors.red.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSuccess ? Icons.check_circle_outline : Icons.highlight_off,
              color: isSuccess ? Colors.green.shade700 : Colors.red.shade700,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            isSuccess ? 'Pembelian Berhasil!' : 'Pembelian Gagal',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          if (isSuccess) ...[
            const Divider(height: 30),
            _buildInfoRow(
              'Total Transaksi',
              currencyFormatter.format(book.price),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              'Waktu Transaksi',
              DateFormat('d MMM y, HH:mm').format(DateTime.now()),
            ),
          ],
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Palette.hijauButton,
              minimumSize: const Size(double.infinity, 45),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
