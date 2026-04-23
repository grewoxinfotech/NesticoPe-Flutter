import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/widgets/image/custom_image.dart'
    hide ColorRes;
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/modules/add_property/controller/create_property_controller.dart'
    hide SellerType;
import 'package:nesticope_app/modules/add_property/view/create_property.dart';
import 'package:nesticope_app/modules/auth/controllers/auth_controller.dart';

import 'package:nesticope_app/modules/auth/views/register_screen.dart';
import 'package:nesticope_app/modules/auth/views/role_convert/convert_to_seller/convert_to_seller.dart';
import 'package:nesticope_app/modules/builder/view/builder_dashboard.dart';
import 'package:nesticope_app/modules/contractor/view/dashboard/contractor_dashboard.dart';
import 'package:nesticope_app/modules/dashboard/views/seller_dashboard_screen.dart';
import 'package:nesticope_app/modules/history/controller/search_history_controller.dart';
import 'package:nesticope_app/modules/home/controllers/top_builder_controller.dart';
import 'package:nesticope_app/modules/in_app_message/view/in_app_message_screen.dart';
import 'package:nesticope_app/modules/profile/views/profile_screen.dart';
import 'package:nesticope_app/modules/reseller/view/property_reseller.dart';
import 'package:nesticope_app/modules/search_property/view/search_screen.dart';

import '../../../app/utils/helper_function/user_helper/user_helper.dart';
import '../../../data/network/auth/model/user_model.dart';
import '../../../widgets/messages/snack_bar.dart';
import '../../builder/controller/builder_form_controller.dart';
import '../../builder/view/builder_main_screen.dart';
import '../../contractor/view/contractor_main.dart';
import '../../in_app_message/controller/in_app_message_controller.dart';
import '../../property/controllers/property_controller.dart';
import '../../profile/controllers/buyer_profiledata.dart';
import '../../hire_contractor/view/hire_contractor_screen.dart';

class HomeHeader extends StatefulWidget {
  final List<String> propertyTypes;
  final String backgroundImage;
  final String image;
  final Function(String city) onCityChanged;
  // Change callback signature
  final Function(String category, {bool fromUser}) onCategoryChanged;

