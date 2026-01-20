import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/models/shortcut_item.dart';

final List<ShortcutItem> userShortcuts = [
  ShortcutItem(
    icon: Icons.verified_user,
    title: "Kullanıcı Yetkilendirme",
    onTap: (ctx) {
      Navigator.of(ctx, rootNavigator: true).pushNamed('/userList');
    },
  ),
  ShortcutItem(
    icon: Icons.security,
    title: "Yetki Tanımları",
    onTap: (ctx) {
      Navigator.of(ctx, rootNavigator: true).pushNamed('/roleInsertWeb');
    },
  ),

];
