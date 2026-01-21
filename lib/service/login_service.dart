import 'dart:convert';
import 'package:cloud_winpol_frontend/service/api_client.dart';
import 'package:cloud_winpol_frontend/service/auth_storage.dart';
import 'package:http/http.dart' as http;

class LoginService {
  //static const String baseUrl = "http://localhost:8000";
  static const String baseUrl = "/api";
  
  //  static const String baseUrl = "http://192.168.1.36:8000";
  static final http.Client _client = http.Client();

  static Future<Map<String, dynamic>> login(
    String identifier,
    String password,
  ) async {
    print("LOGIN SERVICE START");

    final url = Uri.parse(
      "$baseUrl/admin/login",
    ).replace(queryParameters: {"email": identifier, "password": password});

    final response = await _client.post(
      url,
      headers: const {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: "",
    );

    print("LOGIN STATUS: ${response.statusCode}");
    print("LOGIN BODY RAW: ${response.body}");

    if (response.statusCode == 401) {
      return {"error": "wrong_password"};
    }

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      final token = data["access_token"];
      if (token == null) {
        throw Exception("Token missing in login response");
      }

      // EN KRİTİK SATIR
      await AuthStorage.saveToken(token);

      // DEBUG (1 kere bak, sonra silebilirsin)
      final saved = await AuthStorage.getToken();
      print("SAVED TOKEN: $saved");

      return data;
    }

    throw Exception("Unexpected response");
  }

  static Future<Map<String, dynamic>> sessionControl() async {
    final url = Uri.parse("$baseUrl/tenant/tenant-info");

    final response = await ApiClient.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Session control failed");
  }
}
