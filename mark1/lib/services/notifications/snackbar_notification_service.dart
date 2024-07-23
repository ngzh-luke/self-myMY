import 'package:flutter/material.dart';
import 'package:mymy_m1/services/notifications/notification_service.dart';

class SnackBarNotificationService implements NotificationService {
  @override
  void showNotification(BuildContext context, NotificationData data) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(data.message),
          duration: data.duration,
          backgroundColor: _getColor(data.type),
          showCloseIcon: data.showCloseBtn),
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
      case CustomNotificationType.warning:
        return Colors.orange;
    }
  }
}
