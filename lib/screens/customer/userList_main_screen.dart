import 'package:cloud_winpol_frontend/models/customer_action.dart';
import 'package:cloud_winpol_frontend/models/customer_main_args.dart';
import 'package:cloud_winpol_frontend/screens/customer/user_detail_screen.dart';
import 'package:cloud_winpol_frontend/widgets/navigation/customer_app_draver.dart';
import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/service/customer_service.dart';
import 'package:cloud_winpol_frontend/models/user_summary.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:cloud_winpol_frontend/screens/settings/settings_screen.dart';

class UserlistMainScreen extends StatefulWidget {
  static const String routeName = '/userList';

  const UserlistMainScreen({super.key});

  @override
  State<UserlistMainScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserlistMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<UserSummary> users = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final data = await CustomerService.getAllUsersBySession();
      setState(() {
        users = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.body,
      drawer: const CustomerAppDrawer(),
      appBar: WinpolHeader(
        title: "Kullanıcı Listesi",
        showLogo: false,
        onBack: null,
        onMenu: () => _scaffoldKey.currentState?.openDrawer(),
        onSettings: () =>
            Navigator.pushNamed(context, SettingsScreen.routeName),
      ),
      body: Builder(
        builder: (context) {
          if (loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (error != null) {
            return Center(
              child: Text("Hata oluştu:\n$error", textAlign: TextAlign.center),
            );
          }

          if (users.isEmpty) {
            return const Center(
              child: Text(
                "Henüz kullanıcı yok",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1400),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= TOP BAR =================
                  Row(
                    children: [
                      Text(
                        "Toplam: ${users.length} Kullanıcı",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),

                      _refreshButton(),

                      const SizedBox(width: 8),
                      _actionButton(
                        label: "Ekle",
                        icon: Icons.add,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/userInsertWeb',
                            arguments: const CustomerArgs(
                              action: CustomerAction.create,
                            ),
                          );
                        },
                      ),

                      const SizedBox(width: 8),
                      
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ================= ANA LİSTE DİV =================
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Column(
                        children: [
                          // ===== STICKY HEADER (desktop) =====
                          if (!isMobile) _stickyHeader(),

                          if (!isMobile) const SizedBox(height: 8),

                          // ===== LIST =====
                          Expanded(
                            child: ListView.separated(
                              itemCount: users.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 6),
                              itemBuilder: (context, index) {
                                return _userRow(context, users[index], index);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/* ========================================================= */
/* ======================= WIDGETS ========================= */
/* ========================================================= */

Widget _refreshButton() {
  return InkWell(
    borderRadius: BorderRadius.circular(10),
    onTap: () {},
    child: Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: const Color.fromARGB(236, 7, 86, 143),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.refresh, size: 18, color: Colors.white),
    ),
  );
}

Widget _actionButton({
  required String label,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    ),
  );
}

Widget _stickyHeader() {
  return Material(
    elevation: 2,
    borderRadius: BorderRadius.circular(12),
    child: _userListHeader(),
  );
}

Widget _userRow(BuildContext context, UserSummary user, int index) {
  final isEven = index % 2 == 0;

  return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: () {
      Navigator.pushNamed(
        context,
        '/userInsertWeb',
        arguments: CustomerArgs(
          action: CustomerAction.edit,
          user: user, // SADECE BURADA user VAR
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: isEven ? Colors.white : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(user.email ?? "-")),
          Expanded(flex: 3, child: Text(user.username ?? "-")),
          Expanded(flex: 2, child: Text(user.longName ?? "-")),
          Expanded(flex: 2, child: Text(user.kullaniciNo?.toString() ?? "-")),
          SizedBox(width: 60, child: _statusBadge(!(user.isPassive ?? false))),
          SizedBox(width: 40),

          // buraya edit kısmı eklenecek customerAction.edit
          SizedBox(
            width: 20,
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.edit, size: 18),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/userInsertWeb',
                    arguments: const CustomerArgs(action: CustomerAction.edit),
                  );
                },
              ),
            ),
          ),

          SizedBox(width: 10),
        ],
      ),
    ),
  );
}

Widget _statusBadge(bool active) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: active
          ? Colors.green.withOpacity(0.15)
          : Colors.red.withOpacity(0.15),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      active ? "Aktif" : "Pasif",
      style: TextStyle(fontSize: 12, color: active ? Colors.green : Colors.red),
    ),
  );
}

Widget _userListHeader() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.black12),
    ),
    child: const Row(
      children: [
        Expanded(
          flex: 3,
          child: Text("E-posta", style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        Expanded(
          flex: 3,
          child: Text(
            "Kullanıcı Adı",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            "Ad Soyad",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            "Kullanıcı No",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          width: 60,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text("Durum", style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
        SizedBox(width: 40),
        SizedBox(
          width: 20,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text("", style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),

        SizedBox(width: 24),
      ],
    ),
  );
}
