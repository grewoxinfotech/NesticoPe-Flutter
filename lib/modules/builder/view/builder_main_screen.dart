// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
// import '../controller/builder_form_controller.dart';
// import 'builder_dashboard.dart';
// import 'builder_form_screen.dart';
// import 'builder_leads.dart';
// import 'builder_property_listing.dart';
// import 'builder_profile.dart';
// import '../controller/builder_navigation_controller.dart';
//
// class BuilderMainScreen extends StatelessWidget {
//   const BuilderMainScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final navigationController = Get.put(BuilderNavigationController());
//
//     final screens = [
//       const BuilderDashboard(),
//       const BuilderPropertyListing(),
//       const BuilderLeads(),
//       const BuilderProfile(),
//     ];
//
//     return Scaffold(
//       body: Obx(
//         () => IndexedStack(
//           index: navigationController.currentIndex.value,
//           children: screens,
//         ),
//       ),
//       bottomNavigationBar: Obx(
//         () => Container(
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.08),
//                 blurRadius: 12,
//                 offset: const Offset(0, -2),
//               ),
//             ],
//           ),
//           child: BottomAppBar(
//             shape: const CircularNotchedRectangle(),
//             notchMargin: 8,
//             elevation: 0,
//             color: ColorRes.white,
//             child: Container(
//               height: 65,
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: Row(
//                 children: [
//                   _buildNavItem(Icons.dashboard_rounded, 'Dashboard', 0, navigationController.currentIndex.value, () => navigationController.changeTabIndex(0)),
//                   _buildNavItem(Icons.apartment_rounded, 'Property', 1, navigationController.currentIndex.value, () => navigationController.changeTabIndex(1)),
//                   const SizedBox(width: 80),
//                   _buildNavItem(Icons.people_rounded, 'Leads', 2, navigationController.currentIndex.value, () => navigationController.changeTabIndex(2)),
//                   _buildNavItem(Icons.person_rounded, 'Profile', 3, navigationController.currentIndex.value, () => navigationController.changeTabIndex(3)),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNavItem(IconData icon, String label, int index, int currentIndex, VoidCallback onTap) {
//     final isSelected = currentIndex == index;
//     return Expanded(
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Container(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, size: 24, color: isSelected ? ColorRes.primary : Colors.grey[400]),
//               const SizedBox(height: 4),
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 11,
//                   fontWeight: isSelected ? AppFontWeights.semiBold : AppFontWeights.medium,
//                   color: isSelected ? ColorRes.primary : Colors.grey[600],
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:housing_flutter_app/modules/builder/controller/builder_form_controller.dart';
import 'package:housing_flutter_app/modules/builder/view/builder_form_screen.dart';
import 'package:housing_flutter_app/modules/builder/view/subscription_plan/builder_sunbscription_plan.dart';
import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';
import '../../profile/views/seller_profile_detail.dart';
import '../controller/builder_navigation_controller.dart';
import 'package:get/get.dart';

import 'builder_dashboard.dart';
import 'builder_leads.dart';
import 'builder_profile.dart';
import 'builder_property_listing.dart';

class BuilderMainScreen extends StatelessWidget {
  const BuilderMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.put(BuilderNavigationController());
    Get.put(ProjectWizardController(isBuilderView: true), tag: "builder");
    Get.lazyPut(() => PropertyController());

    final screens = [
      const BuilderDashboard(),
      const BuilderPropertyListing(),
      BuilderLeads(),
      BuilderSubscriptionPlanScreen(),
      SellerProfileScreen(),
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
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
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
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.dashboard_outlined, size: 22),
                ),
                label: 'Dashboard',
              ),

              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.location_city_outlined, size: 22),
                ),
                label: 'Projects',
              ),

              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.groups_outlined, size: 22),
                ),
                label: 'Leads',
              ),

              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.workspace_premium_outlined, size: 22),
                ),
                label: 'Plans',
              ),

              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.person_outline_rounded, size: 22),
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
