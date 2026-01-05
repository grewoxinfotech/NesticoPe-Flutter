import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

import '../../../../../../app/constants/app_font_sizes.dart';

class PropertyDistributionPieGraph extends StatelessWidget {
  final Map<String, dynamic> breakdown;

  final Color? color;

  const PropertyDistributionPieGraph({
    super.key,
    required this.breakdown,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final active = (breakdown["active"] as int?)?.toDouble() ?? 0.0;
    final rejected = (breakdown["rejected"] as int?)?.toDouble() ?? 0.0;
    final pending = (breakdown["pending"] as int?)?.toDouble() ?? 0.0;

    final total = active + rejected + pending;

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
        PieChartSectionData(
          value: pending,
          title:
              pending == 0
                  ? ""
                  : "${(pending / total * 100).toStringAsFixed(0)}%",
          radius: 70,
          color: ColorRes.homeAmber.shade600,
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
                _legendItem(ColorRes.error, "Rejected", rejected.toInt().toString()),
                _legendItem(
                  ColorRes.homeAmber.shade600,
                  "Pending",
                  pending.toInt().toString(),
                ),
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



class LeadSourceDistributionPieGraph extends StatelessWidget {
  final Map<String, dynamic> breakdown;
  final Color? color;

  const LeadSourceDistributionPieGraph({
    super.key,
    required this.breakdown,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Safely extract all possible sources
    final sources = {
      "App": (breakdown["app"] as num?)?.toDouble() ?? 0.0,
      "Website": (breakdown["website"] as num?)?.toDouble() ?? 0.0,
      "Referral": (breakdown["referral"] as num?)?.toDouble() ?? 0.0,
      "Social Media": (breakdown["social_media"] as num?)?.toDouble() ?? 0.0,
      "Direct": (breakdown["direct"] as num?)?.toDouble() ?? 0.0,
      "Other": (breakdown["other"] as num?)?.toDouble() ?? 0.0,
    };

    // Filter out 0-value sources
    final validSources = sources.entries.where((e) => e.value > 0).toList();

    final total = validSources.fold<double>(0.0, (sum, e) => sum + e.value);

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

      final colorList = [
        ColorRes.leadTealColor.shade600,
        ColorRes.blueColor.shade600,

        ColorRes.orangeColor.shade600,
        ColorRes.purpleColor.shade600,
        ColorRes.error.shade400,

        ColorRes.green.shade600,
      ];

      return List.generate(validSources.length, (i) {
        final e = validSources[i];
        final percentage = (e.value / total * 100).toStringAsFixed(0);
        return PieChartSectionData(
          value: e.value,
          title: "$percentage%",
          radius: 70,
          color: colorList[i % colorList.length],
          titleStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      });
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
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 2,
                  centerSpaceRadius: 36,

                  sections: _chartSections(),
                ),
                duration: Duration(milliseconds: 150), // Optional
                curve: Curves.linear,

              ),
            ),
            const SizedBox(height: 16),

            /// Dynamic Legend
            if (total > 0)
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 10,
                children: List.generate(validSources.length, (i) {
                  final e = validSources[i];
                  final colorList = [
                    ColorRes.leadTealColor.shade600,
                    ColorRes.blueColor.shade600,

                    ColorRes.orangeColor.shade600,
                    ColorRes.purpleColor.shade600,
                    ColorRes.error.shade400,

                    ColorRes.green.shade600,
                  ];
                  return _legendItem(
                    colorList[i % colorList.length],
                    e.key,
                    e.value.toInt().toString(),
                  );
                }),
              )
            else
              const Text(
                "No data available",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ],
    );
  }

  Widget _legendItem(Color color, String title, String score) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
        const SizedBox(width: 6),
        Text(
          score,
          style: TextStyle(
            fontSize: 13,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

