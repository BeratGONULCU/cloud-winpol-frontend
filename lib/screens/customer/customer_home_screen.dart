import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/data/home_shortcuts.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';
import 'package:cloud_winpol_frontend/widgets/navigation/customer_app_draver.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:cloud_winpol_frontend/widgets/card/glass_shortcut_card.dart';
import 'package:cloud_winpol_frontend/screens/settings/settings_screen.dart';
import 'package:cloud_winpol_frontend/widgets/auth/AuthGuard.dart';

class HomeDashboardScreen extends StatelessWidget {
  static const String routeName = '/homeScreen';

  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      child: const _HomeDashboardContent(),
    );
  }
}

class _HomeDashboardContent extends StatelessWidget {
  const _HomeDashboardContent();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    final crossAxisCount = width >= 1400
        ? 4
        : width >= 720
            ? 3
            : width >= 700
                ? 2
                : 2;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.body2,
      drawer: const CustomerAppDrawer(),
      appBar: WinpolHeader(
        title: "Ana Sayfa",
        showLogo: false,
        onBack: null,
        onMenu: () => scaffoldKey.currentState?.openDrawer(),
        onSettings: () =>
            Navigator.pushNamed(context, SettingsScreen.routeName),
        titleStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.3,
          color: Colors.black.withOpacity(0.75),
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1400),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Favori Kısayollar",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: GridView.builder(
                  itemCount: homeShortcuts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.3,
                  ),
                  itemBuilder: (context, index) {
                    final item = homeShortcuts[index];
                    return GlassShortcutCard(
                      icon: item.icon,
                      title: item.title,
                      onTap: () => item.onTap(context),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
