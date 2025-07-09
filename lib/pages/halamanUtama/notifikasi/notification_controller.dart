import 'package:flutter/foundation.dart';
import 'package:q_baca/core/api_services.dart';
import 'package:q_baca/models/notification_model.dart';

class NotificationController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  NotificationController() {
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notifications = await _apiService.fetchNotifications();
    } catch (e) {
      _errorMessage = "Gagal memuat notifikasi.";
      debugPrint("Error di NotificationController: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
