import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:q_baca/controllers/koleksi_controller.dart';
import 'package:q_baca/models/books.dart';
import 'package:q_baca/pages/halamanUtama/book_detail_page.dart';
import 'package:q_baca/theme/palette.dart';

class KoleksiPage extends StatelessWidget {
  const KoleksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => KoleksiController(),
      child: Scaffold(
        backgroundColor: Palette.colorPrimary,
        appBar: AppBar(
          title: const Text('Koleksi Saya'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Consumer<KoleksiController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                _buildTabs(context, controller),
                const SizedBox(height: 16),
                Expanded(
                  child: IndexedStack(
                    index: controller.selectedTabIndex,
                    children: [
                      _buildBookGrid(
                        context,
                        controller.purchasedBooks,
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
          },
        ),
      ),
    );
  }

  Widget _buildTabs(BuildContext context, KoleksiController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              text: 'Buku Saya',
              isSelected: controller.selectedTabIndex == 0,
              onPressed: () => controller.changeTab(0),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _TabButton(
              text: 'Favorit',
              isSelected: controller.selectedTabIndex == 1,
              onPressed: () => controller.changeTab(1),
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookDetailPage(bookId: book.id),
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

// Widget private untuk tombol tab agar lebih rapi
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
