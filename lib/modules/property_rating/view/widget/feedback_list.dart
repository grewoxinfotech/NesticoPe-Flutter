import 'package:flutter/material.dart';

import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/modules/search_property/view/search_screen.dart';

import '../../../../app/constants/app_font_sizes.dart';

List<Widget> buildFeedback(List<String> goodThings) {
  return List.generate(4, (index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

      decoration: BoxDecoration(
        border: Border.all(color: ColorRes.leadGreyColor.shade400, width: 0.5),
        color: ColorRes.leadGreyColor.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: buildCommonText(
        goodThings[index],
        AppFontSizes.extraSmall,
        AppFontWeights.medium,
        ColorRes.textPrimary.withOpacity(0.7),
        1,
      ),
    );
  });
}
