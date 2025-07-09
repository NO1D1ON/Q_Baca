import 'package:flutter/foundation.dart';
import 'package:q_baca/core/api_services.dart';
import 'package:q_baca/models/transaction_model.dart';

class TransactionHistoryController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Transaction> _transactions = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  TransactionHistoryController() {
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transactions = await _apiService.fetchTransactionHistory();
    } catch (e) {
      _errorMessage = "Gagal memuat riwayat transaksi.";
      debugPrint("Error di TransactionHistoryController: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
