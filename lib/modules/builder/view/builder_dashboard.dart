// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/app/constants/color_res.dart';
// import 'package:nesticope_app/app/constants/app_font_sizes.dart';
// import 'package:nesticope_app/data/network/property/models/property_model.dart';
// import 'package:nesticope_app/modules/builder/view/widget/project_widget_binding.dart';
// import 'package:nesticope_app/modules/dashboard/views/widget/dashboard_layout.dart';
// import 'package:nesticope_app/modules/reseller/controller/dashborad_controller/dashboard_controller.dart';
//
// import '../../../app/utils/formater/formater.dart';
// import '../../../app/utils/helper_function/user_helper/user_helper.dart';
// import '../../../app/widgets/texts/headline_text.dart';
// import '../../../data/database/secure_storage_service.dart';
// import '../../../data/network/seller_dashboard/model/seller_dashboardmodel.dart';
// import '../../../utils/excel/generate_excel.dart';
// import '../../aadhar_auth/screens/aadhar_auth_screen.dart';
// import '../../dashboard/views/dashboard_screen.dart';
// import '../../property/controllers/property_controller.dart';
// import '../../reseller/view/property_reseller.dart';
// import '../../seller/controllers/seller_overview_controller.dart';
// import '../../seller/module/lead_screen/controllers/lead_controller.dart';
// import '../../seller/module/seller_home_screen/views/property_overview_screen.dart';
// import '../../seller/module/seller_home_screen/views/seller_home_screen.dart';
// import '../../seller/module/seller_home_screen/views/widget/property_distribution_pie_graph.dart';
// import '../controller/builder_form_controller.dart';
// import 'builder_form_screen.dart';
//
// class BuilderDashboard extends StatefulWidget {
//   const BuilderDashboard({Key? key}) : super(key: key);
//
//   @override
//   State<BuilderDashboard> createState() => _BuilderDashboardState();
// }
//
// class _BuilderDashboardState extends State<BuilderDashboard> {
//   final controller = Get.find<PropertyController>();
//
//   @override
//   void initState() {
//     loadPropertyBySeller();
//     super.initState();
//   }
//
//   Future<void> loadPropertyBySeller() async {
//     final user = await SecureStorage.getUserData();
//     if (user != null) {
//       controller.applyFilter("created_by", user.user?.id.toString() ?? "");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Get.lazyPut(() => LeadController());
//     Get.lazyPut(() => SellerOverviewController());
//     final overviewController = Get.find<SellerOverviewController>();
//
//     return DashboardLayout(
//       onRefresh:()async {
//
//       } ,
//
//       floatingButton: FloatingActionButton.extended(
//         onPressed: () {
//           if (!UserHelper.isAadharVerified) {
//             Get.to(() => AadharAuthScreen());
//           } else {
//             final controller = Get.put(
//               ProjectWizardController(isBuilderView: false),
//               tag: "builder",
//             );
//             controller.resetForm();
//             Get.to(()=>CreateProjectScreen(),binding: ProjectWizardBinding() );
//           }
//         },
//         label: Text(
//           '+ Add Project',
//           style: TextStyle(
//             color: ColorRes.white,
//             fontWeight: AppFontWeights.semiBold,
//           ),
//         ),
//       ),
//       child: Obx(() {
//         log('UI Obx rebuilding - isLoading: ${overviewController.isLoading.value}, overviewData: ${overviewController.overviewData.value != null ? "HAS DATA" : "NULL"}');
//
//         // Show loading indicator
//         if (overviewController.isLoading.value) {
//           log('Showing loading indicator');
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         // Get overview data
//         final overview = overviewController.overviewData.value;
//         log('overview variable: ${overview != null ? "HAS DATA" : "NULL"}');
//
//         // Show empty state if no data
//         if (!overviewController.isLoading.value && overview == null) {
//           log('Showing empty state');
//           return RefreshIndicator(
//             onRefresh: overviewController.refreshSellerDashboard,
//             color: ColorRes.primary,
//             child: SingleChildScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               child: SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.7,
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "No Dashboard Data available",
//                         style: TextStyle(
//                           fontSize: AppFontSizes.body,
//                           color: ColorRes.textSecondary,
//                           fontWeight: AppFontWeights.medium,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: () {
//                           log('Retry button pressed');
//                           overviewController.getFetchSellerApi(
//                             overviewController.selectedGraphYear.value,
//                           );
//                         },
//                         child: const Text('Retry'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }
//
//         log('Showing main content');
//
//         if(overview == null){
//           return SizedBox.shrink();
//         }
//
//         // Main content
//         return RefreshIndicator(
//           onRefresh: overviewController.refreshSellerDashboard,
//           color: ColorRes.primary,
//           child: SingleChildScrollView(
//             physics: const NeverScrollableScrollPhysics(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Overview",
//                       style: TextStyle(
//                         fontSize: AppFontSizes.medium,
//                         fontWeight: AppFontWeights.semiBold,
//                         color: ColorRes.textColor,
//                       ),
//                     ),
//                     Spacer(),
//                     Padding(
//                       padding: const EdgeInsets.only(right: 12),
//                       child: IconButton(
//                         onPressed: () async {
//                           // await exportContractorInsightsToExcel(contractorInsightsJson);
//                           await exportBuilderInsightsToExcel(overview.toMap());
//
//                         },
//                         icon: const Icon(Icons.download, size: 18),
//
//                         style: IconButton.styleFrom(
//                           backgroundColor: Colors.green.shade600,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 8,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//                     ),
//                     _buildYearDropdown(overviewController),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 OverBuilderViewCard(
//                   property: controller.items,
//                   overview: overview ?? SellerInsightsModel.fromJson({}),
//                 ),
//                 const SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   child: Column(
//                     children: [
//                       Obx(() => buildSellerLeadGraph(overviewController)),
//                       const SizedBox(height: 12),
//                       Obx(() => buildSellerCommissionGraph(overviewController,'Projects Views')),
//                       // const SizedBox(height: 20),
//                       const SizedBox(height: 12),
//                       Obx(() =>  buildProjectDistributionGraph(overviewController)),
//                       const SizedBox(height: 12),
//                       Obx(() =>  buildProjectLeadSourceDistributionGraph(overviewController)),
//                       const SizedBox(height: 12),
//
//                       buildSellerPropertyCreatedGraph(overviewController,'Projects Created'),
//                       const SizedBox(height: 12),
//                       // const SizedBox(height: 12),
//                       leadBuilderLifecycleFunnel(overviewController),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }),
//       // child: Column(
//       //   children: [
//       //     Obx(() {
//       //       final overview = overviewController.overviewData.value;
//       //       if (controller.isLoading.value && controller.items.isEmpty) {
//       //         return const Center(child: CircularProgressIndicator());
//       //       }
//       //
//       //       if (overviewController.isLoading.value) {
//       //         return const Center(child: CircularProgressIndicator());
//       //       }
//       //
//       //       return Column(
//       //         crossAxisAlignment: CrossAxisAlignment.start,
//       //         children: [
//       //           Row(
//       //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //             children: [
//       //               Text(
//       //                 "Overview",
//       //                 style: TextStyle(
//       //                   fontSize: AppFontSizes.medium,
//       //                   fontWeight: AppFontWeights.semiBold,
//       //                   color: ColorRes.textColor,
//       //                 ),
//       //               ),
//       //               _buildYearDropdown(overviewController),
//       //             ],
//       //           ),
//       //           const SizedBox(height: 10),
//       //           OverBuilderViewCard(
//       //             property: controller.items,
//       //             overview: overview ?? SellerInsightsModel.fromJson({}),
//       //           ),
//       //           const SizedBox(height: 20),
//       //         ],
//       //       );
//       //     }),
//       //     Obx(() => buildSellerLeadGraph(overviewController)),
//       //     const SizedBox(height: 12),
//       //     Obx(() => buildSellerCommissionGraph(overviewController)),
//       //     // const SizedBox(height: 20),
//       //     const SizedBox(height: 12),
//       //     Obx(() =>  buildProjectDistributionGraph(overviewController)),
//       //     const SizedBox(height: 12),
//       //     Obx(() =>  buildProjectLeadSourceDistributionGraph(overviewController)),
//       //     const SizedBox(height: 12),
//       //     // const SizedBox(height: 12),
//       //     leadBuilderLifecycleFunnel(overviewController),
//       //   ],
//       // ),
//     );
//   }
// }
// Widget _buildYearDropdown(SellerOverviewController overviewController) {
//   final baseYear = overviewController.createdUserYear.value;
//   final currentYear = DateTime.now().year;
//
//   final List<int> years = (baseYear == currentYear)
//       ? [currentYear]
//       : List.generate(
//     currentYear - baseYear + 1,
//         (index) => baseYear + index,
//   ).reversed.toList();
//
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 12),
//     decoration: BoxDecoration(
//       color: ColorRes.white,
//       borderRadius: BorderRadius.circular(8),
//       border: Border.all(
//         color: ColorRes.leadGreyColor.withOpacity(0.3),
//         width: 1,
//       ),
//     ),
//     child: DropdownButtonHideUnderline(
//       child: DropdownButton<int>(
//         value: overviewController.selectedGraphYear.value,
//         icon: const Icon(Icons.keyboard_arrow_down_rounded),
//         style: TextStyle(
//           color: ColorRes.textColor,
//           fontSize: AppFontSizes.medium,
//           fontWeight: AppFontWeights.medium,
//         ),
//         items: years.map((year) {
//           return DropdownMenuItem<int>(
//             value: year,
//             child: Text("$year"),
//           );
//         }).toList(),
//         onChanged: (value) {
//           if (value != null) {
//             log('Dropdown changed to: $value');
//             overviewController.updateLeadsYear(value);
//           }
//         },
//       ),
//     ),
//   );
// }
// Widget leadBuilderLifecycleFunnel(SellerOverviewController overviewController) {
//   return Container(
//     padding: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: ColorRes.white,
//       borderRadius: BorderRadius.circular(12),
//       border: Border.all(
//         color: ColorRes.leadGreyColor.withOpacity(0.3),
//         width: 1,
//       ),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(Icons.area_chart_outlined, color: ColorRes.green, size: 24),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Lead Lifecycle Funnel',
//                     style: TextStyle(
//                       color: ColorRes.green,
//                       fontSize: AppFontSizes.medium,
//                       fontWeight: AppFontWeights.semiBold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(6),
//                 color: ColorRes.primary.withOpacity(0.2),
//               ),
//               child: Text(
//                 'Total: ${Formatter.formatNumber(overviewController.overviewData.value?.data?.leadAnalytics?.totalLeads ?? 0)}',
//
//                 style: TextStyle(
//                   color: ColorRes.primary,
//                   fontSize: AppFontSizes.small,
//                   fontWeight: AppFontWeights.medium,
//                 ),
//               ),
//             ),
//           ],
//         ),
//
//         // --- Chart section ---
//         SizedBox(
//           height: 350,
//           width: double.infinity,
//           child: LeadFunnelChart(
//             stageBreakdown:
//             overviewController
//                 .overviewData
//                 .value
//                 ?.data
//                 ?.leadAnalytics
//                 ?.stageBreakdown.toMap(),
//           ),
//         ),
//       ],
//     ),
//   );
// }
// Widget buildProjectLeadSourceDistributionGraph(
//     SellerOverviewController overviewController,
//     ) {
//   return Container(
//     padding: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: ColorRes.white,
//       borderRadius: BorderRadius.circular(12),
//       border: Border.all(
//         color: ColorRes.leadGreyColor.withOpacity(0.3),
//         width: 1,
//       ),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(
//               Icons.area_chart_outlined,
//               color: ColorRes.leadTealColor,
//               size: 24,
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Lead Source Distribution',
//                     style: TextStyle(
//                       color: ColorRes.leadTealColor,
//                       fontSize: AppFontSizes.medium,
//                       fontWeight: AppFontWeights.semiBold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(6),
//                 color: ColorRes.primary.withOpacity(0.2),
//               ),
//               child: Text(
//                 'Total: ${Formatter.formatNumber(overviewController.overviewData.value?.data?.leadAnalytics?.totalLeads ?? 0)}',
//
//                 style: TextStyle(
//                   color: ColorRes.primary,
//                   fontSize: AppFontSizes.small,
//                   fontWeight: AppFontWeights.medium,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//
//         // --- Chart section ---
//         SizedBox(
//           height: 350,
//           width: double.infinity,
//           child: LeadSourceDistributionPieGraph(
//             breakdown:
//             overviewController
//                 .overviewData
//                 .value
//                 ?.data
//                 ?.leadAnalytics
//                 ?.sourceDistribution.toMap() ??
//                 {},
//           ),
//         ),
//       ],
//     ),
//   );
// }
// Widget buildProjectDistributionGraph(
//     SellerOverviewController overviewController,
//     ) {
//   return Container(
//     padding: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: ColorRes.white,
//       borderRadius: BorderRadius.circular(12),
//       border: Border.all(
//         color: ColorRes.leadGreyColor.withOpacity(0.3),
//         width: 1,
//       ),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(Icons.area_chart_outlined, color: ColorRes.green, size: 24),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Project Distribution',
//                     style: TextStyle(
//                       color: ColorRes.green,
//                       fontSize: AppFontSizes.medium,
//                       fontWeight: AppFontWeights.semiBold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(6),
//                 color: ColorRes.primary.withOpacity(0.2),
//               ),
//               child: Text(
//                 'Total: ${Formatter.formatNumber(overviewController.overviewData.value?.data?.propertyMetrics?.totalProperties ?? 0)}',
//
//                 style: TextStyle(
//                   color: ColorRes.primary,
//                   fontSize: AppFontSizes.small,
//                   fontWeight: AppFontWeights.medium,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//
//         // --- Chart section ---
//         SizedBox(
//           height: 300,
//           width: double.infinity,
//           child: PropertyDistributionPieGraph(
//             breakdown: {
//               'active':
//               overviewController
//                   .overviewData
//                   .value
//                   ?.data
//                   ?.propertyMetrics
//                   ?.activeListings,
//               'pending':
//               overviewController
//                   .overviewData
//                   .value
//                   ?.data
//                   ?.propertyMetrics
//                   ?.pendingListings,
//               'rejected':
//               overviewController
//                   .overviewData
//                   .value
//                   ?.data
//                   ?.propertyMetrics
//                   ?.rejectedListings,
//             },
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// class OverBuilderViewCard extends StatelessWidget {
//   final List<Items> property;
//   final SellerInsightsModel overview;
//
//   const OverBuilderViewCard({
//     super.key,
//     required this.property,
//     required this.overview,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final data = overview.data;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         GridView.count(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           crossAxisCount: 2,
//           crossAxisSpacing: 12,
//           mainAxisSpacing: 12,
//           childAspectRatio: 1.5,
//           children: [
//             buildMetricCard(
//               'Total Listed Projects',
//               data?.propertyMetrics?.totalProperties.toString() ?? '',
//               Icons.home_work,
//               ColorRes.blueColor,
//             ),
//             buildMetricCard(
//               'Total Project Views',
//               Formatter.formatNumber(
//                 data?.propertyMetrics?.viewsHistory
//                     .map((e) => e.views)
//                     .fold<int>(0, (sum, item) => sum + item) ?? 0,
//               ),
//               Icons.remove_red_eye_outlined,
//               ColorRes.green,
//             ),
//             buildMetricCard(
//               'Active Leads',
//               '${data?.leadAnalytics?.totalLeads}',
//               Icons.person_add_alt_1,
//               ColorRes.orangeColor,
//             ),
//             buildMetricCard(
//               'Total Visits',
//               '${data?.engagementMetrics?.totalVisits}',
//               Icons.add_chart,
//               ColorRes.purpleColor,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/data/network/property/models/property_model.dart';
import 'package:nesticope_app/modules/builder/view/widget/project_widget_binding.dart';
import 'package:nesticope_app/modules/dashboard/views/widget/dashboard_layout.dart';
import 'package:nesticope_app/modules/reseller/controller/dashborad_controller/dashboard_controller.dart';
import 'package:nesticope_app/utils/shimmer/dashboard/dashbard_shimmer.dart';

