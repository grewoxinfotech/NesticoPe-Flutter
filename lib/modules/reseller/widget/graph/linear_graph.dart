import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/modules/reseller/widget/dashboard_widget/animated_builder_widget.dart';

import '../../../../app/constants/color_res.dart';
import '../../../../app/utils/helper_function/month_switch/month_switch.dart';
import '../../../../data/network/reseller/reseller_dashboard/model/reseller_dashboard_model.dart';

// class MonthlyBarChart extends StatelessWidget {
//   final List<double> monthlyData;
//   final List<String> months;
//
//   const MonthlyBarChart({
//     Key? key,
//     required this.monthlyData,
//     required this.months,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final maxValue = monthlyData.reduce((a, b) => a > b ? a : b);
//     print('dkfji$maxValue');
//     final maxIndex = monthlyData.indexOf(maxValue);
//     return BarChart(
//       BarChartData(
//         minY: double.tryParse(Formatter.formatPrice(10000),),
//         maxY: double.tryParse(Formatter.formatPrice(maxValue),),
//
//         groupsSpace: 12,
//         barGroups: _createBarGroups(),
//
//         // --- Titles ---
//         titlesData: FlTitlesData(
//           bottomTitles: AxisTitles(
//             //aser
//             sideTitles: SideTitles(
//               showTitles: true,
//               reservedSize: 32,
//
//               getTitlesWidget: (value, meta) {
//                 final index = value.toInt();
//                 if (index >= 0 && index < months.length && index % 2 == 0) {
//                   final monthNum = months[index].split('-')[1];
//                   return Padding(
//                     padding: const EdgeInsets.only(top: 6.0),
//                     child: Text(
//                       '${MonthDate.monthDate.monthChange(monthNum)}',
//                       style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.grey.shade700,
//                       ),
//                     ),
//                   );
//                 }
//                 return const SizedBox.shrink();
//               },
//             ),
//           ),
//           leftTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               interval: 40000,
//               reservedSize: 28,
//               getTitlesWidget: (value, meta) => Text(
//                 Formatter.formatNumber(value.toInt()),
//                 style: TextStyle(
//                   fontSize: AppFontSizes.extraSmall,
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//             ),
//           ),
//           topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         ),
//
//         // --- Grid + Border ---
//         gridData: FlGridData(
//           show: true,
//           drawVerticalLine: false,
//           getDrawingHorizontalLine: (value) => FlLine(
//             color: Colors.grey.withOpacity(0.12),
//             strokeWidth: 1,
//           ),
//         ),
//         borderData: FlBorderData(
//           show: true,
//           border: Border(
//             bottom: BorderSide(color: Colors.grey.shade300, width: 1),
//             left: BorderSide(color: Colors.grey.shade300, width: 1),
//           ),
//         ),
//
//         // --- Tooltip ---
//         barTouchData: BarTouchData(
//           enabled: true,
//           touchTooltipData: BarTouchTooltipData(
//
//             tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             getTooltipItem: (group, groupIndex, rod, rodIndex) {
//               final month = months[group.x.toInt()];
//               return BarTooltipItem(
//                 '$month\n${Formatter.formatPrice(rod.toY.toInt())}',
//                 const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 12,
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   List<BarChartGroupData> _createBarGroups() {
//     return List.generate(
//       monthlyData.length,
//           (index) {
//         return BarChartGroupData(
//           x: index,
//           barRods: [
//             BarChartRodData(
//               toY: monthlyData[index],
//               width: 5,
//               gradient: LinearGradient(
//                 colors: [
//                   ColorRes.lightPurpleColor.withOpacity(0.9), // Vibrant purple
//                   ColorRes.reportCardTextFiledHint.withOpacity(0.9), // Vibrant purple
//                    // Lighter purple
//                 ],
//                 begin: Alignment.bottomCenter,
//                 end: Alignment.topCenter,
//               ),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(2),
//                 topRight: Radius.circular(2),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

class MonthlyBarChart extends StatelessWidget {
  final List<double> monthlyData;
  final List<String> months;
  final bool isAmount;
  final Color color;

  const MonthlyBarChart({
    Key? key,
    required this.monthlyData,
    required this.months,
    this.isAmount = true,
    this.color = ColorRes.reportCardTextFiledHint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // --- Calculate Y-Axis Dynamic Range ---
    final maxValue = monthlyData.reduce((a, b) => a > b ? a : b);
    final minValue = 0.0;

    // ✅ Ensure minimum visible range up to 50
    final effectiveMax = maxValue < 20 ? 20 : maxValue;
    final yRange = effectiveMax - minValue;

    // ✅ Always create 6 Y steps (0 to max)
    final interval = (yRange / 5).ceilToDouble();

    // ✅ Round top value to next clean multiple of interval
    final adjustedMaxY = ((effectiveMax / interval).ceil()) * interval;

    return BarChart(
      BarChartData(
        minY: minValue,
        maxY: adjustedMaxY,
        groupsSpace: 12,
        barGroups: _createBarGroups(),

        // --- Titles ---
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < months.length && index % 2 == 0) {
                  final monthNum = months[index].split('-')[1];
                  return Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      MonthDate.monthDate.monthChange(monthNum),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: interval, // ✅ dynamic interval
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return isAmount
                    ? Text(
                      Formatter.formatGraphPrice(value.toInt()),

                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    )
                    : Text(
                      Formatter.formatNumber(value.toInt()),

                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),

        // --- Grid + Border ---
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine:
              (value) =>
                  FlLine(color: Colors.grey.withOpacity(0.12), strokeWidth: 1),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
            left: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),

        // --- Tooltip ---
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final month = months[group.x.toInt()];
              return BarTooltipItem(
                '$month\n${(isAmount) ? Formatter.formatPrice(rod.toY.toInt()) : Formatter.formatNumber(rod.toY.toInt())}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _createBarGroups() {
    return List.generate(monthlyData.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: monthlyData[index],
            width: 6,
            gradient: LinearGradient(
              colors: [color.withOpacity(0.9), color.withOpacity(0.9)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(3),
              topRight: Radius.circular(3),
            ),
          ),
        ],
      );
    });
  }
}

class CommissionSourceBarChart extends StatelessWidget {
  final double propertyCommission;
  final double projectCommission;

  const CommissionSourceBarChart({
    super.key,
    required this.propertyCommission,
    required this.projectCommission,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue =
        propertyCommission > projectCommission
            ? propertyCommission
            : projectCommission;
    final sum = projectCommission + propertyCommission;
    final minValue = 0.0;

    // Same logic as MonthlyBarChart
    final effectiveMax = maxValue < 20 ? 20 : maxValue;
    final yRange = effectiveMax - minValue;

    final interval = (yRange / 5).ceilToDouble();

    final adjustedMaxY = ((effectiveMax / interval).ceil()) * interval;

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              TiltingIcon(
                direction: TiltDirection.horizontal,
                icon: Icon(
                  Icons.area_chart_outlined,
                  color: ColorRes.lightPurpleColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Commission by Source',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: ColorRes.lightPurpleColor,
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),

                    Text(
                      'Total: ${Formatter.formatPrice(sum)}',

                      style: TextStyle(
                        color: ColorRes.textColor,
                        fontSize: AppFontSizes.extraSmall,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                minY: 0,
                maxY: double.tryParse(adjustedMaxY.toString()),

                alignment: BarChartAlignment.spaceAround,

                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine:
                      (value) => FlLine(
                        color: Colors.grey.withOpacity(0.12),
                        strokeWidth: 1,
                      ),
                ),

                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                    left: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: interval,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          Formatter.formatGraphPrice(value.toInt()),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                'Properties',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            );

                          case 1:
                            return const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                'Projects',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            );

                          default:
                            return const SizedBox();
                        }
                      },
                    ),
                  ),
                ),

                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        Formatter.formatPrice(rod.toY.toInt()),
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),

                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: propertyCommission,
                        width: 40,
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  ),

                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: projectCommission,
                        width: 40,
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommissionSourcePieChart extends StatefulWidget {
  final double propertyCommission;
  final double projectCommission;

  const CommissionSourcePieChart({
    super.key,
    required this.propertyCommission,
    required this.projectCommission,
  });

  @override
  State<CommissionSourcePieChart> createState() =>
      _CommissionSourcePieChartState();
}

