import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/modules/search_property/view/search_screen.dart';

import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../widgets/New folder/inputs/dropdown_field.dart';


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
        color: ColorRes.white,
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
                        AppFontSizes.extraSmall,
                        AppFontWeights.medium,
                        ColorRes.textColor.withOpacity(0.6),
                        1,
                      ),
                      const SizedBox(height: 4),
                      buildCommonText(
                        Formatter.formatPrice(values.start),
                        AppFontSizes.medium,
                        AppFontWeights.semiBold,
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
                        AppFontSizes.extraSmall,
                        AppFontWeights.medium,
                        ColorRes.textColor.withOpacity(0.6),
                        1,
                      ),
                      const SizedBox(height: 4),
                      buildCommonText(
                        Formatter.formatPrice(values.end),
                        AppFontSizes.medium,
                        AppFontWeights.semiBold,
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
              inactiveTrackColor: ColorRes.leadGreyColor.shade200,
              thumbColor: ColorRes.white,
              overlayColor: ColorRes.primary.withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 10,
                elevation: 2,
              ),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
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










class BudgetFilterChange extends StatefulWidget {

  final double minSelected;
  final double maxSelected;
  final ValueChanged<double?> onMinChanged;
  final ValueChanged<double?> onMaxChanged;
  final String minLabel;
  final String maxLabel;
  final List<double> budgetList;

  const BudgetFilterChange({
    super.key,

    required this.minSelected,
    required this.maxSelected,
    required this.onMinChanged,
    required this.onMaxChanged,
    required this.minLabel,
    required this.maxLabel, required this.budgetList,
  });

  @override
  State<BudgetFilterChange> createState() => _BudgetFilterChangeState();
}

class _BudgetFilterChangeState extends State<BudgetFilterChange> {



  String _formatBudget(double value) {
    if (value == 0) return "₹0";

    // Format with commas for readability
    if (value >= 10000000) {
      return "₹${(value / 10000000).toStringAsFixed(0)} Cr";
    } else if (value >= 100000) {
      return "₹${(value / 100000).toStringAsFixed(value % 100000 == 0 ? 0 : 1)} L";
    } else if (value >= 1000) {
      return "₹${(value / 1000).toStringAsFixed(0)} K";
    } else {
      return "₹${value.toStringAsFixed(0)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Labels Row
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  label: widget.minLabel,
                  value: widget.minSelected,
                  items: widget.budgetList,
                  onChanged: widget.onMinChanged,
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
                child: _buildDropdownField(
                  label: widget.maxLabel,
                  value: widget.maxSelected,
                  // Filter to show only values greater than minSelected
                  items: widget.budgetList.where((e) => e > widget.minSelected).toList(),
                  onChanged: widget.onMaxChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required double value,
    required List<double> items,
    required ValueChanged<double?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            label,
            AppFontSizes.extraSmall,
            AppFontWeights.medium,
            ColorRes.textColor.withOpacity(0.6),
            1,
          ),
          const SizedBox(height: 4),
          NesticoPeDropdownField<double>(
            value: value,
            items: items
                .map(
                  (v) => DropdownMenuItem<double>(
                value: v,
                child: Text(
                  Formatter.formatPrice(v),
                  style: TextStyle(
                    color: ColorRes.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
                .toList(),
            onChanged: (va) {
              onChanged(va);
            },
          ),
        ],
      ),
    );
  }
}

