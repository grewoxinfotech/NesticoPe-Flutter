import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

import '../../../../app/constants/app_font_sizes.dart';

class StepProgress extends StatefulWidget {
  final int totalSteps;
  final int currentStep;
  final List<String>? labels;

  const StepProgress({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.labels,
  });

  @override
  State<StepProgress> createState() => _StepProgressState();
}

class _StepProgressState extends State<StepProgress> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant StepProgress oldWidget) {
    super.didUpdateWidget(oldWidget);


    if (widget.currentStep != oldWidget.currentStep) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToCurrentStep();
      });
    }
  }

  void _scrollToCurrentStep() {
    if (!_scrollController.hasClients) return;

    const double itemWidth = 100;
    double targetScrollOffset =
        (widget.currentStep * (itemWidth + 10)) - 50; // center the item
    print('Before $targetScrollOffset');

    targetScrollOffset = targetScrollOffset.clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    print('after $targetScrollOffset');

    _scrollController.animateTo(
      targetScrollOffset,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.labels != null && widget.labels!.length == widget.totalSteps)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 10,
                children: List.generate(widget.totalSteps, (i) {
                  final isCurrent = i == widget.currentStep;
                  final isCompleted = i < widget.currentStep;

                  return Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: isCompleted
                          ? Colors.green
                          : isCurrent
                          ? ColorRes.primary
                          : Colors.grey.shade300,
                    ),
                    alignment: Alignment.center,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        color: ColorRes.white,
                        fontWeight: isCurrent || isCompleted
                            ? AppFontWeights.extraBold
                            : AppFontWeights.regular,
                      ),
                      child: Text(
                        widget.labels![i],
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
      ],
    );
  }
}
