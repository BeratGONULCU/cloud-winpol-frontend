import 'dart:convert';
import 'package:cloud_winpol_frontend/models/customer_summary.dart';
import 'package:cloud_winpol_frontend/models/role_summary.dart';
import 'package:cloud_winpol_frontend/models/user_summary.dart';
import 'package:cloud_winpol_frontend/service/api_client.dart';
import 'package:cloud_winpol_frontend/service/auth_storage.dart';
import 'package:cloud_winpol_frontend/service/mikro_connection_service.dart';
import 'package:http/http.dart' as http;

class CompanyService {
  //static const String baseUrl = "http://localhost:8000";
  static const String baseUrl = "/api";

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

    final response = await ApiClient.post(url, headers: {});

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
      "?vergi_no=${Uri.encodeComponent(vergi_no)}",
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

    final response = await ApiClient.post(uri, headers: {});

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

  // ============================================================
  // GET ALL USERS (SESSION FIRM)
  // ============================================================
  // ============================================================
  // GET ALL USERS (MIKRO PERSONELLER)
  // ============================================================
  static Future<List<UserSummary>> getAllUsers() async {
    try {
      final tenantdb = await MikroService.getTenantName();

      final response = await MikroService.connectMikroWithBody(
        endpoint: 'SqlVeriOkuV2',
        db_name: tenantdb,
        body: {
          "SQLSorgu": """
          SELECT
            per_Guid,
            per_kod,
            per_adi,
            per_soyadi,
            Per_PersMailAddress,
            per_tel_cepno
          FROM PERSONELLER
          ORDER BY per_kod ASC
        """,
        },
      );

      final data = response['result']?[0]?['Data']?[0]?['SQLResult1'];

      if (data == null) return [];

      return List<Map<String, dynamic>>.from(
        data,
      ).map(UserSummary.fromMikro).toList();
    } catch (e) {
      throw Exception("Mikro personeller alınamadı: $e");
    }
  }

  // ============================================================
  // CREATE USER (MIKRO PERSONEL)
  // ============================================================

  static Future<void> createUser(Map<String, dynamic> body) async {
    final String? firstName = body['firstName']?.toString().trim();
    final String? lastName = body['lastName']?.toString().trim();
    final String email = body['email']?.toString().trim() ?? "";
    final String phone = body['phone']?.toString().trim() ?? "";

    if (firstName == null || firstName.isEmpty) {
      throw Exception("Ad zorunludur");
    }
    if (lastName == null || lastName.isEmpty) {
      throw Exception("Soyad zorunludur");
    }

    // ================= TENANT DB =================
    final tenantdb = await MikroService.getTenantName();

    // ================= MIKRO SETTINGS =================
    final mikroList = await MikroService.getMikroInfo();
    if (mikroList.isEmpty) {
      throw Exception("Mikro API ayarları bulunamadı");
    }
    final mikro = mikroList.first;

    final firmaKodu = mikro.firmaKodu;
    final calismaYiliStr = mikro.calismaYili;
    final kullaniciKodu = mikro.kullanici ?? "";
    final sifre = mikro.password ?? "";
    final apiKey = mikro.apiKey ?? "";

    if (firmaKodu.isEmpty ||
        calismaYiliStr.isEmpty ||
        kullaniciKodu.isEmpty ||
        sifre.isEmpty) {
      throw Exception("Mikro bağlantı bilgileri eksik");
    }

    final calismaYili = int.tryParse(calismaYiliStr) ?? 0;
    if (calismaYili == 0) {
      throw Exception("CalismaYili geçersiz");
    }

    // ================= per_kod =================
    final String perKod = body['per_kod']?.toString().trim().isNotEmpty == true
        ? body['per_kod'].toString().trim()
        : DateTime.now().millisecondsSinceEpoch.toString().substring(7);

    // ================= PERSONEL KAYDET =================
    final insertResponse = await MikroService.connectMikroWithBody(
      endpoint: "PersonelKaydetV2",
      db_name: tenantdb,
      body: {
        "Mikro": {
          "FirmaKodu": firmaKodu,
          "CalismaYili": calismaYili,
          "KullaniciKodu": kullaniciKodu,
          "ApiKey": apiKey,
          "Sifre": sifre,
          "personeller": [
            {
              "per_kod": perKod,
              "per_adi": firstName,
              "per_soyadi": lastName,
              "per_ucret": 0,
              "Per_PersMailAddress": email,
              "per_tel_cepno": phone,
              "per_muh_grpkod": "",
              "per_muh_ozelc1": "",
            },
          ],
        },
      },
    );

    final insertResult = insertResponse['result'];
    if (insertResult == null || insertResult.isEmpty) {
      throw Exception("Mikro PersonelKaydetV2 response boş");
    }
    if (insertResult.first['IsError'] == true) {
      throw Exception(
        insertResult.first['Message'] ?? "Mikro personel kaydı başarısız",
      );
    }

    // ================= SQL OKUMA =================
    String? perGuid;

    // dene ama zorunlu değil
    try {
      final sqlResponse = await MikroService.connectMikroWithBody(
        endpoint: "SQLVeriOkuV2",
        db_name: tenantdb,
        body: {
          "Mikro": {
            "FirmaKodu": firmaKodu,
            "CalismaYili": calismaYili,
            "KullaniciKodu": kullaniciKodu,
            "ApiKey": apiKey,
            "Sifre": sifre,
            "SQLSorgu":
                "SELECT TOP 1 per_Guid FROM PERSONELLER WHERE per_kod = '$perKod'",
          },
        },
      );

      final resultList = sqlResponse['result'];
      if (resultList != null &&
          resultList.isNotEmpty &&
          resultList.first['IsError'] == false) {
        final data = resultList.first['Data'];
        if (data != null &&
            data.isNotEmpty &&
            data.first['SQLResult1'] != null &&
            data.first['SQLResult1'].isNotEmpty) {
          perGuid = data.first['SQLResult1'].first['per_Guid']
              ?.toString()
              .replaceAll('{', '')
              .replaceAll('}', '');
        }
      }
    } catch (_) {}

    // ================= TENANT REGISTER (ASLA SKIP OLMAZ) =================
    await CompanyService.registerUserWithMikro(
      username: firstName + lastName,
      password: body['password']?.toString() ?? "",
      mikroPersonelGuid: perGuid ?? body['mikroPersonelGuidFallback'] ?? "",
      mikroPersonelKod: perKod,
      role_id: body['role_id']?.toString(),
      longName: "$firstName $lastName",
      cepTel: phone,
      email: email,
    );
  }

