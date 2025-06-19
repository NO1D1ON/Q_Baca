class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['nama'] ?? 'Pengguna', // Menggunakan kolom 'nama'
      email: json['email'] ?? '',
    );
  }

  // Helper untuk mendapatkan kata pertama dari nama lengkap sebagai sapaan
  String get firstName => name.split(' ').first;
}
