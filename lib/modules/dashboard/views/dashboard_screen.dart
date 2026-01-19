// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:housing_flutter_app/app/utils/helper_function/user_helper/user_helper.dart';
// import 'package:housing_flutter_app/data/network/auth/model/user_model.dart';
// import 'package:housing_flutter_app/modules/auth/views/login_screen.dart';
// import 'package:housing_flutter_app/modules/auth/views/register_screen.dart';
// import 'package:housing_flutter_app/modules/auth/views/role_convert/convert_to_seller/convert_to_seller.dart';
// import 'package:housing_flutter_app/modules/builder/controller/builder_form_controller.dart';
// import 'package:housing_flutter_app/modules/calender/views/calender_screen.dart';
// import 'package:housing_flutter_app/modules/dashboard/views/seller_dashboard_screen.dart';
// import 'package:housing_flutter_app/modules/dashboard/views/widget/favourite_screen.dart';
// import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';
// import 'package:housing_flutter_app/modules/reseller/view/property_reseller.dart';
// import 'package:housing_flutter_app/modules/saved_property/views/user_activity_screen.dart';
// import 'package:housing_flutter_app/modules/seller/module/seller_home_screen/views/property_overview_screen.dart';
// import 'package:housing_flutter_app/widgets/bar/navigation_bar/navigation_Bar.dart';
// import '../../../data/database/secure_storage_service.dart';
// import '../../../widgets/dialogs/delete_dialog.dart';
// import '../../../widgets/drawer/drawer.dart';
// import 'package:get/get.dart';
//
// import '../../auth/views/role_convert/covert_to_reseller/convert_to_reseller.dart';
// import '../../builder/view/all_project_list_screen.dart';
// import '../../builder/view/builder_main_screen.dart';
// import '../../contractor/view/contractor_main.dart';
// import '../../contractor/view/widget/convert_to_contractor.dart';
// import '../../feedback/views/feedback_and_report.dart';
// import '../../hire_contractor/view/hire_contractor_screen.dart';
// import '../../home/views/compare_screen/comapre_screen.dart';
// import '../../home/views/home_screen/home_screen.dart';
// import '../../feedback/controller/feedback_controller.dart';
// import '../../feedback/views/buyer_feedback.dart';
//
// import '../../insights/views/insights_screen.dart';
// import '../../location_price_matrix/views/location_price_mtrix_screen.dart';
// import '../../propert_detail/view/property_details.dart';
// import '../../referral/view/referral_dashboard.dart';
// import '../../reseller/view/reseller_success_stories/reseller_success_stories.dart';
// import '../../saved_property/views/saved_property_screen.dart';
// import '../../seller/seller_listing/view/seller_listing_view.dart';
// import '../../support_ticket/controllers/chat_socket_controller.dart';
// import '../../support_ticket/views/support_ticket_screen.dart';
//
// import 'package:flutter/material.dart';
// import 'package:housing_flutter_app/modules/dashboard/views/widget/favourite_screen.dart';
// import 'package:housing_flutter_app/modules/saved_property/views/saved_property_screen.dart';
// import 'package:housing_flutter_app/widgets/bar/navigation_bar/navigation_Bar.dart';
// import 'package:get/get.dart';
//
// import '../../home/views/home_screen/home_screen.dart';
// import '../../insights/views/insights_screen.dart';
//
// class DashboardScreen extends StatefulWidget {
//   final List<Map<String, String>>? propertyFilter;
//   const DashboardScreen({super.key, this.propertyFilter});
//
//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _setAppLaunched();
//   }
//
//   Future<void> _setAppLaunched() async {
//     await SecureStorage.setAppLaunched();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final navigationController = Get.put(NavigationController());
//     Get.lazyPut(
//       () => ProjectWizardController(isBuilderView: false),
//       tag: 'builder',
//     );
//
//     return Scaffold(
//       extendBody: true,
//       bottomNavigationBar: const SafeArea(child: NesticoPeNavigationBar()),
//       body: Obx(() {
//         // Clean navigation logic - all buttons moved to ProfileScreen
//         switch (navigationController.currentIndex.value) {
//           case 0:
//             return HomeScreen();
//           case 1:
//             return PropertyDetail(
//               isFromSeeAll: true,
//               filters: widget.propertyFilter,
//             );
//           case 2:
//             return AllProjectListScreen(isFromSeeAll: true, isbuilder: false);
//           case 3:
//             return InsightsScreen();
//           case 4:
//             return HireContractorScreen();
//
//           default:
//             return const SizedBox();
//         }
//       }),
//     );
//   }
// }
//
//

import 'package:flutter/material.dart';
import 'package:housing_flutter_app/modules/dashboard/views/widget/favourite_screen.dart';
import 'package:housing_flutter_app/modules/saved_property/views/saved_property_screen.dart';
import 'package:housing_flutter_app/widgets/bar/navigation_bar/navigation_Bar.dart';
import 'package:get/get.dart';

import '../../../data/database/secure_storage_service.dart';
import '../../builder/controller/builder_form_controller.dart';
import '../../builder/view/all_project_list_screen.dart';
import '../../home/views/home_screen/home_screen.dart';
import '../../insights/views/insights_screen.dart';
import '../../propert_detail/view/property_details.dart';
import '../../hire_contractor/view/hire_contractor_screen.dart';

class DashboardScreen extends StatefulWidget {
  final List<Map<String, String>>? propertyFilter;
  const DashboardScreen({super.key, this.propertyFilter});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // ✅ Removed _setAppLaunched() - it's now handled in onboarding
  }

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.put(NavigationController());
    Get.lazyPut(
      () => ProjectWizardController(isBuilderView: false),
      tag: 'builder',
    );

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const SafeArea(child: NesticoPeNavigationBar()),
      body: Obx(() {
        switch (navigationController.currentIndex.value) {
          case 0:
            return HomeScreen();
          case 1:
            return PropertyDetail(
              isFromSeeAll: true,
              filters: widget.propertyFilter,
            );
          case 2:
            return AllProjectListScreen(isFromSeeAll: true, isbuilder: false);
          case 3:
            return InsightsScreen();
          case 4:
            return HireContractorScreen();
          default:
            return const SizedBox();
        }
      }),
    );
  }
}
