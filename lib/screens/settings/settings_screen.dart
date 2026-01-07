import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.body,
      appBar: WinpolHeader(
        title: "Ayarlar",
        onBack: () => Navigator.pop(context),
        onSettings: null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // ================= THEME SECTION =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Görünüm",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 12),

                    CupertinoSlidingSegmentedControl<bool>(
                      groupValue: isDarkMode,
                      children: const {
                        false: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text("Light"),
                        ),
                        true: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text("Dark"),
                        ),
                      },
                      onValueChanged: (value) {
                        if (value == null) return;
                        setState(() => isDarkMode = value);

                        // TODO: ThemeProvider varsa burada bağla
                        // context.read<ThemeProvider>().setDarkMode(value);
                      },
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // ================= LOGOUT BUTTON =================
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Center(
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 14,
                  ),
                  color: Colors.red.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  child: const Text(
                    "Çıkış Yap",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= LOGOUT CONFIRM =================
  void _showLogoutDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text("Çıkış Yap"),
        content: const Text("Oturumu kapatmak istediğinize emin misiniz?"),
        actions: [
          CupertinoDialogAction(
            child: const Text("İptal"),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text("Çıkış Yap"),
            onPressed: () {
              Navigator.pop(context);

              // TODO: token temizleme / logout işlemleri
              // AuthService.logout();

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
