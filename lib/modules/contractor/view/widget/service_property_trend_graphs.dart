
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';

import '../../../../../../app/constants/app_font_sizes.dart';

class ServiceDistributionPieGraph extends StatefulWidget {
  final Map<String, dynamic> breakdown;

  final Color? color;

  const ServiceDistributionPieGraph({
    super.key,
    required this.breakdown,
    this.color,
  });

  @override
  State<ServiceDistributionPieGraph> createState() => _ServiceDistributionPieGraphState();
}

class _ServiceDistributionPieGraphState extends State<ServiceDistributionPieGraph> {
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    final active = (widget.breakdown["active"] as int?)?.toDouble() ?? 0.0;
    final rejected = (widget.breakdown["inactive"] as int?)?.toDouble() ?? 0.0;

    final total = active + rejected;
    final sections = [
      {
        "value": active,
        "color": ColorRes.green.shade600,
        "title": active == 0 ? "" : "${(active / total * 100).toStringAsFixed(0)}%",
      },
      {
        "value": rejected,
        "color": ColorRes.error,
        "title": rejected == 0 ? "" : "${(rejected / total * 100).toStringAsFixed(0)}%",
      },
    ];

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

      return List.generate(sections.length, (i) {
        final isTouched = i == touchedIndex;
        final radius = isTouched ? 60.0 : 50.0;
        final fontSize = isTouched ? 18.0 : 14.0;


        return PieChartSectionData(
          value: sections[i]["value"] as double,
          title: sections[i]["title"] as String,
          radius: radius,
          color: sections[i]["color"] as Color,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            shadows: const [Shadow(color: Colors.black38, blurRadius: 2)],
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
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex =
                            pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
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
                  "Active Services",
                  active.toInt().toString(),
                ),
                _legendItem(ColorRes.error, "Inactive Services", rejected.toInt().toString()),
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
            Formatter.formatNumber(num.tryParse(score)??0),
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





