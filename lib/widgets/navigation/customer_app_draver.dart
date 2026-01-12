import 'package:cloud_winpol_frontend/screens/old/customer_login_web.dart';
import 'package:cloud_winpol_frontend/service/tenant_auth_service.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomerAppDrawer extends StatefulWidget {
  const CustomerAppDrawer({super.key});

  @override
  State<CustomerAppDrawer> createState() => _CustomerAppDrawerState();
}

class _CustomerAppDrawerState extends State<CustomerAppDrawer> {
  bool usersExpanded = false;
  bool branchesExpanded = false;
  bool mikroExpanded = false;
  bool settingsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final String? currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // ================== MENU ==================
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                physics: const BouncingScrollPhysics(),
                children: [
                  const _DrawerHeader(),

                  // ================= ANA SAYFA =================
                  _drawerItemWithDivider2(
                    DrawerItem(
                      title: "Ana Sayfa",
                      icon: Icons.home_rounded,
                      isActive: currentRoute == "/homeScreen",
                      titleStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w200,
                        letterSpacing: -0.4,
                        color: AppColors.primary,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          "/homeScreen",
                          (route) => false,
                        );
                      },
                    ),
                  ),

                  // ================= KULLANICILAR =================
                  _drawerItemWithDivider2(
                    DrawerSection(
                      title: "Fatura",
                      icon: Icons.people,
                      onExpandedChanged: (v) =>
                          setState(() => usersExpanded = v),
                      children: [
                        _drawerItemWithDivider(
                          DrawerItem(
                            title: "Kullanıcı Listesi",
                            icon: Icons.people_outline,
                            indent: 28,
                            isActive: currentRoute == "/userList",
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, "/userList");
                            },
                          ),
                        ),
                        _drawerItemWithDivider(
                          DrawerItem(
                            title: "Kullanıcı İşlemleri",
                            icon: Icons.badge_outlined,
                            indent: 28,
                            isActive: currentRoute == "/customerList",
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, "/customerList");
                            },
                          ),
                        ),
                        _drawerItemWithDivider(
                          DrawerItem(
                            title: "Kullanıcı Raporları",
                            icon: Icons.groups_outlined,
                            indent: 28,
                          ),
                        ),
                        _drawerItemWithDivider(
                          DrawerItem(
                            title: "Kullanıcı Loglar",
                            icon: Icons.key_outlined,
                            indent: 28,
                          ),
                          showDivider: false,
                        ),
                      ],
                    ),
                    showDivider: !usersExpanded,
                  ),

                  // ================= ŞUBELER =================
                  _drawerItemWithDivider2(
                    DrawerSection(
                      title: "Ürünler",
                      icon: Icons.local_shipping,
                      onExpandedChanged: (v) =>
                          setState(() => branchesExpanded = v),
                      children: [
                        _drawerItemWithDivider(
                          DrawerItem(
                            title: "Şube Listesi",
                            icon: Icons.list_alt,
                            indent: 28,
                            isActive: currentRoute == "/branchList",
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, "/branchList");
                            },
                          ),
                        ),
                        _drawerItemWithDivider(
                          DrawerItem(
                            title: "Depolar",
                            icon: Icons.warehouse_outlined,
                            indent: 28,
                          ),
                          showDivider: false,
                        ),
                      ],
                    ),
                    showDivider: !branchesExpanded,
                  ),

                  // ================= DEPOLAR =================
                  _drawerItemWithDivider2(
                    DrawerSection(
                      title: "Depolar",
                      icon: Icons.local_shipping,
                      onExpandedChanged: (v) =>
                          setState(() => branchesExpanded = v),
                      children: [
                        _drawerItemWithDivider(
                          DrawerItem(
                            title: "Şube Listesi",
                            icon: Icons.list_alt,
                            indent: 28,
                            isActive: currentRoute == "/branchList",
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, "/branchList");
                            },
                          ),
                        ),
                        _drawerItemWithDivider(
                          DrawerItem(
                            title: "Depolar",
                            icon: Icons.warehouse_outlined,
                            indent: 28,
                          ),
                          showDivider: false,
                        ),
                      ],
                    ),
                    showDivider: !branchesExpanded,
                  ),
                  // ================= AYARLAR =================
                  _drawerItemWithDivider(
                    DrawerSection(
                      title: "Ayarlar (Yönetim)",
                      icon: Icons.settings,
                      onExpandedChanged: (v) =>
                          setState(() => settingsExpanded = v),
                      children: [
                        // ===== KULLANICILAR (ALT SECTION) =====
                        DrawerSection(
                          title: "Kullanıcılar",
                          icon: Icons.people,
                          indent: 12,
                          children: [
                            _drawerItemWithDivider(
                              DrawerItem(
                                title: "Kullanıcı Listesi",
                                icon: Icons.people_outline,
                                indent: 28,
                                isActive: currentRoute == "/userList",
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, "/userList");
                                },
                              ),
                            ),
                            _drawerItemWithDivider(
                              DrawerItem(
                                title: "Kullanıcı İşlemleri",
                                icon: Icons.badge_outlined,
                                indent: 28,
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, "/customerList");
                                },
                              ),
                            ),
                            _drawerItemWithDivider(
                              DrawerItem(
                                title: "Kullanıcı Raporları",
                                icon: Icons.groups_outlined,
                                indent: 28,
                              ),
                            ),
                            _drawerItemWithDivider(
                              DrawerItem(
                                title: "Kullanıcı Loglar",
                                icon: Icons.key_outlined,
                                indent: 28,
                              ),
                              showDivider: false,
                            ),
                          ],
                        ),

                        // ===== ŞUBELER (ALT SECTION) =====
                        DrawerSection(
                          title: "Şubeler",
                          icon: Icons.local_shipping,
                          indent: 12,
                          children: [
                            _drawerItemWithDivider(
                              DrawerItem(
                                title: "Şube Listesi",
                                icon: Icons.list_alt,
                                indent: 28,
                                isActive: currentRoute == "/branchList",
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, "/branchList");
                                },
                              ),
                            ),
                            _drawerItemWithDivider(
                              DrawerItem(
                                title: "Depolar",
                                icon: Icons.warehouse_outlined,
                                indent: 28,
                              ),
                              showDivider: false,
                            ),
                          ],
                        ),

                        // ===== DİĞER AYARLAR =====
                        _drawerItemWithDivider(
                          DrawerItem(
                            title: "Firma",
                            icon: Icons.business,
                            indent: 28,
                          ),
                        ),
                        _drawerItemWithDivider(
                          DrawerItem(
                            title: "Şubeler",
                            icon: Icons.apartment,
                            indent: 28,
                          ),
                        ),
                        _drawerItemWithDivider(
                          DrawerItem(
                            title: "Depolar",
                            icon: Icons.warehouse,
                            indent: 28,
                          ),
                        ),
                        _drawerItemWithDivider(
                          DrawerItem(
                            title: "Kullanıcı",
                            icon: Icons.supervised_user_circle,
                            indent: 28,
                          ),
                        ),
                        _drawerItemWithDivider(
                          DrawerItem(
                            title: "Mikro API",
                            icon: Icons.api,
                            indent: 28,
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, "/mikroApi");
                            },
                          ),
                          showDivider: false,
                        ),
                      ],
                    ),
                    showDivider: !settingsExpanded,
                  ),
                ],
              ),
            ),

            // ================= LOGOUT BUTTON =================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: _logoutButton(context),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= LOGOUT BUTTON =================
