// lib/api/api_service.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Pastikan path ke model-model ini sudah benar
import 'package:q_baca/models/books.dart';
import 'package:q_baca/models/users.dart';
import 'package:q_baca/pages/halamanUtama/kategoriLagi/category.dart'; // [TAMBAHAN] Import model Category
// import 'package:q_baca/models/transaction.dart'; // [TAMBAHAN] Import model Transaction

import 'package:q_baca/api/auth_service.dart';

class ApiService {
  final Dio dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Pastikan URL ini benar
  static const String baseUrl =
      'http://127.0.0.1:8000'; // Gunakan 10.0.2.2 untuk emulator Android

  ApiService() {
    dio.options.baseUrl = '$baseUrl/api';
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
      ),
    );
  }

  // --- KODE ASLI ANDA (TETAP ADA) ---
  Future<User> fetchUserProfile() async {
    try {
      final response = await dio.get('/user');
      // [SARAN] Pastikan model User Anda dapat menangani data dari API,
      // terutama jika ada data saldo (balance).
      return User.fromJson(response.data['data']);
    } on DioException {
      rethrow;
    }
  }

  Future<List<Book>> fetchBooks(String endpoint) async {
    try {
      final response = await dio.get('/books/$endpoint');
      // Pastikan response API untuk buku adalah list di dalam key 'data'
      List<Book> books = (response.data['data'] as List)
          .map((item) => Book.fromJson(item, baseUrl))
          .toList();
      return books;
    } on DioException {
      return [];
    }
  }

  // Future<List<String>> fetchCategories() async {
  //   try {
  //     final response = await dio.get('/categories');
  //     // Pastikan response API untuk kategori adalah list di dalam key 'data'
  //     return List<String>.from(
  //       response.data['data'].map((item) => item['name']),
  //     );
  //   } on DioException {
  //     return [];
  //   }
  // }

  // --- KODE TAMBAHAN DARI SAYA ---

  /// [TAMBAHAN] Mengambil daftar kategori sebagai objek lengkap (bukan hanya nama).
  /// Ini lebih fleksibel untuk menampilkan gambar dan ID di UI.
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await dio.get('/categories');
      List<Category> categories = (response.data as List)
          .map((item) => Category.fromJson(item, baseUrl))
          .toList();
      return categories;
    } on DioException catch (e) {
      print("Error fetching categories: ${e.message}");
      return [];
    }
  }

  /// [TAMBAHAN] Mengambil detail satu buku berdasarkan ID.
  /// Berguna untuk halaman detail buku.
  Future<Book> fetchBookDetails(int bookId) async {
    try {
      final response = await dio.get('/books/$bookId');
      // Mengasumsikan API mengembalikan data buku tunggal dalam key 'data'
      return Book.fromJson(response.data['data'], baseUrl);
    } on DioException {
      rethrow; // Lempar error agar bisa ditangani di UI
    }
  }

  /// [TAMBAHAN] Mengirim permintaan untuk membeli buku.
  /// Ini adalah rute terproteksi, interceptor akan menangani token.
  Future<Map<String, dynamic>> buyBook(int bookId) async {
    try {
      final response = await dio.post('/books/$bookId/buy');
      // Mengembalikan response dari server (misal: pesan sukses)
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

  /// [TAMBAHAN] Mengirim permintaan top-up saldo.
  /// Pastikan endpoint '/topup' ada di API Anda.
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

  //   /// [TAMBAHAN] Mengambil riwayat transaksi pengguna.
  //   /// Pastikan endpoint '/transactions' ada di API Anda.
  //   Future<List<Transaction>> fetchTransactionHistory() async {
  //     try {
  //       final response = await dio.get('/transactions');
  //       // Mengasumsikan response dari API adalah: { "data": [ { ...transaksi... }, ... ] }
  //       final List<dynamic> historyJson = response.data['data'];
  //       return historyJson.map((json) => Transaction.fromJson(json)).toList();
  //     } on DioException {
  //       return [];
  //     }
  //   }
  // }
}
