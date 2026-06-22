import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/data/network/auth/model/user_model.dart';
import 'package:nesticope_app/data/network/support_ticket/models/ticket_model/support_ticket_model.dart';
import 'package:nesticope_app/data/network/support_ticket/service/ticket_service/support_ticket_service.dart';
import 'package:nesticope_app/modules/auth/views/otp_login_screen.dart';
import 'package:nesticope_app/modules/home/controllers/contractor_profile_controller/contractor_compare_manager.dart';
import 'package:nesticope_app/modules/support_ticket/controllers/chat_socket_controller.dart';
import 'package:nesticope_app/modules/support_ticket/views/support_ticket_chat_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/app/manager/compare_manager.dart';
import 'package:nesticope_app/app/manager/project_compare_manager.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/utils/logger/app_logger.dart';
import '../../../app/constants/app_font_sizes.dart';
import '../../../data/network/contractor/model/contractor_profile_model/contractor_profile_model.dart';
import '../../../data/network/contractor/model/contractot_service_model/contractor_service_model.dart';
import '../../../data/network/contractor/service/contractor_profile_service.dart';
import '../../../widgets/messages/snack_bar.dart';
import '../controllers/contractor_profile_service_controller/contractor_profile_service_controller.dart';
import 'contractor_add_inuiry_screen.dart';
import 'package:nesticope_app/app/widgets/shimmer/shimmer_widget.dart';
import 'package:nesticope_app/app/utils/helper_function/contact_helper.dart';
import 'package:nesticope_app/modules/home/controllers/contact_controller.dart';
import 'package:nesticope_app/modules/support_ticket/views/instant_support_chat_screen.dart';
import 'package:nesticope_app/modules/home/widgets/unified_comparison_floating_button.dart';
import 'package:nesticope_app/modules/contractor/controller/top_contractor_service_category_controller.dart';
import '../controllers/contractor_profile_controller/contractor_profile_controller.dart';

class ContractorProfileDetailsScreen extends StatefulWidget {
  final Contractor contractor;
  bool isPremium;

  ContractorProfileDetailsScreen({
    super.key,
    required this.contractor,
    this.isPremium = false,
  });

  @override
  State<ContractorProfileDetailsScreen> createState() =>
      _ContractorProfileDetailsScreenState();
}

