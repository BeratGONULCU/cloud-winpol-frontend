import 'package:cloud_winpol_frontend/screens/customer_login_screen.dart';
import 'package:cloud_winpol_frontend/screens/customer_main_screen.dart';
import 'package:cloud_winpol_frontend/screens/web/customer_main_web.dart';
import 'package:cloud_winpol_frontend/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/screens/admin_login_screen.dart';
import 'package:cloud_winpol_frontend/screens/main_router_screen.dart';

void main() {
  runApp(const WinpolApp());
}

class WinpolApp extends StatelessWidget {
  const WinpolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainRouterScreen(),

      routes: {
        '/router': (_) => const MainRouterScreen(),
        '/adminLogin': (_) => const AdminLoginScreen(),
        '/customerLogin': (_) => const CustomerLoginScreen(),
        '/customerMain': (_) => const CustomerMainScreen(),
        '/settings': (_) => const SettingsScreen(),
      },
    );
  }
}
