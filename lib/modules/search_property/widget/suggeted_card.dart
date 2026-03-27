import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/modules/search_property/view/search_screen.dart';

import 'package:nesticope_app/app/constants/app_font_sizes.dart';

class SuggestionCardList extends StatelessWidget {
  final String address;
  final String propertyType;
  final String state;
  // final dynamic price;
  final VoidCallback? onTap;
  final double? cardHeight;

  const SuggestionCardList({
    super.key,
    this.onTap,
    required this.address,
    required this.propertyType,
    // required this.price,
    this.cardHeight,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSpacing.large * 5.5,
        height: cardHeight ?? AppSpacing.large * 2.7,
        margin: const EdgeInsets.symmetric(vertical: AppPadding.small),
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.small,
          vertical: AppPadding.small,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: ColorRes.leadGreyColor.shade500, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildCommonText(
              address,
              AppFontSizes.small,
              AppFontWeights.semiBold,
              ColorRes.textColor,
              1,
            ),
            AppSpacing.verticalSmall,
            buildCommonText(
              propertyType,
              AppFontSizes.extraSmall,
              AppFontWeights.regular,
              ColorRes.leadGreyColor.shade600,
              1,
            ),
            AppSpacing.verticalSmall,
            buildCommonText(
              '$state',
              AppFontSizes.bodySmall,
              AppFontWeights.medium,
              ColorRes.leadGreyColor.shade600,
              1,
            ),
          ],
        ),
      ),
    );
  }
}
