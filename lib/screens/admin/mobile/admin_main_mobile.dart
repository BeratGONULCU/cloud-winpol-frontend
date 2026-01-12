import 'package:cloud_winpol_frontend/models/admin_main_args.dart';
import 'package:cloud_winpol_frontend/models/customer_action.dart';
import 'package:cloud_winpol_frontend/widgets/navigation/admin_app_draver.dart';
import 'package:cloud_winpol_frontend/widgets/theme/AdminMainScaffold.dart';
import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/screens/settings/settings_screen.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:cloud_winpol_frontend/widgets/buttons/panelActionBar.dart';
import 'package:cloud_winpol_frontend/service/company_service.dart';
import 'package:cloud_winpol_frontend/widgets/buttons/submit_button.dart';
import 'package:cloud_winpol_frontend/widgets/theme/admin_tab.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';

import 'package:flutter/services.dart';

class AdminMainMobileScreen extends StatefulWidget {
  const AdminMainMobileScreen({super.key});

  @override
  State<AdminMainMobileScreen> createState() => _AdminMainMobileScreenState();
}

class _AdminMainMobileScreenState extends State<AdminMainMobileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;
  late final List<AdminTab> tabs;

  @override
  void initState() {
    super.initState();

    tabs = const [
      AdminTab("Müşteriler", Icons.people, CustomerPanel()),
      AdminTab("Lisanslar", Icons.security, LicencePanel()),
      AdminTab("Mikro API", Icons.account_tree, MikroApiPanel()),
      AdminTab("Ayarlar", Icons.settings, SettingsPanel()),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments as AdminMainArgs?;

    if (args != null) {
      _selectedIndex = args.tabIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.body, // ← EKLE
      key: _scaffoldKey,
      drawer: const AdminAppDrawer(),
      appBar: WinpolHeader(
        title: "",
        showLogo: false,
        onBack: null,
        onMenu: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scaffoldKey.currentState?.openDrawer();
          });
        },
        onSettings: () =>
            Navigator.pushNamed(context, SettingsScreen.routeName),
      ),
      body: AdminMainScaffold(
        toolbarBottom: true,
        selectedIndex: _selectedIndex,
        onSelect: (i) => setState(() => _selectedIndex = i),
        tabs: tabs,
      ),
    );
  }
}

//
// =======================
// ADMIN TOOLBAR
// =======================
//

class _AdminToolbar extends StatelessWidget {
  final List<AdminTab> tabs;
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
                color: Colors.white.withOpacity(0.75),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.black12),
              ),
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

  // ================= STATE =================
  String? _lastFetchedVergiNo;
  bool _loadingFirm = false;

  // ================= CONTROLLERS =================
  final _taxNoController = TextEditingController();
  final _nameController = TextEditingController();
  final _companyCodeController = TextEditingController();

  final _editTaxNoController = TextEditingController();
  final _editCariUnvanController = TextEditingController();
  final _editCariUnvanController2 = TextEditingController();
  final _editCariTCNOController = TextEditingController();
  final _editVergiDaireController = TextEditingController();
  final _editWebSiteController = TextEditingController();

  // ================= INIT =================
  @override
  void initState() {
    super.initState();
    _editTaxNoController.addListener(_onEditVergiNoChanged);
  }

  @override
  void dispose() {
    _editTaxNoController.removeListener(_onEditVergiNoChanged);

    _taxNoController.dispose();
    _nameController.dispose();
    _companyCodeController.dispose();

    _editTaxNoController.dispose();
    _editCariUnvanController.dispose();
    _editCariUnvanController2.dispose();
    _editCariTCNOController.dispose();
    _editVergiDaireController.dispose();
    _editWebSiteController.dispose();

    super.dispose();
  }

  // ================= LISTENER =================
  void _onEditVergiNoChanged() {
    final vergiNo = _editTaxNoController.text.trim();

    if (vergiNo.length != 10) return;
    if (vergiNo == _lastFetchedVergiNo) return;
    if (_loadingFirm) return;

    _fetchFirmByVergiNo(vergiNo);
  }

  // ================= API CALL =================
  Future<void> _fetchFirmByVergiNo(String vergiNo) async {
    try {
      setState(() => _loadingFirm = true);

      final Map<String, dynamic> firm = await CompanyService.getFirmByVergiNo(
        vergiNo,
      );

      _lastFetchedVergiNo = vergiNo;

      setState(() {
        _editCariUnvanController.text = firm["firma_unvan"] ?? "";
        _editCariUnvanController2.text = firm["firma_unvan2"] ?? "";
        _editCariTCNOController.text = firm["firma_TCkimlik"] ?? "";
        _editVergiDaireController.text = firm["firma_FVergiDaire"] ?? "";
        _editWebSiteController.text = firm["firma_web_sayfasi"] ?? "";
      });
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Firma bulunamadı")));
    } finally {
      setState(() => _loadingFirm = false);
    }
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    return _PanelContainer(
      title: "Müşteri İşlemleri",
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

  // ================= CREATE FORM =================
  Widget _createForm() {
    return Column(
      key: const ValueKey("create"),
      children: [
        _cupertinoInput(
          controller: _taxNoController,
          placeholder: "Vergi No",
          digits: 10,
        ),
        const SizedBox(height: 8),
        _cupertinoInput(controller: _nameController, placeholder: "Cari Adı"),
        const SizedBox(height: 8),
        _cupertinoInput(
          controller: _companyCodeController,
          placeholder: "Şirket Kodu",
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 200,
          child: CupertinoButton(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14),
            onPressed: () {},
            child: const Text(
              "Müşteri Oluştur",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.white, 
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================= EDIT FORM =================
  Widget _editForm() {
    return Column(
      key: const ValueKey("edit"),
      children: [
        if (_loadingFirm)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: LinearProgressIndicator(minHeight: 2),
          ),

        _cupertinoInput(
          controller: _editTaxNoController,
          placeholder: "Vergi No",
          digits: 10,
        ),
        const SizedBox(height: 6),
        _cupertinoInput(
          controller: _editCariUnvanController,
          placeholder: "Cari Ünvan",
        ),
        const SizedBox(height: 6),
        _cupertinoInput(
          controller: _editCariUnvanController2,
          placeholder: "Cari Ünvan 2",
        ),
        const SizedBox(height: 6),
        _cupertinoInput(
          controller: _editCariTCNOController,
          placeholder: "TC Kimlik No",
          digits: 11,
        ),
        const SizedBox(height: 6),
        _cupertinoInput(
          controller: _editVergiDaireController,
          placeholder: "Vergi Dairesi",
        ),
        const SizedBox(height: 6),
        _cupertinoInput(
          controller: _editWebSiteController,
          placeholder: "Website",
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: 200,
          child: CupertinoButton(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14),
            onPressed: () {},
            child: const Text(
              "Müşteri Güncelle",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.white, // ← BUNU EKLE
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================= INPUT HELPER =================
  Widget _cupertinoInput({
    required TextEditingController controller,
    required String placeholder,
    int? digits,
  }) {
    return SizedBox(
      width: 280,
      child: CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        keyboardType: digits != null ? TextInputType.number : null,
        inputFormatters: digits != null
            ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(digits),
              ]
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black26),
        ),
      ),
    );
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
