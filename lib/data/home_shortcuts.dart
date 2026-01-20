import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/models/shortcut_item.dart';

final List<ShortcutItem> homeShortcuts = [
  ShortcutItem(
    icon: Icons.receipt_long,
    title: "Faturalar",
    onTap: (context) {
      //Navigator.pushNamed(context, '/adminLogin');
    },
  ),
  ShortcutItem(
    icon: Icons.inventory_2,
    title: "Ürünler",
    onTap: (ctx) {
      Navigator.of(ctx, rootNavigator: true).pushNamed('/productQuery');
    },
  ),

  ShortcutItem(
    icon: Icons.people,
    title: "Kullanıcılar",
    onTap: (context) {
      Navigator.pushNamed(context, '/userList');
    },
  ),
  ShortcutItem(
    icon: Icons.people,
    title: "Şubeler",
    onTap: (context) {
      Navigator.pushNamed(context, '/branchList');
    },
  ),
  ShortcutItem(icon: Icons.warehouse, title: "Depolar", onTap: (context) {}),
  ShortcutItem(icon: Icons.bar_chart, title: "Raporlar", onTap: (context) {}),
  ShortcutItem(
    icon: Icons.settings,
    title: "Ayarlar",
    onTap: (context) {
      Navigator.pushNamed(context, '/settings');
    },
  ),
  ShortcutItem(
    icon: Icons.api,
    title: "Mikro API Ayarları",
    onTap: (context) {
      Navigator.pushNamed(context, '/mikroApiSettings');
    },
  ),
];
