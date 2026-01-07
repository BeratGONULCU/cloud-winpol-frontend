import 'package:cloud_winpol_frontend/models/customer_action.dart';

class AdminMainArgs {
  final int tabIndex; // 0 = Müşteriler
  final CustomerAction action;

  const AdminMainArgs({
    required this.tabIndex,
    required this.action,
  });
}
