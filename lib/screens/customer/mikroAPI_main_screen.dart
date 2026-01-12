import 'package:cloud_winpol_frontend/models/admin_main_args.dart';
import 'package:cloud_winpol_frontend/models/branch_main_args.dart';
import 'package:cloud_winpol_frontend/models/branch_summary.dart';
import 'package:cloud_winpol_frontend/models/customer_action.dart';
import 'package:cloud_winpol_frontend/models/customer_main_args.dart';
import 'package:cloud_winpol_frontend/screens/admin/web/admin_main_screen.dart';
import 'package:cloud_winpol_frontend/screens/customer/user_detail_screen.dart';
import 'package:cloud_winpol_frontend/widgets/navigation/customer_app_draver.dart';
import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/service/customer_service.dart';
import 'package:cloud_winpol_frontend/models/user_summary.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:cloud_winpol_frontend/screens/settings/settings_screen.dart';
import 'package:cloud_winpol_frontend/models/branch_summary.dart';

class MikroAPIMainScreen extends StatefulWidget {
  static const String routeName = '/mikroAPI';

  const MikroAPIMainScreen({super.key});

  @override
  State<MikroAPIMainScreen> createState() => _MikroAPIScreenState();
}

class _MikroAPIScreenState extends State<MikroAPIMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.body,
      drawer: const CustomerAppDrawer(),
      appBar: WinpolHeader(
        title: "Şube Listesi",
        showLogo: false,
        onBack: null,
        onMenu: () => _scaffoldKey.currentState?.openDrawer(),
        onSettings: () =>
            Navigator.pushNamed(context, SettingsScreen.routeName),
      ),
      body: Center(
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
                    "Mikro API Ayarlar",
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

                  _actionButton(
                    label: "Düzenle",
                    icon: Icons.edit,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/userInsertWeb',
                        arguments: const CustomerArgs(
                          action: CustomerAction.edit,
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ================= TABLO =================
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
                      if (!isMobile) _stickyHeader(),
                      if (!isMobile) const SizedBox(height: 8),

                      Expanded(
                        child: Builder(
                          builder: (_) {
                            // LOADING
                            if (loading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            // ERROR (AMA TABLO DURUYOR)
                            if (error != null) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.red.withOpacity(0.7),
                                    size: 36,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Herhangi Bir Şube Bulunamadı!",
                                    style: TextStyle(
                                      color: Colors.red.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              );
                            }

                            return const SizedBox.expand(); // bu geçici silinecek
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

Widget _userRow(BuildContext context, BranchSummary branch, int index) {
  final isEven = index % 2 == 0;

  return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: () {
      Navigator.pushNamed(
        context,
        '/userInsertWeb',
        arguments: BranchArgs(
          action: CustomerAction.edit,
          branch: branch, // SADECE BURADA user VAR
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
          Expanded(flex: 3, child: Text(branch.subeNo.toString())),
          Expanded(flex: 3, child: Text(branch.name!)),
          Expanded(flex: 2, child: Text(branch.code ?? "-")),
          Expanded(flex: 2, child: Text(branch.mersisNo.toString() ?? "-")),
          Expanded(flex: 2, child: Text(branch.sehir ?? "-")),
          SizedBox(width: 60, child: _statusBadge(!(branch.isLocked ?? false))),
          const SizedBox(
            width: 24,
            child: Icon(Icons.chevron_right, color: Colors.black38),
          ),
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

/*

        children: [
          Expanded(flex: 3, child: Text(branch.subeNo.toString())),
          Expanded(flex: 3, child: Text(branch.name!)),
          Expanded(flex: 2, child: Text(branch.code ?? "-")),
          Expanded(flex: 2, child: Text(branch.mersisNo.toString() ?? "-")),
          Expanded(flex: 2, child: Text(branch.sehir ?? "-")),
          SizedBox(width: 60, child: _statusBadge(!(branch.isLocked ?? false))),
          const SizedBox(
            width: 24,
            child: Icon(Icons.chevron_right, color: Colors.black38),
          ),
        ],
         */

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
          flex: 1,
          child: Text("Şube No", style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        Expanded(
          flex: 3,
          child: Text(
            "Şube Adı",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "Şube Kodu",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            "Şube Mersis No",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text("Şehir", style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        SizedBox(
          width: 60,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text("Durum", style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
        SizedBox(width: 24),
      ],
    ),
  );
}
