import 'package:cloud_winpol_frontend/models/customer_action.dart';
import 'package:cloud_winpol_frontend/widgets/navigation/admin_app_draver.dart';
import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/screens/settings/settings_screen.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:cloud_winpol_frontend/widgets/buttons/panelActionBar.dart';
import 'package:cloud_winpol_frontend/service/company_service.dart';
import 'package:cloud_winpol_frontend/widgets/buttons/submit_button.dart';
import 'package:flutter/cupertino.dart';
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

  bool isValidWebsite(String value) {
    final uri = Uri.tryParse(value);
    return uri != null &&
        (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https')) &&
        uri.host.isNotEmpty;
  }

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

  // create değişkenleri
  final _taxNoController = TextEditingController();
  final _nameController = TextEditingController();
  final _companyCodeController = TextEditingController();

  // edit değişkenleri
  final _editTaxNoController = TextEditingController();
  // bu controller ile hem ilgili veritabanına bağlanılacak , veri varsa update yoksa insert yapılacak.
  // bunu bir fonksiyon ile kontrol edebiliriz?
  final _editCariUnvanController = TextEditingController();
  final _editCariUnvanController2 = TextEditingController(); // unvan2 için
  final _editCariTCNOController = TextEditingController();
  final _editVergiDaireController = TextEditingController();
  final _editWebSiteController = TextEditingController();

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

  void _submitEdit() {
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
            onChanged: (a) {
              HapticFeedback.selectionClick();
              setState(() => action = a);
            },
          ),

          const SizedBox(height: 18),

          // FORM ALANI
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 320),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                final slideAnimation = Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(animation);

                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: child,
                  ),
                );
              },
              child: _buildForm(),
            ),
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
            SizedBox(
              width: 280,
              child: CupertinoTextField(
                controller: _taxNoController,
                placeholder: "Vergi No",
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color.fromARGB(255, 195, 195, 195),
                    width: 1,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),
            SizedBox(
              width: 280,
              child: CupertinoTextField(
                controller: _nameController,
                placeholder: "Cari Adı",
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 253, 253),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color.fromARGB(255, 195, 195, 195),
                    width: 1,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),
            SizedBox(
              width: 280,
              child: CupertinoTextField(
                controller: _companyCodeController,
                placeholder: "Şirket Kodu",
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 253, 253),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color.fromARGB(255, 195, 195, 195),
                    width: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: 200,
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 14),
                borderRadius: BorderRadius.circular(14),
                color: AppColors.primary, // Winpol ana rengi
                onPressed: _submitCreate,
                child: const Text(
                  "Müşteri Oluştur",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.white,
                  ),
                ),
              ),
            ),
          ],
        );

      /* 
        frontend içerisinde update edildiğinde yapılacak kontroller;
        - tüm veriler tutarlı mı? 
        - vergiNo ve tcNo aynı anda girilemez. ama illa ki biri olması gerekiyor. 
        - cariUnvan,vergi dairesi required
       */

      /*
                  SizedBox(
              width: 280,
              child: CupertinoTextField(
                controller: _companyCodeController,
                placeholder: "Şirket Kodu",
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 253, 253),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color.fromARGB(255, 195, 195, 195),
                    width: 1,
                  ),
                ),
              ),
            ),
      
       */

      case CustomerAction.edit:
        return Column(
          key: const ValueKey("edit"),
          children: [
            SizedBox(
              width: 280,
              child: CupertinoTextField(
                controller: _editTaxNoController,
                placeholder: "Vergi No",
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color.fromARGB(255, 195, 195, 195),
                    width: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 280,
              child: CupertinoTextField(
                controller: _editCariUnvanController,
                placeholder: "Cari Unvan",
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 253, 253),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color.fromARGB(255, 195, 195, 195),
                    width: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),

            SizedBox(
              width: 280,
              child: CupertinoTextField(
                controller: _editCariUnvanController2,
                placeholder: "Cari Unvan 2",
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 253, 253),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color.fromARGB(255, 195, 195, 195),
                    width: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),

            SizedBox(
              width: 280,
              child: CupertinoTextField(
                controller: _editCariTCNOController,
                placeholder: "Müşteri TC Numarası",
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color.fromARGB(255, 195, 195, 195),
                    width: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 280,
              child: CupertinoTextField(
                controller: _editVergiDaireController,
                placeholder: "Cari Vergi Dairesi",
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 253, 253),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color.fromARGB(255, 195, 195, 195),
                    width: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 280,
              child: CupertinoTextField(
                controller: _editWebSiteController,
                placeholder: "Cari Website",
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 253, 253),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color.fromARGB(255, 195, 195, 195),
                    width: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 200,
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 14),
                borderRadius: BorderRadius.circular(14),
                color: AppColors.primary, // Winpol ana rengi
                onPressed:
                    _submitEdit, // --> burada submitUpdate ve kontroller yapılacak
                child: const Text(
                  "Müşteri Güncelle",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.white,
                  ),
                ),
              ),
            ),
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
