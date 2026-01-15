import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/models/branch_summary.dart';

class BranchListWidget extends StatelessWidget {
  final List<BranchReportSummary> branches;
  final bool compact;

  const BranchListWidget({
    super.key,
    required this.branches,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (branches.isEmpty) {
      return Center(
        child: Text(
          "Henüz şube bulunamadı",
          style: TextStyle(
            color: Colors.black.withOpacity(0.5),
            fontSize: 13,
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: branches.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (context, index) {
        final b = branches[index];

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: compact ? 10 : 14,
          ),
          decoration: BoxDecoration(
            color: index % 2 == 0 ? Colors.white : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              Expanded(flex: 1, child: Text(b.subeNo?.toString() ?? "-")),
              Expanded(flex: 3, child: Text(b.name ?? "-")),
              if (!compact)
                Expanded(flex: 2, child: Text(b.telefon ?? "-")),
              Expanded(flex: 2, child: Text(b.sehir ?? "-")),
            ],
          ),
        );
      },
    );
  }
}
