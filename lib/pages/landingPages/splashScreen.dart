import 'package:flutter/material.dart';
import 'package:q_baca/theme/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// import 'onBoardingContents.dart';
import 'onBoardingScreen.dart';
import 'package:q_baca/pages/halamanUtama/homePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkTokenValid();
  }

  Future<void> checkTokenValid() async {
    await Future.delayed(const Duration(seconds: 2)); //memberi jeda 1 detik
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      // Token tidak ada
      _redirectToLogin();
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
          'https://hobibaca.my.id/api/check-token',
        ), // ganti sesuai API-mu
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['status'] == 'success') {
          // Token valid
          _redirectToHome();
        } else {
          // Token expired/tidak valid
          _redirectToLogin();
        }
      } else {
        // Token invalid atau server menolak
        _redirectToLogin();
      }
    } catch (e) {
      // Error jaringan
      _redirectToLogin();
    }
  }

  void _redirectToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  void _redirectToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
