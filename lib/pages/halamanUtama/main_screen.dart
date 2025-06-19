import 'package:flutter/material.dart';
// Ganti dengan path file Anda yang sebenarnya
import 'package:q_baca/pages/halamanUtama/homePage.dart';
import 'package:q_baca/pages/halamanUtama/bottomNavBar.dart';
import 'package:q_baca/pages/halamanUtama/kategori.dart';
import 'package:q_baca/pages/halamanUtama/koleksi.dart';
import 'package:q_baca/pages/halamanUtama/profil.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Daftar semua halaman utama yang akan ditampilkan
  final List<Widget> _pages = [
    const HomePage(),
    const KategoriPage(), // Placeholder
    const koleksi(), // Placeholder
    const ProfilPage(), // Placeholder
  ];

  void _onNavigate(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold menyediakan "kanvas" Material Design yang dibutuhkan.
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: CustomBottomNavBar(
        // Ini adalah widget BottomNavBar Anda
        currentIndex: _currentIndex,
        onTap: _onNavigate,
      ),
    );
  }
}
