import 'package:flutter/material.dart';
import 'package:q_baca/pages/loginPages/register.dart';
import 'package:q_baca/theme/palette.dart';
import 'package:q_baca/pages/halamanUtama/homePage.dart';

class loginPage extends StatelessWidget {
  const loginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7F6D9),
      body: Padding(
        padding: const EdgeInsets.only(right: 24.0, left: 24.0, top: 160.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image(image: AssetImage('assets/pageIcon/slide1.png')),
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
                      Navigator.pushReplacement(
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

              // Input Fields
              const CustomInputField(label: "Masukkan email Anda"),
              const CustomInputField(
                label: "Masukkan sandi Anda",
                isPassword: true,
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Navigasi ke halaman lupa password
                  },
                  child: const Text(
                    'Lupa Sandi?',
                    style: TextStyle(color: Palette.hijauButton),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Palette.hijauButton,
                ),
                child: const Text(
                  'Masuk',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),

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
            ],
          ),
        ),
      ),
    );
  }
}

class CustomInputField extends StatefulWidget {
  final String label;
  final bool isPassword;

  const CustomInputField({
    super.key,
    required this.label,
    this.isPassword = false,
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
        obscureText: widget.isPassword ? _obscureText : false,
        decoration: InputDecoration(
          labelText: widget.label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0), // <- Rounded corners
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0), // <- Rounded corners
            borderSide: const BorderSide(color: Palette.hijauButton),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0), // <- Rounded corners
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
          Text(label, style: const TextStyle(color: Palette.hijauButton)),
        ],
      ),
    );
  }
}
