import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../data/network/property/models/analytics_model.dart';
import '../../../../data/network/property/models/property_model.dart';

class ScoreBarChart extends StatelessWidget {
  final ScoreComponents components;
  final Color? color;
  const ScoreBarChart({super.key, required this.components, this.color});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Adjust bar width based on screen size
    final barWidth = (screenWidth < 350 ? 14 : 20).toDouble();
    final chartHeight = (screenWidth < 350 ? 230 : 260).toDouble();

    final data = [
      _barData(
        "Base",
        components.basePerformance.score,
        components.basePerformance.max,
        barWidth,
      ),
      _barData(
        "Sub",
        components.subscriptionPlan.score,
        components.subscriptionPlan.max,
        barWidth,
      ),
      _barData(
        "Media",
        components.mediaQuality.score,
        components.mediaQuality.max,
        barWidth,
      ),
      _barData(
        "Eng",
        components.engagement.score,
        components.engagement.max,
        barWidth,
      ),
      _barData(
        "Premium",
        components.premium.score,
        components.premium.max,
        barWidth,
      ),
    ];

    return Container(
      color: color,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Score Breakdown by Component",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12),

          /// **Horizontal scroll support for small screens**
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: math.max(screenWidth, 550), // Minimum safe width
              height: chartHeight,
              child: BarChart(
                BarChartData(
                  maxY: 35,
                  barGroups: data,
                  gridData: FlGridData(show: false),

                  /// Bottom labels optimized
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 32,
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final labels = [
                            "Base",
                            "Sub",
                            "Media",
                            "Eng",
                            "Prem",
                          ];

                          if (value.toInt() < 0 ||
                              value.toInt() >= labels.length)
                            return SizedBox();

                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              labels[value.toInt()],
                              style: TextStyle(
                                fontSize: screenWidth < 350 ? 10 : 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _barData(
    String label,
    double score,
    double max,
    double barWidth,
  ) {
    return BarChartGroupData(
      x: _xIndex(label),
      barRods: [
        BarChartRodData(
          toY: max,
          color: Colors.grey.shade300,
          width: barWidth,
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: score,
          color: Colors.blueAccent,
          width: barWidth,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  int _xIndex(String label) =>
      ["Base", "Sub", "Media", "Eng", "Premium"].indexOf(label);
}