class _CommissionSourcePieChartState extends State<CommissionSourcePieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final property = widget.propertyCommission;
    final project = widget.projectCommission;

    final total = property + project;

    final sections = [
      {
        "value": property,
        "color": ColorRes.blueColor,
        "title":
            property == 0
                ? ""
                : "${(property / total * 100).toStringAsFixed(0)}%",
      },
      {
        "value": project,
        "color": ColorRes.leadIndigoColor,
        "title":
            project == 0
                ? ""
                : "${(project / total * 100).toStringAsFixed(0)}%",
      },
    ];

    List<PieChartSectionData> chartSections() {
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

      return List.generate(sections.length, (index) {
        final isTouched = touchedIndex == index;

        return PieChartSectionData(
          value: sections[index]["value"] as double,
          title: sections[index]["title"] as String,
          color: sections[index]["color"] as Color,
          radius: isTouched ? 65 : 55,
          titleStyle: TextStyle(
            fontSize: isTouched ? 18 : 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            shadows: const [Shadow(color: Colors.black38, blurRadius: 2)],
          ),
        );
      });
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.pie_chart_outline, color: ColorRes.leadIndigoColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Source Distribution',
                      style: TextStyle(
                        color: ColorRes.leadIndigoColor,
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                    // Text(
                    //   'Total: ${Formatter.formatPrice(total.toInt())}',
                    //   style: TextStyle(
                    //     color: ColorRes.textColor,
                    //     fontSize:
                    //         AppFontSizes.extraSmall,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 240,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (event, pieTouchResponse) {
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
                centerSpaceRadius: 40,
                sections: chartSections(),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              legendItem(ColorRes.blueColor, "Properties", property),
              legendItem(ColorRes.leadIndigoColor, "Projects", project),
            ],
          ),
        ],
      ),
    );
  }

  Widget legendItem(Color color, String title, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
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
            Formatter.formatPrice(amount.toInt()),
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

/// A combined widget to show revenue sources comparison and breakdown
class RevenueSourcesWidget extends StatelessWidget {
  final Earnings earnings;

  const RevenueSourcesWidget({Key? key, required this.earnings})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxValue =
        earnings.totalCommission > earnings.potentialCommission
            ? earnings.totalCommission
            : earnings.potentialCommission;
    final sum = earnings.potentialCommission + earnings.totalCommission;
    final minValue = 0.0;

    // Same logic as MonthlyBarChart
    final effectiveMax = maxValue < 20 ? 20 : maxValue;
    final yRange = effectiveMax - minValue;

    final interval = (yRange / 5).ceilToDouble();

    final adjustedMaxY = ((effectiveMax / interval).ceil()) * interval;
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TiltingIcon(
                direction: TiltDirection.horizontal,
                icon: Icon(
                  Icons.area_chart_outlined,
                  color: ColorRes.lightPurpleColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Revenue Sources Comparison',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: ColorRes.lightPurpleColor,
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),

                    Text(
                      'Total: ${Formatter.formatPrice(sum)}',

                      style: TextStyle(
                        color: ColorRes.textColor,
                        fontSize: AppFontSizes.extraSmall,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                minY: 0,
                maxY: double.tryParse(adjustedMaxY.toString()),

                alignment: BarChartAlignment.spaceAround,

                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine:
                      (value) => FlLine(
                        color: Colors.grey.withOpacity(0.12),
                        strokeWidth: 1,
                      ),
                ),

                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                    left: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: interval,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          Formatter.formatGraphPrice(value.toInt()),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                'Earned',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            );

                          case 1:
                            return const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                'Potential',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            );

                          default:
                            return const SizedBox();
                        }
                      },
                    ),
                  ),
                ),

                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        Formatter.formatPrice(rod.toY.toInt()),
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),

                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY:
                            double.tryParse(
                              earnings.totalCommission.toString() ?? '0',
                            ) ??
                            0.0,
                        width: 40,
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  ),

                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY:
                            double.tryParse(
                              earnings.potentialCommission.toString() ?? '0',
                            ) ??
                            0.0,
                        width: 40,
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RevenueSourcesSourcePieChart extends StatefulWidget {
  final double propertyCommission;
  final double projectCommission;

  const RevenueSourcesSourcePieChart({
    super.key,
    required this.propertyCommission,
    required this.projectCommission,
  });

  @override
  State<RevenueSourcesSourcePieChart> createState() =>
      _RevenueSourcesSourcePieChartState();
}

