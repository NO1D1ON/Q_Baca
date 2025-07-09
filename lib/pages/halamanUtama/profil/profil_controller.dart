import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// Ganti dengan path yang benar
import 'package:q_baca/core/api_services.dart';
import 'package:q_baca/core/auth_service.dart';
import 'package:q_baca/models/users_model.dart';

class ProfilController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = true;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ProfilController() {
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _apiService.fetchUserProfile();
    } catch (e) {
      _errorMessage = "Gagal memuat data profil.";
      print("Error di ProfilController: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// --- FUNGSI BARU YANG DITAMBAHKAN ---
  /// Memanggil AuthService untuk menghapus token dan sesi login.
  /// Menerima BuildContext untuk menangani navigasi setelah logout.
  Future<void> logout(BuildContext context) async {
    await _authService.logout(context);
  }
}
