// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../../../../data/network/property/models/property_model.dart';
//
// class InvestmentInsightChart extends StatelessWidget {
//   final InvestmentInsight insight;
//
//   const InvestmentInsightChart({super.key, required this.insight});
//
//   String formatCurrency(num value) {
//     return NumberFormat.compactCurrency(
//       decimalDigits: 1,
//       symbol: '₹',
//     ).format(value);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final priceTrend = insight.priceTrend;
//     final future = insight.futureProjection;
//
//     if (priceTrend == null || future == null) {
//       return const SizedBox.shrink();
//     }
//
//     // Build past & future values list for chart
//     final List<Map<String, dynamic>> chartData = [
//       {"year": 2022, "price": priceTrend.past5yrPrice},
//       {"year": 2023, "price": priceTrend.past5yrPrice! + 100000}, // dummy
//       {"year": 2024, "price": (priceTrend.currentPrice! * 0.95)},
//       {"year": 2025, "price": priceTrend.currentPrice},
//       {"year": 2026, "price": future.projectedPrice5yr! * 0.95},
//       {"year": 2027, "price": future.projectedPrice5yr! * 0.93},
//       {"year": 2028, "price": future.projectedPrice5yr},
//     ];
//
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ─────────────────────────────── TOP LABELS
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildInsightItem(
//                 icon: Icons.trending_up,
//                 color: Colors.green,
//                 label: "Past 5yr Growth",
//                 value: "${priceTrend.growthPercentage5yr?.toStringAsFixed(1)}%",
//                 sub: "CAGR: ${priceTrend.cagrPercentage?.toStringAsFixed(1)}%",
//               ),
//               _buildInsightItem(
//                 icon: Icons.show_chart,
//                 color: Colors.blue,
//                 label: "Projected 5yr ROI",
//                 value: "${future.roiPercentage5yr?.toStringAsFixed(1)}%",
//                 sub: "Future Estimate",
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 20),
//
//           // ─────────────────────────────── CHART
//           SizedBox(
//             height: 260,
//             child: LineChart(
//               LineChartData(
//                 gridData: FlGridData(show: true, horizontalInterval: 0.2),
//                 borderData: FlBorderData(show: false),
//                 titlesData: FlTitlesData(
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 50,
//                       getTitlesWidget:
//                           (v, meta) => Text(
//                             formatCurrency(v),
//                             style: const TextStyle(fontSize: 11),
//                           ),
//                     ),
//                   ),
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       getTitlesWidget: (v, meta) {
//                         int index = v.toInt();
//                         if (index < 0 || index >= chartData.length)
//                           return const SizedBox();
//                         return Text(chartData[index]["year"].toString());
//                       },
//                     ),
//                   ),
//                 ),
//                 minX: 0,
//                 maxX: (chartData.length - 1).toDouble(),
//                 minY:
//                     chartData
//                         .map((e) => e["price"])
//                         .reduce((a, b) => a < b ? a : b) *
//                     0.95,
//                 maxY:
//                     chartData
//                         .map((e) => e["price"])
//                         .reduce((a, b) => a > b ? a : b) *
//                     1.05,
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: [
//                       for (int i = 0; i < chartData.length; i++)
//                         FlSpot(i.toDouble(), chartData[i]["price"] * 1.0),
//                     ],
//                     isCurved: true,
//                     color: Colors.orange,
//                     barWidth: 3,
//                     dotData: FlDotData(show: true),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           // ─────────────────────────────── FOOTER LINK
//           InkWell(
//             onTap: () {},
//             child: const Text(
//               "See city wide trends →",
//               style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInsightItem({
//     required IconData icon,
//     required String value,
//     required String label,
//     required String sub,
//     required Color color,
//   }) {
//     return Row(
//       children: [
//         Icon(icon, color: color, size: 20),
//         const SizedBox(width: 8),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               value,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Text(label, style: const TextStyle(fontSize: 12)),
//             Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../data/network/property/models/property_model.dart';

class InvestmentInsightChart extends StatefulWidget {
  final InvestmentInsight insight;

  const InvestmentInsightChart({super.key, required this.insight});

  @override
  State<InvestmentInsightChart> createState() => _InvestmentInsightChartState();
}

class _InvestmentInsightChartState extends State<InvestmentInsightChart> {
  String formatCurrency(num value) {
    return NumberFormat.compactCurrency(
      decimalDigits: 1,
      symbol: '₹',
    ).format(value);
  }

  String formatCurrencyFull(num value) {
    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    final priceTrend = widget.insight.priceTrend;
    final future = widget.insight.futureProjection;

    // Null safety validation
    if (priceTrend == null ||
        future == null ||
        priceTrend.currentPrice == null ||
        priceTrend.past5yrPrice == null ||
        future.projectedPrice5yr == null) {
      return const SizedBox.shrink();
    }

    final past = priceTrend.past5yrPrice!;
    final current = priceTrend.currentPrice!;
    final projected = future.projectedPrice5yr!;

    // Validate data makes sense
    if (past <= 0 || current <= 0 || projected <= 0) {
      return const SizedBox.shrink();
    }

    // ─────────────────────────────── CHART DATA with realistic interpolation
    final List<_ChartPoint> chartData = _generateChartData(
      past,
      current,
      projected,
    );

    final prices = chartData.map((e) => e.price).toList();
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final priceRange = maxPrice - minPrice;

    // Calculate actual growth percentage
    final actualGrowth = ((current - past) / past) * 100;

    // Calculate optimal Y-axis interval for proper label spacing
    final yAxisInterval = _calculateOptimalInterval(priceRange.toDouble());

    // Calculate min and max Y with reduced padding (5%) and aligned to intervals
    final minYWithPadding = minPrice - (priceRange * 0.05);
    final maxYWithPadding = maxPrice + (priceRange * 0.05);

    // Align to interval boundaries for cleaner chart
    final minY = (minYWithPadding / yAxisInterval).floor() * yAxisInterval;
    final maxY = (maxYWithPadding / yAxisInterval).ceil() * yAxisInterval;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),

      // padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─────────────────────────────── METRICS CARDS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.trending_up,
                  color: const Color(0xFF4CAF50),
                  label: 'Past 5yr Growth',
                  value: '${actualGrowth.toStringAsFixed(1)}%',
                  sub:
                      'CAGR: ${priceTrend.cagrPercentage?.toStringAsFixed(1) ?? '--'}%',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.show_chart,
                  color: const Color(0xFF2196F3),
                  label: 'Projected 5yr ROI',
                  value:
                      '${future.roiPercentage5yr?.toStringAsFixed(1) ?? '--'}%',
                  sub: 'Future Estimate',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ─────────────────────────────── PRICE RANGE INFO
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPriceInfo('Past Price', past),
              _buildPriceInfo('Current Price', current),
              _buildPriceInfo('Projected Price', projected),
            ],
          ),

          const SizedBox(height: 24),

          // ─────────────────────────────── LINE CHART WITH AREA
          SizedBox(
            height: 280,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: yAxisInterval,
                  getDrawingHorizontalLine:
                      (value) =>
                          FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (chartData.length - 1).toDouble(),
                minY: minY,
                maxY: maxY,
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final index = touchedSpot.x.toInt();
                        if (index >= 0 && index < chartData.length) {
                          final point = chartData[index];
                          return LineTooltipItem(
                            '${point.year}\n${formatCurrencyFull(point.price.toInt())}\n${point.isPast ? '(Past)' : '(Projected)'}',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        }
                        return null;
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 65,
                      getTitlesWidget:
                          (v, _) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              formatCurrency(v),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (v, _) {
                        final index = v.toInt();
                        if (index < 0 || index >= chartData.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            chartData[index].year.toString(),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
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
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    curveSmoothness: 0.4,
                    barWidth: 3,
                    color: const Color(0xFFFF9800),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFFFF9800).withValues(alpha: 0.1),
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        final point = chartData[index];
                        return FlDotCirclePainter(
                          radius: 5,
                          color:
                              point.isPast
                                  ? const Color(0xFF4CAF50)
                                  : const Color(0xFFFFC107),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    spots: [
                      for (int i = 0; i < chartData.length; i++)
                        FlSpot(i.toDouble(), chartData[i].price.toDouble()),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ─────────────────────────────── LEGEND
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Past Data', const Color(0xFF4CAF50)),
              const SizedBox(width: 24),
              _buildLegendItem('Projected Data', const Color(0xFFFFC107)),
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
    required String sub,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInfo(String label, num price) {
    return Flexible(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            formatCurrency(price),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  List<_ChartPoint> _generateChartData(num past, num current, num projected) {
    return [
      // Past data
      _ChartPoint(2023, past, isPast: true),
      _ChartPoint(2024, past + (current - past) * 0.35, isPast: true),
      _ChartPoint(2025, current, isPast: true),
      // Projected data with consistent growth rate
      _ChartPoint(2026, current + (projected - current) * 0.40, isPast: false),
      _ChartPoint(2027, current + (projected - current) * 0.75, isPast: false),
    ];
  }

  /// Calculate optimal Y-axis interval for consistent spacing
  /// Ensures labels are evenly spaced and readable (4-5 labels ideal)
  double _calculateOptimalInterval(double priceRange) {
    if (priceRange <= 0) return 1000000;

    // Find the order of magnitude
    final magnitude = (priceRange / 4).abs(); // Target 4 intervals
    final exponent = log(magnitude) / log(10);
    final orderOfMagnitude = pow(10, exponent.floor()).toDouble();

    // Calculate interval candidates in order of preference
    final candidates = [
      orderOfMagnitude,
      orderOfMagnitude * 2,
      orderOfMagnitude * 5,
      orderOfMagnitude * 10, // Fallback for very large ranges
    ];

    // Choose the candidate that gives 3-6 intervals (4-5 is ideal)
    double selectedInterval = candidates[0];

    for (final candidate in candidates) {
      final numIntervals = (priceRange / candidate).ceil();
      // Prefer intervals that give 4-5 labels
      if (numIntervals >= 4 && numIntervals <= 5) {
        selectedInterval = candidate;
        break;
      }
      // Accept 3-6 as fallback
      if (numIntervals >= 3 && numIntervals <= 6) {
        selectedInterval = candidate;
      }
    }

    return selectedInterval;
  }
}

/// Internal chart point model with past/future distinction
class _ChartPoint {
  final int year;
  final num price;
  final bool isPast;

  _ChartPoint(this.year, this.price, {this.isPast = true});
}
