import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/screens/settings/settings_screen.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'mobile/customer_main_mobile.dart';
import 'web/customer_main_web.dart';

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
