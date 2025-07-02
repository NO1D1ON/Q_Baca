import 'package:intl/intl.dart';

class Transaction {
  final String id;
  final String type; // Contoh: 'pembelian', 'topup'
  final String title;
  final String description;
  final int amount;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.amount,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      type: json['type'] ?? 'unknown',
      title: json['title'] ?? 'Tanpa Judul',
      description: json['description'] ?? 'Tidak ada deskripsi.',
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  String get formattedDate {
    return DateFormat('d MMM y, HH:mm', 'id').format(createdAt);
  }

  String get formattedAmount {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    // Tambahkan tanda minus untuk pengeluaran
    return type == 'pembelian'
        ? '- ${currencyFormatter.format(amount)}'
        : '+ ${currencyFormatter.format(amount)}';
  }
}
