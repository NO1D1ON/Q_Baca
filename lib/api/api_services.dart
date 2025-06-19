import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// Ganti dengan path file Anda
import 'package:q_baca/models/books.dart';
import 'package:q_baca/models/users.dart';
// import 'package:q_baca/api/auth_service.dart';

class ApiService {
  final Dio dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String baseUrl =
      'http://127.0.0.1:8000'; // Ganti ke 10.0.2.2 untuk emulator

  ApiService() {
    dio.options.baseUrl = '$baseUrl/api';
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);
    dio.options.headers['Accept'] = 'application/json';

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(
            key: 'auth_token',
          ); // Menggunakan kunci dari AuthService jika ada

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<User> fetchUserProfile() async {
    try {
      final response = await dio.get('/user');
      return User.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }

  Future<List<Book>> fetchBooks(String endpoint) async {
    try {
      final response = await dio.get('/books/$endpoint');
      List<Book> books = (response.data as List)
          .map((item) => Book.fromJson(item, baseUrl))
          .toList();
      return books;
    } on DioException {
      return [];
    }
  }

  Future<List<String>> fetchCategories() async {
    try {
      final response = await dio.get('/categories');
      return List<String>.from(response.data.map((item) => item['name']));
    } on DioException {
      return [];
    }
  }
}
