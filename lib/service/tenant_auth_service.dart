import 'dart:convert';

import 'package:cloud_winpol_frontend/service/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_winpol_frontend/service/auth_storage.dart';

class TenantAuthService {
  //static const String baseUrl = "http://localhost:8000";
  static const String baseUrl = "/api";

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
  final token = await AuthStorage.getToken();

  if (token == null || token.isEmpty) {
    throw Exception("Oturum yok (token bulunamadı)");
  }

  final Map<String, String> queryParams = {
    "firma_unvan": cariAdi,
  };

  if (tc_no.isNotEmpty) {
    queryParams["firma_TCkimlik"] = tc_no;
  } else {
    queryParams["firma_FVergiNo"] = vergiNo;
  }

  final url = Uri.parse(
    "$baseUrl/tenant/tenant-firm-create",
  ).replace(queryParameters: queryParams);

  final response = await ApiClient.post(
    url,
    headers: {
      "Authorization": "Bearer $token",
    },
  );

  if (response.statusCode == 200 && response.body.isNotEmpty) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  throw Exception(
    "Tenant firma oluşturulamadı (${response.statusCode}): ${response.body}",
  );
}


}



