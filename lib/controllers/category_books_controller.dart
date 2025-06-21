import 'package:flutter/foundation.dart';
import 'package:q_baca/api/api_services.dart';
import 'package:q_baca/models/books.dart';

class CategoryBooksController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final int categoryId;

  CategoryBooksController(this.categoryId) {
    // Panggil fungsi untuk mengambil buku saat controller dibuat
    fetchBooks();
  }

  bool _isLoading = true;
  List<Book> _books = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<Book> get books => _books;
  String? get errorMessage => _errorMessage;

  Future<void> fetchBooks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Panggil fungsi API yang sudah kita buat sebelumnya
      _books = await _apiService.fetchBooksByCategory(categoryId);
    } catch (e) {
      _errorMessage = "Gagal memuat daftar buku.";
      debugPrint("Error di CategoryBooksController: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
