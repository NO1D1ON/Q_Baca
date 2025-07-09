import 'package:flutter/foundation.dart' hide Category;
import 'package:q_baca/core/api_services.dart';
import 'package:q_baca/models/books_model.dart';
import 'package:q_baca/models/category_model.dart'; // <-- Pastikan model kategori di-import

class CategoryBooksController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  // [PERBAIKAN] Terima seluruh objek Category, bukan hanya ID
  final Category category;

  // [PERBAIKAN] Ubah konstruktor untuk menerima objek Category
  CategoryBooksController(this.category) {
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
      // [PERBAIKAN UTAMA] Panggil API menggunakan slug dari objek kategori
      _books = await _apiService.fetchBooksByCategory(category.slug);
    } catch (e) {
      _errorMessage = "Gagal memuat daftar buku.";
      debugPrint("Error di CategoryBooksController: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
