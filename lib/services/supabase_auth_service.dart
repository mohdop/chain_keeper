import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Auth state changes stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Sign up with email and password
  Future<String?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': name},
      );

      if (response.user == null) {
        return 'Erreur lors de la création du compte.';
      }

      return null; // Success
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Une erreur inattendue est survenue: ${e.toString()}';
    }
  }

  // Sign in with email and password
  Future<String?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return null; // Success
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Une erreur inattendue est survenue: ${e.toString()}';
    }
  }

  // Send password reset email
  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return null; // Success
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Une erreur inattendue est survenue: ${e.toString()}';
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Delete account
  Future<String?> deleteAccount() async {
    try {
      final user = currentUser;
      if (user == null) return 'Utilisateur non trouvé.';

      await signOut();
      return null;
    } catch (e) {
      return 'Erreur lors de la suppression du compte: ${e.toString()}';
    }
  }

  // Update display name
  Future<String?> updateDisplayName(String name) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(data: {'display_name': name}),
      );
      return null; // Success
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Erreur lors de la mise à jour du nom: ${e.toString()}';
    }
  }

  // Update email
  Future<String?> updateEmail(String email) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(email: email),
      );
      return null; // Success
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Erreur lors de la mise à jour de l\'email: ${e.toString()}';
    }
  }

  // Update password
  Future<String?> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return null; // Success
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Erreur lors de la mise à jour du mot de passe: ${e.toString()}';
    }
  }

  // Get user display name
  String? get displayName {
    final user = currentUser;
    if (user == null) return null;
    return user.userMetadata?['display_name'] as String?;
  }

  // Get user email
  String? get email => currentUser?.email;
}