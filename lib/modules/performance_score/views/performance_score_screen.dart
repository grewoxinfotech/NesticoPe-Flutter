import 'package:flutter/material.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';
import 'package:housing_flutter_app/modules/performance_score/views/widgets/analytics_pie_chart.dart';
import 'package:housing_flutter_app/modules/performance_score/views/widgets/engagement_tile.dart';
import 'package:housing_flutter_app/modules/performance_score/views/widgets/media_breakdown_tile.dart';
import 'package:housing_flutter_app/modules/performance_score/views/widgets/score_bar_chart.dart';
import 'package:housing_flutter_app/modules/performance_score/views/widgets/score_component_tile.dart';
import 'package:housing_flutter_app/modules/performance_score/views/widgets/score_gauge.dart';

import '../../../app/constants/color_res.dart';

class PerformanceScoreWidget extends StatelessWidget {
  final ScoreBreakdownModel score;

  const PerformanceScoreWidget({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final components = score.components;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),

        // Overall Gauge
        ScoreGauge(totalScore: score.totalScore, maxScore: score.maxScore),

        Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
        SizedBox(height: 12),

        // Components Overview
        ScoreComponentTile(components: components),

        Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
        SizedBox(height: 12),

        /// ================== Not Display ================== ///

        // Breakdown Chart
        // ScoreBarChart(components: components),
        //
        // Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
        // SizedBox(height: 12),

        /// ================================================= ///

        //  Media Breakdown
        // MediaBreakdownTile(breakdown: components.mediaQuality.breakdown),
        //
        // Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
        // SizedBox(height: 12),
        BreakdownColumnChart(
          title: "Media Breakdown",
          breakdown: {
            "images":
                components.mediaQuality.breakdown['images'] ??
                SubBreakdown(count: 0, score: 0, max: 0, maxCount: 10),
            "videos":
                components.mediaQuality.breakdown['videos'] ??
                SubBreakdown(count: 0, score: 0, max: 0, maxCount: 10),
            "documents":
                components.mediaQuality.breakdown['documents'] ??
                SubBreakdown(count: 0, score: 0, max: 0, maxCount: 10),
          },
        ),

        Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
        SizedBox(height: 12),

        //  Engagement Breakdown
        // EngagementTile(breakdown: components.engagement.breakdown),
        EngagementPieChart(breakdown: components.engagement.breakdown),
      ],
    );
  }
}
