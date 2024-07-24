import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:mymy_m1/services/authentication/rate_limiter.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger();
  final RateLimiter _rateLimiter = RateLimiter();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    if (!_rateLimiter.canAttempt(email)) {
      throw FirebaseAuthException(
        code: 'too-many-requests',
        message: 'Too many sign-in attempts. Please try again later.',
      );
    }

    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      _logger.e('Sign in failed', error: e, stackTrace: StackTrace.current);
      rethrow;
    } catch (e) {
      _logger.e('Unexpected error during sign in',
          error: e, stackTrace: StackTrace.current);
      rethrow;
    }
  }

  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password) async {
    if (!_rateLimiter.canAttempt(email)) {
      throw FirebaseAuthException(
        code: 'too-many-requests',
        message: 'Too many registration attempts. Please try again later.',
      );
    }

    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      _logger.e('Registration failed',
          error: e, stackTrace: StackTrace.current);
      rethrow;
    } catch (e) {
      _logger.e('Unexpected error during registration',
          error: e, stackTrace: StackTrace.current);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      _logger.e('Sign out failed', error: e, stackTrace: StackTrace.current);
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _logger.e('Password reset failed',
          error: e, stackTrace: StackTrace.current);
      rethrow;
    } catch (e) {
      _logger.e('Unexpected error during password reset',
          error: e, stackTrace: StackTrace.current);
      rethrow;
    }
  }
}