Widget _logoutButton(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    height: 48,
    child: ElevatedButton.icon(
      icon: const Icon(Icons.logout, size: 20),
      label: const Text(
        "Çıkış Yap",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onPressed: () async {
        Navigator.pop(context); // drawer kapat

        try {
          // BACKEND LOGOUT + TOKEN CLEAR
          await TenantAuthService.logout();

          // 🔁 LOGIN'E DÖN (STACK TEMİZ)
          Navigator.pushNamedAndRemoveUntil(
            context,
            CustomerLoginScreen.routeName,
            (route) => false,
          );
        } catch (e) {
          // İstersen burada pop/snackbar basarsın
          debugPrint("LOGOUT ERROR: $e");

          Navigator.pushNamedAndRemoveUntil(
            context,
            CustomerLoginScreen.routeName,
            (route) => false,
          );
        }
      },
    ),
  );
}

// ================= HEADER =================

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset("assets/images/winpol_logo.png", height: 36),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Modüller",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(0.55),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
        ],
      ),
    );
  }
}

// ================= SECTION =================

class DrawerSection extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final ValueChanged<bool>? onExpandedChanged;
  final double indent;

  const DrawerSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.onExpandedChanged,
    this.indent = 0,
  });

  @override
  State<DrawerSection> createState() => _DrawerSectionState();
}

class _DrawerSectionState extends State<DrawerSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.fromLTRB(
            14 + widget.indent, 
            2,
            14,
            2,
          ),
          leading: Icon(widget.icon),
          title: Text(
            widget.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w200,
              letterSpacing: -0.25,
              color: Colors.black.withOpacity(0.78),
            ),
          ),
          trailing: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
          onTap: () {
            setState(() => _expanded = !_expanded);
            widget.onExpandedChanged?.call(_expanded);
          },
        ),

        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: _expanded
              ? Column(children: widget.children)
              : const SizedBox(),
        ),
      ],
    );
  }
}

// ================= ITEM & DIVIDER =================
// bu yapıya isFavorite kolonu eklenecek , bu eklenen kolon ile customer_home_screen.dart ekranında kontrol edilerek sekmeler getirilicek?
// (mobilde sharedPreferences ile kontrol edilebilir ama webde hangi kullanıcının neyi favorilediğini nasıl kontrol edicez? veritabanına kolon mu eklesek?)
// favorites diye her 1'e 1 ilişki olur

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool isActive;
  final VoidCallback? onTap;
  final TextStyle? titleStyle;
  final double indent;

  const DrawerItem({
    super.key,
    required this.title,
    this.icon,
    this.isActive = false,
    this.onTap,
    this.titleStyle,
    this.indent = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.fromLTRB(14 + indent, 2, 14, 2),
      tileColor: isActive ? AppColors.primary.withOpacity(0.06) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: icon != null ? Icon(icon, size: 20) : const SizedBox(width: 20),
      title: Text(
        title,
        style:
            titleStyle ??
            TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isActive ? AppColors.primary : Colors.black87,
            ),
      ),
      onTap: onTap ?? () => Navigator.pop(context),
    );
  }
}

Widget _drawerItemWithDivider(Widget child, {bool showDivider = true}) {
  return Column(
    children: [
      child,
      if (showDivider)
        const Padding(
          padding: EdgeInsets.only(left: 25, right: 24),
          child: Divider(height: 1, thickness: 0.6),
        ),
    ],
  );
}

Widget _drawerItemWithDivider2(Widget child, {bool showDivider = true}) {
  return Column(
    children: [
      child,
      if (showDivider)
        const Padding(
          padding: EdgeInsets.only(left: 12, right: 27),
          child: Divider(height: 1, thickness: 0.6),
        ),
    ],
  );
}

Widget _drawerItemWithDivider3(Widget child, {bool showDivider = true}) {
  return Column(
    children: [
      child,
      if (showDivider)
        const Padding(
          padding: EdgeInsets.only(left: 35, right: 27),
          child: Divider(height: 1, thickness: 0.6),
        ),
    ],
  );
}
