import 'package:flutter/material.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const MetricCard({super.key, required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Icon(icon, color: color),
          ),
          const Spacer(),
          Text(title,
              style: TextStyle(color: ColorRes.textSecondary)),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                fontSize: AppFontSizes.medium,
                fontWeight: AppFontWeights.bold,
              )),
        ],
      ),
    );
  }
}
