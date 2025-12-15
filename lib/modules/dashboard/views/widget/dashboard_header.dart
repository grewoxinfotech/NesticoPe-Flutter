import 'package:flutter/material.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';

class DashboardHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const DashboardHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorRes.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      fontSize: AppFontSizes.large,
                      fontWeight: AppFontWeights.bold,
                      color: ColorRes.white,
                    )),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ColorRes.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorRes.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: ColorRes.white, size: 40),
          ),
        ],
      ),
    );
  }
}
