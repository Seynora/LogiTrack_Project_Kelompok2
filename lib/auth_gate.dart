import 'package:flutter/material.dart';
import 'package:logitrack_app/auth_service.dart';
import 'package:logitrack_app/dashboard_page.dart';
import 'package:logitrack_app/login_page.dart';

class AuthGate extends StatelessWidget {
  AuthGate({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Terjadi kesalahan: ${snapshot.error}'),
            ),
          );
        }

        final isLoggedIn = snapshot.data ?? false;
        if (!isLoggedIn) {
          return const LoginPage();
        }

        return const DashboardPage();
      },
    );
  }
}  