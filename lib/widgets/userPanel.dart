import 'dart:ui';
import 'package:cloud_winpol_frontend/models/customer_action.dart';
import 'package:cloud_winpol_frontend/widgets/buttons/panelActionBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:cloud_winpol_frontend/models/customer_summary.dart';
import 'package:flutter/services.dart';


class UserPanel extends StatefulWidget {
  const UserPanel({super.key});

  @override
  State<UserPanel> createState() => _UserPanelState();
}

class _UserPanelState extends State<UserPanel> {
  CustomerAction action = CustomerAction.create;

  // ================= CONTROLLERS =================
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  // edit
  final _editUsernameController = TextEditingController();
  final _editEmailController = TextEditingController();
  final _editPhoneController = TextEditingController();

  bool _isPassive = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();

    _editUsernameController.dispose();
    _editEmailController.dispose();
    _editPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _PanelContainer(
      title: "Kullanıcı İşlemleri",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomerActionBar(
            selected: action,
            onChanged: (a) => setState(() => action = a),
          ),
          const SizedBox(height: 18),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: action == CustomerAction.create
                ? _createForm()
                : _editForm(),
          ),
        ],
      ),
    );
  }

  // ================= CREATE =================
  Widget _createForm() {
    return Column(
      key: const ValueKey("createUser"),
      children: [
        _input(_usernameController, "Kullanıcı Adı"),
        const SizedBox(height: 6),
        _input(_emailController, "E-posta"),
        const SizedBox(height: 6),
        _input(_passwordController, "Şifre", obscure: true),
        const SizedBox(height: 6),
        _input(_phoneController, "Telefon"),
        const SizedBox(height: 24),
        _submitButton("Kullanıcı Oluştur", () {}),
      ],
    );
  }

  // ================= EDIT =================
  Widget _editForm() {
    return Column(
      key: const ValueKey("editUser"),
      children: [
        _input(_editUsernameController, "Kullanıcı Adı"),
        const SizedBox(height: 6),
        _input(_editEmailController, "E-posta"),
        const SizedBox(height: 6),
        _input(_editPhoneController, "Telefon"),
        const SizedBox(height: 12),

        SwitchListTile.adaptive(
          value: _isPassive,
          title: const Text("Pasif Kullanıcı"),
          onChanged: (v) => setState(() => _isPassive = v),
        ),

        const SizedBox(height: 20),
        _submitButton("Kullanıcı Güncelle", () {}),
      ],
    );
  }

  // ================= HELPERS =================
  Widget _input(
    TextEditingController controller,
    String placeholder, {
    bool obscure = false,
  }) {
    return SizedBox(
      width: 280,
      child: CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        obscureText: obscure,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black26),
        ),
      ),
    );
  }

  Widget _submitButton(String text, VoidCallback onTap) {
    return SizedBox(
      width: 200,
      child: CupertinoButton(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
class _PanelContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const _PanelContainer({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 520,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}
