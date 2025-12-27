// import 'dart:math';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../../../../data/network/property/models/property_model.dart';
//
// class InvestmentInsightChart extends StatefulWidget {
//   final InvestmentInsight insight;
//
//   const InvestmentInsightChart({super.key, required this.insight});
//
//   @override
//   State<InvestmentInsightChart> createState() => _InvestmentInsightChartState();
// }
//
// class _InvestmentInsightChartState extends State<InvestmentInsightChart> {
//   String formatCurrency(num value) {
//     return NumberFormat.compactCurrency(
//       decimalDigits: 1,
//       symbol: '₹',
//     ).format(value);
//   }
//
//   String formatCurrencyFull(num value) {
//     return NumberFormat.currency(
//       locale: 'en_IN',
//       symbol: '₹',
//       decimalDigits: 0,
//     ).format(value);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final priceTrend = widget.insight.priceTrend;
//     final future = widget.insight.futureProjection;
//
//     // Null safety validation
//     if (priceTrend == null ||
//         future == null ||
//         priceTrend.currentPrice == null ||
//         priceTrend.past5yrPrice == null ||
//         future.projectedPrice5yr == null) {
//       return const SizedBox.shrink();
//     }
//
//     final past = priceTrend.past5yrPrice!;
//     final current = priceTrend.currentPrice!;
//     final projected = future.projectedPrice5yr!;
//
//     // Validate data makes sense
//     if (past <= 0 || current <= 0 || projected <= 0) {
//       return const SizedBox.shrink();
//     }
//
//     // ─────────────────────────────── CHART DATA with realistic interpolation
//     final List<_ChartPoint> chartData = _generateChartData(
//       past,
//       current,
//       projected,
//     );
//
//     final prices = chartData.map((e) => e.price).toList();
//     final minPrice = prices.reduce((a, b) => a < b ? a : b);
//     final maxPrice = prices.reduce((a, b) => a > b ? a : b);
//     final priceRange = maxPrice - minPrice;
//
//     // Calculate actual growth percentage
//     final actualGrowth = ((current - past) / past) * 100;
//
//     // Calculate optimal Y-axis interval for proper label spacing
//     final yAxisInterval = _calculateOptimalInterval(priceRange.toDouble());
//
//     // Calculate min and max Y with reduced padding (5%) and aligned to intervals
//     final minYWithPadding = minPrice - (priceRange * 0.05);
//     final maxYWithPadding = maxPrice + (priceRange * 0.05);
//
//     // Align to interval boundaries for cleaner chart
//     final minY = (minYWithPadding / yAxisInterval).floor() * yAxisInterval;
//     final maxY = (maxYWithPadding / yAxisInterval).ceil() * yAxisInterval;
//
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12),
//
//       // padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ─────────────────────────────── METRICS CARDS
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: _buildMetricCard(
//                   icon: Icons.trending_up,
//                   color: const Color(0xFF4CAF50),
//                   label: 'Past 5yr Growth',
//                   value: '${actualGrowth.toStringAsFixed(1)}%',
//                   sub:
//                       'CAGR: ${priceTrend.cagrPercentage?.toStringAsFixed(1) ?? '--'}%',
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildMetricCard(
//                   icon: Icons.show_chart,
//                   color: const Color(0xFF2196F3),
//                   label: 'Projected 5yr ROI',
//                   value:
//                       '${future.roiPercentage5yr?.toStringAsFixed(1) ?? '--'}%',
//                   sub: 'Future Estimate',
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 24),
//
//           // ─────────────────────────────── PRICE RANGE INFO
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildPriceInfo('Past Price', past),
//               _buildPriceInfo('Current Price', current),
//               _buildPriceInfo('Projected Price', projected),
//             ],
//           ),
//
//           const SizedBox(height: 24),
//
//           // ─────────────────────────────── LINE CHART WITH AREA
//           SizedBox(
//             height: 280,
//             child: LineChart(
//               LineChartData(
//                 gridData: FlGridData(
//                   show: true,
//                   drawVerticalLine: false,
//                   horizontalInterval: yAxisInterval,
//                   getDrawingHorizontalLine:
//                       (value) =>
//                           FlLine(color: Colors.grey.shade200, strokeWidth: 1),
//                 ),
//                 borderData: FlBorderData(show: false),
//                 minX: 0,
//                 maxX: (chartData.length - 1).toDouble(),
//                 minY: minY,
//                 maxY: maxY,
//                 lineTouchData: LineTouchData(
//                   touchTooltipData: LineTouchTooltipData(
//                     getTooltipItems: (touchedSpots) {
//                       return touchedSpots.map((LineBarSpot touchedSpot) {
//                         final index = touchedSpot.x.toInt();
//                         if (index >= 0 && index < chartData.length) {
//                           final point = chartData[index];
//                           return LineTooltipItem(
//                             '${point.year}\n${formatCurrencyFull(point.price.toInt())}\n${point.isPast ? '(Past)' : '(Projected)'}',
//                             const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                             ),
//                           );
//                         }
//                         return null;
//                       }).toList();
//                     },
//                   ),
//                   handleBuiltInTouches: true,
//                 ),
//                 titlesData: FlTitlesData(
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 65,
//                       getTitlesWidget:
//                           (v, _) => Padding(
//                             padding: const EdgeInsets.only(right: 8),
//                             child: Text(
//                               formatCurrency(v),
//                               style: const TextStyle(
//                                 fontSize: 11,
//                                 color: Colors.grey,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                     ),
//                   ),
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       interval: 1,
//                       getTitlesWidget: (v, _) {
//                         final index = v.toInt();
//                         if (index < 0 || index >= chartData.length) {
//                           return const SizedBox.shrink();
//                         }
//                         return Padding(
//                           padding: const EdgeInsets.only(top: 8),
//                           child: Text(
//                             chartData[index].year.toString(),
//                             style: const TextStyle(
//                               fontSize: 11,
//                               color: Colors.grey,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   topTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   rightTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                 ),
//                 lineBarsData: [
//                   LineChartBarData(
//                     isCurved: true,
//                     curveSmoothness: 0.4,
//                     barWidth: 3,
//                     color: const Color(0xFFFF9800),
//                     belowBarData: BarAreaData(
//                       show: true,
//                       color: const Color(0xFFFF9800).withValues(alpha: 0.1),
//                     ),
//                     dotData: FlDotData(
//                       show: true,
//                       getDotPainter: (spot, percent, barData, index) {
//                         final point = chartData[index];
//                         return FlDotCirclePainter(
//                           radius: 5,
//                           color:
//                               point.isPast
//                                   ? const Color(0xFF4CAF50)
//                                   : const Color(0xFFFFC107),
//                           strokeWidth: 2,
//                           strokeColor: Colors.white,
//                         );
//                       },
//                     ),
//                     spots: [
//                       for (int i = 0; i < chartData.length; i++)
//                         FlSpot(i.toDouble(), chartData[i].price.toDouble()),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           // ─────────────────────────────── LEGEND
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _buildLegendItem('Past Data', const Color(0xFF4CAF50)),
//               const SizedBox(width: 24),
//               _buildLegendItem('Projected Data', const Color(0xFFFFC107)),
//             ],
//           ),
//
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMetricCard({
//     required IconData icon,
//     required Color color,
//     required String label,
//     required String value,
//     required String sub,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: 0.08),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withValues(alpha: 0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: color, size: 18),
//               const SizedBox(width: 8),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 11,
//               color: Colors.grey.shade700,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             sub,
//             style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPriceInfo(String label, num price) {
//     return Flexible(
//       child: Column(
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 11,
//               color: Colors.grey.shade600,
//               fontWeight: FontWeight.w500,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             formatCurrency(price),
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLegendItem(String label, Color color) {
//     return Row(
//       children: [
//         Container(
//           width: 12,
//           height: 12,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(6),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey.shade700,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
//
//   List<_ChartPoint> _generateChartData(num past, num current, num projected) {
//     return [
//       // Past data
//       _ChartPoint(2023, past, isPast: true),
//       _ChartPoint(2024, past + (current - past) * 0.35, isPast: true),
//       _ChartPoint(2025, current, isPast: true),
//       // Projected data with consistent growth rate
//       _ChartPoint(2026, current + (projected - current) * 0.40, isPast: false),
//       _ChartPoint(2027, current + (projected - current) * 0.75, isPast: false),
//     ];
//   }
//
//   /// Calculate optimal Y-axis interval for consistent spacing
//   /// Ensures labels are evenly spaced and readable (4-5 labels ideal)
//   double _calculateOptimalInterval(double priceRange) {
//     if (priceRange <= 0) return 1000000;
//
//     // Find the order of magnitude
//     final magnitude = (priceRange / 4).abs(); // Target 4 intervals
//     final exponent = log(magnitude) / log(10);
//     final orderOfMagnitude = pow(10, exponent.floor()).toDouble();
//
//     // Calculate interval candidates in order of preference
//     final candidates = [
//       orderOfMagnitude,
//       orderOfMagnitude * 2,
//       orderOfMagnitude * 5,
//       orderOfMagnitude * 10, // Fallback for very large ranges
//     ];
//
//     // Choose the candidate that gives 3-6 intervals (4-5 is ideal)
//     double selectedInterval = candidates[0];
//
//     for (final candidate in candidates) {
//       final numIntervals = (priceRange / candidate).ceil();
//       // Prefer intervals that give 4-5 labels
//       if (numIntervals >= 4 && numIntervals <= 5) {
//         selectedInterval = candidate;
//         break;
//       }
//       // Accept 3-6 as fallback
//       if (numIntervals >= 3 && numIntervals <= 6) {
//         selectedInterval = candidate;
//       }
//     }
//
//     return selectedInterval;
//   }
// }
//
// /// Internal chart point model with past/future distinction
// class _ChartPoint {
//   final int year;
//   final num price;
//   final bool isPast;
//
//   _ChartPoint(this.year, this.price, {this.isPast = true});
// }

// import 'dart:math';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../../../../data/network/property/models/property_model.dart';
//
// class InvestmentInsightChart extends StatelessWidget {
//   final FinancialInfo financialInfo;
//
//   const InvestmentInsightChart({super.key, required this.financialInfo});
//
//   String _formatCurrency(num value) {
//     return NumberFormat.compactCurrency(
//       symbol: '₹',
//       decimalDigits: 1,
//     ).format(value);
//   }
//
//   String _formatCurrencyFull(num value) {
//     return NumberFormat.currency(
//       locale: 'en_IN',
//       symbol: '₹',
//       decimalDigits: 0,
//     ).format(value);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final past = financialInfo.pricePast;
//     final future = financialInfo.priceFuture;
//
//     if (past.isEmpty || future.isEmpty) {
//       return const SizedBox.shrink();
//     }
//
//     final chartData = _generateChartData(past: past, future: future);
//
//     final prices = chartData.map((e) => e.price).toList();
//     final minPrice = prices.reduce(min);
//     final maxPrice = prices.reduce(max);
//     final range = maxPrice - minPrice;
//
//     final yInterval = _calculateOptimalInterval(range.toDouble());
//     final minY = (minPrice - range * 0.05) ~/ yInterval * yInterval;
//     final maxY = (maxPrice + range * 0.05) ~/ yInterval * yInterval + yInterval;
//
//     // Metrics
//     final pastStart = past.first.price;
//     final pastEnd = past.last.price;
//     final futureEnd = future.last.price;
//
//     final pastGrowth = ((pastEnd - pastStart) / pastStart) * 100;
//
//     final futureROI = ((futureEnd - pastEnd) / pastEnd) * 100;
//
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// ─────────────── METRICS
//           Row(
//             children: [
//               Expanded(
//                 child: _metricCard(
//                   title: 'Past Growth',
//                   value: '${pastGrowth.toStringAsFixed(1)}%',
//                   icon: Icons.trending_up,
//                   color: const Color(0xFF4CAF50),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _metricCard(
//                   title: 'Future ROI',
//                   value: '${futureROI.toStringAsFixed(1)}%',
//                   icon: Icons.show_chart,
//                   color: const Color(0xFFFF9800),
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 24),
//
//           /// ─────────────── PRICE INFO
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _priceInfo('Past', pastStart),
//               _priceInfo('Current', pastEnd),
//               _priceInfo('Future', futureEnd),
//             ],
//           ),
//
//           const SizedBox(height: 24),
//
//           /// ─────────────── CHART
//           SizedBox(
//             height: 280,
//             child: LineChart(
//               LineChartData(
//                 minX: 0,
//                 maxX: (chartData.length - 1).toDouble(),
//                 minY: minY.toDouble(),
//                 maxY: maxY.toDouble(),
//                 gridData: FlGridData(
//                   show: true,
//                   drawVerticalLine: false,
//                   horizontalInterval: yInterval,
//                   getDrawingHorizontalLine:
//                       (v) =>
//                           FlLine(color: Colors.grey.shade200, strokeWidth: 1),
//                 ),
//                 borderData: FlBorderData(show: false),
//                 titlesData: _buildTitles(chartData),
//                 lineTouchData: _buildTouch(chartData),
//                 lineBarsData: [
//                   LineChartBarData(
//                     isCurved: true,
//                     curveSmoothness: 0.35,
//                     barWidth: 3,
//                     color: const Color(0xFF2196F3),
//                     belowBarData: BarAreaData(
//                       show: true,
//                       color: const Color(0xFF2196F3).withOpacity(0.1),
//                     ),
//                     dotData: FlDotData(
//                       show: true,
//                       getDotPainter: (spot, _, __, index) {
//                         final point = chartData[index];
//                         return FlDotCirclePainter(
//                           radius: 5,
//                           color:
//                               point.isPast
//                                   ? const Color(0xFF4CAF50)
//                                   : const Color(0xFFFFC107),
//                           strokeWidth: 2,
//                           strokeColor: Colors.white,
//                         );
//                       },
//                     ),
//                     spots: [
//                       for (int i = 0; i < chartData.length; i++)
//                         FlSpot(i.toDouble(), chartData[i].price.toDouble()),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           /// ─────────────── LEGEND
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _legend('Past', const Color(0xFF4CAF50)),
//               const SizedBox(width: 24),
//               _legend('Projected', const Color(0xFFFFC107)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ───────────────────────── HELPERS
//
//   List<_ChartPoint> _generateChartData({
//     required List<PropertyPriceYear> past,
//     required List<PropertyPriceYear> future,
//   }) {
//     final List<_ChartPoint> data = [];
//
//     past.sort((a, b) => a.year.compareTo(b.year));
//     future.sort((a, b) => a.year.compareTo(b.year));
//
//     for (final p in past) {
//       data.add(_ChartPoint(p.year, p.price, true));
//     }
//
//     for (final f in future) {
//       data.add(_ChartPoint(f.year, f.price, false));
//     }
//
//     return data;
//   }
//
//   FlTitlesData _buildTitles(List<_ChartPoint> data) {
//     return FlTitlesData(
//       show: true,
//
//       /// ───────── LEFT (PRICE)
//       leftTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 50,
//           getTitlesWidget: (value, meta) {
//             return Padding(
//               padding: const EdgeInsets.only(right: 8),
//               child: Text(
//                 _formatCurrency(value),
//                 textAlign: TextAlign.right,
//                 style: const TextStyle(
//                   fontSize: 11,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//
//       /// ───────── BOTTOM (YEAR)
//       bottomTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           interval: 1,
//           reservedSize: 28,
//           getTitlesWidget: (value, meta) {
//             final index = value.round();
//
//             if (index < 0 || index >= data.length) {
//               return const SizedBox.shrink();
//             }
//
//             final point = data[index];
//
//             return Padding(
//               padding: const EdgeInsets.only(top: 8),
//               child: Text(
//                 point.year.toString(),
//                 style: TextStyle(
//                   fontSize: 11,
//                   fontWeight: FontWeight.w500,
//                   color:
//                       point.isPast
//                           ? Colors.grey.shade700
//                           : Colors.grey.shade500,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//
//       /// ───────── HIDE TOP & RIGHT
//       topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//       rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//     );
//   }
//
//   LineTouchData _buildTouch(List<_ChartPoint> data) {
//     return LineTouchData(
//       touchTooltipData: LineTouchTooltipData(
//         getTooltipItems: (spots) {
//           return spots.map((s) {
//             final point = data[s.x.toInt()];
//             return LineTooltipItem(
//               '${point.year}\n${_formatCurrencyFull(point.price)}\n${point.isPast ? 'Past' : 'Projected'}',
//               const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12,
//               ),
//             );
//           }).toList();
//         },
//       ),
//     );
//   }
//
//   double _calculateOptimalInterval(double range) {
//     if (range <= 0) return 100000;
//
//     final magnitude = pow(10, (log(range / 4) / log(10)).floor());
//     final candidates = [
//       magnitude,
//       magnitude * 2,
//       magnitude * 5,
//       magnitude * 10,
//     ];
//
//     for (final c in candidates) {
//       final ticks = range / c;
//       if (ticks >= 3 && ticks <= 6) return c.toDouble();
//     }
//     return candidates.last.toDouble();
//   }
//
//   Widget _metricCard({
//     required String title,
//     required String value,
//     required IconData icon,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: color, size: 18),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//           Text(title, style: const TextStyle(fontSize: 11)),
//         ],
//       ),
//     );
//   }
//
//   Widget _priceInfo(String label, num value) {
//     return Column(
//       children: [
//         Text(label, style: const TextStyle(fontSize: 11)),
//         const SizedBox(height: 4),
//         Text(
//           _formatCurrency(value),
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
//         ),
//       ],
//     );
//   }
//
//   Widget _legend(String text, Color color) {
//     return Row(
//       children: [
//         Container(
//           width: 12,
//           height: 12,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(6),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text(text, style: const TextStyle(fontSize: 12)),
//       ],
//     );
//   }
// }
//
// /// INTERNAL MODEL
// class _ChartPoint {
//   final int year;
//   final num price;
//   final bool isPast;
//
//   _ChartPoint(this.year, this.price, this.isPast);
// }

// import 'dart:math';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// import '../../../../data/network/property/models/property_model.dart'
//     hide PriceTrend;
// import '../../../../data/network/location_price_matrix/model/location_price_matrix_model.dart';
// import '../../../location_price_matrix/controllers/location_price_matrix_controller.dart';
//
// class InvestmentInsightChart extends StatefulWidget {
//   final FinancialInfo financialInfo;
//   final String? propertyLocation;
//   final String? propertyType;
//   final String propertyId;
//
//   const InvestmentInsightChart({
//     super.key,
//     required this.financialInfo,
//     this.propertyLocation,
//     this.propertyType,
//     required this.propertyId,
//   });
//
//   @override
//   State<InvestmentInsightChart> createState() => _InvestmentInsightChartState();
// }
//
// class _InvestmentInsightChartState extends State<InvestmentInsightChart> {
//   final LocationPriceMatrixController _matrixController = Get.find();
//   final List<ComparisonProperty> selectedProperties = [];
//   final int maxSelection = 3;
//
//   // Define colors for comparison lines
//   final List<Color> comparisonColors = [
//     Color(0xFFFF6B6B), // Red
//     Color(0xFF4ECDC4), // Teal
//     Color(0xFFFFBE0B), // Yellow
//     Color(0xFF9B59B6), // Purple
//   ];
//
//   String _formatCurrency(num value) {
//     return NumberFormat.compactCurrency(
//       symbol: '₹',
//       decimalDigits: 1,
//     ).format(value);
//   }
//
//   String _formatCurrencyFull(num value) {
//     return NumberFormat.currency(
//       locale: 'en_IN',
//       symbol: '₹',
//       decimalDigits: 0,
//     ).format(value);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final past = widget.financialInfo.pricePast;
//     final future = widget.financialInfo.priceFuture;
//
//     if (past.isEmpty || future.isEmpty) {
//       return const SizedBox.shrink();
//     }
//
//     final myPropertyData = _generateChartData(past: past, future: future);
//
//     // Combine all chart data for axis calculation
//     List<num> allPrices = myPropertyData.map((e) => e.price).toList();
//     for (var prop in selectedProperties) {
//       allPrices.addAll(prop.chartData.map((e) => e.price));
//     }
//
//     final minPrice = allPrices.reduce(min);
//     final maxPrice = allPrices.reduce(max);
//     final range = maxPrice - minPrice;
//
//     final yInterval = _calculateOptimalInterval(range.toDouble());
//     final minY = (minPrice - range * 0.05) ~/ yInterval * yInterval;
//     final maxY = (maxPrice + range * 0.05) ~/ yInterval * yInterval + yInterval;
//
//     // Metrics for main property
//     final pastStart = past.first.price;
//     final pastEnd = past.last.price;
//     final futureEnd = future.last.price;
//     final pastGrowth = ((pastEnd - pastStart) / pastStart) * 100;
//     final futureROI = ((futureEnd - pastEnd) / pastEnd) * 100;
//
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// ─────────────── METRICS
//           Row(
//             children: [
//               Expanded(
//                 child: _metricCard(
//                   title: 'Past Growth',
//                   value: '${pastGrowth.toStringAsFixed(1)}%',
//                   icon: Icons.trending_up,
//                   color: const Color(0xFF4CAF50),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _metricCard(
//                   title: 'Future ROI',
//                   value: '${futureROI.toStringAsFixed(1)}%',
//                   icon: Icons.show_chart,
//                   color: const Color(0xFFFF9800),
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 24),
//
//           /// ─────────────── PRICE INFO
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _priceInfo('Past', pastStart),
//               _priceInfo('Current', pastEnd),
//               _priceInfo('Future', futureEnd),
//             ],
//           ),
//
//           const SizedBox(height: 24),
//
//           /// ─────────────── CHART
//           SizedBox(
//             height: 280,
//             child: LineChart(
//               LineChartData(
//                 minX: 0,
//                 maxX: (myPropertyData.length - 1).toDouble(),
//                 minY: minY.toDouble(),
//                 maxY: maxY.toDouble(),
//                 gridData: FlGridData(
//                   show: true,
//                   drawVerticalLine: false,
//                   horizontalInterval: yInterval,
//                   getDrawingHorizontalLine:
//                       (v) =>
//                           FlLine(color: Colors.grey.shade200, strokeWidth: 1),
//                 ),
//                 borderData: FlBorderData(show: false),
//                 titlesData: _buildTitles(myPropertyData),
//                 lineTouchData: _buildTouch(myPropertyData),
//                 lineBarsData: [
//                   // Main property line (blue)
//                   _buildMainPropertyLine(myPropertyData),
//                   // Comparison property lines
//                   ...selectedProperties.asMap().entries.map((entry) {
//                     return _buildComparisonLine(
//                       entry.value.chartData,
//                       comparisonColors[entry.key % comparisonColors.length],
//                     );
//                   }),
//                 ],
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           /// ─────────────── LEGEND
//           Wrap(
//             spacing: 16,
//             runSpacing: 8,
//             alignment: WrapAlignment.center,
//             children: [
//               _legend('My Property', const Color(0xFF2196F3)),
//               ...selectedProperties.asMap().entries.map((entry) {
//                 return _legend(
//                   entry.value.title,
//                   comparisonColors[entry.key % comparisonColors.length],
//                 );
//               }),
//             ],
//           ),
//
//           const SizedBox(height: 24),
//
//           /// ─────────────── COMPARE BUTTON
//           Center(
//             child: ElevatedButton.icon(
//               onPressed: () => _showComparisonSheet(context),
//               icon: const Icon(Icons.compare_arrows, size: 20),
//               label: Text(
//                 selectedProperties.isEmpty
//                     ? 'Compare price with society'
//                     : 'Comparing with ${selectedProperties.length} ${selectedProperties.length == 1 ? 'property' : 'properties'}',
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF2196F3),
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 12,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ───────────────────────── BUILD CHART LINES
//
//   LineChartBarData _buildMainPropertyLine(List<_ChartPoint> data) {
//     return LineChartBarData(
//       isCurved: true,
//       curveSmoothness: 0.35,
//       barWidth: 3,
//       color: const Color(0xFF2196F3),
//       belowBarData: BarAreaData(
//         show: true,
//         color: const Color(0xFF2196F3).withOpacity(0.1),
//       ),
//       dotData: FlDotData(
//         show: true,
//         getDotPainter: (spot, _, __, index) {
//           final point = data[index];
//           return FlDotCirclePainter(
//             radius: 5,
//             color:
//                 point.isPast
//                     ? const Color(0xFF4CAF50)
//                     : const Color(0xFFFFC107),
//             strokeWidth: 2,
//             strokeColor: Colors.white,
//           );
//         },
//       ),
//       spots: [
//         for (int i = 0; i < data.length; i++)
//           FlSpot(i.toDouble(), data[i].price.toDouble()),
//       ],
//     );
//   }
//
//   LineChartBarData _buildComparisonLine(List<_ChartPoint> data, Color color) {
//     return LineChartBarData(
//       isCurved: true,
//       curveSmoothness: 0.35,
//       barWidth: 2.5,
//       color: color,
//       belowBarData: BarAreaData(show: false),
//       dotData: FlDotData(
//         show: true,
//         getDotPainter: (spot, _, __, ___) {
//           return FlDotCirclePainter(
//             radius: 4,
//             color: color,
//             strokeWidth: 2,
//             strokeColor: Colors.white,
//           );
//         },
//       ),
//       spots: [
//         for (int i = 0; i < data.length; i++)
//           FlSpot(i.toDouble(), data[i].price.toDouble()),
//       ],
//     );
//   }
//
//   // ───────────────────────── COMPARISON SHEET
//
//   void _showComparisonSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder:
//           (context) => StatefulBuilder(
//             builder: (context, setModalState) {
//               return Container(
//                 height: MediaQuery.of(context).size.height * 0.85,
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                 ),
//                 child: Column(
//                   children: [
//                     /// HEADER
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         border: Border(
//                           bottom: BorderSide(color: Colors.grey.shade200),
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           const Text(
//                             'Compare with Society',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const Spacer(),
//                           if (selectedProperties.isNotEmpty)
//                             TextButton(
//                               onPressed: () {
//                                 setModalState(() {
//                                   selectedProperties.clear();
//                                 });
//                                 setState(() {});
//                               },
//                               child: const Text('Clear All'),
//                             ),
//                           IconButton(
//                             onPressed: () => Navigator.pop(context),
//                             icon: const Icon(Icons.close),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     /// WARNING MESSAGE
//                     if (selectedProperties.length >= maxSelection)
//                       Container(
//                         margin: const EdgeInsets.all(16),
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.orange.shade50,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           'You can compare up to $maxSelection properties. Deselect one to add another.',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.orange.shade900,
//                           ),
//                         ),
//                       ),
//
//                     /// PROPERTY LIST
//                     Expanded(
//                       child: Obx(() {
//                         if (_matrixController.isLoading.value) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//
//                         return ListView(
//                           padding: const EdgeInsets.all(16),
//                           children: _buildPropertyList(setModalState),
//                         );
//                       }),
//                     ),
//
//                     /// DONE BUTTON
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.05),
//                             blurRadius: 10,
//                             offset: const Offset(0, -5),
//                           ),
//                         ],
//                       ),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           setState(() {});
//                           Navigator.pop(context);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF2196F3),
//                           foregroundColor: Colors.white,
//                           minimumSize: const Size(double.infinity, 50),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: Text(
//                           selectedProperties.isEmpty
//                               ? 'Done'
//                               : 'Show Comparison (${selectedProperties.length})',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//     );
//   }
//
//   List<Widget> _buildPropertyList(StateSetter setModalState) {
//     // Get properties from location matrix based on property type
//     final propertyTypeData = _getPropertyTypeData();
//
//     if (propertyTypeData == null) {
//       return [
//         const Center(
//           child: Padding(
//             padding: EdgeInsets.all(32.0),
//             child: Text('No comparison data available'),
//           ),
//         ),
//       ];
//     }
//
//     final List<ComparisonProperty> availableProperties = [];
//
//     // Generate comparison properties from location data
//     propertyTypeData.bhkDistribution.forEach((bhk, count) {
//       if (count > 0) {
//         final compProperty = ComparisonProperty(
//           id: '$bhk-${widget.propertyLocation}',
//           title:
//               '$bhk in ${widget.propertyLocation?.toUpperCase() ?? 'LOCATION'}',
//           priceData: propertyTypeData.priceTrend,
//           avgPrice: propertyTypeData.avgPrice.toDouble(),
//           propertyType: widget.propertyType ?? '',
//         );
//         availableProperties.add(compProperty);
//       }
//     });
//
//     if (availableProperties.isEmpty) {
//       return [
//         const Center(
//           child: Padding(
//             padding: EdgeInsets.all(32.0),
//             child: Text('No properties available for comparison'),
//           ),
//         ),
//       ];
//     }
//
//     return availableProperties.map((property) {
//       final isSelected = selectedProperties.any((p) => p.id == property.id);
//
//       return GestureDetector(
//         onTap: () {
//           setModalState(() {
//             if (isSelected) {
//               selectedProperties.removeWhere((p) => p.id == property.id);
//             } else if (selectedProperties.length < maxSelection) {
//               selectedProperties.add(property);
//             }
//           });
//         },
//         child: Container(
//           margin: const EdgeInsets.only(bottom: 12),
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             border: Border.all(
//               color:
//                   isSelected ? const Color(0xFF2196F3) : Colors.grey.shade300,
//               width: isSelected ? 2 : 1,
//             ),
//             borderRadius: BorderRadius.circular(12),
//             color:
//                 isSelected
//                     ? const Color(0xFF2196F3).withOpacity(0.05)
//                     : Colors.white,
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade200,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(Icons.home, color: Colors.grey),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       property.title,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '₹${_formatCurrency(property.avgPrice)}',
//                       style: const TextStyle(fontSize: 13),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       property.propertyType,
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               if (isSelected)
//                 const Icon(
//                   Icons.check_circle,
//                   color: Color(0xFF2196F3),
//                   size: 24,
//                 ),
//             ],
//           ),
//         ),
//       );
//     }).toList();
//   }
//
//   PropertyTypeData? _getPropertyTypeData() {
//     final buyData = _matrixController.buyData;
//     if (buyData == null) return null;
//
//     // Try to find data for the property location and type
//     for (var stateData in buyData.values) {
//       for (var locationData in stateData.values) {
//         for (var location in locationData) {
//           if (location.location.toLowerCase().contains(
//             widget.propertyLocation?.toLowerCase() ?? '',
//           )) {
//             // Return the first matching property type data
//             return location.propertyTypes.values.isNotEmpty
//                 ? location.propertyTypes.values.first
//                 : null;
//           }
//         }
//       }
//     }
//     return null;
//   }
//
//   // ───────────────────────── HELPERS
//
//   List<_ChartPoint> _generateChartData({
//     required List<PropertyPriceYear> past,
//     required List<PropertyPriceYear> future,
//   }) {
//     final List<_ChartPoint> data = [];
//     past.sort((a, b) => a.year.compareTo(b.year));
//     future.sort((a, b) => a.year.compareTo(b.year));
//
//     for (final p in past) {
//       data.add(_ChartPoint(p.year, p.price, true));
//     }
//     for (final f in future) {
//       data.add(_ChartPoint(f.year, f.price, false));
//     }
//     return data;
//   }
//
//   FlTitlesData _buildTitles(List<_ChartPoint> data) {
//     return FlTitlesData(
//       show: true,
//       leftTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 50,
//           getTitlesWidget: (value, meta) {
//             return Padding(
//               padding: const EdgeInsets.only(right: 8),
//               child: Text(
//                 _formatCurrency(value),
//                 textAlign: TextAlign.right,
//                 style: const TextStyle(
//                   fontSize: 11,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//       bottomTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           interval: 1,
//           reservedSize: 28,
//           getTitlesWidget: (value, meta) {
//             final index = value.round();
//             if (index < 0 || index >= data.length) {
//               return const SizedBox.shrink();
//             }
//             final point = data[index];
//             return Padding(
//               padding: const EdgeInsets.only(top: 8),
//               child: Text(
//                 point.year.toString(),
//                 style: TextStyle(
//                   fontSize: 11,
//                   fontWeight: FontWeight.w500,
//                   color:
//                       point.isPast
//                           ? Colors.grey.shade700
//                           : Colors.grey.shade500,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//       topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//       rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//     );
//   }
//
//   LineTouchData _buildTouch(List<_ChartPoint> data) {
//     return LineTouchData(
//       touchTooltipData: LineTouchTooltipData(
//         getTooltipItems: (spots) {
//           return spots.map((s) {
//             final lineIndex = s.barIndex;
//             String label = 'My Property';
//             Color color = const Color(0xFF2196F3);
//
//             if (lineIndex > 0 && lineIndex - 1 < selectedProperties.length) {
//               final prop = selectedProperties[lineIndex - 1];
//               label = prop.title;
//               color =
//                   comparisonColors[(lineIndex - 1) % comparisonColors.length];
//             }
//
//             return LineTooltipItem(
//               '$label\n${_formatCurrencyFull(s.y)}',
//               TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12,
//               ),
//             );
//           }).toList();
//         },
//       ),
//     );
//   }
//
//   double _calculateOptimalInterval(double range) {
//     if (range <= 0) return 100000;
//     final magnitude = pow(10, (log(range / 4) / log(10)).floor());
//     final candidates = [
//       magnitude,
//       magnitude * 2,
//       magnitude * 5,
//       magnitude * 10,
//     ];
//     for (final c in candidates) {
//       final ticks = range / c;
//       if (ticks >= 3 && ticks <= 6) return c.toDouble();
//     }
//     return candidates.last.toDouble();
//   }
//
//   Widget _metricCard({
//     required String title,
//     required String value,
//     required IconData icon,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: color, size: 18),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//           Text(title, style: const TextStyle(fontSize: 11)),
//         ],
//       ),
//     );
//   }
//
//   Widget _priceInfo(String label, num value) {
//     return Column(
//       children: [
//         Text(label, style: const TextStyle(fontSize: 11)),
//         const SizedBox(height: 4),
//         Text(
//           _formatCurrency(value),
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
//         ),
//       ],
//     );
//   }
//
//   Widget _legend(String text, Color color) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 12,
//           height: 12,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(6),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           text.length > 20 ? '${text.substring(0, 20)}...' : text,
//           style: const TextStyle(fontSize: 12),
//         ),
//       ],
//     );
//   }
// }
//
// /// ═══════════════════════════════════════════════════════════════════════
// /// MODELS
// /// ═══════════════════════════════════════════════════════════════════════
//
// class ComparisonProperty {
//   final String id;
//   final String title;
//   final List<PriceTrend> priceData;
//   final double avgPrice;
//   final String propertyType;
//   late final List<_ChartPoint> chartData;
//
//   ComparisonProperty({
//     required this.id,
//     required this.title,
//     required this.priceData,
//     required this.avgPrice,
//     required this.propertyType,
//   }) {
//     // Convert PriceTrend to _ChartPoint
//     chartData =
//         priceData
//             .map(
//               (trend) => _ChartPoint(
//                 trend.year,
//                 trend.avgPricePerSqFt,
//                 trend.year <= DateTime.now().year,
//               ),
//             )
//             .toList();
//     chartData.sort((a, b) => a.year.compareTo(b.year));
//   }
// }
//
// class _ChartPoint {
//   final int year;
//   final num price;
//   final bool isPast;
//
//   _ChartPoint(this.year, this.price, this.isPast);
// }

import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';
import 'package:housing_flutter_app/app/manager/property/property_name_manager.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart';
import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';
import 'package:intl/intl.dart';

// Import your models
import '../../../../data/network/property/models/property_model.dart';
import '../../../../data/network/location_price_matrix/model/location_price_matrix_model.dart';
import '../../../location_price_matrix/controllers/location_price_matrix_controller.dart';
import '../../controllers/insights_property_controller.dart';

class _ChartPoint {
  final int year;
  final num price;
  final bool isPast;

  _ChartPoint(this.year, this.price, this.isPast);
}

class ComparisonProperty {
  final String id;
  final String title;
  final List<_ChartPoint> chartData;
  final num avgPrice;
  final String propertyType;

  ComparisonProperty({
    required this.id,
    required this.title,
    required this.chartData,
    required this.avgPrice,
    required this.propertyType,
  });
}

class InvestmentInsightChart extends StatefulWidget {
  final Items currentProperty;

  const InvestmentInsightChart({super.key, required this.currentProperty});

  @override
  State<InvestmentInsightChart> createState() => _InvestmentInsightChartState();
}

class _InvestmentInsightChartState extends State<InvestmentInsightChart> {
  final LocationPriceMatrixController _matrixController = Get.find();

  String _comparisonType = 'locality'; // 'locality' or 'property'
  String? _selectedLocation;
  String? _selectedPropertyType;
  final List<ComparisonProperty> _selectedProperties = [];
  final int _maxSelection = 3;

  final List<Color> _comparisonColors = [
    const Color(0xFFFF6B6B), // Red
    const Color(0xFF4ECDC4), // Teal
    const Color(0xFFFFBE0B), // Yellow
  ];

  @override
  void initState() {
    super.initState();
    _initializeDefaults();
  }

  void _initializeDefaults() {
    _selectedLocation = widget.currentProperty.location;
    _selectedPropertyType = widget.currentProperty.propertyType;
  }

  String _formatCurrency(num value) {
    return NumberFormat.compactCurrency(
      symbol: '₹',
      decimalDigits: 1,
    ).format(value);
  }

  String _formatCurrencyFull(num value) {
    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    ).format(value);
  }

  List<_ChartPoint> _generateChartData({
    required List<PropertyPriceYear> past,
    required List<PropertyPriceYear> future,
  }) {
    final List<_ChartPoint> data = [];

    // Sort and add past data
    final sortedPast = List<PropertyPriceYear>.from(past)
      ..sort((a, b) => a.year.compareTo(b.year));

    for (final p in sortedPast) {
      data.add(_ChartPoint(p.year, p.pricePerSqft, true));
    }

    // Sort and add future data
    final sortedFuture = List<PropertyPriceYear>.from(future)
      ..sort((a, b) => a.year.compareTo(b.year));

    for (final f in sortedFuture) {
      data.add(_ChartPoint(f.year, f.pricePerSqft, false));
    }

    return data;
  }

  PropertyTypeData? _getPropertyTypeData() {
    if (_selectedLocation == null || _selectedPropertyType == null) return null;

    final buyData = _matrixController.buyData;
    if (buyData == null) return null;

    // Search through all states and cities
    for (var stateData in buyData.values) {
      for (var cityLocations in stateData.values) {
        for (var locationData in cityLocations) {
          // Match location (case-insensitive, partial match)
          if (locationData.location.toLowerCase().contains(
                _selectedLocation!.toLowerCase(),
              ) ||
              _selectedLocation!.toLowerCase().contains(
                locationData.location.toLowerCase(),
              )) {
            // Return property type data if exists
            final propTypeData =
                locationData.propertyTypes[_selectedPropertyType];
            if (propTypeData != null) {
              return propTypeData;
            }
          }
        }
      }
    }

    return null;
  }

  List<_ChartPoint> _getLocalityChartData() {
    final propertyTypeData = _getPropertyTypeData();
    if (propertyTypeData == null) return [];

    return propertyTypeData.priceTrend
        .map(
          (trend) => _ChartPoint(
            trend.year,
            trend.avgPricePerSqFt,
            trend.year <= DateTime.now().year,
          ),
        )
        .toList()
      ..sort((a, b) => a.year.compareTo(b.year));
  }

  double _calculateOptimalInterval(double range) {
    if (range <= 0) return 100000;
    final magnitude = pow(10, (log(range / 4) / log(10)).floor());
    final candidates = [
      magnitude,
      magnitude * 2,
      magnitude * 5,
      magnitude * 10,
    ];
    for (final c in candidates) {
      final ticks = range / c;
      if (ticks >= 3 && ticks <= 6) return c.toDouble();
    }
    return candidates.last.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final financialInfo = widget.currentProperty.propertyDetails?.financialInfo;

    if (financialInfo == null ||
        financialInfo.pricePast.isEmpty ||
        financialInfo.priceFuture.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text('No investment insight data available'),
        ),
      );
    }

    final myPropertyData = _generateChartData(
      past: financialInfo.pricePast,
      future: financialInfo.priceFuture,
    );

    // Collect all prices for axis calculation
    List<num> allPrices = myPropertyData.map((e) => e.price).toList();

    if (_comparisonType == 'locality') {
      final localityData = _getLocalityChartData();
      allPrices.addAll(localityData.map((e) => e.price));
    } else {
      for (var prop in _selectedProperties) {
        allPrices.addAll(prop.chartData.map((e) => e.price));
      }
    }

    final minPrice = allPrices.isEmpty ? 0 : allPrices.reduce(min);
    final maxPrice = allPrices.isEmpty ? 100000 : allPrices.reduce(max);
    final range = maxPrice - minPrice;

    final yInterval = _calculateOptimalInterval(range.toDouble());
    final minY = (minPrice - range * 0.05) ~/ yInterval * yInterval;
    final maxY = (maxPrice + range * 0.05) ~/ yInterval * yInterval + yInterval;

    // Calculate metrics
    final pastStart = financialInfo.pricePast.first.pricePerSqft;
    final pastEnd = financialInfo.pricePast.last.pricePerSqft;
    final futureEnd = financialInfo.priceFuture.last.pricePerSqft;
    final pastGrowth = ((pastEnd - pastStart) / pastStart) * 100;
    final futureROI = ((futureEnd - pastEnd) / pastEnd) * 100;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Compare price trends and forecast future returns',
            style: TextStyle(fontSize: 12, color: ColorRes.leadGreyColor),
          ),
          const SizedBox(height: 24),

          // Comparison Type Toggle
          Row(
            children: [
              Expanded(
                child: _comparisonTypeButton(
                  label: 'Compare with Locality',
                  icon: Icons.location_on,
                  isSelected: _comparisonType == 'locality',
                  onTap: () => setState(() => _comparisonType = 'locality'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _comparisonTypeButton(
                  label: 'Compare with Properties',
                  icon: Icons.home,
                  isSelected: _comparisonType == 'property',
                  onTap: () => setState(() => _comparisonType = 'property'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Metrics Cards
          Row(
            children: [
              Expanded(
                child: _metricCard(
                  title: 'Past Growth',
                  value: '${pastGrowth.toStringAsFixed(1)}%',
                  icon: Icons.trending_up,
                  color: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _metricCard(
                  title: 'Future ROI',
                  value: '${futureROI.toStringAsFixed(1)}%',
                  icon: Icons.show_chart,
                  color: const Color(0xFFFF9800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Filters
          if (_comparisonType == 'locality') _buildLocalityFilters(),
          if (_comparisonType == 'property')
            _buildPropertyComparisonButton(
              widget.currentProperty.id ?? '',
              widget.currentProperty.city ?? '',
            ),

          const SizedBox(height: 24),

          // Chart
          Container(
            height: 280,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (myPropertyData.length - 1).toDouble(),
                minY: minY.toDouble(),
                maxY: maxY.toDouble(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: yInterval,
                  getDrawingHorizontalLine:
                      (v) =>
                          FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                titlesData: _buildTitles(myPropertyData),
                lineTouchData: _buildTouch(myPropertyData),
                lineBarsData: _buildChartLines(myPropertyData),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Legend
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _comparisonTypeButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B82F6) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildLocalityFilters() {
    return Obx(() {
      if (_matrixController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final buyData = _matrixController.buyData;
      if (buyData == null || buyData.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'No locality data available for comparison',
            style: TextStyle(fontSize: 12, color: Colors.orange.shade900),
          ),
        );
      }

      // Get available locations
      final locations = <String>[];
      for (var stateData in buyData.values) {
        for (var cityLocations in stateData.values) {
          for (var loc in cityLocations) {
            if (!locations.contains(loc.location)) {
              locations.add(loc.location);
            }
          }
        }
      }

      // Get available property types for selected location
      final propertyTypes = <String>[];
      if (_selectedLocation != null) {
        final propTypeData = _getPropertyTypeData();
        if (propTypeData != null) {
          propertyTypes.addAll(
            _matrixController.buyData!.values
                .expand((state) => state.values)
                .expand((city) => city)
                .where((loc) => loc.location == _selectedLocation)
                .expand((loc) => loc.propertyTypes.keys),
          );
        }
      }

      return Row(
        children: [
          Expanded(
            child: _buildDropdown(
              label: 'Location',
              value: _selectedLocation,
              items:
                  locations.isEmpty
                      ? [widget.currentProperty.location ?? 'Unknown']
                      : locations,
              onChanged: (value) => setState(() => _selectedLocation = value),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildDropdown(
              label: 'Property Type',
              value: _selectedPropertyType,
              items:
                  propertyTypes.isEmpty
                      ? [widget.currentProperty.propertyType ?? 'apartment']
                      : propertyTypes.toSet().toList(),
              onChanged:
                  (value) => setState(() => _selectedPropertyType = value),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items:
                  items
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyComparisonButton(String propertyId, String city) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _showPropertySelectionSheet(propertyId, city),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B82F6),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            _selectedProperties.isEmpty
                ? 'Select Properties to Compare'
                : 'Comparing with ${_selectedProperties.length} ${_selectedProperties.length == 1 ? 'property' : 'properties'}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        if (_selectedProperties.length >= _maxSelection)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Maximum $_maxSelection properties can be compared',
              style: const TextStyle(fontSize: 12, color: Color(0xFFFF9800)),
            ),
          ),
      ],
    );
  }

  List<LineChartBarData> _buildChartLines(List<_ChartPoint> myPropertyData) {
    final lines = <LineChartBarData>[];

    // Main property line
    lines.add(_buildMainPropertyLine(myPropertyData));

    if (_comparisonType == 'locality') {
      final localityData = _getLocalityChartData();
      if (localityData.isNotEmpty) {
        lines.add(
          _buildComparisonLine(
            localityData,
            _comparisonColors[0],
            isDashed: true,
          ),
        );
      }
    } else {
      for (int i = 0; i < _selectedProperties.length; i++) {
        lines.add(
          _buildComparisonLine(
            _selectedProperties[i].chartData,
            _comparisonColors[i % _comparisonColors.length],
          ),
        );
      }
    }

    return lines;
  }

  LineChartBarData _buildMainPropertyLine(List<_ChartPoint> data) {
    return LineChartBarData(
      isCurved: true,
      curveSmoothness: 0.35,
      barWidth: 3,
      color: const Color(0xFF3B82F6),
      belowBarData: BarAreaData(
        show: true,
        color: const Color(0xFF3B82F6).withOpacity(0.1),
      ),
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, _, __, index) {
          final point = data[index];
          return FlDotCirclePainter(
            radius: 5,
            color:
                point.isPast
                    ? const Color(0xFF10B981)
                    : const Color(0xFFFF9800),
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        },
      ),
      spots: [
        for (int i = 0; i < data.length; i++)
          FlSpot(i.toDouble(), data[i].price.toDouble()),
      ],
    );
  }

  LineChartBarData _buildComparisonLine(
    List<_ChartPoint> data,
    Color color, {
    bool isDashed = false,
  }) {
    return LineChartBarData(
      isCurved: true,
      curveSmoothness: 0.35,
      barWidth: 2.5,
      color: color,
      dashArray: isDashed ? [5, 5] : null,
      belowBarData: BarAreaData(show: false),
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, _, __, ___) {
          return FlDotCirclePainter(
            radius: 4,
            color: color,
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        },
      ),
      spots: [
        for (int i = 0; i < data.length; i++)
          FlSpot(i.toDouble(), data[i].price.toDouble()),
      ],
    );
  }

  FlTitlesData _buildTitles(List<_ChartPoint> data) {
    return FlTitlesData(
      show: true,
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                _formatCurrency(value),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          reservedSize: 28,
          getTitlesWidget: (value, meta) {
            final index = value.round();
            if (index < 0 || index >= data.length) {
              return const SizedBox.shrink();
            }
            final point = data[index];
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                point.year.toString(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: point.isPast ? Colors.grey[700] : Colors.grey[500],
                ),
              ),
            );
          },
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  LineTouchData _buildTouch(List<_ChartPoint> data) {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        getTooltipItems: (spots) {
          return spots.map((s) {
            final lineIndex = s.barIndex;
            String label = 'My Property';
            Color color = const Color(0xFF3B82F6);

            if (_comparisonType == 'locality' && lineIndex == 1) {
              label = _selectedLocation ?? 'Locality';
              color = _comparisonColors[0];
            } else if (_comparisonType == 'property' &&
                lineIndex > 0 &&
                lineIndex - 1 < _selectedProperties.length) {
              label = _selectedProperties[lineIndex - 1].title;
              color =
                  _comparisonColors[(lineIndex - 1) % _comparisonColors.length];
            }

            return LineTooltipItem(
              '$label\n${_formatCurrencyFull(s.y)}',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            );
          }).toList();
        },
      ),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _legendItem('My Property', const Color(0xFF3B82F6)),
        if (_comparisonType == 'locality' && _selectedLocation != null)
          _legendItem('${_selectedLocation!} Avg', _comparisonColors[0]),
        if (_comparisonType == 'property')
          ..._selectedProperties.asMap().entries.map((entry) {
            return _legendItem(
              entry.value.title,
              _comparisonColors[entry.key % _comparisonColors.length],
            );
          }),
      ],
    );
  }

  Widget _legendItem(String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
          text.length > 20 ? '${text.substring(0, 20)}...' : text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  void _showPropertySelectionSheet(String propertyId, String city) {
    final controller = Get.put(
      InsightsPropertyController(city: city),
      tag: 'Matrix_$propertyId',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              /// ───────── Header ─────────
              Obx(() {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Text(
                        'Compare Properties',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      if (controller.selectedPropertyIds.isNotEmpty)
                        TextButton(
                          onPressed: controller.clearSelection,
                          child: const Text('Clear All'),
                        ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                );
              }),

              /// ───────── Property List ─────────
              Expanded(
                child: Obx(() {
                  /// Initial loading
                  if (controller.isLoading.value && controller.items.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  /// Empty state
                  if (controller.items.isEmpty) {
                    return const Center(child: Text('No properties found'));
                  }

                  return NotificationListener<ScrollNotification>(
                    onNotification: (scroll) {
                      if (scroll.metrics.pixels >=
                              scroll.metrics.maxScrollExtent - 200 &&
                          controller.hasMore.value &&
                          !controller.isPaging.value) {
                        controller.loadMore();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount:
                          controller.items.length +
                          (controller.isPaging.value ? 1 : 0),
                      itemBuilder: (_, index) {
                        if (index >= controller.items.length) {
                          return const Padding(
                            padding: EdgeInsets.all(12),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final item = controller.items[index];

                        return Obx(() {
                          final isSelected = controller.selectedPropertyIds
                              .contains(item.id);

                          final imageUrl =
                              item.propertyMedia?.images?.isNotEmpty == true
                                  ? item.propertyMedia!.images!.first
                                  : null;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CustomImage(
                                type:
                                    imageUrl != null
                                        ? CustomImageType.network
                                        : CustomImageType.asset,
                                src: imageUrl ?? IMGRes.home1,
                                height: 100,
                                width: 100,
                              ),
                              title: Text(
                                PropertyNameManager(item).displayName ?? '',
                              ),
                              subtitle: Text(item.city ?? ''),
                              trailing: Checkbox(
                                value: isSelected,
                                onChanged:
                                    (_) => controller.toggleSelection(
                                      item.id ?? '',
                                    ),
                              ),
                              onTap:
                                  () =>
                                      controller.toggleSelection(item.id ?? ''),
                            ),
                          );
                        });
                      },
                    ),
                  );
                }),
              ),

              /// ───────── Done Button ─────────
              Obx(() {
                final count = controller.selectedPropertyIds.length;

                return Container(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      /// Use controller.selectedPropertyIds
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      count == 0 ? 'Done' : 'Show Comparison ($count)',
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
