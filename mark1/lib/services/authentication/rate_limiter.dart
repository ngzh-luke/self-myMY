class RateLimiter {
  final Map<String, int> _attempts = {};
  final Map<String, DateTime> _lastAttempt = {};

  bool canAttempt(String identifier) {
    final now = DateTime.now();
    if (_lastAttempt.containsKey(identifier) &&
        now.difference(_lastAttempt[identifier]!) <
            const Duration(minutes: 15)) {
      _attempts[identifier] = (_attempts[identifier] ?? 0) + 1;
      if (_attempts[identifier]! > 5) {
        return false;
      }
    } else {
      _attempts[identifier] = 1;
    }
    _lastAttempt[identifier] = now;
    return true;
  }
}
