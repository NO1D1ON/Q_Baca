import 'package:flutter/material.dart';
import 'package:q_baca/pages/halamanUtama/main_screen.dart'; // Navigasi ke MainScreen setelah login
// Ganti dengan path file Anda yang sebenarnya
import 'package:q_baca/api/auth_service.dart'; // <-- PERBAIKAN: Import AuthService
import 'package:q_baca/pages/loginPages/register.dart';
import 'package:q_baca/theme/palette.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // PERBAIKAN: Gunakan instance dari AuthService untuk semua logika autentikasi
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  // --- PERBAIKAN UTAMA: Fungsi _login sekarang memanggil AuthService ---
  Future<void> _login() async {
    // Validasi sederhana di sisi klien
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Email dan sandi tidak boleh kosong.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null; // Hapus error lama saat mencoba lagi
    });

    try {
      // Panggil fungsi login dari service terpusat.
      // AuthService akan menangani panggilan API dan penyimpanan token.
      await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      // Jika tidak ada error, token sudah tersimpan. Langsung navigasi ke MainScreen.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } catch (e) {
      // Tangani semua jenis error yang dilempar oleh AuthService
      if (mounted) {
        setState(() {
          // Menghapus "Exception: " dari pesan error agar lebih bersih
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Palette.colorPrimary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Image.asset(
                  'assets/pageIcon/slide1.png',
                  height: screenHeight * 0.2,
                  fit: BoxFit.contain,
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
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomInputField(
                  label: "Masukkan sandi Anda",
                  isPassword: true,
                  controller: _passwordController,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Lupa Sandi?',
                      style: TextStyle(color: Palette.hijauButton),
                    ),
                  ),
                ),
                // PERBAIKAN: Menampilkan pesan error di bawah form
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                const SizedBox(height: 12),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Palette.hijauButton,
                        ),
                      )
                    : ElevatedButton(
                        onPressed: _login,
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
                  label: 'Masuk dengan Facebook',
                  labelColor: Palette.hijauButton,
                  color: Colors.grey.shade200,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                SocialButton(
                  icon: Image.asset('assets/pageIcon/google.png'),
                  label: 'Masuk dengan Google',
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

// Widget-widget pendukung (CustomInputField, SocialButton) tetap sama
// dan bisa berada di file yang sama atau dipisah.

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
          hintText: widget.label,
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
