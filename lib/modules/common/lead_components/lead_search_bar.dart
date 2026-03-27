import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'lead_helpers.dart';

/// Reusable Lead Search Bar Widget
class LeadSearchBar extends StatelessWidget {
  final Function(String) onSearchChanged;
  final String hintText;

  const LeadSearchBar({
    Key? key,
    required this.onSearchChanged,
    this.hintText = 'Search buyer leads...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(getResponsivePadding(context)),
      padding: EdgeInsets.symmetric(horizontal: getResponsivePadding(context)),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      child: TextField(
        onChanged: onSearchChanged,
        style: TextStyle(fontSize: AppFontSizes.medium),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: AppFontSizes.medium),
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
