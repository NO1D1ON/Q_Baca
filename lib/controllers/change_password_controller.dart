// lib/controllers/change_password_controller.dart

import 'package:flutter/material.dart';
import 'package:q_baca/core/api_services.dart';

class ChangePasswordController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final newPasswordConfirmationController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> submit(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final message = await _apiService.changePassword(
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
        newPasswordConfirmation: newPasswordConfirmationController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
      // Jika berhasil, kembali ke halaman sebelumnya
      if (context.mounted) Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    newPasswordConfirmationController.dispose();
    super.dispose();
  }
}
