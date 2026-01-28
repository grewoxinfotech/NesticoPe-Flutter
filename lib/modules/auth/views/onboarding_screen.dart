// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/data/network/auth/model/user_model.dart';
// import 'package:housing_flutter_app/modules/auth/views/register_screen.dart';
//
// import '../../../data/database/secure_storage_service.dart';
// import '../../dashboard/views/dashboard_screen.dart';
// import '../../home/views/select_city_screen/select_city_screen.dart';
// import '../../propert_detail/view/property_details.dart';
// import '../../saved_property/controllers/property_favorite_controller.dart';
//
// // Controller for managing state
// class OnboardingController extends GetxController {
//   var selectedOption = ''.obs;
//
//   void selectOption(String option) {
//     selectedOption.value = option;
//
//     // Perform different operations based on selection
//     switch (option) {
//       case 'Buy Home':
//         handleBuyHome();
//         break;
//       case 'Rent Home':
//         handleRentHome();
//         break;
//       case 'Seller Registration':
//         handleSellerRegistration();
//         break;
//       case 'Reseller Registration':
//         handleResellerRegistration();
//         break;
//       case 'Contractor Registration':
//         handleContractorRegistration();
//         break;
//     }
//   }
//
//   Future<void> handleBuyHome() async {
//     print('Navigating to Buy Home screen');
//     final city = await Get.to(() => SelectCityScreen());
//     if (city != null) {
//       // Get.lazyPut(() => PropertyFavoriteController());
//       // Get.to(
//       //   () => PropertyDetail(
//       //     isFromSeeAll: true,
//       //     filters: [
//       //       {'city': city},
//       //       {'listingType': 'Sell'},
//       //     ],
//       //   ),
//       // );
//       await SecureStorage.saveSelectedCity(city);
//       Get.offAll(
//         () => DashboardScreen(
//           propertyFilter: [
//             {'city': city},
//             {'listingType': 'Sell'},
//           ],
//         ),
//       );
//     }
//   }
//
//   Future<void> handleRentHome() async {
//     print('Navigating to Rent Home screen');
//     final city = await Get.to(() => SelectCityScreen());
//     if (city != null) {
//       await SecureStorage.saveSelectedCity(city);
//       Get.offAll(
//         () => DashboardScreen(
//           propertyFilter: [
//             {'city': city},
//             {'listingType': 'Rent'},
//           ],
//         ),
//       );
//     }
//   }
//
//   void handleSellerRegistration() {
//     print('Navigating to Seller Registration screen');
//
//     Get.to(() => RegisterScreen(role: UserRole.seller));
//   }
//
//   void handleResellerRegistration() {
//     print('Navigating to Reseller Registration screen');
//
//     Get.to(() => RegisterScreen(role: UserRole.reseller));
//   }
//
//   void handleContractorRegistration() {
//     print('Navigating to Contractor Registration screen');
//
//     Get.to(() => RegisterScreen(role: UserRole.contractor));
//   }
// }
//
// class OnboardingScreen extends StatelessWidget {
//   const OnboardingScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final OnboardingController controller = Get.put(OnboardingController());
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'What are you\nlooking for?',
//               style: TextStyle(
//                 fontSize: 32,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//                 height: 1.2,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Choose an option to customize your\nexperience.',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//                 height: 1.5,
//               ),
//             ),
//             SizedBox(height: 32),
//             _buildOptionTile(
//               controller: controller,
//               icon: Icons.home,
//               iconColor: ColorRes.primary,
//               iconBgColor: ColorRes.primary.withOpacity(0.05),
//               title: 'Buy Home',
//               subtitle: 'Find your forever property',
//             ),
//             SizedBox(height: 16),
//             _buildOptionTile(
//               controller: controller,
//               icon: Icons.key,
//               iconColor: ColorRes.primary,
//               iconBgColor: ColorRes.primary.withOpacity(0.05),
//               title: 'Rent Home',
//               subtitle: 'Explore monthly rentals',
//             ),
//             SizedBox(height: 16),
//             _buildOptionTile(
//               controller: controller,
//               icon: Icons.sell,
//               iconColor: ColorRes.primary,
//               iconBgColor: ColorRes.primary.withOpacity(0.05),
//               title: 'Seller Registration',
//               subtitle: 'List and sell your property',
//             ),
//             SizedBox(height: 16),
//             _buildOptionTile(
//               controller: controller,
//               icon: Icons.store,
//               iconColor: ColorRes.primary,
//               iconBgColor: ColorRes.primary.withOpacity(0.05),
//               title: 'Reseller Registration',
//               subtitle: 'Join our partners program',
//             ),
//             SizedBox(height: 16),
//             _buildOptionTile(
//               controller: controller,
//               icon: Icons.construction,
//               iconColor: ColorRes.primary,
//               iconBgColor: ColorRes.primary.withOpacity(0.05),
//               title: 'Contractor Registration',
//               subtitle: 'Provide renovation services',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOptionTile({
//     required OnboardingController controller,
//     required IconData icon,
//     required Color iconColor,
//     required Color iconBgColor,
//     required String title,
//     required String subtitle,
//   }) {
//     return Obx(
//       () => InkWell(
//         onTap: () => controller.selectOption(title),
//         borderRadius: BorderRadius.circular(12),
//         child: Container(
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color:
//                 controller.selectedOption.value == title
//                     ? Colors.blue[50]
//                     : Colors.grey[50],
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color:
//                   controller.selectedOption.value == title
//                       ? ColorRes.primary
//                       : Colors.transparent,
//               width: 2,
//             ),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: iconBgColor,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(icon, color: iconColor, size: 24),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       subtitle,
//                       style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/data/network/auth/model/user_model.dart';
import 'package:housing_flutter_app/modules/auth/views/register_screen.dart';

