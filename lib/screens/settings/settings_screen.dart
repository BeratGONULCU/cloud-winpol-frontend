import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.body,
      appBar: WinpolHeader(
        title: "Ayarlar",
        onBack: () => Navigator.pop(context),
        onSettings: null, // ayarlar ekranında ayar butonu olmaz
      ),
      body: const Center(
        child: Text(
          "Settings Screen",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
