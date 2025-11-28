import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalyticsPieChart extends StatelessWidget {
  final int favorites;
  final int inquiries;
  final int views;
  final int visits;

  AnalyticsPieChart({
    required this.favorites,
    required this.inquiries,
    required this.views,
    required this.visits,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: _card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "📊 Property Analytics Overview",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: visits.toDouble(),
                        color: Colors.blue,
                        title: "",
                      ),
                      PieChartSectionData(
                        value: favorites.toDouble(),
                        color: Colors.green,
                        title: "",
                      ),
                      PieChartSectionData(
                        value: views.toDouble(),
                        color: Colors.orange,
                        title: "",
                      ),
                      PieChartSectionData(
                        value: inquiries.toDouble(),
                        color: Colors.red,
                        title: "",
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _legend("Total Views", views, Colors.orange),
                  _legend("Total Shares", favorites, Colors.green),
                  _legend("Total Inquiries", inquiries, Colors.red),
                  _legend("Total Visits", visits, Colors.blue),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legend(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(width: 10, height: 10, color: color),
          SizedBox(width: 8),
          Text("$label: "),
          Text(value.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  final BoxDecoration _card = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 6,
        offset: Offset(0, 2),
      ),
    ],
  );
}