import '../../../data/database/secure_storage_service.dart';
import '../../../widgets/location_permission/location_permission_method.dart';
import '../../dashboard/views/dashboard_screen.dart';
import '../../history/controller/search_history_controller.dart';
import '../../home/views/select_city_screen/select_city_screen.dart';

// Controller for managing state
class OnboardingController extends GetxController {
  var selectedOption = ''.obs;
  final searchHistoryController = Get.put(SearchHistoryController());
  var isProcessing = false.obs; // ✅ Prevent double-taps

  void selectOption(String option) async {
    if (isProcessing.value) return; // ✅ Prevent concurrent navigation

    selectedOption.value = option;
    isProcessing.value = true;

    try {
      // Perform different operations based on selection
      switch (option) {
        case 'Buy Home':
          await handleBuyHome();
          break;
        case 'Rent Home':
          await handleRentHome();
          break;
        case 'Seller Registration':
          handleSellerRegistration();
          break;
        case 'Reseller Registration':
          handleResellerRegistration();
          break;
        case 'Contractor Registration':
          handleContractorRegistration();
          break;
      }
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> handleBuyHome() async {
    print('Navigating to Buy Home screen');

    String? cityLocation = await getCurrentCity();

    if (cityLocation != null) {
      print("✅ You are currently in: $cityLocation");
    } else {
      print("❌ Unable to get city name");
    }

    if ((cityLocation == null)) {
      // ✅ Get city selection
      final city = await Get.to(
        () => SelectCityScreen(
          isFromLogin: true,
          title: 'Find or Buy Property in Your Location',
        ),
      );

      if (city != null) {
        // ✅ Save city and mark onboarding complete
        log("city login chage $city");
        await searchHistoryController.addSearchHistory({
          'keywords': ['$city'],
        });
        await SecureStorage.saveSelectedCity(city);
        await SecureStorage.setAppLaunched(); // ✅ Mark as not first time

        // ✅ Navigate to dashboard with filters
        await Get.offAll(
          () => DashboardScreen(
            propertyFilter: [
              {'city': city},
              {'listingType': 'Sell'},
            ],
          ),
        );
      } else {
        // User cancelled city selection - stay on onboarding
        selectedOption.value = '';
      }
    } else {
      await SecureStorage.saveSelectedCity(cityLocation ?? '');
      await SecureStorage.setAppLaunched(); // ✅ Mark as not first time

      // ✅ Navigate to dashboard with filters
      await Get.offAll(
        () => DashboardScreen(
          propertyFilter: [
            {'city': cityLocation ?? ''},
            {'listingType': 'Sell'},
          ],
        ),
      );
    }
  }

  Future<void> handleRentHome() async {
    print('Navigating to Rent Home screen');

    final cityLocation = await getCurrentCity();

    if (cityLocation != null) {
      log("permission for location ${cityLocation}");
    }

    if (cityLocation == null) {
      // ✅ Get city selection
      final city = await Get.to(
        () => SelectCityScreen(
          isFromLogin: true,
          title: 'Find or Rent Property in Your Location',
        ),
      );

      if (city != null) {
        // ✅ Save city and mark onboarding complete
        await searchHistoryController.addSearchHistory({
          'keywords': ["$city"],
        });
        await SecureStorage.saveSelectedCity(city);
        await SecureStorage.setAppLaunched(); // ✅ Mark as not first time

        // ✅ Navigate to dashboard with filters
        await Get.offAll(
          () => DashboardScreen(
            propertyFilter: [
              {'city': city},
              {'listingType': 'Rent'},
            ],
          ),
        );
      } else {
        // User cancelled city selection - stay on onboarding
        selectedOption.value = '';
      }
    }
    else{
      await SecureStorage.saveSelectedCity(cityLocation ?? '');
      await SecureStorage.setAppLaunched(); // ✅ Mark as not first time

      // ✅ Navigate to dashboard with filters
      await Get.offAll(
            () => DashboardScreen(
          propertyFilter: [
            {'city': cityLocation ?? ''},
            {'listingType': 'Sell'},
          ],
        ),
      );
    }
  }

  void handleSellerRegistration() async {
    print('Navigating to Seller Registration screen');

    // ✅ Mark onboarding complete before registration
    await SecureStorage.setAppLaunched();

    // ✅ Use Get.off (not Get.to) to replace onboarding screen
    await Get.to(() => RegisterScreen(role: UserRole.seller));
  }

  void handleResellerRegistration() async {
    print('Navigating to Reseller Registration screen');

    // ✅ Mark onboarding complete before registration
    await SecureStorage.setAppLaunched();

    // ✅ Use Get.off (not Get.to) to replace onboarding screen
    await Get.to(() => RegisterScreen(role: UserRole.reseller));
  }

  void handleContractorRegistration() async {
    print('Navigating to Contractor Registration screen');

    // ✅ Mark onboarding complete before registration
    await SecureStorage.setAppLaunched();

    // ✅ Use Get.off (not Get.to) to replace onboarding screen
    await Get.to(() => RegisterScreen(role: UserRole.contractor));
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingController controller = Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading:
            false, // ✅ Remove back button on first launch
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What are you\nlooking for?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Choose an option to customize your\nexperience.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              SizedBox(height: 32),
              _buildOptionTile(
                controller: controller,
                icon: Icons.home,
                iconColor: ColorRes.primary,
                iconBgColor: ColorRes.primary.withOpacity(0.05),
                title: 'Buy Home',
                subtitle: 'Find your forever property',
              ),
              SizedBox(height: 16),
              _buildOptionTile(
                controller: controller,
                icon: Icons.key,
                iconColor: ColorRes.primary,
                iconBgColor: ColorRes.primary.withOpacity(0.05),
                title: 'Rent Home',
                subtitle: 'Explore monthly rentals',
              ),
              SizedBox(height: 16),
              _buildOptionTile(
                controller: controller,
                icon: Icons.sell,
                iconColor: ColorRes.primary,
                iconBgColor: ColorRes.primary.withOpacity(0.05),
                title: 'Seller Registration',
                subtitle: 'List and sell your property',
              ),
              SizedBox(height: 16),
              _buildOptionTile(
                controller: controller,
                icon: Icons.store,
                iconColor: ColorRes.primary,
                iconBgColor: ColorRes.primary.withOpacity(0.05),
                title: 'Partner Registration',
                subtitle: 'Join our partners program',
              ),
              SizedBox(height: 16),
              _buildOptionTile(
                controller: controller,
                icon: Icons.construction,
                iconColor: ColorRes.primary,
                iconBgColor: ColorRes.primary.withOpacity(0.05),
                title: 'Contractor Registration',
                subtitle: 'Provide renovation services',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required OnboardingController controller,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
  }) {
    return Obx(
      () => IgnorePointer(
        ignoring: controller.isProcessing.value,
        // ✅ Disable during processing
        child: Opacity(
          opacity: controller.isProcessing.value ? 0.6 : 1.0,
          child: InkWell(
            onTap: () => controller.selectOption(title),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    controller.selectedOption.value == title
                        ? Colors.blue[50]
                        : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      controller.selectedOption.value == title
                          ? ColorRes.primary
                          : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (controller.isProcessing.value &&
                      controller.selectedOption.value == title)
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: ColorRes.primary,
                      ),
                    )
                  else
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
