// lib/pages/halamanUtama/main_screen.dart (VERSI FINAL & BENAR)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:q_baca/pages/halamanUtama/beranda/home_controller.dart';
// Ganti dengan path file Anda yang sebenarnya
import 'package:q_baca/pages/halamanUtama/beranda/homePage.dart';
import 'package:q_baca/core/bottomNavBar.dart';
import 'package:q_baca/pages/halamanUtama/kategori_buku/kategori.dart';
import 'package:q_baca/pages/halamanUtama/koleksi/koleksi.dart';
import 'package:q_baca/pages/halamanUtama/profil/profil.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // [PERBAIKAN #1] Daftar halaman Anda sudah benar. Kita gunakan ini lagi.
  final List<Widget> _pages = [
    const HomePage(),
    const KategoriPage(),
    const KoleksiPage(), // Pastikan nama kelas ini diawali huruf besar: Koleksi()
    const ProfilPage(),
  ];

  void _onNavigate(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // [PERBAIKAN #2] Letakkan Provider di level TERTINGGI dari MainScreen.
    // Ini akan "menyediakan" satu instance HomeController untuk SEMUA halaman di _pages.
    return ChangeNotifierProvider(
      create: (context) => HomeController(),
      child: Scaffold(
        // IndexedStack menjaga state setiap halaman agar tidak hilang saat berpindah tab.
        body: IndexedStack(index: _currentIndex, children: _pages),
        // [PERBAIKAN #3] Gunakan kembali CustomBottomNavBar Anda yang sudah ada.
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onNavigate,
        ),
      ),
    );
  }
}
