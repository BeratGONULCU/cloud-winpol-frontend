import 'package:cloud_winpol_frontend/models/app_button_type.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final AppButtonType type;

  const AppButton({
    super.key,
    required this.title,
    required this.onTap,
    this.type = AppButtonType.primary,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    BorderSide? border;

    switch (type) {
      case AppButtonType.secondary:
        backgroundColor = Colors.transparent;
        textColor = AppColors.primary;
        border = BorderSide(color: AppColors.primary, width: 1.2);
        break;

      case AppButtonType.text:
        backgroundColor = Colors.transparent;
        textColor = AppColors.primary;
        border = BorderSide.none;
        break;

      case AppButtonType.primary:
      default:
        backgroundColor = AppColors.primary;
        textColor = Colors.white;
        border = BorderSide.none;
    }

    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: border ?? BorderSide.none,
          ),
        ),
        onPressed: onTap,
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
