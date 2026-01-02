import 'package:flutter/material.dart';

class AdminAppDrawer extends StatelessWidget {
  const AdminAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(12),
          physics: const BouncingScrollPhysics(), // iOS uyum
          children: const [
            _DrawerHeader(),

            DrawerSection(
              title: "Müşteri Listesi",
              icon: Icons.receipt_long,
              children: [
                DrawerItem(title: "Müşteriler"),
                DrawerItem(title: "Müşteri Çalışanları"),
                DrawerItem(title: "Müşteri Lisansları"),
              ],
            ),

            DrawerSection(
              title: "Lisanslar",
              icon: Icons.local_shipping,
              children: [
                DrawerItem(title: "Lisans Listesi"),
                DrawerItem(title: "Bitmek Üzere Olanlar"),
              ],
            ),

            DrawerSection(
              title: "Mikro API Ayarları",
              icon: Icons.inventory_2,
              children: [
                DrawerItem(title: "Stok Kartları"),
                DrawerItem(title: "Depolar"),
                DrawerItem(title: "Stok Hareketleri"),
              ],
            ),

            DrawerSection(
              title: "Ayarlar (Yönetim)",
              icon: Icons.settings,
              children: [
                DrawerItem(title: "Kullanıcılar"),
                DrawerItem(title: "Yetkiler"),
                DrawerItem(title: "İzinler"),
                DrawerItem(title: "Kullanıcı - Yetki ilişkilendirme"),
                DrawerItem(title: "Şubeler"),
                DrawerItem(title: "Mikro API"),
              ],
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Winpol",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            "Modüller",
            style: TextStyle(
              fontSize: 13,
              color: Colors.black.withOpacity(0.55),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(),
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
        ListTile(
          dense: true,
          leading: Icon(widget.icon),
          title: Text(widget.title),
          trailing: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
          onTap: () => setState(() => _expanded = !_expanded),
        ),

        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: _expanded
                ? Column(children: widget.children)
                : const SizedBox(height: 0),
          ),
        ),
      ],
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const DrawerItem({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 34),
      child: ListTile(
        dense: true,
        minVerticalPadding: 0,
        visualDensity: VisualDensity.compact,
        title: Text(title),
        onTap:
            onTap ??
            () {
              Navigator.pop(context); // drawer kapansın
            },
      ),
    );
  }
}
