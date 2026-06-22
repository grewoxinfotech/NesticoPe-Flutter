import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/modules/contractor/view/lead/contractor_lead_screen.dart';

import 'package:nesticope_app/modules/contractor/view/profile/contractot_profile.dart';
import 'package:nesticope_app/modules/contractor/view/project/contractor_project.dart';
import 'package:nesticope_app/modules/contractor/view/widget/contractor_inquiry_screen.dart';
import 'package:nesticope_app/modules/profile/controllers/buyer_profiledata.dart';

import '../../../app/constants/app_font_sizes.dart';

import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../controller/contractor_navigate_controller.dart';
import '../controller/contractor_dashboard_controller.dart';
import 'dashboard/contractor_dashboard.dart';

class ContractorMainScreen extends StatefulWidget {
  const ContractorMainScreen({Key? key}) : super(key: key);

  @override
  State<ContractorMainScreen> createState() => _ContractorMainScreenState();
}

class _ContractorMainScreenState extends State<ContractorMainScreen> {
  final navigationController = Get.put(ContractorNavigationController());
  final dashboardController = Get.put(ContractorDashboardController());

  late final BuyerProfileDataController profile;
  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    dashboardController.fetchActiveSubscription(showDialogWhenMissing: false);

    // ✅ Proper controller init
    if (!Get.isRegistered<BuyerProfileDataController>()) {
      profile = Get.put(BuyerProfileDataController());
    } else {
      profile = Get.find<BuyerProfileDataController>();
    }
    screens = [
      ContractorDashboard(),

      ContractorInquiryScreen(),
      ContractorLeadScreen(),
      ContractorProjectScreen(),

      ContractorProfileScreen(),
    ];
  }

  @override
  // Widget build(BuildContext context) {
  //   double iconSize = 18;
  //   return Scaffold(
  //     body: Obx(
  //       () => IndexedStack(
  //         index: navigationController.currentIndex.value,
  //         children: screens,
  //       ),
  //     ),
  //     bottomNavigationBar: Obx(() {
  //       final TextStyle style = TextStyle(
  //         fontSize: AppFontSizes.small,
  //         fontWeight: AppFontWeights.extraBold,
  //         color: Get.theme.colorScheme.primary,
  //       );
  //       return SafeArea(
  //         child: Card(
  //           elevation: 5,
  //           shadowColor: Get.theme.colorScheme.surface,
  //           color: Get.theme.colorScheme.surface,
  //           margin: const EdgeInsets.only(
  //             left: AppMargin.small,
  //             bottom: AppMargin.small,
  //             right: AppMargin.small,
  //           ),
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(AppRadius.large),
  //           ),
  //           child: Container(
  //             height: kToolbarHeight,
  //             alignment: Alignment.center,
  //             child: SalomonBottomBar(
  //               duration: const Duration(milliseconds: 400),
  //               unselectedItemColor: Get.theme.colorScheme.onSurface
  //                   .withOpacity(0.7),
  //               margin: const EdgeInsets.all(AppPadding.small),
  //               itemShape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(AppRadius.large),
  //               ),
  //               itemPadding: const EdgeInsets.all(AppPadding.small),
  //               currentIndex: navigationController.currentIndex.value,
  //               onTap: (i) => navigationController.changeTabIndex(i),
  //               items: [
  //                 SalomonBottomBarItem(
  //                   icon: Icon(Icons.dashboard_outlined, size: iconSize * 1.2),
  //                   title: Text('Dashboard', style: style),
  //                 ),
  //                 SalomonBottomBarItem(
  //                   icon: Icon(
  //                     Icons.location_city_outlined,
  //                     size: iconSize * 1.2,
  //                   ),
  //                   title: Text('Project', style: style),
  //                 ),
  //                 SalomonBottomBarItem(
  //                   icon: Icon(Icons.groups_outlined, size: iconSize * 1.2),
  //                   title: Text('Leads', style: style),
  //                 ),
  //                 SalomonBottomBarItem(
  //                   icon: Icon(
  //                     Icons.support_agent_outlined,
  //                     size: iconSize * 1.2,
  //                   ),
  //                   title: Text('Inquiry', style: style),
  //                 ),
  //                 SalomonBottomBarItem(
  //                   icon: Obx(() {
  //                     final selected =
  //                         navigationController.currentIndex.value == 4;
  //                     final imageUrl =
  //                         profile.userProfile.value?.profilePic ?? '';
  //                     return Container(
  //                   width: 28,
  //                   height: 28,
  //                   decoration: BoxDecoration(
  //                     shape: BoxShape.circle,
  //                     border: Border.all(
  //                       color:
  //                           selected
  //                               ? Get.theme.colorScheme.primary
  //                               : Get.theme.colorScheme.onSurface.withOpacity(
  //                                 0.4,
  //                               ),
  //                       width: selected ? 1.5 : 1,
  //                     ),
  //                   ),
  //                   child: CircleAvatar(
  //                     radius: 14,
  //                     backgroundColor: Get.theme.colorScheme.primary,
  //                     child: ClipOval(
  //                       child: Icon(
  //                         Icons.person,
  //                         color: Colors.white,
  //                         size: 16,
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //                   }),
  //                   title: Text("Profile", style: style),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     }),
  //   );
  // }
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
          body: IndexedStack(index: index, children: screens),

          /// ✅ Bottom Navigation (same UI as seller)
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
                    borderRadius: BorderRadius.circular(AppRadius.large),
                  ),
                  child: Container(
                    height: kToolbarHeight,
                    alignment: Alignment.center,
                    child: SalomonBottomBar(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.all(AppPadding.small),
                      itemPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      itemShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.large),
                      ),
                      currentIndex: index,
                      onTap: (tabIndex) async {
                        final bool restrictedTab =
                            tabIndex != 0 && tabIndex != 4;
                        final bool hasActivePlan =
                            dashboardController.activeSubscription.value !=
                            null;

                        if (restrictedTab && !hasActivePlan) {
                          await dashboardController.showUpgradePlanDialog(
                            title: 'Active plan required',
                            message:
                                'Please activate or upgrade your subscription to access this section.',
                          );
                          return;
                        }

                        navigationController.changeTabIndex(tabIndex);
                      },
                      unselectedItemColor: Get.theme.colorScheme.onSurface
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

                        /// ✅ Project

                        /// ✅ Inquiry
                        SalomonBottomBarItem(
                          icon: Obx(() {
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Icon(
                                  Icons.groups_outlined,
                                  size: iconSize * 1.2,
                                ),

                                if (dashboardController.showRedDot.value)
                                  Positioned(
                                    top: -2,
                                    right: -2,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }),

                          title: Text("Enquiry", style: style),
                        ),

                        /// ✅ Leads
                        SalomonBottomBarItem(
                          icon: Icon(
                            Icons.groups_outlined,
                            size: iconSize * 1.2,
                          ),
                          title: Text("Leads", style: style),
                        ),
                        SalomonBottomBarItem(
                          icon: Icon(
                            Icons.location_city_outlined,
                            size: iconSize * 1.2,
                          ),
                          title: Text("Project", style: style),
                        ),

                        /// ✅ Profile
                        SalomonBottomBarItem(
                          icon: Obx(() {
                            final selected =
                                navigationController.currentIndex.value == 4;

                            return Container(
                              height: 26,
                              width: 26,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      selected
                                          ? Get.theme.colorScheme.primary
                                          : Colors.grey.shade400,
                                  width: selected ? 1.5 : 1,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Get.theme.colorScheme.primary,
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
