import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_winpol_frontend/widgets/navigation/customer_app_draver.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:cloud_winpol_frontend/screens/settings/settings_screen.dart';

class MikroApiSettingsScreen extends StatefulWidget {
  static const String routeName = '/mikroApiSettings';

  const MikroApiSettingsScreen({super.key});

  @override
  State<MikroApiSettingsScreen> createState() =>
      _MikroApiSettingsScreenState();
}

class _MikroApiSettingsScreenState extends State<MikroApiSettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _ipCtrl = TextEditingController();
  final _portCtrl = TextEditingController();
  final _firmaKoduCtrl = TextEditingController();
  final _calismaYiliCtrl = TextEditingController(text: "2025");
  final _kullaniciCtrl = TextEditingController();
  final _sifreCtrl = TextEditingController();

  final _apiKeyCtrl = TextEditingController();
  final _firmaNoCtrl = TextEditingController();
  final _subeNoCtrl = TextEditingController();

  bool _loading = false;
  bool _showPassword = false;

  Future<void> _kaydet() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
  }

  Future<void> _testEt() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.body,
      drawer: const CustomerAppDrawer(),
      appBar: WinpolHeader(
        title: "Mikro API Ayarları",
        onBack: null,
        onMenu: () => _scaffoldKey.currentState?.openDrawer(),
        onSettings: () =>
            Navigator.pushNamed(context, SettingsScreen.routeName),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;

          return SingleChildScrollView(
            physics: isMobile
                ? const BouncingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildFormCard(isMobile),
                    const SizedBox(height: 24),
                    _buildActionBar(isMobile),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= FORM =================

  Widget _buildFormCard(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Bağlantı Bilgileri",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),

          if (isMobile) ..._mobileForm(),
          if (!isMobile) ..._desktopForm(),

          if (_loading)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  // ================= MOBILE FORM =================

  List<Widget> _mobileForm() => [
        _inputRow("Mikro IP / Host", _ipCtrl,
            requiredField: true, isIp: true),
        _gap(),
        _inputRow("Port", _portCtrl,
            requiredField: true, isNumber: true),
        _gap(),
        _inputRow("Firma Kodu", _firmaKoduCtrl,
            requiredField: true),
        _gap(),
        _inputRow("Çalışma Yılı", _calismaYiliCtrl,
            requiredField: true, isNumber: true),
        _gap(),
        _inputRow("Kullanıcı", _kullaniciCtrl,
            requiredField: true),
        _gap(),
        _passwordInput(),
        _gap(),
        _inputRow("Firma No", _firmaNoCtrl,
            isNumber: true),
        _gap(),
        SizedBox(width: 60,),
        _inputRow("API Key", _apiKeyCtrl,
            maxLength: 255),
        _gap(),
        _inputRow("Şube No", _subeNoCtrl,
            isNumber: true),
      ];

  // ================= DESKTOP FORM =================

  List<Widget> _desktopForm() => [
        _row(
          _inputRow("Mikro IP / Host", _ipCtrl,
              requiredField: true, isIp: true),
          _inputRow("Port", _portCtrl,
              requiredField: true, isNumber: true),
        ),
        _row(
          _inputRow("Firma Kodu", _firmaKoduCtrl,
              requiredField: true),
          _inputRow("Çalışma Yılı", _calismaYiliCtrl,
              requiredField: true, isNumber: true),
        ),
        _row(
          _inputRow("Kullanıcı", _kullaniciCtrl,
              requiredField: true),
          _passwordInput(),
        ),
        _row(
          _inputRow("Firma No", _firmaNoCtrl,
              isNumber: true),
          _inputRow("API Key", _apiKeyCtrl,
              maxLength: 255),
        ),
        _row(
          _inputRow("Şube No", _subeNoCtrl,
              isNumber: true),
          const SizedBox(),
        ),
      ];

  // ================= ACTION BAR =================

  Widget _buildActionBar(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _dangerButton("Sil", Icons.delete, _testEt),
          const SizedBox(height: 12),
          _normalButton("Bağlantı Testi", Icons.wifi_tethering, _testEt),
          const SizedBox(height: 12),
          _primaryButton("Kaydet", Icons.save, _kaydet),
        ],
      );
    }

    return Row(
      children: [
        const Spacer(),
        Expanded(child: _dangerButton("Sil", Icons.delete, _testEt)),
        const SizedBox(width: 16),
        Expanded(
            child: _normalButton(
                "Bağlantı Testi", Icons.wifi_tethering, _testEt)),
        const SizedBox(width: 16),
        Expanded(child: _primaryButton("Kaydet", Icons.save, _kaydet)),
      ],
    );
  }

  // ================= INPUT HELPERS =================

  Widget _passwordInput() {
    return _inputRow(
      "Şifre",
      _sifreCtrl,
      obscure: true,
      requiredField: true,
      suffix: IconButton(
        icon: Icon(
          _showPassword ? Icons.visibility_off : Icons.visibility,
        ),
        onPressed: () => setState(() => _showPassword = !_showPassword),
      ),
    );
  }
}

/* ================= HELPERS ================= */

Widget _gap() => const SizedBox(height: 14);

Widget _row(Widget left, Widget right) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    ),
  );
}

Widget _inputRow(
  String label,
  TextEditingController controller, {
  bool isNumber = false,
  bool obscure = false,
  bool requiredField = false,
  bool isIp = false,
  int? maxLength,
  Widget? suffix,
}) {
  return TextField(
    controller: controller,
    obscureText: obscure,
    keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    inputFormatters: [
      if (isNumber && !isIp) FilteringTextInputFormatter.digitsOnly,
      if (isIp) FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
    ],
    maxLength: maxLength,
    decoration: InputDecoration(
      label: RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(color: Colors.black87),
          children: [
            if (requiredField)
              const TextSpan(
                text: " *",
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF7F9FC),
      isDense: true,
      counterText:
          maxLength != null ? "${controller.text.length}/$maxLength" : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF065186)),
      ),
    ),
  );
}

/* ================= BUTTONS ================= */

Widget _primaryButton(String label, IconData icon, VoidCallback onTap) =>
    _baseButton(label, icon, onTap, const Color(0xFF065186));

Widget _normalButton(String label, IconData icon, VoidCallback onTap) =>
    _baseButton(label, icon, onTap, Colors.white,
        borderColor: const Color(0xFFC9D6E2),
        textColor: Colors.black87);

Widget _dangerButton(String label, IconData icon, VoidCallback onTap) =>
    _baseButton(label, icon, onTap,
        const Color.fromARGB(255, 205, 14, 14));

Widget _baseButton(
  String label,
  IconData icon,
  VoidCallback onTap,
  Color bgColor, {
  Color? borderColor,
  Color textColor = Colors.white,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(16),
    onTap: onTap,
    child: Container(
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border:
            borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    ),
  );
}
