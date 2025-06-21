import 'package:flutter/material.dart';
import 'package:q_baca/api/api_services.dart';

class TopUpController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final amountController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> submitTopUp(BuildContext context) async {
    final amountString = amountController.text.trim();
    if (amountString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jumlah top up tidak boleh kosong.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final amount = double.tryParse(amountString);
    if (amount == null || amount < 10000) {
      // Asumsi minimal top up 10,000
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan jumlah yang valid (minimal Rp 10.000).'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    // [PERBAIKAN UTAMA DI SINI]
    // Panggil ApiService dan simpan hasilnya (sebuah Map) ke dalam variabel `result`.
    final Map<String, dynamic> result = await _apiService.requestTopUp(amount);

    // Ambil nilai 'success' dan 'message' dari dalam Map.
    final bool isSuccess = result['success'] ?? false;
    final String message =
        result['message'] ?? 'Terjadi kesalahan tidak diketahui.';

    // Tampilkan notifikasi berdasarkan hasilnya.
    // Pastikan context masih valid sebelum digunakan.
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isSuccess ? Colors.green : Colors.red,
        ),
      );

      // Jika sukses, tutup dialog pop-up.
      if (isSuccess) {
        Navigator.of(context).pop();
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }
}
