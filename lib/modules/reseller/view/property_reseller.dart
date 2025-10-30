import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/reseller/view/profile/reseller_profile.dart';
import 'package:housing_flutter_app/modules/seller/module/lead_screen/controllers/lead_controller.dart';
import 'package:housing_flutter_app/modules/seller/module/lead_screen/model/lead_model.dart';
import 'package:housing_flutter_app/modules/reseller/widget/graph/linear_graph.dart';

import '../../../app/constants/size_manager.dart';
import '../../../app/manager/property/property_pricemanager.dart';
import '../../../app/utils/formater/formater.dart';
import '../../../utils/global.dart';
import '../../dashboard/views/dashboard_screen.dart';
import '../../profile/views/profile_screen.dart';
import '../../seller/module/lead_screen/views/lead_screen_enhanced.dart';
import '../controller/dashborad_controller/dashboard_controller.dart';
import '../model/dashboard/dashboard_model.dart';
import 'lead/lead_screen.dart';
import 'lead_overview/lead_detail.dart';
import 'listing/property_listing.dart';

// Dashboard Screen
class ResellerDashboardScreen extends StatelessWidget {
  const ResellerDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(DashboardController());

    return Scaffold(
      backgroundColor: ColorRes.bgColor,
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(fontWeight: AppFontWeights.extraBold),
        ),
        backgroundColor: ColorRes.bgColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              Get.offAll(() => DashboardScreen());
            },
            child: Text('Back'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.recentLeads.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.refreshDashboard,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overview Cards
                buildOverviewCards(controller),
                const SizedBox(height: 20),

                // Monthly Performance Section (NEW)
                // buildMonthlyPerformance(controller),
                buildMonthlyPerformance(
                  title: 'Monthly Performance',
                  levelName: 'Pro Level',
                  levelIcon: Icons.star,
                  levelIconColor: ColorRes.orangeColor,
                  benefits: ['Priority Support', 'Access to Premium Listings'],
                  progressValue: 0.65,
                  currentAmount: '₹65K',
                  targetAmount: '₹1L',
                  unlockMessage: '₹35K more to unlock next level!',
                  streakDays: 7,
                  commissionCurrent: '₹2.9L',
                  commissionPrevious: '₹2.3L',
                  commissionChange: '25% increase',
                  commissionPositive: true,
                  leadsCurrent: '12',
                  leadsPrevious: '9',
                  leadsChange: '33% increase',
                  leadsPositive: true,
                ),

                const SizedBox(height: 20),
                // buildDailyGoals(controller, currentStep, context),
                buildDailyGoals(
                  title: 'Daily Goal',
                  goalText: 'Try to generate 5 leads today',
                  date: '27 Oct 2025',
                  currentStep: 3,
                  totalSteps: 5,
                  currentStreak: 2,
                  primaryColor: ColorRes.purpleColor.shade500,
                  accentColor: ColorRes.homeAmber.shade800,
                  context: context,
                ),

                const SizedBox(height: 20),
                // buildBestResellerOnTheMonth(controller),
              buildBestResellerOnTheMonth(

                month: "October",
                year: "2025",
                totalCommission: "₹2.9L",
                commissionSubtitle: "2,85,000 earned this month",
                level: "Noob",
                levelSubtitle: "0% to next level",
                totalLeads: "8",
                leadsSubtitle: "Generated this month",
                commissionColor: ColorRes.success,
                levelColor: ColorRes.purpleColor.shade800,
                leadsColor: ColorRes.blueColor,
              ),

                const SizedBox(height: 20),
                // resellerLeaderBoard(controller),
              resellerLeaderBoard(
                title: 'Leaderboard',
                bannerTitle: 'Top 10 (Overall)',
                bannerSubtitle: 'Gets Extra Rewards',
                leaderboardData: [
                  {
                    'rank': 1,
                    'name': 'Rajesh Kumar',
                    'tier': 'Platinum',
                    'amount': '₹35L',
                    'emoji': '👨',
                    'isTopRank': true,
                  },
                  {
                    'rank': 2,
                    'name': 'Priya Sharma',
                    'tier': 'Platinum',
                    'amount': '₹32L',
                    'emoji': '👩',
                    'isTopRank': true,
                  },
                  {
                    'rank': 3,
                    'name': 'You',
                    'tier': 'Gold',
                    'amount': '₹29L',
                    'emoji': '⭐',
                    'isCurrentUser': true,
                  },
                  {
                    'rank': 4,
                    'name': 'Amit Patel',
                    'tier': 'Gold',
                    'amount': '₹24L',
                    'emoji': '👨',
                  },
                  {
                    'rank': 5,
                    'name': 'Neha Desai',
                    'tier': 'Silver',
                    'amount': '₹21L',
                    'emoji': '👩',
                    'isLast': true,
                  },
                ],
              ),
              const SizedBox(height: 20),
                // buildLeaderBoardRanking(controller),
              buildLeaderBoardRanking(

                title: 'Leaderboard Rankings',
                subtitle: 'Top performers across regions',
                filters: ['All', 'City-wise', 'Monthly'],
                leaderboardData: [
                  {
                    'rank': 1,
                    'name': 'Rajesh Kumar',
                    'level': 'Platinum Level',
                    'city': 'Ahmedabad',
                    'sales': '₹35L',
                    'deals': '70',
                    'color': ColorRes.orangeColor.withOpacity(0.05),
                    'borderColor': ColorRes.orangeColor.withOpacity(0.3),
                    'medalIcon': Icons.emoji_events,
                  },
                  {
                    'rank': 2,
                    'name': 'Priya Sharma',
                    'level': 'Platinum Level',
                    'city': 'Ahmedabad',
                    'sales': '₹32L',
                    'deals': '64',
                    'color': ColorRes.orangeColor.withOpacity(0.05),
                    'borderColor': ColorRes.orangeColor.withOpacity(0.3),
                    'medalIcon': Icons.emoji_events,
                  },
                  {
                    'rank': 3,
                    'name': 'You',
                    'level': 'Gold Level',
                    'city': 'Ahmedabad',
                    'sales': '₹29L',
                    'deals': '57',
                    'color': ColorRes.green.withOpacity(0.05),
                    'borderColor': ColorRes.green.withOpacity(0.3),
                    'medalIcon': Icons.emoji_events,
                    'isCurrentUser': true,
                  },
                  {
                    'rank': 4,
                    'name': 'Amit Patel',
                    'level': 'Gold Level',
                    'city': 'Ahmedabad',
                    'sales': '₹24L',
                    'deals': '48',
                    'color': ColorRes.leadGreyColor.withOpacity(0.05),
                    'borderColor': ColorRes.leadGreyColor.withOpacity(0.3),
                    'medalIcon': null,
                  },
                  {
                    'rank': 5,
                    'name': 'Neha Desai',
                    'level': 'Silver Level',
                    'city': 'Ahmedabad',
                    'sales': '₹21L',
                    'deals': '42',
                    'color': ColorRes.blueColor.withOpacity(0.05),
                    'borderColor': ColorRes.blueColor.withOpacity(0.3),
                    'medalIcon': null,
                  },
                ],
              ),
              const SizedBox(height: 20),
                // buildTopPropertyForGoodCommission(controller),
                buildTopPropertyForGoodCommission(controller, propertyCommissionList),
                const SizedBox(height: 20),
              buildReferralProgram(
                // controller: controller,
                context: context,
                bonus: 5000,
                currentProgress: 4,
                targetProgress: 10,
                title: 'Referral Program',
                subtitle: 'Get ₹5000 for every new active reseller',
                pointsEarned: '2400',
                totalEarnings: '₹4K',
                earningSubtitle: '8 x ₹5000 each',
                referralCode: 'REF12345',
                leftIcon: Icons.card_giftcard_rounded,
                iconColor: ColorRes.textPrimary,
                iconBackground: ColorRes.textPrimary.withOpacity(0.08),
                card1BorderColor: ColorRes.homeAmber.withOpacity(0.3),
                card1BgColor: ColorRes.homeAmber.withOpacity(0.08),
                card2BorderColor: ColorRes.green.withOpacity(0.3),
                card2BgColor: ColorRes.green.withOpacity(0.08),
              ),
              const SizedBox(height: 20),
                buildLeadGraph(),
                const SizedBox(height: 20),
                buildCommissionGraph(),
                const SizedBox(height: 20),

                // Recent Leads
                _buildRecentLeads(controller),
                const SizedBox(height: 20),

                // Top Products
                buildTopProducts(controller),
                // const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }),
    );
  }
}

