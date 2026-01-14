import 'package:cloud_winpol_frontend/screens/admin/web/admin_main_screen.dart';
import 'package:cloud_winpol_frontend/screens/customer/customer_login_screen.dart';
import 'package:cloud_winpol_frontend/screens/customer/customer_main_screen.dart';
import 'package:cloud_winpol_frontend/screens/customer/urunQuery_main_screen.dart';
import 'package:cloud_winpol_frontend/screens/customer/web/customer_main_web.dart';
import 'package:cloud_winpol_frontend/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/screens/admin/web/admin_login_screen.dart';
import 'package:cloud_winpol_frontend/screens/admin/main_router_screen.dart';
import 'package:cloud_winpol_frontend/screens/customer/customer_home_screen.dart';
import 'package:cloud_winpol_frontend/screens/customer/customerList_main_screen.dart';
import 'package:cloud_winpol_frontend/screens/customer/userList_main_screen.dart';
import 'package:cloud_winpol_frontend/screens/customer/user_insert_screen.dart';
import 'package:cloud_winpol_frontend/screens/customer/branchList_main_screen.dart';
import 'package:cloud_winpol_frontend/screens/customer/mikroAPI_main_screen.dart';
import 'package:cloud_winpol_frontend/screens/customer/customer_register_screen.dart';

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
        '/mikroApiSettings': (_) => const MikroApiSettingsScreen(),
        '/customerRegister': (_) => const CustomerRegisterScreen(),
        '/productQuery': (_) => const UrunQueryMainScreen(),
      },
    );
  }
}
