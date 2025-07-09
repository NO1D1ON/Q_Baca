// lib/pages/notification_page.dart (VERSI FINAL)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:q_baca/pages/halamanUtama/notifikasi/notification_controller.dart';
import 'package:q_baca/core/palette.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // [PERBAIKAN UTAMA] Bungkus halaman ini dengan Provider-nya SENDIRI
    return ChangeNotifierProvider(
      create: (context) => NotificationController(),
      child: Scaffold(
        backgroundColor: Palette.colorPrimary,
        appBar: AppBar(
          title: const Text('Notifikasi'),
          backgroundColor: Palette.colorPrimary,
          elevation: 0,
          iconTheme: const IconThemeData(color: Palette.hijauButton),
        ),
        // Gunakan Consumer untuk "mendengarkan" NotificationController
        body: Consumer<NotificationController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Palette.hijauButton),
              );
            }

            if (controller.errorMessage != null) {
              return Center(child: Text(controller.errorMessage!));
            }

            if (controller.notifications.isEmpty) {
              return const Center(child: Text('Tidak ada notifikasi.'));
            }

            final notifications = controller.notifications;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return ListTile(
                  leading: notif.isRead
                      ? const Icon(Icons.notifications, color: Colors.grey)
                      : const Icon(
                          Icons.notifications_active,
                          color: Palette.hijauButton,
                        ),
                  title: Text(
                    notif.title,
                    style: TextStyle(
                      fontWeight: notif.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notif.message),
                      const SizedBox(height: 4),
                      Text(
                        timeago.format(notif.createdAt, locale: 'id'),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // TODO: Implementasi logika 'tandai sudah dibaca'
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
