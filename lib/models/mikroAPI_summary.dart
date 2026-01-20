class MikroApiSummary {
  // Primary / Relation
  final String id; // api_Guid
  final String firmaGuid; // firma_Guid
  final int firmaSiraNo; // firma_siraNo

  // Status
  final bool isLocked; // api_kilitli

  // Connection info
  final String ip; // api_ip
  final int port; // api_port
  final String protocol; // api_protocol

  // Mikro settings
  final String firmaKodu; // api_firmakodu
  final String calismaYili; // api_calismayili
  final String? kullanici; // api_kullanici
  final String? password; // api_pw (HASHED)
  final String non_hashed_password; // api_pw (NON HASHED)
  final String? apiKey; // api_key
  final String? firmaNo; // api_firmano
  final String? subeNo; // api_subeno
  // Audit
  final String? createdUser; // api_create_user
  final DateTime createdAt; // api_create_date
  final String? lastUpdateUser; // api_lastup_user
  final DateTime? lastUpdateDate; // api_lastup_date

  MikroApiSummary({
    required this.id,
    required this.firmaGuid,
    required this.firmaSiraNo,
    required this.isLocked,
    required this.ip,
    required this.port,
    required this.protocol,
    required this.firmaKodu,
    required this.calismaYili,
    required this.createdAt,
    required this.non_hashed_password,

    this.subeNo,
    this.kullanici,
    this.password,
    this.apiKey,
    this.firmaNo,
    this.createdUser,
    this.lastUpdateUser,
    this.lastUpdateDate,
  });

  factory MikroApiSummary.fromJson(Map<String, dynamic> json) {
    return MikroApiSummary(
      id: json['api_Guid']?.toString() ?? "",
      firmaGuid: json['firma_Guid']?.toString() ?? "",
      firmaSiraNo: json['firma_siraNo'] ?? 0,

      isLocked: json['api_kilitli'] ?? false,

      ip: json['api_ip']?.toString() ?? "",
      port: json['api_port'] ?? 0,
      protocol: json['api_protocol']?.toString() ?? "http",

      firmaKodu: json['api_firmakodu']?.toString() ?? "",
      calismaYili: json['api_calismayili']?.toString() ?? "",

      kullanici: json['api_kullanici']?.toString(),
      password: json['api_pw']?.toString(),
      non_hashed_password: json['api_pw_non_hash']?.toString() ?? "",
      apiKey: json['api_key']?.toString(),
      firmaNo: json['api_firmano']?.toString(),
      subeNo: json['sube_no']?.toString(),

      createdUser: json['api_create_user']?.toString(),
      createdAt: DateTime.parse(
        json['api_create_date']?.toString() ??
            DateTime.now().toIso8601String(),
      ),

      lastUpdateUser: json['api_lastup_user']?.toString(),
      lastUpdateDate: json['api_lastup_date'] != null
          ? DateTime.parse(json['api_lastup_date'])
          : null,
    );
  }
}
