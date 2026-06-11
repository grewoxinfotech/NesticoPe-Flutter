// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../data/network/property/models/analytics_model.dart';
import '../../../../data/network/property/models/property_model.dart';

// class MediaBreakdownTile extends StatelessWidget {
//   final Map<String, SubBreakdown> breakdown;
//
//   MediaBreakdownTile({required this.breakdown});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Media Breakdown",
//             style: TextStyle(
//               fontSize: AppFontSizes.body,
//               fontWeight: AppFontWeights.semiBold,
//               color: ColorRes.leadGreyColor[800],
//             ),
//           ),
//           SizedBox(height: 14),
//
//           _row("Images", breakdown["images"]),
//           _row("Videos", breakdown["videos"]),
//           _row("Documents", breakdown["documents"]),
//
//           SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
//
//   Widget _row(String label, SubBreakdown? data) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       decoration: BoxDecoration(
//         color: ColorRes.leadGreyColor.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontWeight: AppFontWeights.semiBold,
//               fontSize: AppFontSizes.bodySmall,
//             ),
//           ),
//           Row(
//             children: [
//               Text(
//                 "${data?.count ?? 0} ",
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//               Text(
//                 "(${data?.score ?? 0}/${data?.max.toStringAsFixed(0) ?? 0})",
//                 style: TextStyle(
//                   color: ColorRes.leadGreyColor[600],
//                   fontWeight: AppFontWeights.medium,
//                   fontSize: AppFontSizes.small,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BreakdownColumnChart extends StatelessWidget {
  final String title;
  final Map<String, SubBreakdown> breakdown;
  final Color? color;

  const BreakdownColumnChart({
    super.key,
    required this.title,
    required this.breakdown,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final items = breakdown.entries.toList();
    final maxY = _getMaxY(items);

    return Container(
      color: color,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Text(
              title,
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textPrimary,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 280,
              child: BarChart(
                BarChartData(
                  maxY: maxY,
                  barGroups: _buildBars(items),

                  /// Draw left and bottom axis lines
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      left: BorderSide(
                        color: Colors.black.withValues(alpha: 0.5),
                        width: 1,
                      ),
                      bottom: BorderSide(
                        color: Colors.black.withValues(alpha: 0.5),
                        width: 1,
                      ),
                      right: BorderSide(color: Colors.transparent),
                      top: BorderSide(color: Colors.transparent),
                    ),
                  ),

                  gridData: FlGridData(show: false),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final month = items[group.x.toInt()].key;
                        return BarTooltipItem(
                          '$month\n${rod.toY.toInt()}',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),

                  /// Bottom (X-axis)
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, _) {
                          if (value < 0 || value >= items.length)
                            return const SizedBox.shrink();
                          final label = items[value.toInt()].key;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              _short(label),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: AppFontWeights.medium,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    /// Left (Y-axis)
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        interval: (maxY / 5).roundToDouble(),
                        getTitlesWidget: (value, _) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
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
          ],
        ),
      ),
    );
  }

  /// Create bar groups
  List<BarChartGroupData> _buildBars(
    List<MapEntry<String, SubBreakdown>> items,
  ) {
    return List.generate(items.length, (i) {
      final entry = items[i];
      final data = entry.value;

      return BarChartGroupData(
        x: i,
        barsSpace: 4,
        barRods: [
          // /// Background MAX bar
          // BarChartRodData(
          //   toY: data.max.toDouble(),
          //   width: 22,
          //   color: ColorRes.leadGreyColor[300],
          //   borderRadius: BorderRadius.circular(0),
          // ),

          /// Foreground ACTUAL score bar
          BarChartRodData(
            toY: data.count.toDouble(),
            width: 22,
            color: ColorRes.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    });
  }

  /// Determine the Y-axis max value
  double _getMaxY(List<MapEntry<String, SubBreakdown>> items) {
    return double.tryParse(items.first.value.maxCount.toString()) ??
        10; // small headroom
  }

  /// Shorten labels if long
  String _short(String text) {
    // if (text.length <= 7) return text;
    // return text.substring(0, 7); // keeping clean on small screens
    return text.capitalize ?? '';
  }
}
