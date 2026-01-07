import 'package:cloud_winpol_frontend/models/customer_action.dart';
import 'package:cloud_winpol_frontend/models/user_summary.dart';

class CustomerArgs {
  final CustomerAction action;
  final UserSummary? user;

  const CustomerArgs({
    required this.action,
    this.user,
  });
}
