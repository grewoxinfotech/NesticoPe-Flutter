import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';
import 'package:housing_flutter_app/modules/reseller/controller/dashborad_controller/dashboard_controller.dart';

import '../../../app/utils/formater/formater.dart';
import '../../../app/widgets/texts/headline_text.dart';
import '../../../data/database/secure_storage_service.dart';
import '../../../data/network/seller_dashboard/model/seller_dashboardmodel.dart';
import '../../dashboard/views/dashboard_screen.dart';
import '../../property/controllers/property_controller.dart';
import '../../reseller/view/property_reseller.dart';
import '../../seller/controllers/seller_overview_controller.dart';
import '../../seller/module/lead_screen/controllers/lead_controller.dart';
import '../../seller/module/seller_home_screen/views/property_overview_screen.dart';
import '../../seller/module/seller_home_screen/views/seller_home_screen.dart';

class BuilderDashboard extends StatefulWidget {
  const BuilderDashboard({Key? key}) : super(key: key);

  @override
  State<BuilderDashboard> createState() => _BuilderDashboardState();
}

class _BuilderDashboardState extends State<BuilderDashboard> {
  final controller = Get.find<PropertyController>();

  @override
  void initState() {
    loadPropertyBySeller();
    super.initState();
  }

  Future<void> loadPropertyBySeller() async {
    final user = await SecureStorage.getUserData();
    if (user != null) {
      controller.applyFilter("created_by", user.user?.id.toString() ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => LeadController());
    Get.lazyPut(() => SellerOverviewController());
    final overviewController = Get.find<SellerOverviewController>();

    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(fontWeight: AppFontWeights.bold),
        ),
        backgroundColor: ColorRes.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              Get.offAll(() => DashboardScreen());
            },
            child: Text('Back'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                            fontSize: AppFontSizes.large,
                            fontWeight: AppFontWeights.bold,
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
                    child: const Icon(
                      Icons.home_work_rounded,
                      size: 40,
                      color: ColorRes.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              final overview = overviewController.overviewData.value;
              if (controller.isLoading.value && controller.items.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
           
              if (overviewController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OverBuilderViewCard(
                    property: controller.items,
                    overview: overview??SellerInsightsModel.fromJson({}),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }),

            ///Font not change from it ============================================
            // GridView.count(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   crossAxisCount: 2,
            //   crossAxisSpacing: 12,
            //   mainAxisSpacing: 12,
            //   childAspectRatio: 1.5,
            //   children: [
            //     buildMetricCard(
            //       'Total Properties',
            //       '24',
            //       Icons.apartment_rounded,
            //       const Color(0xFF6366F1),
            //     ),
            //     buildMetricCard(
            //       'Active Leads',
            //       '156',
            //       Icons.people_rounded,
            //       const Color(0xFFEC4899),
            //     ),
            //     buildMetricCard(
            //       'Sold Units',
            //       '18',
            //       Icons.check_circle_rounded,
            //       const Color(0xFF10B981),
            //     ),
            //     buildMetricCard(
            //       'Revenue',
            //       '₹2.4Cr',
            //       Icons.currency_rupee_rounded,
            //       const Color(0xFFF59E0B),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 20),
            // Text(
            //   'Recent Activities',
            //   style: TextStyle(
            //     fontSize: AppFontSizes.medium,
            //     fontWeight: AppFontWeights.semiBold,
            //     color: ColorRes.textPrimary,
            //   ),
            // ),
            // const SizedBox(height: 12),
            // _buildActivityItem(
            //   'New lead for Skyline Tower',
            //   '2 hours ago',
            //   Icons.person_add_rounded,
            //   ColorRes.blueColor,
            // ),
            // _buildActivityItem(
            //   'Property listed successfully',
            //   '5 hours ago',
            //   Icons.check_circle_rounded,
            //   ColorRes.green,
            // ),
            // _buildActivityItem(
            //   'Site visit scheduled',
            //   '1 day ago',
            //   Icons.calendar_today_rounded,
            //   ColorRes.orangeColor,
            // ),
            // const SizedBox(height: 10),
            // buildMonthlyPerformance(
            //   title: 'Monthly Performance',
            //   levelName: 'Pro Level',
            //   levelIcon: Icons.star,
            //   levelIconColor: ColorRes.orangeColor,
            //   benefits: ['Priority Support', 'Access to Premium Listings'],
            //   progressValue: 0.65,
            //   currentAmount: '₹65K',
            //   targetAmount: '₹1L',
            //   unlockMessage: '₹35K more to unlock next level!',
            //   streakDays: 7,
            //   commissionCurrent: '₹2.9L',
            //   commissionPrevious: '₹2.3L',
            //   commissionChange: '25% increase',
            //   commissionPositive: true,
            //   leadsCurrent: '12',
            //   leadsPrevious: '9',
            //   leadsChange: '33% increase',
            //   leadsPositive: true,
            // ),
            //
            // const SizedBox(height: 20),
            // buildDailyGoals(
            //   title: 'Daily Goal',
            //   goalText: 'Try to generate 5 leads today',
            //   date: '27 Oct 2025',
            //   currentStep: 4,
            //   totalSteps: 5,
            //   currentStreak: 2,
            //   primaryColor: ColorRes.purpleColor.shade500,
            //   accentColor: ColorRes.homeAmber.shade800,
            //   context: context,
            // ),
            // const SizedBox(height: 20),
            // buildBestResellerOnTheMonth(
            //   month: "October",
            //   year: "2025",
            //   totalCommission: "₹2.9L",
            //   commissionSubtitle: "2,85,000 earned this month",
            //   level: "Noob",
            //   levelSubtitle: 0.0,
            //   totalLeads: "8",
            //   leadsSubtitle: "Generated this month",
            //   commissionColor: ColorRes.success,
            //   levelColor: ColorRes.purpleColor.shade800,
            //   leadsColor: ColorRes.blueColor,
            // ),
            // const SizedBox(height: 20),
            // resellerLeaderBoard(
            //   title: 'Leaderboard',
            //   bannerTitle: 'Top 10 (Overall)',
            //   bannerSubtitle: 'Gets Extra Rewards',
            //   leaderboardData: [
            //
            //   ],
            // ),
            // const SizedBox(height: 20),
            // buildLeaderBoardRanking(
            //   title: 'Leaderboard Rankings',
            //   subtitle: 'Top performers across regions',
            //   filters: ['All', 'City-wise', 'Monthly'],
            //   leaderboardData: [
            //     {
            //       'rank': 1,
            //       'name': 'Rajesh Kumar',
            //       'level': 'Platinum Level',
            //       'city': 'Ahmedabad',
            //       'sales': '₹35L',
            //       'deals': '70',
            //       'color': ColorRes.orangeColor.withOpacity(0.05),
            //       'borderColor': ColorRes.orangeColor.withOpacity(0.3),
            //       'medalIcon': Icons.emoji_events,
            //     },
            //     {
            //       'rank': 2,
            //       'name': 'Priya Sharma',
            //       'level': 'Platinum Level',
            //       'city': 'Ahmedabad',
            //       'sales': '₹32L',
            //       'deals': '64',
            //       'color': ColorRes.orangeColor.withOpacity(0.05),
            //       'borderColor': ColorRes.orangeColor.withOpacity(0.3),
            //       'medalIcon': Icons.emoji_events,
            //     },
            //     {
            //       'rank': 3,
            //       'name': 'You',
            //       'level': 'Gold Level',
            //       'city': 'Ahmedabad',
            //       'sales': '₹29L',
            //       'deals': '57',
            //       'color': ColorRes.green.withOpacity(0.05),
            //       'borderColor': ColorRes.green.withOpacity(0.3),
            //       'medalIcon': Icons.emoji_events,
            //       'isCurrentUser': true,
            //     },
            //     {
            //       'rank': 4,
            //       'name': 'Amit Patel',
            //       'level': 'Gold Level',
            //       'city': 'Ahmedabad',
            //       'sales': '₹24L',
            //       'deals': '48',
            //       'color': ColorRes.leadGreyColor.withOpacity(0.05),
            //       'borderColor': ColorRes.leadGreyColor.withOpacity(0.3),
            //       'medalIcon': null,
            //     },
            //     {
            //       'rank': 5,
            //       'name': 'Neha Desai',
            //       'level': 'Silver Level',
            //       'city': 'Ahmedabad',
            //       'sales': '₹21L',
            //       'deals': '42',
            //       'color': ColorRes.blueColor.withOpacity(0.05),
            //       'borderColor': ColorRes.blueColor.withOpacity(0.3),
            //       'medalIcon': null,
            //     },
            //   ],
            // ),
            // const SizedBox(height: 20),
            // buildReferralProgram(
            //   controller: DashboardController(),
            //   context: context,
            //   bonus: 5000,
            //   currentProgress: 4,
            //   targetProgress: 10,
            //   title: 'Referral Program',
            //   subtitle: 'Get ₹5000 for every new active reseller',
            //   pointsEarned: '2400',
            //   totalEarnings: '₹4K',
            //   earningSubtitle: '8 x ₹5000 each',
            //   referralCode: 'REF12345',
            //   leftIcon: Icons.card_giftcard_rounded,
            //   iconColor: ColorRes.textPrimary,
            //   iconBackground: ColorRes.textPrimary.withOpacity(0.08),
            //   card1BorderColor: ColorRes.homeAmber.withOpacity(0.3),
            //   card1BgColor: ColorRes.homeAmber.withOpacity(0.08),
            //   card2BorderColor: ColorRes.green.withOpacity(0.3),
            //   card2BgColor: ColorRes.green.withOpacity(0.08),
            // ),
            // const SizedBox(height: 20),
            Obx(() => buildSellerLeadGraph(overviewController)),
            const SizedBox(height: 20),
            Obx(() => buildSellerCommissionGraph(overviewController)),
            const SizedBox(height: 20),

            // Recent Activities
          ],
        ),
      ),
    );
  }
}

class OverBuilderViewCard extends StatelessWidget {
  final List<Items> property;
  final SellerInsightsModel overview;

  const OverBuilderViewCard({
    super.key,
    required this.property,
    required this.overview,
  });

  @override
  Widget build(BuildContext context) {
    final data = overview.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            buildMetricCard(
              'Total Properties',
              data.propertyMetrics.totalProperties.toString() ?? '',
              Icons.home_work,
              ColorRes.blueColor,
            ),
            buildMetricCard(
              'Total Revenue',
              '${Formatter.formatPrice(data.financialMetrics.totalRevenue)}',
              Icons.currency_rupee_outlined,
              ColorRes.green,
            ),
            buildMetricCard(
              'Total Leads',
              '${data?.leadAnalytics.totalLeads}',
              Icons.person_add_alt_1,
              ColorRes.orangeColor,
            ),
            buildMetricCard(
              'Total Visits',
              '${data?.engagementMetrics.totalVisits}',
              Icons.add_chart,
              ColorRes.purpleColor,
            ),
          ],
        ),
      ],
    );
  }
}
