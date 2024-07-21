import 'package:flutter/material.dart';

enum CustomNotificationType { success, error, info }

class CustomNotification {
  final String message;
  final CustomNotificationType type;

  CustomNotification(this.message, this.type);
}

class CustomNotificationService extends ChangeNotifier {
  CustomNotification? _latestNotification;

  CustomNotification? get latestNotification => _latestNotification;

  void notify(String message, CustomNotificationType type) {
    _latestNotification = CustomNotification(message, type);
    notifyListeners();
  }

  void clearNotification() {
    _latestNotification = null;
    notifyListeners();
  }
}
