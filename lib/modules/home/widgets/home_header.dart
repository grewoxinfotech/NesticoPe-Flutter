import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart'
    hide ColorRes;
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/modules/add_property/controller/create_property_controller.dart'
    hide SellerType;
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart';
import 'package:housing_flutter_app/modules/auth/controllers/auth_controller.dart';

import 'package:housing_flutter_app/modules/auth/views/register_screen.dart';
import 'package:housing_flutter_app/modules/auth/views/role_convert/convert_to_seller/convert_to_seller.dart';
import 'package:housing_flutter_app/modules/builder/view/builder_dashboard.dart';
import 'package:housing_flutter_app/modules/contractor/view/dashboard/contractor_dashboard.dart';
import 'package:housing_flutter_app/modules/dashboard/views/seller_dashboard_screen.dart';
import 'package:housing_flutter_app/modules/history/controller/search_history_controller.dart';
import 'package:housing_flutter_app/modules/in_app_message/view/in_app_message_screen.dart';
import 'package:housing_flutter_app/modules/profile/views/profile_screen.dart';
import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';

import '../../../app/utils/helper_function/user_helper/user_helper.dart';
import '../../../data/network/auth/model/user_model.dart';
import '../../../widgets/messages/snack_bar.dart';
import '../../builder/controller/builder_form_controller.dart';
import '../../builder/view/builder_main_screen.dart';
import '../../contractor/view/contractor_main.dart';
import '../../in_app_message/controller/in_app_message_controller.dart';
import '../../property/controllers/property_controller.dart';

class HomeHeader extends StatefulWidget {
  final List<String> propertyTypes;
  final String backgroundImage;
  final String image;
  final Function(String city) onCityChanged;

