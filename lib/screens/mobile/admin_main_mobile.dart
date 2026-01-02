import 'package:cloud_winpol_frontend/models/customer_action.dart';
import 'package:cloud_winpol_frontend/widgets/navigation/admin_app_draver.dart';
import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/screens/settings/settings_screen.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:cloud_winpol_frontend/widgets/buttons/panelActionBar.dart';
import 'package:cloud_winpol_frontend/service/company_service.dart';
import 'package:cloud_winpol_frontend/widgets/buttons/submit_button.dart';
import 'dart:ui';

import 'package:flutter/services.dart';

class AdminMainMobileScreen extends StatefulWidget {
  static const String routeName = '/adminMain';
  const AdminMainMobileScreen({super.key});

  @override
  State<AdminMainMobileScreen> createState() => _AdminMainMobileScreenState();
}

class _AdminMainMobileScreenState extends State<AdminMainMobileScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<_AdminTab> _tabs = const [
    _AdminTab("Müşteriler", Icons.people, CustomerPanel()),
    _AdminTab("Lisanslar", Icons.security, LicencePanel()),
    _AdminTab("Mikro API", Icons.account_tree, MikroApiPanel()),
    _AdminTab(
      "Ayarlar",
      Icons.settings_accessibility_outlined,
      SettingsPanel(),
    ),
  ];

  Future<bool> _onBackPressed() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xFFF5F6F8),
          drawer: const AdminAppDrawer(),
          appBar: WinpolHeader(
            title: "",
            showLogo: false,
            onBack: null,
            onMenu: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            onSettings: () {
              Navigator.pushNamed(context, SettingsScreen.routeName);
            },
          ),

          body: Column(
            children: [
              // PANEL ALANI
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    key: ValueKey(_selectedIndex),
                    padding: const EdgeInsets.all(16),
                    child: _tabs[_selectedIndex].widget,
                  ),
                ),
              ),

              // ADMIN TOOLBAR
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _AdminToolbar(
                  tabs: _tabs,
                  selectedIndex: _selectedIndex,
                  onSelect: (i) => setState(() => _selectedIndex = i),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

//
// =======================
// ADMIN TOOLBAR
// =======================
//

class _AdminToolbar extends StatelessWidget {
  final List<_AdminTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _AdminToolbar({
    required this.tabs,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isCompact = width < 600; // telefon breakpoint
    final isScrollable = width < 900;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(tabs.length, (i) {
        final selected = i == selectedIndex;

        return GestureDetector(
          onTap: () => onSelect(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 12 : 14,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primary.withOpacity(0.9)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                isCompact
                    ? Tooltip(
                        // --> bu iphone içerisine kullanılan : basılı tutunca detay çıkan kısım
                        message: tabs[i].title,
                        child: Icon(
                          tabs[i].icon,
                          size: 18,
                          color: selected
                              ? Colors.white
                              : Colors.black.withAlpha(135),
                        ),
                      )
                    : Icon(
                        tabs[i].icon,
                        size: 18,
                        color: selected
                            ? Colors.white
                            : Colors.black.withAlpha(135),
                      ),

                // TELEFONDA YAZIYI GİZLE
                if (!isCompact) ...[
                  const SizedBox(width: 6),
                  Text(
                    tabs[i].title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: selected
                          ? Colors.white
                          : Colors.black.withOpacity(0.65),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.black12),
              ),
              child: isScrollable
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: content,
                    )
                  : content,
            ),
          ),
        ),
      ),
    );
  }
}

//
// =======================
// ADMIN TAB MODEL
// =======================
//

class _AdminTab {
  final String title;
  final IconData icon;
  final Widget widget;

  const _AdminTab(this.title, this.icon, this.widget);
}

//
// =======================
// COMMON PANEL CONTAINER
// =======================
//

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

//
// =======================
// PANELS (PLACEHOLDERS)
// =======================
//
class CustomerPanel extends StatefulWidget {
  const CustomerPanel({super.key});

  @override
  State<CustomerPanel> createState() => _CustomerPanelState();
}

