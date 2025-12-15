import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';
import 'package:housing_flutter_app/modules/dashboard/views/widget/dashboard_layout.dart';
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
import '../controller/builder_form_controller.dart';
import 'builder_form_screen.dart';

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

    return DashboardLayout(
      floatingButton: FloatingActionButton.extended(
        onPressed: () {
          final controller = Get.put(
            ProjectWizardController(isBuilderView: false),
            tag: "builder",
          );
          controller.resetForm();
          Get.to(CreateProjectScreen());
          // Get.to(ProjectWizardView(),binding: BindingsBuilder(() {
          //     Get.put(ProjectWizardController());
          //   },));
        },
        label: Text(
          '+ Add Project',
          style: TextStyle(
            color: ColorRes.white,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
      ),
      child: Column(
        children: [
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
                  overview: overview ?? SellerInsightsModel.fromJson({}),
                ),
                const SizedBox(height: 20),
              ],
            );
          }),
          Obx(() => buildSellerLeadGraph(overviewController)),
          const SizedBox(height: 20),
          Obx(() => buildSellerCommissionGraph(overviewController)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
//class BuilderDashboard extends StatefulWidget {
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
//     return Scaffold(
//       backgroundColor: ColorRes.white,
//       appBar: AppBar(
//         title: Text(
//           'Dashboard',
//           style: TextStyle(fontWeight: AppFontWeights.bold),
//         ),
//         backgroundColor: ColorRes.white,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         actions: [
//           TextButton(
//             onPressed: () {
//               Get.offAll(() => DashboardScreen());
//             },
//             child: Text('Switch To Buyer'),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Welcome Card
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: ColorRes.primary,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Welcome Back!',
//                           style: TextStyle(
//                             fontSize: AppFontSizes.large,
//                             fontWeight: AppFontWeights.bold,
//                             color: ColorRes.white,
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           'Manage your properties efficiently',
//                           style: TextStyle(
//                             fontSize: AppFontSizes.bodySmall,
//                             color: ColorRes.white.withOpacity(0.9),
//                           ),
//                           maxLines: 2,
//
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: ColorRes.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(
//                       Icons.home_work_rounded,
//                       size: 40,
//                       color: ColorRes.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Obx(() {
//               final overview = overviewController.overviewData.value;
//               if (controller.isLoading.value && controller.items.isEmpty) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//
//               if (overviewController.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   OverBuilderViewCard(
//                     property: controller.items,
//                     overview: overview ?? SellerInsightsModel.fromJson({}),
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               );
//             }),
//             Obx(() => buildSellerLeadGraph(overviewController)),
//             const SizedBox(height: 20),
//             Obx(() => buildSellerCommissionGraph(overviewController)),
//             const SizedBox(height: 20),
//
//             // Recent Activities
//           ],
//         ),
//       ),
//
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           final controller = Get.put(
//             ProjectWizardController(isBuilderView: false),
//             tag: "builder",
//           );
//           controller.resetForm();
//           Get.to(CreateProjectScreen());
//           // Get.to(ProjectWizardView(),binding: BindingsBuilder(() {
//           //     Get.put(ProjectWizardController());
//           //   },));
//         },
//         label: Text(
//           '+ Add Project',
//           style: TextStyle(
//             color: ColorRes.white,
//             fontWeight: AppFontWeights.semiBold,
//           ),
//         ),
//       ),
//     );
//   }
// }

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
