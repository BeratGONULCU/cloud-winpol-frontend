import 'package:cloud_winpol_frontend/models/customer_action.dart';
import 'package:cloud_winpol_frontend/service/company_service.dart';
import 'package:cloud_winpol_frontend/service/tenant_auth_service.dart';
import 'package:cloud_winpol_frontend/widgets/buttons/panelActionBar.dart';
import 'package:cloud_winpol_frontend/widgets/buttons/submit_button.dart';
import 'package:cloud_winpol_frontend/widgets/navigation/admin_app_draver.dart';
import 'package:cloud_winpol_frontend/widgets/theme/AdminMainScaffold.dart';
import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/screens/settings/settings_screen.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:cloud_winpol_frontend/widgets/theme/admin_tab.dart';
import 'dart:ui';

import 'package:flutter/services.dart';

class AdminMainWebScreen extends StatefulWidget {
  const AdminMainWebScreen({super.key});

  @override
  State<AdminMainWebScreen> createState() => _AdminMainWebScreenState();
}

class _AdminMainWebScreenState extends State<AdminMainWebScreen> {
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
          if (_scaffoldKey.currentState != null) {
            _scaffoldKey.currentState!.openDrawer();
          }
        },
        onSettings: () =>
            Navigator.pushNamed(context, SettingsScreen.routeName),
      ),
      body: AdminMainScaffold(
        toolbarBottom: false,
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

    final isCompact = width < 600; // 📱 telefon breakpoint
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

  // ================= STATE =================
  String? _lastFetchedVergiNo;
  bool _loadingFirm = false;

  // ================= CONTROLLERS =================
  final _taxNoController = TextEditingController();
  final _TCNoController = TextEditingController();
  final _nameController = TextEditingController();
  final _companyCodeController = TextEditingController();

  final _editTaxNoController = TextEditingController();
  final _editUnvan1Controller = TextEditingController();
  final _editUnvan2Controller = TextEditingController();
  final _editTcController = TextEditingController();
  final _editVergiDaireController = TextEditingController();
  final _editWebsiteController = TextEditingController();

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
    _editUnvan1Controller.dispose();
    _editUnvan2Controller.dispose();
    _editTcController.dispose();
    _editVergiDaireController.dispose();
    _editWebsiteController.dispose();
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
        _editUnvan1Controller.text = firm["firma_unvan"] ?? "";
        _editUnvan2Controller.text = firm["firma_unvan2"] ?? "";
        _editTcController.text = firm["firma_TCkimlik"] ?? "";
        _editVergiDaireController.text = firm["firma_FVergiDaire"] ?? "";
        _editWebsiteController.text = firm["firma_web_sayfasi"] ?? "";
      });
    } catch (e) {
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
    final isWeb = MediaQuery.of(context).size.width > 900;

    return Center(
      child: Container(
        width: isWeb ? 760 : 360,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Müşteri Yönetimi",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              action == CustomerAction.create
                  ? "Yeni müşteri kaydı oluşturun"
                  : "Mevcut müşteri bilgilerini güncelleyin",
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            CustomerActionBar(
              selected: action,
              onChanged: (a) => setState(() => action = a),
            ),

            const SizedBox(height: 24),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              child: action == CustomerAction.create
                  ? _createForm(isWeb)
                  : _editForm(isWeb),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CREATE FORM =================
  Widget _createForm(bool isWeb) {
    return _formWrapper(
      isWeb,
      [
        _input("Vergi No", _taxNoController, digits: 10),
        _input("TC Numarası", _TCNoController, digits: 11),
        _input("Cari Adı", _nameController),
        _input("Şirket Kodu", _companyCodeController),
      ],
      SubmitButton(
        label: "Müşteri Oluştur",
        onPressed: () async {
          final vergiNo = _taxNoController.text.trim();
          final tcNo = _TCNoController.text.trim();
          final cariAdi = _nameController.text.trim();
          final companyCode = _companyCodeController.text.trim();

          if (vergiNo.length != 10 || cariAdi.isEmpty || companyCode.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Zorunlu alanları doldurun")),
            );
            return;
          }

          try {
            // -------------------------------------------------
            // companies içinde VAR MI?
            // -------------------------------------------------
            bool companyExists = false;

            try {
              await CompanyService.getCustomerById(vergi_no: vergiNo);
              companyExists = true;
            } catch (_) {
              companyExists = false; // yok → NORMAL
            }

            // -------------------------------------------------
            // YOKSA → companies kaydı oluştur
            // -------------------------------------------------
            if (!companyExists) {
              await CompanyService.createCustomer(
                vergiNo: vergiNo,
                cariAdi: cariAdi,
                companyCode: companyCode,
              );
            }

            // -------------------------------------------------
            // tenant firm HER DURUMDA oluştur
            // -------------------------------------------------
            await TenantAuthService.createTenantFirm(
              cariAdi: cariAdi,
              tc_no: tcNo.isNotEmpty ? tcNo : "",
              vergiNo: tcNo.isEmpty ? vergiNo : "",
            );

            // -------------------------------------------------
            // BAŞARILI
            // -------------------------------------------------
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  companyExists
                      ? "Mevcut şirket için tenant kaydı oluşturuldu"
                      : "Yeni şirket ve tenant kaydı oluşturuldu",
                ),
              ),
            );

            _taxNoController.clear();
            _TCNoController.clear();
            _nameController.clear();
            _companyCodeController.clear();
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("İşlem başarısız: $e")));
          }
        },
      ),
    ); // burada
  }

  // ================= EDIT FORM =================
  Widget _editForm(bool isWeb) {
    return Column(
      children: [
        if (_loadingFirm)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: LinearProgressIndicator(minHeight: 2),
          ),
        _formWrapper(isWeb, [
          _input("Vergi No", _editTaxNoController, digits: 10),
          _input("Cari Ünvan", _editUnvan1Controller),
          _input("Cari Ünvan 2", _editUnvan2Controller),
          _input("TC Kimlik No", _editTcController, digits: 11),
          _input("Vergi Dairesi", _editVergiDaireController),
          _input("Website", _editWebsiteController),
        ], SubmitButton(label: "Müşteri Güncelle", onPressed: () {})),
      ],
    );
  }

  // ================= FORM HELPERS =================
  Widget _formWrapper(bool isWeb, List<Widget> inputs, Widget button) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 24 : 16),
      child: Column(
        children: [
          Wrap(
            spacing: 18,
            runSpacing: 14,
            children: inputs
                .map(
                  (e) =>
                      SizedBox(width: isWeb ? 320 : double.infinity, child: e),
                )
                .toList(),
          ),
          const SizedBox(height: 28),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(width: 200, height: 50, child: button),
          ),
        ],
      ),
    );
  }

  Widget _input(String label, TextEditingController c, {int? digits}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 6),
        TextField(
          controller: c,
          keyboardType: digits != null ? TextInputType.number : null,
          inputFormatters: digits != null
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(digits),
                ]
              : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.black12),
            ),
          ),
        ),
      ],
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

  const _MinimalTextBox({required this.hint});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: TextField(
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
