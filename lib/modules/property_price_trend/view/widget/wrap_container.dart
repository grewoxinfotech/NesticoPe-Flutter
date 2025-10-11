import 'package:flutter/material.dart';

import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';

import '../../../../app/constants/app_font_sizes.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subText;
  final IconData? icon;
  final Color? iconColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subText,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 170, // fixed width for balance
      decoration: BoxDecoration(
        color: ColorRes.leadGreyColor.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Title
          buildCommonText(title, AppFontSizes.small, AppFontWeights.semiBold, ColorRes.textColor, 1),
          const SizedBox(height: 4),

          /// Value + optional icon + subtext
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: iconColor ?? ColorRes.black, size: 15),
                const SizedBox(width: 4),
              ],
              buildCommonText(
                value,
                AppFontSizes.caption,
                AppFontWeights.semiBold,
                iconColor ?? ColorRes.black,
                1,
              ),
              if (subText != null) ...[
                const SizedBox(width: 4),
                buildCommonText(
                  subText ?? '',
                  AppFontSizes.extraSmall,
                  AppFontWeights.regular,
                  ColorRes.leadGreyColor,
                  1,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