class _CustomerPanelState extends State<CustomerPanel> {
  CustomerAction action = CustomerAction.create;

  final _taxNoController = TextEditingController();
  final _nameController = TextEditingController();
  final _companyCodeController = TextEditingController();

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _submitCreate() {
    final taxNo = _taxNoController.text.trim();
    final name = _nameController.text.trim();
    final companyCode = _companyCodeController.text.trim();

    if (taxNo.length != 10) {
      _showError("Vergi No 10 haneli olmalıdır");
      return;
    }

    if (name.isEmpty) {
      _showError("Cari adı boş olamaz");
      return;
    }

    CompanyService.createCustomer(
      vergiNo: taxNo,
      cariAdi: name,
      companyCode: companyCode,
    );
  }

  @override
  void dispose() {
    _taxNoController.dispose();
    _nameController.dispose();
    _companyCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _PanelContainer(
      title: "Müşteri İşlemleri",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // EKLE / DÜZENLE BUTTON BAR
          CustomerActionBar(
            selected: action,
            onChanged: (a) => setState(() => action = a),
          ),

          const SizedBox(height: 18),

          // FORM ALANI
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _buildForm(),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    switch (action) {
      case CustomerAction.create:
        return Column(
          key: const ValueKey("create"),
          children: [
            _MinimalTextBox(
              hint: "Vergi No",
              controller: _taxNoController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),
            const SizedBox(height: 12),
            _MinimalTextBox(hint: "Cari Adı", controller: _nameController),
            const SizedBox(height: 12),
            _MinimalTextBox(
              hint: "Şirket Kodu",
              controller: _companyCodeController,
            ),
            const SizedBox(height: 20),

            SubmitButton(label: "Müşteri Oluştur", onPressed: _submitCreate),
          ],
        );

      case CustomerAction.edit:
        return Column(
          key: const ValueKey("edit"),
          children: const [
            //_MinimalTextBox(hint: "Müşteri Cari No"),
            SizedBox(height: 12),
            //_MinimalTextBox(hint: "Yeni Cari Adı"),
            SizedBox(height: 12),
            //_MinimalTextBox(hint: "Yeni Vergi No"),
          ],
        );
    }
  }
}

class LicencePanel extends StatelessWidget {
  const LicencePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return _PanelContainer(
      title: "lisanslar",
      child: Center(
        child: Text(
          "Lisans CRUD\nADMIN / SUPERVISOR / WORKER",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Colors.black.withAlpha(150),
          ),
        ),
      ),
    );
  }
}

class PermissionsPanel extends StatelessWidget {
  const PermissionsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return _PanelContainer(
      title: "İzinler",
      child: Center(
        child: Text(
          "Permission list\nSTOCK_VIEW\nREPORT_VIEW\nWORKORDER_VIEW",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Colors.black.withAlpha(150),
          ),
        ),
      ),
    );
  }
}

class RolePermissionsPanel extends StatelessWidget {
  const RolePermissionsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return _PanelContainer(
      title: "Kullanıcı - Yetki İlişkilendirme",
      child: Center(
        child: Text(
          "Checkbox matrix\nRole × Permission",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Colors.black.withAlpha(150),
          ),
        ),
      ),
    );
  }
}

class MikroApiPanel extends StatelessWidget {
  const MikroApiPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return _PanelContainer(
      title: "Mikro API Ayarlar",
      child: Center(
        child: Text(
          "Mikro API credentials\n• api_key\n• firma_no\n• sube_no\n(masked)",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Colors.black.withAlpha(150),
          ),
        ),
      ),
    );
  }
}

class SettingsPanel extends StatelessWidget {
  const SettingsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return _PanelContainer(
      title: "Ayarlar",
      child: Center(
        child: Text(
          "Ayarlar\nAdres / İletişim / MERSİS",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Colors.black.withAlpha(150),
          ),
        ),
      ),
    );
  }
}

class _MinimalTextBox extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  const _MinimalTextBox({
    required this.hint,
    required this.controller,
    this.inputFormatters,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.25)),
          ),
        ),
      ),
    );
  }
}
