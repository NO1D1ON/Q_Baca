/* ================================================================================
File FINAL: lib/api/auth_service.dart
Tugas: Menjadi pusat logika untuk login, registrasi, dan manajemen token yang andal.
================================================================================ */
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Sesuaikan path jika perlu
import 'package:q_baca/api/api_services.dart';
import 'package:q_baca/pages/loginPages/login.dart';

class AuthService extends ChangeNotifier {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Mengambil baseUrl dari ApiService agar konsisten
  final String _baseUrl = ApiService.baseUrl;

  // Kunci untuk token, dijadikan private untuk enkapsulasi yang lebih baik
  static const String tokenKey = 'auth_token';

  /// [PERBAIKAN] Fungsi private untuk menyimpan token.
  /// Setelah menyimpan, ia akan memberi notifikasi ke listener.
  Future<void> _saveToken(String token) async {
    await _storage.write(key: tokenKey, value: token);
    notifyListeners();
  }

  /// Fungsi publik untuk mendapatkan token jika diperlukan di bagian lain aplikasi.
  Future<String?> getToken() async {
    return await _storage.read(key: tokenKey);
  }

  /// Mengecek apakah pengguna sudah login berdasarkan keberadaan token.
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Fungsi login yang sudah disempurnakan.
  Future<void> login({required String email, required String password}) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/api/login',
        data: {'email': email, 'password': password},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200 && response.data['access_token'] != null) {
        await _saveToken(response.data['access_token']);
      } else {
        throw Exception('Login gagal: Token tidak diterima dari server.');
      }
    } on DioException catch (e) {
      // Melempar pesan error dari server agar bisa ditampilkan di UI
      throw Exception(
        e.response?.data['message'] ?? 'Gagal terhubung ke server.',
      );
    }
  }

  /// Fungsi register yang sudah disempurnakan.
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/api/register',
        data: {
          'nama': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 201 && response.data['access_token'] != null) {
        // Setelah berhasil register, langsung login dengan menyimpan token.
        await _saveToken(response.data['access_token']);
      } else {
        throw Exception('Registrasi gagal.');
      }
    } on DioException catch (e) {
      final errors = e.response?.data['errors'];
      if (errors != null && errors is Map && errors.isNotEmpty) {
        // Ambil pesan error validasi pertama dari Laravel
        throw Exception(errors.values.first[0]);
      }
      throw Exception(e.response?.data['message'] ?? 'Gagal mendaftar.');
    }
  }

  /// --- DIHAPUS ---
  /// Fungsi fetchCategories() telah dihapus dari AuthService.
  /// Pengambilan data kategori sekarang HANYA dilakukan melalui ApiService
  /// yang sudah kita buat aman dan terpusat. Ini menghilangkan duplikasi
  /// dan potensi error yang sama di masa depan.

  /// Fungsi logout yang disederhanakan dan diperbaiki.
  Future<void> logout(BuildContext context) async {
    final token = await getToken();

    if (token != null) {
      try {
        // ApiService() akan secara otomatis menambahkan token ke header permintaan ini.
        await ApiService().dio.post('/logout');
      } catch (e) {
        // Jika gagal logout di server (misal: koneksi putus atau token sudah tidak valid),
        // kita tidak perlu khawatir. Cukup cetak pesannya dan lanjutkan.
        debugPrint(
          "Gagal menghubungi API logout, token lokal akan tetap dihapus: $e",
        );
      }
    }

    // Hapus token dari penyimpanan lokal, apapun yang terjadi di server.
    await _storage.delete(key: tokenKey);
    // Beri notifikasi ke UI bahwa pengguna sudah logout.
    notifyListeners();

    // Arahkan pengguna kembali ke halaman Login dan hapus semua rute sebelumnya.
    // Pemeriksaan `context.mounted` adalah praktik keamanan yang baik.
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }
}