import '../../../app/utils/formater/formater.dart';
import '../../../app/utils/helper_function/user_helper/user_helper.dart';
import '../../../app/widgets/texts/headline_text.dart';
import '../../../data/database/secure_storage_service.dart';
import '../../../data/network/seller_dashboard/model/seller_dashboardmodel.dart';
import '../../../utils/excel/generate_excel.dart';
import '../../dashboard/views/dashboard_screen.dart';
import '../../property/controllers/property_controller.dart';
import '../../reseller/view/property_reseller.dart';
import '../../seller/controllers/seller_overview_controller.dart';
import '../../seller/module/lead_screen/controllers/lead_controller.dart';
import '../../seller/module/seller_home_screen/views/property_overview_screen.dart';
import '../../seller/module/seller_home_screen/views/seller_home_screen.dart';
import '../../seller/module/seller_home_screen/views/widget/property_distribution_pie_graph.dart';
import '../../verification/aadhar_auth/screens/aadhar_auth_screen.dart';
import '../../verification/mou_verification/controllers/mou_verification_controller.dart';
import '../../verification/mou_verification/screens/mou_verification_screen.dart';
import '../controller/builder_form_controller.dart';
import 'builder_form_screen.dart';

class BuilderDashboard extends StatefulWidget {
  const BuilderDashboard({Key? key}) : super(key: key);

