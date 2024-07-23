import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mymy_m1/services/authentication/auth_service.dart';

class UserSession {
  final AuthService _authService;
  User? _currentUser;
  Timer? _sessionTimer;

  UserSession(this._authService) {
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(User? user) {
    _currentUser = user;
    if (user != null) {
      _startSessionTimer();
    } else {
      _stopSessionTimer();
    }
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer =
        Timer.periodic(const Duration(minutes: 5), (_) => _refreshToken());
  }

  void _stopSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
  }

  Future<void> _refreshToken() async {
    try {
      await _currentUser?.getIdToken(true);
    } catch (e) {
      // Handle token refresh error
    }
  }
}
