import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_winpol_frontend/widgets/navigation/customer_app_draver.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:cloud_winpol_frontend/widgets/buttons/submit_button.dart';
import 'package:cloud_winpol_frontend/screens/settings/settings_screen.dart';

class BranchInsertScreen extends StatefulWidget {
  static const String routeName = '/branchInsertWeb';

  const BranchInsertScreen({super.key});

  @override
  State<BranchInsertScreen> createState() => _BranchInsertScreenState();
}

class _BranchInsertScreenState extends State<BranchInsertScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ================= CONTROLLERS =================
  final _firmaNoController = TextEditingController();
  final _subeNoController = TextEditingController();
  final _subeAdiController = TextEditingController();
  final _telefonController = TextEditingController();

  final _caddeController = TextEditingController();
  final _mahalleController = TextEditingController();
  final _sokakController = TextEditingController();
  final _aptNoController = TextEditingController();
  final _ilceController = TextEditingController();
  final _sehirController = TextEditingController();
  final _ulkeController = TextEditingController();

  @override
  void dispose() {
    _firmaNoController.dispose();
    _subeNoController.dispose();
    _subeAdiController.dispose();
    _telefonController.dispose();
    _caddeController.dispose();
    _mahalleController.dispose();
    _sokakController.dispose();
    _aptNoController.dispose();
    _ilceController.dispose();
    _sehirController.dispose();
    _ulkeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.body,
      drawer: const CustomerAppDrawer(),
      appBar: WinpolHeader(
        title: "Şube Oluştur",
        showLogo: true,
        onBack: () => Navigator.pop(context),
        onMenu: () => _scaffoldKey.currentState?.openDrawer(),
        onSettings: () =>
            Navigator.pushNamed(context, SettingsScreen.routeName),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: _BranchForm(
          firmaNoController: _firmaNoController,
          subeNoController: _subeNoController,
          subeAdiController: _subeAdiController,
          telefonController: _telefonController,
          caddeController: _caddeController,
          mahalleController: _mahalleController,
          sokakController: _sokakController,
          aptNoController: _aptNoController,
          ilceController: _ilceController,
          sehirController: _sehirController,
          ulkeController: _ulkeController,
          onSubmit: _submitBranch,
        ),
      ),
    );
  }

  // ================= SUBMIT =================
  Future<void> _submitBranch() async {
    final payload = {
      "Firma No": int.tryParse(_firmaNoController.text),
      "Şube No": int.tryParse(_subeNoController.text),
      "Şube Adı": _subeAdiController.text.trim(),
      "Telefon": _telefonController.text.trim(),
      "Cadde": _caddeController.text.trim(),
      "Mahalle": _mahalleController.text.trim(),
      "Sokak": _sokakController.text.trim(),
      "Apt. No": _aptNoController.text.trim(),
      "İlçe": _ilceController.text.trim(),
      "Şehir": _sehirController.text.trim(),
      "Ülke": _ulkeController.text.trim(),
    };

    debugPrint("BRANCH PAYLOAD => $payload");

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Şube kaydetme isteği hazır")));
  }
}

/* ========================================================= */
/* ======================= FORM PANEL ====================== */
/* ========================================================= */

class _BranchFormPanel extends StatelessWidget {
  const _BranchFormPanel();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class _BranchForm extends StatelessWidget {
  final TextEditingController firmaNoController;
  final TextEditingController subeNoController;
  final TextEditingController subeAdiController;
  final TextEditingController telefonController;
  final TextEditingController caddeController;
  final TextEditingController mahalleController;
  final TextEditingController sokakController;
  final TextEditingController aptNoController;
  final TextEditingController ilceController;
  final TextEditingController sehirController;
  final TextEditingController ulkeController;
  final VoidCallback onSubmit;

  const _BranchForm({
    required this.firmaNoController,
    required this.subeNoController,
    required this.subeAdiController,
    required this.telefonController,
    required this.caddeController,
    required this.mahalleController,
    required this.sokakController,
    required this.aptNoController,
    required this.ilceController,
    required this.sehirController,
    required this.ulkeController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return Center(
      child: Container(
        width: isMobile ? double.infinity : 860,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: panelBox(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= HEADER =================
            const Text(
              "Şube Bilgileri",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Şubeye ait temel ve adres bilgilerini girin",
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 20),

            // ================= FORM =================
            _formWrapper(
              isMobile,
              [
                modernInput(
                  label: "Firma No",
                  controller: firmaNoController,
                  digits: 5,
                ),
                modernInput(
                  label: "Şube No",
                  controller: subeNoController,
                  digits: 5,
                ),
                modernInput(label: "Şube Adı", controller: subeAdiController),
                modernInput(
                  label: "Telefon",
                  controller: telefonController,
                  digits: 11,
                ),
                modernInput(label: "Cadde", controller: caddeController),
                modernInput(label: "Mahalle", controller: mahalleController),
                modernInput(label: "Sokak", controller: sokakController),
                modernInput(label: "Apt. No", controller: aptNoController),
                modernInput(label: "İlçe", controller: ilceController),
                modernInput(label: "Şehir", controller: sehirController),
                modernInput(label: "Ülke", controller: ulkeController),
              ],
              SizedBox(
                width: isMobile ? double.infinity : 220,
                height: 48,
                child: SubmitButton(label: "Şube Kaydet", onPressed: onSubmit),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formWrapper(bool isMobile, List<Widget> inputs, Widget button) {
    return Column(
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 14,
          children: inputs
              .map(
                (e) =>
                    SizedBox(width: isMobile ? double.infinity : 320, child: e),
              )
              .toList(),
        ),
        const SizedBox(height: 24),
        Align(alignment: Alignment.centerRight, child: button),
      ],
    );
  }
}

Widget modernInput({
  required String label,
  required TextEditingController controller,
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

BoxDecoration panelBox() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
  border: Border.all(color: const Color(0xFFE5E7EB)),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.03),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ],
);