Widget buildTopPropertyForGoodCommission(
    DashboardController controller,
    List<Map<String, dynamic>> propertyList,
    ) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: ColorRes.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: ColorRes.leadGreyColor.withOpacity(0.3),
        width: 1,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section
        Row(
          children: [
            Icon(
              Icons.apartment_outlined,
              color: ColorRes.leadIndigoColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Best Commission',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: ColorRes.leadIndigoColor,
                      fontSize: AppFontSizes.body,
                      fontWeight: AppFontWeights.semiBold,
                    ),
                  ),
                  Text(
                    'Top earning opportunities',
                    style: TextStyle(
                      color: ColorRes.textColor,
                      fontSize: AppFontSizes.extraSmall,
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                // View all tap
              },
              child: Text(
                'View All',
                style: TextStyle(
                  color: ColorRes.leadIndigoColor,
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.medium,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Horizontal Property List
        SizedBox(
          height: 185, // enough to fit property cards
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: propertyList.length,
            itemBuilder: (context, index) {
              final property = propertyList[index];
              return Container(
                width: 280,
                margin: EdgeInsets.only(right: index == propertyList.length - 1 ? 0 : 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorRes.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ColorRes.leadGreyColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Property Image
                        Stack(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    property['image'] ??
                                        'https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),

                        // Property Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                property['title'] ?? 'Luxury Apartment',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: ColorRes.textColor,
                                  fontSize: AppFontSizes.bodyMedium,
                                  fontWeight: AppFontWeights.semiBold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                property['address'] ?? '123 Main St, City, State',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: ColorRes.leadGreyColor,
                                  fontSize: AppFontSizes.extraSmall,
                                  fontWeight: AppFontWeights.medium,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '₹${property['price'] ?? '1,00,000'}',
                                style: TextStyle(
                                  color: ColorRes.textColor,
                                  fontSize: AppFontSizes.small,
                                  fontWeight: AppFontWeights.semiBold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    '${property['views'] ?? '1.2K'} views',
                                    style: TextStyle(
                                      color: ColorRes.textColor,
                                      fontSize: AppFontSizes.extraSmall,
                                      fontWeight: AppFontWeights.medium,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Posted ${property['postedAgo'] ?? '2d'} ago',
                                    style: TextStyle(
                                      color: ColorRes.textColor,
                                      fontSize: AppFontSizes.extraSmall,
                                      fontWeight: AppFontWeights.medium,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Commission Section
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ColorRes.leadIndigoColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: ColorRes.leadIndigoColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Commission',
                                style: TextStyle(
                                  color: ColorRes.textColor,
                                  fontSize: AppFontSizes.extraSmall,
                                  fontWeight: AppFontWeights.medium,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '₹${property['commission'] ?? '5,000'}',
                                style: TextStyle(
                                  color: ColorRes.leadIndigoColor,
                                  fontSize: AppFontSizes.bodyMedium,
                                  fontWeight: AppFontWeights.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: ColorRes.leadIndigoColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.trending_up,
                                  color: ColorRes.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${property['commissionRate'] ?? '5'}%',
                                  style: TextStyle(
                                    color: ColorRes.white,
                                    fontSize: AppFontSizes.small,
                                    fontWeight: AppFontWeights.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

// Helper method to build feature items
Widget _buildFeatureItem(IconData icon, String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    decoration: BoxDecoration(
      color: ColorRes.leadGreyColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 14,
          color: ColorRes.leadGreyColor,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              color: ColorRes.textColor,
              fontSize: AppFontSizes.extraSmall,
              fontWeight: AppFontWeights.medium,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

Widget buildLeadGraph() {

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: ColorRes.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: ColorRes.leadGreyColor.withOpacity(0.3),
        width: 1,
      ),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Icon(Icons.area_chart_outlined, color: ColorRes.green, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Leads',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: ColorRes.green,
                      fontSize: AppFontSizes.body,
                      fontWeight: AppFontWeights.semiBold,
                    ),
                  ),

                  Text(
                    'Monthly Overview',
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
        SizedBox(height: 12),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: MonthlyLineChart(monthlyData: monthlyData, months: months),
        ),
      ],
    ),
  );
}

Widget buildCommissionGraph() {

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: ColorRes.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: ColorRes.leadGreyColor.withOpacity(0.3),
        width: 1,
      ),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.area_chart_outlined,
              color: ColorRes.lightPurpleColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Commission',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: ColorRes.lightPurpleColor,
                      fontSize: AppFontSizes.body,
                      fontWeight: AppFontWeights.semiBold,
                    ),
                  ),

                  Text(
                    'Monthly Overview',
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
          height: 200,
          width: double.infinity,
          child: MonthlyBarChart(monthlyData: monthlyData, months: months),
        ),
      ],
    ),
  );
}

// class MonthlyBarChart extends StatelessWidget {
//   final List<double> monthlyData; // e.g., 12 values
//   final List<String> months; // e.g., ['Jan', 'Feb', ..., 'Dec']
//
//   const MonthlyBarChart({
//     Key? key,
//     required this.monthlyData,
//     required this.months,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // --- Combine data into 2-month groups ---
//     final combinedData = <double>[];
//     final combinedLabels = <String>[];
//     final combineLabel=<String>[];
//
//     for (int i = 0; i < monthlyData.length; i += 2) {
//       final val1 = monthlyData[i];
//       final val2 = (i + 1 < monthlyData.length) ? monthlyData[i + 1] : 0;
//
//       // 👉 Change to sum instead of average if needed
//       combinedData.add((val1 + val2) / 2);
//
//       // 👉 Label e.g. "Jan–Feb"
//       if (i + 1 < months.length) {
//         combineLabel.add('${months[i]}-${months[i+1]}');
//         combinedLabels.add('${months[i]}');
//       } else {
//         combinedLabels.add(months[i]);
//       }
//     }
//
//     return BarChart(
//       BarChartData(
//         maxY: 50,
//         minY: 0,
//
//         // --- we’ll ignore groupsSpace and instead space bars manually ---
//         barGroups: _createBarGroups(combinedData),
//
//         titlesData: FlTitlesData(
//           show: true,
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (value, meta) {
//                 int index = (value ~/ 2); // since x = index * 2 below
//                 if (index >= 0 && index < combinedLabels.length) {
//                   return Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text(
//                       combinedLabels[index],
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: AppFontSizes.mini,
//                         fontWeight: AppFontWeights.medium,
//                       ),
//                     ),
//                   );
//                 }
//                 return const SizedBox();
//               },
//               reservedSize: 36,
//             ),
//           ),
//           leftTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               interval: 10,
//               getTitlesWidget: (value, meta) => Text(
//                 value.toInt().toString(),
//                 style: TextStyle(fontSize: AppFontSizes.caption),
//               ),
//               reservedSize: 28,
//             ),
//           ),
//           topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         ),
//
//         gridData: FlGridData(show: false),
//
//         borderData: FlBorderData(
//           show: true,
//           border: Border(
//             bottom: BorderSide(color: ColorRes.leadGreyColor.shade300, width: 1),
//             left: BorderSide(color: ColorRes.leadGreyColor.shade300, width: 1),
//           ),
//         ),
//
//         barTouchData: BarTouchData(
//           enabled: true,
//           touchTooltipData: BarTouchTooltipData(
//             getTooltipItem: (group, groupIndex, rod, rodIndex) {
//               return BarTooltipItem(
//                 '${combineLabel[groupIndex]}\n${rod.toY.toInt()}',
//                 const TextStyle(
//                   color: ColorRes.white,
//                   fontWeight: AppFontWeights.medium,
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   // --- Proper spacing: manually offset X values ---
//   List<BarChartGroupData> _createBarGroups(List<double> data) {
//     return List.generate(
//       data.length,
//           (index) => BarChartGroupData(
//         x: index * 2, // 👈 adds spacing between groups
//         barRods: [
//           BarChartRodData(
//             toY: data[index],
//             color: ColorRes.green,
//             width: 20, // adjust bar width if you want wider bars
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(6),
//               topRight: Radius.circular(6),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class MonthlyLineChart extends StatelessWidget {
  final List<double> monthlyData;
  final List<String> months;

  const MonthlyLineChart({
    Key? key,
    required this.monthlyData,
    required this.months,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spots = List.generate(
      monthlyData.length,
      (index) => FlSpot(index.toDouble(), monthlyData[index]),
    );

    // Show only alternate month labels (Jan, Mar, May…)
    final visibleIndexes =
        List.generate(
          months.length,
          (i) => i,
        ).where((i) => i % 2 == 0).toList();

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 50,

        // --- Line style ---
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.green.shade600,
            barWidth: 2,

            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
              getDotPainter: (spot, percent, barData, index) {
                // Highlight dots for in-between months (Feb, Apr, etc.)

                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.green,
                  strokeColor: Colors.white,
                  strokeWidth: 1.5,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,

              gradient: LinearGradient(
                colors: [
                  Colors.green.withOpacity(0.25),
                  Colors.green.withOpacity(0.05),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],

        // --- Axis Titles ---
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (visibleIndexes.contains(index)) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      months[index],
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
              reservedSize: 32,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 10,
              getTitlesWidget:
                  (value, meta) => Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
              reservedSize: 28,
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
          show: false,
          drawVerticalLine: false,
          getDrawingHorizontalLine:
              (value) =>
                  FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
            left: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),

        // --- Tooltip on tap ---
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            // tooltipBgColor: Colors.black.withOpacity(0.7),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final month = months[spot.x.toInt()];
                final value = spot.y.toInt();
                return LineTooltipItem(
                  '$month\n$value',
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}

Widget buildReferralProgram({

  required BuildContext context,
  required double bonus,
  required int currentProgress,
  required double targetProgress,
  required String title,
  required String subtitle,
  required String pointsEarned,
  required String totalEarnings,
  required String earningSubtitle,
  required String referralCode,
  required IconData leftIcon,
  required Color iconColor,
  required Color iconBackground,
  required Color card1BorderColor,
  required Color card1BgColor,
  required Color card2BorderColor,
  required Color card2BgColor,

}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: ColorRes.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: ColorRes.leadGreyColor.withOpacity(0.3),
        width: 1,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section
        Row(
          children: [
            Icon(
              Icons.card_giftcard_outlined,
              color: ColorRes.purpleColor,
              size: 28,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: ColorRes.purpleColor,
                        fontSize: AppFontSizes.body,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ColorRes.textColor,
                        fontSize: AppFontSizes.caption,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Two cards: points earned and total earnings
        Row(
          children: [
            Expanded(
              child: buildReferralCard(
                iconBgColor: iconBackground,
                iconColor: iconColor,
                icon: Icons.safety_check_outlined,
                subtitle: 'From referrals',
                title: 'Points earned',
                amount: 2400.toString(),
                backgroundColor: card1BgColor,
                borderColor: card1BorderColor
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: buildReferralCard(
                  iconBgColor: iconBackground,
                  iconColor: iconColor,
                  icon: Icons.safety_check_outlined,
                  subtitle: earningSubtitle,
                  title: 'Total earnings',
                  amount: totalEarnings.toString(),
                  backgroundColor: card2BgColor,
                  borderColor: card2BorderColor
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Referral Code Section
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ColorRes.leadGreyColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: ColorRes.textPrimary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          leftIcon,
                          color: iconColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Referral Code',
                              style: TextStyle(
                                color: ColorRes.textSecondary,
                                fontSize: AppFontSizes.caption,
                                fontWeight: AppFontWeights.medium,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              referralCode,
                              style: TextStyle(
                                color: ColorRes.textPrimary,
                                fontSize: AppFontSizes.medium,
                                fontWeight: AppFontWeights.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: referralCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Referral code copied!'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: ColorRes.textPrimary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.copy_rounded,
                            color: ColorRes.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Progress Section
        buildProgressSection(
          bonusAmount: bonus,
          currentProgress: currentProgress,
          targetProgress: targetProgress,
        ),
      ],
    ),
  );
}





Widget buildLeaderBoardRanking({

  required String title,
  required String subtitle,
  required List<String> filters,
  required List<Map<String, dynamic>> leaderboardData,
  Color headerIconColor = const Color(0xFFFF9800),
  Color defaultFilterColor = Colors.grey,
  Color activeFilterColor = Colors.orange,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: ColorRes.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: ColorRes.leadGreyColor.withOpacity(0.3),
        width: 1,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section
        Row(
          children: [
            Icon(
              Icons.emoji_events_outlined,
              color: headerIconColor,
              size: 28,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: headerIconColor,
                      fontSize: AppFontSizes.body,
                      fontWeight: AppFontWeights.semiBold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: ColorRes.textColor,
                      fontSize: AppFontSizes.caption,
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Filter Chips Row
        Row(
          children: List.generate(filters.length, (index) {
            final bool isActive = index == 0;
            final Color filterColor =
            isActive ? activeFilterColor : defaultFilterColor;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index != filters.length - 1 ? 8 : 0),
                child: buildFilterChip(
                  filters[index],
                  filterColor,
                  isActive,
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 16),

        // Dynamic Leader Cards
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: leaderboardData.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final data = leaderboardData[index];
            return buildLeaderCard(
              rank: data['rank'],
              name: data['name'],
              level: data['level'],
              city: data['city'],
              sales: data['sales'],
              deals: data['deals'],
              color: data['color'],
              borderColor: data['borderColor'],
              medalIcon: data['medalIcon'],
              isCurrentUser: data['isCurrentUser'] ?? false,
            );
          },
        ),
      ],
    ),
  );
}


Widget buildFilterChip(String label, Color color, bool isSelected) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: isSelected ? color : color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: isSelected ? color : color.withOpacity(0.3),
        width: 1.4,
      ),
    ),
    child: Center(
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: AppFontWeights.medium,
          fontSize: AppFontSizes.caption,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget buildLeaderCard({
  required int rank,
  required String name,
  required String level,
  required String city,
  required String sales,
  required String deals,
  required Color color,
  required Color borderColor,
  IconData? medalIcon,
  required bool isCurrentUser,
}) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: borderColor, width: 1.3),
    ),
    child: Row(
      children: [
        // Rank and Avatar Section
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                    isCurrentUser
                        ? ColorRes.orangeColor[700]
                        : ColorRes.leadGreyColor[300],
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    'https://randomuser.me/api/portraits/men/1.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (rank <= 3 && medalIcon != null)
              Positioned(
                top: -6,
                right: -6,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color:
                        rank == 1
                            ? ColorRes.homeAmber
                            : rank == 2
                            ? ColorRes.leadGreyColor
                            : ColorRes.orangeColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      rank.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: AppFontWeights.semiBold,
                        fontSize: AppFontSizes.caption,
                      ),
                    ),
                  ),
                ),
              ),
            if (rank > 3)
              Positioned(
                top: -6,
                right: -6,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      rank.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: AppFontWeights.semiBold,
                        fontSize: AppFontSizes.caption,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 16),
        // User Info Section
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 145,
                child: Text(
                  '${name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.blackShade87,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                level,
                style: TextStyle(
                  fontSize: AppFontSizes.extraSmall,
                  color: ColorRes.grey,
                  fontWeight: AppFontWeights.regular,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                city,
                style: TextStyle(
                  fontSize: AppFontSizes.caption,
                  color: ColorRes.purpleColor,
                  fontWeight: AppFontWeights.regular,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Stats Section
        Expanded(
          flex: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  Text(
                    'SALES',
                    style: TextStyle(
                      fontSize: AppFontSizes.extraSmall,
                      color: ColorRes.leadGreyColor,
                      fontWeight: AppFontWeights.medium,
                      // letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sales,
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      color: ColorRes.green,
                      fontWeight: AppFontWeights.semiBold,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8),
              Column(
                children: [
                  Text(
                    'DEALS',
                    style: TextStyle(
                      fontSize: AppFontSizes.extraSmall,
                      color: ColorRes.leadGreyColor,
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    deals,
                    style: const TextStyle(
                      fontSize: AppFontSizes.medium,
                      color: ColorRes.green,
                      fontWeight: AppFontWeights.semiBold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget resellerLeaderBoard({

  required String title,
  required String bannerTitle,
  required String bannerSubtitle,
  required List<Map<String, dynamic>> leaderboardData,
  Color headerColor = const Color(0xFF6366F1),
  Color bannerColor = const Color(0xFFFEF3E2),
  Color bannerBorderColor = const Color(0xFFFBBF24),
  Color bannerIconColor = Colors.orange,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.emoji_events_outlined,
                color: headerColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: AppFontSizes.body,
                  fontWeight: AppFontWeights.semiBold,
                  color: headerColor,
                ),
              ),
            ],
          ),
        ),

        // Top 10 Banner
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bannerColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: bannerBorderColor, width: 1.5),
          ),
          child: Row(
            children: [
              Icon(
                Icons.emoji_events_outlined,
                color: bannerIconColor,
                size: 40,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bannerTitle,
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.medium,
                      color: bannerIconColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        bannerSubtitle,
                        style: TextStyle(
                          fontSize: AppFontSizes.caption,
                          color: ColorRes.textColor,
                          fontWeight: AppFontWeights.regular,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Dynamic Leaderboard Items
        for (int i = 0; i < leaderboardData.length; i++)
          buildLeaderboardItem(
            rank: leaderboardData[i]['rank'],
            name: leaderboardData[i]['name'],
            tier: leaderboardData[i]['tier'],
            amount: leaderboardData[i]['amount'],
            emoji: leaderboardData[i]['emoji'],
            isTopRank: leaderboardData[i]['isTopRank'] ?? false,
            isCurrentUser: leaderboardData[i]['isCurrentUser'] ?? false,
            isLast: leaderboardData[i]['isLast'] ?? false,
          ),
      ],
    ),
  );
}


Widget buildLeaderboardItem({
  required int rank,
  required String name,
  required String tier,
  required String amount,
  required String emoji,
  bool isTopRank = false,
  bool isCurrentUser = false,
  bool isLast = false,
}) {
  return Container(
    margin: EdgeInsets.only(
      // top: isTopRank? 16 : 12,
      right: 16,
      left: 16,
      // bottom: isLast? 16 : 12,
      bottom: isLast ? 16 : 12,
    ),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color:
          isCurrentUser
              ? const Color(0xFFEEF2FF)
              : ColorRes.leadGreyColor.shade50,
      borderRadius: BorderRadius.circular(12),
      border:
          isCurrentUser
              ? Border.all(color: ColorRes.primary, width: 2)
              : Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
    ),
    child: Row(
      children: [
        // Rank Medal or Number
        SizedBox(
          width: 40,
          child:
              rank <= 3 && isTopRank
                  ? Text(
                    rank == 1 ? '🏆' : '🥈',
                    style: const TextStyle(fontSize: 20),
                  )
                  : rank == 3 && isCurrentUser
                  ? const Text('🥉', style: TextStyle(fontSize: 20))
                  : Text(
                    '#$rank',
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.blackShade87,
                    ),
                  ),
        ),
        const SizedBox(width: 12),

        // Avatar

        // Name and Tier
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: AppFontSizes.bodySmall,
                  fontWeight: AppFontWeights.medium,
                  color: ColorRes.blackShade87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                tier,
                style: TextStyle(
                  fontSize: AppFontSizes.caption,
                  color: ColorRes.leadGreyColor.shade500,
                ),
              ),
            ],
          ),
        ),

        // Amount
        Text(
          amount,
          style: TextStyle(
            fontSize: AppFontSizes.body,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.green,
          ),
        ),
      ],
    ),
  );
}

Widget buildBestResellerOnTheMonth({

  required String month,
  required String year,
  required String totalCommission,
  required String commissionSubtitle,
  required String level,
  required String levelSubtitle,
  required String totalLeads,
  required String leadsSubtitle,
  required Color commissionColor,
  required Color levelColor,
  required Color leadsColor,
  String motivationalText =
  "Keep up the excellent work! You're on track for greatness!",
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      color: ColorRes.white,
      border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.emoji_events,
              color: ColorRes.homeAmber.shade800,
              size: 35,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: AppFontSizes.body,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textPrimary,
                    ),
                    children: [
                      const TextSpan(text: 'Best Reseller '),
                      TextSpan(
                        text: 'of the Month',
                        style: TextStyle(
                          color: ColorRes.error,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$month $year',
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    fontWeight: AppFontWeights.medium,
                    color: ColorRes.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Commission Card
        buildCommissionCard(
          title: 'Total Commission',
          subtitle: commissionSubtitle,
          amount: totalCommission,
          backgroundColor: commissionColor.withOpacity(0.05),
          borderColor: commissionColor,
        ),

        const SizedBox(height: 12),

        // Level Card
        buildCommissionCard(
          title: 'Current Level',
          subtitle: levelSubtitle,
          amount: level,
          backgroundColor: levelColor.withOpacity(0.05),
          borderColor: levelColor,
          icon: Icons.emoji_events_outlined,
          iconBgColor: levelColor,
        ),

        const SizedBox(height: 12),

        // Leads Card
        buildCommissionCard(
          title: 'Total Leads',
          amount: totalLeads,
          borderColor: leadsColor,
          backgroundColor: leadsColor.withOpacity(0.05),
          subtitle: leadsSubtitle,
          iconBgColor: leadsColor,
          icon: Icons.call_made_outlined,
        ),

        const SizedBox(height: 16),

        // Motivational Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            gradient: LinearGradient(
              colors: [
                ColorRes.homeAmber.shade800.withOpacity(0.08),
                ColorRes.orangeColor.shade800.withOpacity(0.08),
                ColorRes.error.shade800.withOpacity(0.08),
              ],
            ),
            border: Border.all(
              width: 1,
              color: ColorRes.homeAmber.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: ColorRes.homeAmber.shade800,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  motivationalText,
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    fontWeight: AppFontWeights.medium,
                    color: ColorRes.homeAmber.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


Widget buildCommissionCard({
  required String title,
  required String subtitle,
  required String amount,
  IconData icon = Icons.currency_rupee,
  Color iconBgColor = Colors.green,
  Color iconColor = Colors.white,
  required Color backgroundColor, // green with 5% opacity
  required Color borderColor, // green with 20% opacity
}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(width: 1, color: borderColor.withOpacity(0.3)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon Box
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: iconBgColor,
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 12),

        // Text Column
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: AppFontSizes.small,
                // Replace with AppFontSizes.extraSmall
                fontWeight: AppFontWeights.semiBold,
                // Replace with AppFontWeights.semiBold
                color:
                    ColorRes.textColor, // Replace with ColorRes.textSecondary
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: AppFontSizes.extraSmall,
                // Replace with AppFontSizes.extraSmall
                fontWeight: AppFontWeights.medium,
                // Replace with AppFontWeights.semiBold
                color:
                    ColorRes
                        .leadGreyColor, // Replace with Cplace with ColorRes.textSecondary
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
        const Spacer(),

        // Amount Text
        Text(
          amount,
          style: TextStyle(
            fontSize: AppFontSizes.body,
            // Replace with AppFontSizes.large
            fontWeight: AppFontWeights.semiBold,
            // Replace with AppFontWeights.bold
            color: ColorRes.black, // Replace with ColorRes.textPrimary
          ),
        ),
      ],
    ),
  );
}

Widget buildDailyGoals({
  required String title,
  required String goalText,
  required String date,
  required int totalSteps,
  required int currentStep,
  required int currentStreak,
  required Color primaryColor,
  required Color accentColor,
  required BuildContext context,
}) {
  final completedSteps = currentStep.clamp(0, totalSteps);
  final double progress = (completedSteps / totalSteps).clamp(0.0, 1.0);
  final remainingSteps = totalSteps - completedSteps;
  final progressPercent = (completedSteps / totalSteps * 100).toInt();

  return Container(
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      color: ColorRes.white,
      border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor.withOpacity(0.05),
                accentColor.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: primaryColor.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.bolt,
                  color: accentColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title, // applied title parameter
                          style: TextStyle(
                            fontSize: AppFontSizes.bodyMedium,
                            fontWeight: AppFontWeights.bold,
                            color: ColorRes.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            date, // applied date parameter
                            style: TextStyle(
                              fontSize: AppFontSizes.mini,
                              fontWeight: AppFontWeights.medium,
                              color: accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      goalText, // applied goalText parameter
                      style: TextStyle(
                        fontSize: AppFontSizes.extraSmall,
                        fontWeight: AppFontWeights.regular,
                        color: ColorRes.leadGreyColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Progress Bar with Dots
        LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;

            return Stack(
              children: [
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: primaryColor.withOpacity(0.08),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  height: 20,
                  width: totalWidth * progress,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color:
                    completedSteps > 0 ? primaryColor : Colors.transparent,
                  ),
                ),
                // Dots overlay
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(totalSteps + 1, (index) {
                      bool isActive = index <= completedSteps;
                      bool isFirst = index == 0;
                      bool isLast = index == totalSteps;

                      return Container(
                        margin: EdgeInsets.only(
                          left: isFirst ? 0 : 0,
                          right: isLast ? 0 : 0,
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: isActive
                                ? ColorRes.green.shade400
                                : ColorRes.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isActive
                                  ? ColorRes.green.shade400
                                  : ColorRes.green.shade300,
                              width: 1,
                            ),
                            boxShadow: isActive
                                ? [
                              BoxShadow(
                                offset: const Offset(0, 2),
                                blurRadius: 8,
                                spreadRadius: 0,
                                color: ColorRes.green.shade400
                                    .withOpacity(0.4),
                              ),
                            ]
                                : null,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 12),

        // Numbers below progress bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalSteps + 1, (index) {
              bool isActive = index <= completedSteps;
              return Text(
                "$index",
                style: TextStyle(
                  fontWeight: AppFontWeights.semiBold,
                  fontSize: AppFontSizes.small,
                  color: isActive
                      ? ColorRes.green.shade600
                      : ColorRes.textPrimary.withOpacity(0.5),
                ),
              );
            }),
          ),
        ),

        const SizedBox(height: 16),

        // Stats Section
        Row(
          children: [
            Expanded(
              child: buildStatItem(
                value: '$completedSteps',
                label: 'Completed',
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: buildStatItem(
                value: '$remainingSteps',
                label: 'Remaining',
                color: primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: buildStatItem(
                value: '$progressPercent%',
                label: 'Progress',
                color: ColorRes.green.shade400,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: buildStatItem(
                value: '🔥 $currentStreak',
                label: 'Current Streak',
                color: ColorRes.orangeColor,
                valueColor: ColorRes.orangeColor,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// Helper method for stat items (you'll need to add this if not already present)
Widget buildStatItem({
  required String value,
  required String label,
  required Color color,
  Color? valueColor,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: color.withOpacity(0.08),
      border: Border.all(color: color.withOpacity(0.3), width: 1),
    ),
    child: Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: AppFontSizes.body,
            fontWeight: AppFontWeights.semiBold,
            color: valueColor ?? color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: AppFontSizes.mini,
            fontWeight: AppFontWeights.medium,
            color: ColorRes.textPrimary.withOpacity(0.7),
          ),
        ),
      ],
    ),
  );
}

Widget buildOverviewCards(DashboardController controller) {
  return Obx(() {
    final metrics = controller.metrics.value;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        buildMetricCard(
          'Property Sales',
          '\$${(metrics.totalSales / 1000000).toStringAsFixed(2)}M',
          Icons.home_work,
          ColorRes.success,
        ),
        buildMetricCard(
          'Buyer Leads',
          '${metrics.totalLeads}',
          Icons.people,
          ColorRes.blueColor,
        ),
        buildMetricCard(
          'Listed Properties',
          '${metrics.totalProducts}',
          Icons.apartment,
          ColorRes.orangeColor,
        ),
        buildMetricCard(
          'Sales Growth',
          '${metrics.growthPercentage.toStringAsFixed(1)}%',
          Icons.trending_up,
          ColorRes.purpleColor,
        ),
      ],
    );
  });
}

Widget _buildRecentLeads(DashboardController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Buyer Leads',
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => ResellerLeadScreen(isViewAll: true));
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'View All',
                style: TextStyle(
                  fontWeight: AppFontWeights.medium,
                  color: ColorRes.primary,
                  fontSize: AppFontSizes.caption,
                ),
              ),
            ),
          ],
        ),
      ),

      // Obx(
      //   () => ListView.separated(
      //     shrinkWrap: true,
      //     physics: const NeverScrollableScrollPhysics(),
      //     itemCount: controller.recentLeads.take(5).length,
      //     separatorBuilder: (context, index) => const SizedBox(height: 10),
      //     itemBuilder: (context, index) {
      //       final lead = controller.recentLeads[index];
      //       return _buildLeadCard(context, lead, controller);
      //     },
      //   ),
      // ),
    ],
  );
}

Widget buildLeadCard(
  BuildContext context,
  LeadItem lead,
  DashboardController controller,
) {
  final isCompact = MediaQuery.of(context).size.width < 600;
  final cardPadding = isCompact ? 12.0 : 16.0;
  final priceManager = PropertyPriceManager(
    listingType: lead.customFields?.listingType ?? '',
    financialInfo: lead.customFields?.propertyDetails?.financialInfo,
  );

  return Container(
    padding: EdgeInsets.all(cardPadding),
    decoration: BoxDecoration(
      color: ColorRes.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: isCompact ? 18 : 20,
              backgroundColor: ColorRes.primary.withOpacity(0.2),
              child: Text(
                lead.name ?? '',
                style: TextStyle(
                  color: ColorRes.primary,
                  fontWeight: AppFontWeights.bold,
                  fontSize:
                      isCompact ? AppFontSizes.small : AppFontSizes.medium,
                ),
              ),
            ),
            SizedBox(width: isCompact ? 8 : 12),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 180,
                    child: Text(
                      lead.name ?? '',
                      style: TextStyle(
                        fontSize:
                            isCompact ? AppFontSizes.medium : AppFontSizes.body,
                        fontWeight: AppFontWeights.bold,
                        color: ColorRes.textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 2),
                  SizedBox(
                    width: 180,
                    child: Text(
                      '${lead.name}',
                      style: TextStyle(
                        fontSize:
                            isCompact
                                ? AppFontSizes.extraSmall
                                : AppFontSizes.small,
                        color: ColorRes.leadGreyColor[700],
                        fontWeight: AppFontWeights.regular,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (lead.email != null && lead.email!.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lead.email!.replaceRange(
                              lead.email!.length < 4 ? lead.email!.length : 4,
                              lead.email!.length,
                              '**********',
                            ),
                            style: TextStyle(
                              fontSize: AppFontSizes.extraSmall,
                              color: ColorRes.leadGreyColor[600],
                              fontWeight: AppFontWeights.regular,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Budget',
                  style: TextStyle(
                    fontSize: AppFontSizes.extraSmall,
                    color: ColorRes.leadGreyColor[800],
                    fontWeight: AppFontWeights.regular,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${priceManager.displayPrice}',
                  style: TextStyle(
                    fontSize:
                        isCompact ? AppFontSizes.medium : AppFontSizes.body,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.success,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _formatTime(lead.createdAt ?? DateTime.now()),
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.leadGreyColor[600],
                    fontWeight: AppFontWeights.regular,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: isCompact ? 8 : 12),
        Divider(color: ColorRes.leadGreyColor, thickness: 0.5),
        SizedBox(height: isCompact ? 8 : 12),

        Row(
          children: [
            // Status Badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 10 : 14,
                vertical: isCompact ? 6 : 8,
              ),
              decoration: BoxDecoration(
                color: _getStatusColor(
                  getLeadStatusFromString(lead.status ?? ""),
                ).withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getStatusColor(
                    getLeadStatusFromString(lead.status ?? ""),
                  ).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                _getStatusText(getLeadStatusFromString(lead.status ?? "")),
                style: TextStyle(
                  fontSize:
                      isCompact ? AppFontSizes.extraSmall : AppFontSizes.small,
                  color: _getStatusColor(
                    getLeadStatusFromString(lead.status ?? ''),
                  ),
                  fontWeight: AppFontWeights.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8),
            // Stage Badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 10 : 14,
                vertical: isCompact ? 6 : 8,
              ),
              decoration: BoxDecoration(
                color: _getStageColor(
                  getLeadStageFromString(lead.stage),
                ).withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getStageColor(
                    getLeadStageFromString(lead.stage),
                  ).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                _getStageText(getLeadStageFromString(lead.stage)),
                style: TextStyle(
                  fontSize:
                      isCompact ? AppFontSizes.extraSmall : AppFontSizes.small,
                  color: _getStageColor(getLeadStageFromString(lead.stage)),
                  fontWeight: AppFontWeights.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Spacer(),
            Row(
              children: [
                buildActionButton(
                  icon: Icons.visibility,
                  color: ColorRes.blueColor,
                  onPressed: () {
                    Get.to(
                      () => LeadDetailScreen(lead: lead, isFromLead: true),
                    );
                  },
                  tooltip: 'View Details',
                  isCompact: isCompact,
                ),
                SizedBox(width: 8),
                buildActionButton(
                  icon: Icons.edit,
                  color: ColorRes.orangeColor,
                  onPressed: () {},
                  // () => showLeadForm(context, controller, lead: lead),
                  tooltip: 'Edit Lead',
                  isCompact: isCompact,
                ),
                SizedBox(width: 8),
                buildActionButton(
                  icon: Icons.delete,
                  color: ColorRes.error,
                  onPressed:
                      () => showDeleteConfirmation(context, lead, controller,),
                  tooltip: 'Delete Lead',
                  isCompact: isCompact,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildTopProducts(DashboardController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Top Property',
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => ResellerLeadScreen());
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'View All',
                style: TextStyle(
                  fontWeight: AppFontWeights.medium,
                  color: ColorRes.primary,
                  fontSize: AppFontSizes.caption,
                ),
              ),
            ),
          ],
        ),
      ),
      Obx(
        () => SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: controller.topProducts.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final product = controller.topProducts[index];
              return buildProductCard(product);
            },
          ),
        ),
      ),
    ],
  );
}

Widget buildProductCard(Product product) {
  return SizedBox(
    width: 200,
    child: Container(
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  product.image,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: ColorRes.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: ColorRes.leadGreyColor.shade300,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Added Today',
                    style: TextStyle(
                      fontSize: AppFontSizes.tiny,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textPrimary,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ColorRes.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: ColorRes.textPrimary,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 160,
                  child: Text(
                    product.name,
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textColor,
                      // height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 160,
                  child: Text(
                    product.category,
                    style: TextStyle(
                      fontSize: AppFontSizes.extraSmall,
                      color: ColorRes.leadGreyColor.shade700,
                      // height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 6,
                    // runSpacing: 4,
                    children: List.generate(
                      4,
                      (index) => buildPropertyFeature(
                        Icons.square_foot,
                        '${product.area} m²',
                        isFirst: (index == 0) ? true : false,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${Formatter.formatPrice(product.price)}',
                      style: TextStyle(
                        fontSize: AppFontSizes.body,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textColor,
                        // height: 1.0,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ColorRes.primary,
                      ),
                      child: Text(
                        'Contact ',
                        style: TextStyle(
                          fontSize: AppFontSizes.extraSmall,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildPropertyFeature(
  IconData icon,
  String text, {
  bool isFirst = false,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (!isFirst) ...[
        Text('-', style: TextStyle(fontSize: AppFontSizes.extraSmall)),
        // const Text('•', style: TextStyle(fontSize: 10)),
        const SizedBox(width: 2),
      ],
      Icon(icon, size: 14, color: ColorRes.primary),
      const SizedBox(width: 3),
      Text(
        text,
        style: TextStyle(
          fontSize: AppFontSizes.mini,
          color: ColorRes.leadGreyColor.shade800,
          height: 1.0,
        ),
      ),
    ],
  );
}

Color _getStatusColor(LeadStatus status) {
  switch (status) {
    case LeadStatus.new_: // 'New'
      return ColorRes.blueColor;
    case LeadStatus.contacted:
      return ColorRes.orangeColor;
    case LeadStatus.qualified:
      return ColorRes.purpleColor;
    case LeadStatus.negotiation:
      return ColorRes.leadIndigoColor;
    case LeadStatus.lost:
      return ColorRes.error;
    case LeadStatus.convert:
      return ColorRes.leadTealColor;
    case LeadStatus.all:
    default:
      return ColorRes.leadGreyColor;
  }
}

String _getStatusText(LeadStatus status) {
  switch (status) {
    case LeadStatus.new_:
      return 'New';
    case LeadStatus.contacted:
      return 'Contacted';
    case LeadStatus.qualified:
      return 'Qualified';
    case LeadStatus.negotiation:
      return 'Negotiating';
    case LeadStatus.lost:
      return 'Lost';
    case LeadStatus.convert:
      return 'Converted';
    case LeadStatus.all:
    default:
      return 'All';
  }
}

Color _getStageColor(LeadStage stage) {
  switch (stage) {
    case LeadStage.newLead: // 'New Lead'
      return ColorRes.blueColor;
    // return Colors.blue;
    case LeadStage.contacted:
      return ColorRes.orangeColor;
    // return ;
    // return Colors.orange;
    case LeadStage.interested:
      return ColorRes.purpleColor;
    // return Colors.purple;
    case LeadStage.siteVisit:
      return ColorRes.leadIndigoColor;
    // return Colors.indigo;
    case LeadStage.sell:
      return ColorRes.success;
    // return Colors.green;
    case LeadStage.all:
    default:
      return ColorRes.leadGreyColor;
    // return Colors.grey;
  }
}

String _getStageText(LeadStage stage) {
  switch (stage) {
    case LeadStage.newLead:
      return 'New Lead';
    case LeadStage.contacted:
      return 'Contacted';
    case LeadStage.interested:
      return 'Interested';
    case LeadStage.siteVisit:
      return 'Site Visit';
    case LeadStage.sell:
      return 'Sell';
    case LeadStage.all:
    default:
      return 'All';
  }
}

String _formatTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays > 0) {
    return '${difference.inDays}d ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h ago';
  } else {
    return '${difference.inMinutes}m ago';
  }
}

Widget buildMonthlyPerformance({ required String title,
  required String levelName,
  required IconData levelIcon,
  required Color levelIconColor,
  required List<String> benefits,
  required double progressValue, // between 0.0 to 1.0
  required String currentAmount,
  required String targetAmount,
  required String unlockMessage,
  required int streakDays,
  required String commissionCurrent,
  required String commissionPrevious,
  required String commissionChange,
  required bool commissionPositive,
  required String leadsCurrent,
  required String leadsPrevious,
  required String leadsChange,
  required bool leadsPositive,}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: ColorRes.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: ColorRes.leadGreyColor.withOpacity(0.3),
        width: 1,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Icon(
              Icons.bar_chart_rounded,
              color: ColorRes.purpleColor,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              '$title',
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Level Card and Progress
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorRes.leadGreyColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColorRes.orangeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.emoji_events,
                      color: levelIconColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Level Text
                  Text(
                    '$levelName',
                    style: TextStyle(
                      fontSize: AppFontSizes.body,
                      fontWeight: AppFontWeights.bold,
                      color: ColorRes.purpleColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  // Benefits
                  // buildBenefit('✓ Basic support'),
                  // const SizedBox(height: 6),
                  // buildBenefit('✓ Access to properties'),
                  ...List.generate(benefits.length, (index)=>buildBenefit('✓ ${benefits[index]}'))
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Progress and Stats
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress to Next Level
                Row(
                  children: [
                    Icon(Icons.bolt, color: ColorRes.orangeColor, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      'Progress to Next Level',
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$currentAmount ',
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.success,
                      ),
                    ),
                    Text(
                      '/ $targetAmount',
                      style: TextStyle(
                        fontSize: AppFontSizes.caption,
                        fontWeight: AppFontWeights.medium,
                        color: ColorRes.blackShade87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progressValue,
                    backgroundColor: ColorRes.leadGreyColor.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      ColorRes.orangeColor,
                    ),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '%${progressValue*100}',
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.leadGreyColor.shade600,
                  ),
                ),
                const SizedBox(height: 12),

                // Unlock Message
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: ColorRes.homeAmber.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ColorRes.homeAmber.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.emoji_events_outlined,
                        color: ColorRes.homeAmber.shade700,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '$unlockMessage',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: AppFontSizes.small,
                            color: ColorRes.homeAmber.shade700,
                            fontWeight: AppFontWeights.medium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Streak
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: ColorRes.error.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ColorRes.error.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        color: ColorRes.error,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$streakDays day streak!',
                        style: TextStyle(
                          fontSize: AppFontSizes.caption,
                          color: ColorRes.error,
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 25),

        // Commission and Leads Stats
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Commission Card
            buildMetricComparisonCard(
              icon: Icons.account_balance_wallet,
              title: 'Comission',
              currentMonth: '$commissionCurrent',
              previousMonth: '$commissionPrevious',
              percentage: '$commissionChange',
              isPositive: commissionPositive,
            ),
            const SizedBox(height: 12),
            Divider(color: ColorRes.leadGreyColor.withOpacity(0.5)),
            const SizedBox(height: 12),
            // Leads Card
            buildMetricComparisonCard(
              icon: Icons.people,
              title: 'Leads',
              currentMonth: leadsCurrent,
              previousMonth: leadsPrevious,
              percentage: leadsChange,
              isPositive: leadsPositive,
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildBenefit(String text) {
  return Container(
    margin: EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: ColorRes.purpleColor.withOpacity(0.08),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: AppFontSizes.extraSmall,
        color: ColorRes.textColor,
        fontWeight: AppFontWeights.regular,
      ),
    ),
  );
}

Widget buildMetricComparisonCard({
  required IconData icon,
  required String title,
  required String currentMonth,
  required String previousMonth,
  required String percentage,
  required bool isPositive,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, size: 18, color: ColorRes.purpleColor),
          const SizedBox(width: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: AppFontSizes.small,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          // Current Month
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColorRes.success.withOpacity(0.08),
                border: Border.all(
                  color: ColorRes.success.shade300,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Month',
                    style: TextStyle(
                      fontSize: AppFontSizes.extraSmall,
                      color: ColorRes.textColor,
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentMonth,
                    style: TextStyle(
                      fontSize: AppFontSizes.bodyMedium,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.success,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'vs',
              style: TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.leadGreyColor.shade600,
              ),
            ),
          ),
          // Previous Month
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColorRes.leadGreyColor.withOpacity(0.08),
                border: Border.all(
                  color: ColorRes.leadGreyColor.shade300,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Previous Month',
                    style: TextStyle(
                      fontSize: AppFontSizes.extraSmall,
                      color: ColorRes.textColor,
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    previousMonth,
                    style: TextStyle(
                      fontSize: AppFontSizes.bodyMedium,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color:
              isPositive
                  ? ColorRes.success.withOpacity(0.08)
                  : ColorRes.leadGreyColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isPositive
                    ? ColorRes.success.shade300
                    : ColorRes.leadGreyColor.shade300,
            width: 0.5,
          ),
          // borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.trending_up,
              size: 14,
              color: isPositive ? ColorRes.success : ColorRes.leadGreyColor,
            ),
            const SizedBox(width: 4),
            Text(
              percentage,
              style: TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.semiBold,
                color: isPositive ? ColorRes.success : ColorRes.leadGreyColor,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

// Navigation Controller
class ResellerNavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }
}

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.put(ResellerNavigationController());
    Get.lazyPut(() => DashboardController(), tag: "reseller");
    Get.lazyPut(() => LeadController(), tag: "reseller");

    final screens = [
      const ResellerDashboardScreen(),
      ProductListingScreen(),
      ResellerLeadScreen(),
      ResellerProfileScreen(),
    ];

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: navigationController.currentIndex.value,
          children: screens,
        ),
      ),
      bottomNavigationBar: Obx(
        () => SafeArea(
          child: BottomNavigationBar(
            currentIndex: navigationController.currentIndex.value,
            onTap: navigationController.changeTabIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: ColorRes.blueColor,
            unselectedItemColor: ColorRes.leadGreyColor,
            selectedLabelStyle: TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: AppFontWeights.semiBold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: AppFontWeights.medium,
            ),
            backgroundColor: ColorRes.white,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.dashboard, size: 22),
                ),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.inventory, size: 22),
                ),
                label: 'Property',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.people, size: 22),
                ),
                label: 'Leads',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.person, size: 22),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildMetricCard(String title, String value, IconData icon, Color color) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final cardWidth = constraints.maxWidth;
      final isCompact = cardWidth < 150;

      final titleFontSize =
          isCompact ? AppFontSizes.extraSmall : AppFontSizes.small;
      final valueFontSize = isCompact ? AppFontSizes.body : AppFontSizes.large;
      final iconSize = isCompact ? 16.0 : 18.0;
      final iconPadding = isCompact ? 6.0 : 8.0;
      final cardPadding = isCompact ? 12.0 : 12.0;

      return Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: color.withOpacity(0.02),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 1, color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      color: ColorRes.leadGreyColor[600],
                      fontWeight: AppFontWeights.medium,
                      height: 1.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.all(iconPadding),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: color.withOpacity(0.3)),
                  ),
                  child: Icon(icon, color: color, size: iconSize),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: valueFontSize,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textPrimary,
                height: 1.0,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    },
  );
}

Widget buildProgressSection({
  required int currentProgress,
  required double targetProgress,
  required double bonusAmount,
}) {
  final progress = currentProgress / targetProgress;
  final remaining = targetProgress - currentProgress;

  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: ColorRes.purpleColor.withOpacity(0.08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: ColorRes.purpleColor.withOpacity(0.3),
        width: 1,
      ),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorRes.purpleColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.emoji_events_rounded,
                color: ColorRes.purpleColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: AppFontSizes.bodySmall,
                    color: ColorRes.leadGreyColor[800],
                    height: 1.2,
                  ),
                  children: [
                    TextSpan(
                      text: 'Refer ',
                      style: TextStyle(fontWeight: AppFontWeights.regular),
                    ),
                    TextSpan(
                      text: '$remaining more active resellers',
                      style: TextStyle(fontWeight: AppFontWeights.semiBold),
                    ),
                    TextSpan(
                      text: ' to unlock ',
                      style: TextStyle(fontWeight: AppFontWeights.regular),
                    ),
                    TextSpan(
                      text:
                          'BONUS ₹${bonusAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}!',
                      style: TextStyle(
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.purpleColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: ColorRes.purpleColor[100],
            valueColor: const AlwaysStoppedAnimation<Color>(
              ColorRes.purpleColor,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildReferralCard({
  required String title,
  required String amount,
  required Color borderColor,
  required Color backgroundColor,
  required String subtitle,
  required IconData icon,
  required Color iconColor,
  required Color iconBgColor,
}) {
  return Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(width: 1, color: borderColor),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: AppFontSizes.small,
            color: ColorRes.textPrimary,
            fontWeight: AppFontWeights.semiBold,
            height: 1.2,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: AppFontSizes.extraSmall,
            color: ColorRes.leadGreyColor,
            fontWeight: AppFontWeights.medium,
            height: 1.2,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                amount,
                style: TextStyle(
                  fontSize: AppFontSizes.body,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textPrimary,
                  height: 1.0,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            // Container(
            //   padding: EdgeInsets.all(12),
            //   decoration: BoxDecoration(
            //     color: iconBgColor,
            //     borderRadius: BorderRadius.circular(8),
            //     border: Border.all(
            //       width: 1,
            //       color: borderColor,
            //     ),
            //   ),
            //   child: Icon(icon, color: iconColor, size: 12),
            // ),
          ],
        ),
      ],
    ),
  );
}

/// curret=8 target 13 bonus=1000
/// currentProgress / targetProgress

/// remaining = targetProgress - currentProgress
