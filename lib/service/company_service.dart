import 'dart:convert';
import 'package:cloud_winpol_frontend/service/api_client.dart';
import 'package:flutter/material.dart';

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

  static Future<Map<String, dynamic>> getAllCustomer({
    required String vergi_no
  }) async {
    final url = Uri.parse(
      "$baseUrl/admin//get-all-companies"
    );

    final response = await ApiClient.get(url);

    if(response.statusCode == 400)
    {
      throw Exception("herhangi bir şirket kaydı bulunamadı");
     // return jsonDecode(response.body) as Map<String, dynamic>;
    }

    if(response.statusCode == 200)
    {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    
    throw Exception(
      "Hata: ${response.statusCode}: ${response.body}",
    );

  }


}
