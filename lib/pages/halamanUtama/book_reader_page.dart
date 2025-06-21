import 'package:flutter/material.dart';
import 'package:q_baca/models/books.dart';

class BookReaderPage extends StatelessWidget {
  final Book book;
  const BookReaderPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Center(
        child: Text(
          'Halaman untuk membaca "${book.title}" akan diimplementasikan di sini.',
        ),
      ),
    );
  }
}
