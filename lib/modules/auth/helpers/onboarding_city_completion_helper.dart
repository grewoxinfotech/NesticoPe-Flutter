import 'dart:developer';

import 'package:get/get.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/history/service/search_history_service.dart';
import 'package:nesticope_app/modules/builder/view/builder_main_screen.dart';
import 'package:nesticope_app/modules/contractor/view/contractor_main.dart';
import 'package:nesticope_app/modules/dashboard/views/dashboard_screen.dart';
import 'package:nesticope_app/modules/dashboard/views/seller_dashboard_screen.dart';
import 'package:nesticope_app/modules/reseller/view/property_reseller.dart';

/// Shared path after the user picks a city during buyer onboarding (from
/// [OnboardingScreen] or splash resume).
class OnboardingCityCompletionHelper {
  static Future<void> completeAndOpenDashboard(String city) async {
    final trimmed = city.trim();
    if (trimmed.isEmpty) return;

    final homeCategory = await SecureStorage.getHomeCategory();
    final listingType = (homeCategory == 'Rent/Lease') ? 'Rent' : 'Sell';
    final hc = homeCategory ?? 'Buy';

    log('Onboarding city completion: $trimmed (category=$hc)');

    // Avoid creating SearchHistoryController here (its onInit triggers network
    // calls and can freeze on selection). Just call the service best-effort.
    
      try {
        await SearchHistoryService.service.addSearchHistory({
          'keywords': [trimmed],
        });
      } catch (e) {
        log('Search history add failed: $e');
      }
    
    await SecureStorage.saveSelectedCity(trimmed);
    await SecureStorage.setAppLaunched();
    await SecureStorage.saveHomeCategory(hc);
    await SecureStorage.setPendingOnboardingCitySelection(false);

    final filter =
        listingType == 'Sell'
            ? [
              {'city': trimmed},
              {'listingType': 'Sell'},
            ]
            : [
              {'city': trimmed},
              {'listingType': 'Rent'},
            ];

    // await Get.offAll(() => DashboardScreen(propertyFilter: filter));
    if (UserHelper.userType == UserType.buyer) {
      await Get.offAll(() => DashboardScreen(propertyFilter: filter));
    } else if (UserHelper.userType == UserType.seller &&
        UserHelper.sellerType == SellerType.owner) {
      Get.offAll(() => const SellerDashboardScreen());
    } else if (UserHelper.userType == UserType.reseller) {
      Get.offAll(() => const MainNavigationScreen());
    } else if (UserHelper.userType == UserType.contractor) {
      Get.offAll(() => ContractorMainScreen());
    } else if (UserHelper.userType == UserType.seller &&
        UserHelper.sellerType == SellerType.builder) {
      Get.offAll(() => const BuilderMainScreen());
    }
    else{
       await Get.offAll(() => DashboardScreen(propertyFilter: filter));
    }
  }
}
