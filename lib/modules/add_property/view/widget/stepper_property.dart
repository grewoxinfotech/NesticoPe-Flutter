import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

class MultiSelectChip extends StatelessWidget {
  final List<String> options;
  final List<String> selectedItems;
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
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children:
          options.map((option) {
            final bool selected = selectedItems.contains(option);

            return GestureDetector(
              onTap: () => onTap(option),
              child: Container(
                width: 158,
                padding: padding,
                decoration: BoxDecoration(
                  color:
                      selected
                          ? ColorRes.primary.withOpacity(0.1)
                          : Colors.white,
                  border: Border.all(
                    color: selected ? Colors.transparent : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                alignment: Alignment.center,
                child: Text(
                  option,
                  style: TextStyle(
                    color: selected ? ColorRes.primary : ColorRes.textPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: AppFontSizes.small,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
