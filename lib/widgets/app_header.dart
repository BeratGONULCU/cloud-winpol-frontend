import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';

class WinpolHeader extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? onBack;
  final VoidCallback? onSettings;

  final String? title;
  final bool showLogo;

  const WinpolHeader({
    super.key,
    required this.onBack,
    this.onSettings,
    this.title,
    this.showLogo = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(99); // SABİT YÜKSEKLİK

  @override
  State<WinpolHeader> createState() => _WinpolHeaderState();
}

class _WinpolHeaderState extends State<WinpolHeader> {
  bool _isConnected = false;
  bool _isVisible = true; // yanıp sönme için
  Timer? _connectionTimer;
  Timer? _blinkTimer;
  bool _errorPopupShown = false; // ← popup sadece bir kez gösterilsin

  @override
  void initState() {
    super.initState();

    // Her 10 saniyede görünür/görünmez değiştir
    _blinkTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (mounted) {
        setState(() {
          _isVisible = !_isVisible;
        });
      }
    });
  }

  @override
  void dispose() {
    _connectionTimer?.cancel();
    _blinkTimer?.cancel();
    super.dispose();
  }

  void _showErrorPopup(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420, maxHeight: 350),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 200,
                      height: 75,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Tamam",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 96,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          color: AppColors.body,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (widget.onBack != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: _circleIcon(
                    icon: Icons.arrow_back_ios_new,
                    onTap: widget.onBack!,
                  ),
                ),

              Center(
                child: widget.showLogo
                    ? Image.asset(
                        'assets/images/winpol_logo.png',
                        height: 40,
                        fit: BoxFit.contain,
                      )
                    : Text(
                        widget.title ?? "",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
              ),

              if (widget.onSettings != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: _circleIconSettings(
                    icon: CupertinoIcons.settings,
                    onTap: widget.onSettings!,
                  ),
                ),
            ],
          ),
        ),

        // İNCE AYIRICI ÇİZGİ (APPLE STYLE)
        Divider(
          height: 1.5,
          thickness: 0.5,
          color: AppColors.primary.withAlpha(175),
        ),
      ],
    );
  }
}

Widget _circleIcon({required IconData icon, required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(50),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withOpacity(0.02),
        border: Border.all(color: AppColors.primary.withAlpha(0), width: 1.5),
      ),
      child: Icon(icon, color: AppColors.primary, size: 28),
    ),
  );
}

Widget _circleIconSettings({
  required IconData icon,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withOpacity(0.02),
        border: Border.all(color: AppColors.primary.withAlpha(0), width: 1.5),
      ),
      child: Icon(icon, color: AppColors.primary, size: 28),
    ),
  );
}
