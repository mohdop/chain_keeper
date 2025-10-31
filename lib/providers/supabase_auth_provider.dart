import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_auth_service.dart';

class SupabaseAuthProvider with ChangeNotifier {
  final SupabaseAuthService _authService = SupabaseAuthService();
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  String? get displayName => _authService.displayName;
  String? get email => _authService.email;

  SupabaseAuthProvider() {
    // Listen to auth state changes
    _authService.authStateChanges.listen((AuthState state) {
      _user = state.session?.user;
      notifyListeners();
    });

    // Set initial user
    _user = _authService.currentUser;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final error = await _authService.signUpWithEmail(
      email: email,
      password: password,
      name: name,
    );

    _isLoading = false;
    
    if (error != null) {
      _errorMessage = error;
      notifyListeners();
      return false;
    }

    notifyListeners();
    return true;
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final error = await _authService.signInWithEmail(
      email: email,
      password: password,
    );

    _isLoading = false;
    
    if (error != null) {
      _errorMessage = error;
      notifyListeners();
      return false;
    }

    notifyListeners();
    return true;
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final error = await _authService.sendPasswordResetEmail(email);

    _isLoading = false;
    
    if (error != null) {
      _errorMessage = error;
      notifyListeners();
      return false;
    }

    notifyListeners();
    return true;
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    await _authService.signOut();

    _isLoading = false;
    _user = null;
    notifyListeners();
  }

  Future<bool> deleteAccount() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final error = await _authService.deleteAccount();

    _isLoading = false;
    
    if (error != null) {
      _errorMessage = error;
      notifyListeners();
      return false;
    }

    notifyListeners();
    return true;
  }

  Future<bool> updateDisplayName(String name) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final error = await _authService.updateDisplayName(name);

    _isLoading = false;
    
    if (error != null) {
      _errorMessage = error;
      notifyListeners();
      return false;
    }

    // Reload user
    _user = _authService.currentUser;
    notifyListeners();
    return true;
  }

  Future<bool> updateEmail(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final error = await _authService.updateEmail(email);

    _isLoading = false;
    
    if (error != null) {
      _errorMessage = error;
      notifyListeners();
      return false;
    }

    notifyListeners();
    return true;
  }

  Future<bool> updatePassword(String newPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final error = await _authService.updatePassword(newPassword);

    _isLoading = false;
    
    if (error != null) {
      _errorMessage = error;
      notifyListeners();
      return false;
    }

    notifyListeners();
    return true;
  }
}