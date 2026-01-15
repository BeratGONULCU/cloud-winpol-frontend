import 'package:cloud_winpol_frontend/models/admin_main_args.dart';
import 'package:cloud_winpol_frontend/models/branch_action.dart';
import 'package:cloud_winpol_frontend/models/branch_main_args.dart';
import 'package:cloud_winpol_frontend/models/branch_summary_old.dart';
import 'package:cloud_winpol_frontend/models/customer_action.dart';
import 'package:cloud_winpol_frontend/models/customer_main_args.dart';
import 'package:cloud_winpol_frontend/screens/admin/web/admin_main_screen.dart';
import 'package:cloud_winpol_frontend/screens/customer/user_detail_screen.dart';
import 'package:cloud_winpol_frontend/service/mikro_connection_service.dart';
import 'package:cloud_winpol_frontend/widgets/navigation/customer_app_draver.dart';
import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/service/customer_service.dart';
import 'package:cloud_winpol_frontend/models/user_summary.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:cloud_winpol_frontend/screens/settings/settings_screen.dart';
import 'package:cloud_winpol_frontend/models/branch_summary.dart';

class BranchlistMainScreen extends StatefulWidget {
  static const String routeName = '/branchList';

  const BranchlistMainScreen({super.key});

  @override
  State<BranchlistMainScreen> createState() => _BranchListScreenState();
}

class _BranchListScreenState extends State<BranchlistMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<BranchReportSummary> branches = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadbranches();
  }

  /* ========================================================= */
  /* ===================== SUBELER SQL ======================= */
  /* ========================================================= */

  Future<void> _loadbranches() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final response = await MikroService.connectMikroWithBody(
        endpoint: 'SqlVeriOkuV2',
        db_name: '1234567890',
        body: {
          "SQLSorgu": """
           SELECT Sube_no AS [Şube No], Sube_adi AS [Şube Adı], sube_TelNo1 AS [Telefon], sube_Cadde AS [Cadde], sube_Mahalle AS [Mahalle], sube_Sokak AS [Sokak], sube_Apt_No AS [Apt. No], sube_Ilce AS [İlçe], sube_Il AS [Şehir], sube_Ulke AS [Ülke] FROM SUBELER
          """,
        },
      );

      final result = response['result']?[0];
      final data = result?['Data']?[0]?['SQLResult1'];

      if (data == null) {
        setState(() {
          branches = [];
        });
        return;
      }

      // SQL →  BranchReportSummary
      final List<BranchReportSummary> parsed = List<Map<String, dynamic>>.from(
        data,
      ).map((e) => BranchReportSummary.fromJson(e)).toList();

      setState(() {
        branches = parsed;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
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
                    "Toplam: ${branches.length} Şube",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  _refreshButton(
                    onTap: () {
                      _loadbranches();
                    },
                  ),
                  const SizedBox(width: 8),
                  _actionButton(
                    label: "Ekle",
                    icon: Icons.add,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/branchInsertWeb',
                        arguments: const BranchArgs(
                          action: BranchAction.create,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
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

                            // EMPTY
                            if (branches.isEmpty) {
                              return Center(
                                child: Text(
                                  "Henüz şube bulunamadı",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.55),
                                  ),
                                ),
                              );
                            }

                            // DATA
                            return ListView.separated(
                              itemCount: branches.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 6),
                              itemBuilder: (context, index) {
                                return _branchRow(
                                  context,
                                  branches[index],
                                  index,
                                );
                              },
                            );
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

Widget _refreshButton({required VoidCallback onTap}) {
  return InkWell(
    borderRadius: BorderRadius.circular(10),
    onTap: onTap,
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

Widget _branchRow(BuildContext context, BranchReportSummary branch, int index) {
  final isEven = index % 2 == 0;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    decoration: BoxDecoration(
      color: isEven ? Colors.white : const Color(0xFFF9FAFB),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.black12),
    ),
    child: Row(
      children: [
        Expanded(flex: 1, child: Text(branch.subeNo?.toString() ?? "-")),
        Expanded(flex: 3, child: Text(branch.name ?? "-")),
        Expanded(flex: 2, child: Text(branch.telefon ?? "-")),
        Expanded(flex: 2, child: Text(branch.sehir ?? "-")),
      ],
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
          flex: 2,
          child: Text("Telefon", style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        Expanded(
          flex: 2,
          child: Text("Şehir", style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    ),
  );
}
