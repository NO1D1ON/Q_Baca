import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Ganti dengan path file Anda yang sebenarnya
import 'package:q_baca/pages/loginPages/register.dart';
import 'package:q_baca/theme/palette.dart';
import 'package:q_baca/pages/halamanUtama/homePage.dart';

// --- WIDGET HALAMAN LOGIN (SUDAH DIPERBAIKI) ---
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk mengambil data dari TextField
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // State untuk menampilkan loading indicator saat proses login berjalan
  bool _isLoading = false;

  // URL base dari API Laravel Anda.
  // GANTI DENGAN YANG BENAR:
  // Emulator Android: 'http://10.0.2.2:8000'
  // Perangkat Fisik (pastikan 1 jaringan): 'http://[IP_ADDRESS_LAPTOP_ANDA]:8000'
  final String _apiBaseUrl = 'http://127.0.0.1:8000';

  // Fungsi untuk menangani proses login
  Future<void> _login() async {
    // Validasi input di sisi klien
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email dan sandi tidak boleh kosong.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Tampilkan loading
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http
          .post(
            Uri.parse('$_apiBaseUrl/api/login'), // Endpoint login Anda
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
            },
            body: jsonEncode(<String, String>{
              'email': _emailController.text.trim(),
              'password': _passwordController.text,
            }),
          )
          .timeout(const Duration(seconds: 10)); // Tambahkan timeout koneksi

      if (mounted) {
        // Cek apakah widget masih ada di tree
        if (response.statusCode == 200) {
          // Jika login berhasil
          // TODO: Simpan token yang diterima dari Laravel
          // final responseData = jsonDecode(response.body);
          // final String token = responseData['access_token'];

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          // Jika login gagal (misal: kredensial salah)
          final errorData = jsonDecode(response.body);
          final errorMessage =
              errorData['message'] ??
              'Login gagal. Periksa kembali email dan sandi Anda.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } catch (e) {
      // Tangani error koneksi (timeout, tidak ada internet, dll)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan koneksi: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Sembunyikan loading setelah proses selesai, apapun hasilnya
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Selalu dispose controller untuk menghindari memory leak
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.colorPrimary, // Menggunakan warna dari Palette
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/pageIcon/slide1.png',
                ), // Pastikan path asset benar
                const SizedBox(height: 32),
                Text(
                  'Selamat Datang Kembali',
                  textAlign: TextAlign.center,
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
                        style: TextStyle(
                          color: Palette.hijauButton,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CustomInputField(
                  label: "Masukkan email Anda",
                  controller: _emailController, // Hubungkan controller
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomInputField(
                  label: "Masukkan sandi Anda",
                  isPassword: true,
                  controller: _passwordController, // Hubungkan controller
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Navigasi ke halaman lupa password
                    },
                    child: const Text(
                      'Lupa Sandi?',
                      style: TextStyle(color: Palette.hijauButton),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Tombol login yang menampilkan loading indicator
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Palette.hijauButton,
                        ),
                      )
                    : ElevatedButton(
                        onPressed: _login, // Panggil fungsi _login
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Palette.hijauButton,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text(
                          'Masuk',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                const SizedBox(height: 24),
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
                  icon: Image.asset('assets/pageIcon/facebook.png', height: 24),
                  label: 'Masuk dengan Facebook',
                  labelColor: Palette.hijauButton,
                  color: Colors.white,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                SocialButton(
                  icon: Image.asset('assets/pageIcon/google.png', height: 24),
                  label: 'Masuk dengan Google',
                  labelColor: Palette.hijauButton,
                  color: Colors.white,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- WIDGET KUSTOM (DENGAN PENYESUAIAN) ---
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
          hintText: widget.label, // Menggunakan hintText agar lebih modern
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(color: Palette.hijauButton.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: const BorderSide(color: Palette.hijauButton, width: 2),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.7),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Palette.hijauButton,
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
        elevation: 1.0,
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(color: labelColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