  @override
  State<BuilderDashboard> createState() => _BuilderDashboardState();
}

class _BuilderDashboardState extends State<BuilderDashboard> {
  final controller = Get.find<PropertyController>();
  late final SellerOverviewController overviewController;
  late Future<void> _dashboardFuture;
  // late Future<void> _dashboardRefreshFuture;
  DigitalSignatureController? signatureController;

  @override
  void initState() {
    super.initState();

    // Get.lazyPut(() => LeadController());
    // Get.lazyPut(() => SellerOverviewController());

    overviewController = Get.find<SellerOverviewController>();

    loadPropertyBySeller();

    // 👇 cache future (VERY IMPORTANT)
    _dashboardFuture = overviewController.getFetchSellerApi(
      overviewController.selectedGraphYear.value,
    );
    // _dashboardRefreshFuture = overviewController.refreshSellerDashboard();
  }

  Future<void> loadPropertyBySeller() async {
    final user = await SecureStorage.getUserData();
    final String userId = user?.user?.id.toString() ?? "";
    if (userId.isNotEmpty) {
      controller.applyFilter("created_by", userId);
    }

    print("User Id for Signature: ${userId}");

    if (Get.isRegistered<DigitalSignatureController>(tag: 'signature')) {
      signatureController = Get.find<DigitalSignatureController>(
        tag: 'signature',
      );
    } else {
      signatureController = Get.put(
        DigitalSignatureController(userId: userId),
        tag: 'signature',
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get.lazyPut(() => LeadController());
    // Get.lazyPut(() => SellerOverviewController());
    // final overviewController = Get.find<SellerOverviewController>();

    return DashboardLayout(
      onRefresh: () async {
        setState(() {
          _dashboardFuture = overviewController.getFetchSellerApi(
            overviewController.selectedGraphYear.value,
          );
        });
      },

      floatingButton: FloatingActionButton.extended(
        onPressed: () async {
          /// 1️⃣ Check Aadhar first
          if (!UserHelper.isAadharVerified) {
            Get.to(() => AadharAuthScreen());
            return;
          }

          /// 2️⃣ Ensure signatures are loaded
          if (signatureController!.signatures.isEmpty &&
              !signatureController!.isLoading.value) {
            await signatureController!.fetchDigitalSignatures();
          }

          /// 3️⃣ Check MOU verification
          /// 3️⃣ Check MOU verification
          if (!signatureController!.isSignatureVerified.value) {
            // Pass the controller to MouVerificationScreen
            Get.to(
              () => MouVerificationScreen(controller: signatureController),
            );
            return;
          }
          final controller = Get.put(
            ProjectWizardController(isBuilderView: false),
            tag: "builder",
          );

          Get.to(() => CreateProjectScreen(), binding: ProjectWizardBinding());
          controller.resetForm();
        },

        label: Text(
          '+ Add Project',
          style: TextStyle(
            color: ColorRes.white,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
      ),

      // child: Obx(() {
      //   // Show loading indicator
      //   if (overviewController.isLoading.value) {
      //     log('Showing loading indicator');
      //     return const Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   }
      //   // Get overview data
      //   final overview = overviewController.overviewData.value;
      //   log('overview variable: ${overview != null ? "HAS DATA" : "NULL"}');
      //
      //   // Show empty state if no data
      //   if (!overviewController.isLoading.value && overview == null) {
      //     log('Showing empty state');
      //     return RefreshIndicator(
      //       onRefresh: overviewController.refreshSellerDashboard,
      //       color: ColorRes.primary,
      //       child: SingleChildScrollView(
      //         physics: const AlwaysScrollableScrollPhysics(),
      //         child: SizedBox(
      //           height: MediaQuery.of(context).size.height * 0.7,
      //           child: Center(
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 Text(
      //                   "No Dashboard Data available",
      //                   style: TextStyle(
      //                     fontSize: AppFontSizes.body,
      //                     color: ColorRes.textSecondary,
      //                     fontWeight: AppFontWeights.medium,
      //                   ),
      //                 ),
      //                 const SizedBox(height: 16),
      //                 ElevatedButton(
      //                   onPressed: () {
      //                     log('Retry button pressed');
      //                     overviewController.getFetchSellerApi(
      //                       overviewController.selectedGraphYear.value,
      //                     );
      //                   },
      //                   child: const Text('Retry'),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //     );
      //   }
      //
      //   log('Showing main content');
      //
      //   if(overview == null){
      //     return SizedBox.shrink();
      //   }
      //
      //   // Main content
      //   return RefreshIndicator(
      //     onRefresh: overviewController.refreshSellerDashboard,
      //     color: ColorRes.primary,
      //     child: SingleChildScrollView(
      //       physics: const NeverScrollableScrollPhysics(),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Text(
      //                 "Overview",
      //                 style: TextStyle(
      //                   fontSize: AppFontSizes.medium,
      //                   fontWeight: AppFontWeights.semiBold,
      //                   color: ColorRes.textColor,
      //                 ),
      //               ),
      //               Spacer(),
      //               Padding(
      //                 padding: const EdgeInsets.only(right: 12),
      //                 child: IconButton(
      //                   onPressed: () async {
      //                     // await exportContractorInsightsToExcel(contractorInsightsJson);
      //                     await exportBuilderInsightsToExcel(overview.toMap());
      //
      //                   },
      //                   icon: const Icon(Icons.download, size: 18),
      //
      //                   style: IconButton.styleFrom(
      //                     backgroundColor: Colors.green.shade600,
      //                     foregroundColor: Colors.white,
      //                     padding: const EdgeInsets.symmetric(
      //                       horizontal: 12,
      //                       vertical: 8,
      //                     ),
      //                     shape: RoundedRectangleBorder(
      //                       borderRadius: BorderRadius.circular(8),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //               _buildYearDropdown(overviewController),
      //             ],
      //           ),
      //           const SizedBox(height: 10),
      //           OverBuilderViewCard(
      //             property: controller.items,
      //             overview: overview ?? SellerInsightsModel.fromJson({}),
      //           ),
      //           const SizedBox(height: 20),
      //           Padding(
      //             padding: const EdgeInsets.symmetric(vertical: 12),
      //             child: Column(
      //               children: [
      //                 Obx(() => buildSellerLeadGraph(overviewController)),
      //                 const SizedBox(height: 12),
      //                 Obx(() => buildSellerCommissionGraph(overviewController,'Projects Views')),
      //                 // const SizedBox(height: 20),
      //                 const SizedBox(height: 12),
      //                 Obx(() =>  buildProjectDistributionGraph(overviewController)),
      //                 const SizedBox(height: 12),
      //                 Obx(() =>  buildProjectLeadSourceDistributionGraph(overviewController)),
      //                 const SizedBox(height: 12),
      //
      //                 buildSellerPropertyCreatedGraph(overviewController,'Projects Created'),
      //                 const SizedBox(height: 12),
      //                 // const SizedBox(height: 12),
      //                 leadBuilderLifecycleFunnel(overviewController),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   );
      // }),
      child: FutureBuilder<void>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          // 🔄 Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            // return const Center(child: CircularProgressIndicator());
            return DashboardShimmer();
          }

          // ❌ Error
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Failed to load dashboard"),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _dashboardFuture = overviewController.getFetchSellerApi(
                          overviewController.selectedGraphYear.value,
                        );
                      });
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          // ✅ Data available (reactive)
          return Obx(() {
            final overview = overviewController.overviewData.value;

            if (overview == null) {
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _dashboardFuture = overviewController.getFetchSellerApi(
                      overviewController.selectedGraphYear.value,
                    );
                  });
                },
                child: const SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 120),
                      child: Text("No Dashboard Data available"),
                    ),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _dashboardFuture = overviewController.getFetchSellerApi(
                    overviewController.selectedGraphYear.value,
                  );
                });
              },
              color: ColorRes.primary,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(overviewController, overview),
                    const SizedBox(height: 10),
                    OverBuilderViewCard(
                      property: controller.items,
                      overview: overview,
                    ),
                    const SizedBox(height: 20),
                    _buildGraphs(overviewController),
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

