import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:housing_flutter_app/data/network/auth/model/user_model.dart';
import 'package:housing_flutter_app/modules/auth/views/register_screen.dart';
import 'package:housing_flutter_app/modules/auth/views/role_convert/convert_to_seller/convert_to_seller.dart';
import 'package:housing_flutter_app/modules/builder/controller/builder_form_controller.dart';
import 'package:housing_flutter_app/modules/calender/views/calender_screen.dart';
import 'package:housing_flutter_app/modules/dashboard/views/seller_dashboard_screen.dart';
import 'package:housing_flutter_app/modules/dashboard/views/widget/favourite_screen.dart';
import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';
import 'package:housing_flutter_app/modules/reseller/view/property_reseller.dart';
import 'package:housing_flutter_app/modules/seller/module/seller_home_screen/views/property_overview_screen.dart';
import 'package:housing_flutter_app/widgets/bar/navigation_bar/navigation_Bar.dart';
import '../../../widgets/dialogs/delete_dialog.dart';
import '../../../widgets/drawer/drawer.dart';
import 'package:get/get.dart';

import '../../auth/views/role_convert/covert_to_reseller/convert_to_reseller.dart';
import '../../builder/view/builder_main_screen.dart';
import '../../feedback/views/feedback_and_report.dart';
import '../../home/views/compare_screen/comapre_screen.dart';
import '../../home/views/home_screen/home_screen.dart';
import '../../feedback/controller/feedback_controller.dart';
import '../../feedback/views/buyer_feedback.dart';

import '../../insights/views/insights_screen.dart';
import '../../location_price_matrix/views/location_price_mtrix_screen.dart';
import '../../referral/view/referral_dashboard.dart';
import '../../reseller/view/reseller_success_stories/reseller_success_stories.dart';
import '../../saved_property/views/saved_property_screen.dart';
import '../../seller/seller_listing/view/seller_listing_view.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.put(NavigationController());
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const SafeArea(child: NesticoPeNavigationBar()),
      body: Obx(() {
        if (navigationController.currentIndex.value == 0) {
          return HomeScreen();
        } else if (navigationController.currentIndex.value == 1) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // if (UserHelper.isSellerOwner) ...[
                ElevatedButton(
                  onPressed: () {
                    navigationController.currentIndex.value = 0;
                    Get.to(
                      () => SellerDashboardScreen(),
                      binding: BindingsBuilder(() {
                        Get.lazyPut<PropertyController>(
                          () => PropertyController(),
                        );
                      }),
                    );
                  },

                  child: Text("Seller"),
                ),
                SizedBox(height: 16),
                // ],
                // if (UserHelper.isReseller) ...[
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => MainNavigationScreen());
                  },

                  child: Text("Reseller"),
                ),
                SizedBox(height: 16),
                // ],
                // if (UserHelper.isSellerBuilder) ...[
                ElevatedButton(
                  onPressed: () {
                    // if (Get.isRegistered<ProjectWizardController>()) {
                    //   Get.delete<ProjectWizardController>();
                    // }
                    Get.to(() => BuilderMainScreen());
                  },

                  child: Text("Builder"),
                ),
                SizedBox(height: 16),
                // ],
                // if (UserHelper.isReseller) ...[
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => ResellerSuccessStoryScreen());
                  },

                  child: Text("Reseller Stories"),
                ),
                SizedBox(height: 16),
                // ],
                if (UserHelper.isBuyer) ...[
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => ResellerConversionScreen());
                    },

                    child: Text("Convert Reseller"),
                  ),
                  SizedBox(height: 16),
                ],

                if (UserHelper.isGuest) ...[
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => RegisterScreen(role: UserRole.reseller));
                    },

                    child: Text("Convert Reseller"),
                  ),
                  SizedBox(height: 16),
                ],

                ElevatedButton(
                  onPressed: () {
                    Get.to(() => SellerConversionScreen());
                  },

                  child: Text("Convert seller"),
                ),
                SizedBox(height: 16),
                // ],
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => LocationPriceMatrixScreen());
                  },

                  child: Text("Location Price Matrix Screen"),
                ),

                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => CalendarScreen());
                  },

                  child: Text("Calender"),
                ),
              ],
            ),
          );
        } else if (navigationController.currentIndex.value == 2) {
          return FavouriteScreen();
        } else if (navigationController.currentIndex.value == 3) {
          return InsightsScreen();
        } else if (navigationController.currentIndex.value == 4) {
          return const SavedPropertyScreen();
        } else if (navigationController.currentIndex.value == 5) {
          return const SavedPropertyScreen();
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
