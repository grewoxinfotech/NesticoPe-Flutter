import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StepProgress extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  const StepProgress({super.key, required this.totalSteps, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (i) {
        final active = i <= currentStep;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            height: 6,
            decoration: BoxDecoration(
              color: active ? Get.theme.colorScheme.primary : Get.theme.dividerColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}