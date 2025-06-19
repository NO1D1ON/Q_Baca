class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  // Factory constructor untuk membuat objek User dari data JSON API
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      // Mengambil data dari kolom 'nama' di JSON dan menyimpannya di properti 'name'
      name: json['nama'] ?? 'Pengguna',
      email: json['email'] ?? '',
    );
  }

  // --- PERBAIKAN UTAMA ADA DI SINI ---
  // Ini adalah sebuah "getter", bukan kolom database.
  // Tugasnya adalah mengolah properti 'name' yang sudah ada.
  String get firstName {
    // Jika nama kosong, kembalikan string kosong
    if (name.isEmpty) return '';
    // Ambil nama lengkap, pecah berdasarkan spasi, dan ambil bagian pertamanya.
    return name.split(' ').first;
  }
}
