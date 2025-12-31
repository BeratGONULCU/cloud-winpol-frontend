import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: const [
            _DrawerHeader(),

            DrawerSection(
              title: "Fatura",
              icon: Icons.receipt_long,
              children: [
                DrawerItem(title: "Fatura Listesi"),
                DrawerItem(title: "Yeni Fatura"),
              ],
            ),

            DrawerSection(
              title: "İrsaliye",
              icon: Icons.local_shipping,
              children: [
                DrawerItem(title: "İrsaliye Listesi"),
                DrawerItem(title: "Yeni İrsaliye"),
              ],
            ),

            DrawerSection(
              title: "Stok",
              icon: Icons.inventory_2,
              children: [
                DrawerItem(title: "Stok Kartları"),
                DrawerItem(title: "Depolar"),
                DrawerItem(title: "Stok Hareketleri"),
              ],
            ),

            DrawerSection(
              title: "Rapor",
              icon: Icons.bar_chart,
              children: [
                DrawerItem(title: "Satış Raporu"),
                DrawerItem(title: "Stok Raporu"),
              ],
            ),

            DrawerSection(
              title: "Ayarlar (Yönetim)",
              icon: Icons.settings,
              children: [
                DrawerItem(title: "Kullanıcılar"),
                DrawerItem(title: "Yetkiler"),
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

class _DrawerSectionState extends State<DrawerSection> {
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
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 180),
          crossFadeState:
              _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Column(children: widget.children),
          secondChild: const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const DrawerItem({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 34),
      child: ListTile(
        dense: true,
        title: Text(title),
        onTap: onTap ??
            () {
              Navigator.pop(context); // drawer kapansın
            },
      ),
    );
  }
}
