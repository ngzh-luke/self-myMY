import 'package:mymy_m1/services/notifications/elegant_notification_service.dart';
import 'package:mymy_m1/services/notifications/notification_service.dart';
import 'package:mymy_m1/services/notifications/snackbar_notification_service.dart';

enum NotificationStyle { snackBar, elegant }

class NotificationFactory {
  static NotificationService createNotificationService(
      NotificationStyle style) {
    switch (style) {
      case NotificationStyle.snackBar:
        return SnackBarNotificationService();
      case NotificationStyle.elegant:
        return ElegantNotificationService();
    }
  }
}
