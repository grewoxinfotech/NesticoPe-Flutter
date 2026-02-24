import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../../app/constants/app_font_sizes.dart';

class PropertyDistributionPieGraph extends StatefulWidget {
  final Map<String, dynamic> breakdown;
  final Color? color;

  const PropertyDistributionPieGraph({
    super.key,
    required this.breakdown,
    this.color,
  });

  @override
  State<PropertyDistributionPieGraph> createState() =>
      _PropertyDistributionPieGraphState();
}

class _PropertyDistributionPieGraphState
    extends State<PropertyDistributionPieGraph> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final active = (widget.breakdown["active"] as int?)?.toDouble() ?? 0.0;
    final rejected = (widget.breakdown["rejected"] as int?)?.toDouble() ?? 0.0;
    final pending = (widget.breakdown["pending"] as int?)?.toDouble() ?? 0.0;

    final total = active + rejected + pending;

    List<PieChartSectionData> _chartSections() {
      if (total == 0) {
        return [
          PieChartSectionData(
            value: 1,
            title: "No Data",
            color: Colors.grey.shade300,
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ];
      }

      final sections = [
        {
          "value": active,
          "color": ColorRes.green.shade600,
          "title":
              active == 0
                  ? ""
                  : "${(active / total * 100).toStringAsFixed(0)}%",
        },
        {
          "value": rejected,
          "color": ColorRes.error,
          "title":
              rejected == 0
                  ? ""
                  : "${(rejected / total * 100).toStringAsFixed(0)}%",
        },
        {
          "value": pending,
          "color": ColorRes.homeAmber.shade600,
          "title":
              pending == 0
                  ? ""
                  : "${(pending / total * 100).toStringAsFixed(0)}%",
        },
      ];

      return List.generate(sections.length, (i) {
        final isTouched = i == touchedIndex;
        final radius = isTouched ? 65.0 : 50.0;
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
                            pieTouchResponse
                                .touchedSection!
                                .touchedSectionIndex;
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
                  "Active",
                  active.toInt().toString(),
                ),
                _legendItem(
                  ColorRes.error,
                  "Rejected",
                  rejected.toInt().toString(),
                ),
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
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            Formatter.formatNumber(num.tryParse(score) ?? 0),
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

class PropertyGrowthPieGraph extends StatefulWidget {
  final Map<String, dynamic> breakdown;
  final Color? color;

  const PropertyGrowthPieGraph({
    super.key,
    required this.breakdown,
    this.color,
  });

  @override
  State<PropertyGrowthPieGraph> createState() => _PropertyGrowthPieGraphState();
}

class _PropertyGrowthPieGraphState extends State<PropertyGrowthPieGraph> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    // Safely extract property growth categories
    final categories = {
      "Sold": (widget.breakdown["sold"] as num?)?.toDouble() ?? 0.0,
      "Unsold": (widget.breakdown["unsold"] as num?)?.toDouble() ?? 0.0,
      "Dead": (widget.breakdown["dead"] as num?)?.toDouble() ?? 0.0,
      "Duplicate": (widget.breakdown["duplicate"] as num?)?.toDouble() ?? 0.0,
    };

    // Remove empty or 0-value categories
    // final validCategories = categories.entries.where((e) => e.value > 0).toList();
    final validCategories = categories.entries.toList();

    final total = validCategories.fold<double>(0.0, (sum, e) => sum + e.value);

    List<PieChartSectionData> _chartSections() {
      if (total == 0) {
        return [
          PieChartSectionData(
            value: 1,
            title: "No Data",
            color: Colors.grey.shade300,
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ];
      }

      final colorList = [
        ColorRes.green.shade600, // Sold
        ColorRes.orangeColor.shade600, // Unsold
        ColorRes.error, // Dead
        ColorRes.homeAmber.shade600, // Duplicate
      ];

      return List.generate(validCategories.length, (i) {
        final e = validCategories[i];
        final percentage = (e.value / total * 100).toStringAsFixed(0);
        final isTouched = i == touchedIndex;
        final radius = isTouched ? 65.0 : 50.0;
        final fontSize = isTouched ? 18.0 : 14.0;

        return PieChartSectionData(
          value: e.value,
          title: "$percentage%",
          radius: radius,
          color: colorList[i % colorList.length],
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
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
                  borderData: FlBorderData(show: false),
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
                            pieTouchResponse
                                .touchedSection!
                                .touchedSectionIndex;
                      });
                    },
                  ),
                  sectionsSpace: 2,
                  centerSpaceRadius: 36,
                  sections: _chartSections(),
                ),
                duration: const Duration(milliseconds: 150),
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
                children: List.generate(validCategories.length, (i) {
                  final e = validCategories[i];
                  final colorList = [
                    ColorRes.green.shade600,
                    ColorRes.orangeColor.shade600,
                    ColorRes.error,
                    ColorRes.homeAmber.shade600,
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
                style: TextStyle(fontSize: 14, color: Colors.black54),
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
          Formatter.formatNumber(num.tryParse(score) ?? 0),
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

class LeadFunnelChart extends StatelessWidget {
  final Map<String, dynamic>? stageBreakdown;

  const LeadFunnelChart({super.key, this.stageBreakdown});

  @override
  Widget build(BuildContext context) {
    log("Funnel Chart Data: $stageBreakdown");

    // Safely read values with fallback to 0 - handles missing fields
    final newLead =
        stageBreakdown != null && stageBreakdown!.containsKey('new_lead')
            ? (stageBreakdown!['new_lead'] ?? 0).toInt()
            : 0;
    final contacted =
        stageBreakdown != null && stageBreakdown!.containsKey('contacted')
            ? (stageBreakdown!['contacted'] ?? 0).toInt()
            : 0;
    final interested =
        stageBreakdown != null && stageBreakdown!.containsKey('interested')
            ? (stageBreakdown!['interested'] ?? 0).toInt()
            : 0;
    final siteVisit =
        stageBreakdown != null && stageBreakdown!.containsKey('site_visit')
            ? (stageBreakdown!['site_visit'] ?? 0).toInt()
            : 0;
    final sell =
        stageBreakdown != null && stageBreakdown!.containsKey('sell')
            ? (stageBreakdown!['sell'] ?? 0).toInt()
            : 0;

    // Reversed order - NEW LEAD at top, SELL at bottom
    final List<_FunnelStage> stages = [
      _FunnelStage('NEW LEAD', newLead, const Color(0xFF9B51E0)),
      _FunnelStage('CONTACTED', contacted, const Color(0xFFEB5757)),
      _FunnelStage('INTERESTED', interested, const Color(0xFF2D9CDB)),
      _FunnelStage('SITE VISIT', siteVisit, const Color(0xFF56CCF2)),
      _FunnelStage('SELL', sell, const Color(0xFF27AE60)),
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: _FunnelPainter(stages),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Legend
          Wrap(
            spacing: 16,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children:
                stages.map((stage) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: stage.color,
                          shape: BoxShape.rectangle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${stage.name}: ${Formatter.formatNumber(stage.value)}',

                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}

class _FunnelStage {
  final String name;
  final int value;
  final Color color;

  _FunnelStage(this.name, this.value, this.color);
}

class _FunnelPainter extends CustomPainter {
  final List<_FunnelStage> stages;

  _FunnelPainter(this.stages);

  @override
  void paint(Canvas canvas, Size size) {
    // Decrease height for every funnel bar
    final segmentHeight = (size.height / stages.length) * 0.7;
    final totalHeight = segmentHeight * stages.length;
    final startY = (size.height - totalHeight) / 2;

    final maxWidth = size.width * 0.95;
    final centerX = size.width / 2;

    for (int i = 0; i < stages.length; i++) {
      final stage = stages[i];
      final y = startY + (i * segmentHeight);

      // Calculate widths for trapezoid
      final topWidthRatio = 1.0 - (i * 0.13);
      final bottomWidthRatio = 1.0 - ((i + 1) * 0.13);

      final topWidth = maxWidth * topWidthRatio;
      final bottomWidth = maxWidth * bottomWidthRatio;

      // Draw trapezoid
      final path =
          Path()
            ..moveTo(centerX - topWidth / 2, y)
            ..lineTo(centerX + topWidth / 2, y)
            ..lineTo(centerX + bottomWidth / 2, y + segmentHeight)
            ..lineTo(centerX - bottomWidth / 2, y + segmentHeight)
            ..close();

      final paint =
          Paint()
            ..color = stage.color
            ..style = PaintingStyle.fill;

      canvas.drawPath(path, paint);

      // Border
      final borderPaint =
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2;

      canvas.drawPath(path, borderPaint);

      // Text
      final textSpan = TextSpan(
        text: '${stage.name}: ${stage.value}',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      final textX = centerX - textPainter.width / 2;
      final textY = y + (segmentHeight - textPainter.height) / 2;
      textPainter.paint(canvas, Offset(textX, textY));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class LeadSourceDistributionPieGraph extends StatefulWidget {
  final Map<String, dynamic> breakdown;
  final Color? color;

  const LeadSourceDistributionPieGraph({
    super.key,
    required this.breakdown,
    this.color,
  });

  @override
  State<LeadSourceDistributionPieGraph> createState() =>
      _LeadSourceDistributionPieGraphState();
}

class _LeadSourceDistributionPieGraphState
    extends State<LeadSourceDistributionPieGraph> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    // Safely extract all possible sources
    final sources = {
      "App": (widget.breakdown["app"] as num?)?.toDouble() ?? 0.0,
      "NesticoPe Site": (widget.breakdown["website"] as num?)?.toDouble() ?? 0.0,
      "Referral": (widget.breakdown["referral"] as num?)?.toDouble() ?? 0.0,
      "Social Media":
          (widget.breakdown["social_media"] as num?)?.toDouble() ?? 0.0,
      "Direct": (widget.breakdown["direct"] as num?)?.toDouble() ?? 0.0,
      "Other": (widget.breakdown["other"] as num?)?.toDouble() ?? 0.0,
    };

    // Filter out 0-value sources
    // final validSources = sources.entries.where((e) => e.value > 0).toList();
    final validSources = sources.entries.toList();

    final total = validSources.fold<double>(0.0, (sum, e) => sum + e.value);

    List<PieChartSectionData> _chartSections() {
      if (total == 0) {
        return [
          PieChartSectionData(
            value: 1,
            title: "No Data",
            color: Colors.grey.shade300,
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 12,
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
        final isTouched = i == touchedIndex;
        final radius = isTouched ? 65.0 : 50.0;
        final fontSize = isTouched ? 18.0 : 14.0;
        return PieChartSectionData(
          value: e.value,
          title: "$percentage%",
          radius: radius,
          color: colorList[i % colorList.length],
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
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
                  borderData: FlBorderData(show: false),
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
                            pieTouchResponse
                                .touchedSection!
                                .touchedSectionIndex;
                      });
                    },
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
                style: TextStyle(fontSize: 14, color: Colors.black54),
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
          Formatter.formatNumber(num.tryParse(score) ?? 0),
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






class LeadStatusDistributionPieGraph extends StatefulWidget {
  final Map<String, dynamic> breakdown;
  final Color? color;

  const LeadStatusDistributionPieGraph({
    super.key,
    required this.breakdown,
    this.color,
  });

  @override
  State<LeadStatusDistributionPieGraph> createState() =>
      _LeadStatusDistributionPieGraphState();
}

class _LeadStatusDistributionPieGraphState
    extends State<LeadStatusDistributionPieGraph> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    // Safely extract all possible sources
    final sources = {
      "New": (widget.breakdown["new"] as num?)?.toDouble() ?? 0.0,
      "Contacted": (widget.breakdown["contacted"] as num?)?.toDouble() ?? 0.0,
      "Qualified": (widget.breakdown["qualified"] as num?)?.toDouble() ?? 0.0,
      "Negotiation":
          (widget.breakdown["negotiation"] as num?)?.toDouble() ?? 0.0,
      "Lost": (widget.breakdown["lost"] as num?)?.toDouble() ?? 0.0,
      "Converted": (widget.breakdown["converted"] as num?)?.toDouble() ?? 0.0,
    };

    // Filter out 0-value sources
    // final validSources = sources.entries.where((e) => e.value > 0).toList();
    final validSources = sources.entries.toList();

    final total = validSources.fold<double>(0.0, (sum, e) => sum + e.value);

    List<PieChartSectionData> _chartSections() {
      if (total == 0) {
        return [
          PieChartSectionData(
            value: 1,
            title: "No Data",
            color: Colors.grey.shade300,
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 12,
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
        final isTouched = i == touchedIndex;
        final radius = isTouched ? 65.0 : 50.0;
        final fontSize = isTouched ? 18.0 : 14.0;
        return PieChartSectionData(
          value: e.value,
          title: "$percentage%",
          radius: radius,
          color: colorList[i % colorList.length],
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
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
              height: 230,
              child: PieChart(
                PieChartData(
                  borderData: FlBorderData(show: false),
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
                            pieTouchResponse
                                .touchedSection!
                                .touchedSectionIndex;
                      });
                    },
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
                style: TextStyle(fontSize: 14, color: Colors.black54),
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
          Formatter.formatNumber(num.tryParse(score) ?? 0),
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
