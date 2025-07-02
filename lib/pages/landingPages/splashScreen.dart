import 'package:flutter/material.dart';
// Ganti dengan path file Anda yang sebenarnya
import 'package:q_baca/theme/palette.dart';
import 'package:q_baca/api/auth_service.dart';
import 'package:q_baca/pages/halamanUtama/main_screen.dart';
import 'package:q_baca/pages/landingPages/onBoardingScreen.dart'; // Asumsi Anda punya file ini

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // PERBAIKAN: Buat instance dari AuthService
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // Panggil fungsi pengecekan yang sudah diperbaiki
    _checkLoginStatus();
  }

  // --- PERBAIKAN UTAMA: Logika pengecekan sekarang menggunakan AuthService ---
  Future<void> _checkLoginStatus() async {
    // Memberi jeda 2 detik untuk menampilkan splash screen
    await Future.delayed(const Duration(seconds: 2));

    // Gunakan AuthService untuk memeriksa apakah token ada di FlutterSecureStorage
    final bool isLoggedIn = await _authService.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      // Jika token ada (sudah login), arahkan ke MainScreen
      _redirectToHome();
    } else {
      // Jika token tidak ada, arahkan ke Onboarding/Login
      _redirectToOnboarding();
    }
  }

  void _redirectToHome() {
    Navigator.pushReplacement(
      context,
      // PERBAIKAN: Arahkan ke MainScreen, bukan HomePage
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  void _redirectToOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tampilan UI Anda dipertahankan sepenuhnya
    return Scaffold(
      body: Container(
        color: Palette.colorPrimary,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Q-Baca',
                    style: TextStyle(
                      color: Palette.hijauButton,
                      fontSize: 65,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Image(image: AssetImage('assets/pageIcon/slide1.png')),
                ],
              ),
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(color: Palette.hijauButton),
          ],
        ),
      ),
    );
  }
}