Widget _buildHeader(
  SellerOverviewController overviewController,
  SellerInsightsModel overview,
) {
  return Row(
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

      const Spacer(),

      Padding(
        padding: const EdgeInsets.only(right: 12),
        child: IconButton(
          onPressed: () async {
            await exportBuilderInsightsToExcel(overview.toMap());
          },
          icon: const Icon(Icons.download, size: 18),
          style: IconButton.styleFrom(
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),

      _buildYearDropdown(overviewController),
    ],
  );
}

Widget _buildGraphs(SellerOverviewController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Column(
      children: [
        Obx(() => buildSellerLeadGraph(controller)),
        const SizedBox(height: 12),
        Obx(() => buildSellerCommissionGraph(controller, 'Projects Views')),
        const SizedBox(height: 12),
        Obx(() => buildProjectDistributionGraph(controller)),
        const SizedBox(height: 12),
        Obx(() => buildProjectLeadSourceDistributionGraph(controller)),
        const SizedBox(height: 12),
        buildSellerPropertyCreatedGraph(controller, 'Projects Created'),
        const SizedBox(height: 12),
        leadBuilderLifecycleFunnel(controller),
      ],
    ),
  );
}

Widget _buildYearDropdown(SellerOverviewController overviewController) {
  final baseYear = overviewController.createdUserYear.value;
  final currentYear = DateTime.now().year;

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
        value: overviewController.selectedGraphYear.value,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        style: TextStyle(
          color: ColorRes.textColor,
          fontSize: AppFontSizes.medium,
          fontWeight: AppFontWeights.medium,
        ),
        items:
            years.map((year) {
              return DropdownMenuItem<int>(value: year, child: Text("$year"));
            }).toList(),
        onChanged: (value) {
          if (value != null) {
            log('Dropdown changed to: $value');
            overviewController.updateLeadsYear(value);
          }
        },
      ),
    ),
  );
}

