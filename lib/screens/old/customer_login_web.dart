import 'package:cloud_winpol_frontend/screens/customer_main_screen.dart';
import 'package:cloud_winpol_frontend/screens/web/customer_main_web.dart';
import 'package:cloud_winpol_frontend/screens/settings/settings_screen.dart';
import 'package:cloud_winpol_frontend/services/auth_storage.dart';
import 'package:cloud_winpol_frontend/services/customer_login_service.dart';
import 'package:cloud_winpol_frontend/utils/show_pop.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';
import 'package:cloud_winpol_frontend/widgets/buttons/app_button.dart';
import 'package:cloud_winpol_frontend/widgets/text/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';

class CustomerLoginScreen extends StatefulWidget {
  static const String routeName = '/customerLogin';
  const CustomerLoginScreen({super.key});

  @override
  State<CustomerLoginScreen> createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  final TextEditingController _vergiNoController = TextEditingController();
  final TextEditingController _identifierController =
      TextEditingController(); // Kullanıcı adı veya email aynı yerde alınıyor
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _vergiNoController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<bool> _onBackPressed() async {
    // Eğer SQL'den aktif bir IS_GUID varsa → modal göster

    return await _showExitConfirmDialog();

    // aktif bir kayıt yok → direkt çık
    return true;
  }

  Future<bool> _showExitConfirmDialog() async {
    return true;
  }

  int isEmail() {
    String input = _identifierController.text.trim();
    // e-posta doğrulama
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(emailPattern);
    if (regex.hasMatch(input)) {
      print("Geçerli bir e-posta adresi girdiniz.");
      return 1; // E-posta
    } else {
      print("Geçersiz e-posta adresi.");
      return 0; // Kullanıcı adı
    }
  }

  Future<void> _handleLogin() async {
    print("LOGIN START");

    try {
      final result = await CustomerLoginService.login(
        _vergiNoController.text.trim(),
        _identifierController.text.trim(),
        _passwordController.text.trim(),
      );

      print("LOGIN RESULT: $result");

      // access_token VAR MI?
      if (result.containsKey("access_token") &&
          result["access_token"] != null &&
          result["access_token"].toString().isNotEmpty) {
        final token = result["access_token"].toString();

        // TOKEN'I KAYDET
        await AuthStorage.saveToken(token);
        print("TOKEN SAVED (CUSTOMER): $token");

        // AUTH KONTROLÜ (isteğe bağlı ama güzel)
        final sessionControl = await CustomerLoginService.sessionControl();
        print("SESSION CONTROL RESULT: $sessionControl");

        showPop(context, "Giriş başarılı", PopType.success);

        await Future.delayed(const Duration(milliseconds: 2000));

        Navigator.pushReplacementNamed(context, CustomerMainScreen.routeName);
      } else if (result.containsKey("error")) {
        if (result["error"] == "wrong_password") {
          showPop(context, "Kullanıcı adı veya şifre hatalı", PopType.error);
        } else {
          showPop(context, "Giriş başarısız", PopType.error);
        }
      } else {
        showPop(
          context,
          "Giriş yapılamadı. Lütfen tekrar deneyin.",
          PopType.error,
        );
      }
    } catch (e) {
      print("LOGIN ERROR: $e");
      showPop(context, "Sunucuya bağlanılamadı ya da internet bağlantısı yok", PopType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.body,
      
      appBar: WinpolHeader(
        title: "Winpol",
        onBack: () async {
          if (await _onBackPressed()) {
            Navigator.pop(context);
          }
        },
        onSettings: () {
          Navigator.pushNamed(context, SettingsScreen.routeName);
        },
        showLogo: true,
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ARKA IŞIK (GLOW)
            Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(124),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.35),
                    blurRadius: 55,
                    spreadRadius: 16,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
            ),

            // CARD (RENKSİZ / TEMİZ)
            Container(
              width: 360,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
              decoration: BoxDecoration(
                color: AppColors.card, // SADECE kendi rengi
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 56,
                    child: Image.asset('assets/images/winpol_logo.png'),
                  ),
                  const SizedBox(height: 28),
                  AppTextField(
                    label: 'Vergi No / TCKN',
                    controller: _vergiNoController,
                    onSubmit: _handleLogin,
                  ),
                  SizedBox(height: 18),
                  AppTextField(
                    label: 'Email',
                    controller: _identifierController,
                    onSubmit: _handleLogin,
                  ),
                  const SizedBox(height: 18),
                  AppTextField(
                    label: 'Şifre',
                    obscure: true,
                    controller: _passwordController,
                    onSubmit: _handleLogin,
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    title: 'GİRİŞ YAP',
                    onTap: () {
                      final vergiNo = _vergiNoController.text.trim();
                      final identifier = _identifierController.text.trim();
                      final password = _passwordController.text.trim();
                      _handleLogin();
                    },
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

