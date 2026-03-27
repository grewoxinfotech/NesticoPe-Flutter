// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/app/constants/color_res.dart';
// import 'package:nesticope_app/app/constants/app_font_sizes.dart';
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
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/modules/builder/controller/builder_form_controller.dart';
import 'package:nesticope_app/modules/builder/view/builder_form_screen.dart';
import 'package:nesticope_app/modules/builder/view/subscription_plan/builder_sunbscription_plan.dart';
import 'package:nesticope_app/modules/profile/controllers/buyer_profiledata.dart';
import 'package:nesticope_app/modules/property/controllers/property_controller.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';
import '../../profile/views/seller_profile_detail.dart';
import '../controller/builder_navigation_controller.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'builder_dashboard.dart';
import 'builder_leads.dart';
import 'builder_profile.dart';
import 'builder_property_listing.dart';

// class BuilderMainScreen extends StatelessWidget {
//   const BuilderMainScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final navigationController = Get.put(BuilderNavigationController());
//     Get.put(ProjectWizardController(isBuilderView: true), tag: "builder");
//     Get.lazyPut(() => PropertyController());
//     if (!Get.isRegistered<BuyerProfileDataController>()) {
//       Get.put(BuyerProfileDataController());
//     }
//     final BuyerProfileDataController profile =
//         Get.find<BuyerProfileDataController>();

//     final screens = [
//       const BuilderDashboard(),
//       const BuilderPropertyListing(),
//       BuilderLeads(isViewAll: true),
//       BuilderSubscriptionPlanScreen(),
//       SellerProfileScreen(),
//     ];

//     return Scaffold(
//       body: Obx(
//         () => IndexedStack(
//           index: navigationController.currentIndex.value,
//           children: screens,
//         ),
//       ),

//       bottomNavigationBar: Obx(() {
//         final TextStyle style = TextStyle(
//           fontSize: AppFontSizes.small,
//           fontWeight: AppFontWeights.extraBold,
//           color: Get.theme.colorScheme.primary,
//         );
//         return SafeArea(
//           child: Card(
//             elevation: 5,
//             shadowColor: Get.theme.colorScheme.surface,
//             color: Get.theme.colorScheme.surface,
//             margin: const EdgeInsets.only(
//               left: AppMargin.small,
//               bottom: AppMargin.small,
//               right: AppMargin.small,
//             ),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(AppRadius.large),
//             ),
//             child: Container(
//               height: kToolbarHeight,
//               alignment: Alignment.center,
//               child: SalomonBottomBar(
//                 duration: const Duration(milliseconds: 400),
//                 unselectedItemColor: Get.theme.colorScheme.onSurface
//                     .withOpacity(0.7),
//                 margin: const EdgeInsets.all(AppPadding.small),
//                 itemShape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(AppRadius.large),
//                 ),
//                 itemPadding: const EdgeInsets.all(AppPadding.small),
//                 currentIndex: navigationController.currentIndex.value,
//                 onTap: (i) => navigationController.changeTabIndex(i),
//                 items: [
//                   SalomonBottomBarItem(
//                     icon: const Icon(Icons.dashboard_outlined, size: 22),
//                     title: Text('Dashboard', style: style),
//                   ),
//                   SalomonBottomBarItem(
//                     icon: const Icon(Icons.location_city_outlined, size: 22),
//                     title: Text('Projects', style: style),
//                   ),
//                   SalomonBottomBarItem(
//                     icon: const Icon(Icons.groups_outlined, size: 22),
//                     title: Text('Leads', style: style),
//                   ),
//                   SalomonBottomBarItem(
//                     icon: const Icon(
//                       Icons.workspace_premium_outlined,
//                       size: 22,
//                     ),
//                     title: Text('Plans', style: style),
//                   ),
//                   SalomonBottomBarItem(
//                     icon: Obx(() {
//                       final selected =
//                           navigationController.currentIndex.value == 4;
//                       final imageUrl =
//                           profile.userProfile.value?.profilePic ?? '';
//                       return Container(
//                     width: 28,
//                     height: 28,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color:
//                             selected
//                                 ? Get.theme.colorScheme.primary
//                                 : Get.theme.colorScheme.onSurface.withOpacity(
//                                   0.4,
//                                 ),
//                         width: selected ? 1.5 : 1,
//                       ),
//                     ),
//                     child: CircleAvatar(
//                       radius: 14,
//                       backgroundColor: Get.theme.colorScheme.primary,
//                       child: ClipOval(
//                         child: Icon(
//                           Icons.person,
//                           color: Colors.white,
//                           size: 16,
//                         ),
//                       ),
//                     ),
//                   );
//                     }),
//                     title: Text("Profile", style: style),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }


