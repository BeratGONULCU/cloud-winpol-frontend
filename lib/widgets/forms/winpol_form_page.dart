import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/widgets/navigation/customer_app_draver.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:cloud_winpol_frontend/screens/settings/settings_screen.dart';

class WinpolFormPage extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onBack;

  const WinpolFormPage({
    super.key,
    required this.title,
    required this.child,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.body,
      drawer: const CustomerAppDrawer(),
      appBar: WinpolHeader(
        title: title,
        showLogo: true,
        onBack: onBack,
        onMenu: () => scaffoldKey.currentState?.openDrawer(),
        onSettings: () =>
            Navigator.pushNamed(context, SettingsScreen.routeName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: child,
      ),
    );
  }
}
