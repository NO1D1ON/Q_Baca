import 'package:flutter/material.dart';
// Ganti dengan path file Anda yang sebenarnya
import 'package:q_baca/api/auth_service.dart';
import 'package:q_baca/pages/halamanUtama/main_screen.dart'; // Navigasi ke MainScreen
import 'package:q_baca/pages/loginPages/login.dart';
// import 'package:q_baca/pages/loginPages/login.dart';
import 'package:q_baca/theme/palette.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // PERBAIKAN: Gunakan instance dari AuthService untuk semua logika autentikasi
  final AuthService _authService = AuthService();

  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  bool _isLoading = false;

  // --- PERBAIKAN UTAMA: Fungsi _register sekarang memanggil AuthService ---
  Future<void> _register() async {
    // Jalankan validasi form terlebih dahulu
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Panggil fungsi register dari service terpusat.
      // AuthService akan menangani panggilan API dan penyimpanan token.
      await _authService.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      );

      if (!mounted) return;

      // Jika tidak ada error, token sudah tersimpan.
      // Tampilkan notifikasi sukses dan langsung navigasi ke halaman utama (MainScreen).
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran berhasil! Selamat datang.'),
          backgroundColor: Palette.hijauButton,
        ),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (route) => false,
      );
    } catch (e) {
      // Tangani semua jenis error yang dilempar oleh AuthService
      _showErrorSnackbar(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Widget terpisah untuk input field, tidak ada perubahan di sini
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: label,
          filled: true,
          fillColor: Colors.white.withOpacity(0.7),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          suffixIcon: suffixIcon,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Palette.hijauButton.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(50),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Palette.hijauButton, width: 2),
            borderRadius: BorderRadius.circular(50),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.circular(50),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.colorPrimary,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // leading: IconButton(
      //   icon: const Icon(Icons.arrow_back, color: Palette.hijauButton),
      //   onPressed: () => Navigator.of(context).pop(),
      // ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 30.0,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - kToolbarHeight,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Tampilan UI Anda dipertahankan, tidak ada perubahan
                        Image.asset(
                          'assets/pageIcon/slide1.png',
                          height: constraints.maxHeight * 0.15,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Selamat Datang',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Palette.hijauButton,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Sudah punya akun?',
                              style: TextStyle(fontSize: 16),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              ),
                              child: const Text(
                                'Masuk',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Palette.hijauButton,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        buildTextField(
                          controller: _nameController,
                          label: 'Nama Lengkap',
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Nama lengkap tidak boleh kosong'
                              : null,
                        ),
                        buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Email tidak boleh kosong';
                            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value))
                              return 'Masukkan format email yang valid';
                            return null;
                          },
                        ),
                        buildTextField(
                          controller: _passwordController,
                          label: 'Kata Sandi',
                          obscureText: _isPasswordObscured,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black45,
                            ),
                            onPressed: () => setState(
                              () => _isPasswordObscured = !_isPasswordObscured,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Kata sandi tidak boleh kosong';
                            if (value.length < 8)
                              return 'Kata sandi minimal 8 karakter';
                            return null;
                          },
                        ),
                        buildTextField(
                          controller: _confirmPasswordController,
                          label: 'Konfirmasi kata sandi',
                          obscureText: _isConfirmPasswordObscured,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black45,
                            ),
                            onPressed: () => setState(
                              () => _isConfirmPasswordObscured =
                                  !_isConfirmPasswordObscured,
                            ),
                          ),
                          validator: (value) {
                            if (value != _passwordController.text)
                              return 'Konfirmasi kata sandi tidak cocok';
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Palette.hijauButton,
                                ),
                              )
                            : ElevatedButton(
                                onPressed: _register,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  backgroundColor: Palette.hijauButton,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                child: const Text(
                                  'Daftar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                        SizedBox(height: 16),
                        Row(
                          children: const [
                            Expanded(
                              child: Divider(color: Palette.hijauButton),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Atau',
                                style: TextStyle(color: Palette.hijauButton),
                              ),
                            ),
                            Expanded(
                              child: Divider(color: Palette.hijauButton),
                            ),
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
                        const SizedBox(height: 16),
                        Text(
                          'Dengan mendaftar, Anda menyetujui Syarat & Ketentuan kami.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
