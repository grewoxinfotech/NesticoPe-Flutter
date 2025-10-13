import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';

import '../../dashboard/views/dashboard_screen.dart';
import '../../reseller/view/property_reseller.dart';

class BuilderDashboard extends StatelessWidget {
  const BuilderDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: ColorRes.white,
      appBar: AppBar(
        title: Text('Dashboard', style: TextStyle(fontWeight: AppFontWeights.semiBold)),
        backgroundColor: ColorRes.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(onPressed: () {
            Get.offAll(() => DashboardScreen());
          }, child: Text('Back')),
        ],
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
                            fontSize: AppFontSizes.subtitle,
                            fontWeight: AppFontWeights.extraBold,
                            color: ColorRes.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Manage your properties efficiently',
                          style: TextStyle(
                            fontSize: AppFontSizes.bodySmall,
                            color: ColorRes.white.withOpacity(0.9),
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
                      color: ColorRes.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.home_work_rounded, size: 40, color: ColorRes.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            ///Font not change from it ============================================

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                buildMetricCard('Total Properties', '24', Icons.apartment_rounded, const Color(0xFF6366F1)),
                buildMetricCard('Active Leads', '156', Icons.people_rounded, const Color(0xFFEC4899)),
                buildMetricCard('Sold Units', '18', Icons.check_circle_rounded, const Color(0xFF10B981)),
                buildMetricCard('Revenue', '₹2.4Cr', Icons.currency_rupee_rounded, const Color(0xFFF59E0B)),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Activities
            Text('Recent Activities', style: TextStyle(fontSize: AppFontSizes.body, fontWeight: AppFontWeights.semiBold, color: ColorRes.textPrimary)),
            const SizedBox(height: 12),
            _buildActivityItem('New lead for Skyline Tower', '2 hours ago', Icons.person_add_rounded, ColorRes.blueColor),
            _buildActivityItem('Property listed successfully', '5 hours ago', Icons.check_circle_rounded, ColorRes.green),
            _buildActivityItem('Site visit scheduled', '1 day ago', Icons.calendar_today_rounded, ColorRes.orangeColor),
          ],
        ),
      ),
    );
  }



  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor.shade200),
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
                Text(title, style: TextStyle(fontSize: AppFontSizes.bodySmall, fontWeight: AppFontWeights.semiBold, color: ColorRes.textPrimary)),
                Text(time, style: TextStyle(fontSize: AppFontSizes.small, color: ColorRes.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
