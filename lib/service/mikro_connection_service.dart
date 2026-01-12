import 'dart:convert';
import 'package:http/http.dart' as http;

class MikroService {
  static const String baseUrl = 'http://localhost:8000';


  // MİKRO BAĞLANTI SERVİSİ
  
  static Future<Map<String, dynamic>> connectToMikro({
    required String endpoint,
    required String db_name,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/test/mikro/$endpoint?db_name=$db_name',
    );

    final Map<String, dynamic> payload = {};

    // Backend Mikro auth'u kendisi ekliyor
    if (body != null) {
      payload.addAll(body);
    }

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Mikro API Error (${response.statusCode}): ${response.body}',
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
