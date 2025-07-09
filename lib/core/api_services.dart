// lib/api/api_service.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Pastikan path ke model-model ini sudah benar
import 'package:q_baca/models/books_model.dart';
import 'package:q_baca/models/notification_model.dart';
import 'package:q_baca/models/users_model.dart';
import 'package:q_baca/models/category_model.dart'; // Menggunakan model Category yang benar
// import 'package:q_baca/models/transaction.dart';

import 'package:q_baca/core/auth_service.dart';
import 'package:q_baca/models/search_result_model.dart';
import 'package:q_baca/models/transaction_model.dart';

class ApiService {
  final Dio dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Gunakan 'http://10.0.2.2:8000' jika menggunakan Emulator Android.
  // Ganti sesuai IP Anda jika menjalankan di HP fisik.
  // static const String baseUrl = 'https://qbaca.my.id';
  static const String baseUrl = 'http://127.0.0.1:8000';

  ApiService() {
    dio.options.baseUrl = '$baseUrl/api';
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);
    dio.options.headers['Accept'] = 'application/json';

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: AuthService.tokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          debugPrint('Dio Error: ${e.requestOptions.path} -> ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  // Helper untuk parsing yang aman dan bisa digunakan kembali
  List<T> _parseObjectList<T>({
    required dynamic responseData, // Terima seluruh data respons
    required T Function(Map<String, dynamic> json) builder,
  }) {
    // Cek jika respons itu sendiri bukan Map, berarti ada error (misal, timeout)
    if (responseData is! Map) {
      return []; // Langsung kembalikan list kosong jika respons bukan Map
    }

    final dynamic data = responseData['data'] ?? responseData;

    if (data == null) return [];
    if (data is List) {
      return data.whereType<Map<String, dynamic>>().map(builder).toList();
    }
    if (data is Map) {
      return data.values
          .whereType<Map<String, dynamic>>()
          .map(builder)
          .toList();
    }
    return [];
  }

  Future<User> fetchUserProfile() async {
    try {
      final response = await dio.get('/user');
      final userData = response.data['data'] ?? response.data;
      return User.fromJson(userData as Map<String, dynamic>);
    } on DioException {
      rethrow;
    }
  }

  Future<List<Book>> fetchBooks(String endpoint) async {
    try {
      final response = await dio.get('/books/$endpoint');
      // [PERBAIKAN] Kirim seluruh `response.data` ke helper
      return _parseObjectList<Book>(
        responseData: response.data,
        builder: (json) => Book.fromJson(json, baseUrl),
      );
    } on DioException {
      rethrow;
    }
  }

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await dio.get('/categories');
      // [PERBAIKAN] Kirim seluruh `response.data` ke helper
      return _parseObjectList<Category>(
        responseData: response.data,
        builder: (json) => Category.fromJson(json, baseUrl),
      );
    } on DioException {
      rethrow;
    }
  }

  /// [FINAL & AMAN] Mengambil detail satu buku
  Future<Book> fetchBookDetails(int bookId) async {
    try {
      final response = await dio.get('/books/$bookId');
      // [PERBAIKAN #2] Menerapkan pola aman yang sama untuk konsistensi
      final bookData = response.data['data'] ?? response.data;
      return Book.fromJson(bookData as Map<String, dynamic>, baseUrl);
    } on DioException {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> buyBook(int bookId) async {
    try {
      final response = await dio.post('/books/$bookId/buy');
      return {
        'success': true,
        'message': response.data['message'] ?? 'Pembelian berhasil',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Pembelian gagal',
      };
    }
  }

  Future<Map<String, dynamic>> requestTopUp(double amount) async {
    try {
      final response = await dio.post('/topup', data: {'amount': amount});
      return {
        'success': true,
        'message':
            response.data['message'] ?? 'Permintaan top-up berhasil dikirim',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Permintaan top-up gagal',
      };
    }
  }

  Future<List<NotificationModel>> fetchNotifications() async {
    try {
      final response = await dio.get('/notifications');
      final notificationData = response.data['data'] ?? response.data;

      // Gunakan helper yang sudah kita buat sebelumnya
      return _parseObjectList<NotificationModel>(
        responseData: notificationData,
        builder: (json) => NotificationModel.fromJson(json),
      );
    } on DioException {
      // Jika gagal, kembalikan list kosong agar tidak crash.
      return [];
    }
  }

  Future<SearchResult> search(String query) async {
    try {
      final response = await dio.get('/search', queryParameters: {'q': query});
      // Asumsikan respons selalu terbungkus 'data'
      return SearchResult.fromJson(response.data['data'], baseUrl);
    } on DioException {
      rethrow;
    }
  }

  Future<List<Book>> fetchBooksByCategory(String categorySlug) async {
    try {
      final response = await dio.get('/categories/$categorySlug');

      // [PERBAIKAN PENTING]
      // Respons dari Laravel: { success: true, data: { ..., books: [...] } }
      // Kita harus masuk ke 'data', lalu ke 'books'.
      final bookData = response.data['data']['books'];

      // Pastikan bookData adalah List sebelum diparsing
      if (bookData is List) {
        // Langsung parsing list tersebut
        return bookData.map((json) => Book.fromJson(json, baseUrl)).toList();
      }

      // Jika tidak ada data buku, kembalikan list kosong
      return [];
    } on DioException {
      rethrow;
    }
  }

  Future<List<Book>> fetchMyBooks() async {
    try {
      final response = await dio.get('/my-books');
      return _parseObjectList<Book>(
        responseData: response.data,
        builder: (json) => Book.fromJson(json, baseUrl),
      );
    } on DioException {
      return []; // Kembalikan list kosong jika error
    }
  }

  /// [TAMBAHAN] Mengambil daftar buku yang difavoritkan
  Future<List<Book>> fetchMyFavorites() async {
    try {
      final response = await dio.get('/my-favorites');
      return _parseObjectList<Book>(
        responseData: response.data,
        builder: (json) => Book.fromJson(json, baseUrl),
      );
    } on DioException {
      return [];
    }
  }

  /// [TAMBAHAN] Meminta tautan reset password.
  Future<String> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final response = await dio.post(
        '/change-password',
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        },
      );
      return response.data['message'] ?? 'Password berhasil diubah.';
    } on DioException catch (e) {
      // Lempar pesan error dari server agar bisa ditampilkan
      throw e.response?.data['message'] ?? 'Terjadi kesalahan.';
    }
  }

  Future<Map<String, dynamic>> toggleFavorite(int bookId) async {
    try {
      // Panggil endpoint yang sudah kita buat di Laravel
      final response = await dio.post('/books/$bookId/toggle-favorite');
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Terjadi kesalahan.';
    }
  }

  Future<List<Transaction>> fetchTransactionHistory() async {
    try {
      final response = await dio.get(
        '/transactions',
      ); // Sesuaikan dengan endpoint API Anda
      return _parseObjectList<Transaction>(
        responseData: response.data,
        builder: (json) => Transaction.fromJson(json),
      );
    } on DioException {
      // Jika gagal, kembalikan list kosong agar tidak crash.
      return [];
    }
  }
}
