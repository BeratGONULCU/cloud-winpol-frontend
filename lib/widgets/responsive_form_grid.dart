import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:cloud_winpol_frontend/models/customer_summary.dart';

class ResponsiveFormGrid extends StatelessWidget {
  final List<Widget> children;

  const ResponsiveFormGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWeb = width > 900;

    return Wrap(
      spacing: 18,
      runSpacing: 14,
      children: children.map((c) {
        return SizedBox(
          width: isWeb ? (width > 1200 ? 360 : 300) : double.infinity,
          child: c,
        );
      }).toList(),
    );
  }
}
