class RoleSummary {
  final String id;
  final String name;
  final String? description;

  RoleSummary({
    required this.id,
    required this.name,
    this.description,
  });

  factory RoleSummary.fromJson(Map<String, dynamic> json) {
    return RoleSummary(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
