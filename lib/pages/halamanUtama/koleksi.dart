import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:q_baca/pages/halamanUtama/home_controller.dart'; // [PERBAIKAN #1] Gunakan HomeController
import 'package:q_baca/models/books.dart';
import 'package:q_baca/pages/halamanUtama/book_detail_page.dart';
import 'package:q_baca/theme/palette.dart';

class KoleksiPage extends StatelessWidget {
  const KoleksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    // [PERBAIKAN #2] Hapus ChangeNotifierProvider.
    // Halaman ini sekarang hanya menjadi 'Consumer' dari HomeController yang sudah ada.
    return Scaffold(
      backgroundColor: Palette.colorPrimary,
      appBar: AppBar(
        title: const Text('Koleksi Saya'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      // [PERBAIKAN #3] Gunakan StatefulWidget kecil untuk mengelola state tab secara lokal.
      body: const _KoleksiView(),
    );
  }
}

// Widget baru untuk mengelola state tab (Buku Saya / Favorit)
class _KoleksiView extends StatefulWidget {
  const _KoleksiView();

  @override
  State<_KoleksiView> createState() => _KoleksiViewState();
}

class _KoleksiViewState extends State<_KoleksiView> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Ambil HomeController dari Provider yang sudah ada di level atas
    final controller = context.watch<HomeController>();

    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        _buildTabs(context),
        const SizedBox(height: 16),
        Expanded(
          child: IndexedStack(
            index: _selectedTabIndex,
            children: [
              _buildBookGrid(
                context,
                controller.myBooks,
                "Anda belum membeli buku apapun.",
              ),
              _buildBookGrid(
                context,
                controller.favoriteBooks,
                "Anda belum memfavoritkan buku apapun.",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              text: 'Buku Saya',
              isSelected: _selectedTabIndex == 0,
              onPressed: () => setState(() => _selectedTabIndex = 0),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _TabButton(
              text: 'Favorit',
              isSelected: _selectedTabIndex == 1,
              onPressed: () => setState(() => _selectedTabIndex = 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookGrid(
    BuildContext context,
    List<Book> books,
    String emptyMessage,
  ) {
    if (books.isEmpty) {
      return Center(child: Text(emptyMessage));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.6,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return InkWell(
          onTap: () {
            // Kita perlu mewariskan HomeController saat navigasi
            final homeController = context.read<HomeController>();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider.value(
                  value: homeController,
                  child: BookDetailPage(bookId: book.id),
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: book.coverUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                book.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                book.author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Widget _TabButton tidak perlu diubah
class _TabButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const _TabButton({
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Palette.hijauButton : Colors.white,
        foregroundColor: isSelected ? Colors.white : Palette.hijauButton,
        side: BorderSide(
          color: isSelected ? Colors.transparent : Palette.hijauButton,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(text),
    );
  }
}
