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
import 'package:housing_flutter_app/app/constants/color_res.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../data/network/property/models/analytics_model.dart';
import '../../../../data/network/property/models/property_model.dart';

class EngagementPieChart extends StatelessWidget {
  final Map<String, SubBreakdown> breakdown;
  final Color? color;

  const EngagementPieChart({super.key, required this.breakdown, this.color});

  @override
  Widget build(BuildContext context) {
    final favorites = breakdown["favorites"]?.count.toDouble() ?? 0;
    final inquiries = breakdown["inquiries"]?.count.toDouble() ?? 0;
    final views = breakdown["views"]?.count.toDouble() ?? 0;

    final total = favorites + inquiries + views;

    List<PieChartSectionData> _chartSections() {
      if (total == 0) {
        return [
          PieChartSectionData(
            value: 1,
            title: "No Data",
            color: Colors.grey.shade300,
            radius: 70,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ];
      }

      return [
        PieChartSectionData(
          value: favorites,
          title:
              favorites == 0
                  ? ""
                  : "${(favorites / total * 100).toStringAsFixed(0)}%",
          radius: 70,
          color: ColorRes.primary,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        PieChartSectionData(
          value: inquiries,
          title:
              inquiries == 0
                  ? ""
                  : "${(inquiries / total * 100).toStringAsFixed(0)}%",
          radius: 70,
          color: ColorRes.leadTealColor,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        PieChartSectionData(
          value: views,
          title:
              views == 0 ? "" : "${(views / total * 100).toStringAsFixed(0)}%",
          radius: 70,
          color: ColorRes.purpleColor,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ];
    }

    return Container(
      color: color,
      padding: EdgeInsets.symmetric(horizontal: 12),
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
          const SizedBox(height: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 240,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 36,
                    sections: _chartSections(),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _legendItem(ColorRes.primary, "Favorites"),
                  _legendItem(ColorRes.leadTealColor, "Inquiries"),
                  _legendItem(ColorRes.purpleColor, "Views"),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
