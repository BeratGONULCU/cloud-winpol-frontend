import 'package:cloud_winpol_frontend/screens/admin_main_screen.dart';
import 'package:cloud_winpol_frontend/screens/customer_login_screen.dart';
import 'package:cloud_winpol_frontend/screens/customer_main_screen.dart';
import 'package:cloud_winpol_frontend/screens/web/customer_main_web.dart';
import 'package:cloud_winpol_frontend/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/screens/admin_login_screen.dart';
import 'package:cloud_winpol_frontend/screens/main_router_screen.dart';
import 'package:cloud_winpol_frontend/screens/customer_home_screen.dart';
import 'package:cloud_winpol_frontend/screens/customerList_main_screen.dart';
import 'package:cloud_winpol_frontend/screens/userList_main_screen.dart';
import 'package:cloud_winpol_frontend/screens/user_insert_screen.dart';
import 'package:cloud_winpol_frontend/screens/branchList_main_screen.dart';
import 'package:cloud_winpol_frontend/screens/mikroAPI_main_screen.dart';

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
        '/adminMain': (_) => const AdminMainScreen(),
        '/homeScreen': (_) => const HomeDashboardScreen(),
        '/customerList': (_) => const CustomerListScreen(),
        '/userList': (_) => const UserlistMainScreen(),
        '/userInsertWeb': (_) => const userInsertScreen(),
        '/branchList': (_) => const BranchlistMainScreen(),
        '/mikroAPI': (_) => const MikroAPIMainScreen(),
      },
    );
  }
}
