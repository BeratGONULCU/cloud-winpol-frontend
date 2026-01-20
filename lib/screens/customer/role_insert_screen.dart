import 'dart:ui';
import 'package:cloud_winpol_frontend/models/role_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_winpol_frontend/models/customer_action.dart';
import 'package:cloud_winpol_frontend/models/user_summary.dart';
import 'package:cloud_winpol_frontend/service/company_service.dart';

import 'package:cloud_winpol_frontend/widgets/navigation/customer_app_draver.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:cloud_winpol_frontend/widgets/forms/winpol_form_panel.dart';
import 'package:cloud_winpol_frontend/widgets/buttons/panelActionBar.dart';
import 'package:cloud_winpol_frontend/widgets/buttons/submit_button.dart';

import 'package:cloud_winpol_frontend/screens/settings/settings_screen.dart';

class RoleInsertScreen extends StatefulWidget {
  static const String routeName = '/roleInsertWeb';
  const RoleInsertScreen({super.key});

  @override
  State<RoleInsertScreen> createState() => _RoleInsertWebScreenState();
}

class _RoleInsertWebScreenState extends State<RoleInsertScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isMobile(BuildContext c) => MediaQuery.of(c).size.width < 768;
  int _selectedIndex = 0;

  Widget _mobileLayout() =>
      const Padding(padding: EdgeInsets.all(16), child: CustomerPanel());

  Widget _webLayout() =>
      const Padding(padding: EdgeInsets.all(24), child: CustomerPanel());

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    return Scaffold(
      backgroundColor: AppColors.body,
      key: _scaffoldKey,
      drawer: const CustomerAppDrawer(),
      appBar: WinpolHeader(
        title: "",
        showLogo: false,
        onBack: null,
        onMenu: () => _scaffoldKey.currentState?.openDrawer(),
        onSettings: () =>
            Navigator.pushNamed(context, SettingsScreen.routeName),
      ),
      body: mobile ? _mobileLayout() : _webLayout(),
    );
  }
}

// ============================================================================
// CUSTOMER PANEL (USER CREATE / EDIT)
// ============================================================================

class CustomerPanel extends StatefulWidget {
  const CustomerPanel({super.key});
  @override
  State<CustomerPanel> createState() => _CustomerPanelState();
}

class _CustomerPanelState extends State<CustomerPanel> {
  CustomerAction action = CustomerAction.create;
  bool isPassive = false;

  // ================= STATE =================
  //UserSummary? selectedUser;
  String? selectedRoleId;
  RoleSummary? selectedRole;

  bool loadingUsers = false;
  bool submitting = false;

  List<RoleSummary> roles = [];
  Set<String> selectedRoleIds = {};
  bool loadingRoles = false;

  // ================= CONTROLLERS =================
  final _roleNameController = TextEditingController();
  final _DescriptionController = TextEditingController();
  
