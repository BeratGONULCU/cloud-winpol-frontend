import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/service/auth_storage.dart';
import 'package:cloud_winpol_frontend/screens/customer_login_screen.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: AuthStorage.getToken(),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final token = snapshot.data;

        // TOKEN YOK → LOGIN
        if (token == null || token.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              CustomerLoginScreen.routeName,
              (route) => false,
            );
          });

          return const SizedBox.shrink();
        }

        // TOKEN VAR → SAYFA
        return child;
      },
    );
  }
}