class BuilderMainScreen extends StatefulWidget {
  const BuilderMainScreen({Key? key}) : super(key: key);

  @override
  State<BuilderMainScreen> createState() => _BuilderMainScreenState();
}

class _BuilderMainScreenState extends State<BuilderMainScreen> {
  final navigationController = Get.put(BuilderNavigationController());

  late final BuyerProfileDataController profile;
  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();

    /// ✅ Init controllers properly
    Get.put(ProjectWizardController(isBuilderView: true), tag: "builder");
    Get.lazyPut(() => PropertyController());

    if (!Get.isRegistered<BuyerProfileDataController>()) {
      profile = Get.put(BuyerProfileDataController());
    } else {
      profile = Get.find<BuyerProfileDataController>();
    }

    /// ✅ Screens list
    screens = [
      const BuilderDashboard(),
      const BuilderPropertyListing(),
      BuilderLeads(isViewAll: true),
      BuilderSubscriptionPlanScreen(),
      SellerProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final index = navigationController.currentIndex.value;

      return PopScope(
        canPop: index == 0,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            navigationController.changeTabIndex(0);
          }
        },
        child: Scaffold(
          body: IndexedStack(
            index: index,
            children: screens,
          ),

          /// ✅ Bottom Navigation (same as others)
          bottomNavigationBar: SafeArea(
            child: Builder(
              builder: (context) {
                TextStyle style = TextStyle(
                  fontSize: AppFontSizes.caption,
                  fontWeight: AppFontWeights.semiBold,
                  color: Get.theme.colorScheme.primary,
                );

                double iconSize = 18;

                return Card(
                  elevation: 6,
                  shadowColor: Colors.black12,
                  color: Get.theme.colorScheme.surface,
                  margin: const EdgeInsets.only(
                    left: AppMargin.small,
                    right: AppMargin.small,
                    bottom: AppMargin.small,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppRadius.large),
                  ),
                  child: Container(
                    height: kToolbarHeight,
                    alignment: Alignment.center,
                    child: SalomonBottomBar(
                      duration: const Duration(milliseconds: 200),
                      margin:
                          const EdgeInsets.all(AppPadding.small),
                      itemPadding:
                          const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      itemShape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.large),
                      ),
                      currentIndex: index,
                      onTap:
                          navigationController.changeTabIndex,
                      unselectedItemColor:
                          Get.theme.colorScheme.onSurface
                              .withOpacity(0.6),

                      items: [
                        /// ✅ Dashboard
                        SalomonBottomBarItem(
                          icon: Icon(
                            Icons.dashboard_outlined,
                            size: iconSize * 1.2,
                          ),
                          title: Text("Dashboard", style: style),
                        ),

                        /// ✅ Projects
                        SalomonBottomBarItem(
                          icon: Icon(
                            Icons.location_city_outlined,
                            size: iconSize * 1.2,
                          ),
                          title: Text("Projects", style: style),
                        ),

                        /// ✅ Leads
                        SalomonBottomBarItem(
                          icon: Icon(
                            Icons.groups_outlined,
                            size: iconSize * 1.2,
                          ),
                          title: Text("Leads", style: style),
                        ),

                        /// ✅ Plans
                        SalomonBottomBarItem(
                          icon: Icon(
                            Icons.credit_card,
                            size: iconSize * 1.2,
                          ),
                          title: Text("Plans", style: style),
                        ),

                        /// ✅ Profile Avatar
                        SalomonBottomBarItem(
                          icon: Obx(() {
                            final selected =
                                navigationController
                                        .currentIndex.value ==
                                    4;

                            final imageUrl =
                                profile.userProfile.value
                                        ?.profilePic ??
                                    "";

                            return Container(
                              height: 26,
                              width: 26,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: selected
                                      ? Get.theme.colorScheme
                                          .primary
                                      : Colors.grey.shade400,
                                  width:
                                      selected ? 1.5 : 1,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor:
                                    Get.theme.colorScheme
                                        .primary,
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            );
                          }),
                          title: Text("Profile", style: style),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }
}