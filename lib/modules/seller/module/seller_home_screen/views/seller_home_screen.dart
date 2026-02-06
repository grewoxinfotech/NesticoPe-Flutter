import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart';
import 'package:housing_flutter_app/modules/dashboard/views/dashboard_screen.dart';
import 'package:housing_flutter_app/modules/home/views/home_screen/home_screen.dart';
import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';
import 'package:housing_flutter_app/modules/reseller/controller/dashborad_controller/dashboard_controller.dart';
import 'package:housing_flutter_app/modules/seller/controllers/seller_overview_controller.dart';
import 'package:housing_flutter_app/modules/seller/model/overview_model.dart';
import 'package:housing_flutter_app/modules/seller/module/lead_screen/controllers/lead_controller.dart';
import 'package:housing_flutter_app/modules/seller/module/seller_home_screen/views/property_overview_screen.dart';
import 'package:housing_flutter_app/modules/seller/module/seller_home_screen/views/widget/property_distribution_pie_graph.dart';
import 'package:housing_flutter_app/utils/shimmer/dashboard/dashbard_shimmer.dart';

import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../app/utils/formater/formater.dart';
import '../../../../../app/utils/helper_function/user_helper/user_helper.dart';
import '../../../../../app/widgets/texts/headline_text.dart';
import '../../../../../data/network/property/models/property_model.dart';
import '../../../../../data/network/seller_dashboard/model/seller_dashboardmodel.dart';
import '../../../../../utils/excel/generate_excel.dart';
import '../../../../builder/view/builder_dashboard.dart';
import '../../../../dashboard/views/widget/dashboard_layout.dart';
import '../../../../profile/controllers/buyer_profiledata.dart';
import '../../../../profile/views/profile_screen.dart';
import '../../../../reseller/view/property_reseller.dart';
import '../../../../reseller/widget/graph/linear_graph.dart';
import '../../../../verification/aadhar_auth/screens/aadhar_auth_screen.dart';
import '../../../../verification/mou_verification/controllers/mou_verification_controller.dart';
import '../../../../verification/mou_verification/screens/mou_verification_screen.dart';

final List<Map<String, dynamic>> addonData = [
  {
    "title": "Extended Warranty",
    "description": "Get 2 extra years of warranty for your plan.",
    "price": 49.99,
    "isPopular": true,
  },
  {
    "title": "Priority Support",
    "description": "24/7 dedicated support for faster resolutions.",
    "price": 29.99,
  },
  {
    "title": "Cloud Backup",
    "description": "Secure cloud storage for all your data.",
    "price": 19.99,
  },
  {
    "title": "Premium Themes",
    "description": "Access exclusive themes and templates.",
    "price": 9.99,
  },
  {
    "title": "Advanced Analytics",
    "description": "Get detailed reports and insights.",
    "price": 39.99,
  },
  {
    "title": "Custom Domain",
    "description": "Use your own domain for branding.",
    "price": 14.99,
  },
  {
    "title": "Marketing Tools",
    "description": "Boost your visibility with built-in tools.",
    "price": 24.99,
  },
  {
    "title": "Team Collaboration",
    "description": "Add team members and collaborate easily.",
    "price": 34.99,
  },
  {
    "title": "Security Package",
    "description": "Extra security features for your plan.",
    "price": 19.99,
  },
  {
    "title": "VIP Access",
    "description": "Early access to new features and updates.",
    "price": 59.99,
    "isPopular": true,
  },
];

final List<Map<String, dynamic>> propertiesOverview = [
  {
    'id': '1',
    'title': 'Modern Luxury Villa',
    'location': 'Beverly Hills, CA',
    'price': '\$2,500,000',
    'image':
        'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=400',
    'type': 'Villa',
    'bedrooms': 5,
    'bathrooms': 4,
    'area': '3,500 sq ft',
    'views': 15420,
    'likes': 892,
    'shares': 234,
    'visits': 1250,
    'totalLeads': 45,
    'status': 'Available',
    'featured': true,
  },
  {
    'id': '2',
    'title': 'Downtown Penthouse',
    'location': 'Manhattan, NY',
    'price': '\$4,200,000',
    'image': 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=400',
    'type': 'Penthouse',
    'bedrooms': 3,
    'bathrooms': 3,
    'area': '2,800 sq ft',
    'views': 23150,
    'likes': 1456,
    'shares': 567,
    'visits': 2100,
    'totalLeads': 78,
    'status': 'Available',
    'featured': true,
  },
  {
    'id': '3',
    'title': 'Cozy Family Home',
    'location': 'Austin, TX',
    'price': '\$650,000',
    'image':
        'https://images.unsplash.com/photo-1572120360610-d971b9d7767c?w=400',
    'type': 'House',
    'bedrooms': 4,
    'bathrooms': 3,
    'area': '2,200 sq ft',
    'views': 8750,
    'likes': 421,
    'shares': 156,
    'visits': 890,
    'totalLeads': 32,
    'status': 'Available',
    'featured': false,
  },
  {
    'id': '4',
    'title': 'Beachfront Condo',
    'location': 'Miami Beach, FL',
    'price': '\$1,800,000',
    'image':
        'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=400',
    'type': 'Condo',
    'bedrooms': 2,
    'bathrooms': 2,
    'area': '1,600 sq ft',
    'views': 19200,
    'likes': 1123,
    'shares': 445,
    'visits': 1680,
    'totalLeads': 67,
    'status': 'Sold',
    'featured': true,
  },
  {
    'id': '5',
    'title': 'Mountain Retreat',
    'location': 'Aspen, CO',
    'price': '\$3,100,000',
    'image':
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
    'type': 'Cabin',
    'bedrooms': 6,
    'bathrooms': 5,
    'area': '4,200 sq ft',
    'views': 12890,
    'likes': 734,
    'shares': 298,
    'visits': 1020,
    'totalLeads': 38,
    'status': 'Available',
    'featured': false,
  },
];

///============================================= UnChange Comment =====================================================

///=========================================== UnChange Comment =======================================================

