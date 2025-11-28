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
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/modules/dashboard/views/dashboard_screen.dart';
import 'package:housing_flutter_app/modules/profile/views/profile_screen.dart';
import 'package:housing_flutter_app/modules/seller/module/seller_home_screen/views/property_overview_screen.dart';
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
import '../../seller/module/lead_screen/views/lead_screen.dart';

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

  @override
  void initState() {
    loadPropertyBySeller();
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

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.put(NavigationController());

    TextStyle style = TextStyle(
      fontSize: AppFontSizes.small,
      fontWeight: AppFontWeights.extraBold,
      color: Get.theme.colorScheme.primary,
    );
    double iconSize = 20;

    return Scaffold(
      backgroundColor: ColorRes.white,
      extendBody: true,

      // drawer: NesticoPeDrawer(),
      bottomNavigationBar: SafeArea(
        child: Obx(
          () => Container(
            decoration: BoxDecoration(
              color: ColorRes.white,
              boxShadow: [
                BoxShadow(
                  color: ColorRes.blackShade12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: BottomNavigationBar(
              elevation: 5,

              type: BottomNavigationBarType.fixed,
              currentIndex: navigationController.currentIndex.value,
              onTap: (i) => navigationController.changeIndex(i),
              selectedItemColor: Get.theme.colorScheme.primary,
              unselectedItemColor: ColorRes.leadGreyColor,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedLabelStyle: TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.semiBold,
              ),

              unselectedLabelStyle: TextStyle(
                fontSize: AppFontSizes.extraSmall,
                fontWeight: AppFontWeights.regular,
              ),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.leaderboard_outlined,
                  ), // optional better icon for leads
                  label: 'Leads',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt),
                  label: 'Listing',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.card_membership),
                  label: 'Plans',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_2_outlined),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),

      body: Obx(() {
        switch (navigationController.currentIndex.value) {
          case 0:
            return SellerHomeScreen();
          case 1:
            return SellerLeadScreen();
          // return Center(
          //   child: ElevatedButton(
          //     onPressed: () {
          //       Get.offAll(() => DashboardScreen());
          //     },
          //     child: const Text("seller"),
          //   ),
          // );
          case 2:
            return Obx(() {
              if (controller.isLoading.value && controller.items.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!controller.isLoading.value && controller.items.isEmpty) {
                return const Center(child: Text("No Property found."));
              }

              return PropertyOverviewScreen(properties: controller.items);
            });
          // return SellerListingView();
          case 3:
            return SubscriptionPlansScreen();
          case 4:
            return SellerProfileScreen();
          default:
            return const SizedBox();
        }
      }),
    );
  }
}
