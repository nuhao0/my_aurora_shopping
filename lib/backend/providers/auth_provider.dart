import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:taqikrdnawa/backend/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService() {
    _subscription = _authService.authStateChanges().listen((event) {
      _user = event;
      notifyListeners();
    });
  }

  final AuthService _authService;
  StreamSubscription<User?>? _subscription;

  User? _user;
  bool _isLoading = false;
  String? _error;
  String? _errorCode;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get errorCode => _errorCode;

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    _errorCode = null;
    notifyListeners();
    try {
      await _authService.signIn(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorCode = e.code;
      _error = _friendlyError('signIn', e);
      return false;
    } catch (_) {
      _error = 'Sign in failed';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(String email, String password) async {
    _isLoading = true;
    _error = null;
    _errorCode = null;
    notifyListeners();
    try {
      await _authService.signUp(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorCode = e.code;
      _error = _friendlyError('signUp', e);
      return false;
    } catch (_) {
      _error = 'Sign up failed';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() => _authService.signOut();

  String _friendlyError(String action, FirebaseAuthException e) {
    final message = e.message ?? 'Unknown FirebaseAuth error';
    if (message.contains('CONFIGURATION_NOT_FOUND')) {
      return 'Firebase config missing (CONFIGURATION_NOT_FOUND). '
          'Enable Email/Password in Firebase Auth, add SHA-1/SHA-256 for '
          'com.example.taqikrdnawa, then re-download google-services.json.';
    }
    return '${action == 'signIn' ? 'Sign in' : 'Sign up'} failed '
        '(${e.code}): $message';
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
