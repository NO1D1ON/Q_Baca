import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:q_baca/pages/transaction_history/transaction_controller.dart';
import 'package:q_baca/core/palette.dart';
import 'package:q_baca/pages/transaction_history/transaction_tile.dart'; // <-- Import widget baru
import 'package:collection/collection.dart'; // <-- Tambahkan import ini untuk groupBy

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionHistoryController(),
      child: Scaffold(
        backgroundColor: Palette.colorPrimary, // Warna latar belakang utama
        appBar: AppBar(
          title: const Text(
            'Riwayat Transaksi',
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.transparent, // AppBar transparan
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black87,
          ), // Warna ikon back
        ),
        body: Consumer<TransactionHistoryController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage != null) {
              return Center(child: Text(controller.errorMessage!));
            }

            if (controller.transactions.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history_toggle_off,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Belum Ada Transaksi',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            // Kelompokkan transaksi berdasarkan tanggal
            final groupedTransactions = groupBy(
              controller.transactions,
              (transaction) =>
                  transaction.relativeDateGroup, // Gunakan getter baru di model
            );

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              // Jumlah item adalah jumlah grup tanggal + jumlah transaksi
              itemCount:
                  groupedTransactions.length + controller.transactions.length,
              itemBuilder: (context, index) {
                // Logika untuk menampilkan header tanggal atau item transaksi
                int itemIndex = 0;
                for (var entry in groupedTransactions.entries) {
                  final groupTitle = entry.key;
                  final groupItems = entry.value;

                  // Jika index adalah awal dari grup baru
                  if (index == itemIndex) {
                    return _buildDateHeader(groupTitle);
                  }
                  itemIndex++;

                  // Jika index berada dalam jangkauan item grup ini
                  if (index < itemIndex + groupItems.length) {
                    final transaction = groupItems[index - itemIndex];
                    return TransactionTile(transaction: transaction);
                  }
                  itemIndex += groupItems.length;
                }
                return const SizedBox.shrink(); // Fallback
              },
            );
          },
        ),
      ),
    );
  }

  // Widget untuk menampilkan header tanggal
  Widget _buildDateHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 16, top: 20, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }
}
