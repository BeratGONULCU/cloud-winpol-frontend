import 'dart:convert';
import 'package:cloud_winpol_frontend/service/api_client.dart';
import 'package:cloud_winpol_frontend/service/auth_storage.dart';
import 'package:http/http.dart' as http;

class CustomerLoginService {
  static const String baseUrl = "http://localhost:8000";
  static final http.Client _client = http.Client();

  static Future<Map<String, dynamic>> login(
    String vergiNo,
    String identifier,
    String password,
  ) async {
    print("LOGIN SERVICE START");

    final url = Uri.parse(
      "$baseUrl/tenant/user-login-to-firmby-vergino2"
      "?vergi_no=${Uri.encodeComponent(vergiNo)}"
      "&email=${Uri.encodeComponent(identifier)}"
      "&password=${Uri.encodeComponent(password)}",
    );

    print("LOGIN URL: $url");

    final response = await _client.post(
      url,
      headers: const {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: "", // boş da olsa body şart
    );

    print("LOGIN STATUS: ${response.statusCode}");
    print("LOGIN BODY RAW: ${response.body}");

    if (response.statusCode == 401) {
      return {"error": "wrong_password"};
    }

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception("Login failed ${response.statusCode}: ${response.body}");
  }


  static Future<Map<String, dynamic>> sessionControl() async {
    final url = Uri.parse("$baseUrl/tenant/tenant-info");

    final response = await ApiClient.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Session control failed");
  }

  static Future<Map<String, dynamic>> register({
    required String vergiNo,
    required String username,
    required String password,
    String? roleId,
    String? longName,
    String? cepTel,
    String? email,
  }) async {
    final Map<String, String> queryParams = {
      "vergi_no": vergiNo.trim(),
      "username": username.trim(),
      "password": password,
    };

    if (roleId != null && roleId.trim().isNotEmpty) {
      queryParams["role_id"] = roleId.trim();
    }

    if (longName != null && longName.trim().isNotEmpty) {
      queryParams["longName"] = longName.trim();
    }

    if (cepTel != null && cepTel.trim().isNotEmpty) {
      queryParams["cepTel"] = cepTel.trim();
    }

    if (email != null && email.trim().isNotEmpty) {
      queryParams["email"] = email.trim();
    }

    final Uri url = Uri.parse(
      "$baseUrl/tenant/user-register-to-firmby-vergino",
    ).replace(queryParameters: queryParams);

    final response = await http.post(url);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception(
      "Kullanıcı kaydı başarısız oldu. "
      "${response.statusCode}: ${response.body}",
    );
  }
}
