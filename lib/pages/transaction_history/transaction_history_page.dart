import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:q_baca/models/transaction_model.dart';
import 'package:q_baca/pages/halamanUtama/kategoriLagi/transaction_controller.dart';
import 'package:q_baca/theme/palette.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionHistoryController(),
      child: Scaffold(
        backgroundColor: Palette.colorPrimary,
        appBar: AppBar(
          title: const Text('Riwayat Transaksi'),
          backgroundColor: Palette.colorPrimary,
          elevation: 0,
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
              return const Center(child: Text('Belum ada transaksi.'));
            }

            return ListView.builder(
              itemCount: controller.transactions.length,
              itemBuilder: (context, index) {
                final transaction = controller.transactions[index];
                return _buildTransactionTile(transaction);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTransactionTile(Transaction transaction) {
    final isIncome = transaction.type == 'topup';
    final iconData = isIncome ? Icons.arrow_downward : Icons.arrow_upward;
    final color = isIncome ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(iconData, color: color, size: 20),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(transaction.formattedDate),
        trailing: Text(
          transaction.formattedAmount,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
