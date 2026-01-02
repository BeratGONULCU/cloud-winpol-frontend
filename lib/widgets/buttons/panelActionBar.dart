import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'package:cloud_winpol_frontend/models/customer_action.dart';


class CustomerActionBar extends StatelessWidget {
  final CustomerAction selected;
  final ValueChanged<CustomerAction> onChanged;

  const CustomerActionBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ActionButton(
          title: "Ekle",
          icon: Icons.add,
          active: selected == CustomerAction.create,
          onTap: () => onChanged(CustomerAction.create),
        ),
        const SizedBox(width: 10),
        ActionButton(
          title: "Düzenle",
          icon: Icons.edit,
          active: selected == CustomerAction.edit,
          onTap: () => onChanged(CustomerAction.edit),
        ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.title,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary.withOpacity(0.9)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: active ? Colors.white : Colors.black54,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: active ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
