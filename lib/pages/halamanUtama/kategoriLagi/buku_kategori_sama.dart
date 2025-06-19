// lib/pages/halamanUtama/kategoriLagi/buku_kategori_sama.dart

import 'package:flutter/material.dart';
import 'package:q_baca/pages/halamanUtama/kategoriLagi/category.dart'; // Pastikan path import benar

class CategoryBooksPage extends StatelessWidget {
  // 1. Deklarasikan variabel untuk menampung data kategori yang dikirim
  final Category category;

  // 2. Tambahkan variabel tersebut ke konstruktor sebagai parameter yang wajib diisi (required)
  const CategoryBooksPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 3. Gunakan data yang diterima untuk judul AppBar
        title: Text('Buku Kategori: ${category.name}'),
      ),
      body: Center(
        // Anda bisa mulai membangun UI untuk menampilkan buku-buku
        // berdasarkan ID kategori: widget.category.id
        child: Text(
          'Menampilkan buku untuk kategori "${category.name}" dengan ID: ${category.id}',
        ),
      ),
    );
  }
}
