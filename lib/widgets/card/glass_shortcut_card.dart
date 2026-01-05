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
        child: AnimatedScale(
          scale: _hover ? 1.05 : 1,
          duration: const Duration(milliseconds: 180),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(_hover ? 0.32 : 0.25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.35),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 30,
                      offset: const Offset(0, 14),
                    ),
                    if (_hover)
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.35),
                        blurRadius: 90,
                        spreadRadius: -10,
                      ),
                  ],
                ),
                child: _content(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          widget.icon,
          size: 36,
          color: Colors.white,
        ),
        const SizedBox(height: 12),
        Text(
          widget.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

