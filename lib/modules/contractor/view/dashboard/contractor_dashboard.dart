import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_dashboard_controller.dart';
import 'package:housing_flutter_app/modules/dashboard/views/widget/dashboard_layout.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../app/utils/formater/formater.dart';
import '../../../dashboard/views/dashboard_screen.dart';
import '../../../reseller/view/property_reseller.dart';
import '../../../reseller/widget/graph/linear_graph.dart';
import '../../controller/contractor_my_service_controller.dart';

class ContractorDashboard extends StatefulWidget {
  const ContractorDashboard({super.key});

  @override
  State<ContractorDashboard> createState() => _ContractorDashboardState();
}

class _ContractorDashboardState extends State<ContractorDashboard> {
  final contractorDashboardController = Get.put(
    ContractorDashboardController(),
  );
  final controller = Get.put(ContractorMyServiceController());

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   backgroundColor: ColorRes.bgColor,
    //   appBar: AppBar(
    //     title: Text(
    //       'Dashboard',
    //       style: TextStyle(fontWeight: AppFontWeights.bold),
    //     ),
    //     backgroundColor: ColorRes.bgColor,
    //     elevation: 0,
    //     automaticallyImplyLeading: false,
    //     centerTitle: false,
    //     actions: [
    //       TextButton(
    //         onPressed: () {
    //           Get.offAll(() => DashboardScreen());
    //         },
    //         child: Text('Switch To Buyer'),
    //       ),
    //     ],
    //   ),
    //   body: FutureBuilder(
    //     future: contractorDashboardController.getContractorDashboard(
    //       inquiriesYear: contractorDashboardController.selectedGraphYear.value,
    //       leadsYear: contractorDashboardController.selectedGraphYear.value,
    //     ),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const Center(child: CircularProgressIndicator());
    //       } else if (snapshot.hasError) {
    //         return Center(child: Text('Error: ${snapshot.error}'));
    //       } else if (!snapshot.hasData) {
    //         return const Center(child: Text('No data found'));
    //       }
    //       return Obx(() {
    //         if (contractorDashboardController.isLoading.value) {
    //           return const Center(child: CircularProgressIndicator());
    //         }
    //         contractorDashboardController.contractorInsights = snapshot.data!;
    //
    //         // Check if data exists before building
    //         if (contractorDashboardController.contractorInsights.value ==
    //             null) {
    //           return const Center(child: CircularProgressIndicator());
    //         }
    //
    //         return RefreshIndicator(
    //           onRefresh: contractorDashboardController.refreshDashboard,
    //           child: SingleChildScrollView(
    //             physics: const AlwaysScrollableScrollPhysics(),
    //             padding: const EdgeInsets.symmetric(
    //               horizontal: 16,
    //               vertical: 12,
    //             ),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 buildOverviewCards(contractorDashboardController),
    //                 const SizedBox(height: 20),
    //                 Obx(
    //                   () => buildContractorLeadGraph(
    //                     contractorDashboardController,
    //                   ),
    //                 ),
    //                 const SizedBox(height: 20),
    //                 Obx(
    //                   () => buildContractorInquiryGraph(
    //                     contractorDashboardController,
    //                   ),
    //                 ),
    //                 const SizedBox(height: 12),
    //                 Obx(
    //                   () => buildRatingsDistribution(
    //                     averageRating:
    //                         contractorDashboardController
    //                             .contractorInsights
    //                             .value
    //                             ?.data
    //                             ?.reviews
    //                             .averageRating ??
    //                         0.0,
    //                     totalRatings:
    //                         contractorDashboardController
    //                             .contractorInsights
    //                             .value
    //                             ?.data
    //                             ?.reviews
    //                             .totalReviews ??
    //                         0,
    //                     ratingCounts:
    //                         contractorDashboardController
    //                             .contractorInsights
    //                             .value
    //                             ?.data
    //                             ?.services
    //                             .ratingsDistribution ??
    //                         {},
    //                   ),
    //                 ),
    //                 const SizedBox(height: 12),
    //                 // Fixed horizontal scrolling section
    //                 Obx(
    //                   () => SizedBox(
    //                     height: 170,
    //                     child: ListView.builder(
    //                       scrollDirection: Axis.horizontal,
    //                       itemCount:
    //                           contractorDashboardController
    //                               .contractorInsights
    //                               .value
    //                               ?.data
    //                               ?.services
    //                               .topRatedServices
    //                               .length ??
    //                           0,
    //                       itemBuilder: (context, index) {
    //                         final data =
    //                             contractorDashboardController
    //                                 .contractorInsights
    //                                 .value
    //                                 ?.data
    //                                 ?.services
    //                                 .topRatedServices[index];
    //                         return buildTopRatedService(
    //                           title: data?.serviceName ?? '',
    //                           context: context,
    //                           totalReview: data?.totalReviews ?? 0,
    //                           description: data?.description ?? '',
    //                           rating: data?.averageRating ?? 0,
    //                           status:
    //                               data?.isActive ?? false
    //                                   ? "Active"
    //                                   : "Not Active",
    //                         );
    //                       },
    //                     ),
    //                   ),
    //                 ),
    //                 const SizedBox(height: 12),
    //                 Obx(
    //                   () => SizedBox(
    //                     height: 150,
    //                     child: ListView.builder(
    //                       itemCount:
    //                           contractorDashboardController
    //                               .contractorInsights
    //                               .value
    //                               ?.data
    //                               ?.reviews
    //                               .recentReviews
    //                               .length ??
    //                           0,
    //                       itemBuilder: (context, index) {
    //                         final data =
    //                             contractorDashboardController
    //                                 .contractorInsights
    //                                 .value
    //                                 ?.data
    //                                 ?.reviews
    //                                 .recentReviews[index];
    //                         return buildRecentReview(
    //                           userName: data?.reviewerName ?? '',
    //                           timeAgo: getTimeAgo(data?.createdAt ?? ''),
    //                           rating: data?.rating ?? 0.0,
    //                           review: data?.content ?? '',
    //                         );
    //                       },
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         );
    //       });
    //     },
    //   ),
    // );

    return DashboardLayout(
      child: FutureBuilder(
        future: contractorDashboardController.getContractorDashboard(
          inquiriesYear: contractorDashboardController.selectedGraphYear.value,
          leadsYear: contractorDashboardController.selectedGraphYear.value,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          }
          return Obx(() {
            if (contractorDashboardController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            contractorDashboardController.contractorInsights = snapshot.data!;

            // Check if data exists before building
            if (contractorDashboardController.contractorInsights.value ==
                null) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: contractorDashboardController.refreshDashboard,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildOverviewCards(contractorDashboardController),
                    const SizedBox(height: 20),
                    Obx(
                      () => buildContractorLeadGraph(
                        contractorDashboardController,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => buildContractorInquiryGraph(
                        contractorDashboardController,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => buildRatingsDistribution(
                        averageRating:
                            contractorDashboardController
                                .contractorInsights
                                .value
                                ?.data
                                ?.reviews
                                .averageRating ??
                            0.0,
                        totalRatings:
                            contractorDashboardController
                                .contractorInsights
                                .value
                                ?.data
                                ?.reviews
                                .totalReviews ??
                            0,
                        ratingCounts:
                            contractorDashboardController
                                .contractorInsights
                                .value
                                ?.data
                                ?.services
                                .ratingsDistribution ??
                            {},
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Fixed horizontal scrolling section
                    Obx(
                      () => SizedBox(
                        height: 170,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              contractorDashboardController
                                  .contractorInsights
                                  .value
                                  ?.data
                                  ?.services
                                  .topRatedServices
                                  .length ??
                              0,
                          itemBuilder: (context, index) {
                            final data =
                                contractorDashboardController
                                    .contractorInsights
                                    .value
                                    ?.data
                                    ?.services
                                    .topRatedServices[index];
                            return buildTopRatedService(
                              title: data?.serviceName ?? '',
                              context: context,
                              totalReview: data?.totalReviews ?? 0,
                              description: data?.description ?? '',
                              rating: data?.averageRating ?? 0,
                              status:
                                  data?.isActive ?? false
                                      ? "Active"
                                      : "Not Active",
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => SizedBox(
                        height: 150,
                        child: ListView.builder(
                          itemCount:
                              contractorDashboardController
                                  .contractorInsights
                                  .value
                                  ?.data
                                  ?.reviews
                                  .recentReviews
                                  .length ??
                              0,
                          itemBuilder: (context, index) {
                            final data =
                                contractorDashboardController
                                    .contractorInsights
                                    .value
                                    ?.data
                                    ?.reviews
                                    .recentReviews[index];
                            return buildRecentReview(
                              userName: data?.reviewerName ?? '',
                              timeAgo: getTimeAgo(data?.createdAt ?? ''),
                              rating: data?.rating ?? 0.0,
                              review: data?.content ?? '',
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

Widget buildContractorLeadGraph(ContractorDashboardController controller) {
  final leadsTrend =
      controller.contractorInsights.value?.data?.leadsTrend
          ?.map<Map<String, dynamic>>(
            (e) => {"name": e.month ?? '', "leads": e.leads ?? 0},
          )
          .toList() ??
      [];

  final Set<String> yearsInData =
      leadsTrend.map((e) => e['name'].toString().split('-').first).toSet();

  final String displayYear =
      yearsInData.isNotEmpty
          ? (yearsInData.toList()..sort()).last
          : DateTime.now().year.toString();

  final Map<String, double> monthDataForYear = {};
  for (var e in leadsTrend) {
    final parts = e['name'].toString().split('-');
    if (parts.length == 2 && parts[0] == displayYear) {
      monthDataForYear[parts[1]] = (e['leads'] as num).toDouble();
    }
  }

  final mergedData = List.generate(12, (i) {
    final month = (i + 1).toString().padLeft(2, '0');
    return {
      "name": "$displayYear-$month",
      "leads": monthDataForYear[month] ?? 0,
    };
  });

  final List<String> months =
      mergedData.map((e) => e['name'] as String).toList();

  final List<double> monthlyData =
      mergedData.map((e) => (e['leads'] as num).toDouble()).toList();

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
                    style: TextStyle(
                      color: ColorRes.green,
                      fontSize: AppFontSizes.medium,
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
            // buildYearDropdown(
            //   label: 'Year',
            //   selectedYear: controller.selectedGraphYear.value,
            //   onChanged: controller.updateLeadsYear,
            //   controller: controller,
            // ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: MonthlyBarChart(
            monthlyData: monthlyData,
            months: months,
            color: ColorRes.green,
            isAmount: false,
          ),
        ),
      ],
    ),
  );
}

Widget buildContractorInquiryGraph(ContractorDashboardController controller) {
  final leadsTrend =
      controller.contractorInsights.value?.data?.inquiriesTrend
          ?.map<Map<String, dynamic>>(
            (e) => {"name": e.month ?? '', "commission": e.inquiries ?? 0},
          )
          .toList() ??
      [];

  final Set<String> yearsInData =
      leadsTrend.map((e) => e['name'].toString().split('-').first).toSet();

  final String displayYear =
      yearsInData.isNotEmpty
          ? (yearsInData.toList()..sort()).last
          : DateTime.now().year.toString();

  final Map<String, double> monthDataForYear = {};
  for (var e in leadsTrend) {
    final parts = e['name'].toString().split('-');
    if (parts.length == 2 && parts[0] == displayYear) {
      monthDataForYear[parts[1]] = (e['commission'] as num).toDouble();
    }
  }

  final mergedData = List.generate(12, (i) {
    final month = (i + 1).toString().padLeft(2, '0');
    return {
      "name": "$displayYear-$month",
      "commission": monthDataForYear[month] ?? 0,
    };
  });

  final List<String> months =
      mergedData.map((e) => e['name'] as String).toList();

  final List<double> monthlyData =
      mergedData.map((e) => (e['commission'] as num).toDouble()).toList();

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
                    'Inquiries',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: ColorRes.lightPurpleColor,
                      fontSize: AppFontSizes.medium,
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
            // buildYearDropdown(
            //   label: 'Year',
            //   selectedYear: controller.selectedGraphYear.value,
            //   onChanged: controller.updateInquiriesYear,
            //   controller: controller,
            // ),s
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: MonthlyBarChart(
            monthlyData: monthlyData,
            months: months,
            isAmount: false,
          ),
        ),
      ],
    ),
  );
}

Widget buildOverviewCards(ContractorDashboardController controller) {
  return Obx(() {
    final data = controller.contractorInsights.value?.data;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        buildMetricCard(
          'Total Services',
          data?.performance.totalServices.toString() ?? '',
          Icons.design_services,
          ColorRes.blueColor,
        ),
        buildMetricCard(
          'Total Inquiries',
          Formatter.formatNumber(data?.performance.totalInquiries ?? 0),
          Icons.question_answer,
          ColorRes.green,
        ),
        buildMetricCard(
          'Total Leads',
          '${data?.performance.totalLeads}',
          Icons.person_add_alt_1,
          ColorRes.purpleColor,
        ),
        buildMetricCard(
          'Overall Rating',
          Formatter.formatNumber(data?.performance.overallRating ?? 0),
          Icons.star,
          ColorRes.homeAmber,
        ),
      ],
    );
  });
}

Widget buildRatingsDistribution({
  required double averageRating,
  required int totalRatings,
  required Map<String, int> ratingCounts,
}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: ColorRes.leadGreyColor.shade300, width: 1),
    ),

    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: ColorRes.orangeColor, size: 24),
              SizedBox(width: 6),
              Text(
                "Ratings Distribution",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: ColorRes.orangeColor,
                  fontSize: AppFontSizes.medium,
                  fontWeight: AppFontWeights.semiBold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: ColorRes.homeAmber.shade50,
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    averageRating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: AppFontSizes.displaySmall,
                      fontWeight: AppFontWeights.semiBold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < averageRating.round()
                            ? Icons.star
                            : Icons.star_border,
                        color: ColorRes.orangeColor,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$totalRatings Ratings",
                    style: TextStyle(
                      color: ColorRes.textColor,
                      fontSize: AppFontSizes.small,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(5, (index) {
            final star = 5 - index;
            final count = ratingCounts[star.toString()] ?? 0;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text("$star"),
                      Icon(Icons.star, size: 15, color: ColorRes.orangeColor),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LinearProgressIndicator(
                      value:
                          totalRatings == 0
                              ? 0
                              : count / totalRatings.clamp(1, double.infinity),
                      color: Colors.orange,
                      backgroundColor: Colors.grey.shade200,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text("$count"),
                ],
              ),
            );
          }),
        ],
      ),
    ),
  );
}

