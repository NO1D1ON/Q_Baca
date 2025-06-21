// lib/pages/account_page.dart (VERSI FINAL & BENAR)

import 'package:flutter/material.dart';
import 'package:q_baca/models/users.dart';
import 'package:q_baca/pages/halamanUtama/change_password_page.dart';
import 'package:q_baca/theme/palette.dart'; // Asumsi Anda butuh Palette

class AccountPage extends StatelessWidget {
  final User user;
  const AccountPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // [PERBAIKAN] Hapus `ChangeNotifierProvider` dan `Consumer`.
    // Halaman ini cukup menjadi Scaffold sederhana.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Akun'),
        backgroundColor: Palette.colorPrimary, // Sesuaikan dengan tema
      ),
      backgroundColor: Palette.colorPrimary, // Sesuaikan dengan tema
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // Gunakan ListView agar bisa di-scroll jika ada menu tambahan
          children: [
            const Text('Nama', style: TextStyle(color: Colors.grey)),
            Text(user.name, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),

            const Text('Email', style: TextStyle(color: Colors.grey)),
            Text(user.email, style: const TextStyle(fontSize: 18)),
            const Divider(height: 32),

            // ListTile sekarang menjadi bagian langsung dari body
            ListTile(
              leading: const Icon(Icons.lock_reset_outlined),
              title: const Text('Ubah Password'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordPage(),
                  ),
                );
              },
            ),
            const Divider(indent: 16),
            // Anda bisa menambahkan menu lain di sini jika perlu
          ],
        ),
      ),
    );
  }
}
