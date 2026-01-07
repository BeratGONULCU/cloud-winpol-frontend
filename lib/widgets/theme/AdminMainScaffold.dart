import 'package:cloud_winpol_frontend/screens/web/admin_main_web.dart';
import 'package:flutter/material.dart';

import 'package:cloud_winpol_frontend/models/customer_action.dart';
import 'package:cloud_winpol_frontend/widgets/navigation/admin_app_draver.dart';
import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/screens/settings/settings_screen.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:cloud_winpol_frontend/widgets/buttons/panelActionBar.dart';
import 'package:cloud_winpol_frontend/service/company_service.dart';
import 'package:cloud_winpol_frontend/widgets/buttons/submit_button.dart';
import 'package:cloud_winpol_frontend/widgets/theme/admin_toolbar.dart';
import 'package:cloud_winpol_frontend/widgets/theme/admin_tab.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';

import 'package:flutter/services.dart';


class _AdminToolbar extends StatelessWidget {
  final List<AdminTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _AdminToolbar({
    required this.tabs,
    required this.selectedIndex,
    required this.onSelect,
  });
  

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isCompact = width < 600;
    final isScrollable = width < 900;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(tabs.length, (i) {
        final selected = i == selectedIndex;

        return GestureDetector(
          onTap: () => onSelect(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 12 : 14,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primary.withOpacity(0.9)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  tabs[i].icon,
                  size: 18,
                  color: selected
                      ? Colors.white
                      : Colors.black.withAlpha(135),
                ),
                if (!isCompact) ...[
                  const SizedBox(width: 6),
                  Text(
                    tabs[i].title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: selected
                          ? Colors.white
                          : Colors.black.withOpacity(0.65),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.body,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.black12),
              ),
              child: isScrollable
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: content,
                    )
                  : content,
            ),
          ),
        ),
      ),
    );
  }
}


class AdminMainScaffold extends StatelessWidget {
  final bool toolbarBottom;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final List<AdminTab> tabs;


  const AdminMainScaffold({
    required this.toolbarBottom,
    required this.selectedIndex,
    required this.onSelect,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!toolbarBottom)
          _AdminToolbar(
            tabs: tabs,
            selectedIndex: selectedIndex,
            onSelect: onSelect,
          ),

        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Padding(
              key: ValueKey(selectedIndex),
              padding: const EdgeInsets.all(16),
              child: tabs[selectedIndex].widget,
            ),
          ),
        ),

        if (toolbarBottom)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _AdminToolbar(
              tabs: tabs,
              selectedIndex: selectedIndex,
              onSelect: onSelect,
            ),
          ),
      ],
    );
  }
}
