import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:cloud_winpol_frontend/widgets/card/router_card.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';

class MainRouterScreen extends StatelessWidget {
  static const String routeName = '/main-router';

  const MainRouterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F4C81), Color.fromARGB(39, 28, 107, 160)],
          ),
        ),
        child: Center(
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
      ),
    );
  }
}
