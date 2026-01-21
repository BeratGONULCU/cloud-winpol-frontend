import 'dart:convert';
import 'package:cloud_winpol_frontend/models/branch_summary_old.dart';
import 'package:cloud_winpol_frontend/models/customer_summary.dart';
import 'package:cloud_winpol_frontend/models/user_summary.dart';
import 'package:cloud_winpol_frontend/service/api_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomerService {
  //static const String baseUrl = "http://localhost:8000";
  static const String baseUrl = "http://37.27.204.97:8000";

  static Future<Map<String, dynamic>> getAllCustomer({
    required String vergi_no,
  }) async {
    final url = Uri.parse("$baseUrl/admin//get-all-companies");

    final response = await ApiClient.get(url);

    if (response.statusCode == 400) {
      throw Exception("herhangi bir şirket kaydı bulunamadı");
      // return jsonDecode(response.body) as Map<String, dynamic>;
    }

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception("Hata: ${response.statusCode}: ${response.body}");
  }

  static Future<Map<String, dynamic>> getFirmByVergiNo(String vergiNo) async {
    final uri = Uri.parse(
      "$baseUrl/tenant/get-all-firmsby-vergiNo"
      "?vergiNo=${Uri.encodeComponent(vergiNo)}",
    );

    final response = await ApiClient.get(uri);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    if (response.statusCode == 404) {
      throw Exception("Firma bulunamadı");
    }

    if (response.statusCode == 401) {
      throw Exception("Unauthorized – token geçersiz");
    }

    throw Exception(
      "Firma bilgisi alınamadı (${response.statusCode}): ${response.body}",
    );
  }

  // giriş yapılan şirket içindeki tüm kullanıcılar (çalışanlar)
  static Future<List<UserSummary>> getAllUsersBySession() async {
    final uri = Uri.parse("$baseUrl/tenant/get-all-users");
    final response = await ApiClient.get(uri);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final List list = jsonDecode(response.body);
      return list.map((e) => UserSummary.fromJson(e)).toList();
    }

    throw Exception("Kullanıcılar alınamadı");
  }

  // giriş yapılan şirket içindeki tüm şubeler
  static Future<List<BranchSummary>> getAllBranchesBySession() async {
    final uri = Uri.parse("$baseUrl/tenant/get-all-branches");
    final response = await ApiClient.get(uri);

    // Başarılı response
    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return <BranchSummary>[]; // BOŞ LİSTE
      }

      final decoded = jsonDecode(response.body);

      // API [] dönerse
      if (decoded is List) {
        return decoded.map((e) => BranchSummary.fromJson(e)).toList();
      }

      // Beklenmeyen ama 200 dönen durum
      return <BranchSummary>[];
    }

    throw Exception("Şubeler alınamadı (HTTP ${response.statusCode})");
  }
}
