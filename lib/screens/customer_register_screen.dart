import 'package:cloud_winpol_frontend/screens/customer_main_screen.dart';
import 'package:cloud_winpol_frontend/screens/customer_home_screen.dart';
import 'package:cloud_winpol_frontend/screens/old/customer_login_web.dart';
import 'package:cloud_winpol_frontend/screens/settings/settings_screen.dart';
import 'package:cloud_winpol_frontend/service/auth_storage.dart';
import 'package:cloud_winpol_frontend/service/customer_login_service.dart';
import 'package:cloud_winpol_frontend/utils/show_pop.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';
import 'package:cloud_winpol_frontend/widgets/buttons/app_button.dart';
import 'package:cloud_winpol_frontend/widgets/text/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:cloud_winpol_frontend/models/app_button_type.dart';

class CustomerRegisterScreen extends StatefulWidget {
  static const String routeName = '/customerRegister';
  const CustomerRegisterScreen({super.key});

  @override
  State<CustomerRegisterScreen> createState() => _CustomerRegisterScreenState();
}

class _CustomerRegisterScreenState extends State<CustomerRegisterScreen> {
  int _step = 1;

  final TextEditingController _vergiNoController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _vergiNoController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    try {
      final result = await CustomerLoginService.register(
        vergiNo: _vergiNoController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        roleId: "1cbdc756-c8ac-4fe0-a65c-e53f3f6580ad",
        longName: _fullNameController.text.trim(),
        cepTel: _phoneController.text.trim(),
        email: _emailController.text.trim(),
      );

      if (result.containsKey("user_id")) {
        showPop(
          context,
          "Kayıt başarılı. Giriş yapabilirsiniz.",
          PopType.success,
        );

        await Future.delayed(const Duration(milliseconds: 1500));
        Navigator.pushReplacementNamed(context, CustomerLoginScreen.routeName);
      } else {
        showPop(context, "Kayıt tamamlanamadı.", PopType.error);
      }
    } catch (e) {
      print("REGISTER ERROR: $e");
      showPop(context, "Kayıt hatası: $e", PopType.error); // debug için
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.body,
      appBar: WinpolHeader(
        title: "Winpol",
        onBack: () {
          if (_step == 2) {
            setState(() => _step = 1);
          } else {
            Navigator.pop(context);
          }
        },
        onSettings: () {
          Navigator.pushNamed(context, SettingsScreen.routeName);
        },
        showLogo: true,
      ),
      body: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black.withAlpha(20), width: 0.8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 48,
                child: Image.asset('assets/images/winpol_logo.png'),
              ),
              const SizedBox(height: 20),

              _step == 1 ? _buildStep1() : _buildStep2(),
            ],
          ),
        ),
      ),
    );
  }

  // ================= STEP 1 =================
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Firma & Hesap Bilgileri",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C4B7D),
          ),
        ),
        const SizedBox(height: 16),

        AppTextField(label: 'Vergi No / TCKN', controller: _vergiNoController),
        const SizedBox(height: 12),

        AppTextField(label: 'Kullanıcı Adı', controller: _usernameController),
        const SizedBox(height: 12),

        AppTextField(
          label: 'Şifre',
          obscure: true,
          controller: _passwordController,
        ),

        const SizedBox(height: 24),

        AppButton(
          title: "DEVAM ET",
          onTap: () {
            setState(() => _step = 2);
          },
        ),
      ],
    );
  }

  // ================= STEP 2 =================
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Kişisel Bilgiler",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C4B7D),
          ),
        ),
        const SizedBox(height: 16),

        AppTextField(label: 'Ad Soyad', controller: _fullNameController),
        const SizedBox(height: 12),

        AppTextField(label: 'Email', controller: _emailController),
        const SizedBox(height: 12),

        AppTextField(label: 'Cep No', controller: _phoneController),

        const SizedBox(height: 24),

        AppButton(title: "KAYDI TAMAMLA", onTap: _handleRegister),
      ],
    );
  }
}
