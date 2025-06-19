import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Ganti dengan path yang benar
import 'package:q_baca/pages/loginPages/login.dart';
import 'package:q_baca/theme/palette.dart';
import 'package:q_baca/pages/halamanUtama/profil/profil_controller.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfilController(),
      child: const ProfilView(),
    );
  }
}

class ProfilView extends StatelessWidget {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfilController>();

    return Scaffold(
      backgroundColor: Palette.colorPrimary,
      body: SafeArea(
        child: controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Palette.hijauButton),
              )
            : controller.errorMessage != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => controller.fetchUserData(),
                        child: const Text("Coba Lagi"),
                      ),
                    ],
                  ),
                ),
              )
            : _buildProfileContent(context, controller),
      ),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    ProfilController controller,
  ) {
    return Column(
      children: [
        // --- Bagian Header Profil ---
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

        // --- Bagian Menu List ---
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(top: 8.0),
            children: [
              _buildProfileMenuItem(
                icon: Icons.person_outline,
                text: 'Akun',
                onTap: () {
                  /* TODO: Navigasi ke halaman edit akun */
                },
              ),
              _buildProfileMenuItem(
                icon: Icons.lock_outline,
                text: 'Ubah Kata Sandi',
                onTap: () {
                  /* TODO: Navigasi ke halaman ubah kata sandi */
                },
              ),
              _buildProfileMenuItem(
                icon: Icons.headset_mic_outlined,
                text: 'Bantuan',
                onTap: () {
                  /* TODO: Navigasi ke halaman bantuan */
                },
              ),
              _buildProfileMenuItem(
                icon: Icons.receipt_long_outlined,
                text: 'Transaksi',
                onTap: () {
                  /* TODO: Navigasi ke halaman riwayat transaksi */
                },
              ),
              _buildProfileMenuItem(
                icon: Icons.logout,
                text: 'Keluar',
                // --- PERBAIKAN: Memanggil fungsi logout yang benar ---
                onTap: () async {
                  // Panggil fungsi logout dari controller dan kirim context
                  await controller.logout(context);
                  // Navigasi tidak lagi diperlukan di sini, karena sudah diurus oleh AuthService
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget helper untuk membuat setiap item menu
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
