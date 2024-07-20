import 'package:flutter/material.dart';
import 'package:mymy_m1/services/notifications/notification_service.dart';
import 'package:provider/provider.dart';

class CustomNotificationListener extends StatelessWidget {
  final Widget child;

  const CustomNotificationListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomNotificationService>(
      builder: (context, notificationService, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (notificationService.latestNotification != null) {
            _showNotification(context, notificationService.latestNotification!);
            notificationService.clearNotification();
          }
        });
        return child;
      },
    );
  }

  void _showNotification(
      BuildContext context, CustomNotification notification) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(notification.message),
        duration: const Duration(seconds: 3),
        backgroundColor: _getColor(notification.type),
      ),
    );
  }

  Color _getColor(CustomNotificationType type) {
    switch (type) {
      case CustomNotificationType.success:
        return Colors.green;
      case CustomNotificationType.error:
        return Colors.red;
      case CustomNotificationType.info:
        return Colors.blue;
    }
  }
}
