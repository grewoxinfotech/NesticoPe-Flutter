import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';

class ScoreGauge extends StatelessWidget {
  final double totalScore;
  final double maxScore;
  final Color? color;

  ScoreGauge({required this.totalScore, required this.maxScore, this.color});

  @override
  Widget build(BuildContext context) {
    final percentage = (totalScore / maxScore);

    return Container(
      color: color,
      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Overall Performance Score",
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),

          SizedBox(height: 32),

          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 160,
                  width: 160,
                  child: CircularProgressIndicator(
                    value: percentage,
                    strokeWidth: 12,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(
                      percentage < 0.5 ? ColorRes.error : ColorRes.success,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      totalScore.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: AppFontSizes.heading,
                        fontWeight: AppFontWeights.bold,
                        color:
                            percentage < 0.5
                                ? ColorRes.error
                                : ColorRes.success,
                      ),
                    ),
                    Text(
                      "OUT OF ${maxScore.toStringAsFixed(0)}%",
                      style: TextStyle(
                        color: ColorRes.leadGreyColor.shade600,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 16),
          // LinearProgressIndicator(
          //   backgroundColor: ColorRes.leadGreyColor[300],
          //   minHeight: 7,
          //   borderRadius: BorderRadius.circular(10),
          //   value: percentage,
          //   valueColor: AlwaysStoppedAnimation(
          //     percentage < 0.5 ? ColorRes.error : ColorRes.success,
          //   ),
          // ),
          // SizedBox(height: 10),
          Center(
            child: Text(
              percentage < 0.5 ? "Needs Improvement" : "Good",
              style: TextStyle(
                color: percentage < 0.5 ? ColorRes.error : ColorRes.success,
                fontSize: AppFontSizes.bodySmall,
                fontWeight: AppFontWeights.semiBold,
              ),
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }

  final BoxDecoration _card = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 6,
        offset: Offset(0, 2),
      ),
    ],
  );
}
