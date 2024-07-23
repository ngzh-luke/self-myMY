import 'package:flutter/material.dart';
import 'package:mymy_m1/services/notifications/notification_factory.dart';
import 'package:mymy_m1/services/notifications/notification_service.dart';
import 'package:mymy_m1/services/settings/settings_service.dart';

class NotificationManager {
  final SettingsService _settingsService;
  late NotificationService _notificationService;

  NotificationManager(this._settingsService) {
    _notificationService = NotificationFactory.createNotificationService(
        _settingsService.notificationStyle);
    _settingsService.addListener(_updateNotificationService);
  }

  void _updateNotificationService() {
    _notificationService = NotificationFactory.createNotificationService(
        _settingsService.notificationStyle);
  }

  void showNotification(BuildContext context, NotificationData data) {
    _notificationService.showNotification(context, data);
  }

  void dispose() {
    _settingsService.removeListener(_updateNotificationService);
  }
}
