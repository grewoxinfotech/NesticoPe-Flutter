import 'package:flutter/material.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../data/network/property/models/property_model.dart';

class ScoreComponentTile extends StatelessWidget {
  final ScoreComponents components;

  ScoreComponentTile({required this.components});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Score Components",
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.leadGreyColor[800],
            ),
          ),
          SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _component(
                "Base Performance",
                components.basePerformance.score,
                components.basePerformance.max,
                Colors.red,
              ),

              SizedBox(width: 8),
              _component(
                "Media Quality",
                components.mediaQuality.score,
                components.mediaQuality.max,
                Colors.orange,
              ),
            ],
          ),

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _component(
                "Subscription Plan",
                components.subscriptionPlan.score,
                components.subscriptionPlan.max,
                Colors.green,
              ),
              SizedBox(width: 8),

              _component(
                "Premium Bonus",
                components.premium.score,
                components.premium.max,
                Colors.purple,
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              _component(
                "Engagement",
                components.engagement.score,
                components.engagement.max,
                Colors.redAccent,
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _component(String title, double score, double max, Color color) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: ColorRes.textPrimary,
                fontWeight: AppFontWeights.semiBold,
                fontSize: AppFontSizes.caption,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "${score.toStringAsFixed(2)} / ${max.toStringAsFixed(0)}",
              style: TextStyle(
                color: color,
                fontWeight: AppFontWeights.semiBold,
              ),
            ),
            SizedBox(height: 4),
            LinearProgressIndicator(
              value: score / max,
              minHeight: 7,
              borderRadius: BorderRadius.circular(10),
              color: color,
              backgroundColor: Colors.grey.shade300,
            ),
          ],
        ),
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
