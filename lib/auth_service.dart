import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal();

  final StreamController<bool> _authStateController = StreamController<bool>.broadcast();
  final Map<String, String> _localUsers = {};
  bool _isLocalLoggedIn = false;
  String? lastError;

  bool get _hasFirebaseApp => Firebase.apps.isNotEmpty;

  bool get _firebaseConfigured {
    if (!_hasFirebaseApp) return false;
    final options = Firebase.apps.first.options;
    return options.apiKey.isNotEmpty &&
        !options.apiKey.contains('YOUR_') &&
        options.projectId.isNotEmpty &&
        !options.projectId.contains('YOUR_') &&
        options.appId.isNotEmpty &&
        !options.appId.contains('YOUR_');
  }

  bool get _firebaseAvailable => _hasFirebaseApp && _firebaseConfigured;
  FirebaseAuth get _auth => FirebaseAuth.instance;

  Stream<bool> get authStateChanges {
    if (_firebaseAvailable) {
      return _auth.authStateChanges().map((user) => user != null);
    } else {
      return () async* {
        yield _isLocalLoggedIn;
        yield* _authStateController.stream;
      }();
    }
  }

  Future<bool> signIn(String email, String password) async {
    if (!_firebaseAvailable) {
      final storedPassword = _localUsers[email];
      final success = storedPassword != null && storedPassword == password;
      _isLocalLoggedIn = success;
      _authStateController.add(success);
      if (!success) {
        lastError = 'Email atau password salah.';
        if (kDebugMode) {
          debugPrint('Local sign in failed for $email');
        }
      } else {
        lastError = null;
      }
      return success;
    }

    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final success = userCredential.user != null;
      _authStateController.add(success);
      lastError = success ? null : 'Login gagal.';
      return success;
    } catch (e) {
      lastError = 'Login gagal: $e';
      if (kDebugMode) {
        debugPrint('Error signing in: $e');
      }
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    if (!_firebaseAvailable) {
      if (_localUsers.containsKey(email)) {
        lastError = 'Akun sudah terdaftar.';
        if (kDebugMode) {
          debugPrint('Local sign up failed: user already exists');
        }
        return false;
      }
      _localUsers[email] = password;
      _isLocalLoggedIn = true;
      _authStateController.add(true);
      lastError = null;
      return true;
    }

    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final success = userCredential.user != null;
      _authStateController.add(success);
      lastError = success ? null : 'Registrasi gagal.';
      return success;
    } catch (e) {
      lastError = 'Registrasi gagal: $e';
      if (kDebugMode) {
        debugPrint('Error signing up: $e');
      }
      return false;
    }
  }

  Future<bool> registerWithEmailPassword(String email, String password) async {
    return signUp(email, password);
  }

  Future<bool> signOut() async {
    if (!_firebaseAvailable) {
      _isLocalLoggedIn = false;
      _authStateController.add(false);
      return true;
    }

    try {
      await _auth.signOut();
      _authStateController.add(false);
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error signing out: $e');
      }
      return false;
    }
  }
}
