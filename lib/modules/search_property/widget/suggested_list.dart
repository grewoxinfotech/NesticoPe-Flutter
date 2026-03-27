// import 'package:flutter/material.dart';
// import 'package:nesticope_app/app/constants/app_font_sizes.dart';
// import 'package:nesticope_app/app/constants/color_res.dart';
// import 'package:nesticope_app/app/constants/size_manager.dart';
// import 'package:nesticope_app/modules/search_property/view/search_screen.dart';
//
// Widget buildFilterPropertyTypes({
//   required String title,
//   required bool isSelected,
//   required bool isExpanded,
//   double height = AppSpacing.medium,
//   double width = AppSpacing.large,
//   double paddingHorizontal = AppPadding.medium,
//   double paddingVertical = AppPadding.small,
// }) {
//   if (isExpanded) {
//     return Container(
//       // height: height,
//       // width: width,
//       padding: EdgeInsets.symmetric(
//         horizontal: paddingHorizontal,
//         vertical: paddingVertical,
//       ),
//       decoration: BoxDecoration(
//         border:
//             isSelected
//                 ? null
//                 : Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
//         color: isSelected ? ColorRes.primary : ColorRes.leadGreyColor.shade100,
//         borderRadius: BorderRadius.circular(AppRadius.small),
//       ),
//       alignment: Alignment.center,
//       child: buildCommonText(
//         title,
//         AppFontSizes.small,
//         AppFontWeights.medium,
//         isSelected ? ColorRes.white : ColorRes.textColor,
//         1,
//       ),
//     );
//   } else {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: paddingHorizontal,
//         vertical: paddingVertical,
//       ),
//       decoration: BoxDecoration(
//         border:
//             isSelected
//                 ? null
//                 : Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
//         color: isSelected ? ColorRes.primary : ColorRes.leadGreyColor.shade100,
//         borderRadius: BorderRadius.circular(AppRadius.small),
//       ),
//       child: buildCommonText(
//         title,
//         AppFontSizes.small,
//         AppFontWeights.medium,
//         isSelected ? ColorRes.white : ColorRes.textColor,
//         1,
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';
import '../../../app/constants/size_manager.dart';
import '../view/search_screen.dart';

Widget buildFilterPropertyTypes({
  required String title,
  required bool isSelected,
  required bool isExpanded,
  double height = AppSpacing.medium,
  double width = AppSpacing.large,
  double paddingHorizontal = AppPadding.medium,
  double paddingVertical = AppPadding.small,
}) {
  return Container(
    // duration: const Duration(milliseconds: 200),
    height: 42,
    padding: EdgeInsets.symmetric(
      horizontal: paddingHorizontal,
      vertical: paddingVertical + 2,
    ),
    decoration: BoxDecoration(

      color: isSelected ? ColorRes.primary.withOpacity(0.1) : ColorRes.white,
      border: Border.all(
        color: isSelected ? ColorRes.primary : ColorRes.leadGreyColor.shade300,
        width: isSelected?1.8:1.5,
      ),
      borderRadius: BorderRadius.circular(10),

    ),
    child: Row(
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        buildCommonText(
          title,
          AppFontSizes.small,
          AppFontWeights.medium,
          isSelected ? ColorRes.primary : ColorRes.textColor,
          1,
        ),
      ],
    ),
  );
}

