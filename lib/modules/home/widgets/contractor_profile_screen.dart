import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:housing_flutter_app/modules/auth/views/login_screen.dart';
import 'package:housing_flutter_app/modules/contractor/view/widget/contractor_inquiry_screen.dart';
import '../../../app/constants/app_font_sizes.dart';
import '../../../data/network/contractor/model/contractor_profile_model/contractor_profile_model.dart';
import '../../../data/network/contractor/model/contractot_service_model/contractor_service_model.dart';
import '../../../widgets/messages/snack_bar.dart';
import '../controllers/contractor_profile_service_controller/contractor_profile_service_controller.dart';
import 'contractor_add_inuiry_screen.dart';

class ContractorProfileDetailsScreen extends StatelessWidget {
  final Contractor contractor;
  final bool isPremium;

  ContractorProfileDetailsScreen({
    super.key,
    required this.contractor,
    this.isPremium = false,
  });

  // Make this an instance variable accessible to the controller
  final RxBool isListSelectable = false.obs;

  Future<void> contactContractor() async {
    final contractorServiceController = Get.find<ContractorServiceController>();

    print("Selected Services: ${contractorServiceController.selectedItems}");

    final bool result = await Get.to(
      () => ContractorAddInquiryScreen(
        services: contractorServiceController.selectedItems.value,
        contractor: contractor,
      ),
    );
    // After navigation reset back
    isListSelectable.value = false;
    if (result) {
      contractorServiceController.clearSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final contractorServiceController = Get.put(
      ContractorServiceController(contractorId: contractor.userId),
    );

    final displayName = getDisplayName(
      contractorFirstName:
          contractorServiceController.userData.value?.firstName,
      contractorLastName: contractorServiceController.userData.value?.lastName,
      userName: contractor.username,
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
                                profilePic: contractor.imageUrl,
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
                                          contractor.overallRating.toString(),
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
                                              "${contractor.overallRating} (${contractor.totalReviews})",
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
                            if (contractor.contractorType != null &&
                                contractor.contractorType!.isNotEmpty) ...[
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
                                  contractor.contractorType!,
                                  style: TextStyle(
                                    fontSize: AppFontSizes.caption,
                                    fontWeight: AppFontWeights.medium,
                                    color: ColorRes.primary,
                                  ),
                                ),
                              ),
                            ],

                            if (contractor.subscription.hasPremiumPlan) ...[
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
                                    color: ColorRes.orangeColor.withOpacity(0.3),
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
                  Obx(() {
                    final bool isSelectable = isListSelectable.value;
                    final bool isGuest = UserHelper.isGuest;

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
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
                          backgroundColor: ColorRes.primary,
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
                    );
                  }),

                  const SizedBox(height: 12),

                  // ---------------- STATS GRID ----------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statCard(
                        "Total Services",
                        contractor.totalServices.toString(),
                      ),
                      _statCard(
                        "Active Services",
                        contractor.activeServices.toString(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statCard(
                        "Projects",
                        contractor.projectStats.totalProjects.toString(),
                      ),

                      _statCard(
                        "Experience",
                        "${contractor.totalExperience} years",
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
                    "Services Offered (${contractor.totalServices})",
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

class ServiceCard extends StatelessWidget {
  final bool isSelectable;
  final ContractorServiceItem service;

  const ServiceCard({
    super.key,
    required this.service,
    required this.isSelectable,
  });

  @override
  Widget build(BuildContext context) {
    final contractorController = Get.find<ContractorServiceController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isSelectable &&
                      contractorController.selectedItems.contains(service)
                  ? ColorRes.primary
                  : ColorRes.leadGreyColor.shade300,
          width:
              isSelectable &&
                      contractorController.selectedItems.contains(service)
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
                if (isSelectable) ...[
                  Obx(
                    () => Checkbox(
                      value: contractorController.selectedItems.contains(
                        service,
                      ),
                      onChanged: (value) {
                        contractorController.toggleSelectedService(service);
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
                              service.serviceName,
                              style: TextStyle(
                                fontSize: AppFontSizes.body,
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
                                '${service.averageRating} (${service.totalReviews})',
                                style: TextStyle(
                                  fontSize: AppFontSizes.bodySmall,
                                  fontWeight: AppFontWeights.medium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        service.description,
                        style: TextStyle(
                          fontSize: AppFontSizes.bodySmall,
                          fontWeight: AppFontWeights.medium,
                          color: Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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

                _detailColumn("AVAILABILITY", service.meta.workAvailability),
                _detailColumn(
                  "Visiting Charge",
                  '₹${service.meta.visitCharge.toString()}',
                  highlight: true,
                ),
              ],
            ),
          ),
          Divider(color: ColorRes.leadGreyColor.shade300, height: 1),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _detailColumn("PRICE", service.meta.priceRange),
          ),
          // Features list -----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                _feature(service.meta.provideMaterials, "Materials Provided"),
                const SizedBox(height: 6),
                _feature(service.meta.equipmentProvided, "Equipment Provided"),
                const SizedBox(height: 6),
                _feature(
                  service.meta.insuranceAvailable,
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
                    "${service.meta.advanceRequiredPercentage}%",
                  ),
                ),
                Expanded(
                  child: _detailColumn(
                    "PAYMENT MODES",
                    service.meta.acceptedPaymentModes
                        .map((e) => e.replaceAll("_", " ").capitalize)
                        .join(", "),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
