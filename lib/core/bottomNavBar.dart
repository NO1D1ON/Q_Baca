import 'package:flutter/material.dart';
import 'package:q_baca/core/palette.dart'; // Ganti dengan path Anda

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Palette.hijauButton,
      unselectedItemColor: Colors.grey,
      backgroundColor:
          Palette.colorPrimary, // Menggunakan warna dari Palette Anda
      type: BottomNavigationBarType
          .fixed, // Agar semua item terlihat dan memiliki label
      showUnselectedLabels:
          true, // Menampilkan label untuk item yang tidak aktif
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category_outlined),
          activeIcon: Icon(Icons.category),
          label: 'Kategori',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.collections_bookmark_outlined),
          activeIcon: Icon(Icons.collections_bookmark),
          label: 'Koleksi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}
