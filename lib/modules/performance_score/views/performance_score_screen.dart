import 'package:flutter/material.dart';
import 'package:nesticope_app/modules/performance_score/views/widgets/engagement_tile.dart';
import 'package:nesticope_app/modules/performance_score/views/widgets/media_breakdown_tile.dart';
import 'package:nesticope_app/modules/performance_score/views/widgets/score_component_tile.dart';
import 'package:nesticope_app/modules/performance_score/views/widgets/score_gauge.dart';

import '../../../app/constants/color_res.dart';
import '../../../data/network/builder/model/builder_model.dart';
import '../../../data/network/property/models/analytics_model.dart';

class PerformanceScoreWidget extends StatelessWidget {
  final ScoreBreakdownModel score;
  final bool showDivider;
  final Color? color;
  final double? margin;
  final ProjectItem? project;

  const PerformanceScoreWidget({
    super.key,
    required this.score,
    this.showDivider = true,
    this.color,
    this.margin,
    this.project,
  });

  @override
  Widget build(BuildContext context) {
    final components = score.components;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: margin ?? 12),

        // Overall Gauge
        ScoreGauge(
          totalScore: score.totalScore,
          maxScore: score.maxScore,
          color: color,
        ),

        if (showDivider)
          Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
        SizedBox(height: margin ?? 12),

        // Components Overview
        ScoreComponentTile(components: components, color: color),

        if (showDivider)
          Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
        SizedBox(height: margin ?? 12),

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
          color: color,
        ),

        if (showDivider)
          Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
        SizedBox(height: margin ?? 12),

        //  Engagement Breakdown
        // EngagementTile(breakdown: components.engagement.breakdown),
        if (project != null) ...[
          EngagementPieChart(
            /*  breakdown: components.engagement.breakdown,*/
            breakdown: {
              "totalViews": project?.totalViews ?? 0,
              "totalInquiries": project?.totalInquiries ?? 0,
              "totalShares": project?.totalShares ?? 0,
              "totalFavorites": project?.totalFavorites ?? 0,
              // "totalViews":project?.totalViews??0,
            },
            color: color,
          ),
        ] else ...[
          EngagementSubBreakDownPieChart(
            breakdown: components.engagement.breakdown,
            // breakdown: {
            //   "totalViews":project?.totalViews??0,
            //   "totalInquiries":project?.totalInquiries??0,
            //   "totalShares":project?.totalShares??0,
            //   "totalFavorites":project?.totalFavorites??0,
            //   // "totalViews":project?.totalViews??0,
            // },
            color: color,
          ),
        ],
      ],
    );
  }
}
