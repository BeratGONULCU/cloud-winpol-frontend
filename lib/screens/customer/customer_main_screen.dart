import 'package:flutter/material.dart';
import 'mobile/customer_main_mobile.dart';
import 'package:cloud_winpol_frontend/screens/customer/web/customer_main_web.dart';

class CustomerMainScreen extends StatelessWidget {
  static const String routeName = '/customerMain';
  const CustomerMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // breakpoint tamamen senin kontrolünde
    if (width < 768) {
      return const CustomerMainMobileScreen();
    } else {
      return const CustomerMainWebScreen();
    }
  }
}
