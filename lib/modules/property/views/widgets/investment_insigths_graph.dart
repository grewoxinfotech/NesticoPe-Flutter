import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../data/network/property/models/property_model.dart';

class InvestmentInsightChart extends StatelessWidget {
  final InvestmentInsight insight;

  const InvestmentInsightChart({super.key, required this.insight});

  String formatCurrency(num value) {
    return NumberFormat.compactCurrency(
      decimalDigits: 1,
      symbol: '₹',
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    final priceTrend = insight.priceTrend;
    final future = insight.futureProjection;

    if (priceTrend == null || future == null) {
      return const SizedBox.shrink();
    }

    // Build past & future values list for chart
    final List<Map<String, dynamic>> chartData = [
      {"year": 2022, "price": priceTrend.past5yrPrice},
      {"year": 2023, "price": priceTrend.past5yrPrice! + 100000}, // dummy
      {"year": 2024, "price": (priceTrend.currentPrice! * 0.95)},
      {"year": 2025, "price": priceTrend.currentPrice},
      {"year": 2026, "price": future.projectedPrice5yr! * 0.95},
      {"year": 2027, "price": future.projectedPrice5yr! * 0.93},
      {"year": 2028, "price": future.projectedPrice5yr},
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─────────────────────────────── TOP LABELS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInsightItem(
                icon: Icons.trending_up,
                color: Colors.green,
                label: "Past 5yr Growth",
                value: "${priceTrend.growthPercentage5yr?.toStringAsFixed(1)}%",
                sub: "CAGR: ${priceTrend.cagrPercentage?.toStringAsFixed(1)}%",
              ),
              _buildInsightItem(
                icon: Icons.show_chart,
                color: Colors.blue,
                label: "Projected 5yr ROI",
                value: "${future.roiPercentage5yr?.toStringAsFixed(1)}%",
                sub: "Future Estimate",
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ─────────────────────────────── CHART
          SizedBox(
            height: 260,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, horizontalInterval: 0.2),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget:
                          (v, meta) => Text(
                            formatCurrency(v),
                            style: const TextStyle(fontSize: 11),
                          ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, meta) {
                        int index = v.toInt();
                        if (index < 0 || index >= chartData.length)
                          return const SizedBox();
                        return Text(chartData[index]["year"].toString());
                      },
                    ),
                  ),
                ),
                minX: 0,
                maxX: (chartData.length - 1).toDouble(),
                minY:
                    chartData
                        .map((e) => e["price"])
                        .reduce((a, b) => a < b ? a : b) *
                    0.95,
                maxY:
                    chartData
                        .map((e) => e["price"])
                        .reduce((a, b) => a > b ? a : b) *
                    1.05,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (int i = 0; i < chartData.length; i++)
                        FlSpot(i.toDouble(), chartData[i]["price"] * 1.0),
                    ],
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ─────────────────────────────── FOOTER LINK
          InkWell(
            onTap: () {},
            child: const Text(
              "See city wide trends →",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem({
    required IconData icon,
    required String value,
    required String label,
    required String sub,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(label, style: const TextStyle(fontSize: 12)),
            Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}
