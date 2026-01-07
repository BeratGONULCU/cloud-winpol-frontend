import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/screens/mobile/admin_main_mobile.dart';
import 'package:cloud_winpol_frontend/screens/web/admin_main_web.dart' hide CustomerPanel;
import 'package:cloud_winpol_frontend/models/customer_summary.dart';

class CustomerDetailScreen extends StatelessWidget {
  final CustomerSummary customer;

  const CustomerDetailScreen({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(customer.name)),
      body: CustomerPanel(
        // burada edit modu açılır
        // isEdit: true,
        // customerId: customer.id,
      ),
    );
  }
}
