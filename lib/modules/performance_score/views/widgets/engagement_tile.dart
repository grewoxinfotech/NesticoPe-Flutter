// import 'package:flutter/material.dart';
//
// import '../../../../app/constants/app_font_sizes.dart';
// import '../../../../app/constants/color_res.dart';
// import '../../../../data/network/property/models/property_model.dart';
//
// class EngagementTile extends StatelessWidget {
//   final Map<String, SubBreakdown> breakdown;
//
//   EngagementTile({required this.breakdown});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Engagement Metrics",
//             style: TextStyle(
//               fontSize: AppFontSizes.body,
//               fontWeight: AppFontWeights.semiBold,
//               color: ColorRes.leadGreyColor[800],
//             ),
//           ),
//           SizedBox(height: 12),
//
//           _row("Favorites", breakdown["favorites"]),
//           _row("Inquiries", breakdown["inquiries"]),
//           _row("Views", breakdown["views"]),
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
//
//   final BoxDecoration _card = BoxDecoration(
//     color: Colors.white,
//     borderRadius: BorderRadius.circular(14),
//     boxShadow: [
//       BoxShadow(
//         color: Colors.black.withOpacity(0.05),
//         blurRadius: 6,
//         offset: Offset(0, 2),
//       ),
//     ],
//   );
// }

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/color_res.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../data/network/property/models/analytics_model.dart';
class EngagementSubBreakDownPieChart extends StatefulWidget {
  final Map<String, SubBreakdown> breakdown;
  final Color? color;

  const EngagementSubBreakDownPieChart({
    super.key,
    required this.breakdown,
    this.color,
  });

  @override
  State<EngagementSubBreakDownPieChart> createState() => _EngagementSubBreakDownPieChartState();
}

class _EngagementSubBreakDownPieChartState extends State<EngagementSubBreakDownPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    /// Normalize engagement data
    final engagement = {
      "Favorites": widget.breakdown["favorites"]?.count.toDouble() ?? 0,
      "Inquiries": widget.breakdown["inquiries"]?.count.toDouble() ?? 0,
      "Views": widget.breakdown["views"]?.count.toDouble() ?? 0,
      "Visits": widget.breakdown["visits"]?.count.toDouble() ?? 0,
      "Shares": widget.breakdown["shares"]?.count.toDouble() ?? 0,
    };

    final entries = engagement.entries.toList();
    final total = entries.fold<double>(0, (sum, e) => sum + e.value);

    final colors = [
      ColorRes.primary,
      ColorRes.leadTealColor,
      ColorRes.purpleColor,
      ColorRes.orangeColor,
      ColorRes.green,
    ];

    List<PieChartSectionData> _sections() {
      if (total == 0) {
        return [
          PieChartSectionData(
            value: 1,
            title: "No Data",
            radius: 55,
            color: Colors.grey.shade300,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ];
      }

      return List.generate(entries.length, (i) {
        final e = entries[i];
        final isTouched = i == touchedIndex;
        final percentage = (e.value / total * 100).toStringAsFixed(0);

        return PieChartSectionData(
          value: e.value,
          title: e.value == 0 ? "" : "$percentage%",
          radius: isTouched ? 75 : 65,
          color: colors[i % colors.length],
          titleStyle: TextStyle(
            fontSize: isTouched ? 16 : 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      });
    }

    return Container(
      color: widget.color,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Engagement Breakdown",
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.leadGreyColor[800],
            ),
          ),
          const SizedBox(height: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 240,
                child: PieChart(
                  PieChartData(
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 2,
                    centerSpaceRadius: 36,
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              response?.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex =
                              response!.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    sections: _sections(),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// Dynamic Legend (perfectly centered)
              if (total > 0)
                Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  spacing: 18,
                  runSpacing: 10,
                  children: List.generate(entries.length, (i) {
                    final e = entries[i];
                    return _legendItem(
                      colors[i % colors.length],
                      e.key,
                      e.value.toInt(),
                    );
                  }),
                )
              else
                const Text(
                  "No data available",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String title, int value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 6),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class EngagementPieChart extends StatefulWidget {
  final Map<String, int> breakdown;
  final Color? color;

  const EngagementPieChart({
    super.key,
    required this.breakdown,
    this.color,
  });

  @override
  State<EngagementPieChart> createState() => _EngagementPieChartState();
}

class _EngagementPieChartState extends State<EngagementPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    /// Normalize engagement data
    final engagement = {
      "Total Favorites": widget.breakdown["totalFavorites"] ?? 0,
      "Total Inquiries": widget.breakdown["totalInquiries"] ?? 0,
      "Total Views": widget.breakdown["totalViews"] ?? 0,
      "Total Shares": widget.breakdown["totalShares"] ?? 0,
    };

    final entries = engagement.entries.toList();
    final total = entries.fold<double>(0, (sum, e) => sum + e.value);

    final colors = [
      ColorRes.primary,
      ColorRes.leadTealColor,
      ColorRes.purpleColor,
      ColorRes.orangeColor,

    ];

    List<PieChartSectionData> _sections() {
      if (total == 0) {
        return [
          PieChartSectionData(
            value: 1,
            title: "No Data",
            radius: 55,
            color: Colors.grey.shade300,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ];
      }

      return List.generate(entries.length, (i) {
        final e = entries[i];
        final isTouched = i == touchedIndex;
        final percentage = (e.value / total * 100).toStringAsFixed(0);

        return PieChartSectionData(
          value: e.value.toDouble(),
          title: e.value == 0 ? "" : "$percentage%",
          radius: isTouched ? 75 : 65,
          color: colors[i % colors.length],
          titleStyle: TextStyle(
            fontSize: isTouched ? 16 : 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      });
    }

    return Container(
      color: widget.color,
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Engagement Breakdown",
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 240,
                child: PieChart(
                  PieChartData(
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 2,
                    centerSpaceRadius: 36,
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              response?.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex =
                              response!.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    sections: _sections(),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// Dynamic Legend (perfectly centered)
              if (total > 0)
                Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  spacing: 18,
                  runSpacing: 10,
                  children: List.generate(entries.length, (i) {
                    final e = entries[i];
                    return _legendItem(
                      colors[i % colors.length],
                      e.key,
                      e.value.toInt(),
                    );
                  }),
                )
              else
                const Text(
                  "No data available",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String title, int value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: AppFontWeights.medium,
            color: ColorRes.leadGreyColor.shade700,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

