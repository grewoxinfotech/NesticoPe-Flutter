import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/modules/add_property/controller/create_property_controller.dart'
    hide SellerType;
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart';
import 'package:housing_flutter_app/modules/auth/controllers/auth_controller.dart';

import 'package:housing_flutter_app/modules/auth/views/register_screen.dart';
import 'package:housing_flutter_app/modules/auth/views/role_convert/convert_to_seller/convert_to_seller.dart';
import 'package:housing_flutter_app/modules/profile/views/profile_screen.dart';
import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';

import '../../../app/utils/helper_function/user_helper/user_helper.dart';
import '../../../data/network/auth/model/user_model.dart';
import '../../builder/controller/builder_form_controller.dart';
import '../../builder/view/builder_form_screen.dart';
import '../../profile/controllers/buyer_profiledata.dart';
import '../../property/controllers/property_controller.dart';

class HomeHeader extends StatefulWidget {
  final List<String> propertyTypes;
  final String backgroundImage;
  final String image;

  const HomeHeader({
    super.key,
    this.backgroundImage =
        "https://sitasurat.in/assets/images/about/surat-city.jpg",
    this.image =
        "https://img.freepik.com/premium-vector/man-avatar-profile-picture-isolated-background-avatar-profile-picture-man_1293239-4866.jpg",
    this.propertyTypes = const [
      "Buy",
      "Sell",
      "Rent",
      // "Commercial",
      "PG",
      // "Shop",
      // "Office",
      // "Studio",
      // "Warehouse",
    ],
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final propertyController = Get.find<PropertyController>();
  final projectController = Get.find<ProjectWizardController>();

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
                        // Container(
                        //   width: 45,
                        //   height: 45,
                        //   decoration: BoxDecoration(
                        //     color: ColorRes.white,
                        //     border: Border.all(
                        //       color: ColorRes.grey.withOpacity(0.2),
                        //     ),
                        //     borderRadius: BorderRadius.circular(12),
                        //   ),
                        //   padding: const EdgeInsets.all(8),
                        //   child: const Icon(
                        //     Icons.notes_outlined,
                        //     color: ColorRes.black,
                        //     size: 22,
                        //   ),
                        // ),
                        // const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
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

              // SizedBox(width: 8),
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
              if (UserHelper.isSeller) ...[
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () async {
                    print("Mic tapped");

                    try {
                      // Get cached user type (sync, since you initialized it in splash)
                      final userType = UserHelper.userType;

                      // If not initialized, fetch directly from secure storage (fallback)
                      if (userType == null) {
                        final user = await SecureStorage.getUserData();
                        final role = user?.user?.userType?.toLowerCase() ?? '';
                        UserHelper.setUserType(role);
                      }

                      print(
                        "DEBUG >> Current UserType: ${UserHelper.userType}",
                      );

                      if (UserHelper.isGuest) {
                        if (!Get.isRegistered<AuthController>()) {
                          Get.put(AuthController());
                        }
                        Get.to(
                          () => const RegisterScreen(role: UserRole.seller),
                        );
                      }

                      if (UserHelper.isBuyer) {
                        Get.to(() => const SellerConversionScreen());
                      }

                      // Handle behavior by role
                      if (UserHelper.isSeller) {
                        // ✅ Seller → can create property directly
                        if (UserHelper.isSellerOwner) {
                          Get.to(
                            () => CreatePropertyScreen(
                              // sellerType: mapUserRoleToSellerType(
                              //   UserRole.seller,
                              // ),
                              isLogin: true,
                            ),
                          );
                        }

                        if (UserHelper.isSellerBuilder) {
                          if (Get.isRegistered<ProjectWizardController>(
                            tag: "builder",
                          )) {
                            Get.find<ProjectWizardController>(tag: "builder");
                          } else {
                            Get.lazyPut(
                              () =>
                                  ProjectWizardController(isBuilderView: true),
                              tag: "builder",
                            );
                          }
                          Get.to(() => CreateProjectScreen());
                        }
                      }
                    } catch (e) {
                      print("Error checking user type: $e");
                      Get.snackbar(
                        "Error",
                        "Something went wrong. Please try again.",
                        snackPosition: SnackPosition.BOTTOM,
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
                      Icons.add,
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
