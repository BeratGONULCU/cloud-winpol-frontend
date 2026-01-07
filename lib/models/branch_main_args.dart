import 'package:cloud_winpol_frontend/models/branch_summary.dart';
import 'package:cloud_winpol_frontend/models/customer_action.dart';

class BranchArgs {
  final CustomerAction action; // aynı işlemler
  final BranchSummary? branch;

  const BranchArgs({
    required this.action,
    this.branch,
  });
}
