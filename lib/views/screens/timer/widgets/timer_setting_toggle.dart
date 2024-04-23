import 'package:flutter/material.dart';

class SettingToggle extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SettingToggle({
    super.key,
    required this.isActive,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(isActive ? icon : Icons.close),
            const SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}
