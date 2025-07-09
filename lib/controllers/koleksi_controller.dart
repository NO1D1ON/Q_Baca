// lib/controllers/koleksi_controller.dart

import 'package:flutter/foundation.dart';
import 'package:q_baca/core/api_services.dart';
import 'package:q_baca/models/books_model.dart';

class KoleksiController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  KoleksiController() {
    fetchData();
  }

  bool _isLoading = true;
  int _selectedTabIndex = 0;
  List<Book> _purchasedBooks = [];
  List<Book> _favoriteBooks = [];

  bool get isLoading => _isLoading;
  int get selectedTabIndex => _selectedTabIndex;
  List<Book> get purchasedBooks => _purchasedBooks;
  List<Book> get favoriteBooks => _favoriteBooks;

  void changeTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();

    // Ambil kedua data secara bersamaan
    final results = await Future.wait([
      _apiService.fetchMyBooks(),
      _apiService.fetchMyFavorites(),
    ]);

    _purchasedBooks = results[0];
    _favoriteBooks = results[1];
    _isLoading = false;
    notifyListeners();
  }
}
