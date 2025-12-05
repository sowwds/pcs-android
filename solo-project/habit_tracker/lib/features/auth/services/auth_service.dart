import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:habit_tracker/core/services/supabase_service.dart';

/// Service class for handling user authentication with Supabase.
class AuthService {
  final GoTrueClient _auth = SupabaseService.instance.auth;

  /// The current logged-in user, if any.
  User? get currentUser => _auth.currentUser;

  /// Stream of authentication state changes.
  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;

  /// Signs up a new user with email and password.
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signUp(email: email, password: password);
    } catch (e) {
      // It's better to handle errors in the UI layer,
      // but logging them here can be useful for debugging.
      debugPrint('Sign up error: $e');
      rethrow;
    }
  }

  /// Signs in an existing user with email and password.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      debugPrint('Sign in error: $e');
      rethrow;
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Sign out error: $e');
      rethrow;
    }
  }
}
