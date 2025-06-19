import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Ganti dengan path yang benar
import 'package:q_baca/pages/loginPages/login.dart';
import 'package:q_baca/theme/palette.dart';
import 'package:q_baca/pages/halamanUtama/profil/profil_controller.dart';

class koleksi extends StatelessWidget {
  const koleksi({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfilController(),
      // PERBAIKAN: Tidak ada lagi Scaffold di sini.
      // Latar belakang akan otomatis mengikuti MainScreen.
      child: const ProfilView(),
    );
  }
}

class ProfilView extends StatelessWidget {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfilController>();

    // Widget ini sekarang hanya mengembalikan kontennya saja.
    return SafeArea(
      child: controller.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Palette.hijauButton),
            )
          : controller.errorMessage != null
          ? Center(
              child: Text(
                controller.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : _buildProfileContent(context, controller),
    );
  }

  // ... (fungsi _buildProfileContent dan _buildProfileMenuItem tetap sama) ...
  Widget _buildProfileContent(
    BuildContext context,
    ProfilController controller,
  ) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: const Color(0xFFCDE5C1),
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white70,
                child: Icon(Icons.person, size: 60, color: Palette.hijauButton),
              ),
              const SizedBox(height: 16),
              Text(
                controller.user?.name ?? 'Nama Pengguna',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Palette.hijauButton,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                controller.user?.email ?? 'email@contoh.com',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Colors.blue, thickness: 2),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(top: 8.0),
            children: [
              _buildProfileMenuItem(
                icon: Icons.person_outline,
                text: 'Akun',
                onTap: () {},
              ),
              _buildProfileMenuItem(
                icon: Icons.lock_outline,
                text: 'Ubah Kata Sandi',
                onTap: () {},
              ),
              _buildProfileMenuItem(
                icon: Icons.headset_mic_outlined,
                text: 'Bantuan',
                onTap: () {},
              ),
              _buildProfileMenuItem(
                icon: Icons.receipt_long_outlined,
                text: 'Transaksi',
                onTap: () {},
              ),
              _buildProfileMenuItem(
                icon: Icons.logout,
                text: 'Keluar',
                onTap: () async {
                  await controller.logout(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 4.0,
          ),
          leading: Icon(icon, color: Palette.hijauButton),
          title: Text(text, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
          onTap: onTap,
        ),
        const Divider(height: 1, indent: 24, endIndent: 24),
      ],
    );
  }
}
