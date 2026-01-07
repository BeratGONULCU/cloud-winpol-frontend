class UserSummary {
  final String id; // kullanici_Guid
  final String username; // kullanici_name
  final String email; // kullanici_EMail
  final String roleId; // role_id
  final bool isPassive; // kullanici_pasif

  final String? longName; // kullanici_LongName
  final String? phone; // kullanici_Ceptel

  final int? firmaSiraNo; // firma_siraNo
  final int? kullaniciNo; // kullanici_no

  final DateTime createdAt; // kullanici_create_date
  final DateTime? lastUpdateDate; // kullanici_lastup_date
  final DateTime? passwordChangeDate; // kullanici_SifreDegisim_date

  UserSummary({
    required this.id,
    required this.username,
    required this.email,
    required this.roleId,
    required this.isPassive,
    required this.createdAt,
    this.longName,
    this.phone,
    this.firmaSiraNo,
    this.kullaniciNo,
    this.lastUpdateDate,
    this.passwordChangeDate,
  });

  factory UserSummary.fromJson(Map<String, dynamic> json) {
    return UserSummary(
      id: json['kullanici_Guid']?.toString() ?? "",
      username: json['kullanici_name']?.toString() ?? "",
      email: json['kullanici_EMail']?.toString() ?? "",
      roleId: json['role_id']?.toString() ?? "",
      isPassive: json['kullanici_pasif'] ?? false,

      longName: json['kullanici_LongName']?.toString(),
      phone: json['kullanici_Ceptel']?.toString(),

      firmaSiraNo: json['firma_siraNo'],
      kullaniciNo: json['kullanici_no'],

      createdAt: DateTime.parse(
        json['kullanici_create_date']?.toString() ??
            DateTime.now().toIso8601String(),
      ),

      lastUpdateDate: json['kullanici_lastup_date'] != null
          ? DateTime.parse(json['kullanici_lastup_date'])
          : null,

      passwordChangeDate: json['kullanici_SifreDegisim_date'] != null
          ? DateTime.parse(json['kullanici_SifreDegisim_date'])
          : null,
    );
  }
}

