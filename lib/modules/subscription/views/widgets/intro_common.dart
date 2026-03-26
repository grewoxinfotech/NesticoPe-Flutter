import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';

class TagChip extends StatelessWidget {
  final String text;
  final Color color;
  const TagChip({super.key, required this.text, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: ColorRes.white,
          fontSize: AppFontSizes.caption,
          fontWeight: AppFontWeights.semiBold,
        ),
      ),
    );
  }
}
