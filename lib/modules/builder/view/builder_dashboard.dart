import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';

class BuilderDashboard extends StatelessWidget {
  const BuilderDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
             color: ColorRes.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Manage your properties efficiently',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.home_work_rounded, size: 40, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Metrics Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildMetricCard('Total Properties', '24', Icons.apartment_rounded, const Color(0xFF6366F1)),
                _buildMetricCard('Active Leads', '156', Icons.people_rounded, const Color(0xFFEC4899)),
                _buildMetricCard('Sold Units', '18', Icons.check_circle_rounded, const Color(0xFF10B981)),
                _buildMetricCard('Revenue', '₹2.4Cr', Icons.currency_rupee_rounded, const Color(0xFFF59E0B)),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Activities
            Text('Recent Activities', style: TextStyle(fontSize: AppFontSizes.body, fontWeight: FontWeight.w600, color: ColorRes.textPrimary)),
            const SizedBox(height: 12),
            _buildActivityItem('New lead for Skyline Tower', '2 hours ago', Icons.person_add_rounded, Colors.blue),
            _buildActivityItem('Property listed successfully', '5 hours ago', Icons.check_circle_rounded, Colors.green),
            _buildActivityItem('Site visit scheduled', '1 day ago', Icons.calendar_today_rounded, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Container(

      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:color.withOpacity(0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3),width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withOpacity(0.3),width: 1),),
            child: Icon(icon, size: 20, color: color),
          ),
          Text(value, style: TextStyle(fontSize: AppFontSizes.large, fontWeight: FontWeight.w600, color: ColorRes.textPrimary)),
          Text(label, style: TextStyle(fontSize: AppFontSizes.small, color: ColorRes.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: AppFontSizes.bodySmall, fontWeight: FontWeight.w600, color: ColorRes.textPrimary)),
                Text(time, style: TextStyle(fontSize: AppFontSizes.small, color: ColorRes.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