  get _updateRole => null; // bu silinecek

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    setState(() => loadingRoles = true);
    try {
      roles = await CompanyService.getAllRoles();
    } finally {
      setState(() => loadingRoles = false);
    }
  }

  @override
  void dispose() {
    _roleNameController.dispose();    
    _DescriptionController.dispose(); 
    super.dispose();
  }

  void _fillFromRole(RoleSummary u) {
    _roleNameController.text = u.name ?? "";
    _DescriptionController.text = u.description ?? "";
  }

  Widget _passiveCheckbox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isPassive,
            activeColor: Colors.redAccent,
            onChanged: (v) => setState(() => isPassive = v ?? false),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text("Kullanıcı pasif mi?", style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  // ================= USER PICKER FUNCTION =================
  void _openUserPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final TextEditingController searchCtrl = TextEditingController();
        List<RoleSummary> filtered = List.from(roles);

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),

                  // SEARCH
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: searchCtrl,
                      decoration: const InputDecoration(
                        hintText: "Kullanıcı ara...",
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (v) {
                        setModalState(() {
                          filtered = roles
                              .where(
                                (u) =>
                                    u.name.toLowerCase().contains(
                                      v.toLowerCase(),
                                    ) ||
                                    (u.description ?? "").toLowerCase().contains(
                                      v.toLowerCase(),
                                    ),
                              )
                              .toList();
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // LIST
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final u = filtered[i];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(u.name[0].toUpperCase()),
                          ),
                          title: Text(u.name),
                          subtitle: u.description != null
                              ? Text(u.description!)
                              : null,
                          onTap: () {
                            setState(() {
                              selectedRole = u;
                              selectedRoleId = u.id;
                              _fillFromRole(u);
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ================= LOAD USERS =================


  // ================= CREATE ROLE =================
  Future<void> _createRole() async {
    setState(() => submitting = true);
    try {
      await CompanyService.createRole(
        name: _roleNameController.text.trim(),
        description: _DescriptionController.text.trim(),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Kullanıcı oluşturuldu")));

      _clearForm();
    } finally {
      setState(() => submitting = false);
    }
  }

  // ================= UPDATE ROLE =================



  void _clearForm() {
    _roleNameController.clear();
    _DescriptionController.clear();
    isPassive = false;
    selectedRoleIds.clear();
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 900;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: WinpolFormPanel(
        title: "Yetki Yönetimi",
        subtitle: action == CustomerAction.create
            ? "Yeni yetki oluştur"
            : "Yetki bilgilerini güncelle",
        children: [
          CustomerActionBar(
            selected: action,
            onChanged: (a) {
              setState(() {
                action = a;
                selectedRole = null;
                _clearForm();
              });
            },
          ),
          const SizedBox(height: 24),
          if (action == CustomerAction.edit) _roleSelector(),
          _form(isWeb),
        ],
      ),
    );
  }

  // ================= ROLE SELECTOR =================
  Widget _roleSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openUserPicker(),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: "Kullanıcı Seç",
            prefixIcon: const Icon(Icons.person_outline),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            selectedRole?.name ?? "Yetki seçin",
            style: TextStyle(
              color: selectedRole == null ? Colors.black54 : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _wrapItem(bool isWeb, Widget child) {
    return SizedBox(width: isWeb ? 320 : double.infinity, child: child);
  }

  Widget _roleDropdown() {
    if (loadingRoles) {
      return const LinearProgressIndicator();
    }

    return DropdownButtonFormField<String>(
      value: selectedRoleIds.isNotEmpty ? selectedRoleIds.first : null,
      decoration: const InputDecoration(
        labelText: "Rol",
        filled: true,
        fillColor: Color(0xFFF9FAFB),
        border: OutlineInputBorder(),
      ),
      items: roles
          .map((r) => DropdownMenuItem(value: r.id, child: Text(r.name)))
          .toList(),
      onChanged: (v) {
        setState(() {
          selectedRoleIds = v != null ? {v} : {};
        });
      },
    );
  }

  // ================= FORM =================
  Widget _form(bool isWeb) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 24 : 16),
      child: Column(
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 14,
            children: [
              _wrapItem(
                isWeb,
                modernInput(label: "Yetki adı:", controller: _roleNameController),
              ),
              _wrapItem(
                isWeb,
                modernInput(label: "Açıklama", controller: _DescriptionController),
              ),

              //_wrapItem(isWeb, _passiveCheckbox()),

              //_wrapItem(isWeb, _roleDropdown()),
            ],
          ),
          const SizedBox(height: 28),

          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 220,
              height: 48,
              child: SubmitButton(
                //loading: submitting,
                label: action == CustomerAction.create
                    ? "Kullanıcı Oluştur"
                    : "Yetki Güncelle",
                onPressed: action == CustomerAction.create
                    ? _createRole
                    : _updateRole,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PLACEHOLDER PANELS (AYNEN KALDI)
// ============================================================================

Widget modernInput({
  required String label,
  required TextEditingController controller,
  bool obscure = false,
  int? digits,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF6B7280),
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: digits != null ? TextInputType.number : null,
        inputFormatters: digits != null
            ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(digits),
              ]
            : null,
        style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF9CA3AF)),
          ),
        ),
      ),
    ],
  );
}
