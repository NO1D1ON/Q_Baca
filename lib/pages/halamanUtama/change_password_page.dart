import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:q_baca/controllers/change_password_controller.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChangePasswordController(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Ubah Kata Sandi')),
        body: Consumer<ChangePasswordController>(
          builder: (context, controller, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: controller.oldPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password Lama',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password Baru',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.newPasswordConfirmationController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Konfirmasi Password Baru',
                    ),
                  ),
                  const SizedBox(height: 32),
                  controller.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () => controller.submit(context),
                          child: const Text('Simpan Perubahan'),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
