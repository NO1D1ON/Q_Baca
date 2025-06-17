import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Mengganti http dengan dio

import 'package:q_baca/pages/loginPages/register.dart';
import 'package:q_baca/theme/palette.dart';
import 'package:q_baca/pages/halamanUtama/homePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final Dio _dio = Dio(); // Instansiasi Dio

  bool _isLoading = false;
  String? _errorMessage; // State untuk menyimpan pesan error

  final String _apiBaseUrl = 'http://127.0.0.1:8000/api';

  Future<void> _login() async {
    // Hilangkan pesan error sebelumnya saat mencoba login lagi
    setState(() {
      _errorMessage = null;
    });

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email dan sandi tidak boleh kosong.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Menggunakan Dio untuk request POST
      final response = await _dio.post(
        '$_apiBaseUrl/login',
        data: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (mounted) {
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login berhasil!'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      }
    } on DioException catch (e) {
      // Menangani error dari Dio
      if (mounted) {
        String errorMessage = 'Terjadi kesalahan pada server.';
        if (e.response != null) {
          // Jika ada response error dari server (misal: email/password salah)
          final errorData = e.response?.data;
          errorMessage = errorData['message'] ?? 'Email atau sandi salah.';
        } else {
          // Error koneksi atau lainnya
          errorMessage = 'Gagal terhubung ke server. Periksa koneksi Anda.';
        }

        setState(() {
          _errorMessage = errorMessage;
        });
      }
    } catch (e) {
      // Menangani error tak terduga lainnya
      setState(() {
        _errorMessage = 'Terjadi kesalahan yang tidak diketahui.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil ukuran layar untuk responsivitas
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFE7F6D9),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05),
                // Gambar yang ukurannya disesuaikan dengan layar
                Image.asset(
                  'assets/pageIcon/slide1.png',
                  height: screenHeight * 0.2, // Tinggi responsif
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  'Selamat Datang Kembali',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Palette.hijauButton,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Belum punya akun?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Daftar',
                        style: TextStyle(color: Palette.hijauButton),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CustomInputField(
                  label: "Masukkan email Anda",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomInputField(
                  label: "Masukkan sandi Anda",
                  isPassword: true,
                  controller: _passwordController,
                ),

                // Baris untuk menampilkan pesan error dan tombol 'Lupa Sandi'
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tampilkan pesan error jika ada
                    if (_errorMessage != null)
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const Spacer(), // Memberi jarak
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Lupa Sandi?',
                        style: TextStyle(color: Palette.hijauButton),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Palette.hijauButton,
                        ), // Warna loading diubah
                      )
                    : ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Palette.hijauButton,
                        ),
                        child: const Text(
                          'Masuk',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  children: const [
                    Expanded(child: Divider(color: Palette.hijauButton)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Atau',
                        style: TextStyle(color: Palette.hijauButton),
                      ),
                    ),
                    Expanded(child: Divider(color: Palette.hijauButton)),
                  ],
                ),
                const SizedBox(height: 16),
                SocialButton(
                  icon: Image.asset('assets/pageIcon/facebook.png'),
                  label: 'Masuk dengan facebook',
                  labelColor: Palette.hijauButton,
                  color: Colors.grey.shade200,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                SocialButton(
                  icon: Image.asset('assets/pageIcon/google.png'),
                  label: 'Masuk dengan google',
                  labelColor: Palette.hijauButton,
                  color: Colors.grey.shade200,
                  onTap: () {},
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomInputField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const CustomInputField({
    super.key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.keyboardType,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          labelText: widget.label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: const BorderSide(color: Palette.hijauButton),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          filled: true,
          fillColor: Colors.grey[200],
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final Color labelColor;

  const SocialButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.labelColor = Palette.hijauButton,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 10),
          Text(label, style: TextStyle(color: labelColor)),
        ],
      ),
    );
  }
}
