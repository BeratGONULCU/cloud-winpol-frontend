class BranchReportSummary {
  final int? subeNo;
  final String? name;
  final String? telefon;
  final String? cadde;
  final String? mahalle;
  final String? sokak;
  final String? aptNo;
  final String? ilce;
  final String? sehir;
  final String? ulke;

  BranchReportSummary({
    this.subeNo,
    this.name,
    this.telefon,
    this.cadde,
    this.mahalle,
    this.sokak,
    this.aptNo,
    this.ilce,
    this.sehir,
    this.ulke,
  });

  factory BranchReportSummary.fromJson(Map<String, dynamic> json) {
    return BranchReportSummary(
      subeNo: json['Şube No'],
      name: json['Şube Adı']?.toString(),
      telefon: json['Telefon']?.toString(),
      cadde: json['Cadde']?.toString(),
      mahalle: json['Mahalle']?.toString(),
      sokak: json['Sokak']?.toString(),
      aptNo: json['Apt. No']?.toString(),
      ilce: json['İlçe']?.toString(),
      sehir: json['Şehir']?.toString(),
      ulke: json['Ülke']?.toString(),
    );
  }
}
