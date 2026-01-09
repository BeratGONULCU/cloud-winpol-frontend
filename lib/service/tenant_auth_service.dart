import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cloud_winpol_frontend/service/auth_storage.dart';

class TenantAuthService {
  static const String baseUrl = "http://localhost:8000";

  static Future<void> logout() async {
    final token = await AuthStorage.getToken();

    try {
      if (token != null && token.isNotEmpty) {
        await http.post(
          Uri.parse("$baseUrl/logout"),
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


 static Future<Map<String, dynamic>> createTenantFirm({
  required String cariAdi,
  required String tc_no,
  required String vergiNo,
}) async {
  final Map<String, String> queryParams = {
    "firma_unvan": cariAdi,
  };

  // BİRİNİ GÖNDERECEK
  if (tc_no.isNotEmpty) {
    queryParams["firma_TCkimlik"] = tc_no;
  } else {
    queryParams["firma_FVergiNo"] = vergiNo;
  }

  final url = Uri.parse(
    "$baseUrl/tenant/tenant-firm-create",
  ).replace(queryParameters: queryParams);

  final response = await http.post(url);

  if (response.statusCode == 200 && response.body.isNotEmpty) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  throw Exception(
    "firms kaydı başarısız oldu. ${response.statusCode}: ${response.body}",
  );
}

}



