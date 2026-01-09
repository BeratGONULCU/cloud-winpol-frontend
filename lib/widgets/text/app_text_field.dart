import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final bool obscure;
  final TextEditingController controller;
  final VoidCallback? onSubmit;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscure = false,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w600,
            fontSize: 13, // 14 → 13
            color: Color(0xFF2C4B7D),
          ),
        ),
        const SizedBox(height: 4), // 6 → 4
        TextField(
          controller: controller,
          obscureText: obscure,
          textInputAction:
              obscure ? TextInputAction.done : TextInputAction.next,
          onSubmitted: (_) => onSubmit?.call(),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12, // 14 → 12
              vertical: 10, // 14 → 10
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6), // 8 → 6
              borderSide:
                  const BorderSide(color: Color(0xFF94A3B8), width: 1),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: Color(0xFF07578F),
                width: 1.4, // 1.5 → 1.4
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide:
                  const BorderSide(color: Colors.red, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}
