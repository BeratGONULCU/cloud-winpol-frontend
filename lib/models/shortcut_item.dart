import 'package:flutter/material.dart';

class ShortcutItem {
  final IconData icon;
  final String title;
  final void Function(BuildContext context) onTap;

  ShortcutItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