// class SellerHomeScreen extends StatefulWidget {
//   const SellerHomeScreen({super.key});
//
//   @override
//   State<SellerHomeScreen> createState() => _SellerHomeScreenState();
// }
//
// class _SellerHomeScreenState extends State<SellerHomeScreen> {
//   final controller = Get.find<PropertyController>();
//   final profileController = Get.put(BuyerProfileDataController());
//   late final SellerOverviewController overviewController;
//
//   @override
//   void initState() {
//     loadPropertyBySeller();
//     super.initState();
//     overviewController = Get.put(SellerOverviewController());
//   }
//
//   Future<void> loadPropertyBySeller() async {
//     final user = await SecureStorage.getUserData();
//     if (user != null) {
//       controller.applyFilter("created_by", user.user?.id.toString() ?? "");
//     }
//   }
//
//   // @override
//   // Widget build(BuildContext context) {
//   //   Get.lazyPut(() => LeadController());
//   //   return DashboardLayout(
//   //     onRefresh: overviewController.refreshSellerDashboard,
//   //
//   //     floatingButton: FloatingActionButton.extended(
//   //       onPressed: () {
//   //         if (!UserHelper.isAadharVerified) {
//   //           Get.to(() => AadharAuthScreen());
//   //         } else {
//   //           Get.to(CreatePropertyScreen(isLogin: true));
//   //         }
//   //       },
//   //       label: Text(
//   //         '+ Add Property',
//   //         style: TextStyle(
//   //           color: ColorRes.white,
//   //           fontWeight: AppFontWeights.semiBold,
//   //         ),
//   //       ),
//   //     ),
//   //     child: Obx(() {
//   //       log(
//   //         'UI Obx rebuilding - isLoading: ${overviewController.isLoading.value}, overviewData: ${overviewController.overviewData.value != null ? "HAS DATA" : "NULL"}',
//   //       );
//   //
//   //       // Show loading indicator
//   //       if (overviewController.isLoading.value) {
//   //         log('Showing loading indicator');
//   //         return DashboardShimmer();
//   //       }
//   //       // Get overview data
//   //       final overview = overviewController.overviewData.value;
//   //       log('overview variable: ${overview != null ? "HAS DATA" : "NULL"}');
//   //
//   //       // Show empty state if no data
//   //       if (!overviewController.isLoading.value && overview == null) {
//   //         log('Showing empty state');
//   //         return RefreshIndicator(
//   //           onRefresh: overviewController.refreshSellerDashboard,
//   //           color: ColorRes.primary,
//   //           child: SingleChildScrollView(
//   //             physics: const AlwaysScrollableScrollPhysics(),
//   //             child: SizedBox(
//   //               height: MediaQuery.of(context).size.height * 0.7,
//   //               child: Center(
//   //                 child: Column(
//   //                   mainAxisAlignment: MainAxisAlignment.center,
//   //                   children: [
//   //                     Text(
//   //                       "No Dashboard Data available",
//   //                       style: TextStyle(
//   //                         fontSize: AppFontSizes.body,
//   //                         color: ColorRes.textSecondary,
//   //                         fontWeight: AppFontWeights.medium,
//   //                       ),
//   //                     ),
//   //                     const SizedBox(height: 16),
//   //                     ElevatedButton(
//   //                       onPressed: () {
//   //                         log('Retry button pressed');
//   //                         overviewController.getFetchSellerApi(
//   //                           overviewController.selectedGraphYear.value,
//   //                         );
//   //                       },
//   //                       child: const Text('Retry'),
//   //                     ),
//   //                   ],
//   //                 ),
//   //               ),
//   //             ),
//   //           ),
//   //         );
//   //       }
//   //
//   //       log('Showing main content');
//   //
//   //       if (overview == null) {
//   //         return SizedBox.shrink();
//   //       }
//   //
//   //       // Main content
//   //       return RefreshIndicator(
//   //         onRefresh: overviewController.refreshSellerDashboard,
//   //         color: ColorRes.primary,
//   //         child: SingleChildScrollView(
//   //           physics: const NeverScrollableScrollPhysics(),
//   //           child: Column(
//   //             crossAxisAlignment: CrossAxisAlignment.start,
//   //             children: [
//   //               Row(
//   //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                 children: [
//   //                   Text(
//   //                     "Overview",
//   //                     style: TextStyle(
//   //                       fontSize: AppFontSizes.medium,
//   //                       fontWeight: AppFontWeights.semiBold,
//   //                       color: ColorRes.textColor,
//   //                     ),
//   //                   ),
//   //                   Spacer(),
//   //                   Padding(
//   //                     padding: const EdgeInsets.only(right: 12),
//   //                     child: IconButton(
//   //                       onPressed: () async {
//   //                         // await exportContractorInsightsToExcel(contractorInsightsJson);
//   //                         await exportSellerInsightsToExcel(overview.toMap());
//   //                       },
//   //                       icon: const Icon(Icons.download, size: 18),
//   //
//   //                       style: IconButton.styleFrom(
//   //                         backgroundColor: Colors.green.shade600,
//   //                         foregroundColor: Colors.white,
//   //                         padding: const EdgeInsets.symmetric(
//   //                           horizontal: 12,
//   //                           vertical: 8,
//   //                         ),
//   //                         shape: RoundedRectangleBorder(
//   //                           borderRadius: BorderRadius.circular(8),
//   //                         ),
//   //                       ),
//   //                     ),
//   //                   ),
//   //
//   //                   _buildYearDropdown(overviewController),
//   //                 ],
//   //               ),
//   //               const SizedBox(height: 10),
//   //               OverViewCard(property: controller.items, overview: overview),
//   //               const SizedBox(height: 20),
//   //               Padding(
//   //                 padding: const EdgeInsets.symmetric(vertical: 12),
//   //                 child: Column(
//   //                   children: [
//   //                     buildSellerLeadGraph(overviewController),
//   //                     const SizedBox(height: 12),
//   //                     buildSellerCommissionGraph(
//   //                       overviewController,
//   //                       'Properties Views',
//   //                     ),
//   //                     const SizedBox(height: 12),
//   //                     buildPropertyDistributionGraph(overviewController),
//   //                     const SizedBox(height: 12),
//   //                     buildLeadSourceDistributionGraph(overviewController),
//   //                     const SizedBox(height: 12),
//   //                     buildPropertyGrowthGraph(overviewController),
//   //                     const SizedBox(height: 12),
//   //                     buildSellerPropertyCreatedGraph(
//   //                       overviewController,
//   //                       'Properties Created',
//   //                     ),
//   //                     const SizedBox(height: 12),
//   //                     leadLifecycleFunnel(overviewController),
//   //                   ],
//   //                 ),
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //       );
//   //     }),
//   //   );
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     Get.lazyPut(() => LeadController());
//     final DigitalSignatureController signatureController =
//         Get.find<DigitalSignatureController>();
//
//     return DashboardLayout(
//       onRefresh: overviewController.refreshSellerDashboard,
//
//       floatingButton: FloatingActionButton.extended(
//         onPressed: () async {
//           /// 1️⃣ Check Aadhar first
//           if (!UserHelper.isAadharVerified) {
//             Get.to(() => AadharAuthScreen());
//             return;
//           }
//
//           /// 2️⃣ Ensure signatures are loaded
//           if (signatureController.signatures.isEmpty &&
//               !signatureController.isLoading.value) {
//             await signatureController.fetchDigitalSignatures();
//           }
//
//           /// 3️⃣ Check MOU verification
//           if (!signatureController.isDigitalSignatureVerified) {
//             Get.to(() => MouVerificationScreen()); // 👈 your MOU screen
//             return;
//           }
//
//           /// 4️⃣ All verified → go to property screen
//           Get.to(CreatePropertyScreen(isLogin: true));
//         },
//
//         label: Text(
//           '+ Add Property',
//           style: TextStyle(
//             color: ColorRes.white,
//             fontWeight: AppFontWeights.semiBold,
//           ),
//         ),
//       ),
//       child: FutureBuilder(
//         future: overviewController.getFetchSellerApi(
//           overviewController.selectedGraphYear.value,
//         ),
//         builder: (context, snapshot) {
//           log('FutureBuilder state → ${snapshot.connectionState}');
//
//           // =============================
//           // LOADING
//           // =============================
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return DashboardShimmer();
//           }
//
//           // =============================
//           // ERROR
//           // =============================
//           if (snapshot.hasError) {
//             return RefreshIndicator(
//               onRefresh: overviewController.refreshSellerDashboard,
//               color: ColorRes.primary,
//               child: SingleChildScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 child: SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.7,
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Something went wrong',
//                           style: TextStyle(
//                             fontSize: AppFontSizes.body,
//                             color: ColorRes.textSecondary,
//                             fontWeight: AppFontWeights.medium,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         ElevatedButton(
//                           onPressed: () {
//                             overviewController.getFetchSellerApi(
//                               overviewController.selectedGraphYear.value,
//                             );
//                           },
//                           child: const Text('Retry'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }
//
//           // =============================
//           // DATA
//           // =============================
//           final overview = overviewController.overviewData.value;
//
//           if (overview == null) {
//             return RefreshIndicator(
//               onRefresh: overviewController.refreshSellerDashboard,
//               color: ColorRes.primary,
//               child: SingleChildScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 child: SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.7,
//                   child: Center(
//                     child: Text(
//                       "No Dashboard Data available",
//                       style: TextStyle(
//                         fontSize: AppFontSizes.body,
//                         color: ColorRes.textSecondary,
//                         fontWeight: AppFontWeights.medium,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }
//
//           // =============================
//           // MAIN CONTENT
//           // =============================
//           return RefreshIndicator(
//             onRefresh: overviewController.refreshSellerDashboard,
//             color: ColorRes.primary,
//             child: SingleChildScrollView(
//               physics: const NeverScrollableScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Overview",
//                         style: TextStyle(
//                           fontSize: AppFontSizes.medium,
//                           fontWeight: AppFontWeights.semiBold,
//                           color: ColorRes.textColor,
//                         ),
//                       ),
//                       const Spacer(),
//                       Padding(
//                         padding: const EdgeInsets.only(right: 12),
//                         child: IconButton(
//                           onPressed: () async {
//                             await exportSellerInsightsToExcel(overview.toMap());
//                           },
//                           icon: const Icon(Icons.download, size: 18),
//                           style: IconButton.styleFrom(
//                             backgroundColor: Colors.green.shade600,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 8,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                       ),
//                       _buildYearDropdown(overviewController),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   OverViewCard(property: controller.items, overview: overview),
//                   const SizedBox(height: 20),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     child: Column(
//                       children: [
//                         buildSellerLeadGraph(overviewController),
//                         const SizedBox(height: 12),
//                         buildSellerCommissionGraph(
//                           overviewController,
//                           'Properties Views',
//                         ),
//                         const SizedBox(height: 12),
//                         buildPropertyDistributionGraph(overviewController),
//                         const SizedBox(height: 12),
//                         buildLeadSourceDistributionGraph(overviewController),
//                         const SizedBox(height: 12),
//                         buildPropertyGrowthGraph(overviewController),
//                         const SizedBox(height: 12),
//                         buildSellerPropertyCreatedGraph(
//                           overviewController,
//                           'Properties Created',
//                         ),
//                         const SizedBox(height: 12),
//                         leadLifecycleFunnel(overviewController),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildYearDropdown(SellerOverviewController overviewController) {
//     final baseYear = overviewController.createdUserYear.value;
//     final currentYear = DateTime.now().year;
//
//     final List<int> years =
//         (baseYear == currentYear)
//             ? [currentYear]
//             : List.generate(
//               currentYear - baseYear + 1,
//               (index) => baseYear + index,
//             ).reversed.toList();
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: ColorRes.leadGreyColor.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<int>(
//           value: overviewController.selectedGraphYear.value,
//           icon: const Icon(Icons.keyboard_arrow_down_rounded),
//           style: TextStyle(
//             color: ColorRes.textColor,
//             fontSize: AppFontSizes.medium,
//             fontWeight: AppFontWeights.medium,
//           ),
//           items:
//               years.map((year) {
//                 return DropdownMenuItem<int>(value: year, child: Text("$year"));
//               }).toList(),
//           onChanged: (value) {
//             if (value != null) {
//               log('Dropdown changed to: $value');
//               overviewController.updateLeadsYear(value);
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   //
//   // const CustomerSupportCard(
//   //   email: "abc@support.com",
//   //   phone: "+91 234 567 890",
//   // ),
//   // const SizedBox(height: 20),
//
//   Widget buildPropertyDistributionGraph(
//     SellerOverviewController overviewController,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: ColorRes.leadGreyColor.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.area_chart_outlined, color: ColorRes.green, size: 24),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Property Distribution',
//                       style: TextStyle(
//                         color: ColorRes.green,
//                         fontSize: AppFontSizes.medium,
//                         fontWeight: AppFontWeights.semiBold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(6),
//                   color: ColorRes.primary.withOpacity(0.2),
//                 ),
//                 child: Text(
//                   'Total: ${Formatter.formatNumber(overviewController.overviewData.value?.data?.propertyMetrics?.totalProperties ?? 0)}',
//
//                   style: TextStyle(
//                     color: ColorRes.primary,
//                     fontSize: AppFontSizes.small,
//                     fontWeight: AppFontWeights.medium,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//
//           // --- Chart section ---
//           SizedBox(
//             height: 300,
//             width: double.infinity,
//             child: PropertyDistributionPieGraph(
//               breakdown: {
//                 'active':
//                     overviewController
//                         .overviewData
//                         .value
//                         ?.data
//                         ?.propertyMetrics
//                         ?.activeListings,
//                 'pending':
//                     overviewController
//                         .overviewData
//                         .value
//                         ?.data
//                         ?.propertyMetrics
//                         ?.pendingListings,
//                 'rejected':
//                     overviewController
//                         .overviewData
//                         .value
//                         ?.data
//                         ?.propertyMetrics
//                         ?.rejectedListings,
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildPropertyGrowthGraph(SellerOverviewController overviewController) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: ColorRes.leadGreyColor.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.area_chart_outlined, color: ColorRes.green, size: 24),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Property Growth',
//                       style: TextStyle(
//                         color: ColorRes.green,
//                         fontSize: AppFontSizes.medium,
//                         fontWeight: AppFontWeights.semiBold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(6),
//                   color: ColorRes.primary.withOpacity(0.2),
//                 ),
//                 child: Text(
//                   'Total: ${Formatter.formatNumber(overviewController.overviewData.value?.data?.propertyMetrics?.totalProperties ?? 0)}',
//
//                   style: TextStyle(
//                     color: ColorRes.primary,
//                     fontSize: AppFontSizes.small,
//                     fontWeight: AppFontWeights.medium,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//
//           // --- Chart section ---
//           SizedBox(
//             height: 350,
//             width: double.infinity,
//             child: PropertyGrowthPieGraph(
//               breakdown: {
//                 'sold':
//                     overviewController
//                         .overviewData
//                         .value
//                         ?.data
//                         ?.propertyMetrics
//                         ?.statusDistribution['sold'],
//                 'unsold':
//                     overviewController
//                         .overviewData
//                         .value
//                         ?.data
//                         ?.propertyMetrics
//                         ?.statusDistribution['unsold'],
//                 'dead':
//                     overviewController
//                         .overviewData
//                         .value
//                         ?.data
//                         ?.propertyMetrics
//                         ?.statusDistribution['dead'],
//                 'duplicate':
//                     overviewController
//                         .overviewData
//                         .value
//                         ?.data
//                         ?.propertyMetrics
//                         ?.statusDistribution['duplicate'],
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget leadLifecycleFunnel(SellerOverviewController overviewController) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: ColorRes.leadGreyColor.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.area_chart_outlined, color: ColorRes.green, size: 24),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Lead Lifecycle Funnel',
//                       style: TextStyle(
//                         color: ColorRes.green,
//                         fontSize: AppFontSizes.medium,
//                         fontWeight: AppFontWeights.semiBold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(6),
//                   color: ColorRes.primary.withOpacity(0.2),
//                 ),
//                 child: Text(
//                   'Total: ${Formatter.formatNumber(overviewController.overviewData.value?.data?.leadAnalytics?.totalLeads ?? 0)}',
//
//                   style: TextStyle(
//                     color: ColorRes.primary,
//                     fontSize: AppFontSizes.small,
//                     fontWeight: AppFontWeights.medium,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           // --- Chart section ---
//           SizedBox(
//             height: 350,
//             width: double.infinity,
//             child: LeadFunnelChart(
//               stageBreakdown:
//                   overviewController
//                       .overviewData
//                       .value
//                       ?.data
//                       ?.leadAnalytics
//                       ?.stageBreakdown
//                       .toMap(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildLeadSourceDistributionGraph(
//     SellerOverviewController overviewController,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: ColorRes.leadGreyColor.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.area_chart_outlined,
//                 color: ColorRes.leadTealColor,
//                 size: 24,
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Lead Source Distribution',
//                       style: TextStyle(
//                         color: ColorRes.leadTealColor,
//                         fontSize: AppFontSizes.medium,
//                         fontWeight: AppFontWeights.semiBold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(6),
//                   color: ColorRes.primary.withOpacity(0.2),
//                 ),
//                 child: Text(
//                   'Total: ${Formatter.formatNumber(overviewController.overviewData.value?.data?.leadAnalytics?.totalLeads ?? 0)}',
//
//                   style: TextStyle(
//                     color: ColorRes.primary,
//                     fontSize: AppFontSizes.small,
//                     fontWeight: AppFontWeights.medium,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//
//           // --- Chart section ---
//           SizedBox(
//             height: 360,
//             width: double.infinity,
//             child: LeadSourceDistributionPieGraph(
//               breakdown:
//                   overviewController
//                       .overviewData
//                       .value
//                       ?.data
//                       ?.leadAnalytics
//                       ?.sourceDistribution
//                       .toMap() ??
//                   {},
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class SellerHomeScreen extends StatefulWidget {
  const SellerHomeScreen({super.key});

  @override
  State<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  final controller = Get.find<PropertyController>();
  final profileController = Get.put(BuyerProfileDataController());
  late final SellerOverviewController overviewController;

  // Nullable controller to handle async initialization
  DigitalSignatureController? signatureController;

  @override
  void initState() {
    super.initState();
    overviewController = Get.put(SellerOverviewController());

    // Initialize data and controllers
    _initDataAndControllers();
  }

  Future<void> _initDataAndControllers() async {
    // 1. Fetch User Data
    final user = await SecureStorage.getUserData();
    final String userId = user?.user?.id.toString() ?? "";

    // 2. Apply Property Filters
    if (userId.isNotEmpty) {
      controller.applyFilter("created_by", userId);
    }

    // 3. Inject DigitalSignatureController with userId via constructor
    // We check isRegistered to prevent errors if the user navigates back and forth quickly
    if (Get.isRegistered<DigitalSignatureController>()) {
      signatureController = Get.find<DigitalSignatureController>();
    } else {
      // Create the instance passing the userId
      signatureController = Get.put(DigitalSignatureController(userId: userId));
    }

    // 4. Update UI to indicate initialization is complete
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => LeadController());

    // 1. Show Loading until the Signature Controller is initialized
    if (signatureController == null) {
      return DashboardShimmer();
    }

    return DashboardLayout(
      onRefresh: overviewController.refreshSellerDashboard,

      floatingButton: FloatingActionButton.extended(
        onPressed: () async {
          /// 1️⃣ Check Aadhar first
          if (!UserHelper.isAadharVerified) {
            Get.to(() => AadharAuthScreen());
            return;
          }

          /// 2️⃣ Ensure signatures are loaded
          // Use the class-level signatureController instance
          if (signatureController!.signatures.isEmpty &&
              !signatureController!.isLoading.value) {
            await signatureController!.fetchDigitalSignatures();
          }

          /// 3️⃣ Check MOU verification
          if (!signatureController!.isDigitalSignatureVerified) {
            Get.to(() => MouVerificationScreen());
            return;
          }

          /// 4️⃣ All verified → go to property screen
          Get.to(CreatePropertyScreen(isLogin: true));
        },
        label: Text(
          '+ Add Property',
          style: TextStyle(
            color: ColorRes.white,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
      ),
      child: FutureBuilder(
        future: overviewController.getFetchSellerApi(
          overviewController.selectedGraphYear.value,
        ),
        builder: (context, snapshot) {
          log('FutureBuilder state → ${snapshot.connectionState}');

          // =============================
          // LOADING
          // =============================
          if (snapshot.connectionState == ConnectionState.waiting) {
            return DashboardShimmer();
          }

          // =============================
          // ERROR
          // =============================
          if (snapshot.hasError) {
            return RefreshIndicator(
              onRefresh: overviewController.refreshSellerDashboard,
              color: ColorRes.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Something went wrong',
                          style: TextStyle(
                            fontSize: AppFontSizes.body,
                            color: ColorRes.textSecondary,
                            fontWeight: AppFontWeights.medium,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            overviewController.getFetchSellerApi(
                              overviewController.selectedGraphYear.value,
                            );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          // =============================
          // DATA
          // =============================
          final overview = overviewController.overviewData.value;

          if (overview == null) {
            return RefreshIndicator(
              onRefresh: overviewController.refreshSellerDashboard,
              color: ColorRes.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: Text(
                      "No Dashboard Data available",
                      style: TextStyle(
                        fontSize: AppFontSizes.body,
                        color: ColorRes.textSecondary,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          // =============================
          // MAIN CONTENT
          // =============================
          return RefreshIndicator(
            onRefresh: overviewController.refreshSellerDashboard,
            color: ColorRes.primary,
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
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: IconButton(
                          onPressed: () async {
                            await exportSellerInsightsToExcel(overview.toMap());
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
                      _buildYearDropdown(overviewController),
                    ],
                  ),
                  const SizedBox(height: 10),
                  OverViewCard(property: controller.items, overview: overview),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      children: [
                        buildSellerLeadGraph(overviewController),
                        const SizedBox(height: 12),
                        buildSellerCommissionGraph(
                          overviewController,
                          'Properties Views',
                        ),
                        const SizedBox(height: 12),
                        buildPropertyDistributionGraph(overviewController),
                        const SizedBox(height: 12),
                        buildLeadSourceDistributionGraph(overviewController),
                        const SizedBox(height: 12),
                        buildPropertyGrowthGraph(overviewController),
                        const SizedBox(height: 12),
                        buildSellerPropertyCreatedGraph(
                          overviewController,
                          'Properties Created',
                        ),
                        const SizedBox(height: 12),
                        leadLifecycleFunnel(overviewController),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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

  Widget buildPropertyDistributionGraph(
    SellerOverviewController overviewController,
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
                      'Property Distribution',
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

  Widget buildPropertyGrowthGraph(SellerOverviewController overviewController) {
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
                      'Property Growth',
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
            height: 350,
            width: double.infinity,
            child: PropertyGrowthPieGraph(
              breakdown: {
                'sold':
                    overviewController
                        .overviewData
                        .value
                        ?.data
                        ?.propertyMetrics
                        ?.statusDistribution['sold'],
                'unsold':
                    overviewController
                        .overviewData
                        .value
                        ?.data
                        ?.propertyMetrics
                        ?.statusDistribution['unsold'],
                'dead':
                    overviewController
                        .overviewData
                        .value
                        ?.data
                        ?.propertyMetrics
                        ?.statusDistribution['dead'],
                'duplicate':
                    overviewController
                        .overviewData
                        .value
                        ?.data
                        ?.propertyMetrics
                        ?.statusDistribution['duplicate'],
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget leadLifecycleFunnel(SellerOverviewController overviewController) {
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

  Widget buildLeadSourceDistributionGraph(
    SellerOverviewController overviewController,
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
            height: 360,
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
}

class OverViewCard extends StatelessWidget {
  final List<Items> property;
  final SellerInsightsModel overview;

  const OverViewCard({
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
              'Total Listed Properties',
              data?.propertyMetrics?.totalProperties.toString() ?? '',
              Icons.home_work,
              ColorRes.blueColor,
            ),
            buildMetricCard(
              'Total Property Views',
              Formatter.formatNumber(
                data?.propertyMetrics?.viewsHistory
                        .map((e) => e.views)
                        .fold<int>(
                          0,
                          (previousValue, element) => previousValue + element,
                        ) ??
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

  /// 🔹 Helper to format large numbers (K, L, Cr)
  String _formatValue(num value) {
    if (value >= 10000000) return "${(value / 10000000).toStringAsFixed(1)}Cr";
    if (value >= 100000) return "${(value / 100000).toStringAsFixed(1)}L";
    if (value >= 1000) return "${(value / 1000).toStringAsFixed(1)}K";
    return value.toStringAsFixed(0);
  }
}

class AddOnsForBuyer extends StatelessWidget {
  const AddOnsForBuyer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175, // set fixed height for all cards
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: addonData.length,
        separatorBuilder: (_, __) => const SizedBox(width: 2),
        itemBuilder: (context, index) {
          final addon = addonData[index];
          return SizedBox(
            width: 250,
            child: AddonCard(
              title: addon['title'],
              description: addon['description'],
              price: addon['price'],
              isPopular: addon['isPopular'] ?? false,
              onTap: () {
                print('${addon['title']} added!');
              },
            ),
          );
        },
      ),
    );
  }
}

class AddonCard extends StatelessWidget {
  final String title;
  final String description;
  final double price;
  final Color backgroundColor;
  final VoidCallback? onTap;
  final bool isPopular;

  const AddonCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    this.backgroundColor = ColorRes.white,
    this.onTap,
    this.isPopular = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPopular ? ColorRes.primary : ColorRes.leadGreyColor[300]!,
            width: isPopular ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // if (isPopular)
            //   Container(
            //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            //     decoration: BoxDecoration(
            //       color: Colors.orange,
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     child: const Text(
            //       'POPULAR',
            //       style: TextStyle(
            //         color: ColorRes.white,
            //         fontSize: 10,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: AppFontWeights.extraBold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: AppFontSizes.bodySmall,
                color: ColorRes.leadGreyColor[700],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: AppFontSizes.bodyMedium,
                    fontWeight: AppFontWeights.extraBold,
                    color: ColorRes.success,
                  ),
                ),
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorRes.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                  ),
                  child: Text(
                    'Add',
                    style: TextStyle(
                      fontSize: AppFontSizes.bodySmall,
                      fontWeight: AppFontWeights.extraBold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PricingComparisonWidget extends StatefulWidget {
  final List<PricingPlan> plans;
  final Function(PricingPlan)? onPlanSelected;
  final Duration animationDuration;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;

  const PricingComparisonWidget({
    Key? key,
    required this.plans,
    this.onPlanSelected,
    this.animationDuration = const Duration(milliseconds: 800),
    this.primaryColor = ColorRes.builderGridPurple,
    this.secondaryColor = ColorRes.builderGridLightGreen,
    this.backgroundColor = ColorRes.white,
  }) : super(key: key);

  @override
  State<PricingComparisonWidget> createState() =>
      _PricingComparisonWidgetState();
}

class _PricingComparisonWidgetState extends State<PricingComparisonWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int? selectedPlanIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ColorRes.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorRes.leadGreyColor[300]!),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              _buildComparisonTable(),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          decoration: BoxDecoration(
            color: ColorRes.white,
            borderRadius: BorderRadius.circular(12),
            // border: Border(bottom: BorderSide(color: ColorRes.leadGreyColor[200]!)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    "Plans",
                    style: TextStyle(
                      fontSize: AppFontSizes.subtitle,
                      fontWeight: AppFontWeights.extraBold,
                      color: widget.primaryColor,
                    ),
                  ),
                ),
              ),
              const Expanded(child: Text("", style: TextStyle(fontSize: 14))),
              ...widget.plans.map((plan) {
                return Expanded(
                  child: Text(
                    plan.name,
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.semiBold,
                      color:
                          plan.isPopular
                              ? widget.primaryColor
                              : const Color(0xFF4A4A4A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        Divider(height: 1, color: ColorRes.leadGreyColor[200]!),
      ],
    );
  }

  Widget _buildComparisonTable() {
    final allFeatures = _getAllUniqueFeatures();

    return Column(
      children:
          allFeatures.map((featureName) {
            return _buildFeatureRow(featureName);
          }).toList(),
    );
  }

  List<String> _getAllUniqueFeatures() {
    Set<String> features = {};
    for (var plan in widget.plans) {
      features.addAll(plan.features.keys);
    }
    return features.toList();
  }

  Widget _buildFeatureRow(String featureName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1), // Reduced margin
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        border: Border(bottom: BorderSide(color: ColorRes.leadGreyColor[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              featureName,
              style: TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.medium,
                color: Color(0xFF4A4A4A),
              ),
            ),
          ),
          ...widget.plans.map((plan) {
            final feature = plan.features[featureName];
            return Expanded(child: _buildFeatureValue(feature));
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildFeatureValue(PlanFeature? feature) {
    if (feature == null) {
      return Text(
        "-",
        style: TextStyle(
          fontSize: AppFontSizes.medium,
          color: ColorRes.leadGreyColor,
          fontWeight: AppFontWeights.medium,
        ),
        textAlign: TextAlign.center,
      );
    }

    switch (feature.type) {
      case FeatureType.boolean:
        return Icon(
          feature.value == true ? Icons.check_circle : Icons.cancel,
          color: feature.value == true ? widget.secondaryColor : ColorRes.error,
          size: 20,
        );
      case FeatureType.percentage:
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: feature.value / 100),
                duration: widget.animationDuration,
                builder: (context, value, child) {
                  return CircularProgressIndicator(
                    value: value,
                    strokeWidth: 4,
                    backgroundColor: ColorRes.leadGreyColor[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      feature.value >= 90
                          ? widget.secondaryColor
                          : widget.primaryColor,
                    ),
                  );
                },
              ),
            ),
            Text(
              '${feature.value.toInt()}%',
              style: TextStyle(
                fontSize: AppFontSizes.extraSmall,
                fontWeight: AppFontWeights.extraBold,
              ),
            ),
          ],
        );
      case FeatureType.text:
        return Text(
          feature.value.toString(),
          style: TextStyle(
            fontSize: AppFontSizes.bodySmall,
            fontWeight: AppFontWeights.medium,
            color:
                feature.isHighlight
                    ? widget.primaryColor
                    : const Color(0xFF4A4A4A),
          ),
          textAlign: TextAlign.center,
        );
      case FeatureType.number:
        return Text(
          feature.value.toString(),
          style: TextStyle(
            fontSize: AppFontSizes.bodySmall,
            fontWeight: AppFontWeights.medium,
            color:
                feature.isHighlight
                    ? widget.primaryColor
                    : const Color(0xFF4A4A4A),
          ),
          textAlign: TextAlign.center,
        );
    }
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: Row(
        children:
            widget.plans.map((plan) {
              int index = widget.plans.indexOf(plan);
              bool isSelected = selectedPlanIndex == index;

              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: index > 0 ? 8 : 0),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedPlanIndex = index;
                            });
                            widget.onPlanSelected?.call(plan);
                            _showPlanDetails(plan);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                plan.isPopular
                                    ? widget.primaryColor
                                    : ColorRes.leadGreyColor[200],
                            foregroundColor:
                                plan.isPopular
                                    ? ColorRes.white
                                    : ColorRes.leadGreyColor[700],
                            elevation: isSelected ? 8 : 2,
                            // shadowColor: (plan.isPopular
                            //         ? widget.primaryColor
                            //         : widget.secondaryColor)
                            //     .withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            plan.buttonText,
                            style: TextStyle(
                              fontWeight: AppFontWeights.semiBold,
                              fontSize: AppFontSizes.bodySmall,
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(height: 8),
                      // TextButton(
                      //   onPressed: () {
                      //     _showPlanDetails(plan);
                      //   },
                      //   child: Text(
                      //     'Know More',
                      //     style: TextStyle(
                      //       color: widget.primaryColor,
                      //       fontSize: 12,
                      //       decoration: TextDecoration.underline,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  void _showPlanDetails(PricingPlan plan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorRes.transparentColor,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: ColorRes.leadGreyColor[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    plan.name,
                    style: TextStyle(
                      fontSize: AppFontSizes.subtitle,
                      fontWeight: AppFontWeights.semiBold,
                      color: widget.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children:
                          plan.features.entries.map((entry) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: ColorRes.leadGreyColor[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      entry.key,
                                      style: TextStyle(
                                        fontSize: AppFontSizes.medium,
                                        fontWeight: AppFontWeights.medium,
                                      ),
                                    ),
                                  ),
                                  _buildFeatureValue(entry.value),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

// Data Models
class PricingPlan {
  final String name;
  final String buttonText;
  final bool isPopular;
  final Map<String, PlanFeature> features;

  PricingPlan({
    required this.name,
    required this.buttonText,
    this.isPopular = false,
    required this.features,
  });
}

class PlanFeature {
  final dynamic value;
  final FeatureType type;
  final bool isHighlight;

  PlanFeature({
    required this.value,
    required this.type,
    this.isHighlight = false,
  });
}

enum FeatureType { boolean, text, number, percentage }

// Example Usage
class PricingWidgetDemo extends StatelessWidget {
  const PricingWidgetDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final plans = [
      PricingPlan(
        name: 'Free',
        buttonText: 'Know More',
        features: {
          'Visibility': PlanFeature(value: 15.0, type: FeatureType.percentage),
          'Leads': PlanFeature(value: 'Only 3', type: FeatureType.text),
          'Listing expiry': PlanFeature(
            value: '15 Days',
            type: FeatureType.text,
          ),
          'Matching buyers': PlanFeature(
            value: false,
            type: FeatureType.boolean,
          ),
          'Relationship Manager': PlanFeature(
            value: false,
            type: FeatureType.boolean,
          ),
          'Field Visit Assistance': PlanFeature(
            value: false,
            type: FeatureType.boolean,
          ),
          'PhotoShoot': PlanFeature(value: false, type: FeatureType.boolean),
        },
      ),
      PricingPlan(
        name: 'Owner',
        buttonText: 'Explore',
        isPopular: true,
        features: {
          'Visibility': PlanFeature(
            value: 98.0,
            type: FeatureType.percentage,
            isHighlight: true,
          ),
          'Leads': PlanFeature(
            value: 'Unlimited',
            type: FeatureType.text,
            isHighlight: true,
          ),
          'Listing expiry': PlanFeature(
            value: '120 Days',
            type: FeatureType.text,
            isHighlight: true,
          ),
          'Matching buyers': PlanFeature(
            value: true,
            type: FeatureType.boolean,
          ),
          'Relationship Manager': PlanFeature(
            value: true,
            type: FeatureType.boolean,
          ),
          'Field Visit Assistance': PlanFeature(
            value: true,
            type: FeatureType.boolean,
          ),
          'PhotoShoot': PlanFeature(value: true, type: FeatureType.boolean),
        },
      ),
    ];

    return PricingComparisonWidget(
      plans: plans,
      primaryColor: ColorRes.primary,
      onPlanSelected: (plan) {
        print('Selected: ${plan.name}');
      },
    );
  }
}

class CustomerSupportCard extends StatelessWidget {
  final String email;
  final String phone;

  const CustomerSupportCard({
    super.key,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorRes.leadGreyColor[300]!),
      ),
      // margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.support_agent, color: ColorRes.primary),
                const SizedBox(width: 8),
                Text(
                  "Customer Support",
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ColorRes.leadGreyColor[300]!),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),

              child: Row(
                children: [
                  Icon(Icons.email_outlined, color: ColorRes.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      email,
                      style: TextStyle(fontSize: AppFontSizes.bodySmall),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ColorRes.leadGreyColor[300]!),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Row(
                children: [
                  Icon(Icons.phone_outlined, color: ColorRes.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      phone,
                      style: TextStyle(fontSize: AppFontSizes.bodySmall),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildSellerLeadGraph(SellerOverviewController overviewController) {
  final leadsTrend =
      overviewController.overviewData.value?.data?.leadAnalytics?.leadsTimeline
          ?.map<Map<String, dynamic>>(
            (e) => {"month": e.month ?? '', "leads": e.count ?? 0},
          )
          .toList() ??
      [];

  // --- Step 1: Extract all years present in data ---
  final Set<String> yearsInData =
      leadsTrend.map((e) => e['month'].toString().split('-').first).toSet();

  // --- Step 2: Determine which year to display ---
  // Prefer latest available year; fallback to current year
  final String displayYear =
      yearsInData.isNotEmpty
          ? (yearsInData.toList()..sort()).last
          : DateTime.now().year.toString();

  // --- Step 3: Collect month data for that year ---
  final Map<String, double> monthDataForYear = {};
  for (var e in leadsTrend) {
    final parts = e['month'].toString().split('-');
    if (parts.length == 2 && parts[0] == displayYear) {
      monthDataForYear[parts[1]] = (e['leads'] as num).toDouble();
    }
  }

  // --- Step 4: Fill missing months (1–12) with zero ---
  final mergedData = List.generate(12, (i) {
    final month = (i + 1).toString().padLeft(2, '0');
    return {
      "month": "$displayYear-$month",
      "leads": monthDataForYear[month] ?? 0,
    };
  });

  // --- Step 5: Extract for chart ---
  final List<String> months =
      mergedData.map((e) => e['month'] as String).toList();

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
          ],
        ),
        const SizedBox(height: 12),

        // --- Chart section ---
        SizedBox(
          height: 200,
          width: double.infinity,
          child: MonthlyBarChart(
            monthlyData: monthlyData,
            months: months,
            color: ColorRes.green,
          ),
        ),
      ],
    ),
  );
}

Widget buildSellerCommissionGraph(
  SellerOverviewController overviewController,
  String title,
) {
  final leadsTrend =
      overviewController.overviewData.value?.data?.propertyMetrics?.viewsHistory
          .map<Map<String, dynamic>>(
            (e) => {"month": e.month ?? '', "views": e.views ?? 0},
          )
          .toList() ??
      [];

  // --- Step 1: Extract all years present in data ---
  final Set<String> yearsInData =
      leadsTrend.map((e) => e['month'].toString().split('-').first).toSet();

  // --- Step 2: Determine which year to display ---
  // Prefer latest available year; fallback to current year
  final String displayYear =
      yearsInData.isNotEmpty
          ? (yearsInData.toList()..sort()).last
          : DateTime.now().year.toString();

  // --- Step 3: Collect month data for that year ---
  final Map<String, double> monthDataForYear = {};
  for (var e in leadsTrend) {
    final parts = e['month'].toString().split('-');
    if (parts.length == 2 && parts[0] == displayYear) {
      monthDataForYear[parts[1]] = (e['views'] as num).toDouble();
    }
  }

  // --- Step 4: Fill missing months (1–12) with zero ---
  final mergedData = List.generate(12, (i) {
    final month = (i + 1).toString().padLeft(2, '0');
    return {
      "month": "$displayYear-$month",
      "views": monthDataForYear[month] ?? 0,
    };
  });

  // --- Step 5: Extract for chart ---
  final List<String> months =
      mergedData.map((e) => e['month'] as String).toList();

  final List<double> monthlyData =
      mergedData.map((e) => (e['views'] as num).toDouble()).toList();

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
              color: ColorRes.reportCardblue,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$title',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: ColorRes.reportCardblue,
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
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: MonthlyBarChart(
            monthlyData: monthlyData,
            months: months,
            color: ColorRes.reportCardblue,
            isAmount: false,
          ),
        ),
      ],
    ),
  );
}

Widget buildSellerPropertyCreatedGraph(
  SellerOverviewController overviewController,
  String title,
) {
  final leadsTrend =
      overviewController
          .overviewData
          .value
          ?.data
          ?.propertyMetrics
          ?.propertyTimeline
          .map<Map<String, dynamic>>(
            (e) => {"month": e.month ?? '', "count": e.count ?? 0},
          )
          .toList() ??
      [];

  // --- Step 1: Extract all years present in data ---
  final Set<String> yearsInData =
      leadsTrend.map((e) => e['month'].toString().split('-').first).toSet();

  // --- Step 2: Determine which year to display ---
  // Prefer latest available year; fallback to current year
  final String displayYear =
      yearsInData.isNotEmpty
          ? (yearsInData.toList()..sort()).last
          : DateTime.now().year.toString();

  // --- Step 3: Collect month data for that year ---
  final Map<String, double> monthDataForYear = {};
  for (var e in leadsTrend) {
    final parts = e['month'].toString().split('-');
    if (parts.length == 2 && parts[0] == displayYear) {
      monthDataForYear[parts[1]] = (e['count'] as num).toDouble();
    }
  }

  // --- Step 4: Fill missing months (1–12) with zero ---
  final mergedData = List.generate(12, (i) {
    final month = (i + 1).toString().padLeft(2, '0');
    return {
      "month": "$displayYear-$month",
      "count": monthDataForYear[month] ?? 0,
    };
  });

  // --- Step 5: Extract for chart ---
  final List<String> months =
      mergedData.map((e) => e['month'] as String).toList();

  final List<double> monthlyData =
      mergedData.map((e) => (e['count'] as num).toDouble()).toList();

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
            Icon(Icons.home_work, color: ColorRes.reportCardblue, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$title',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: ColorRes.reportCardblue,
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
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: MonthlyBarChart(
            monthlyData: monthlyData,
            months: months,
            color: ColorRes.reportCardblue,
            isAmount: false,
          ),
        ),
      ],
    ),
  );
}
