import 'dart:convert';
import 'package:cloud_winpol_frontend/models/branch_summary_old.dart';
import 'package:cloud_winpol_frontend/models/mikroAPI_summary.dart';
import 'package:cloud_winpol_frontend/service/api_client.dart';
import 'package:cloud_winpol_frontend/service/auth_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class MikroService {
  static const String baseUrl = 'http://localhost:8000';

  // MİKRO BAĞLANTI SERVİSİ

  static Future<Map<String, dynamic>> connectMikroWithBody({
    required String endpoint,
    required String db_name,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl/test/mikro/$endpoint?db_name=$db_name');

    final Map<String, dynamic> payload = {
      "SQLSorgu":
          "SELECT sth_stok_kod, SUM(sth_miktar * CASE WHEN sth_evraktip IN (1,2,3) THEN 1 WHEN sth_evraktip IN (4,5,6) THEN -1 ELSE 0 END) AS mevcut_stok FROM STOK_HAREKETLERI WHERE sth_stok_kod = 'Bilgi.Knt.0001' GROUP BY sth_stok_kod",
    };

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

  static Future<Map<String, dynamic>> getStockByStoKod({
    required String endpoint,
    required String db_name,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl/test/mikro/$endpoint?db_name=$db_name');

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

  /* depo verileri getiren kod */
  static Future<Map<String, dynamic>> getWarehouse({
    required String endpoint,
    required String db_name,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl/test/mikro/$endpoint?db_name=$db_name');

    final Map<String, dynamic> payload = {
      "SQLSorgu":
          "select dep_Guid, dep_subeno, dep_firmano, dep_adi, dep_no, dep_hareket_tipi from DEPOLAR",
    };

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

  /* mikro API bağlantısı için servis metotları */

  /* mikro kaydı servisi /tenant/get-mikro-info */

  static Future<List<MikroApiSummary>> getMikroInfo() async {
    final token = await AuthStorage.getToken();

    final uri = Uri.parse("$baseUrl/tenant/get-mikro-info");

    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      // backend object dönüyor
      if (decoded is Map<String, dynamic>) {
        return [MikroApiSummary.fromJson(decoded)];
      }

      if (decoded is List) {
        return decoded.map((e) => MikroApiSummary.fromJson(e)).toList();
      }

      return [];
    }

    throw Exception("Mikro Bilgileri alınamadı (HTTP ${response.statusCode})");
  }

  // mikro kayıt ekleme servisi /tenant/push-mikro-info
  static Future<void> pushMikroInfo({
    required String apiIp,
    required int apiPort,
    required String apiProtocol,
    required String apiFirmaKodu,
    required String apiCalismaYili,
    required String apiKullanici,
    required String apiPw,
    required String apiKey,
    required String apiFirmaNo,
  }) async {
    final uri = Uri.parse("$baseUrl/tenant/push-mikro-info");

    final Map<String, dynamic> body = {
      "api_ip": apiIp,
      "api_port": apiPort,
      "api_protocol": apiProtocol,
      "api_firmakodu": apiFirmaKodu,
      "api_calismayili": apiCalismaYili,
      "api_kullanici": apiKullanici,
      "api_pw": apiPw,
      "api_key": apiKey,
      "api_firmano": apiFirmaNo,
    };

    final response = await ApiClient.put(
      Uri.parse("$baseUrl/tenant/push-mikro-info"),
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Mikro API bilgileri güncellenemedi "
        "(HTTP ${response.statusCode}): ${response.body}",
      );
    }
  }
}
