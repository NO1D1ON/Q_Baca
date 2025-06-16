import 'package:flutter/material.dart';
import 'package:q_baca/pages/loginPages/login.dart';
import 'package:q_baca/theme/palette.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 1. KUNCI UNTUK VALIDASI FORM
  final _formKey = GlobalKey<FormState>();

  // 2. CONTROLLER UNTUK MENGAMBIL NILAI DARI SETIAP INPUT
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Variabel untuk mengelola visibilitas kata sandi
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  void dispose() {
    // Selalu dispose controller untuk mencegah memory leak
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // 3. FUNGSI UNTUK PROSES PENDAFTARAN (AKAN DIHUBUNGKAN KE API)
  void _register() {
    // Jalankan validasi. Jika semua input valid, maka...
    if (_formKey.currentState!.validate()) {
      // Tampilkan loading indicator (improvisasi)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pendaftaran berhasil, silahkan masuk kembali',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Palette.hijauButton,
        ),
      );

      // Di sinilah kita akan memanggil API nanti
      final name = _nameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;

      print('Data siap dikirim: Nama: $name, Email: $email');
      // TODO: Panggil API Service untuk register
    }
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade200,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        suffixIcon: suffixIcon != null
            ? IconTheme(
                data: const IconThemeData(color: Colors.black45),
                child: suffixIcon,
              )
            : null,
        // Semua state border dikelola dari sini agar konsisten
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Palette.hijauButton),
          borderRadius: BorderRadius.circular(50),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Palette.hijauButton, width: 1.5),
          borderRadius: BorderRadius.circular(50),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(50),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.colorPrimary, // Warna latar belakang hijau muda
      body: SafeArea(
        child: SingleChildScrollView(
          // Agar bisa di-scroll jika layar kecil
          padding: const EdgeInsets.all(24.0),
          child: Form(
            // 4. WIDGET FORM UNTUK MENGELOMPOKKAN INPUT
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80),
                Image(image: AssetImage('assets/pageIcon/slide1.png')),
                const SizedBox(height: 10.0),
                const Text(
                  'Selamat Datang',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Palette.hijauButton, // Hijau tua
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
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const loginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          fontSize: 16,
                          color: Palette.hijauButton, // Biru
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Input Nama Lengkap
                buildTextField(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama lengkap tidak boleh kosong';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Input Email
                // Email
                buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Masukkan format email yang valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Kata Sandi
                buildTextField(
                  controller: _passwordController,
                  label: 'Kata Sandi',
                  obscureText: _isPasswordObscured,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordObscured
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordObscured = !_isPasswordObscured;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kata sandi tidak boleh kosong';
                    }
                    if (value.length < 8) {
                      return 'Kata sandi minimal 8 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Konfirmasi Kata Sandi
                buildTextField(
                  controller: _confirmPasswordController,
                  label: 'Konfirmasi kata sandi',
                  obscureText: _isConfirmPasswordObscured,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordObscured
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordObscured =
                            !_isConfirmPasswordObscured;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Konfirmasi kata sandi tidak cocok';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 40),

                // Tombol Daftar
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Palette.hijauButton, // Sesuai gambar
                  ),
                  child: const Text(
                    'Daftar',
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
                // Lanjutkan dengan 'atau' dan social login jika perlu
              ],
            ),
          ),
        ),
      ),
    );
  }
}
