import 'dart:convert';
import 'package:cloud_winpol_frontend/models/customer_summary.dart';
import 'package:cloud_winpol_frontend/service/api_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CompanyService {
  static const String baseUrl = "http://localhost:8000";

  static Future<Map<String, dynamic>> createCustomer({
    required String vergiNo,
    required String cariAdi,
    required String companyCode,
  }) async {
    final url = Uri.parse(
      "$baseUrl/companies/create-company"
      "?vergi_no=${Uri.encodeComponent(vergiNo)}"
      "&name=${Uri.encodeComponent(cariAdi)}"
      "&company_code=${Uri.encodeComponent(companyCode)}",
    );

    final response = await ApiClient.post(url);

    if (response.statusCode == 401) {
      throw Exception("Unauthorized – token gönderilmedi");
    }

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception(
      "Create company failed ${response.statusCode}: ${response.body}",
    );
  }

  /*  get companies by id  */

  static Future<Map<String, dynamic>> getCustomerById({
    required String vergi_no,
  }) async {
    final url = Uri.parse(
      "$baseUrl/companies/get-companies-by-id"
      "?vergi_no=${Uri.encodeComponent(vergi_no)}"
      );

    final response = await ApiClient.get(url);

    if (response.statusCode == 400) {
      throw Exception("Bu vergi no ile şirket kaydı bulunamadı");
      // return jsonDecode(response.body) as Map<String, dynamic>;
    }

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception("Hata: ${response.statusCode}: ${response.body}");
  }

  /**
   * 1) burada ilk önce vergi no ile compannies içerisinden şirketler alınacak varsa return 1 döner 
   * 2) eğer ki 1 nolu sorgu return 1 ise tenant-firm-create adlı endpoint çalıştırılır.
   * 3) o da status 200 (created) ise pop-up çıkarılır ve firm kaydı tamamlandı diye.
   */

  static Future<Map<String, dynamic>> getAllCustomer({
    required String vergi_no,
  }) async {
    final url = Uri.parse("$baseUrl/companies/get-all-companies");

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


  static Future<Map<String, dynamic>> editCustomer({
    required String vergiNo,
    required String cariUnvan,
    String? cariUnvan2,
    String? firma_TCkimlik,
    String? firma_FVergiDaire,
    String? firma_web_sayfasi,
  }) async {
    final queryParams = <String, String>{
      "firma_FVergiNo": vergiNo,
      "firma_unvan": cariUnvan,
    };

    if (cariUnvan2 != null && cariUnvan2.isNotEmpty) {
      queryParams["firma_unvan2"] = cariUnvan2;
    }

    if (firma_TCkimlik != null && firma_TCkimlik.isNotEmpty) {
      queryParams["firma_TCkimlik"] = firma_TCkimlik;
    }

    if (firma_FVergiDaire != null && firma_FVergiDaire.isNotEmpty) {
      queryParams["firma_FVergiDaire"] = firma_FVergiDaire;
    }

    if (firma_web_sayfasi != null && firma_web_sayfasi.isNotEmpty) {
      queryParams["firma_web_sayfasi"] = firma_web_sayfasi;
    }

    final uri = Uri.parse(
      "$baseUrl/admin/firm-init",
    ).replace(queryParameters: queryParams);

    final response = await ApiClient.post(uri);

    if (response.statusCode == 401) {
      throw Exception("Unauthorized – token gönderilmedi");
    }

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception(
      "Create company failed ${response.statusCode}: ${response.body}",
    );
  }

  static Future<Map<String, dynamic>> updateCustomer({
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

  /* bütün şirket kayıtları */
  static Future<List<CustomerSummary>> getCustomerSummaries() async {
    final res = await ApiClient.get(Uri.parse('$baseUrl/admin/all-companies'));

    if (res.statusCode != 200) {
      throw Exception("Şirketler alınamadı");
    }

    final List data = jsonDecode(res.body);
    return data.map((e) => CustomerSummary.fromJson(e)).toList();
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
}
