import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';

class MultiSelectChip extends StatelessWidget {
  final List<String> options;
  final RxList<String> selectedItems;
  final void Function(String option) onTap;

  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const MultiSelectChip({
    super.key,
    required this.options,
    required this.selectedItems,
    required this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wrap(
        spacing: 10,
        runSpacing: 10,
        children:
            options.map((option) {
              final bool selected = selectedItems.contains(option);

              return GestureDetector(
                onTap: () => onTap(option),
                child: Container(
                  width: (MediaQuery.of(Get.context!).size.width - 45) / 2,
                  padding: padding,
                  decoration: BoxDecoration(
                    color:
                        selected
                            ? ColorRes.primary.withOpacity(0.1)
                            : ColorRes.white,
                    border: Border.all(
                      color:
                          selected ? ColorRes.transparentColor : ColorRes.leadGreyColor.shade300,
                    ),
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    option,
                    style: TextStyle(
                      color: selected ? ColorRes.primary : ColorRes.textPrimary,
                      fontWeight: AppFontWeights.medium,
                      fontSize: AppFontSizes.small,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
