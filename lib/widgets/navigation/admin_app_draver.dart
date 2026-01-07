import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AdminAppDrawer extends StatelessWidget {
  const AdminAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final String? currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(12),
          physics: const BouncingScrollPhysics(), // iOS uyum
          children: [
            const _DrawerHeader(),
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
            _drawerItemWithDivider2(
              DrawerSection(
                title: "Müşteri Listesi",
                icon: Icons.receipt_long,
                children: [
                  _drawerItemWithDivider(
                    DrawerItem(
                      title: "Müşteri İşlemleri",
                      icon: Icons.people_outline,
                      isActive: currentRoute == "/adminMain",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/adminMain");
                      },
                    ),
                  ),
                  _drawerItemWithDivider(
                    DrawerItem(
                      title: "Müşteriler",
                      icon: Icons.badge_outlined,
                      isActive: currentRoute == "/customerList",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/customerList");
                      },
                    ),
                  ),
                  _drawerItemWithDivider(
                    DrawerItem(
                      title: "Müşteri Çalışanları",
                      icon: Icons.groups_outlined,
                      isActive: currentRoute == "/customerWorkers",
                    ),
                  ),
                  _drawerItemWithDivider(
                    DrawerItem(
                      title: "Müşteri Lisansları",
                      icon: Icons.key_outlined,
                      isActive: currentRoute == "/customerLicences",
                    ),
                  ),
                ],
              ),
            ),

            _drawerItemWithDivider2(
              DrawerSection(
                title: "Lisanslar",
                icon: Icons.local_shipping,
                children: [
                  _drawerItemWithDivider(
                    DrawerItem(
                      title: "Lisans Listesi",
                      icon: Icons.list_alt,
                      isActive: currentRoute == "/licenceList",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/licenceList");
                      },
                    ),
                  ),
                  _drawerItemWithDivider(
                    DrawerItem(
                      title: "Bitmek Üzere Olanlar",
                      icon: Icons.warning_amber_rounded,
                      isActive: currentRoute == "/licenceExpiring",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/licenceExpiring");
                      },
                    ),
                  ),
                ],
              ),
            ),

            _drawerItemWithDivider2(
              DrawerSection(
                title: "Mikro API Ayarları",
                icon: Icons.inventory_2,
                children: [
                  _drawerItemWithDivider(
                    DrawerItem(
                      title: "Stok Kartları",
                      icon: Icons.inventory_outlined,
                      isActive: currentRoute == "/mikroStocks",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/mikroStocks");
                      },
                    ),
                  ),
                  _drawerItemWithDivider(
                    DrawerItem(
                      title: "Depolar",
                      icon: Icons.warehouse_outlined,
                      isActive: currentRoute == "/mikroWarehouses",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/mikroWarehouses");
                      },
                    ),
                  ),
                  _drawerItemWithDivider(
                    DrawerItem(
                      title: "Stok Hareketleri",
                      icon: Icons.swap_horiz,
                      isActive: currentRoute == "/mikroStockMovements",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/mikroStockMovements");
                      },
                    ),
                  ),
                ],
              ),
            ),

            _drawerItemWithDivider2(
              DrawerSection(
                title: "Ayarlar (Yönetim)",
                icon: Icons.settings,
                children: [
                  _drawerItemWithDivider(
                    DrawerItem(
                      title: "Kullanıcılar",
                      icon: Icons.person_outline,
                      isActive: currentRoute == "/users",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/users");
                      },
                    ),
                  ),
                  _drawerItemWithDivider(
                    DrawerItem(
                      title: "Yetkiler",
                      icon: Icons.security_outlined,
                      isActive: currentRoute == "/roles",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/roles");
                      },
                    ),
                  ),
                  _drawerItemWithDivider(
                    DrawerItem(
                      title: "İzinler",
                      icon: Icons.verified_user_outlined,
                      isActive: currentRoute == "/permissions",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/permissions");
                      },
                    ),
                  ),
                  _drawerItemWithDivider(
                    DrawerItem(
                      title: "Kullanıcı - Yetki ilişkilendirme",
                      icon: Icons.account_tree_outlined,
                      isActive: currentRoute == "/rolePermissions",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/rolePermissions");
                      },
                    ),
                  ),
                  _drawerItemWithDivider(
                    DrawerItem(
                      title: "Şubeler",
                      icon: Icons.apartment_outlined,
                      isActive: currentRoute == "/branches",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/branches");
                      },
                    ),
                  ),
                  _drawerItemWithDivider(
                    DrawerItem(
                      title: "Mikro API",
                      icon: Icons.api_outlined,
                      isActive: currentRoute == "/mikroApi",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/mikroApi");
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LOGO
          Row(
            children: [
              Image.asset("assets/images/winpol_logo.png", height: 36),
              const SizedBox(width: 10),
              const Text(
                "",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
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

class DrawerSection extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const DrawerSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  State<DrawerSection> createState() => _DrawerSectionState();
}

class _DrawerSectionState extends State<DrawerSection>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _expanded
                ? Colors.black.withOpacity(0.04)
                : Colors.transparent,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _expanded = !_expanded),
            child: ListTile(
              dense: true,
              leading: Icon(widget.icon),
              title: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -0.25,
                  color: Colors.black.withOpacity(0.78),
                ),
              ),
              trailing: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            ),
          ),
        ),

        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(children: widget.children),
                  )
                : const SizedBox(height: 0),
          ),
        ),
      ],
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool isActive;
  final VoidCallback? onTap;
  final TextStyle? titleStyle;

  const DrawerItem({
    super.key,
    required this.title,
    this.icon,
    this.isActive = false,
    this.onTap,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),

      tileColor: isActive ? AppColors.primary.withOpacity(0.06) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      leading: icon != null
          ? Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Icon(icon, size: 20),
            )
          : const SizedBox(width: 26),

      title: Text(
        title,
        style:
            titleStyle ??
            TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.2,
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
        Padding(
          padding: const EdgeInsets.only(left: 52), // icon hizası
          child: Divider(height: 1, thickness: 0.6, color: Colors.black12),
        ),
    ],
  );
}

Widget _drawerItemWithDivider2(Widget child, {bool showDivider = true}) {
  return Column(
    children: [
      child,
      if (showDivider)
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 27), // icon hizası
          child: Divider(height: 1, thickness: 0.6, color: Colors.black12),
        ),
    ],
  );
}
