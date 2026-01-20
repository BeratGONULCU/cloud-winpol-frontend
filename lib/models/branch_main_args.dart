import 'package:cloud_winpol_frontend/models/branch_action.dart';
import 'package:cloud_winpol_frontend/models/branch_summary.dart';

class BranchArgs {
  final BranchAction action; // aynı işlemler
  final BranchReportSummary? branch;

  const BranchArgs({
    required this.action,
    this.branch,
  });
}
