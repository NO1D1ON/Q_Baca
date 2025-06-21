// lib/pages/halamanUtama/profil.dart (VERSI FINAL & SELARAS)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:q_baca/api/auth_service.dart';
import 'package:q_baca/controllers/topUp_controller.dart';
import 'package:q_baca/models/users.dart';
import 'package:q_baca/pages/halamanUtama/home_controller.dart'; // <-- Gunakan HomeController
import 'package:q_baca/pages/halamanUtama/account_page.dart'; // <-- Import halaman baru
import 'package:q_baca/theme/palette.dart';
import 'package:intl/intl.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    // [PERBAIKAN #1] Langsung 'listen' ke HomeController yang sudah disediakan oleh MainScreen
    final controller = context.watch<HomeController>();
    final user = controller.user; // Ambil data user dari HomeController

    // Jika karena suatu hal controller masih loading atau user belum login
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (user == null) {
      return const Center(child: Text("Silakan login untuk melihat profil."));
    }

    // Jika data sudah ada, bangun UI-nya
    return Scaffold(
      backgroundColor: Palette.colorPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // --- Bagian Header Profil ---
            _buildProfileHeader(user),

            const Divider(height: 1, color: Colors.grey, thickness: 1),

            // --- Bagian Menu List ---
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 8.0),
                children: [
                  _buildProfileMenuItem(
                    context: context,
                    icon: Icons.person_outline,
                    text: 'Akun',
                    onTap: () {
                      // [PERBAIKAN #2] Navigasi ke halaman akun baru
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccountPage(user: user),
                        ),
                      );
                    },
                  ),
                  _buildProfileMenuItem(
                    context: context,
                    icon:
                        Icons.account_balance_wallet_outlined, // <-- IKON BARU
                    text: 'Top Up Saldo',
                    onTap: () {
                      // [PERBAIKAN] Panggil fungsi untuk menampilkan dialog
                      _showTopUpDialog(context);
                    },
                  ),
                  _buildProfileMenuItem(
                    context: context,
                    icon: Icons.history,
                    text: 'Riwayat Transaksi',
                    onTap: () {
                      /* TODO: Navigasi ke halaman riwayat transaksi */
                    },
                  ),
                  _buildProfileMenuItem(
                    context: context,
                    icon: Icons.headset_mic_outlined,
                    text: 'Bantuan',
                    onTap: () {
                      /* TODO: Navigasi ke halaman bantuan */
                    },
                  ),
                  _buildProfileMenuItem(
                    context: context,
                    icon: Icons.logout,
                    text: 'Keluar',
                    isLogout: true, // Tandai sebagai tombol logout
                    onTap: () => _showLogoutDialog(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTopUpDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User harus menekan tombol
      builder: (BuildContext dialogContext) {
        // Sediakan TopUpController khusus untuk dialog ini
        return ChangeNotifierProvider(
          create: (_) => TopUpController(),
          child: Consumer<TopUpController>(
            builder: (context, controller, child) {
              return AlertDialog(
                title: const Text('Top Up Saldo'),
                content: TextField(
                  controller: controller.amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Top Up',
                    prefixText: 'Rp ',
                  ),
                ),
                actions: controller.isLoading
                    ? [const Center(child: CircularProgressIndicator())]
                    : [
                        TextButton(
                          child: const Text('Batal'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        FilledButton(
                          child: const Text('Kirim'),
                          onPressed: () => controller.submitTopUp(context),
                        ),
                      ],
              );
            },
          ),
        );
      },
    );
  }

  // Widget helper dipisahkan agar lebih rapi
  // Widget _buildProfileHeader(User user) {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.symmetric(vertical: 32.0),
  //     child: Column(
  //       children: [
  //         const CircleAvatar(
  //           radius: 50,
  //           backgroundColor: Colors.white70,
  //           child: Icon(Icons.person, size: 60, color: Palette.hijauButton),
  //         ),
  //         const SizedBox(height: 16),
  //         Text(
  //           user.name,
  //           style: const TextStyle(
  //             fontSize: 22,
  //             fontWeight: FontWeight.bold,
  //             color: Palette.hijauButton,
  //           ),
  //         ),
  //         const SizedBox(height: 4),
  //         Text(
  //           user.email,
  //           style: const TextStyle(fontSize: 14, color: Colors.black54),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildProfileHeader(User user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 70.0, horizontal: 16.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white70,
            child: Icon(Icons.person, size: 60, color: Palette.hijauButton),
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Palette.hijauButton,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16), // Jarak sebelum saldo
          // Panggil widget saldo yang baru kita buat
          _SaldoWidget(saldo: user.saldo),
        ],
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    final color = isLogout ? Colors.red : Palette.hijauButton;
    final textColor = isLogout ? Colors.red : Colors.black;

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 4.0,
          ),
          leading: Icon(icon, color: color),
          title: Text(text, style: TextStyle(fontSize: 16, color: textColor)),
          trailing: isLogout
              ? null
              : const Icon(
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

  // Fungsi untuk menampilkan dialog konfirmasi logout
  Future<void> _showLogoutDialog(BuildContext context) async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Keluar'),
          content: const Text('Apakah Anda yakin ingin keluar dari akun Anda?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Keluar'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      // Gunakan context.read untuk memanggil fungsi dari provider
      // karena kita berada di dalam async gap
      if (context.mounted) {
        // Asumsi AuthService disediakan secara global atau di-instance di sini
        await AuthService().logout(context);
      }
    }
  }
}

class _SaldoWidget extends StatefulWidget {
  final double saldo;
  const _SaldoWidget({required this.saldo});

  @override
  State<_SaldoWidget> createState() => _SaldoWidgetState();
}

class _SaldoWidgetState extends State<_SaldoWidget> {
  bool _isSaldoVisible = false;

  void _toggleVisibility() {
    setState(() {
      _isSaldoVisible = !_isSaldoVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    // Tampilan saldo yang bisa diklik
    return InkWell(
      onTap: _toggleVisibility,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: Palette.colorPrimary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Agar ukuran row pas dengan konten
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Saldo Anda',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  _isSaldoVisible
                      ? currencyFormatter.format(widget.saldo)
                      : 'Rp •••••••',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Palette.hijauButton,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Icon(
              _isSaldoVisible ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[600],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