  const HomeHeader({
    super.key,
    this.backgroundImage =
        "https://sitasurat.in/assets/images/about/surat-city.jpg",
    this.image =
        "https://img.freepik.com/premium-vector/man-avatar-profile-picture-isolated-background-avatar-profile-picture-man_1293239-4866.jpg",
    this.propertyTypes = const ["Buy", "Sell", "Rent", "PG"],
    required this.onCityChanged,
    required this.onCategoryChanged,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  late final PropertyController propertyController;
  late final ProjectWizardController projectController;
  late final TopBuilderController topBuilderController;
  late final SearchHistoryController searchHistoryController;
  final NotificationController controller = Get.put(NotificationController());

  int selectedIndex = 0;
  String? selectedCategory;
  bool _userInteracted = false;

  @override
  void initState() {
    super.initState();
    propertyController =
        Get.isRegistered<PropertyController>()
            ? Get.find<PropertyController>()
            : Get.put(PropertyController());
    projectController =
        Get.isRegistered<ProjectWizardController>()
            ? Get.find<ProjectWizardController>()
            : Get.put(ProjectWizardController(isBuilderView: false));
    topBuilderController =
        Get.isRegistered<TopBuilderController>()
            ? Get.find<TopBuilderController>()
            : Get.put(TopBuilderController());
    searchHistoryController =
        Get.isRegistered<SearchHistoryController>()
            ? Get.find<SearchHistoryController>()
            : Get.put(SearchHistoryController());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final initial = await SecureStorage.getHomeCategory();
      selectedCategory = initial ?? 'Buy';
      // widget.onCategoryChanged(selectedCategory!);
      if (!Get.isRegistered<BuyerProfileDataController>()) {
        Get.put(BuyerProfileDataController());
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final BuyerProfileDataController profileController =
        Get.find<BuyerProfileDataController>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Row: City + Post Property
        SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.only(right: 12),

          // color: Colors.white,

          // height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  height: 32,
                  width: 32,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      'assets/images/Nestico-Pe_Logo-svg.png',
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // (UserHelper.isGuest)
              //     ? SizedBox.shrink()
              //     : Stack(
              //       clipBehavior: Clip.none,
              //       children: [
              //         // Profile avatar moved from bottom nav
              //         GestureDetector(
              //           onTap: () {
              //             controller.refreshNotifications();
              //             Get.to(() => InAppMessageScreen());
              //           },
              //           child: Container(
              //             padding: const EdgeInsets.all(8),
              //             child: Icon(
              //               Icons.notifications_none_rounded,
              //               color: ColorRes.primary,
              //               size: 25,
              //             ),
              //           ),
              //         ),

              //         // 🔴 Badge
              //         Obx(() {
              //           if (controller.unReadNumber.value == 0) {
              //             return SizedBox.shrink();
              //           }
              //           return Positioned(
              //             right: 4,
              //             top: 2,
              //             child: Container(
              //               padding: const EdgeInsets.all(4),
              //               decoration: BoxDecoration(
              //                 color: Colors.red,
              //                 shape: BoxShape.circle,
              //               ),
              //               constraints: const BoxConstraints(
              //                 minWidth: 16,
              //                 minHeight: 16,
              //               ),
              //               child: Center(
              //                 child: Text(
              //                   '${controller.unReadNumber.value}',
              //                   // 🔢 notification count
              //                   style: const TextStyle(
              //                     color: Colors.white,
              //                     fontSize: 10,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           );
              //         }),
              //       ],
              //     ),
              // SizedBox(width: 8),
              if (UserHelper.isSeller ||
                  UserHelper.isContractor ||
                  UserHelper.isBuyer ||
                  UserHelper.isGuest ||
                  UserHelper.isReseller) ...[
                const SizedBox(width: 8),

                GestureDetector(
                  onTap: () async {
                    print("Post Property tapped");

                    try {
                      var userType = UserHelper.userType;

                      if (userType == null) {
                        final user = await SecureStorage.getUserData();
                        final role = user?.user?.userType?.toLowerCase() ?? '';
                        UserHelper.setUserType(role);
                      }

                      /// Guest → Register
                      if (UserHelper.isGuest) {
                        if (!Get.isRegistered<AuthController>()) {
                          Get.put(AuthController());
                        }
                        Get.to(
                          () => const RegisterScreen(role: UserRole.seller),
                        );
                        return;
                      }

                      /// Buyer → Seller conversion
                      if (UserHelper.isBuyer) {
                        Get.to(() => const SellerConversionScreen());
                        return;
                      }

                      /// Seller
                      if (UserHelper.isSeller) {
                        if (UserHelper.isSellerOwner) {
                          Get.to(() => const SellerDashboardScreen());
                          return;
                        }

                        if (UserHelper.isSellerBuilder) {
                          Get.to(() => BuilderMainScreen());
                          return;
                        }
                      }

                      /// Contractor
                      if (UserHelper.isContractor) {
                        Get.to(() => ContractorMainScreen());
                      }
                      if (UserHelper.isReseller) {
                        Get.to(() => MainNavigationScreen());
                        return;
                      }
                    } catch (e, s) {
                      print(e);
                      print(s);

                      NesticoPeSnackBar.showAwesomeSnackbar(
                        title: 'Error',
                        message: "Something went wrong. Please try again.",
                        contentType: ContentType.failure,
                      );
                    }
                  },

                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: ColorRes.primary,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: ColorRes.primary.withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          getButtonText(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      Positioned(
                        right: -10,
                        top: -12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: ColorRes.error,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: ColorRes.error.withOpacity(0.25),

                                blurRadius: 6,

                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            'FREE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSizes.mini,
                              fontWeight: AppFontWeights.bold,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => ProfileScreen(
                      imageUrl:
                          profileController.userProfile.value?.profilePic ?? '',
                    ),
                  );
                },
                child: Obx(() {
                  final img =
                      profileController.userProfile.value?.profilePic ?? '';
                  return Container(
                    margin: const EdgeInsets.only(right: 6),
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Get.theme.colorScheme.primary.withOpacity(0.5),
                        width: 1.2,
                      ),
                    ),
                    child: ClipOval(
                      child:
                          (img.isNotEmpty && img != 'null')
                              ? CustomImage(
                                src: img,
                                type: CustomImageType.network,
                                width: 34,
                                height: 34,
                                fit: BoxFit.cover,
                              )
                              : Container(
                                color: Get.theme.colorScheme.primary,
                                child: const Icon(
                                  Icons.person_outline,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        ///MARK: Change here
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: buildPositionedTextField(
                  propertyController,
                  context,
                  () async {
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
                      topBuilderController.applyFilter('city', city);

                      propertyController.applyFilter('city', city);
                      projectController.applyFilter('city', city);
                      // Reload top properties for the new city
                      await propertyController.loadTopProperties();
                      await projectController.loadTopProject();
                      await topBuilderController.loadInitial();

                      // Navigate to PropertyDetail in both cases (Yes and No)
                    }
                  },
                ),
              ),
              const SizedBox(width: 6),
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 16),
              //   decoration: BoxDecoration(
              //     color: ColorRes.white,
              //     borderRadius: BorderRadius.circular(16),
              //     border: Border.all(color: ColorRes.grey.withOpacity(0.2)),
              //   ),
              //   child: SizedBox(
              //     height: 48,
              //     child: PopupMenuButton<String>(

              //       onSelected: (val) async {
              //         setState(() {
              //           selectedCategory = val;
              //         });
              //         widget.onCategoryChanged(val);
              //         await SecureStorage.saveHomeCategory(val);
              //       },
              //       itemBuilder: (context) => const [
              //         PopupMenuItem(value: 'Buy', child: Text('BUY',style: TextStyle(fontSize: AppFontSizes.small,fontWeight: AppFontWeights.semiBold,color: ColorRes.textColor),)),
              //         PopupMenuItem(value: 'Rent/Lease', child: Text('RENT/LEASE',style: TextStyle(fontSize: AppFontSizes.small,fontWeight: AppFontWeights.semiBold,color: ColorRes.textColor),)),
              //         PopupMenuItem(value: 'Commercial', child: Text('COMMERCIAL',style: TextStyle(fontSize: AppFontSizes.small,fontWeight: AppFontWeights.semiBold,color: ColorRes.textColor),)),
              //         PopupMenuItem(value: 'PG/Co-living', child: Text('PG/CO-LIVING',style: TextStyle(fontSize: AppFontSizes.small,fontWeight: AppFontWeights.semiBold,color: ColorRes.textColor),)),
              //         PopupMenuItem(value: 'Plots', child: Text('PLOTS',style: TextStyle(fontSize: AppFontSizes.small,fontWeight: AppFontWeights.semiBold,color: ColorRes.textColor),)),
              //       ],
              //       padding: EdgeInsets.zero,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: const [
              //           Icon(Icons.filter_list, color: ColorRes.primary, size: 22),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 48,
                child: PopupMenuButton<String>(
                  offset: const Offset(10, 0), // 👈 button height ke equal
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: ColorRes.primary.withOpacity(
                        0.2,
                      ), // 👈 border color
                      width: 1,
                    ),
                  ),
                  color: Colors.white,

                  /// ✅ Shadow
                  elevation: 8,

                  position: PopupMenuPosition.under,
                  onSelected: (val) async {
                    if (val == 'Service') {
                      Get.to(() => const HireContractorScreen());
                      return;
                    }
                    setState(() {
                      selectedCategory = val;
                      _userInteracted = true;
                    });
                    widget.onCategoryChanged(val, fromUser: true);
                    await SecureStorage.saveHomeCategory(val);
                  },
                  itemBuilder:
                      (context) => [
                        _buildMenuItem('Buy'),
                        _buildMenuItem('Rent/Lease'),
                        _buildMenuItem('Commercial'),
                        _buildMenuItem('PG/Co-living'),
                        _buildMenuItem('Service'),
                        // _buildMenuItem('Plots'),
                      ],
                  padding: EdgeInsets.zero,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: ColorRes.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: ColorRes.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.tune_rounded,
                          color: ColorRes.primary,
                          size: 20,
                        ),
                        // const SizedBox(width: 6),
                        // Text(    i have app idea for fit ness tarker app that on base of solo leveling anime that contain the workout plan for honme and gym alltype so exercise with diet plan with ai intergartion chat white other use progress tarcker leaderbpard
 
                        //   selectedCategory ?? 'Buy',
                        //   style: const TextStyle(
                        //     fontSize: AppFontSizes.small,
                        //     fontWeight: AppFontWeights.semiBold,
                        //     color: ColorRes.primary,
                        //   ),
                        // ),
                        // const SizedBox(width: 4),
                        // const Icon(
                        //   Icons.keyboard_arrow_down_rounded,
                        //   size: 18,
                        //   color: ColorRes.primary,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // const SizedBox(height: 8),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(String value) {
    final isSelected = selectedCategory == value;
    final isServiceItem = value == 'Service';


    return PopupMenuItem<String>(
      value: value,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            children: [
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: isSelected ? ColorRes.primary : Colors.grey,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                value.toUpperCase(),
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? ColorRes.primary : ColorRes.textColor,
                ),
              ),
            ],
          ),
          if (isServiceItem)
            Positioned(
          
              right: 18,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: ColorRes.error,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: ColorRes.error.withOpacity(0.25),
                      blurRadius: 10,
                      spreadRadius: 4,

                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'NEW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppFontSizes.mini,
                    fontWeight: AppFontWeights.bold,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String getButtonText() {
    if (UserHelper.isReseller) {
      return "Add Lead";
    } else if (UserHelper.isContractor) {
      return "Add Service";
    } else if (UserHelper.isSellerOwner) {
      return "Post Property";
    } else if (UserHelper.isSellerBuilder) {
      return "Post Project";
    }
    return "Post Property"; // default fallback
  }
}

Widget buildPositionedTextField(
  PropertyController propertyController,
  BuildContext context,
  VoidCallback? onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: TextField(
      enabled: false, // same as your CustomTextField

      controller: TextEditingController(
        text: propertyController.selectedCity.value,
      ),
      style: const TextStyle(
        fontSize: AppFontSizes.medium,
        fontWeight: AppFontWeights.medium,
        color: ColorRes.textColor,
      ),
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

// Widget buildPositionedTextField(BuildContext context, VoidCallback? onTap) {
//   return GestureDetector(
//     onTap: onTap,
//     child: TextField(
//       enabled: false, // same as your CustomTextField
//       controller: TextEditingController(),
//       decoration: InputDecoration(
//         hintText: 'Change your Location ...',
//         hintStyle: const TextStyle(fontSize: AppFontSizes.medium),
//         filled: true,
//         fillColor: ColorRes.white,
//         prefixIcon: const Icon(Icons.search, color: ColorRes.primary, size: 22),

//         contentPadding: const EdgeInsets.symmetric(
//           vertical: 14,
//           horizontal: 12,
//         ),
//         disabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: ColorRes.grey.withOpacity(0.2)),
//           borderRadius: BorderRadius.circular(16),
//           // borderSide: BorderSide(
//           //   color: ColorRes.grey,
//           //   width: 1,
//           // ), // remove border like your custom field
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: ColorRes.grey.withOpacity(0.2)),
//           borderRadius: BorderRadius.circular(16),
//           // borderSide: BorderSide(
//           //   color: ColorRes.grey,
//           //   width: 1,
//           // ), // remove border like your custom field
//         ),
//         border: OutlineInputBorder(
//           borderSide: BorderSide(color: ColorRes.grey.withOpacity(0.2)),
//           borderRadius: BorderRadius.circular(16),
//         ),
//       ),
//     ),
//   );
// }

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
