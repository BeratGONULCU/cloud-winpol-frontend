import 'package:flutter/material.dart';
import 'service/auth_storage.dart';

import 'screens/main_router_screen.dart';
import 'screens/customer_login_screen.dart';
import 'screens/admin_login_screen.dart';
import 'screens/customer_home_screen.dart';
import 'screens/customerList_main_screen.dart';
import 'screens/userList_main_screen.dart';
import 'screens/branchList_main_screen.dart';
import 'screens/mikroAPI_main_screen.dart';
import 'screens/settings/settings_screen.dart';

class AppRouter {
  static Route<dynamic> generate(RouteSettings settings) {
    debugPrint("ROUTE => ${settings.name}");

    // ===============================
    // AUTH GEREKTİRMEYEN EKRANLAR
    // ===============================
    if (settings.name == MainRouterScreen.routeName) {
      return MaterialPageRoute(
        builder: (_) => const MainRouterScreen(),
        settings: settings,
      );
    }

    if (settings.name == CustomerLoginScreen.routeName) {
      return MaterialPageRoute(
        builder: (_) => const CustomerLoginScreen(),
        settings: settings,
      );
    }

    if (settings.name == AdminLoginScreen.routeName) {
      return MaterialPageRoute(
        builder: (_) => const AdminLoginScreen(),
        settings: settings,
      );
    }

    // ===============================
    // AUTH GEREKEN EKRANLAR
    // ===============================
    return MaterialPageRoute(
      settings: settings,
      builder: (_) {
        return FutureBuilder<String?>(
          future: AuthStorage.getToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final token = snapshot.data;
            final isLoggedIn = token != null && token.isNotEmpty;

            if (!isLoggedIn) {
              return const CustomerLoginScreen();
            }

            // KORUMALI ROUTE MAP
            switch (settings.name) {
              case '/homeScreen':
                return const HomeDashboardScreen();

              case '/customerList':
                return const CustomerListScreen();

              case '/userList':
                return const UserlistMainScreen();

              case '/branchList':
                return const BranchlistMainScreen();

              case '/mikroAPI':
                return const MikroAPIMainScreen();

              case '/settings':
                return const SettingsScreen();

              default:
                return const HomeDashboardScreen();
            }
          },
        );
      },
    );
  }
}
