import 'package:cloud_winpol_frontend/screens/settings/settings_screen.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomerMainScreen extends StatefulWidget {
  static const String routeName = '/customerMain';
  const CustomerMainScreen({super.key});

  @override
  State<CustomerMainScreen> createState() => _CustomerMainScreenState();
}

class _CustomerMainScreenState extends State<CustomerMainScreen> {

    @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<bool> _onBackPressed() async {
    // Eğer SQL'den aktif bir IS_GUID varsa → modal göster

    return await _showExitConfirmDialog();

    // aktif bir kayıt yok → direkt çık
    return true;
  }

  Future<bool> _showExitConfirmDialog() async {
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.body,

      appBar: WinpolHeader(
        title: "Winpol",
        onBack: () async {
          if (await _onBackPressed()) {
            Navigator.pop(context);
          }
        },
        onSettings: () {
          Navigator.pushNamed(context, SettingsScreen.routeName);
        },
        showLogo: true,
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(124),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary,
                    offset: const Offset(0, 45),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
