// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/app/constants/color_res.dart';
// import 'package:nesticope_app/data/network/auth/model/user_model.dart';
// import 'package:nesticope_app/modules/auth/views/register_screen.dart';
//
// import '../../../data/database/secure_storage_service.dart';
// import 'package:nesticope_app/app/services/truecaller_service.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/services/truecaller_service.dart';
import 'package:nesticope_app/services/notification_service.dart' as notif;
import 'package:nesticope_app/data/network/user/service/notification_sync_service.dart';
import 'package:nesticope_app/modules/auth/controllers/auth_controller.dart';
import '../../dashboard/views/dashboard_screen.dart';
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
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/data/network/auth/model/user_model.dart';
import 'package:nesticope_app/modules/auth/views/register_screen.dart';
import 'package:nesticope_app/data/network/auth/service/auth_service.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';

import '../../../data/database/secure_storage_service.dart';
import '../../../widgets/location_permission/location_permission_method.dart';
import '../../dashboard/views/dashboard_screen.dart';
import '../../history/controller/search_history_controller.dart';
import '../../home/views/select_city_screen/select_city_screen.dart';

// Controller for managing state
class OnboardingController extends GetxController {
  var selectedOption = ''.obs;
  final searchHistoryController = Get.put(SearchHistoryController());
  final truecallerService = TruecallerService();
  var isProcessing = false.obs; // ✅ Prevent double-taps

  @override
  void onInit() {
    super.onInit();
    truecallerService.initialize();
  }

  @override
  void onClose() {
    truecallerService.dispose();
    super.onClose();
  }

  Future<void> _handleTruecallerLogin() async {
    final response = await truecallerService.login();
    if (response != null) {
      log(
        "Truecaller Login Success: ${response.firstName} ${response.lastName}, Phone: ${response.phoneNumber}",
      );
      // Proceed with authentication using Truecaller data
    } else {
      log("Truecaller Login Cancelled or Failed");
    }
  }

