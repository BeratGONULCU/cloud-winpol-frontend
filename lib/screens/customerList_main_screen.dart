import 'package:cloud_winpol_frontend/models/admin_main_args.dart';
import 'package:cloud_winpol_frontend/models/customer_action.dart';
import 'package:cloud_winpol_frontend/screens/admin_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/service/company_service.dart';
import 'package:cloud_winpol_frontend/models/customer_summary.dart';
import 'package:cloud_winpol_frontend/widgets/card/customerCard.dart';
import 'package:cloud_winpol_frontend/screens/customer_detail_screen.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';
import 'package:cloud_winpol_frontend/widgets/navigation/admin_app_draver.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:cloud_winpol_frontend/screens/settings/settings_screen.dart';

class CustomerListScreen extends StatefulWidget {
  static const String routeName = '/customerList';

  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<CustomerSummary> customers = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    try {
      final data = await CompanyService.getCustomerSummaries();
      setState(() {
        customers = data;
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
    final width = MediaQuery.of(context).size.width;

    final crossAxisCount = width >= 1400
        ? 4
        : width >= 1000
        ? 3
        : width >= 600
        ? 2
        : 1;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.body,
      drawer: const AdminAppDrawer(),
      appBar: WinpolHeader(
        title: "Müşteri Listesi",
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

          if (customers.isEmpty) {
            return const Center(
              child: Text("Henüz müşteri yok", style: TextStyle(fontSize: 16)),
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
                        "Toplam ${customers.length} müşteri",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () async {
                          setState(() => loading = true);
                          await _loadCustomers();
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(236, 7, 86, 143),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.refresh,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),
                      _actionButton(
                        label: "Ekle",
                        icon: Icons.add,
                        filled: false,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AdminMainScreen.routeName,
                            arguments: const AdminMainArgs(
                              tabIndex: 0, // Müşteriler
                              action: CustomerAction.create,
                            ),
                          );
                        },
                      ),

                      const SizedBox(width: 8),
                      _actionButton(
                        label: "Düzenle",
                        icon: Icons.edit,
                        filled: false,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AdminMainScreen.routeName,
                            arguments: const AdminMainArgs(
                              tabIndex: 0,
                              action: CustomerAction.edit,
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ================= LIST HEADER =================
                  _listHeader(),


                  const SizedBox(height: 8),

                  // ================= LISTVIEW =================
                  Expanded(
                    child: ListView.separated(
                      itemCount: customers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final customer = customers[index];

                        return InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CustomerDetailScreen(customer: customer),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    customer.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(customer.vergiNo),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(customer.companyCode ?? "-"),
                                ),
                                SizedBox(
                                  width: 90,
                                  child: _statusBadge(
                                    customer.status == "ACTIVE",
                                  ),
                                ),
                                const SizedBox(
                                  width: 24,
                                  child: Icon(
                                    Icons.chevron_right,
                                    color: Colors.black38,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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

Widget _actionButton({
  required String label,
  required IconData icon,
  required bool filled,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: filled ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: filled ? AppColors.primary : Colors.black12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: filled ? Colors.white : Colors.black87),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: filled ? Colors.white : Colors.black87,
            ),
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

Widget _listHeader() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.black12),
    ),
    child: Row(
      children: const [
        Expanded(flex: 3, child: Text("Cari Adı")),
        Expanded(flex: 2, child: Text("Vergi No")),
        Expanded(flex: 2, child: Text("Şirket Kodu")),
        SizedBox(width: 90, child: Text("Durum")),
        SizedBox(width: 24),
      ],
    ),
  );
}