  static Future<Map<String, dynamic>> registerUserWithMikro({
    required String username,
    required String password,
    required String mikroPersonelGuid,
    required String mikroPersonelKod,
    String? role_id,
    String? longName,
    String? cepTel,
    String? email,
  }) async {
    final Map<String, String> queryParams = {
      "username": username.trim(),
      "password": password,

      // KRİTİK – DAHA ÖNCE YOKTU
      "mikroPersonelGuid": mikroPersonelGuid,
      "mikroPersonelKod": mikroPersonelKod,
    };

    if (role_id != null && role_id.trim().isNotEmpty) {
      queryParams["role_id"] = role_id.trim();
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
      "$baseUrl/tenant/user-register-with-mikro",
    ).replace(queryParameters: queryParams);

    final token = await AuthStorage.getToken(); // senin sistemine göre

    final response = await http.post(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception(
      "Kullanıcı kaydı başarısız oldu. "
      "${response.statusCode}: ${response.body}",
    );
  }

  // ============================================================
  // UPDATE USER (MIKRO PERSONEL)
  // ============================================================
  static Future<void> updateUser(
    String userId,
    Map<String, dynamic> body,
  ) async {
    final updates = <String>[];
    final tenantdb = await MikroService.getTenantName();

    void add(String key, String column) {
      final v = body[key];
      if (v != null && v.toString().trim().isNotEmpty) {
        updates.add("$column = '${v.toString().trim().replaceAll("'", "''")}'");
      }
    }

    add('firstName', 'per_adi');
    add('lastName', 'per_soyadi');
    add('email', 'Per_PersMailAddress');
    add('phone', 'per_tel_cepno');
    add('isPassive', 'per_iptal');

    if (updates.isEmpty) return;

    updates.add("per_lastup_date = GETDATE()");

    final sql =
        """
    UPDATE PERSONELLER
    SET ${updates.join(', ')}
    WHERE per_Guid = '$userId'
  """;

    await MikroService.connectMikroWithBody(
      endpoint: 'SqlVeriOkuV2',
      db_name: tenantdb,
      body: {"SQLSorgu": sql},
    );
  }

  static Future<List<RoleSummary>> getAllRoles() async {
    final token = await AuthStorage.getToken();
    final uri = Uri.parse("$baseUrl/tenant/get-all-roles");

    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List list = decoded['roles'] ?? [];
      return list.map((e) => RoleSummary.fromJson(e)).toList();
    }

    throw Exception("Roller alınamadı");
  }

  // ============================================================
  // CREATE ROLE (TENANT - BY VERGI NO)
  // ============================================================
  static Future<RoleSummary> createRole({
    required String name,
    required String description,
  }) async {
    if (name.trim().isEmpty) {
      throw Exception("Rol adı zorunludur");
    }

    final uri = Uri.parse(
      "$baseUrl/tenant/role-insert-vergino",
    ).replace(queryParameters: {"name": name, "description": description});

    final token = await AuthStorage.getToken();

    final response = await http.post(
      uri,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return RoleSummary.fromJson(decoded);
    }

    throw Exception(
      "Rol oluşturulamadı (${response.statusCode}): ${response.body}",
    );
  }

  // ============================================================
  // CREATE BRANCH (MIKRO SUBELER)
  // ============================================================
  static Future<void> createBranchWithKayitKaydet({
    required int subeNo,
    required String subeAdi,
    String cadde = "",
    String mahalle = "",
    String sokak = "",
    String aptNo = "",
    String ilce = "",
    String il = "",
    String ulke = "",
    String tel = "",
  }) async {
    final tenantdb = await MikroService.getTenantName();
    final mikro = (await MikroService.getMikroInfo()).first;

    final body = {
      "Mikro": {
        "FirmaKodu": mikro.firmaKodu,
        "CalismaYili": int.parse(mikro.calismaYili),
        "KullaniciKodu": mikro.kullanici,
        "ApiKey": mikro.apiKey,
        "Sifre": mikro.password,

        "Tablo": [
          {"No": "112", "KayitTipi": "1"},
        ],

        "Kayit": [
          {
            "Sube_no": subeNo,
            "Sube_kodu": subeNo.toString(), // KRİTİK
            "Sube_adi": subeAdi,

            "sube_Cadde": cadde,
            "sube_Mahalle": mahalle,
            "sube_Sokak": sokak,
            "sube_Apt_No": aptNo,

            "sube_Ilce": ilce,
            "sube_Il": il,
            "sube_Ulke": ulke,

            "sube_TelNo1": tel,
          },
        ],
      },
    };

    final response = await MikroService.connectMikroWithBody(
      endpoint: 'KayitKaydetV2',
      db_name: tenantdb,
      body: body,
    );

    final result = response['result']?[0];

    if (result == null) {
      throw Exception("Mikro cevap dönmedi");
    }

    if (result['IsError'] == true) {
      throw Exception(result['ErrorMessage'] ?? 'Şube eklenemedi');
    }
  }

  // UPDATE BRANCH (MIKRO SUBELER)
  static Future<void> updateBranchWithKayitKaydet({
    required int subeNo,
    String? subeAdi,
    String? tel,
    String? cadde,
    String? mahalle,
    String? sokak,
    String? aptNo,
    String? ilce,
    String? il,
    String? ulke,
  }) async {
    final tenantdb = await MikroService.getTenantName();
    final mikro = (await MikroService.getMikroInfo()).first;

    final Map<String, dynamic> kayit = {"Sube_no": subeNo};

    // sadece dolu gelenleri ekle
    void add(String key, String? value) {
      if (value != null && value.trim().isNotEmpty) {
        kayit[key] = value.trim();
      }
    }

    add("Sube_adi", subeAdi);
    add("sube_TelNo1", tel);
    add("sube_Cadde", cadde);
    add("sube_Mahalle", mahalle);
    add("sube_Sokak", sokak);
    add("sube_Apt_No", aptNo);
    add("sube_Ilce", ilce);
    add("sube_Il", il);
    add("sube_Ulke", ulke);

    final body = {
      "Mikro": {
        "FirmaKodu": mikro.firmaKodu,
        "CalismaYili": int.parse(mikro.calismaYili),
        "KullaniciKodu": mikro.kullanici,
        "ApiKey": mikro.apiKey,
        "Sifre": mikro.password,
        "Tablo": [
          {"No": "112", "KayitTipi": "0"},
        ],
        "Kayit": [kayit],
      },
    };

    final response = await MikroService.connectMikroWithBody(
      endpoint: "KayitKaydetV2",
      db_name: tenantdb,
      body: body,
    );

    final result = response['result']?[0];
    if (result == null || result['IsError'] == true) {
      throw Exception(result?['ErrorMessage'] ?? "Şube güncellenemedi");
    }
  }
}