  void selectOption(String option) async {
    if (isProcessing.value) return; // ✅ Prevent concurrent navigation

    selectedOption.value = option;
    isProcessing.value = true;

    log("Options of the dashboard $option");

    try {
      // Perform different operations based on selection
      switch (option) {
        case 'Buy Home':
          // await truecallerService.loginWithTrueCaller();
          await handleBuyHome();
          break;
        case 'Rent Home':
          // await truecallerService.loginWithTrueCaller();
          await handleRentHome();
          break;
        case 'Seller Registration':
          handleSellerRegistration();
          break;
        case 'Partner Registration':
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

        await SecureStorage.saveHomeCategory('Buy');
        final loggedIn = await truecallerService.loginWithTrueCaller();
        if (loggedIn) {
          await Get.offAll(
            () => DashboardScreen(
              propertyFilter: [
                {'city': city},
                {'listingType': 'Sell'},
              ],
            ),
          );
        } else {
          await SecureStorage.saveHomeCategory('Buy');
          final proceed = await _showLoginBottomSheet(
            listingType: 'Sell',
            city: city,
          );
          if (proceed) {
            await Get.offAll(
              () => DashboardScreen(
                propertyFilter: [
                  {'city': city},
                  {'listingType': 'Sell'},
                ],
              ),
            );
          }
        }
      } else {
        // User cancelled city selection - stay on onboarding
        selectedOption.value = '';
      }
    } else {
      await SecureStorage.saveSelectedCity(cityLocation ?? '');
      await SecureStorage.saveHomeCategory('Buy');
      await SecureStorage.setAppLaunched(); // ✅ Mark as not first time

      final loggedIn = await truecallerService.loginWithTrueCaller();
      if (loggedIn) {
        await Get.offAll(
          () => DashboardScreen(
            propertyFilter: [
              {'city': cityLocation ?? ''},
              {'listingType': 'Sell'},
            ],
          ),
        );
      } else {
        final proceed = await _showLoginBottomSheet(
          listingType: 'Sell',
          city: cityLocation ?? '',
        );
        if (proceed) {
          await SecureStorage.saveHomeCategory('Buy');
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

        await SecureStorage.saveHomeCategory('Rent/Lease');
        final loggedIn = await truecallerService.loginWithTrueCaller();
        if (loggedIn) {
          await Get.offAll(
            () => DashboardScreen(
              propertyFilter: [
                {'city': city},
                {'listingType': 'Rent'},
              ],
            ),
          );
        } else {
          await SecureStorage.saveHomeCategory('Rent/Lease');
          final proceed = await _showLoginBottomSheet(
            listingType: 'Rent',
            city: city,
          );
          if (proceed) {
            await Get.offAll(
              () => DashboardScreen(
                propertyFilter: [
                  {'city': city},
                  {'listingType': 'Rent'},
                ],
              ),
            );
          }
        }
      } else {
        // User cancelled city selection - stay on onboarding
        selectedOption.value = '';
      }
    } else {
      await SecureStorage.saveSelectedCity(cityLocation ?? '');
      await SecureStorage.saveHomeCategory('Rent/Lease');
      await SecureStorage.setAppLaunched(); // ✅ Mark as not first time

      final loggedIn = await truecallerService.loginWithTrueCaller();
      if (loggedIn) {
        await Get.offAll(
          () => DashboardScreen(
            propertyFilter: [
              {'city': cityLocation ?? ''},
              {'listingType': 'Sell'},
            ],
          ),
        );
      } else {
        final proceed = await _showLoginBottomSheet(
          listingType: 'Sell',
          city: cityLocation ?? '',
        );
        if (proceed) {
          await SecureStorage.saveHomeCategory('Rent/Lease');
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

  Future<bool> _showLoginBottomSheet({
    required String listingType,
    required String city,
  }) async {
    String phone = '';
    bool isPhoneValid = false;
    final List<String> otpDigits = List.filled(4, '');
    bool stepOtp = false;
    bool proceed = false;
    int resendSecondsLeft = 0;
    bool isSendingOtp = false;
    bool isVerifyingOtp = false;
    bool isResendingOtp = false;
    final currentUser = Rxn<UserModel>();
    final authState = AuthState.initial.obs;
    Timer? _resendTimer;
    final formKey = GlobalKey<FormState>();
    bool isSheetOpen = true;
    void _startResendTimer(StateSetter setState) {
      _resendTimer?.cancel();
      resendSecondsLeft = 120;
      if (!isSheetOpen) return;
      setState(() {});
      _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!isSheetOpen) {
          t.cancel();
          return;
        }
        if (resendSecondsLeft <= 1) {
          t.cancel();
          resendSecondsLeft = 0;
          if (isSheetOpen) setState(() {});
        } else {
          resendSecondsLeft -= 1;
          if (isSheetOpen) setState(() {});
        }
      });
    }

    await Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          // return Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          //   decoration: const BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(16),
          //       topRight: Radius.circular(16),
          //     ),
          //   ),
          //   child: SafeArea(
          //     top: false,
          //     child: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       crossAxisAlignment: CrossAxisAlignment.stretch,
          //       children: [
          //         Container(
          //           width: 40,
          //           height: 4,
          //           margin: const EdgeInsets.only(bottom: 12),
          //           decoration: BoxDecoration(
          //             color: Colors.grey.shade300,
          //             borderRadius: BorderRadius.circular(2),
          //           ),
          //         ),
          //         Row(
          //           children: [
          //             const Expanded(
          //               child: Text(
          //                 'Login with NesticoPe',
          //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          //               ),
          //             ),
          //             TextButton(
          //               onPressed: () async {
          //                 await SecureStorage.saveLoginSkipped(true);
          //                 proceed = true;
          //                 Get.back();
          //               },
          //               child: const Text('Skip'),
          //             ),
          //           ],
          //         ),
          //         const SizedBox(height: 8),
          //         if (!stepOtp) ...[
          //           TextField(
          //             keyboardType: TextInputType.phone,
          //             decoration: const InputDecoration(
          //               prefixText: '+91 ',
          //               hintText: 'Enter mobile number',
          //               border: OutlineInputBorder(),
          //             ),
          //             onChanged: (v) => phone = v,
          //           ),
          //           const SizedBox(height: 12),
          //           ElevatedButton(
          //             onPressed: () {
          //               setState(() {
          //                 stepOtp = true;
          //               });
          //             },
          //             child: const Text('Get OTP'),
          //           ),
          //           const SizedBox(height: 8),
          //           Row(
          //             children: [
          //               const Expanded(child: Divider()),
          //               Padding(
          //                 padding: const EdgeInsets.symmetric(horizontal: 8),
          //                 child: Text('OR', style: TextStyle(color: Colors.grey.shade600)),
          //               ),
          //               const Expanded(child: Divider()),
          //             ],
          //           ),
          //           const SizedBox(height: 8),
          //           OutlinedButton(
          //             onPressed: () async {
          //               final ok = await truecallerService.loginWithTrueCaller();
          //               if (ok) {
          //                 proceed = true;
          //                 Get.back();
          //               }
          //             },
          //             child: const Text('Continue with Truecaller'),
          //           ),
          //         ] else ...[
          //           const Text(
          //             'Verify Mobile Number',
          //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          //           ),
          //           const SizedBox(height: 8),
          //           TextField(
          //             keyboardType: TextInputType.number,
          //             decoration: const InputDecoration(
          //               hintText: 'Enter 6-digit OTP',
          //               border: OutlineInputBorder(),
          //             ),
          //             onChanged: (v) => otp = v,
          //           ),
          //           const SizedBox(height: 12),
          //           ElevatedButton(
          //             onPressed: () async {
          //               await SecureStorage.saveLoggedIn(true);
          //               proceed = true;
          //               Get.back();
          //             },
          //             child: const Text('Verify OTP'),
          //           ),
          //           TextButton(
          //             onPressed: () {
          //               setState(() {
          //                 stepOtp = false;
          //               });
          //             },
          //             child: const Text('Change Number'),
          //           ),
          //         ],
          //       ],
          //     ),
          //   ),
          // );
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.,start
                children: [
                  /// Drag Handle
                  Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  /// Title + Skip
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          stepOtp
                              ? "Verify Mobile Number"
                              : "Login with NesticoPe",
                          style: TextStyle(
                            fontSize: 18,
                            color: ColorRes.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (!stepOtp)
                        GestureDetector(
                          onTap: () async {
                            await SecureStorage.saveLoginSkipped(true);
                            proceed = true;
                            _resendTimer?.cancel();
                            Get.back();
                          },
                          child: Text(
                            "Skip",
                            style: TextStyle(
                              color: ColorRes.primary,
                              fontSize: AppFontSizes.bodySmall,
                              fontWeight: AppFontWeights.medium,
                            ),
                          ),
                        ),
                    ],
                  ),

                  /// Subtitle
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      stepOtp
                          ? "Enter the 4-digit OTP sent to +91 $phone"
                          : "Enter your mobile number to continue",

                      style: TextStyle(
                        color: ColorRes.leadGreyColor.shade600,
                        fontSize: AppFontSizes.small,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// STEP 1: PHONE INPUT
                  ///
                  if (!stepOtp) ...[
                    // TextField(
                    //   keyboardType: TextInputType.phone,
                    //   style: TextStyle(
                    //     fontSize: AppFontSizes.small,
                    //     fontWeight: AppFontWeights.medium,
                    //     color: ColorRes.textPrimary
                    //   ),
                    //   decoration: InputDecoration(
                    //     enabledBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12),

                    //       borderSide: BorderSide(
                    //         color: ColorRes.primary,
                    //         width: 1,
                    //       ),
                    //     ),
                    //     disabledBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12),

                    //       borderSide: BorderSide(
                    //         color: ColorRes.leadGreyColor.shade300,
                    //         width: 1,
                    //       ),
                    //     ),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12),

                    //       borderSide: BorderSide(
                    //         color: ColorRes.leadGreyColor.shade300,
                    //         width: 1,
                    //       ),
                    //     ),
                    //     prefixText: "+91  ",
                    //     hintText: "Enter mobile number",
                    //   ),
                    //   onChanged: (v) => phone = v,
                    // ),
                    Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        style: TextStyle(
                          fontSize: AppFontSizes.small,
                          fontWeight: AppFontWeights.medium,
                          color: ColorRes.textPrimary,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone_outlined,

                            color: ColorRes.leadGreyColor.shade600,
                          ),
                          hintText: "Enter mobile number",
                          hintStyle: TextStyle(
                            fontSize: AppFontSizes.small,
                            fontWeight: AppFontWeights.medium,
                            color: ColorRes.leadGreyColor.shade600,
                          ),

                          // DEFAULT BORDER
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: ColorRes.leadGreyColor.shade300,
                              width: 1,
                            ),
                          ),

                          // ENABLED (NORMAL STATE)
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: ColorRes.leadGreyColor.shade300,
                              width: 1,
                            ),
                          ),

                          // 🔥 FOCUSED (WHEN USER TYPES)
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: ColorRes.primary,
                              width: 1.5,
                            ),
                          ),

                          // OPTIONAL: ERROR
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.red, width: 1),
                          ),

                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
                        ),
                        validator: (value) {
                          final v = (value ?? '').trim();
                          if (v.isEmpty) return 'Mobile number is required';
                          if (v.length != 10) {
                            return 'Enter valid 10-digit mobile number';
                          }
                          return null;
                        },
                        onChanged: (v) {
                          phone = v;
                          isPhoneValid =
                              formKey.currentState?.validate() == true;
                          setState(() {});
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Get OTP Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isPhoneValid ? ColorRes.primary : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed:
                            (!isPhoneValid || isSendingOtp)
                                ? null
                                : () async {
                                  final trimmed = phone.trim();
                                  isSendingOtp = true;
                                  setState(() {});
                                  final ok = await AuthService()
                                      .requestOtpLogin(trimmed);
                                  isSendingOtp = false;
                                  if (ok) {
                                    NesticoPeSnackBar.showAwesomeSnackbar(
                                      title: 'OTP Sent',
                                      message:
                                          'Please enter the OTP within 2 minutes',
                                      contentType: ContentType.success,
                                    );
                                    stepOtp = true;
                                    _startResendTimer(setState);
                                  } else {
                                    NesticoPeSnackBar.showAwesomeSnackbar(
                                      title: 'Error',
                                      message: 'Failed to send OTP',
                                      contentType: ContentType.failure,
                                    );
                                  }
                                  setState(() {});
                                },
                        child:
                            isSendingOtp
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text("Get OTP"),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// OR Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "OR",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: AppFontSizes.small,
                              fontWeight: AppFontWeights.medium,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// Truecaller Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            // ✅ THIS controls border color
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final ok =
                              await truecallerService.loginWithTrueCaller();
                          if (ok) {
                            proceed = true;
                            Get.back();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/truecaller_logo.jpg',
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),

                            Text(
                              "Continue with Truecaller",
                              style: TextStyle(
                                color: ColorRes.textPrimary,
                                fontSize: AppFontSizes.bodySmall,
                                fontWeight: AppFontWeights.medium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
                  /// STEP 2: OTP UI
                  else ...[
                    /// OTP Boxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(4, (index) {
                        return Container(
                          width: 45,
                          height: 55,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                            ),
                            onChanged: (v) {
                              otpDigits[index] = v;
                              if (v.isNotEmpty && index < 3) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 20),

                    /// Verify Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed:
                            isVerifyingOtp
                                ? null
                                : () async {
                                  final otp = otpDigits.join();
                                  if (otp.length != 4) {
                                    NesticoPeSnackBar.showAwesomeSnackbar(
                                      title: 'OTP Required',
                                      message: 'Please enter the 4-digit OTP',
                                      contentType: ContentType.warning,
                                    );
                                    return;
                                  }
                                  isVerifyingOtp = true;
                                  setState(() {});
                                  final user = await AuthService()
                                      .verifyLoginOtp(otp.trim());
                                  isVerifyingOtp = false;
                                  if (user != null) {
                                    NesticoPeSnackBar.showAwesomeSnackbar(
                                      title: 'Login Successful',
                                      message:
                                          'You have logged in successfully',
                                      contentType: ContentType.success,
                                    );
                                    await SecureStorage.saveToken(
                                      user.token ?? '',
                                    );
                                    await SecureStorage.saveUserData(user);
                                    await SecureStorage.saveLoggedIn(true);
                                    await SecureStorage.saveTermAndConditionValue(
                                      false.toString(),
                                    );
                                    if (user.user != null) {
                                      await UserHelper.setUserType(
                                        user.user?.userType,
                                        sellerType: user.user?.sellerType,
                                        isAadharVerified:
                                            user.user?.isAadharVerified,
                                      );
                                    }
                                    currentUser.value = user;
                                    authState.value = AuthState.authenticated;
                                    final userId = user.user?.id?.toString();
                                    final role =
                                        UserHelper.userType?.name ?? 'buyer';
                                    if (userId != null && userId.isNotEmpty) {
                                      await notif.NotificationService.instance
                                          .attachLoggedInUser(
                                            userId: userId,
                                            role: role,
                                            syncToBackend: (playerId) async {
                                              await NotificationSyncService
                                                  .instance
                                                  .syncToBackend(
                                                    deviceToken: playerId,
                                                    metadata: {
                                                      'user_id': userId,
                                                      'role': role,
                                                    },
                                                  );
                                            },
                                          );
                                    }
                                    proceed = true;
                                    _resendTimer?.cancel();
                                    Get.back();
                                  } else {
                                    NesticoPeSnackBar.showAwesomeSnackbar(
                                      title: 'Verification Failed',
                                      message:
                                          'There was a problem verifying the OTP',
                                      contentType: ContentType.failure,
                                    );
                                  }
                                  setState(() {});
                                },
                        child:
                            isVerifyingOtp
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text("Verify OTP"),
                      ),
                    ),

                    /// Change Number
                    if (resendSecondsLeft > 0) ...[
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't receive code? ",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Resend OTP in ${resendSecondsLeft}s",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      TextButton(
                        onPressed:
                            isResendingOtp
                                ? null
                                : () async {
                                  isResendingOtp = true;
                                  setState(() {});
                                  final ok =
                                      await AuthService().resendLoginOtp();
                                  isResendingOtp = false;
                                  if (ok) {
                                    NesticoPeSnackBar.showAwesomeSnackbar(
                                      title: 'OTP Resent',
                                      message:
                                          'A new OTP was sent. Please check',
                                      contentType: ContentType.success,
                                    );
                                    _startResendTimer(setState);
                                  } else {
                                    NesticoPeSnackBar.showAwesomeSnackbar(
                                      title: 'Error',
                                      message: 'Failed to resend OTP',
                                      contentType: ContentType.failure,
                                    );
                                  }
                                  setState(() {});
                                },
                        child:
                            isResendingOtp
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Didn't receive code? ",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    Text("Resend OTP"),
                                  ],
                                ),
                      ),
                    ],
                    TextButton(
                      onPressed: () {
                        setState(() => stepOtp = false);
                      },
                      child: const Text("Change Number"),
                    ),
                  ],

                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    ).whenComplete(() {
      isSheetOpen = false;
      _resendTimer?.cancel();
    });
    return proceed;
  }
}

