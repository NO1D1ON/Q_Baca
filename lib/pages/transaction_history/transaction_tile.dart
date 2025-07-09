import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:q_baca/models/transaction_model.dart';
import 'package:q_baca/core/palette.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    // Tentukan properti berdasarkan tipe transaksi
    final bool isIncome = transaction.type == 'Top Up';
    final IconData iconData = isIncome
        ? Icons.account_balance_wallet_outlined
        : Icons.shopping_bag_outlined;
    final Color color = isIncome ? Palette.hijauButton : Colors.red;
    final String amountPrefix = isIncome ? '+ ' : '- ';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ikon Transaksi
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(iconData, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          // Judul dan Tanggal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.formattedDate,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Jumlah Nominal
          Text(
            amountPrefix + transaction.formattedAmount,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
