import 'package:flutter/material.dart';

class _PanelContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const _PanelContainer({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
