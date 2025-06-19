import 'package:flutter/foundation.dart';
import 'package:q_baca/api/api_services.dart';
import 'package:q_baca/models/books.dart';
import 'package:q_baca/models/users.dart';

class HomeController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = true;
  User? _user;
  List<Book> _popularBooks = [];
  List<Book> _newBooks = [];
  List<Book> _recommendedBooks = [];
  List<Book> _trendingBooks = [];
  List<String> _categories = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String get greetingName => _user?.firstName ?? 'Pembaca';
  List<Book> get popularBooks => _popularBooks;
  List<Book> get newBooks => _newBooks;
  List<Book> get recommendedBooks => _recommendedBooks;
  List<Book> get trendingBooks => _trendingBooks;
  List<String> get categories => _categories;
  String? get errorMessage => _errorMessage;

  HomeController() {
    fetchHomePageData();
  }

  Future<void> fetchHomePageData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      try {
        _user = await _apiService.fetchUserProfile();
      } catch (e) {
        print(
          "Info: Gagal mengambil profil user (mungkin belum login). Error: $e",
        );
        _user = null;
      }

      final publicDataResults = await Future.wait<dynamic>([
        _apiService.fetchBooks('popular'),
        _apiService.fetchBooks('recommendations'),
        _apiService.fetchBooks('new'),
        _apiService.fetchBooks('trending'),
        _apiService.fetchCategories(),
      ]);

      _popularBooks = publicDataResults[0] as List<Book>;
      _recommendedBooks = publicDataResults[1] as List<Book>;
      _newBooks = publicDataResults[2] as List<Book>;
      _trendingBooks = publicDataResults[3] as List<Book>;
      _categories = publicDataResults[4] as List<String>;
    } catch (e) {
      _errorMessage = "Gagal memuat data buku. Silakan coba lagi.";
      print("Error fatal saat memuat data publik: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
