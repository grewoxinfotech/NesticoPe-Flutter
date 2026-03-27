import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';

class StepChipsRow extends StatefulWidget {
  final int selectedIndex;
  final List<String> steps;

  const StepChipsRow({
    super.key,
    required this.selectedIndex,
    required this.steps,
  });

  @override
  State<StepChipsRow> createState() => _StepChipsRowState();
}

class _StepChipsRowState extends State<StepChipsRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          widget.steps.asMap().entries.map((entry) {
            int idx = entry.key;
            String step = entry.value;

            bool isSelected = idx == widget.selectedIndex;
            bool isCompleted = idx < widget.selectedIndex;

            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isCompleted
                            ? ColorRes.success
                            : isSelected
                            ? ColorRes.primary
                            : ColorRes.leadGreyColor.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    step,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorRes.white,
                      fontWeight:
                          isSelected || isCompleted
                              ? AppFontWeights.extraBold
                              : AppFontWeights.regular,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Connector line (except last step)
                // if (idx != steps.length - 1)
                //   Container(
                //     margin: const EdgeInsets.symmetric(vertical: 6),
                //     height: 2,
                //     width: double.infinity,
                //     color: isCompleted ? Colors.green : Colors.grey.shade300,
                //   ),
              ],
            );
          }).toList(),
    );
  }
}
