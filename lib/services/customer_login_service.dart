import 'dart:convert';
import 'package:cloud_winpol_frontend/services/api_client.dart';
import 'package:cloud_winpol_frontend/services/auth_storage.dart';
import 'package:http/http.dart' as http;

class CustomerLoginService {
  static const String baseUrl = "http://192.168.1.36:8000";
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
}
