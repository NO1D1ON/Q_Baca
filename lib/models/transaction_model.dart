import 'package:intl/intl.dart';

class Transaction {
  final String title;
  final DateTime date;
  final double amount;
  final String type; // 'topup' atau 'purchase'

  Transaction({
    required this.title,
    required this.date,
    required this.amount,
    required this.type,
  });

  String get formattedDate {
    return DateFormat('d MMM yyyy, HH:mm', 'id').format(date);
  }

  String get formattedAmount {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  // [TAMBAHAN] Getter untuk mengelompokkan tanggal secara relatif
  String get relativeDateGroup {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) {
      return 'Hari Ini';
    } else if (transactionDate == yesterday) {
      return 'Kemarin';
    } else {
      // Menampilkan nama bulan dan tahun, contoh: "Juli 2025"
      return DateFormat('MMMM yyyy', 'id').format(date);
    }
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      // [PERBAIKAN] Menggunakan kunci yang benar dari API
      title: json['description'] ?? 'Tanpa Judul',
      date: DateTime.parse(json['display_date']),
      amount: double.tryParse(json['display_amount'].toString())?.abs() ?? 0.0,
      type: json['type'] ?? 'purchase', // Default ke 'purchase' jika tidak ada
    );
  }
}
