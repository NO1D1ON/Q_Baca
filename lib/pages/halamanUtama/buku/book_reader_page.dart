import 'package:flutter/material.dart';
import 'package:q_baca/models/books_model.dart';
import 'package:q_baca/core/palette.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// [PERBAIKAN 1] Mengubah widget menjadi StatefulWidget
class BookReaderPage extends StatefulWidget {
  final Book book;
  const BookReaderPage({super.key, required this.book});

  @override
  State<BookReaderPage> createState() => _BookReaderPageState();
}

class _BookReaderPageState extends State<BookReaderPage> {
  // [PERBAIKAN 2] Tambahkan state untuk mengelola status loading
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title, style: TextStyle(color: Colors.white)),
        backgroundColor: Palette.hijauButton,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.white),
      ),

      body: Stack(
        children: [
          SfPdfViewer.network(
            // Gunakan widget.book untuk mengakses properti dari StatefulWidget
            widget.book.pdfUrl,
            // [PERBAIKAN 4] Gunakan callback onDocumentLoaded untuk mengubah status loading
            onDocumentLoaded: (PdfDocumentLoadedDetails details) {
              // Setelah dokumen berhasil dimuat, hilangkan indikator loading
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            // Tambahkan penanganan jika dokumen gagal dimuat
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
                // Tampilkan pesan error kepada pengguna
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal memuat PDF: ${details.error}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            canShowScrollHead: false,
            canShowScrollStatus: false,
            pageLayoutMode: PdfPageLayoutMode.single,
          ),

          // [PERBAIKAN 5] Tampilkan Indikator Loading di tengah layar
          // Indikator ini akan hilang saat _isLoading menjadi false
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Palette.hijauButton),
            ),
        ],
      ),
    );
  }
}