Widget leadBuilderLifecycleFunnel(SellerOverviewController overviewController) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: ColorRes.white,
      borderRadius: BorderRadius.circular(12),
       boxShadow: [
        BoxShadow(
          color: ColorRes.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
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
                'Total: ${Formatter.formatNumber(overviewController.overviewData.value?.data?.leadAnalytics?.totalLeads ?? 0)}',

                style: TextStyle(
                  color: ColorRes.primary,
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.medium,
                ),
              ),
            ),
          ],
        ),

        // --- Chart section ---
        SizedBox(
          height: 350,
          width: double.infinity,
          child: LeadFunnelChart(
            stageBreakdown:
                overviewController
                    .overviewData
                    .value
                    ?.data
                    ?.leadAnalytics
                    ?.stageBreakdown
                    .toMap(),
          ),
        ),
      ],
    ),
  );
}

Widget buildProjectLeadSourceDistributionGraph(
  SellerOverviewController overviewController,
) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: ColorRes.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: ColorRes.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
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
                'Total: ${Formatter.formatNumber(overviewController.overviewData.value?.data?.leadAnalytics?.totalLeads ?? 0)}',

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
                    .overviewData
                    .value
                    ?.data
                    ?.leadAnalytics
                    ?.sourceDistribution
                    .toMap() ??
                {},
          ),
        ),
      ],
    ),
  );
}

