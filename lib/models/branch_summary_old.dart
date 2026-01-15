class BranchSummary {
  final String id; // sube_Guid
  final int firmaId; // sube_bag_firma

  final bool? isLocked; // sube_kilitli

  final int? subeNo; // sube_no
  final String? name; // sube_adi
  final String? code; // sube_kodu
  final String? mersisNo; // sube_MersisNo

  // Address fields
  final String? cadde; // sube_Cadde
  final String? mahalle; // sube_Mahalle
  final String? sokak; // sube_Sokak
  final String? semt; // sube_Semt
  final String? aptNo; // sube_Apt_No
  final String? daireNo; // sube_Daire_No
  final String? postaKodu; // sube_Posta_Kodu
  final String? sehir;

  // Audit fields
  final int? createdUser; // sube_create_user
  final DateTime createdAt; // sube_create_date
  final int? lastUpdateUser; // sube_lastup_user
  final DateTime? lastUpdateDate; // sube_lastup_date

  BranchSummary({
    required this.id,
    required this.firmaId,
    required this.createdAt,

    this.isLocked,
    this.subeNo,
    this.name,
    this.code,
    this.mersisNo,

    this.cadde,
    this.mahalle,
    this.sokak,
    this.semt,
    this.aptNo,
    this.daireNo,
    this.postaKodu,
    this.sehir,

    this.createdUser,
    this.lastUpdateUser,
    this.lastUpdateDate,
  });

  factory BranchSummary.fromJson(Map<String, dynamic> json) {
    return BranchSummary(
      id: json['sube_Guid']?.toString() ?? "",
      firmaId: json['sube_bag_firma'] ?? 0,

      isLocked: json['sube_kilitli'],

      subeNo: json['sube_no'],
      name: json['sube_adi']?.toString(),
      code: json['sube_kodu']?.toString(),
      mersisNo: json['sube_MersisNo']?.toString(),

      cadde: json['sube_Cadde']?.toString(),
      mahalle: json['sube_Mahalle']?.toString(),
      sokak: json['sube_Sokak']?.toString(),
      semt: json['sube_Semt']?.toString(),
      aptNo: json['sube_Apt_No']?.toString(),
      daireNo: json['sube_Daire_No']?.toString(),
      postaKodu: json['sube_Posta_Kodu']?.toString(),
      sehir: json['sube_Il']?.toString() ?? "",

      createdUser: json['sube_create_user'],
      createdAt: DateTime.parse(
        json['sube_create_date']?.toString() ??
            DateTime.now().toIso8601String(),
      ),

      lastUpdateUser: json['sube_lastup_user'],
      lastUpdateDate: json['sube_lastup_date'] != null
          ? DateTime.parse(json['sube_lastup_date'])
          : null,
    );
  }
}
