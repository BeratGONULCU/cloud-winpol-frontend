import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'package:cloud_winpol_frontend/models/customer_action.dart';


class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final bool enabled;

  const SubmitButton({
    required this.onPressed,
    this.label = "Kaydet",
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.4),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
