import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/modules/auth/views/login_screen.dart';
import 'package:housing_flutter_app/modules/contractor/view/widget/contractor_inquiry_screen.dart';
import 'package:housing_flutter_app/modules/property_rating/view/widget/read_more_or_less.dart';
import 'package:housing_flutter_app/utils/logger/app_logger.dart';
import '../../../app/constants/app_font_sizes.dart';
import '../../../data/network/contractor/model/contractor_profile_model/contractor_profile_model.dart';
import '../../../data/network/contractor/model/contractot_service_model/contractor_service_model.dart';
import '../../../widgets/messages/snack_bar.dart';
import '../controllers/contractor_profile_service_controller/contractor_profile_service_controller.dart';
import 'contractor_add_inuiry_screen.dart';

class ContractorProfileDetailsScreen extends StatefulWidget {
  final Contractor contractor;
  final bool isPremium;

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

  final currentUserId = ''.obs;

  Future<void> contactContractor() async {
    final contractorServiceController = Get.find<ContractorServiceController>();

    print("Selected Services: ${contractorServiceController.selectedItems}");

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
    AppLogger.structured("Check Current User Data", user?.user?.toJson());
    currentUserId.value = user?.user?.id ?? '';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final contractorServiceController = Get.put(
      ContractorServiceController(contractorId: widget.contractor.userId),
    );

    final displayName = getDisplayName(
      contractorFirstName:
          contractorServiceController.userData.value?.firstName,
      contractorLastName: contractorServiceController.userData.value?.lastName,
      userName: widget.contractor.username,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Contractor Profile",
          style: TextStyle(
            color: ColorRes.textColor,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ColorRes.leadGreyColor.shade300),
                color: ColorRes.white,
              ),
              child: Column(
                children: [
                  // ---------------- PROFILE HEADER ----------------
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: ColorRes.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                profilePic: widget.contractor.imageUrl,
                              ),
                              const SizedBox(width: 16),

                              // Contractor Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Name (only if available)
                                    if (displayName.isNotEmpty)
                                      Text(
                                        displayName,
                                        style: TextStyle(
                                          fontSize: AppFontSizes.body,
                                          fontWeight: AppFontWeights.semiBold,
                                          color: ColorRes.primary,
                                        ),
                                      ),

                                    // Rating (only if valid)
                                    if (double.tryParse(
                                          widget.contractor.overallRating
                                              .toString(),
                                        ) !=
                                        null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: ColorRes.warning,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "${widget.contractor.overallRating} (${widget.contractor.totalReviews})",
                                              style: TextStyle(
                                                fontSize:
                                                    AppFontSizes.bodySmall,
                                                fontWeight:
                                                    AppFontWeights.medium,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            if (widget.contractor.contractorType != null &&
                                widget
                                    .contractor
                                    .contractorType!
                                    .isNotEmpty) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorRes.primary.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: ColorRes.primary.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  widget.contractor.contractorType!,
                                  style: TextStyle(
                                    fontSize: AppFontSizes.caption,
                                    fontWeight: AppFontWeights.medium,
                                    color: ColorRes.primary,
                                  ),
                                ),
                              ),
                            ],

                            if (widget
                                .contractor
                                .subscription
                                .hasPremiumPlan) ...[
                              SizedBox(height: 6),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorRes.orangeColor.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: ColorRes.orangeColor.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Premium',
                                  style: TextStyle(
                                    fontSize: AppFontSizes.caption,
                                    fontWeight: AppFontWeights.medium,
                                    color: ColorRes.orangeColor,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Location (only if city exists)
                  Obx(() {
                    final city =
                        contractorServiceController.userData.value?.city;

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
                                color: ColorRes.leadGreyColor.shade600,
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
                    final bool isSelectable = isListSelectable.value;
                    final bool isGuest = UserHelper.isGuest;
                    final bool isOwnService =
                        currentUserId.value == widget.contractor.userId;

                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                isOwnService
                                    ? null
                                    : () {
                                      if (isGuest) {
                                        Get.to(() => LoginScreen());
                                        return;
                                      }

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
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isOwnService
                                      ? ColorRes.leadGreyColor.shade300
                                      : ColorRes.primary,
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

                        /// 🔴 Show explanation if contractor viewing own service
                        if (isOwnService) ...[
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
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

                  // ---------------- STATS GRID ----------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statCard(
                        "Total Services",
                        widget.contractor.totalServices.toString(),
                      ),
                      _statCard(
                        "Active Services",
                        widget.contractor.activeServices.toString(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statCard(
                        "Projects",
                        widget.contractor.projectStats.totalProjects.toString(),
                      ),

                      _statCard(
                        "Experience",
                        "${widget.contractor.totalExperience} years",
                        highlight: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // ---------------- SECTION TITLE ----------------
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Services Offered (${widget.contractor.totalServices})",
                    style: TextStyle(
                      fontSize: AppFontSizes.body,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // ---------------- SELECTED SERVICES COUNT ----------------
            Obx(() {
              if (contractorServiceController.selectedItems.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: ColorRes.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ColorRes.primary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          contractorServiceController.clearSelection();
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
                );
              }
              return const SizedBox.shrink();
            }),
            // ---------------- LOGIN ALERT ----------------
            if (UserHelper.isGuest) ...[
              Container(
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
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            // ---------------- SERVICE CARDS ----------------
            Obx(() {
              if (contractorServiceController.isLoading.value &&
                  contractorServiceController.items.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (!contractorServiceController.isLoading.value &&
                  contractorServiceController.items.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text("No services found."),
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final data = contractorServiceController.items[index];
                  return Obx(
                    () => ServiceCard(
                      service: data,
                      isSelectable: isListSelectable.value,
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 16),
                itemCount: contractorServiceController.items.length,
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
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  String getDisplayName({
    String? contractorFirstName,
    String? contractorLastName,
    String? userName,
  }) {
    final fullName =
        '${contractorFirstName ?? ''} ${contractorLastName ?? ''}'.trim();

    print("Full Name: $fullName");

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

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade300,
      backgroundImage: hasImage ? NetworkImage(profilePic) : null,
      child:
          hasImage
              ? null
              : Text(
                getAvatarLetter(displayName),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
    );
  }

  Widget _statCard(String title, String value, {bool highlight = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorRes.leadGreyColor.shade300),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: AppFontSizes.bodySmall,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.grey,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: AppFontWeights.semiBold,
                color: highlight ? ColorRes.primary : ColorRes.black,
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

  const ServiceCard({
    super.key,
    required this.service,
    required this.isSelectable,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool showAllMeta = false;

  @override
  Widget build(BuildContext context) {
    final contractorController = Get.find<ContractorServiceController>();
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
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
        ),
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
                                fontSize: AppFontSizes.medium,
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
                                '${widget.service.averageRating} (${widget.service.totalReviews})',
                                style: TextStyle(
                                  fontSize: AppFontSizes.small,
                                  fontWeight: AppFontWeights.medium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      /*Text(
                        widget.service.description,
                        style: TextStyle(
                          fontSize: AppFontSizes.caption,
                          fontWeight: AppFontWeights.medium,
                          color: Colors.grey,
                        ),

                      ),*/
                      ReadMoreClass(
                        description: widget.service.description,
                        trimLines: 3,
                        size: AppFontSizes.caption,
                        colorClickableText: ColorRes.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(color: ColorRes.leadGreyColor.shade300, height: 1),
          // Middle section ----------
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
                  highlight: true,
                ),
              ],
            ),
          ),
          Divider(color: ColorRes.leadGreyColor.shade300, height: 1),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _detailColumn("PRICE", widget.service.meta.priceRange),
          ),
          // Features list -----------
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _detailColumn(
                    "ADVANCE REQUIRED",
                    "${widget.service.meta.advanceRequiredPercentage}%",
                  ),
                ),
                Expanded(
                  child: _detailColumn(
                    "PAYMENT MODES",
                    widget.service.meta.acceptedPaymentModes
                            ?.map((e) => e.replaceAll("_", " ").capitalize)
                            .join(", ") ??
                        '',
                  ),
                ),
              ],
            ),
          ),
          if (meta.works != null && meta.works!.isNotEmpty) ...[
            Divider(color: ColorRes.leadGreyColor.shade300, height: 1),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Specific Services / Works",
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
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
                          .join(', '),
                      style: TextStyle(
                        fontSize: AppFontSizes.caption,
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

          if (hasAnyMetaData) ...[
            Divider(color: ColorRes.leadGreyColor.shade300, height: 1),
            SizedBox(height: 15),
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
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Additional Services",
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
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
      ),
    );
  }

  Widget _yesNoChip(String label, String? value) {
    if (value == null) return const SizedBox();

    final isYes = value.toUpperCase() == "YES";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              fontSize: AppFontSizes.extraSmall,
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
                fontSize: AppFontSizes.small,
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
              Icon(icon, size: 18, color: ColorRes.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
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
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorRes.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: ColorRes.textSecondary,
              fontSize: AppFontSizes.extraSmall,
              fontWeight: AppFontWeights.medium,
            ),
          ),
          Flexible(
            child: Text(
              values.join(", "),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: ColorRes.textPrimary,
                fontSize: AppFontSizes.caption,
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
    print("iudjiidfi ${value}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.replaceAll("_", " ").capitalize.toString(),
          style: TextStyle(
            fontSize: AppFontSizes.bodySmall,
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
            color: ColorRes.grey,
          ),
        ),
      ],
    );
  }
}