Widget buildProjectDistributionGraph(
  SellerOverviewController overviewController,
) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: ColorRes.white,
      borderRadius: BorderRadius.circular(12),
      // border: Border.all(
      //   color: ColorRes.leadGreyColor.withOpacity(0.3),
      //   width: 1,
      // ),
      // boxShadow: 
       boxShadow: [
        BoxShadow(
          color: ColorRes.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
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
                    'Project Distribution',
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
                'Total: ${Formatter.formatNumber(overviewController.overviewData.value?.data?.propertyMetrics?.totalProperties ?? 0)}',

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
          child: PropertyDistributionPieGraph(
            breakdown: {
              'active':
                  overviewController
                      .overviewData
                      .value
                      ?.data
                      ?.propertyMetrics
                      ?.activeListings,
              'pending':
                  overviewController
                      .overviewData
                      .value
                      ?.data
                      ?.propertyMetrics
                      ?.pendingListings,
              'rejected':
                  overviewController
                      .overviewData
                      .value
                      ?.data
                      ?.propertyMetrics
                      ?.rejectedListings,
            },
          ),
        ),
      ],
    ),
  );
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
              'Total Listed Projects',
              data?.propertyMetrics?.totalProperties.toString() ?? '',
              Icons.home_work,
              ColorRes.blueColor,
            ),
            buildMetricCard(
              'Total Project Views',
              Formatter.formatNumber(
                data?.propertyMetrics?.viewsHistory
                        .map((e) => e.views)
                        .fold<int>(0, (sum, item) => sum + item) ??
                    0,
              ),
              Icons.remove_red_eye_outlined,
              ColorRes.green,
            ),
            buildMetricCard(
              'Active Leads',
              '${data?.leadAnalytics?.totalLeads}',
              Icons.person_add_alt_1,
              ColorRes.orangeColor,
            ),
            buildMetricCard(
              'Total Visits',
              '${data?.engagementMetrics?.totalVisits}',
              Icons.add_chart,
              ColorRes.purpleColor,
            ),
          ],
        ),
      ],
    );
  }
}