Widget buildTopRatedService({
  required String title,
  required String description,
  required double rating,
  required int totalReview,
  required String status,
  required BuildContext context,
}) {
  final size = MediaQuery.of(context).size;
  final width = size.width;

  // Adjust dynamic scaling based on screen size
  final isSmallScreen = width < 600;
  final isTablet = width >= 600 && width < 1000;

  final cardWidth =
      isSmallScreen
          ? width * 0.9
          : isTablet
          ? width * 0.45
          : width * 0.22;

  final padding = isSmallScreen ? 12.0 : 16.0;
  final titleFont = isSmallScreen ? 14.0 : 16.0;
  final descFont = isSmallScreen ? 11.0 : 12.0;
  final ratingFont = isSmallScreen ? 10.0 : 12.0;
  final badgeFont = isSmallScreen ? 10.0 : 12.0;

  return Container(
    width: cardWidth,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
            Icon(Icons.star, color: ColorRes.deepPurpleColor, size: 24),
            const SizedBox(width: 6),
            Text(
              "Top Rated Services",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: ColorRes.deepPurpleColor,
                fontSize: AppFontSizes.medium,
                fontWeight: AppFontWeights.semiBold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: ColorRes.leadGreyColor.withOpacity(0.3),
              width: 1,
            ),
          ),

          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: isSmallScreen ? 45 : 50,
                      width: isSmallScreen ? 45 : 50,
                      decoration: BoxDecoration(
                        color: ColorRes.deepPurpleColor.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.build,
                        color: ColorRes.deepPurpleColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontWeight: AppFontWeights.semiBold,
                                    fontSize: titleFont,
                                    color: ColorRes.textColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: ColorRes.homeAmber.withOpacity(0.08),
                                  border: Border.all(
                                    color: ColorRes.homeAmber.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      rating.toStringAsFixed(1),
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w500,
                                        fontSize: ratingFont,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Text(
                            description,
                            style: TextStyle(
                              color: ColorRes.leadGreyColor.shade600,
                              fontSize: descFont,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 8 : 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorRes.primary.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: ColorRes.primary.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  "Review: $totalReview",
                                  style: TextStyle(
                                    color: ColorRes.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: badgeFont,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 8 : 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.green.shade200,
                                  ),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                    fontSize: badgeFont,
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
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildRecentReview({
  required String userName,
  required String timeAgo,
  required double rating,
  required String review,
}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: ColorRes.leadGreyColor.withOpacity(0.3),
        width: 1,
      ),
    ),
    elevation: 1,
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: ColorRes.primary),
              SizedBox(width: 6),
              Text(
                "Recent Reviews",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: ColorRes.primary,
                  fontSize: AppFontSizes.medium,
                  fontWeight: AppFontWeights.semiBold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: ColorRes.primary,
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: AppFontSizes.medium,
                      color: ColorRes.textColor,
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < rating.round() ? Icons.star : Icons.star_border,
                        color: Colors.orange,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),

              Text(
                "${timeAgo} ago",
                style: TextStyle(
                  color: ColorRes.leadGreyColor.shade600,
                  fontSize: AppFontSizes.extraSmall,
                  fontWeight: AppFontWeights.medium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            review,
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: AppFontWeights.medium,
              color: ColorRes.leadGreyColor.shade600,
            ),
          ),
        ],
      ),
    ),
  );
}

String getTimeAgo(String? createdAt) {
  if (createdAt == null || createdAt.isEmpty) return '';
  try {
    final dateTime = DateTime.parse(createdAt);

    return timeago.format(dateTime, locale: 'en_short'); // e.g. "2d ago"
  } catch (e) {
    return '';
  }
}

Widget buildYearDropdown({
  required String label,
  required int selectedYear,
  required Function(int) onChanged,
  required ContractorDashboardController controller,
}) {
  return DropdownButton<int>(
    value: selectedYear,
    items:
        controller.getLastThreeYears().map((year) {
          return DropdownMenuItem<int>(
            value: year,
            child: Text(year.toString()),
          );
        }).toList(),
    onChanged: (year) {
      if (year != null) {
        onChanged(year);
      }
    },
    underline: Container(),
    icon: const Icon(Icons.arrow_drop_down),
  );
}
