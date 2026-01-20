import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';

class GlassShortcutCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const GlassShortcutCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  State<GlassShortcutCard> createState() => _GlassShortcutCardState();
}

class _GlassShortcutCardState extends State<GlassShortcutCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            // ZEMİNDEN NET AYRILAN RENK
            color: const Color(0xFFE1E5EC),
            borderRadius: BorderRadius.circular(14),

            // DAHA NET SINIR
            border: Border.all(color: Colors.black.withOpacity(0.22)),

            // KATMANLI GÖLGE (ÇOK ÖNEMLİ)
            boxShadow: [
              // ana gölge
              BoxShadow(
                color: Colors.black.withOpacity(0.20),
                blurRadius: 24,
                offset: const Offset(0, 14),
              ),

              // kart üst highlight (Apple hissi)
              BoxShadow(
                color: Colors.white.withOpacity(0.35),
                blurRadius: 1,
                offset: const Offset(0, -1),
              ),

              // hover derinliği
              if (_hover)
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.35),
                  blurRadius: 40,
                  offset: const Offset(0, 18),
                ),
            ],
          ),
          child: _content(),
        ),
      ),
    );
  }

  Widget _content() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(widget.icon, size: 26, color: AppColors.primary),
        const SizedBox(height: 10),
        Text(
          widget.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1C1C1E), // ⬅ iOS text rengi
          ),
        ),
      ],
    );
  }
}
