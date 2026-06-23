// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
//
// import '../../../app/constants/size_manager.dart';
// import '../../../widgets/bar/navigation_bar/navigation_Bar.dart';
// import '../../../widgets/drawer/drawer.dart';
// import '../../home/views/home_screen.dart';
// import '../../saved_property/views/saved_property_screen.dart';
// import '../../seller/seller_listing/view/seller_listing_view.dart';
//
// class SellerDashboardScreen extends StatelessWidget {
//   const SellerDashboardScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final navigationController = Get.put(NavigationController());
//     TextStyle style = TextStyle(
//       fontSize: 12,
//       fontWeight: AppFontWeights.extraBold,
//       color: Get.theme.colorScheme.primary,
//     );
//     double iconSize = 18;
//     return Scaffold(
//       extendBody: true,
//       drawer: NesticoPeDrawer(),
//       bottomNavigationBar: SafeArea(
//         child: Obx(
//           () => Card(
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
//                 onTap: (i) => navigationController.changeIndex(i),
//                 items: [
//                   SalomonBottomBarItem(
//                     icon: Icon(Icons.home, size: iconSize),
//                     title: Text("Home", style: style),
//                   ),
//
//                   SalomonBottomBarItem(
//                     icon: Icon(Icons.explore, size: iconSize),
//                     title: Text("Explore", style: style),
//                   ),
//
//                   SalomonBottomBarItem(
//                     icon: Icon(FontAwesomeIcons.heart, size: iconSize),
//                     title: Text("Wishlist", style: style),
//                   ),
//
//                   SalomonBottomBarItem(
//                     icon: Icon(FontAwesomeIcons.message, size: iconSize),
//                     title: Text("Message", style: style),
//                   ),
//
//                   SalomonBottomBarItem(
//                     icon: Icon(FontAwesomeIcons.user, size: iconSize),
//                     title: Text("Profile", style: style),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Obx(() {
//         if (navigationController.currentIndex.value == 0) {
//           return const HomeScreen();
//         } else if (navigationController.currentIndex.value == 1) {
//           return Center(
//             child: ElevatedButton(
//               onPressed: () {
//                 Get.to(SellerDashboardScreen());
//               },
//               child: Text("seller"),
//             ),
//           );
//         } else if (navigationController.currentIndex.value == 2) {
//           return SellerListingView();
//         } else if (navigationController.currentIndex.value == 3) {
//           return const Center(child: Text("No Update"));
//         } else if (navigationController.currentIndex.value == 4) {
//           return const SavedPropertyScreen();
//         } else if (navigationController.currentIndex.value == 5) {
//           return const SavedPropertyScreen();
//         } else {
//           return const SizedBox();
//         }
//       }),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/modules/dashboard/views/dashboard_screen.dart';
import 'package:nesticope_app/modules/dashboard/views/widget/seller_property_screen.dart';
import 'package:nesticope_app/modules/profile/controllers/seller_profile_controller.dart';
import 'package:nesticope_app/modules/profile/views/profile_screen.dart';
import 'package:nesticope_app/modules/seller/controllers/seller_overview_controller.dart';
import 'package:nesticope_app/modules/seller/module/seller_home_screen/views/property_overview_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../app/constants/color_res.dart';
import '../../../app/constants/size_manager.dart';
import '../../../data/database/secure_storage_service.dart';
import '../../../widgets/bar/navigation_bar/navigation_Bar.dart';
import '../../../widgets/drawer/drawer.dart';
import '../../home/views/home_screen/home_screen.dart';
import '../../profile/views/seller_profile_detail.dart';
import '../../property/controllers/property_controller.dart';
import '../../saved_property/views/saved_property_screen.dart';

import '../../seller/module/lead_screen/views/lead_screen_enhanced.dart';
import '../../seller/module/package_screen/views/package_screen.dart';
import '../../seller/module/seller_home_screen/views/seller_home_screen.dart';
import '../../seller/seller_listing/view/seller_listing_view.dart';

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  final controller = Get.put(PropertyController());
  final navigationController = Get.put(NavigationController());
  final profileController = Get.put(SellerProfileController());

  final sellerOverviewController = Get.put(
    SellerOverviewController(),
    permanent: true,
  );
  late final List<Widget> screens;

  @override
  void initState() {
    loadPropertyBySeller();
    screens = [
      const SellerHomeScreen(),
      const SellerLeadScreen(isViewAll: true),
      PropertyOverviewScreen(),
      SellerSubscriptionPlanScreen(),
      SellerProfileScreen(),
    ];
    super.initState();
  }

  Future<void> loadPropertyBySeller() async {
    final user = await SecureStorage.getUserData();
    if (user != null) {
      controller.applyFilter(
        "created_by",
        user.user?.id.toString() ?? "",
        includeCity: false,
      );
    }
  }

  Future<void> refreshPropertyBySeller() async {
    final user = await SecureStorage.getUserData();
    if (user != null) {
      controller.applyFilter(
        "created_by",
        user.user?.id.toString() ?? "",
        includeCity: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final index = navigationController.currentIndex.value;
      return PopScope(
        canPop: index == 0,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            // 👉 Not on home → go to home
            navigationController.changeIndex(0);
          }
        },
        child: Scaffold(
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
                      onTap: (index) async {
                        if (index == 1) {
                          if (UserHelper.isSellerOwner) {
                            await SecureStorage.saveSellerLeadCount(
                              sellerOverviewController
                                      .overviewData
                                      .value
                                      ?.data
                                      ?.leadAnalytics
                                      ?.totalLeads ??
                                  0,
                            );
                          } else if (UserHelper.isSellerBuilder) {
                            await SecureStorage.saveBuilderLeadCount(
                              sellerOverviewController
                                      .overviewData
                                      .value
                                      ?.data
                                      ?.leadAnalytics
                                      ?.totalLeads ??
                                  0,
                            );
                          }
                          setState(() {});
                        }
                        navigationController.changeIndex(index);
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

                        /// ✅ Leads
                        SalomonBottomBarItem(
                          icon: Obx(() {
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Icon(
                                  Icons.groups_outlined,
                                  size: iconSize * 1.2,
                                ),

                                if (sellerOverviewController.showRedDot.value)
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

                          title: Text("Leads", style: style),
                        ),

                        /// ✅ Property
                        SalomonBottomBarItem(
                          icon: Icon(
                            Icons.apartment_outlined,
                            size: iconSize * 1.2,
                          ),
                          title: Text("Property", style: style),
                        ),

                        /// ✅ Plans
                        SalomonBottomBarItem(
                          icon: Icon(Icons.credit_card, size: iconSize * 1.2),
                          title: Text("Plans", style: style),
                        ),

                        /// ✅ Profile Avatar
                        SalomonBottomBarItem(
                          icon: Obx(() {
                            final selected =
                                navigationController.currentIndex.value == 4;

                            final imageUrl =
                                profileController
                                    .profileData
                                    .value
                                    ?.user
                                    ?.profilePic ??
                                "";

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

          body: IndexedStack(index: index, children: screens),
        ),
      );
    });
  }
}
