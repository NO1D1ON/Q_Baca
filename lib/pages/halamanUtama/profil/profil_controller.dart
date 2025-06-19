import 'package:flutter/foundation.dart';
// Ganti dengan path yang benar
import 'package:q_baca/api/api_services.dart';
import 'package:q_baca/api/auth_service.dart';
import 'package:q_baca/models/users.dart';

class ProfilController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = true;
  String? _errorMessage;

  // Getters untuk diakses oleh UI
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ProfilController() {
    // Saat controller pertama kali dibuat, langsung ambil data user.
    fetchUserData();
  }

  /// Memanggil ApiService untuk mengambil data profil pengguna yang sedang login.
  /// Ini adalah rute yang terproteksi dan memerlukan token yang sudah disimpan.
  Future<void> fetchUserData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Panggilan API sesungguhnya terjadi di sini
      _user = await _apiService.fetchUserProfile();
    } catch (e) {
      _errorMessage = "Gagal memuat data profil.";
      print("Error di ProfilController: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Memanggil AuthService untuk menghapus token dan sesi login.
  Future<void> logout() async {
    await _authService.logout();
    // Logika navigasi setelah logout akan ditangani di dalam view.
  }
}
