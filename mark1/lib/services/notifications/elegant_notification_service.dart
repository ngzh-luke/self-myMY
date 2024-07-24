import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:mymy_m1/services/notifications/notification_service.dart';

class ElegantNotificationService implements NotificationService {
  @override
  void showNotification(
    BuildContext context,
    NotificationData data,
  ) {
    ElegantNotification(
            title: Text(data.title),
            description: Text(data.message),
            icon: Icon(_getIcon(data.type), color: _getColor(data.type)),
            toastDuration: data.duration,
            animationDuration: const Duration(milliseconds: 400),
            position: Alignment.topCenter,
            animation: AnimationType.fromTop,
            displayCloseButton: data.showCloseBtn,
            background: data.backgroundColor == null
                ? Theme.of(context).colorScheme.errorContainer
                : Colors.white)
        .show(context);
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

  String _getTitle(CustomNotificationType type) {
    switch (type) {
      case CustomNotificationType.success:
        return 'Success';
      case CustomNotificationType.error:
        return 'Error';
      case CustomNotificationType.info:
        return 'Information';
      case CustomNotificationType.warning:
        return "Warning";
    }
  }

  IconData _getIcon(CustomNotificationType type) {
    switch (type) {
      case CustomNotificationType.success:
        return Icons.check_circle;
      case CustomNotificationType.error:
        return Icons.error;
      case CustomNotificationType.info:
        return Icons.info;
      case CustomNotificationType.warning:
        return Icons.warning_rounded;
    }
  }
}
