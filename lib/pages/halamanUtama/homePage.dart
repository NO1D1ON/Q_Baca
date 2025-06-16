import 'package:flutter/material.dart';
import 'package:q_baca/pages/halamanUtama/kategori.dart';
import 'package:q_baca/pages/halamanUtama/koleksi.dart';
import 'package:q_baca/pages/halamanUtama/profil.dart';
import 'package:shimmer/shimmer.dart';
import 'bottomNavBar.dart';
import 'package:q_baca/theme/palette.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool isLoading = true;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildMainContent(), // Halaman utama (beranda)
      const kategori(), // Halaman kategori
      const koleksi(), // Halaman koleksi
      const profil(), // Halaman akun
    ];

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.colorPrimary,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: SafeArea(child: _buildCurrentPage()),
    );
  }

  // === Halaman Utama (Beranda) ===
  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Halo, Nadila",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Palette.hijauButton,
            ),
          ),
          const Text("Mau baca apa hari ini?", style: TextStyle(fontSize: 14)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search),
                hintText: 'Cari disini',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildCategoryChip('Novel'),
              _buildCategoryChip('Sains'),
              _buildCategoryChip('Filsafat'),
            ],
          ),
          const SizedBox(height: 16),
          _buildBookSection('Rekomendasi', isLoading),
          const SizedBox(height: 16),
          _buildBookSection('Rekomendasi', isLoading),
          const SizedBox(height: 16),
          _buildBookSection('Rekomendasi', isLoading),
          const SizedBox(height: 16),
          _buildBookSection('Paling Banyak Dibaca', isLoading),
        ],
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return _buildMainContent(); // ini akan rebuild sesuai isLoading
      case 1:
        return const kategori();
      case 2:
        return const koleksi();
      case 3:
        return const profil();
      default:
        return _buildMainContent();
    }
  }

  Widget _buildCategoryChip(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: OutlinedButton(onPressed: () {}, child: Text(title)),
    );
  }

  Widget _buildBookSection(String title, bool loading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton(onPressed: () {}, child: const Text("Lihat Semua")),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: loading
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (_, __) => _buildShimmerCard(),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (_, index) => _buildBookCard(index),
                ),
        ),
      ],
    );
  }

  Widget _buildBookCard(int index) {
    final titles = [
      'Bumi',
      'Daun yang jatuh...',
      'Ayahku bukan...',
      'Filosofi Teras',
      'Atomic Habits',
    ];
    final authors = [
      'Tere Liye',
      'Tere Liye',
      'Asma Nadia',
      'Henry Manampiring',
      'James Clear',
    ];
    final images = [
      'assets/books/bumi.jpg',
      'assets/books/daun.jpg',
      'assets/books/ayah.jpg',
      'assets/books/filosofi.jpg',
      'assets/books/habits.jpg',
    ];

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: SizedBox(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(images[index], height: 150, fit: BoxFit.cover),
            ),
            const SizedBox(height: 4),
            Text(titles[index], maxLines: 2, overflow: TextOverflow.ellipsis),
            Text(
              authors[index],
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: SizedBox(
        width: 120,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 8),
              ),
              Container(
                height: 12,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 4),
              ),
              Container(height: 10, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
