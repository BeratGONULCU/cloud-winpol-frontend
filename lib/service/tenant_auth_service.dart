import 'package:http/http.dart' as http;
import 'package:cloud_winpol_frontend/service/auth_storage.dart';

class TenantAuthService {
  static const String _baseUrl = "http://localhost:8000";

  static Future<void> logout() async {
    final token = await AuthStorage.getToken();

    try {
      if (token != null && token.isNotEmpty) {
        await http.post(
          Uri.parse("$_baseUrl/tenant/logout"),
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        );
      }
    } finally {
      // TOKEN TEMİZLENİR
      await AuthStorage.clear();
    }
  }
}
