
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

import '../../../../../../app/constants/app_font_sizes.dart';

class ServiceDistributionPieGraph extends StatelessWidget {
  final Map<String, dynamic> breakdown;

  final Color? color;

  const ServiceDistributionPieGraph({
    super.key,
    required this.breakdown,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final active = (breakdown["active"] as int?)?.toDouble() ?? 0.0;
    final rejected = (breakdown["inactive"] as int?)?.toDouble() ?? 0.0;

    final total = active + rejected;

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
          value: active,
          title:
          active == 0
              ? ""
              : "${(active / total * 100).toStringAsFixed(0)}%",
          radius: 70,
          color: ColorRes.green.shade600,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        PieChartSectionData(
          value: rejected,
          title:
          rejected == 0
              ? ""
              : "${(rejected / total * 100).toStringAsFixed(0)}%",
          radius: 70,
          color: ColorRes.error,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

            /// Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _legendItem(
                  ColorRes.green.shade600,
                  "Active",
                  active.toInt().toString(),
                ),
                _legendItem(ColorRes.error, "Inactive", rejected.toInt().toString()),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ],
    );
  }

  Widget _legendItem(Color color, String title, String score) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 5),
              Text(
                title,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Text(
            score,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: AppFontWeights.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}





