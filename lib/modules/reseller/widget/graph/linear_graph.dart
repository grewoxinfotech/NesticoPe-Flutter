import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';

import '../../../../app/constants/color_res.dart';
import '../../../../app/utils/helper_function/month_switch/month_switch.dart';

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
    this.isAmount=true,
    this.color=ColorRes.reportCardTextFiledHint
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
                return isAmount? Text(
                  Formatter.formatGraphPrice(value.toInt()),

                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ): Text(
                  Formatter.formatNumber(value.toInt()),

                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),

        // --- Grid + Border ---
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
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

        // --- Tooltip ---
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final month = months[group.x.toInt()];
              return BarTooltipItem(
                '$month\n${(isAmount)?Formatter.formatPrice(rod.toY.toInt()):Formatter.formatNumber(rod.toY.toInt())}',
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
    return List.generate(
      monthlyData.length,
          (index) {
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: monthlyData[index],
              width: 6,
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.9),
                  color.withOpacity(0.9),
                ],
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
      },
    );
  }
}
