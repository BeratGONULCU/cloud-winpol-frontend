class CustomerSummary {
  final String id;
  final String name;
  final String vergiNo;
  final String companyCode;
  final String? status;
  final String? statusMessage;
  final DateTime createdAt;

  CustomerSummary({
    required this.id,
    required this.name,
    required this.vergiNo,
    required this.companyCode,
    this.status,
    this.statusMessage,
    required this.createdAt,
  });

  factory CustomerSummary.fromJson(Map<String, dynamic> json) {
    return CustomerSummary(
      id: json['id']?.toString() ?? "",
      name: json['name']?.toString() ?? "",
      vergiNo: json['vergi_no']?.toString() ?? "",
      companyCode: json['company_code']?.toString() ?? "",
      status: json['status']?.toString(),
      statusMessage: json['status_message']?.toString(),
      createdAt: DateTime.parse(
        json['created_at']?.toString() ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
