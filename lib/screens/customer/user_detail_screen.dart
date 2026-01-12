import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/models/user_summary.dart';
import 'package:cloud_winpol_frontend/screens/admin/mobile/admin_main_mobile.dart';
import 'package:cloud_winpol_frontend/screens/admin/web/admin_main_web.dart'
    hide UserPanel;
import 'package:cloud_winpol_frontend/widgets/userPanel.dart';

class UserDetailScreen extends StatelessWidget {
  final UserSummary user;

  const UserDetailScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.username),
      ),
      body: UserPanel(
        // edit modu ileride açılır
        // isEdit: true,
        // userId: user.id,
      ),
    );
  }
}
