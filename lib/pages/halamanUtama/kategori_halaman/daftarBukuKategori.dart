import 'package:flutter/material.dart';
import 'modelKategori.dart';

class CategoryBooksPage extends StatelessWidget {
  final Category category;

  const CategoryBooksPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name), // Judul halaman sesuai nama kategori
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        // Nantinya, ini akan diisi dengan daftar buku yang sesuai
        child: Text('Daftar buku untuk kategori: ${category.name}'),
      ),
    );
  }
}