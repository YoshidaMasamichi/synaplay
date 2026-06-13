import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;

  const FeatureRow({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryDeep, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textMain,
            ),
          ),
        ),
      ],
    );
  }
}