class _ContractorProfileDetailsScreenState
    extends State<ContractorProfileDetailsScreen> {
  // Make this an instance variable accessible to the controller
  final RxBool isListSelectable = false.obs;
  final compare = Get.put(ContractorCompareManager(), permanent: true);
  final currentUserId = ''.obs;
  final RxString _selectedServiceCategoryId = ''.obs;
  String? _profilePic;
  User? userData;
  late final ContactController _contactController =
      Get.isRegistered<ContactController>()
          ? Get.find<ContactController>()
          : Get.put(ContactController());
  late final TopCategoryController _topCategoryController =
      Get.isRegistered<TopCategoryController>()
          ? Get.find<TopCategoryController>()
          : Get.put(TopCategoryController());
  TopContractorsController topContractorsController =
      Get.find<TopContractorsController>();
  late ContractorServiceController contractorServiceController;
  bool _ownsTopContractorsController = false;
  bool _ownsContractorServiceController = false;

  Future<void> contactContractor() async {
    contractorServiceController = Get.find<ContractorServiceController>(
      tag: widget.contractor.userId,
    );

    contractorServiceController.clearInquiryForm();
    // print("Selected Services: ${contractorServiceController.selectedItems}");

    final bool result = await Get.to(
      () => ContractorAddInquiryScreen(
        services: contractorServiceController.selectedItems.value,
        contractor: widget.contractor,
      ),
    );

    // After navigation reset back
    isListSelectable.value = false;
    if (result) {
      contractorServiceController.clearSelection();
    }
  }

  Future<void> loadData() async {
    final user = await SecureStorage.getUserData();
    // AppLogger.structured("Check Current User Data", user?.user?.toJson());
    currentUserId.value = user?.user?.id ?? '';

    final service = TopContractorsService();
    final details = await service.fetchUserModelById(widget.contractor.userId);
    if (!mounted) return;
    setState(() {
      userData = details;
      _profilePic = details?.profilePic;
      widget.isPremium = details.isPremium ?? false;
    });
  }

  late final TopContractorsController otherCtrl;

  @override
  void initState() {
    // TODO: implement  initStatecccc
    super.initState();
    if (Get.isRegistered<TopContractorsController>(
      tag: 'contractors_all_profile',
    )) {
      otherCtrl = Get.find<TopContractorsController>(
        tag: 'contractors_all_profile',
      );
    } else {
      _ownsTopContractorsController = true;
      otherCtrl = Get.put(
        TopContractorsController(withoutCity: true),
        tag: 'contractors_all_profile',
      );
    }

    if (Get.isRegistered<ContractorServiceController>(
      tag: widget.contractor.userId,
    )) {
      contractorServiceController = Get.find<ContractorServiceController>(
        tag: widget.contractor.userId,
      );
    } else {
      _ownsContractorServiceController = true;
      contractorServiceController = Get.put(
        ContractorServiceController(contractorId: widget.contractor.userId),
        tag: widget.contractor.userId,
      );
    }

    loadData();
  }

  @override
  void dispose() {
    if (_ownsContractorServiceController &&
        Get.isRegistered<ContractorServiceController>(
          tag: widget.contractor.userId,
        )) {
      Get.delete<ContractorServiceController>(tag: widget.contractor.userId);
    }
    if (_ownsTopContractorsController &&
        Get.isRegistered<TopContractorsController>(
          tag: 'contractors_all_profile',
        )) {
      Get.delete<TopContractorsController>(tag: 'contractors_all_profile');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        // Keep default back behavior so previous Home route is reused.
        topContractorsController.loadInitial();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              topContractorsController.loadInitial();
              _goToDashboard();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(
            "Contractor Profile",
            style: TextStyle(
              color: ColorRes.textColor,
              fontWeight: AppFontWeights.semiBold,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        bottomNavigationBar: SafeArea(child: _bottomActionBar()),
        body: SafeArea(
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  try {
                    await contractorServiceController.refreshList();
                  } catch (_) {
                    // ignore errors during refresh
                  }
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            AppRadius.mediumLarge,
                          ),
                          // border: Border.all(color: ColorRes.leadGreyColor.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 2,
                              offset: const Offset(2, 3),
                            ),
                          ],
                          color: ColorRes.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // ---------------- PROFILE HEADER ----------------
                            Obx(() {
                              final displayName = getDisplayName(
                                contractorFirstName:
                                    contractorServiceController
                                        .userData
                                        .value
                                        ?.firstName,
                                contractorLastName:
                                    contractorServiceController
                                        .userData
                                        .value
                                        ?.lastName,
                                userName: widget.contractor.username,
                              );

                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorRes.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          // Avatar
                                          // Container(
                                          //   height: 60,
                                          //   width: 60,
                                          //   decoration: BoxDecoration(
                                          //     color: ColorRes.primary.withOpacity(0.3),
                                          //     shape: BoxShape.circle,
                                          //   ),
                                          //   child: const Icon(
                                          //     Icons.build,
                                          //     size: 32,
                                          //     color: ColorRes.primary,
                                          //   ),
                                          // ),
                                          buildProfileAvatar(
                                            displayName: displayName,
                                            radius: 30,
                                            profilePic:
                                                _profilePic?.isNotEmpty == true
                                                    ? _profilePic!
                                                    : widget
                                                        .contractor
                                                        .imageUrl,
                                          ),
                                          const SizedBox(width: 16),

                                          // Contractor Info
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Name (only if available)
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if (displayName.isNotEmpty)
                                                      Expanded(
                                                        child: Text(
                                                          displayName.capitalize
                                                                  ?.replaceAll(
                                                                    '_',
                                                                    ' ',
                                                                  ) ??
                                                              '',
                                                          maxLines: 2,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          style: TextStyle(
                                                            fontSize:
                                                                AppFontSizes
                                                                    .body,
                                                            fontWeight:
                                                                AppFontWeights
                                                                    .semiBold,
                                                            color:
                                                                ColorRes
                                                                    .primary,
                                                          ),
                                                        ),
                                                      ),
                                                    // Spacer(),
                                                    SizedBox(width: 12),
                                                    if (double.tryParse(
                                                          widget
                                                              .contractor
                                                              .overallRating
                                                              .toString(),
                                                        ) !=
                                                        null)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              top: 4,
                                                            ),
                                                        child: Row(
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .star_rounded,
                                                              color:
                                                                  Colors.amber,
                                                              size: 14,
                                                            ),
                                                            // const SizedBox(width: 4),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              (double.tryParse(
                                                                        widget
                                                                            .contractor
                                                                            .overallRating,
                                                                      ) ??
                                                                      0)
                                                                  .toStringAsFixed(
                                                                    1,
                                                                  ),

                                                              style: TextStyle(
                                                                fontSize:
                                                                    AppFontSizes
                                                                        .small,
                                                                fontWeight:
                                                                    AppFontWeights
                                                                        .bold,
                                                                color:
                                                                    ColorRes
                                                                        .primary,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              "(${Formatter.formatNumber(widget.contractor.totalReviews)})",
                                                              style: TextStyle(
                                                                fontSize:
                                                                    AppFontSizes
                                                                        .caption,
                                                                color:
                                                                    ColorRes
                                                                        .leadGreyColor
                                                                        .shade700,
                                                                fontWeight:
                                                                    AppFontWeights
                                                                        .medium,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                    // Rating (only if valid)
                                                  ],
                                                ),
                                                SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    if (widget
                                                                .contractor
                                                                .contractorType !=
                                                            null &&
                                                        widget
                                                            .contractor
                                                            .contractorType!
                                                            .isNotEmpty) ...[
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: ColorRes
                                                              .primary
                                                              .withOpacity(
                                                                0.05,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                6,
                                                              ),
                                                          border: Border.all(
                                                            color: ColorRes
                                                                .primary
                                                                .withOpacity(
                                                                  0.3,
                                                                ),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          widget
                                                              .contractor
                                                              .contractorType!,
                                                          style: TextStyle(
                                                            fontSize:
                                                                AppFontSizes
                                                                    .caption,
                                                            fontWeight:
                                                                AppFontWeights
                                                                    .medium,
                                                            color:
                                                                ColorRes
                                                                    .primary,
                                                          ),
                                                        ),
                                                      ),
                                                    ],

                                                    if (widget
                                                            .contractor
                                                            .subscription
                                                            .hasPremiumPlan ||
                                                        widget.isPremium) ...[
                                                      SizedBox(width: 6),

                                                      Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: ColorRes
                                                              .orangeColor
                                                              .withOpacity(
                                                                0.05,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                6,
                                                              ),
                                                          border: Border.all(
                                                            color: ColorRes
                                                                .orangeColor
                                                                .withOpacity(
                                                                  0.3,
                                                                ),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          'Premium',
                                                          style: TextStyle(
                                                            fontSize:
                                                                AppFontSizes
                                                                    .caption,
                                                            fontWeight:
                                                                AppFontWeights
                                                                    .medium,
                                                            color:
                                                                ColorRes
                                                                    .orangeColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),

                            // Location (only if city exists)
                            Obx(() {
                              final city =
                                  contractorServiceController
                                      .userData
                                      .value
                                      ?.city;

                              if (city == null || city.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              return Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      color: ColorRes.primary,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        'Provides service in $city',
                                        style: TextStyle(
                                          fontSize: AppFontSizes.caption,
                                          fontWeight: AppFontWeights.medium,
                                          color:
                                              ColorRes.leadGreyColor.shade600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 12),

                            // ---------------- CONTACT BUTTON ----------------
                            // Obx(
                            //   () => SizedBox(
                            //     width: double.infinity,
                            //     child: ElevatedButton(
                            //       onPressed: () {
                            //         if (UserHelper.isGuest) {
                            //           Get.to(() => LoginScreen());
                            //         }
                            //
                            //         if (isListSelectable.value) {
                            //           if (contractorServiceController
                            //               .selectedItems
                            //               .isEmpty) {
                            //             Get.snackbar(
                            //               "No Service Selected",
                            //               "Please select at least one service to continue",
                            //               snackPosition: SnackPosition.BOTTOM,
                            //             );
                            //             return;
                            //           }
                            //           contactContractor();
                            //           return;
                            //         }
                            //
                            //         isListSelectable.value = true;
                            //       },
                            //       style: ElevatedButton.styleFrom(
                            //         backgroundColor: ColorRes.primary,
                            //         padding: const EdgeInsets.symmetric(vertical: 14),
                            //         shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(10),
                            //         ),
                            //       ),
                            //       child: Text(
                            //         UserHelper.isGuest
                            //             ? "Login to Contact"
                            //             : isListSelectable.value
                            //             ? "Contact Now"
                            //             : "Select Services",
                            //         style: TextStyle(
                            //           fontSize: AppFontSizes.bodySmall,
                            //           fontWeight: AppFontWeights.semiBold,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            /*   Obx(() {
                      final bool isSelectable = isListSelectable.value;
                      final bool isGuest = UserHelper.isGuest;
        
                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (isGuest) {
                                  Get.to(() => LoginScreen());
                                  return;
                                }
        
                                AppLogger(
                                  "Check any Contractor id ",
                                  widget.contractor.toJson(),
                                );
                                AppLogger(
                                  "Check any Current UserId id ",
                                  currentUserId.value,
                                );
                               if(currentUserId.value!=widget.contractor.userId)
                                 {
                                   if (isSelectable) {
                                     if (contractorServiceController
                                         .selectedItems
                                         .isEmpty) {
                                       NesticoPeSnackBar.showAwesomeSnackbar(
                                         title: 'No Service Selected',
                                         message:
                                         "Please select at least one service to continue",
                                         contentType: ContentType.failure,
                                       );
                                       return;
                                     }
                                     contactContractor();
                                   } else {
                                     isListSelectable.value = true;
                                   }
                                 }else{
        
                               }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:currentUserId.value!=widget.contractor.userId? ColorRes.primary:ColorRes.leadGreyColor.shade300,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                isGuest
                                    ? "Login to Contact"
                                    : isSelectable
                                    ? "Contact Now"
                                    : "Select Services",
                                style: TextStyle(
                                  fontSize: AppFontSizes.bodySmall,
                                  fontWeight: AppFontWeights.semiBold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
        */
                            Obx(() {
                              final bool isGuest = UserHelper.isGuest;
                              final bool isOwnService =
                                  currentUserId.value ==
                                  widget.contractor.userId;
                              final bool hasSelection =
                                  contractorServiceController
                                      .selectedItems
                                      .isNotEmpty;
                              final bool enabled =
                                  !isGuest && !isOwnService && hasSelection;

                              return Column(
                                children: [
                                  // if (isGuest)
                                  //   SizedBox(
                                  //     width: double.infinity,
                                  //     child: ElevatedButton(
                                  //       onPressed: () {
                                  //         Get.to(() => OtpLoginScreen());
                                  //       },
                                  //       style: ElevatedButton.styleFrom(
                                  //         backgroundColor: ColorRes.primary,
                                  //         padding: const EdgeInsets.symmetric(vertical: 14),
                                  //         shape: RoundedRectangleBorder(
                                  //           borderRadius: BorderRadius.circular(10),
                                  //         ),
                                  //       ),
                                  //       child: const Text(
                                  //         "Login to Contact",
                                  //         style: TextStyle(
                                  //           fontSize: AppFontSizes.bodySmall,
                                  //           fontWeight: AppFontWeights.semiBold,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   )
                                  // else
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorRes.leadGreyColor.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: ColorRes.leadGreyColor.shade300
                                              .withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 4,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            if (_contactController
                                                .primaryPhone
                                                .value
                                                .isEmpty) {
                                              await _contactController
                                                  .loadContacts(reset: true);
                                            }
                                            final number =
                                                _contactController
                                                    .primaryPhone
                                                    .value;
                                            if (number.isNotEmpty) {
                                              await ContactHelper.openDialer(
                                                number,
                                              );
                                            }
                                          },
                                          child: Container(
                                            height: 44,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 16,
                                            ),
                                            decoration: BoxDecoration(
                                              color: ColorRes.primary
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.call,
                                                color: ColorRes.primary,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () async {
                                            if (_contactController
                                                .primaryPhone
                                                .value
                                                .isEmpty) {
                                              await _contactController
                                                  .loadContacts(reset: true);
                                            }
                                            final number =
                                                _contactController
                                                    .primaryPhone
                                                    .value;
                                            if (number.isNotEmpty) {
                                              await ContactHelper.openWhatsApp(
                                                number,
                                              );
                                            }
                                          },
                                          child: Container(
                                            height: 44,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 16,
                                            ),
                                            decoration: BoxDecoration(
                                              color: ColorRes.green.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                                'assets/images/whatsapp.png',
                                                width: 20,
                                                height: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 25),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (UserHelper.isGuest) {
                                                Get.to(() => OtpLoginScreen());
                                              }
                                              if (enabled) {
                                                contactContractor();
                                              } else {
                                                NesticoPeSnackBar.showAwesomeSnackbar(
                                                  title: 'No Service Selected',
                                                  message:
                                                      "Please select at least one service to continue",
                                                  contentType:
                                                      ContentType.failure,
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  enabled
                                                      ? ColorRes.primary
                                                      : UserHelper.isGuest
                                                      ? ColorRes.primary
                                                      : ColorRes
                                                          .leadGreyColor
                                                          .shade300,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              !UserHelper.isGuest
                                                  ? "Contact Contractor"
                                                  : "Login to Contact",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight:
                                                    AppFontWeights.semiBold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isOwnService) ...[
                                    const SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.red.shade200,
                                        ),
                                      ),
                                      child: Text(
                                        "Contractors cannot submit inquiries for their own services.",
                                        style: TextStyle(
                                          color: Colors.red.shade700,
                                          fontSize: AppFontSizes.caption,
                                          fontWeight: AppFontWeights.medium,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              );
                            }),

                            const SizedBox(height: 12),

                            Row(
                              children: [
                                _statCard(
                                  "Total Services",
                                  Formatter.formatNumber(
                                    widget.contractor.totalServices,
                                  ),
                                  bgColor: Colors.blue.shade50,
                                  valueColor: Colors.blue,
                                ),
                                Obx(() {
                                  final activeCount =
                                      contractorServiceController.items
                                          .where((s) => s.isActive == true)
                                          .length;
                                  return _statCard(
                                    "Active Services",
                                    Formatter.formatNumber(activeCount),
                                    bgColor: Colors.green.shade50,
                                    valueColor: Colors.green,
                                  );
                                }),
                              ],
                            ),
                            const SizedBox(height: 12),

                            Row(
                              children: [
                                _statCard(
                                  "Projects",
                                  Formatter.formatNumber(
                                    widget
                                        .contractor
                                        .projectStats
                                        .totalProjects,
                                  ),
                                  bgColor: Colors.orange.shade50,
                                  valueColor: Colors.orange,
                                ),
                                _statCard(
                                  "Experience",
                                  "${Formatter.formatNumber(widget.contractor.totalExperience)} years",
                                  // highlight: true,
                                  bgColor: ColorRes.lightPurpleColor
                                      .withOpacity(0.1),
                                  valueColor: ColorRes.lightPurpleColor,
                                  titleColor: ColorRes.lightPurpleColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // ---------------- SECTION TITLE ----------------
                      Obx(() {
                        final activeCount =
                            contractorServiceController.items
                                .where((s) => s.isActive == true)
                                .length;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Services Offered ($activeCount)",
                                  style: TextStyle(
                                    fontSize: AppFontSizes.body,
                                    fontWeight: AppFontWeights.semiBold,
                                    color: ColorRes.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 14),
                      // ---------------- CATEGORY TABS ----------------
                      Obx(() {
                        // Observe services so tabs update when list loads.
                        // Use only active services
                        final allItems =
                            contractorServiceController.items
                                .where((s) => s.isActive == true)
                                .toList();
                        final serviceCategoryIds =
                            allItems.map((s) => s.category).toSet();

                        if (_topCategoryController.isLoading.value &&
                            _topCategoryController.categories.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        final categories =
                            _topCategoryController.categories
                                .where((c) => serviceCategoryIds.contains(c.id))
                                .toList();

                        if (categories.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        var selectedId = _selectedServiceCategoryId.value;
                        if (selectedId.isEmpty ||
                            !serviceCategoryIds.contains(selectedId)) {
                          selectedId = categories.first.id;
                          Future.microtask(() {
                            if (_selectedServiceCategoryId.value !=
                                selectedId) {
                              _selectedServiceCategoryId.value = selectedId;
                            }
                          });
                        }

                        return SizedBox(
                          height: 35,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(width: 10),
                            itemBuilder: (context, index) {
                              final cat = categories[index];
                              final id = cat.id;
                              final label = cat.name;
                              final isSelected = selectedId == id;

                              return InkWell(
                                borderRadius: BorderRadius.circular(24),
                                onTap:
                                    () => _selectedServiceCategoryId.value = id,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? ColorRes.primary
                                            : ColorRes.white,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? ColorRes.primary
                                              : ColorRes.primary,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      label.capitalize?.replaceAll('_', ' ') ??
                                          label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: AppFontSizes.small,
                                        fontWeight: AppFontWeights.semiBold,
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : ColorRes.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                      const SizedBox(height: 14),
                      // ---------------- SELECTED SERVICES COUNT ----------------
                      Obx(() {
                        if (contractorServiceController
                            .selectedItems
                            .isNotEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 14),
                              decoration: BoxDecoration(
                                color: ColorRes.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: ColorRes.primary),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${contractorServiceController.selectedItems.length} service(s) selected",
                                    style: TextStyle(
                                      fontSize: AppFontSizes.bodySmall,
                                      fontWeight: AppFontWeights.semiBold,
                                      color: ColorRes.primary,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      contractorServiceController
                                          .clearSelection();
                                    },
                                    child: Text(
                                      "Clear All",
                                      style: TextStyle(
                                        fontSize: AppFontSizes.bodySmall,
                                        color: ColorRes.error,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                      // ---------------- LOGIN ALERT ----------------
                      if (UserHelper.isGuest) ...[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: ColorRes.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.info_outline, color: ColorRes.primary),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Please login to select services and contact the contractor.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      // ---------------- SERVICE CARDS ----------------
                      Obx(() {
                        // Only display active services
                        final allItems =
                            contractorServiceController.items
                                .where((s) => s.isActive == true)
                                .toList();
                        final serviceCategoryIds =
                            allItems.map((s) => s.category).toSet();
                        final categories =
                            _topCategoryController.categories
                                .where((c) => serviceCategoryIds.contains(c.id))
                                .toList();

                        String? effectiveCategoryId;
                        if (categories.isNotEmpty) {
                          var id = _selectedServiceCategoryId.value;
                          if (id.isEmpty || !serviceCategoryIds.contains(id)) {
                            id = categories.first.id;
                            Future.microtask(() {
                              if (_selectedServiceCategoryId.value != id) {
                                _selectedServiceCategoryId.value = id;
                              }
                            });
                          }
                          effectiveCategoryId = id;
                        }

                        final filteredItems =
                            effectiveCategoryId != null
                                ? allItems
                                    .where(
                                      (s) => s.category == effectiveCategoryId,
                                    )
                                    .toList()
                                : allItems;

                        if (contractorServiceController.isLoading.value &&
                            allItems.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (!contractorServiceController.isLoading.value &&
                            allItems.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: ColorRes.leadGreyColor.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Text("No services found."),
                              ),
                            ),
                          );
                        }

                        if (!contractorServiceController.isLoading.value &&
                            filteredItems.isEmpty) {
                          // return Center(
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(16.0),
                          //     child:  Container(child: Text("No services found in category.")),
                          //   ),
                          // );
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 28),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                style: BorderStyle.solid,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /// Circle with plus icon
                                Container(
                                  height: 56,
                                  width: 56,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.shade200,
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 24,
                                    color: Colors.grey.shade500,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                /// Text
                                Text(
                                  "No services found in category",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            final data = filteredItems[index];

                            // print("Contractor Data of Service ${data.toJson()}");

                            return ServiceCard(
                              service: data,
                              isSelectable: !UserHelper.isGuest,
                              tag: widget.contractor.userId,
                            );
                          },
                          separatorBuilder:
                              (context, index) => SizedBox(height: 16),
                          itemCount: filteredItems.length,
                        );
                      }),
                      // Loading indicator for pagination
                      Obx(() {
                        if (contractorServiceController.isLoading.value &&
                            contractorServiceController.items.isNotEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                      // const SizedBox(height: 20),

                      // ---------------- OTHER CONTRACTORS (HORIZONTAL) ----------------
                      Obx(() {
                        // Hide section when viewing own profile
                        if (currentUserId.value == widget.contractor.userId) {
                          return const SizedBox.shrink();
                        }

                        if (otherCtrl.isLoading.value &&
                            otherCtrl.items.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        final list =
                            otherCtrl.items
                                .where(
                                  (c) => c.userId != widget.contractor.userId,
                                )
                                .toList();

                        if (list.isEmpty) return const SizedBox.shrink();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Text(
                                'Other Contractors',
                                style: TextStyle(
                                  fontSize: AppFontSizes.body,
                                  fontWeight: AppFontWeights.semiBold,
                                  color: ColorRes.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 180,

                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                // padding: const EdgeInsets.symmetric(horizontal: 4),
                                padding: EdgeInsets.only(left: 16),
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  final c = list[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: _ContractorMiniCard(
                                      contractor: c,
                                      compare: compare,
                                    ),
                                  );
                                },
                              ),
                            ),
                             SizedBox(height: 20),
                          ],
                        );
                      }),
                      // const SizedBox(height: 30),
                      // const SizedBox(height: 84),
                      Obx(() {
                        final propertyCount =
                            Get.isRegistered<CompareManager>()
                                ? Get.find<CompareManager>().count
                                : 0;
                        final projectCount =
                            Get.isRegistered<ProjectCompareManager>()
                                ? Get.find<ProjectCompareManager>().count
                                : 0;
                        final contractorCount =
                            Get.isRegistered<ContractorCompareManager>()
                                ? Get.find<ContractorCompareManager>().count
                                : 0;

                        final showUnifiedComparisonFloatingButton =
                            propertyCount > 0 ||
                            projectCount > 0 ||
                            contractorCount > 0;

                        return SizedBox(
                          height: showUnifiedComparisonFloatingButton ? 84 : 0,
                        );
                      }),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              const UnifiedComparisonFloatingButton(bottom: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomActionBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),

        /// 🔥 Strong visible shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, -4), // 👈 important (shadow goes UP)
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: _bottomActionButton(
                label: 'Call',
                icon: Icons.call,
                background: ColorRes.primary.withOpacity(0.1),
                foreground: ColorRes.primary,
                onTap: _handleCallTap,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _bottomActionButton(
                label: 'Chat',
                iconWidget: Image.asset(
                  'assets/images/whatsapp.png',
                  width: 18,
                  height: 18,
                ),
                background: ColorRes.green.withOpacity(0.12),
                foreground: ColorRes.green,
                onTap: _handleWhatsappTap,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _bottomActionButton(
                label: 'Support',
                icon: Icons.support_agent,
                background: const Color(0xFFF1F5F9),
                foreground: ColorRes.textPrimary,
                onTap: _openSupport,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomActionButton({
    required String label,
    IconData? icon,
    Widget? iconWidget,
    required Color background,
    required Color foreground,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconWidget != null) iconWidget,
            if (iconWidget == null && icon != null)
              Icon(icon, size: 18, color: foreground),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppFontSizes.bodySmall,
                  fontWeight: AppFontWeights.semiBold,
                  color: foreground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCallTap() async {
    if (_contactController.primaryPhone.value.isEmpty) {
      await _contactController.loadContacts(reset: true);
    }
    final number = _contactController.primaryPhone.value;
    if (number.isNotEmpty) {
      await ContactHelper.openDialer(number);
    }
  }

  Future<void> _handleWhatsappTap() async {
    if (_contactController.primaryPhone.value.isEmpty) {
      await _contactController.loadContacts(reset: true);
    }
    final number = _contactController.primaryPhone.value;
    if (number.isNotEmpty) {
      await ContactHelper.openWhatsApp(number);
    }
  }

  Future<void> _openSupport() async {
    Get.put(SocketController());
    try {
      final service = TicketService();
      if (UserHelper.isGuest) {
        final storedId = await SecureStorage.getSupportTicketId();
        if (storedId != null && storedId.isNotEmpty) {
          final t = TicketItem(
            id: storedId,
            status: 'open',
            title: 'Support Ticket',
          );
          Get.to(() => SupportTicketChatScreen(ticketId: t.id!, ticket: t));
        } else {
          Get.to(() => const SupportTicketChatScreen(createOnFirstSend: true));
        }
      } else if (UserHelper.isBuyer) {
        // Buyer: use API to find existing ticket by created_by; no secure storage
        final user = await SecureStorage.getUserData();
        final userId = user?.user?.id ?? '';
        final resp = await service.fetchTickets(
          page: 1,
          filters: {'created_by': userId, 'limit': '100'},
        );
        final items = resp.items;
        log('Fetched tickets: $items');

        if (items.isNotEmpty && (items.first.id?.isNotEmpty ?? false)) {
          final id = items.first.id!;
          final ticket = await service.fetchTicketById(id) ?? items.first;

          print(" Ticket item that shgo ${items.map((e) => e.id)}");
          Get.to(() => SupportTicketChatScreen(ticketId: id, ticket: ticket));
        } else {
          // No previous ticket found → create on first send
          Get.to(() => const SupportTicketChatScreen(createOnFirstSend: true));
        }
      } else {
        // Other roles: prefer existing open ticket; fallback to first-message screen
        final response = await service.fetchTickets(
          page: 1,
          filters: {'status': 'open'},
        );
        final List<TicketItem> items = response.items;
        if (items.isNotEmpty && (items.first.id?.isNotEmpty ?? false)) {
          final t = items.first;
          Get.to(() => SupportTicketChatScreen(ticketId: t.id!, ticket: t));
        } else {
          Get.to(() => const InstantSupportChatScreen());
        }
      }
    } catch (_) {
      Get.to(() => const InstantSupportChatScreen());
    }
  }

  void _goToDashboard() {
    if (Navigator.of(context).canPop()) {
      Get.back();
      return;
    }
    Get.offAllNamed('/dashboard', predicate: (route) => false);
  }

  String getDisplayName({
    String? contractorFirstName,
    String? contractorLastName,
    String? userName,
  }) {
    final fullName =
        '${contractorFirstName ?? ''} ${contractorLastName ?? ''}'.trim();

    if (fullName.isNotEmpty) {
      return fullName;
    }

    return userName?.trim().isNotEmpty == true ? userName!.trim() : 'User';
  }

  String getAvatarLetter(String name) {
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Widget buildProfileAvatar({
    required String displayName,
    String? profilePic,
    double radius = 22,
  }) {
    final hasImage = profilePic != null && profilePic.isNotEmpty;

    if (hasImage) {
      final size = radius * 2;
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: profilePic!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (context, url) => ShimmerShapes.circle(size: size),
          errorWidget:
              (context, url, error) => CircleAvatar(
                radius: radius,
                backgroundColor: ColorRes.primary,
                child: Icon(
                  Icons.design_services_outlined,
                  color: Colors.white,
                  size: radius,
                ),
              ),
        ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: ColorRes.primary,
      child: Icon(
        Icons.design_services_outlined,
        color: Colors.white,
        size: radius,
      ),
    );
  }

  Widget _statCard(
    String title,
    String value, {
    bool highlight = false,
    Color? bgColor,
    Color? valueColor,
    Color? titleColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: bgColor ?? Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.mediumLarge),

          /// 🔥 Shadow added
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,

              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: AppFontSizes.large,
                fontWeight: AppFontWeights.semiBold,
                color:
                    valueColor ??
                    (highlight ? ColorRes.primary : ColorRes.black),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.caption,
                fontWeight: AppFontWeights.semiBold,
                color: titleColor ?? ColorRes.leadGreyColor.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatefulWidget {
  final bool isSelectable;
  final ContractorServiceItem service;
  final String tag;

  const ServiceCard({
    super.key,
    required this.service,
    required this.isSelectable,
    required this.tag,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  final PageController _pageController = PageController(viewportFraction: 0.9);

  bool _expanded = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool showAllMeta = false;

  @override
  Widget build(BuildContext context) {
    final contractorController = Get.find<ContractorServiceController>(
      tag: widget.tag,
    );
    var meta = widget.service.meta;
    final metaMaps = [
      cleanMetaMap({
        "Cement": meta.cementBrand,
        "Steel": meta.steelBrand,
        "Bricks": meta.brickType,
        "Sand": meta.sandSource,
        "Tank": meta.waterTankBrand,
      }),
      cleanMetaMap({
        "Wires": meta.electricalWiresBrand,
        "Switches": meta.electricalSwitchesBrand,
        "Pipes": meta.plumbingPipesBrand,
        "Sanitary": meta.sanitaryFittingsBrand,
      }),
      cleanMetaMap({
        "Flooring": meta.flooringTilesBrand,
        "Interior Paint": meta.interiorPaintBrand,
        "Exterior Paint": meta.exteriorPaintBrand,
        "False Ceiling": meta.falseCeiling,
        "Fabrication": meta.fabricationWork,
      }),
      cleanMetaMap({
        "Doors": meta.doorsType,
        "Windows": meta.windowsType,
        "Structure": meta.structure,
        "Plaster": meta.plasterType,
        "Waterproofing": meta.waterproofing,
        "Railing": meta.railingType,
        "Chokhat": meta.chokhatType,
      }),
      cleanMetaMap({
        "Solar Panel": meta.solarPanelBrands,
        "Solar Inverter": meta.solarInverterBrands,
      }),
      cleanMetaMap({
        "Security": meta.securityBrands,
        "Smart Home": meta.smartHomeBrands,
      }),
      cleanMetaMap({
        "Machine": meta.machineBrands,
        "Cladding": meta.claddingBrands,
      }),
    ];
    final metaSections = [
      if (metaMaps[0].isNotEmpty)
        _metaSection(
          icon: Icons.home_work,
          title: "Construction Materials",
          data: metaMaps[0],
        ),
      if (metaMaps[1].isNotEmpty)
        _metaSection(
          icon: Icons.electrical_services,
          title: "Electrical & Plumbing",
          data: metaMaps[1],
        ),
      if (metaMaps[2].isNotEmpty)
        _metaSection(
          icon: Icons.format_paint,
          title: "Finishing",
          data: metaMaps[2],
        ),
      if (metaMaps[3].isNotEmpty)
        _metaSection(
          icon: Icons.apartment,
          title: "Structure & Safety",
          data: metaMaps[3],
        ),
      if (metaMaps[4].isNotEmpty)
        _metaSection(
          icon: Icons.solar_power,
          title: "Solar",
          data: metaMaps[4],
        ),
      if (metaMaps[5].isNotEmpty)
        _metaSection(
          icon: Icons.security,
          title: "Security & Smart Home",
          data: metaMaps[5],
        ),
      if (metaMaps[6].isNotEmpty)
        _metaSection(
          icon: Icons.construction,
          title: "Machinery & Cladding",
          data: metaMaps[6],
        ),
    ];

    final safeMetaSections =
        metaSections?.where((e) => e != null).toList() ?? [];
    final hasAnyMetaData = metaMaps.any((map) => map.isNotEmpty);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
        border:
            widget.isSelectable
                ? Border.all(
                  color:
                      widget.isSelectable &&
                              contractorController.selectedItems.contains(
                                widget.service,
                              )
                          ? ColorRes.primary
                          : ColorRes.leadGreyColor.shade300,
                  width:
                      widget.isSelectable &&
                              contractorController.selectedItems.contains(
                                widget.service,
                              )
                          ? 2
                          : 1,
                )
                : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 2,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with checkbox ------------------
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isSelectable) ...[
                  Obx(
                    () => Checkbox(
                      value: contractorController.selectedItems.contains(
                        widget.service,
                      ),
                      onChanged: (value) {
                        contractorController.toggleSelectedService(
                          widget.service,
                        );
                      },
                      activeColor: ColorRes.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.service.serviceName.capitalize?.replaceAll(
                                    "_",
                                    " ",
                                  ) ??
                                  '',
                              style: TextStyle(
                                fontSize: AppFontSizes.bodyMedium,
                                fontWeight: AppFontWeights.semiBold,
                                color: ColorRes.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: ColorRes.warning,
                                size: 18,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${(double.tryParse(widget.service.averageRating ?? '') ?? 0).toStringAsFixed(1)} (${widget.service.totalReviews ?? 0})',
                                style: TextStyle(
                                  fontSize: AppFontSizes.small,
                                  fontWeight: AppFontWeights.medium,
                                ),
                              ),
                              const SizedBox(width: 6),

                              // Expand / Collapse button
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.service.description,
                        style: TextStyle(
                          fontSize: AppFontSizes.caption,
                          fontWeight: AppFontWeights.medium,
                          color: ColorRes.leadGreyColor.shade700,
                        ),
                      ),

                      // ReadMoreClass(
                      //   description: widget.service.description,
                      //   trimLines: 3,
                      //   size: AppFontSizes.caption,
                      //   colorClickableText: ColorRes.primary,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (meta.works != null && meta.works!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Divider(color: ColorRes.leadGreyColor.shade300, height: 1),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Main Services",
                    style: TextStyle(
                      fontSize: AppFontSizes.bodyMedium,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColorRes.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ColorRes.border, width: 1),
                    ),
                    child: Text(
                      meta.works!
                          .map(
                            (w) => w.replaceAll('_', ' ').capitalizeFirst ?? w,
                          )
                          .join(',  '),
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        fontWeight: AppFontWeights.medium,
                        color: ColorRes.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (widget.service.serviceImage != null &&
              widget.service.serviceImage!.isNotEmpty)
            Column(
              children: [
                SizedBox(
                  height: 180,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.service.serviceImage!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppRadius.mediumLarge,
                            ),
                            border: Border.all(
                              color: ColorRes.border,
                              width: 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppRadius.mediumLarge,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: widget.service.serviceImage![index],
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) => ShimmerShapes.rounded(
                                    width: double.infinity,
                                    height: 180,

                                    borderRadius: AppRadius.mediumLarge,
                                  ),
                              errorWidget:
                                  (context, url, error) => Container(
                                    height: 180,
                                    width: double.infinity,

                                    color: ColorRes.leadGreyColor.shade200,
                                    child: const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (widget.service.serviceImage!.length > 1) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: widget.service.serviceImage!.length,
                      effect: ScrollingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: ColorRes.primary,
                        dotColor: ColorRes.disabled,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
              ],
            ),

          Divider(color: ColorRes.leadGreyColor.shade300, height: 1),
          // Middle section and rest of details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _detailColumn(
                  "AVAILABILITY",
                  widget.service.meta.workAvailability ?? '',
                ),
                _detailColumn(
                  "Visiting Charge",
                  '₹${widget.service.meta.visitCharge.toString()}',
                ),
              ],
            ),
          ),
          Divider(color: ColorRes.leadGreyColor.shade300, height: 1),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _detailColumn("PRICE", widget.service.meta.priceRange),
          ),
          // Features list and remaining content follows unchanged
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                _feature(
                  widget.service.meta.provideMaterials ?? false,
                  "Materials Provided",
                ),
                const SizedBox(height: 6),
                _feature(
                  widget.service.meta.equipmentProvided ?? false,
                  "Equipment Provided",
                ),
                const SizedBox(height: 6),
                _feature(
                  widget.service.meta.insuranceAvailable ?? false,
                  "Insurance Available",
                ),
              ],
            ),
          ),
          Divider(color: ColorRes.leadGreyColor.shade300, height: 1),
          // Bottom section ----------
          // Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Expanded(
          //         child: _detailColumn(
          //           "ADVANCE REQUIRED",
          //           "${widget.service.meta.advanceRequiredPercentage}%",
          //         ),
          //       ),
          //       Expanded(
          //         child: _detailColumn(
          //           "PAYMENT MODES",
          //           widget.service.meta.acceptedPaymentModes
          //                   ?.map((e) => e.replaceAll("_", " ").capitalize)
          //                   .join(", ") ??
          //               '',
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'ADVANCE REQUIRED',
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorRes.leadGreyColor.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'PAYMENT MODES',
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorRes.leadGreyColor.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${widget.service.meta.advanceRequiredPercentage}%',
                        style: TextStyle(
                          fontSize: AppFontSizes.medium,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.textPrimary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${widget.service.meta.acceptedPaymentModes?.map((e) => e.replaceAll("_", " ").capitalize).join(", ") ?? ''}',
                        style: TextStyle(
                          fontSize: AppFontSizes.medium,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (hasAnyMetaData) ...[
            Divider(color: ColorRes.leadGreyColor.shade300, height: 1),
            const SizedBox(height: 15),
            ...metaSections
                .take(showAllMeta ? metaSections.length : 2)
                .toList(),

            if (metaSections.length > 2)
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    setState(() => showAllMeta = !showAllMeta);
                  },
                  icon: Icon(
                    showAllMeta ? Icons.expand_less : Icons.expand_more,
                  ),
                  label: Text(
                    showAllMeta ? "Show less details" : "Show more details",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
          ],

          if ([
            meta.threeDDesign,
            meta.modularKitchen,
            meta.boreAndPump,
            meta.securitySystems,
            meta.homeAutomation,
            meta.solarSolutions,
          ].any((e) => e != null)) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.add_box_outlined,
                    color: ColorRes.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Additional Services",
                    style: TextStyle(
                      fontSize: AppFontSizes.bodyMedium,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _yesNoChip("3D Design", meta.threeDDesign),
                  _yesNoChip("Modular Kitchen", meta.modularKitchen),
                  _yesNoChip("Bore & Pump", meta.boreAndPump),
                  _yesNoChip("Security", meta.securitySystems),
                  _yesNoChip("Home Auto.", meta.homeAutomation),
                  _yesNoChip("Solar", meta.solarSolutions),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ],

        // Divider(color: ColorRes.leadGreyColor.shade300, height: 1),
        // // Middle section ----------
        // Padding(
        //   padding: const EdgeInsets.all(16),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       _detailColumn(
        //         "AVAILABILITY",
        //         widget.service.meta.workAvailability ?? '',
        //       ),
        //       _detailColumn(
        //         "Visiting Charge",
        //         '₹${widget.service.meta.visitCharge.toString()}',
        //         highlight: true,
        //       ),
        //     ],
        //   ),
        // ),
        // Divider(color: ColorRes.leadGreyColor.shade300, height: 1),
        // SizedBox(height: 10),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   child: _detailColumn("PRICE", widget.service.meta.priceRange),
        // ),
        // // Features list -----------
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        //   child: Column(
        //     children: [
        //       _feature(
        //         widget.service.meta.provideMaterials ?? false,
        //         "Materials Provided",
        //       ),
        //       const SizedBox(height: 6),
        //       _feature(
        //         widget.service.meta.equipmentProvided ?? false,
        //         "Equipment Provided",
        //       ),
        //       const SizedBox(height: 6),
        //       _feature(
        //         widget.service.meta.insuranceAvailable ?? false,
        //         "Insurance Available",
        //       ),
        //     ],
        //   ),
        // ),
        // Divider(color: ColorRes.leadGreyColor.shade300, height: 1),
        // // Bottom section ----------
        // Padding(
        //   padding: const EdgeInsets.all(16),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Expanded(
        //         child: _detailColumn(
        //           "ADVANCE REQUIRED",
        //           "${widget.service.meta.advanceRequiredPercentage}%",
        //         ),
        //       ),
        //       Expanded(
        //         child: _detailColumn(
        //           "PAYMENT MODES",
        //           widget.service.meta.acceptedPaymentModes
        //                   ?.map((e) => e.replaceAll("_", " ").capitalize)
        //                   .join(", ") ??
        //               '',
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // if (meta.works != null && meta.works!.isNotEmpty) ...[
        //   Divider(color: ColorRes.leadGreyColor.shade300, height: 1),
        //   const SizedBox(height: 12),
        //   Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 16),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text(
        //           "Specific Services / Works",
        //           style: TextStyle(
        //             fontSize: AppFontSizes.medium,
        //             fontWeight: AppFontWeights.semiBold,
        //             color: ColorRes.textPrimary,
        //           ),
        //         ),
        //         const SizedBox(height: 8),
        //         Container(
        //           width: double.infinity,
        //           padding: const EdgeInsets.all(12),
        //           decoration: BoxDecoration(
        //             color: ColorRes.background,
        //             borderRadius: BorderRadius.circular(12),
        //             border: Border.all(color: ColorRes.border, width: 1),
        //           ),
        //           child: Text(
        //             meta.works!
        //                 .map(
        //                   (w) => w.replaceAll('_', ' ').capitalizeFirst ?? w,
        //                 )
        //                 .join(', '),
        //             style: TextStyle(
        //               fontSize: AppFontSizes.caption,
        //               fontWeight: AppFontWeights.medium,
        //               color: ColorRes.primary,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        //   const SizedBox(height: 12),
        // ],

        // if (hasAnyMetaData) ...[
        //   Divider(color: ColorRes.leadGreyColor.shade300, height: 1),
        //   SizedBox(height: 15),
        //   ...metaSections
        //       .take(showAllMeta ? metaSections.length : 2)
        //       .toList(),

        //   if (metaSections.length > 2)
        //     Center(
        //       child: TextButton.icon(
        //         onPressed: () {
        //           setState(() => showAllMeta = !showAllMeta);
        //         },
        //         icon: Icon(
        //           showAllMeta ? Icons.expand_less : Icons.expand_more,
        //         ),
        //         label: Text(
        //           showAllMeta ? "Show less details" : "Show more details",
        //         ),
        //       ),
        //     ),
        // ],

        // if ([
        //   meta.threeDDesign,
        //   meta.modularKitchen,
        //   meta.boreAndPump,
        //   meta.securitySystems,
        //   meta.homeAutomation,
        //   meta.solarSolutions,
        // ].any((e) => e != null)) ...[
        //   Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 16),
        //     child: Row(
        //       children: [
        //         Icon(
        //           Icons.add_box_outlined,
        //           color: ColorRes.primary,
        //           size: 18,
        //         ),
        //         const SizedBox(width: 8),
        //         Text(
        //           "Additional Services",
        //           style: TextStyle(
        //             fontSize: AppFontSizes.medium,
        //             fontWeight: AppFontWeights.semiBold,
        //             color: ColorRes.textPrimary,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        //   const SizedBox(height: 8),
        //   Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 16),
        //     child: Wrap(
        //       spacing: 8,
        //       runSpacing: 8,
        //       children: [
        //         _yesNoChip("3D Design", meta.threeDDesign),
        //         _yesNoChip("Modular Kitchen", meta.modularKitchen),
        //         _yesNoChip("Bore & Pump", meta.boreAndPump),
        //         _yesNoChip("Security", meta.securitySystems),
        //         _yesNoChip("Home Auto.", meta.homeAutomation),
        //         _yesNoChip("Solar", meta.solarSolutions),
        //       ],
        //     ),
        //   ),
        //   SizedBox(height: 10),
        // ],
      ),
    );
  }

  Widget _yesNoChip(String label, String? value) {
    if (value == null) return const SizedBox();

    final isYes = value.toUpperCase() == "YES";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color:
            isYes
                ? ColorRes.success.withOpacity(0.08)
                : ColorRes.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isYes ? ColorRes.success.shade100 : ColorRes.error.shade100,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: AppFontWeights.medium,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: isYes ? ColorRes.success : ColorRes.error,
            ),
            child: Text(
              value,
              style: TextStyle(
                fontWeight: AppFontWeights.semiBold,
                fontSize: AppFontSizes.caption,
                color: ColorRes.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaSection({
    required IconData icon,
    required String title,
    required Map<String, List<String>?> data,
  }) {
    if (data.values.every((v) => v == null || v.isEmpty)) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: ColorRes.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: AppFontSizes.bodyMedium,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...data.entries.map((e) => _infoRow(e.key, e.value)),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _infoRow(String label, List<String>? values) {
    if (values == null || values.isEmpty) return const SizedBox();

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorRes.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: ColorRes.leadGreyColor.shade800,
                fontSize: AppFontSizes.caption,
                fontWeight: AppFontWeights.medium,
              ),
            ),
          ),
          SizedBox(width: 40),
          Expanded(
            child: Text(
              values.join(", "),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: ColorRes.textPrimary,
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<String>> cleanMetaMap(Map<String, List<String>?> raw) {
    final map = <String, List<String>>{};

    raw.forEach((key, value) {
      if (value != null && value.isNotEmpty) {
        map[key] = value;
      }
    });

    return map;
  }

  Widget _detailColumn(String title, String value, {bool highlight = false}) {
    // print("iudjiidfi ${value}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: ColorRes.leadGreyColor.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.replaceAll("_", " ").capitalize.toString(),
          style: TextStyle(
            fontSize: AppFontSizes.medium,
            fontWeight: AppFontWeights.semiBold,
            color: highlight ? ColorRes.green : ColorRes.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _feature(bool value, String title) {
    return Row(
      children: [
        Icon(
          value ? Icons.check_circle : Icons.cancel,
          color: value ? ColorRes.green : ColorRes.error,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: AppFontSizes.bodySmall,
            fontWeight: AppFontWeights.medium,
            color: ColorRes.leadGreyColor.shade800,
          ),
        ),
      ],
    );
  }
}

// class _ContractorMiniCard extends StatelessWidget {
//   final Contractor contractor;

//   const _ContractorMiniCard({Key? key, required this.contractor}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Get.to(() => ContractorProfileDetailsScreen(contractor: contractor));
//       },
//       child: Container(
//         width: 110,
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: ColorRes.border),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.03),
//               blurRadius: 2,
//               offset: const Offset(1, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             ClipOval(
//               child: CachedNetworkImage(
//                 imageUrl: contractor.imageUrl ?? '',
//                 width: 50,
//                 height: 50,
//                 fit: BoxFit.cover,
//                 placeholder: (c, u) => ShimmerShapes.circle(size: 50),
//                 errorWidget: (c, u, e) => CircleAvatar(
//                   radius: 25,
//                   backgroundColor: ColorRes.primary,
//                   child: Icon(
//                     Icons.design_services_outlined,
//                     color: Colors.white,
//                     size: 24,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               contractor.username ?? 'User',
//               overflow: TextOverflow.ellipsis,
//               maxLines: 1,
//               style: TextStyle(
//                 fontSize: AppFontSizes.extraSmall,
//                 fontWeight: AppFontWeights.semiBold,
//                 color: ColorRes.textPrimary,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               contractor.contractorType ?? '',
//               overflow: TextOverflow.ellipsis,
//               maxLines: 1,
//               style: TextStyle(
//                 fontSize: AppFontSizes.extraSmall,
//                 color: ColorRes.leadGreyColor.shade700,
//               ),
//             ),
//             const SizedBox(height: 6),
//             if (double.tryParse(contractor.overallRating.toString()) != null)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.star, color: Colors.amber, size: 14),
//                   const SizedBox(width: 4),
//                   Text(
//                     '${contractor.overallRating}',
//                     style: TextStyle(
//                       fontSize: AppFontSizes.extraSmall,
//                       fontWeight: AppFontWeights.bold,
//                       color: ColorRes.primary,
//                     ),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _ContractorMiniCard extends StatefulWidget {
  final Contractor contractor;
  final ContractorCompareManager compare;

  const _ContractorMiniCard({
    Key? key,
    required this.contractor,
    required this.compare,
  }) : super(key: key);

  @override
  State<_ContractorMiniCard> createState() => _ContractorMiniCardState();
}

class _ContractorMiniCardState extends State<_ContractorMiniCard> {
  @override
  Widget build(BuildContext context) {
    final rating = double.tryParse(widget.contractor.overallRating.toString());
    final initials =
        (widget.contractor.username ?? 'U')
            .trim()
            .split(' ')
            .take(2)
            .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
            .join();

    return GestureDetector(
      onTap:
          () => Get.to(
            () => ContractorProfileDetailsScreen(contractor: widget.contractor),
            routeName: '/contractor/${widget.contractor.id}',
          ),
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(16),
        // margin: const EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// Top row — avatar + name/type + rating
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /// Avatar with verified badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(48),
                      child: CachedNetworkImage(
                        imageUrl: widget.contractor.imageUrl ?? '',
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        placeholder: (c, u) => ShimmerShapes.circle(size: 48),
                        errorWidget:
                            (c, u, e) => Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: ColorRes.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                initials,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: ColorRes.primary,
                                ),
                              ),
                            ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 14),

                /// Name, tag, reviews
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.contractor.username.capitalize?.replaceAll(
                                    '_',
                                    ' ',
                                  ) ??
                                  'User',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          if (rating != null) ...[
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFEF9F27),
                              size: 15,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "(${widget.contractor.totalReviews ?? 0})",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 5),

                      Row(
                        children: [
                          const Icon(
                            Icons.work_outline_rounded,
                            size: 13,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${Formatter.formatNumber(widget.contractor.totalExperience) ?? '0'}+ yrs exp.",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.contractor.city ?? 'N/A',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          if (widget.contractor.contractorType != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: ColorRes.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                widget.contractor.contractorType!,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: ColorRes.primary,
                                ),
                              ),
                            ),
                            SizedBox(width: 8,),
                          if (widget.contractor.subscription.hasPremiumPlan)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: ColorRes.homeAmber.shade100,
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                'Premium',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: ColorRes.homeAmber,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            Divider(
              height: 1,
              thickness: 0.5,
              color: ColorRes.leadGreyColor.withOpacity(0.3),
            ),
            const SizedBox(height: 12),

            /// Bottom row — experience + location + CTA
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        () => Get.to(
                          () => ContractorProfileDetailsScreen(
                            contractor: widget.contractor,
                          ),
                          routeName: '/contractor/${widget.contractor.id}',
                        ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorRes.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text(
                      "View profile",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      widget.compare.toggle(widget.contractor, max: 5);
                    },
                    child: Obx(() {
                      final selected = widget.compare.isSelected(
                        widget.contractor.userId ?? '',
                      );

                      return Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: selected ? ColorRes.primary : ColorRes.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:
                                selected ? ColorRes.primary : ColorRes.border,
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.compare_arrows,
                              color:
                                  selected ? ColorRes.white : ColorRes.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              selected ? "Added" : "Compare",
                              style: TextStyle(
                                color:
                                    selected
                                        ? ColorRes.white
                                        : ColorRes.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
