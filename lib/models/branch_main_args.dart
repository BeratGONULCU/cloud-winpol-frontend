import 'package:cloud_winpol_frontend/models/branch_action.dart';
import 'package:cloud_winpol_frontend/models/branch_summary_old.dart';

class BranchArgs {
  final BranchAction action; // aynı işlemler
  final BranchSummary? branch;

  const BranchArgs({
    required this.action,
    this.branch,
  });
}
