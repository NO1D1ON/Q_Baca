import 'package:flutter/foundation.dart' hide Category;
import 'package:q_baca/core/api_services.dart';
import 'package:q_baca/models/category_model.dart';

class KategoriController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Category> _categories = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  KategoriController() {
    loadCategories();
  }

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();
    try {
      final fetchedCategories = await _apiService.fetchCategories();

      // Logika untuk menampilkan 5 kategori + 1 "Lainnya"
      if (fetchedCategories.length > 5) {
        _categories = fetchedCategories.sublist(0, 5);
        _categories.add(
          Category(
            id: 999, // ID khusus untuk "Lainnya"
            name: 'Lainnya',
            imageUrl:
                'https://pixabay.com/id/photos/terrier-yorkshire-anjing-satu-4400587/',
            slug: '',
          ),
        );
      } else {
        _categories = fetchedCategories;
      }
    } catch (e) {
      _errorMessage = "Gagal memuat kategori.";
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
