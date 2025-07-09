// lib/pages/halamanUtama/home_controller.dart (VERSI FINAL)

import 'package:flutter/foundation.dart'
    hide Category; // hide Category tidak diperlukan jika import model benar
import 'package:q_baca/core/api_services.dart';
import 'package:q_baca/models/books_model.dart';
import 'package:q_baca/models/notification_model.dart';
import 'package:q_baca/models/users_model.dart';
// [PERBAIKAN #1] Import model Category yang benar.
import 'package:q_baca/models/category_model.dart';
import 'package:q_baca/models/search_result_model.dart';

class HomeController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = true;
  User? _user;
  List<Book> _popularBooks = [];
  List<Book> _newBooks = [];
  List<Book> _recommendedBooks = [];
  List<Book> _trendingBooks = [];
  List<Category> _categories = [];
  List<NotificationModel> _notifications = [];
  bool _hasUnreadNotifications = true;
  String? _errorMessage;
  bool _isSearching = false;
  SearchResult? _searchResult;
  String? _searchError;
  List<Book> _myBooks = [];
  List<Book> _favoriteBooks = [];

  // ... (semua getter Anda sudah benar)
  bool get isLoading => _isLoading;
  String get greetingName => _user?.firstName ?? 'Pembaca';
  List<Book> get popularBooks => _popularBooks;
  List<Book> get newBooks => _newBooks;
  List<Book> get recommendedBooks => _recommendedBooks;
  List<Book> get trendingBooks => _trendingBooks;
  List<String> get categoryNames => _categories.map((c) => c.name).toList();
  List<Category> get categoryList => _categories;
  List<NotificationModel> get notifications => _notifications;
  bool get hasUnreadNotifications => _hasUnreadNotifications;
  String? get errorMessage => _errorMessage;
  bool get isSearching => _isSearching;
  SearchResult? get searchResult => _searchResult;
  String? get searchError => _searchError;
  User? get user => _user;
  List<Book> get myBooks => _myBooks;
  List<Book> get favoriteBooks => _favoriteBooks;

  HomeController() {
    fetchHomePageData();
  }

  Future<void> fetchHomePageData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Panggil profil user secara terpisah
      try {
        _user = await _apiService.fetchUserProfile();
      } catch (e) {
        debugPrint("Info: Gagal mengambil profil user. Error: $e");
        _user = null;
      }

      // [SINKRONISASI] Panggil 6 API di sini
      final publicDataResults = await Future.wait([
        _apiService.fetchBooks('popular'), // Indeks 0
        _apiService.fetchBooks('recommendations'), // Indeks 1
        _apiService.fetchBooks('new'), // Indeks 2
        _apiService.fetchBooks('trending'), // Indeks 3
        _apiService.fetchCategories(), // Indeks 4
        _apiService.fetchNotifications(),
        _apiService.fetchMyBooks(),
        _apiService.fetchMyFavorites(), // Indeks 5
      ]);

      // [SINKRONISASI] Ambil 6 hasil sesuai indeksnya
      _popularBooks = publicDataResults[0] as List<Book>;
      _recommendedBooks = publicDataResults[1] as List<Book>;
      _newBooks = publicDataResults[2] as List<Book>;
      _trendingBooks = publicDataResults[3] as List<Book>;
      _categories = publicDataResults[4] as List<Category>;
      // [PERBAIKAN #2] Gunakan indeks yang benar (5) untuk notifikasi
      _notifications = publicDataResults[5] as List<NotificationModel>;
      _myBooks = publicDataResults[6] as List<Book>;
      _favoriteBooks = publicDataResults[7] as List<Book>;

      _hasUnreadNotifications = _notifications.any((notif) => !notif.isRead);
    } catch (e, stackTrace) {
      _errorMessage = "Gagal memuat data. Silakan coba lagi nanti.";
      debugPrint("--- Error fatal di HomeController ---");
      debugPrint("Pesan: $e");
      debugPrint("Stack Trace: $stackTrace");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshCollectionData() async {
    try {
      final results = await Future.wait([
        _apiService.fetchMyBooks(),
        _apiService.fetchMyFavorites(),
      ]);
      _myBooks = results[0];
      _favoriteBooks = results[1];
      // Panggil notifyListeners agar halaman Koleksi diperbarui jika sedang dibuka
      notifyListeners();
    } catch (e) {
      // Tidak perlu menampilkan error besar, cukup cetak di konsol untuk debug
      debugPrint("Gagal me-refresh data koleksi: $e");
    }
  }

  void markNotificationsAsRead() {
    if (_hasUnreadNotifications) {
      _hasUnreadNotifications = false;
      notifyListeners();
    }
  }

  Future<void> performSearch(String query) async {
    // Jika query kosong, tidak melakukan apa-apa
    if (query.trim().isEmpty) return;

    _isSearching = true;
    _searchError = null;
    notifyListeners();

    try {
      _searchResult = await _apiService.search(query);
    } catch (e) {
      _searchError = "Gagal melakukan pencarian.";
      _searchResult = null;
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }
}
