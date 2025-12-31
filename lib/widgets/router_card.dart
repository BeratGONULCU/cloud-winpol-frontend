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
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          width: 320,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              // arkadan ışık hissi
              BoxShadow(
                color: AppColors.primary.withOpacity(_isHover ? 0.95 : 0.20),
                blurRadius: _isHover ? 150 : 84,
                spreadRadius: -8,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _isHover
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.85),
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
                    color: _isHover
                        ? AppColors.primary.withOpacity(0.85)
                        : AppColors.primary.withOpacity(0.7),
                  ),
                  child: Text(widget.subtitle, textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
