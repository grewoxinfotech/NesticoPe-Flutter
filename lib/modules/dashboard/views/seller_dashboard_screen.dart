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
    final navigationController = Get.put(NavigationController());

    final screens = [
      const SellerHomeScreen(),
      const SellerLeadScreen(),
      Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.isLoading.value && controller.items.isEmpty) {
          return const Center(child: Text("No Property found."));
        }

        return NotificationListener<ScrollEndNotification>(
          onNotification: (notification) {
            final metrics = notification.metrics;
            if (metrics.pixels >= metrics.maxScrollExtent) {
              controller.loadMore();
            }
            return true;
          },
          child: RefreshIndicator(
            onRefresh: refreshPropertyBySeller,
            child: PropertyOverviewScreen(
              properties: controller.items,
              onDelete: () => refreshPropertyBySeller(),
            ),
          ),
        );
      }),
      SellerSubscriptionPlanScreen(),
      SellerProfileScreen(),
    ];

    return Scaffold(

      bottomNavigationBar: Obx(
            () => SafeArea(
          child: BottomNavigationBar(
            currentIndex: navigationController.currentIndex.value,
            onTap: navigationController.changeIndex,
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
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.dashboard, size: 22),
                ),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.people, size: 22),
                ),
                label: 'Leads',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.list_alt_outlined, size: 22),
                ),
                label: 'Property',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.card_giftcard_outlined, size: 22),
                ),
                label: 'Plans',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.person, size: 22),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),

      body: Obx(
            () => IndexedStack(
          index: navigationController.currentIndex.value,
          children: screens,
        ),
      ),
    );
  }
}
