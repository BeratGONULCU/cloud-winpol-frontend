import 'package:cloud_winpol_frontend/data/home_shortcuts.dart';
import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:cloud_winpol_frontend/widgets/card/glass_shortcut_card.dart';

class HomeDashboardScreen extends StatelessWidget {
  static const String routeName = '/homeScreen';
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final int crossAxisCount = width > 1400
        ? 5
        : width > 1100
        ? 4
        : width > 800
        ? 3
        : 2;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F4C81), Color.fromARGB(161, 28, 107, 160)],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.builder(
                itemCount: homeShortcuts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 1, // KARE
                ),
                itemBuilder: (context, index) {
                  final item = homeShortcuts[index];

                  final bool isDesktop = width >= 1100;
                  final bool isTablet = width >= 800 && width < 1100;

                  final double cardSize = isDesktop
                      ? 210.0
                      : isTablet
                      ? 160.0
                      : 160.0;

                  return Center(
                    child: SizedBox.square(
                      dimension: cardSize,
                      child: GlassShortcutCard(
                        icon: item.icon,
                        title: item.title,
                        onTap: item.onTap,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return const Text(
      "Favori Kısayollar",
      style: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }
}