class _RevenueSourcesSourcePieChartState
    extends State<RevenueSourcesSourcePieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final property = widget.propertyCommission;
    final project = widget.projectCommission;

    final total = property + project;

    final sections = [
      {
        "value": property,
        "color": ColorRes.blueColor,
        "title":
            property == 0
                ? ""
                : "${(property / total * 100).toStringAsFixed(0)}%",
      },
      {
        "value": project,
        "color": ColorRes.leadIndigoColor,
        "title":
            project == 0
                ? ""
                : "${(project / total * 100).toStringAsFixed(0)}%",
      },
    ];

    List<PieChartSectionData> chartSections() {
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

      return List.generate(sections.length, (index) {
        final isTouched = touchedIndex == index;

        return PieChartSectionData(
          value: sections[index]["value"] as double,
          title: sections[index]["title"] as String,
          color: sections[index]["color"] as Color,
          radius: isTouched ? 65 : 55,
          titleStyle: TextStyle(
            fontSize: isTouched ? 18 : 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            shadows: const [Shadow(color: Colors.black38, blurRadius: 2)],
          ),
        );
      });
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.pie_chart_outline, color: ColorRes.leadIndigoColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Revenue Sources Breakdown',
                      style: TextStyle(
                        color: ColorRes.leadIndigoColor,
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                    // Text(
                    //   'Total: ${Formatter.formatPrice(total.toInt())}',
                    //   style: TextStyle(
                    //     color: ColorRes.textColor,
                    //     fontSize:
                    //         AppFontSizes.extraSmall,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 240,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (event, pieTouchResponse) {
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
                centerSpaceRadius: 40,
                sections: chartSections(),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              legendItem(ColorRes.blueColor, "Earned", property),
              legendItem(ColorRes.leadIndigoColor, "Potential", project),
            ],
          ),
        ],
      ),
    );
  }

  Widget legendItem(Color color, String title, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
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
            Formatter.formatPrice(amount.toInt()),
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
