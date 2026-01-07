class MikroApiSettings {
  final String? apiGuid;
  final String? apiKey;
  final String? firmaNo;
  final String? subeNo;
  final String? veritabani;
  final String? kullanici;
  final String? sifre;
  final bool isLocked;

  MikroApiSettings({
    this.apiGuid,
    this.apiKey,
    this.firmaNo,
    this.subeNo,
    this.veritabani,
    this.kullanici,
    this.sifre,
    this.isLocked = false,
  });

  factory MikroApiSettings.fromJson(Map<String, dynamic> json) {
    return MikroApiSettings(
      apiGuid: json['api_Guid'],
      apiKey: json['api_key'],
      firmaNo: json['api_firmano'],
      subeNo: json['api_subeno'],
      veritabani: json['api_veritabani'],
      kullanici: json['api_kullanici'],
      sifre: json['api_pw'],
      isLocked: json['api_kilitli'] ?? false,
    );
  }
}
