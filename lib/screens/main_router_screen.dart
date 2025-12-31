import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:cloud_winpol_frontend/widgets/router_card.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';

class MainRouterScreen extends StatefulWidget {
  static const String routeName = '/main-router';

  const MainRouterScreen({super.key});

  @override
  State<MainRouterScreen> createState() => _MainRouterScreenState();
}

class _MainRouterScreenState extends State<MainRouterScreen> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.body,

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RouterCard(
              title: 'Admin Paneli',
              subtitle: 'Admin işlemleri ve ayarlar',
              onTap: () {
                Navigator.pushNamed(context, '/adminLogin');
              },
            ),

            const SizedBox(height: 24),

            RouterCard(
              title: 'Müşteri Yönetim Paneli',
              subtitle: 'Şirket içi eylemler',
              onTap: () {
                Navigator.pushNamed(context, '/customerLogin');
              },
            ),
          ],
        ),
      ),
    );
  }
}
