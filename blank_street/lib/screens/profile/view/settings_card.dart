import 'package:blank_street/screens/profile/view/profile_screen.dart';
import 'package:blank_street/screens/profile/view/row_item.dart';
import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({required this.children});
  final List<RowItem> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3EA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ProfileScreen.beige),
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                indent: 12,
                endIndent: 12,
                color: ProfileScreen.beige.withOpacity(0.8),
              ),
          ],
        ],
      ),
    );
  }
}
