import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';

class RouterCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const RouterCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<RouterCard> createState() => _RouterCardState();
}

class _RouterCardState extends State<RouterCard> {
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHover = true),
      onExit: (_) => setState(() => _isHover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: _isHover ? 1.02 : 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 18,
                sigmaY: 18,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                width: 320,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(_isHover ? 0.32 : 0.25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.35),
                    width: 1,
                  ),
                  boxShadow: [
                    // Ana gölge (derinlik)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 30,
                      offset: const Offset(0, 14),
                    ),
                    // Hover sırasında hafif mavi aura
                    if (_isHover)
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.35),
                        blurRadius: 80,
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
            child: Text(widget.title, textAlign: TextAlign.center),
          ),
          const SizedBox(height: 6),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.85),
            ),
            child: Text(widget.subtitle, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
