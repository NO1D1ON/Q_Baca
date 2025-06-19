import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:q_baca/api/api_services.dart'; // Sesuaikan path jika perlu

class AuthService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final String _baseUrl = ApiService.baseUrl;

  static const String tokenKey = 'auth_token';

  Future<void> login({required String email, required String password}) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/api/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 && response.data['access_token'] != null) {
        await _storage.write(
          key: tokenKey,
          value: response.data['access_token'],
        );
      } else {
        throw Exception('Login gagal: Token tidak diterima.');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Gagal terhubung ke server.',
      );
    }
  }

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
        await _storage.write(
          key: tokenKey,
          value: response.data['access_token'],
        );
      } else {
        throw Exception('Registrasi gagal.');
      }
    } on DioException catch (e) {
      final errors = e.response?.data['errors'];
      if (errors != null && errors is Map && errors.isNotEmpty) {
        throw Exception(errors.values.first[0]);
      }
      throw Exception(e.response?.data['message'] ?? 'Gagal mendaftar.');
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: tokenKey);
    // TODO: Panggil API logout di Laravel
  }
}
