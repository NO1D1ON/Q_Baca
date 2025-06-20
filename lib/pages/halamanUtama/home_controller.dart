// FIX 1: 'hide Category' ditambahkan untuk menghindari konflik nama dengan class Category dari Flutter.
import 'package:flutter/foundation.dart' hide Category;
import 'package:q_baca/api/api_services.dart';
import 'package:q_baca/models/books.dart';
import 'package:q_baca/models/users.dart';
import 'package:q_baca/pages/halamanUtama/kategoriLagi/category.dart';

class HomeController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = true;
  User? _user;
  List<Book> _popularBooks = [];
  List<Book> _newBooks = [];
  List<Book> _recommendedBooks = [];
  List<Book> _trendingBooks = [];
  List<Category> _categories = [];
  String? _errorMessage;

  // Getters untuk diakses oleh UI
  bool get isLoading => _isLoading;
  String get greetingName => _user?.firstName ?? 'Pembaca';
  List<Book> get popularBooks => _popularBooks;
  List<Book> get newBooks => _newBooks;
  List<Book> get recommendedBooks => _recommendedBooks;
  List<Book> get trendingBooks => _trendingBooks;
  String? get errorMessage => _errorMessage;

  // [KONFIRMASI] Desain ini sudah SANGAT BAIK.
  // Menyediakan dua jenis data kategori untuk kebutuhan UI yang berbeda.
  /// Mengembalikan HANYA NAMA kategori untuk widget sederhana seperti chips.
  List<String> get categoryNames => _categories.map((c) => c.name).toList();

  /// Mengembalikan OBJEK LENGKAP kategori untuk halaman Kategori yang lebih detail.
  List<Category> get categoryList => _categories;

  HomeController() {
    fetchHomePageData();
  }

  Future<void> fetchHomePageData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Mengambil data user secara terpisah agar tidak memblokir UI utama jika gagal.
      try {
        _user = await _apiService.fetchUserProfile();
      } catch (e) {
        debugPrint(
          "Info: Gagal mengambil profil user (mungkin belum login). Error: $e",
        );
        _user = null;
      }

      // Menjalankan semua panggilan API untuk konten utama secara bersamaan.
      final publicDataResults = await Future.wait([
        _apiService.fetchBooks('popular'),
        _apiService.fetchBooks('recommendations'),
        _apiService.fetchBooks('new'),
        _apiService.fetchBooks('trending'),
        _apiService.fetchCategories(),
      ]);

      // Mengisi data dari hasil panggilan API.
      // Casting ini aman karena sudah berada di dalam blok try-catch.
      _popularBooks = publicDataResults[0] as List<Book>;
      _recommendedBooks = publicDataResults[1] as List<Book>;
      _newBooks = publicDataResults[2] as List<Book>;
      _trendingBooks = publicDataResults[3] as List<Book>;
      _categories = publicDataResults[4] as List<Category>; // Ini sudah benar.
    } catch (e, stackTrace) {
      // [PERBAIKAN #2] Menambahkan 'stackTrace' untuk debug yang lebih baik.
      _errorMessage = "Gagal memuat data. Silakan coba lagi nanti.";
      // Mencetak error yang lebih detail ke konsol untuk developer.
      debugPrint("--- Error fatal di HomeController ---");
      debugPrint("Pesan: $e");
      debugPrint("Stack Trace: $stackTrace");
      debugPrint("-----------------------------------");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
