import 'package:flutter/material.dart';

class StepChipsRow extends StatelessWidget {
  final int selectedIndex;
  final List<String> steps;

  const StepChipsRow({
    super.key,
    required this.selectedIndex,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          steps.asMap().entries.map((entry) {
            int idx = entry.key;
            String step = entry.value;

            bool isSelected = idx == selectedIndex;
            bool isCompleted = idx < selectedIndex;

            return Column(
              children: [
                // Step container with text only
                Container(
                  margin: EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isCompleted
                            ? Colors.green
                            : isSelected
                            ? Colors.blue
                            : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    step,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight:
                          isSelected || isCompleted
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(width: 8),

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
