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
//       fontWeight: FontWeight.w800,
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
import 'package:housing_flutter_app/modules/dashboard/views/dashboard_screen.dart';
import 'package:housing_flutter_app/modules/profile/views/profile_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../app/constants/size_manager.dart';
import '../../../widgets/bar/navigation_bar/navigation_Bar.dart';
import '../../../widgets/drawer/drawer.dart';
import '../../home/views/home_screen.dart';
import '../../saved_property/views/saved_property_screen.dart';
import '../../seller/module/lead_screen/views/lead_screen.dart';

import '../../seller/module/lead_screen/views/lead_screen_enhanced.dart';
import '../../seller/module/package_screen/views/package_screen.dart';
import '../../seller/module/seller_home_screen/views/seller_home_screen.dart';
import '../../seller/seller_listing/view/seller_listing_view.dart';

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.put(NavigationController());

    TextStyle style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w800,
      color: Get.theme.colorScheme.primary,
    );
    double iconSize = 20;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      drawer: NesticoPeDrawer(),

      // bottomNavigationBar: SafeArea(
      //   child: Obx(
      //     () => Card(
      //       elevation: 8,
      //       shadowColor: Get.theme.shadowColor.withOpacity(0.3),
      //       color: Get.theme.colorScheme.surface,
      //       margin: const EdgeInsets.only(
      //         left: AppMargin.small,
      //         // bottom: AppMargin.small,
      //         right: AppMargin.small,
      //       ),
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(AppRadius.large),
      //       ),
      //       child: Container(
      //         height: kToolbarHeight + 5,
      //         alignment: Alignment.center,
      //         child: SalomonBottomBar(
      //           duration: const Duration(milliseconds: 400),
      //           unselectedItemColor: Get.theme.colorScheme.onSurface
      //               .withOpacity(0.6),
      //           margin: const EdgeInsets.all(AppPadding.small),
      //           itemShape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(AppRadius.large),
      //           ),
      //           itemPadding: const EdgeInsets.symmetric(
      //             horizontal: AppPadding.small,
      //             vertical: AppPadding.small,
      //           ),
      //           currentIndex: navigationController.currentIndex.value,
      //           onTap: (i) => navigationController.changeIndex(i),
      //           items: [
      //             SalomonBottomBarItem(
      //               icon: Icon(Icons.home, size: iconSize),
      //               title: Text("Home", style: style),
      //             ),
      //
      //             SalomonBottomBarItem(
      //               icon: Icon(Icons.broken_image_outlined, size: iconSize),
      //               title: Text("Enquiries", style: style),
      //             ),
      //
      //             /// 🔥 Middle Highlighted Item
      //             SalomonBottomBarItem(
      //               icon: Container(
      //                 // padding: const EdgeInsets.all(10),
      //                 decoration: BoxDecoration(
      //                   shape: BoxShape.circle,
      //                   color: Get.theme.colorScheme.primary,
      //                   border: Border.all(
      //                     color: Get.theme.colorScheme.primary,
      //                     width: 2,
      //                   ),
      //                 ),
      //                 child: Center(
      //                   child: Icon(
      //                     FontAwesomeIcons.add,
      //                     size: iconSize,
      //                     color: Colors.white,
      //                   ),
      //                 ),
      //               ),
      //               title: Text("Listings", style: style),
      //             ),
      //
      //             SalomonBottomBarItem(
      //               icon: Icon(Icons.subscriptions, size: iconSize),
      //               title: Text("Packages", style: style),
      //             ),
      //
      //             SalomonBottomBarItem(
      //               icon: Icon(FontAwesomeIcons.user, size: iconSize),
      //               title: Text("Profiles", style: style),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      // bottomNavigationBar: SafeArea(
      //   child: Obx(
      //     () => BottomNavigationBar(
      //       type: BottomNavigationBarType.fixed,
      //       currentIndex: navigationController.currentIndex.value,
      //       onTap: (i) => navigationController.changeIndex(i),
      //       items: const [
      //         BottomNavigationBarItem(
      //           icon: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [Icon(Icons.home), Text('Home')],
      //           ),
      //           label: '',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [Icon(Icons.search), Text('Search')],
      //           ),
      //           label: '',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [Icon(Icons.add), Text('Add')],
      //           ),
      //           label: '',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [Icon(Icons.notifications), Text('Alerts')],
      //           ),
      //           label: '',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [Icon(Icons.person), Text('Profile')],
      //           ),
      //           label: '',
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      bottomNavigationBar: SafeArea(
        child: Obx(
          () => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
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
              unselectedItemColor: Colors.grey,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedLabelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),

              unselectedLabelStyle: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
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
            return const SellerHomeScreen();
          case 1:
            return LeadScreen();
          // return Center(
          //   child: ElevatedButton(
          //     onPressed: () {
          //       Get.offAll(() => DashboardScreen());
          //     },
          //     child: const Text("seller"),
          //   ),
          // );
          case 2:
            return SellerListingView();
          case 3:
            return SubscriptionPlansScreen();
          case 4:
            return ProfileScreen(imageUrl: "");
          default:
            return const SizedBox();
        }
      }),
    );
  }
}
