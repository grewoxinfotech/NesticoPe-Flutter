import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:housing_flutter_app/modules/aadhar_auth/screens/aadhar_auth_screen.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_dashboard_controller.dart';
import 'package:housing_flutter_app/modules/contractor/view/widget/create_service_from.dart';
import 'package:housing_flutter_app/modules/dashboard/views/widget/dashboard_layout.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../app/utils/formater/formater.dart';
import '../../../../data/network/contractor/model/dashboard/contractor_dashboard_model.dart';
import '../../../../utils/excel/generate_excel.dart';
import '../../../dashboard/views/dashboard_screen.dart';
import '../../../reseller/view/property_reseller.dart';
import '../../../reseller/widget/graph/linear_graph.dart';
import '../../../seller/module/seller_home_screen/views/widget/property_distribution_pie_graph.dart';
import '../../controller/contractor_my_service_controller.dart';
import '../widget/service_property_trend_graphs.dart';

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
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      contractorDashboardController.getContractorDashboard(
        leadsYear: contractorDashboardController.selectedGraphYear.value,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      onRefresh: contractorDashboardController.refreshDashboard,
      floatingButton: FloatingActionButton.extended(
        onPressed: () {
          if (!UserHelper.isAadharVerified) {
            Get.to(() => AadharAuthScreen());
          } else {
            controller.clearForm();
            Get.to(() => AddServiceScreen());
          }
        },
        label: Text(
          '+ Add Service',
          style: TextStyle(
            color: ColorRes.white,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
      ),
      child: FutureBuilder(
        future: contractorDashboardController.getContractorDashboard(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Overview",
                          style: TextStyle(
                            fontSize: AppFontSizes.medium,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.textColor,
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: IconButton(
                            onPressed: () async {
                              // await exportContractorInsightsToExcel(contractorInsightsJson);
                               await exportContractorInsightsToExcel(contractorDashboardController.contractorInsights.value?.toMap()??{});
                            },
                            icon: const Icon(Icons.download, size: 18),

                            style: IconButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),

                        Obx(() {
                          final baseYear =
                              contractorDashboardController
                                  .createdUserYear
                                  .value; // starting year of app usage
                          final currentYear = DateTime.now().year;

                          // Generate dynamic list of years from baseYear up to currentYear
                          final List<int> years =
                              (baseYear == currentYear)
                                  ? [currentYear]
                                  : List.generate(
                                    currentYear - baseYear + 1,
                                    (index) => baseYear + index,
                                  ).reversed.toList();

                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: ColorRes.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: ColorRes.leadGreyColor.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value:
                                    contractorDashboardController
                                        .selectedGraphYear
                                        .value,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                ),
                                style: TextStyle(
                                  color: ColorRes.textColor,
                                  fontSize: AppFontSizes.medium,
                                  fontWeight: AppFontWeights.medium,
                                ),
                                items:
                                    years.map((year) {
                                      return DropdownMenuItem<int>(
                                        value: year,
                                        child: Text("$year"),
                                      );
                                    }).toList(),
                                onChanged: (value) async {
                                  if (value != null) {
                                    contractorDashboardController
                                        .selectedGraphYear
                                        .value = value;
                                    // Refresh dashboard when year changes
                                    contractorDashboardController
                                        .updateLeadsYear(value);
                                  }
                                },
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 16),
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

                    const SizedBox(height: 20),
                    Obx(
                      () => buildServiceDistributionGraph(
                        contractorDashboardController,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => contractorLeadFunnel(contractorDashboardController),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => buildProjectsTrendGraph(
                        contractorDashboardController,
                      ),
                    ), const SizedBox(height: 20),
                    Obx(
                      () => buildContractorLeadSourceDistributionGraph(
                        contractorDashboardController,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => buildContractorLeadStatusDistributionGraph(
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
                                ?.averageRating ??
                            0.0,
                        totalRatings:
                            contractorDashboardController
                                .contractorInsights
                                .value
                                ?.data
                                ?.reviews
                                ?.totalReviews ??
                            0,
                        ratingCounts:
                            contractorDashboardController
                                .contractorInsights
                                .value
                                ?.data
                                ?.services
                                ?.ratingsDistribution ??
                            {},
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Fixed horizontal scrolling section
                    // Obx(
                    //   () => SizedBox(
                    //     height: 170,
                    //     child: ListView.builder(
                    //       scrollDirection: Axis.horizontal,
                    //       itemCount:
                    //           contractorDashboardController
                    //               .contractorInsights
                    //               .value
                    //               ?.data
                    //               ?.services
                    //               ?.topRatedServices
                    //               .length ??
                    //           0,
                    //       itemBuilder: (context, index) {
                    //         final data =
                    //             contractorDashboardController
                    //                 .contractorInsights
                    //                 .value
                    //                 ?.data
                    //                 ?.services
                    //                 ?.topRatedServices[index];
                    //         return buildTopRatedService(
                    //           title: data?.serviceName ?? '',
                    //           context: context,
                    //           totalReview: data?.totalReviews ?? 0,
                    //           description: data?.description ?? '',
                    //           rating: data?.averageRating ?? 0,
                    //           status:
                    //               data?.isActive ?? false
                    //                   ? "Active"
                    //                   : "Not Active",
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // ),
                    Obx(() {
                      final topRatedServices =
                          contractorDashboardController
                              .contractorInsights
                              .value
                              ?.data
                              ?.services
                              ?.topRatedServices ??
                          [];

                      if (topRatedServices.isEmpty) {
                        return const SizedBox(); // or a "No data" widget
                      }

                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
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
                                Icon(
                                  Icons.star,
                                  color: ColorRes.deepPurpleColor,
                                  size: 24,
                                ),
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
                            buildTopRatedServiceList(
                              context: context,
                              services: topRatedServices,
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 12),
                    // Obx(
                    //   () => SizedBox(
                    //     height: 150,
                    //     child: ListView.builder(
                    //       itemCount:
                    //           contractorDashboardController
                    //               .contractorInsights
                    //               .value
                    //               ?.data
                    //               ?.reviews
                    //               ?.recentReviews
                    //               .length ??
                    //           0,
                    //       itemBuilder: (context, index) {
                    //         final data =
                    //             contractorDashboardController
                    //                 .contractorInsights
                    //                 .value
                    //                 ?.data
                    //                 ?.reviews
                    //                 ?.recentReviews[index];
                    //         return buildRecentReview(
                    //           userName: data?.reviewerName ?? '',
                    //           timeAgo: getTimeAgo(data?.createdAt ?? ''),
                    //           rating: data?.rating ?? 0.0,
                    //           review: data?.content ?? '',
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // ),
                    Obx(() {
                      final reviews =
                          contractorDashboardController
                              .contractorInsights
                              .value
                              ?.data
                              ?.reviews
                              ?.recentReviews ??
                          [];

                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
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
                                Icon(
                                  Icons.person,
                                  color: ColorRes.primary,
                                  size: 24,
                                ),
                                const SizedBox(width: 6),
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
                            SizedBox(
                              height: 100,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: reviews.length,
                                separatorBuilder:
                                    (_, __) => const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  final data = reviews[index];
                                  final userName = data?.reviewerName ?? '';
                                  final timeAgo = getTimeAgo(
                                    data?.createdAt ?? '',
                                  );
                                  final rating = data?.rating ?? 0.0;
                                  final review = data?.content ?? '';

                                  return SizedBox(
                                    width: 240,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: ColorRes.leadGreyColor
                                              .withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      elevation: 1.5,
                                      margin: EdgeInsets.zero,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Header Row (Avatar + Name + Time)
                                            Row(
                                              children: [
                                                const CircleAvatar(
                                                  radius: 16,
                                                  backgroundColor:
                                                      ColorRes.primary,
                                                  child: Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        userName,
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              AppFontWeights
                                                                  .semiBold,
                                                          fontSize:
                                                              AppFontSizes
                                                                  .small,
                                                          color:
                                                              ColorRes
                                                                  .textColor,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: List.generate(
                                                          5,
                                                          (index) => Icon(
                                                            index <
                                                                    rating
                                                                        .round()
                                                                ? Icons.star
                                                                : Icons
                                                                    .star_border,
                                                            color:
                                                                Colors.orange,
                                                            size: 13,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  "$timeAgo ago",
                                                  style: TextStyle(
                                                    color:
                                                        ColorRes
                                                            .leadGreyColor
                                                            .shade600,
                                                    fontSize:
                                                        AppFontSizes.extraSmall,
                                                    fontWeight:
                                                        AppFontWeights.medium,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 8),

                                            // Review content
                                            Expanded(
                                              child: Text(
                                                review,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize:
                                                      AppFontSizes.caption,
                                                  fontWeight:
                                                      AppFontWeights.medium,
                                                  color:
                                                      ColorRes
                                                          .leadGreyColor
                                                          .shade600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
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
Widget buildContractorLeadSourceDistributionGraph(
    ContractorDashboardController overviewController,
    ) {
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
            Icon(
              Icons.area_chart_outlined,
              color: ColorRes.leadTealColor,
              size: 24,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lead Source Distribution',
                    style: TextStyle(
                      color: ColorRes.leadTealColor,
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.semiBold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: ColorRes.primary.withOpacity(0.2),
              ),
              child: Text(
                'Total: ${Formatter.formatNumber(
                  (overviewController.contractorInsights.value?.data?.leadAnalytics?.leadSourceBreakdown?.values
                      ?.fold<int>(0, (sum, value) => sum + (value as int))) ?? 0,
                )}',

                style: TextStyle(
                  color: ColorRes.primary,
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.medium,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // --- Chart section ---
        SizedBox(
          height: 350,
          width: double.infinity,
          child: LeadSourceDistributionPieGraph(
            breakdown:
            overviewController
                .contractorInsights
                .value
                ?.data
                ?.leadAnalytics?.leadSourceBreakdown??
                {},
          ),
        ),
      ],
    ),
  );
}
Widget buildContractorLeadStatusDistributionGraph(
    ContractorDashboardController overviewController,
    ) {
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
            Icon(
              Icons.area_chart_outlined,
              color: ColorRes.leadTealColor,
              size: 24,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lead Status Distribution',
                    style: TextStyle(
                      color: ColorRes.leadTealColor,
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.semiBold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: ColorRes.primary.withOpacity(0.2),
              ),
              child: Text(
                'Total: ${Formatter.formatNumber(
                  (overviewController.contractorInsights.value?.data?.leadAnalytics?.leadStatusBreakdown?.values
                      ?.fold<int>(0, (sum, value) => sum + (value as int))) ?? 0,
                )}',

                style: TextStyle(
                  color: ColorRes.primary,
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.medium,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // --- Chart section ---
        SizedBox(
          height: 350,
          width: double.infinity,
          child: LeadStatusDistributionPieGraph(
            breakdown:
            overviewController
                .contractorInsights
                .value
                ?.data
                ?.leadAnalytics?.leadStatusBreakdown??
                {},
          ),
        ),
      ],
    ),
  );
}

Widget buildTopRatedServiceList({
  required BuildContext context,
  required List<ContractorTopService> services,
}) {
  return SizedBox(
    height: 110,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: services.length,

      itemBuilder: (context, index) {
        final data = services[index];
        return (data.averageRating > 0)
            ? buildTopRatedService(
              context: context,
              title: data.serviceName ?? '',
              description: data.description ?? '',
              rating: data.averageRating ?? 0,
              totalReview: data.totalReviews ?? 0,
              status: (data.isActive ?? false) ? "Active" : "Not Active",
            )
            : SizedBox.shrink();
      },
    ),
  );
}

Widget buildServiceDistributionGraph(
  ContractorDashboardController overviewController,
) {
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
                    'Service Distribution',
                    style: TextStyle(
                      color: ColorRes.green,
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.semiBold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: ColorRes.primary.withOpacity(0.2),
              ),
              child: Text(
                'Total: ${Formatter.formatNumber(overviewController.contractorInsights.value?.data?.performance?.totalServices ?? 0)}',

                style: TextStyle(
                  color: ColorRes.primary,
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.medium,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // --- Chart section ---
        SizedBox(
          height: 300,
          width: double.infinity,
          child: ServiceDistributionPieGraph(
            breakdown: {
              'active':
                  overviewController
                      .contractorInsights
                      .value
                      ?.data
                      ?.performance
                      ?.activeServices,
              'inactive':
                  overviewController
                      .contractorInsights
                      .value
                      ?.data
                      ?.performance
                      ?.inactiveServices,
            },
          ),
        ),
      ],
    ),
  );
}

Widget contractorLeadFunnel(ContractorDashboardController overviewController) {
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
                    'Lead Lifecycle Funnel',
                    style: TextStyle(
                      color: ColorRes.green,
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.semiBold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: ColorRes.primary.withOpacity(0.2),
              ),
              child: Text(
                'Total: ${Formatter.formatNumber(overviewController.contractorInsights.value?.data?.performance?.totalLeads ?? 0)}',

                style: TextStyle(
                  color: ColorRes.primary,
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.medium,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 350,
          width: double.infinity,
          child: LeadFunnelChart(
            stageBreakdown:
                overviewController
                    .contractorInsights
                    .value
                    ?.data

                    ?.leadAnalytics?.leadStageBreakdown,

          ),
        ),
      ],
    ),
  );
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

Widget buildProjectsTrendGraph(ContractorDashboardController controller) {
  final leadsTrend =
      controller.contractorInsights.value?.data?.projectsTrend
          ?.map<Map<String, dynamic>>(
            (e) => {"month": e.month ?? '', "projects": e.projects ?? 0},
          )
          .toList() ??
      [];

  final Set<String> yearsInData =
      leadsTrend.map((e) => e['month'].toString().split('-').first).toSet();

  final String displayYear =
      yearsInData.isNotEmpty
          ? (yearsInData.toList()..sort()).last
          : DateTime.now().year.toString();

  final Map<String, double> monthDataForYear = {};
  for (var e in leadsTrend) {
    final parts = e['month'].toString().split('-');
    if (parts.length == 2 && parts[0] == displayYear) {
      monthDataForYear[parts[1]] = (e['projects'] as num).toDouble();
    }
  }

  final mergedData = List.generate(12, (i) {
    final month = (i + 1).toString().padLeft(2, '0');
    return {
      "month": "$displayYear-$month",
      "projects": monthDataForYear[month] ?? 0,
    };
  });

  final List<String> months =
      mergedData.map((e) => e['month'] as String).toList();

  final List<double> monthlyData =
      mergedData.map((e) => (e['projects'] as num).toDouble()).toList();

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
              color: ColorRes.homeAmber,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Projects Trend',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: ColorRes.homeAmber,
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.semiBold,
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
            color: ColorRes.homeAmber,
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
          data?.performance?.totalServices.toString() ?? '',
          Icons.design_services,
          ColorRes.blueColor,
        ),
        buildMetricCard(
          'Total Inquiries',
          Formatter.formatNumber(data?.performance?.totalInquiries ?? 0),
          Icons.question_answer,
          ColorRes.green,
        ),
        buildMetricCard(
          'Total Leads',
          '${data?.performance?.totalLeads}',
          Icons.person_add_alt_1,
          ColorRes.purpleColor,
        ),
        buildMetricCard(
          'Overall Rating',
          Formatter.formatNumber(data?.performance?.overallRating ?? 0),
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
          ? width * 0.8
          : isTablet
          ? width * 0.45
          : width * 0.22;

  return SizedBox(
    width: cardWidth,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: ColorRes.leadGreyColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Icon (instead of image)
            Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: ColorRes.deepPurpleColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.build, // replace with relevant icon
                color: ColorRes.deepPurpleColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),

            // Right side content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Status badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title, // e.g. "Plumbing Repair"
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: ColorRes.textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status, // e.g. "ACTIVE"
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Subtitle
                  Text(
                    description, // e.g. "Home Maintenance"
                    style: TextStyle(
                      color: ColorRes.leadGreyColor.shade600,
                      fontSize: 11,
                      fontWeight: AppFontWeights.medium,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // Rating + Review Count
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1), // e.g. "4.9"
                        style: TextStyle(
                          color: ColorRes.textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${Formatter.formatNumber(totalReview)} reviews',
                        // e.g. "84 reviews"
                        style: TextStyle(
                          color: ColorRes.leadGreyColor.shade600,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
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