// class OnboardingScreen extends StatelessWidget {
//   const OnboardingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final OnboardingController controller = Get.put(OnboardingController());

//     return Scaffold(
//       // backgroundColor: Colors.white,

//       body: Container(
//         decoration: BoxDecoration(
//               color: ColorRes.primary, // dark navy background
//           image: DecorationImage(
//             image: AssetImage('assets/images/moder_villa.png'),
//             fit: BoxFit.cover,

//             repeat: ImageRepeat.repeat,
//             // opacity: 0.08,
//             opacity: 0.4
//           ),
//         ),
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,

//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,

//                 children: [
//                   Text(
//                     'What are you\nlooking for?',
//                     style: TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: ColorRes.white,
//                       height: 1.2,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Choose an option to customize your\nexperience.',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.grey[200],
//                       height: 1.5,
//                     ),
//                   ),
//                   SizedBox(height: 32),
//                   _buildOptionTile(
//                     controller: controller,
//                     icon: Icons.home,
//                     iconColor: ColorRes.primary,
//                     iconBgColor: ColorRes.primary.withOpacity(0.05),
//                     title: 'Buy Home',
//                     subtitle: 'Find your forever property',
//                   ),
//                   SizedBox(height: 16),
//                   _buildOptionTile(
//                     controller: controller,
//                     icon: Icons.key,
//                     iconColor: ColorRes.primary,
//                     iconBgColor: ColorRes.primary.withOpacity(0.05),
//                     title: 'Rent Home',
//                     subtitle: 'Explore monthly rentals',
//                   ),
//                   SizedBox(height: 16),
//                   _buildOptionTile(
//                     controller: controller,
//                     icon: Icons.sell,
//                     iconColor: ColorRes.primary,
//                     iconBgColor: ColorRes.primary.withOpacity(0.05),
//                     title: 'Seller Registration',
//                     subtitle: 'List and sell your property',
//                   ),
//                   SizedBox(height: 16),
//                   _buildOptionTile(
//                     controller: controller,
//                     icon: Icons.store,
//                     iconColor: ColorRes.primary,
//                     iconBgColor: ColorRes.primary.withOpacity(0.05),
//                     title: 'Partner Registration',
//                     subtitle: 'Join our partners program',
//                   ),
//                   SizedBox(height: 16),
//                   _buildOptionTile(
//                     controller: controller,

