import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/modules/property_price_trend/view/widget/price_formate.dart';
import 'package:nesticope_app/modules/search_property/view/search_screen.dart';

Padding buildPriceTrendingChart(
  List<FlSpot> spots,
  double minY,
  double maxY,
  List<String> years,
  double interval,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: SizedBox(
      height: 180,
      width: 340,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(
            show: false,
            border: Border.all(color: ColorRes.blackShade26, width: 1),
          ),
          minX: 0,

          maxX: (spots.length - 1).toDouble(),
          minY: minY,
          maxY: maxY,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < years.length) {
                    return buildCommonText(
                      years[index],
                      AppFontSizes.mini,
                      FontWeight.normal,
                      ColorRes.textColor,
                      1,
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: interval,
                getTitlesWidget: (value, meta) {
                  return buildCommonText(
                    "₹${formatNumber(value)}",
                    AppFontSizes.mini,
                    FontWeight.normal,
                    ColorRes.textColor,
                    1,
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: spots,
              gradient: const LinearGradient(
                colors: [ColorRes.primary, ColorRes.primary],
              ),
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ColorRes.primary.withOpacity(0.1),
                    ColorRes.primary.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