  const HomeHeader({
    super.key,
    this.backgroundImage =
        "https://sitasurat.in/assets/images/about/surat-city.jpg",
    this.image =
        "https://img.freepik.com/premium-vector/man-avatar-profile-picture-isolated-background-avatar-profile-picture-man_1293239-4866.jpg",
    this.propertyTypes = const ["Buy", "Sell", "Rent", "PG"],
    required this.onCityChanged,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final propertyController = Get.find<PropertyController>();
  final projectController = Get.find<ProjectWizardController>();
  final searchHistoryController = Get.find<SearchHistoryController>();
  final NotificationController controller = Get.put(NotificationController());

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Row: City + Post Property
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Location",
                              style: TextStyle(
                                fontSize: AppFontSizes.extraSmall,
                                color: ColorRes.primary,

                                fontWeight: AppFontWeights.medium,
                              ),
                            ),
                            Obx(() {
                              if (propertyController
                                  .selectedCity
                                  .value
                                  .isEmpty) {
                                return SizedBox.shrink();
                              }

                              return InkWell(
                                onTap: () async {
                                  final filter = await Get.to(
                                    () => CommonSearchField(
                                      isNavigate: true,
                                      onTap: (city) {
                                        final filters = {
                                          "city": city.split(",").first,
                                        };
                                        propertyController.fetchTradingArea(
                                          filters['city'] ?? '',
                                        );
                                        Get.back(result: filters);
                                      },
                                    ),
                                  );
                                  if (filter != null &&
                                      filter is Map &&
                                      filter['city'] != null) {
                                    final String city = filter['city'];

                                    // Apply city filter to home (Yes case)
                                    await SecureStorage.saveSelectedCity(city);
                                    propertyController.fetchTradingArea(city);
                                    propertyController.applyFilter(
                                      'city',
                                      city,
                                    );
                                    projectController.applyFilter('city', city);
                                    widget.onCityChanged(city);
                                    log(
                                      'Selected city updated to for search history $city',
                                    );
                                    await searchHistoryController
                                        .addSearchHistory({
                                          'keywords': [city],
                                        });
                                    // Reload top properties for the new city
                                    await propertyController
                                        .loadTopProperties();
                                    await projectController.loadTopProject();

                                    // Navigate to PropertyDetail in both cases (Yes and No)
                                  }
                                },
                                child: Text(
                                  // widget.cityName,
                                  propertyController.selectedCity.value,
                                  style: const TextStyle(
                                    fontSize: AppFontSizes.body,
                                    color: ColorRes.textColor,
                                    fontWeight: AppFontWeights.semiBold,
                                    // fontFamily: 'Roboto',
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.refreshNotifications();
                      Get.to(() => InAppMessageScreen());

                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: ColorRes.primary,
                        size: 25,
                      ),
                    ),
                  ),

                  // 🔴 Badge
                  Obx(() {
                    if(controller.unReadNumber.value==0){
                      return SizedBox.shrink();
                    }
                    return Positioned(
                      right: 4,
                      top: 2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Center(
                          child: Text(
                            '${controller.unReadNumber.value}', // 🔢 notification count
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },)
                ],
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  log('dhfgugh djfdfjdn fhgfhglkb ${widget.image}');
                  Get.to(() => ProfileScreen(imageUrl: widget.image));
                },
                child:
                    (widget.image.isEmpty)
                        ? Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: ColorRes.primary,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: ColorRes.grey.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Center(
                              child: Icon(
                                Icons.home_work,
                                size: 22,
                                color: ColorRes.white,
                              ),
                            ),
                          ),
                        )
                        : Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorRes.grey.withOpacity(0.2),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CustomImage(
                              fit: BoxFit.cover,
                              type: CustomImageType.network,
                              src:
                                  widget.image ??
                                  "https://img.freepik.com/premium-vector/man-avatar-profile-picture-isolated-background-avatar-profile-picture-man_1293239-4866.jpg",
                            ),
                          ),
                        ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        ///MARK: Change here
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: buildPositionedTextField(context, () async {
                  final filter = await Get.to(
                    () => CommonSearchField(
                      isNavigate: true,
                      onTap: (city) {
                        final filters = {"city": city.split(",").first};
                        propertyController.fetchTradingArea(
                          filters['city'] ?? '',
                        );
                        Get.back(result: filters);
                      },
                    ),
                  );
                  if (filter != null &&
                      filter is Map &&
                      filter['city'] != null) {
                    final String city = filter['city'];

                    // Apply city filter to home (Yes case)
                    await SecureStorage.saveSelectedCity(city);
                    propertyController.fetchTradingArea(city);
                    propertyController.applyFilter('city', city);
                    projectController.applyFilter('city', city);
                    // Reload top properties for the new city
                    await propertyController.loadTopProperties();
                    await projectController.loadTopProject();

                    // Navigate to PropertyDetail in both cases (Yes and No)
                  }
                }),
              ),
              if (UserHelper.isSeller ||
                  UserHelper.isContractor ||
                  UserHelper.isBuyer) ...[
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () async {
                    print("Mic tapped");

                    try {
                      /// 1️⃣ Ensure UserType is initialized
                      var userType = UserHelper.userType;

                      if (userType == null) {
                        final user = await SecureStorage.getUserData();
                        final role = user?.user?.userType?.toLowerCase() ?? '';
                        UserHelper.setUserType(role);
                      }

                      print(
                        "DEBUG >> Current UserType: ${UserHelper.userType}",
                      );

                      /// 2️⃣ Guest → Register
                      if (UserHelper.isGuest) {
                        if (!Get.isRegistered<AuthController>()) {
                          Get.put(AuthController());
                        }
                        Get.to(
                          () => const RegisterScreen(role: UserRole.seller),
                        );
                        return;
                      }

                      /// 3️⃣ Buyer → Seller conversion
                      if (UserHelper.isBuyer) {
                        Get.to(() => const SellerConversionScreen());
                        return;
                      }

                      /// 4️⃣ Seller flow
                      if (UserHelper.isSeller) {
                        /// Aadhar check (common for all sellers)
                        // if (!UserHelper.isAadharVerified) {
                        //   Get.to(() => AadharAuthScreen());
                        //   return;
                        // }

                        /// 4A️⃣ Seller → Owner
                        if (UserHelper.isSellerOwner) {
                          Get.to(() => const SellerDashboardScreen());
                          return;
                        }

                        /// 4B️⃣ Seller → Builder
                        if (UserHelper.isSellerBuilder) {
                          Get.to(() => BuilderMainScreen());
                          return;
                        }
                      }

                      if (UserHelper.isContractor) {
                        Get.to(() => ContractorMainScreen());
                      }
                    } catch (e, s) {
                      print("Error checking user type: $e");
                      print(s);

                      NesticoPeSnackBar.showAwesomeSnackbar(
                        title: 'Error',
                        message: "Something went wrong. Please try again.",
                        contentType: ContentType.failure,
                      );
                    }
                  },

                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      color: ColorRes.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: ColorRes.grey.withOpacity(0.2)),
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: ColorRes.primary,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        // const SizedBox(height: 8),
      ],
    );
  }
}

Widget buildPositionedTextField(BuildContext context, VoidCallback? onTap) {
  return GestureDetector(
    onTap: onTap,
    child: TextField(
      enabled: false, // same as your CustomTextField
      controller: TextEditingController(),
      decoration: InputDecoration(
        hintText: 'Change your Location ...',
        hintStyle: const TextStyle(fontSize: AppFontSizes.medium),
        filled: true,
        fillColor: ColorRes.white,
        prefixIcon: const Icon(Icons.search, color: ColorRes.primary, size: 22),

        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorRes.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(16),
          // borderSide: BorderSide(
          //   color: ColorRes.grey,
          //   width: 1,
          // ), // remove border like your custom field
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorRes.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(16),
          // borderSide: BorderSide(
          //   color: ColorRes.grey,
          //   width: 1,
          // ), // remove border like your custom field
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: ColorRes.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
  );
}

SellerType mapUserRoleToSellerType(UserRole role) {
  switch (role) {
    case UserRole.seller:
      return SellerType.owner;
    case UserRole.reseller:
      return SellerType.builder; // or any mapping
    default:
      return SellerType.owner;
  }
}
