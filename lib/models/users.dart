class User {
  final int id;
  final String name;
  final String email;
  final double saldo;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.saldo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // [PERBAIKAN] Logika parsing yang lebih aman untuk menangani semua kasus (null, String, num)
    final dynamic saldoData = json['saldo'];
    double parsedSaldo = 0.0;

    // Cek dulu apakah datanya ada (tidak null)
    if (saldoData != null) {
      // Coba parse dengan mengubahnya ke String terlebih dahulu.
      // Ini akan menangani angka (10000) dan string ("10000.00") dengan aman.
      parsedSaldo = double.tryParse(saldoData.toString()) ?? 0.0;
    }

    return User(
      id: json['id'] ?? 0,
      name: json['nama'] ?? 'Pengguna',
      email: json['email'] ?? '',
      saldo: parsedSaldo,
    );
  }

  // Getter untuk nama depan tetap tidak berubah
  String get firstName {
    if (name.isEmpty) return '';
    return name.split(' ').first;
  }
}
