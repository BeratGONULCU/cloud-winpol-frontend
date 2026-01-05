import 'package:flutter/material.dart';

class ShortcutItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ShortcutItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
