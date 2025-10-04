import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';

class BudgetFilter extends StatelessWidget {
  final double minValue; // slider min
  final double maxValue; // slider max
  final RangeValues values; // current range values
  final ValueChanged<RangeValues> onChanged; // callback
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              buildCommonText(
                '$minLabel : ${Formatter.formatPrice(values.start)}',
                11,
                FontWeight.w500,
                ColorRes.primary,
                1,
              ),
              const Spacer(),
              buildCommonText(
                '$maxLabel : ${Formatter.formatPrice(values.end)}',
                11,
                FontWeight.w500,
                ColorRes.primary,
                1,
              ),
            ],
          ),
        ),
        RangeSlider(
          min: minValue,
          max: maxValue,
          activeColor: ColorRes.primary,
          values: values,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
