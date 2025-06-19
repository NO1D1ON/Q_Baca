import 'package:flutter/material.dart';
// Ganti dengan path file Anda yang sebenarnya
import 'package:q_baca/api/auth_service.dart';

class LogoutPage extends StatelessWidget {
  // const LogoutPage({super.key});

  // PERBAIKAN: Buat instance dari AuthService untuk digunakan
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Akun')),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          // PERBAIKAN: onPressed sekarang memanggil authService.logout
          // AuthService akan menangani panggilan API, penghapusan token, dan navigasi.
          onPressed: () async {
            // Menampilkan dialog konfirmasi sebelum logout
            final bool? shouldLogout = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Konfirmasi Keluar'),
                  content: const Text(
                    'Apakah Anda yakin ingin keluar dari akun Anda?',
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Batal'),
                      onPressed: () {
                        Navigator.of(context).pop(false); // Mengembalikan false
                      },
                    ),
                    TextButton(
                      child: const Text('Keluar'),
                      onPressed: () {
                        Navigator.of(context).pop(true); // Mengembalikan true
                      },
                    ),
                  ],
                );
              },
            );

            // Jika pengguna menekan "Keluar", jalankan fungsi logout
            if (shouldLogout == true) {
              await _authService.logout(context);
            }
          },
          child: const Text('Keluar', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
