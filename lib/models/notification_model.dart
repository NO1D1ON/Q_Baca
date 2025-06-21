class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String type; // 'promo' atau 'transaksi'
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Tanpa Judul',
      message: json['message'] ?? '',
      type: json['type'] ?? 'info',

      // [PERBAIKAN] Jika 'is_read' null, anggap sebagai 'belum dibaca' (false).
      // API Laravel mengirim 0 atau 1, yang akan di-cast dengan benar oleh Dart.
      isRead: (json['is_read'] == 1 || json['is_read'] == true),

      // [PENYEMPURNAAN] Parsing tanggal yang lebih aman
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
