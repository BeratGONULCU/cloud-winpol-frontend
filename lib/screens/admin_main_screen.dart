import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/screens/mobile/admin_main_mobile.dart';
import 'package:cloud_winpol_frontend/screens/web/admin_main_web.dart';

class AdminMainScreen extends StatelessWidget {
  static const String routeName = '/adminMain';
  const AdminMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // breakpoint tamamen senin kontrolünde
    if (width < 768) {
      return const AdminMainMobileScreen();
    } else {
      return const AdminMainWebScreen();
    }
  }
}
