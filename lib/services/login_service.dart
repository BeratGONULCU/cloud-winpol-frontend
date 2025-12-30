import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  static const String baseUrl = "http://192.168.1.36:8000";
  static final http.Client _client = http.Client();

  static Future<Map<String, dynamic>> login(
    String identifier,
    String password,
  ) async {
    print("LOGIN SERVICE START");

    final url = Uri.parse("$baseUrl/admin/login").replace(
      queryParameters: {
        "email": identifier,
        "password": password,
      },
    );

    print("LOGIN URL: $url");

    // KRİTİK NOKTA: POST + EMPTY BODY AMA BODY VARMIŞ GİBİ GÖSTER
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
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception("Unexpected response");
  }
}
