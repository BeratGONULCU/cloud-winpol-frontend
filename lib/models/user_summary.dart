class UserSummary {
  final String id;

  final String username;
  final String email;
  final String roleId;
  final bool isPassive;

  // 🔹 AYRI AYRI
  final String firstName;
  final String lastName;

  // 🔹 Türev alan (UI compatibility için)
  final String longName;

  final String? phone;

  final int? firmaSiraNo;
  final int? kullaniciNo;

  final DateTime createdAt;
  final DateTime? lastUpdateDate;
  final DateTime? passwordChangeDate;

  UserSummary({
    required this.id,
    required this.username,
    required this.email,
    required this.roleId,
    required this.isPassive,

    required this.firstName,
    required this.lastName,
    required this.longName,

    required this.createdAt,

    this.phone,
    this.firmaSiraNo,
    this.kullaniciNo,
    this.lastUpdateDate,
    this.passwordChangeDate,
  });
  factory UserSummary.fromMikro(Map<String, dynamic> json) {
    final String cikisTarihi =
        json['per_cikis_tar']?.toString() ?? "1899-12-31 00:00:00";

    final String firstName = json['per_adi']?.toString().trim() ?? "";

    final String lastName = json['per_soyadi']?.toString().trim() ?? "";

    return UserSummary(
      id: json['per_Guid']?.toString() ?? "",

      username: json['per_kod']?.toString() ?? "",

      email: (json['Per_PersMailAddress']?.toString().isNotEmpty ?? false)
          ? json['Per_PersMailAddress']
          : "",

      roleId: "PERSONEL",

      isPassive: !cikisTarihi.startsWith("1899-12-31"),

      // 🔹 ASIL DOĞRU VERİ
      firstName: firstName,
      lastName: lastName,
      longName: "$firstName $lastName".trim(),

      phone: json['per_tel_cepno']?.toString(),

      firmaSiraNo: json['per_firma_no'],
      kullaniciNo: int.tryParse(json['per_sicil_no']?.toString() ?? ""),

      createdAt: DateTime.parse(
        json['per_create_date'] ?? DateTime.now().toIso8601String(),
      ),

      lastUpdateDate: json['per_lastup_date'] != null
          ? DateTime.parse(json['per_lastup_date'])
          : null,

      passwordChangeDate: null,
    );
  }

  factory UserSummary.fromJson(Map<String, dynamic> json) {
    final fullName = json['kullanici_LongName']?.toString() ?? "";

    final parts = fullName.trim().split(RegExp(r'\s+'));

    final firstName = parts.isNotEmpty ? parts.first : "";
    final lastName = parts.length > 1 ? parts.sublist(1).join(" ") : "";

    return UserSummary(
      id: json['kullanici_Guid']?.toString() ?? "",
      username: json['kullanici_name']?.toString() ?? "",
      email: json['kullanici_EMail']?.toString() ?? "",
      roleId: json['role_id']?.toString() ?? "",
      isPassive: json['kullanici_pasif'] ?? false,

      firstName: firstName,
      lastName: lastName,
      longName: fullName,

      phone: json['kullanici_Ceptel']?.toString(),

      firmaSiraNo: json['firma_siraNo'],
      kullaniciNo: json['kullanici_no'],

      createdAt: DateTime.parse(
        json['kullanici_create_date'] ?? DateTime.now().toIso8601String(),
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
