import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';
//
// class BudgetFilter extends StatelessWidget {
//   final double minValue; // slider min
//   final double maxValue; // slider max
//   final RangeValues values; // current range values
//   final ValueChanged<RangeValues> onChanged; // callback
//   final String minLabel;
//   final String maxLabel;
//   final String minQuantityLabel;
//   final String maxQuantityLabel;
//
//   const BudgetFilter({
//     super.key,
//     required this.minValue,
//     required this.maxValue,
//     required this.values,
//     required this.onChanged,
//     required this.minLabel,
//     required this.maxLabel,
//     required this.minQuantityLabel,
//     required this.maxQuantityLabel,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Row(
//             children: [
//               buildCommonText(
//                 '$minLabel : ${Formatter.formatPrice(values.start)}',
//                 11,
//                 FontWeight.w500,
//                 ColorRes.primary,
//                 1,
//               ),
//               const Spacer(),
//               buildCommonText(
//                 '$maxLabel : ${(Formatter.formatPrice(values.end))}',
//                 11,
//                 FontWeight.w500,
//                 ColorRes.primary,
//                 1,
//               ),
//             ],
//           ),
//         ),
//         RangeSlider(
//           min: minValue,
//           max: maxValue,
//           activeColor: ColorRes.primary,
//           values: values,
//           onChanged: onChanged,
//         ),
//       ],
//     );
//   }
// }



class BudgetFilter extends StatelessWidget {
  final double minValue;
  final double maxValue;
  final RangeValues values;
  final ValueChanged<RangeValues> onChanged;
  final String minLabel;
  final String maxLabel;
  final String minQuantityLabel;
  final String maxQuantityLabel;

  const BudgetFilter({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.values,
    required this.onChanged,
    required this.minLabel,
    required this.maxLabel,
    required this.minQuantityLabel,
    required this.maxQuantityLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: ColorRes.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: ColorRes.primary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildCommonText(
                        minLabel,
                        10,
                        FontWeight.w500,
                        ColorRes.textColor.withOpacity(0.6),
                        1,
                      ),
                      const SizedBox(height: 4),
                      buildCommonText(
                        Formatter.formatPrice(values.start),
                        14,
                        FontWeight.w600,
                        ColorRes.primary,
                        1,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: ColorRes.textColor.withOpacity(0.4),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: ColorRes.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: ColorRes.primary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildCommonText(
                        maxLabel,
                        10,
                        FontWeight.w500,
                        ColorRes.textColor.withOpacity(0.6),
                        1,
                      ),
                      const SizedBox(height: 4),
                      buildCommonText(
                        Formatter.formatPrice(values.end),
                        14,
                        FontWeight.w600,
                        ColorRes.primary,
                        1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              activeTrackColor: ColorRes.primary,
              inactiveTrackColor: Colors.grey.shade200,
              thumbColor: Colors.white,
              overlayColor: ColorRes.primary.withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 10,
                elevation: 2,
              ),
              overlayShape: const RoundSliderOverlayShape(
                overlayRadius: 20,
              ),
              rangeThumbShape: const RoundRangeSliderThumbShape(
                enabledThumbRadius: 10,
                elevation: 2,
              ),
            ),
            child: RangeSlider(
              min: minValue,
              max: maxValue,
              values: values,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