//                     icon: Icons.construction,
//                     iconColor: ColorRes.primary,
//                     iconBgColor: ColorRes.primary.withOpacity(0.05),
//                     title: 'Contractor Registration',
//                     subtitle: 'Provide renovation services',
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildOptionTile({
//     required OnboardingController controller,
//     required IconData icon,
//     required Color iconColor,
//     required Color iconBgColor,
//     required String title,
//     required String subtitle,
//   }) {
//     return Obx(
//       () => IgnorePointer(
//         ignoring: controller.isProcessing.value,
//         // ✅ Disable during processing
//         child: Opacity(
//           opacity: controller.isProcessing.value ? 0.6 : 1.0,
//           child: InkWell(
//             onTap: () => controller.selectOption(title),
//             borderRadius: BorderRadius.circular(12),
//             child: Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color:
//                     controller.selectedOption.value == title
//                         ? Colors.blue[50]
//                         : Colors.grey[50],
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color:
//                       controller.selectedOption.value == title
//                           ? ColorRes.primary
//                           : Colors.transparent,
//                   width: 2,
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: iconBgColor,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Icon(icon, color: iconColor, size: 24),
//                   ),
//                   SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           title,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black,
//                           ),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           subtitle,
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   if (controller.isProcessing.value &&
//                       controller.selectedOption.value == title)
//                     SizedBox(
//                       width: 16,
//                       height: 16,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: ColorRes.primary,
//                       ),
//                     )
//                   else
//                     Icon(
//                       Icons.arrow_forward_ios,
//                       size: 16,
//                       color: Colors.grey[400],
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingController controller = Get.put(OnboardingController());

    return Scaffold(
      body: Stack(
        children: [
          // Background: dark navy base
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0D1B3E), // deep navy
            ),
          ),

          // Top house image with gradient fade
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 260,
            child: ShaderMask(
              shaderCallback:
                  (rect) => LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white.withOpacity(0.6), Colors.transparent],
                    stops: const [0.4, 1.0],
                  ).createShader(rect),
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                'assets/images/moder_villa.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),

          // Subtle dot pattern overlay
          Positioned.fill(child: CustomPaint(painter: DotPatternPainter())),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100), // space for the image
                  // Heading
                  const Text(
                    'What are you\nlooking for?',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.15,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Choose an option to customize your experience and find your place in the world.',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.70),
                      height: 1.55,
                    ),

                  ),
                  const SizedBox(height: 28),

                  // Option Cards
                  _buildOptionTile(
                    controller: controller,
                    icon: Icons.home_rounded,
                    title: 'Buy Home',
                    subtitle:
                        'Find premium residential and luxury homes made for first-time owners.',
                    actionLabel: 'Explore Listings',
                  ),
                  const SizedBox(height: 14),
                  _buildOptionTile(
                    controller: controller,
                    icon: Icons.vpn_key_rounded,
                    title: 'Rent Home',
                    subtitle:
                        'Experience high-end living with our exclusive collection of luxury home opportunities.',
                    actionLabel: 'View Rentals',
                  ),
                  const SizedBox(height: 14),
                  _buildOptionTile(
                    controller: controller,
                    icon: Icons.sell_rounded,
                    title: 'Seller Registration',
                    subtitle:
                        'List your property with professional marketing and enhanced tools.',
                    actionLabel: 'Start Selling',
                  ),
                  const SizedBox(height: 14),
                  _buildOptionTile(
                    controller: controller,
                    icon: Icons.store_rounded,
                    title: 'Partner Registration',
                    subtitle:
                        'Join our network of top agents and brokers and unlock new avenues.',
                    actionLabel: 'Become a Partner',
                  ),
                  const SizedBox(height: 14),
                  _buildOptionTile(
                    controller: controller,
                    icon: Icons.construction_rounded,
                    title: 'Contractor Registration',
                    subtitle:
                        'Offer your renovation and construction services to thousands of clients.',
                    actionLabel: 'Join as Contractor',
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required OnboardingController controller,
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionLabel,
  }) {
    return Obx(
      () => IgnorePointer(
        ignoring: controller.isProcessing.value,
        child: Opacity(
          opacity: controller.isProcessing.value ? 0.6 : 1.0,
          child: GestureDetector(
            onTap: () => controller.selectOption(title),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color:
                      controller.selectedOption.value == title
                          ? const Color(0xFF2563EB)
                          : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon bubble
                  Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: ColorRes.primary, size: 22),
                  ),
                  const SizedBox(width: 14),

                  // Text + link
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Action link
                        if (controller.isProcessing.value &&
                            controller.selectedOption.value == title)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF2563EB),
                            ),
                          )
                        else
                          Row(
                            children: [
                              Text(
                                actionLabel,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: ColorRes.primary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward,
                                size: 13,
                                color: ColorRes.primary,
                              ),
                            ],
                          ),
                      ],
                    ),
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

/// Subtle dot pattern painter for the background
class DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.06)
          ..style = PaintingStyle.fill;

    const spacing = 28.0;
    const radius = 1.5;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DotPatternPainter oldDelegate) => false;
}
