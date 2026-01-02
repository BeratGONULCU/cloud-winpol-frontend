class CustomerService {
  static Future<void> createCustomer({
    required String taxNo,
    required String name,
    required String companyCode,
  }) async {
    final payload = {
      "tax_no": taxNo,
      "name": name,
      "company_code": companyCode,
    };

    // TODO: Dio / http ile API çağrısı
    print("POST /customers → $payload");
  }
}
