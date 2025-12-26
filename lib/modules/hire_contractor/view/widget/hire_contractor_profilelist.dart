import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/contractor/model/contractor_compare_model/contractor_compare_model.dart';
import 'package:housing_flutter_app/data/network/contractor/model/contractor_profile_model/contractor_profile_model.dart';
import 'package:housing_flutter_app/modules/hire_contractor/view/widget/hire_contractor_filter.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../data/network/contractor/model/contractot_service_model/contractor_service_model.dart';
import '../../../../data/network/contractor/model/hire-contractor_service_model.dart';
import '../../../../widgets/bar/filter_bar/filter_chip_bar.dart';
import '../../../contractor/controller/contractor_my_service_controller.dart';
import '../../../contractor/view/profile/contractot_profile.dart';
import '../../../home/controllers/contractor_profile_controller/contractor_compare_manager.dart';
import '../../../home/controllers/contractor_profile_controller/contractor_profile_controller.dart';
import '../../../home/widgets/contractor_profile_card.dart';
import '../../../home/widgets/contractor_profile_screen.dart';
import '../../../home/widgets/unified_comparison_floating_button.dart';
import '../../controller/hire_contractor_controller.dart';
import '../../controller/hire_contractor_filter_controller.dart';
import '../../controller/hire_contractor_list_of_profile_controller.dart';

class HireContractorProfileList extends StatelessWidget {
  const HireContractorProfileList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HireContractorController>();
    final controllerProfileData =
        Get.find<HireContractorListOfProfileController>();
    final controllerFilter = Get.find<HireContractorFilterProfileController>();
    TopContractorsController contractor = Get.find<TopContractorsController>();
    RxMap<String, String> selectedFilters = <String, String>{}.obs;
    return Scaffold(
      backgroundColor: ColorRes.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: ColorRes.white,
        elevation: 0,
        title: Obx(
          () => Text(
            '${controllerFilter.selectedCategoryName.isEmpty ? "All Contractor" : controllerFilter.selectedCategoryName}',
            style: TextStyle(
              color: ColorRes.textPrimary,
              fontWeight: AppFontWeights.semiBold,
            ),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Get.dialog<Map<String, String>>(
                const HireContractorFilter(),
                barrierDismissible: true,
              );
              if (result != null) {
                log("Selected Filters → $result");
                if (result != null) {
                  selectedFilters.value = result;
                  controllerFilter.applyFilters(result);
                }
                // You can now apply filters to your list, API call, etc.
                // controller.fetchFilteredInquiries(result);
              }
            },
            icon: Icon(Icons.filter_list),
          ),
        ],
      ),

      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              // Check if filters are applied
              final hasFilters =
                  controllerFilter.selectedCategoryName.isNotEmpty &&
                  controllerFilter.selectedCategoryId.isNotEmpty;

              if (!hasFilters) {
                // Show all contractors (combined list)
                if (controller.isLoading.value && controller.items.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controllerProfileData.items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 64,
                          color: ColorRes.textDisabled,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No categories available',
                          style: TextStyle(
                            fontSize: AppFontSizes.medium,
                            color: ColorRes.textSecondary,
                            fontWeight: AppFontWeights.medium,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controllerProfileData.refreshService(),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView.builder(
                      itemCount: controllerProfileData.combinedList.length,
                      itemBuilder: (context, index) {
                        final item = controllerProfileData.combinedList[index];
                        return AllContractorCard(
                          data: item,
                          contractor: contractor,
                        );
                      },
                    ),
                  ),
                );
              }

              // Show filtered contractors
              return SafeArea(
                child: Column(
                  children: [
                    Obx(() {
                      return FilterChipsBar(
                        filters: selectedFilters.value,
                        onClearAll: () {
                          selectedFilters.clear();
                          controllerFilter.resetFilters();
                          controllerFilter.applyFilters(<String, String>{});
                        },
                        onRemoveFilter: (key) {
                          selectedFilters.remove(key);
                          controllerFilter.applyFilters(
                            Map<String, String>.from(selectedFilters),
                          );
                        },
                      );
                    }),
                    Expanded(
                      child: Obx(() {
                        final filteredResponse =
                            controllerFilter.filteredData.value;

                        if (filteredResponse == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final contractors = filteredResponse.data.contractors;

                        if (contractors.isEmpty) {
                          return const Center(
                            child: Text(
                              'No contractors available for this category.',
                              style: TextStyle(color: ColorRes.textSecondary),
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () async {
                            await controllerFilter
                                .fetchHireContractorByCategoryID(
                                  controllerFilter.selectedCategoryId.value,
                                  controllerFilter.selectedCategoryName.value,
                                );
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: contractors.length,
                            itemBuilder: (context, index) {
                              final item = contractors[index];
                              return HireContractorCard(
                                data: item,
                                contractor: contractor,
                              );
                            },
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            }),
            UnifiedComparisonFloatingButton(bottom: 16),
          ],
        ),
      ),
    );
  }
}

class HireContractorCard extends StatefulWidget {
  final HireContractorServiceContractor data;
  final TopContractorsController contractor;

  HireContractorCard({super.key, required this.data, required this.contractor});

  @override
  State<HireContractorCard> createState() => _HireContractorCardState();
}

class _HireContractorCardState extends State<HireContractorCard> {
  Contractor? contractorProfile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserByID();
  }

  void _fetchUserByID() async {
    final userId = widget.data.contractorId;

    contractorProfile = await widget.contractor.getContractorById(userId);
  }

  @override
  Widget build(BuildContext context) {
    final compare = Get.put(ContractorCompareManager(), permanent: true);

    ContractorMyServiceController contractorData = Get.put(
      ContractorMyServiceController(),
    );
    final controllerFilter = Get.find<HireContractorFilterProfileController>();

    return GestureDetector(
      onTap: () async {
        final id = widget.data.contractorId;

        final userData = await controllerFilter.fetchUserByID(id ?? '');

        final contractorProfile = await widget.contractor.getContractorById(
          id ?? '',
        );

        log("Tapped Contractor Profile Data: ${contractorProfile?.toJson()}");
        contractorProfile?.totalExperience =
            userData.value?.totalExperience ?? 0;

        contractorProfile?.username = widget.data.username;

        if (contractorProfile != null) {
          Get.to(
            () => ContractorProfileDetailsScreen(contractor: contractorProfile),
          );
        } else {
          log('No contractor found for userId: $id');
          Get.snackbar(
            'Not Found',
            'Contractor profile could not be loaded.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorRes.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===================== TOP ROW =====================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.grey.shade100,
                  backgroundImage:
                      (widget.data.profilePic?.isNotEmpty ?? false)
                          ? NetworkImage(widget.data.profilePic!)
                          : null,
                  onBackgroundImageError:
                      (widget.data.profilePic?.isNotEmpty ?? false)
                          ? (_, __) {} // only active if image is non-null
                          : null,
                  child:
                      (widget.data.profilePic?.isEmpty ?? true)
                          ? const Icon(
                            Icons.engineering,
                            color: Colors.orange,
                            size: 28,
                          )
                          : null,
                ),

                const SizedBox(width: 12),

                /// ===================== NAME & EXPERIENCE =====================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data.username ?? 'Unknown Contractor',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: AppFontSizes.medium,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.textColor,
                        ),
                      ),
                      Text(
                        'Total Service ${widget.data.contractorProfile.activeServices.toString()}' ??
                            'Unknown Contractor',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: AppFontSizes.small,
                          fontWeight: AppFontWeights.medium,
                          color: ColorRes.leadGreyColor.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                /// ===================== COMPARE BUTTON =====================
                GestureDetector(
                  onTap: () {
                    _fetchUserByID();

                    if (contractorProfile != null) {
                      compare.toggle(
                        contractorProfile ?? Contractor.fromJson({}),
                        max: 2,
                      );
                    }
                  },
                  child: Obx(() {
                    final selected = compare.isSelected(
                      widget.data.contractorId ?? '',
                    );
                    return Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: selected ? ColorRes.primary : ColorRes.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: selected ? ColorRes.primary : ColorRes.border,
                          width: 1.2,
                        ),
                      ),
                      child: Icon(
                        Icons.compare_arrows,
                        color: selected ? ColorRes.white : ColorRes.primary,
                        size: 18,
                      ),
                    );
                  }),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// ===================== RATING ROW =====================
            Row(
              children: [
                Row(
                  children: List.generate(5, (index) {
                    final rating =
                        double.tryParse(
                          widget.data.contractorProfile.overallRating,
                        ) ??
                        0;
                    if (index < rating.floor()) {
                      return const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      );
                    } else if (index < rating) {
                      return const Icon(
                        Icons.star_half,
                        color: Colors.amber,
                        size: 16,
                      );
                    } else {
                      return Icon(
                        Icons.star_border,
                        color: Colors.amber.shade400,
                        size: 16,
                      );
                    }
                  }),
                ),
                const SizedBox(width: 6),
                Text(
                  (double.tryParse(
                        widget.data.contractorProfile.overallRating,
                      )?.toStringAsFixed(1)) ??
                      '0.0',
                  style: const TextStyle(
                    fontWeight: AppFontWeights.semiBold,
                    fontSize: AppFontSizes.bodySmall,
                    color: ColorRes.textColor,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  "(${widget.data.contractorProfile.totalReviews} review${widget.data.contractorProfile.totalReviews == 1 ? '' : 's'})",
                  style: const TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.textSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Divider(color: ColorRes.border, thickness: 1),
            const SizedBox(height: 10),

            /// ===================== SERVICES / PROJECTS STATS =====================
            Column(
              children: [
                ...List.generate(widget.data.servicesInCategory.length, (
                  index,
                ) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: ColorRes.leadGreyColor.shade300,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${widget.data.servicesInCategory[index].serviceName}',
                            style: TextStyle(
                              fontSize: AppFontSizes.small,
                              fontWeight: AppFontWeights.medium,
                              color: ColorRes.textColor,
                            ),
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.star, size: 16, color: ColorRes.orangeColor),
                        SizedBox(width: 6),
                        Text(
                          '${widget.data.servicesInCategory[index].rating}',
                          style: TextStyle(
                            fontSize: AppFontSizes.small,
                            fontWeight: AppFontWeights.medium,
                            color: ColorRes.textColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AllContractorCard extends StatefulWidget {
  final HireContractorUserWithProfile data;
  final TopContractorsController contractor;

  AllContractorCard({super.key, required this.data, required this.contractor});

  @override
  State<AllContractorCard> createState() => _AllContractorCardState();
}

class _AllContractorCardState extends State<AllContractorCard> {
  Contractor? contractorProfile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserByID();
  }

  void _fetchUserByID() async {
    final userId = widget.data.profile.userId;

    contractorProfile = await widget.contractor.getContractorById(userId);
  }

  @override
  Widget build(BuildContext context) {
    final compare = Get.put(ContractorCompareManager(), permanent: true);
    final contractor = widget.contractor;

    final user = widget.data.user;
    final profile = widget.data.profile;

    return GestureDetector(
      onTap: () async {
        log("User Data From Api ${user.id}    ${profile.userId}");
        final contractorProfile = await contractor.getContractorById(
          profile.userId,
        );
        log("Tapped Contractor Profile Data: ${contractorProfile?.toJson()}");

        contractorProfile?.username = widget.data.user.username ?? '';
        contractorProfile?.totalExperience =
            widget.data.user.totalExperience ?? 0;
        // contractorProfile?.projectStats.totalProjects = data.profile.??  0;

        if (contractorProfile != null) {
          Get.to(
            () => ContractorProfileDetailsScreen(contractor: contractorProfile),
          );
        } else {
          log('No contractor found for userId: $profile.userId');
          Get.snackbar(
            'Not Found',
            'Contractor profile could not be loaded.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorRes.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===================== TOP ROW =====================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.grey.shade100,
                  backgroundImage:
                      (user.profilePic?.isNotEmpty ?? false)
                          ? NetworkImage(user.profilePic!)
                          : null,
                  onBackgroundImageError:
                      (user.profilePic?.isNotEmpty ?? false)
                          ? (_, __) {} // only active if image is non-null
                          : null,
                  child:
                      (user.profilePic?.isEmpty ?? true)
                          ? const Icon(
                            Icons.engineering,
                            color: Colors.orange,
                            size: 28,
                          )
                          : null,
                ),

                const SizedBox(width: 12),

                /// ===================== NAME & EXPERIENCE =====================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username ?? 'Unknown Contractor',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: AppFontSizes.medium,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.textColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${user.totalExperience ?? 0}+ years experience",
                        style: const TextStyle(
                          fontSize: AppFontSizes.small,
                          color: ColorRes.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                /// ===================== COMPARE BUTTON =====================
                GestureDetector(
                  onTap: () async {
                    _fetchUserByID();

                    if (contractorProfile != null) {
                      compare.toggle(
                        contractorProfile ?? Contractor.fromJson({}),
                        max: 2,
                      );
                    }
                  },
                  child: Obx(() {
                    final selected = compare.isSelected(user.id ?? '');
                    return Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: selected ? ColorRes.primary : ColorRes.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: selected ? ColorRes.primary : ColorRes.border,
                          width: 1.2,
                        ),
                      ),
                      child: Icon(
                        Icons.compare_arrows,
                        color: selected ? ColorRes.white : ColorRes.primary,
                        size: 18,
                      ),
                    );
                  }),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// ===================== RATING ROW =====================
            Row(
              children: [
                Row(
                  children: List.generate(5, (index) {
                    final rating = double.tryParse(profile.overallRating) ?? 0;
                    if (index < rating.floor()) {
                      return const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      );
                    } else if (index < rating) {
                      return const Icon(
                        Icons.star_half,
                        color: Colors.amber,
                        size: 16,
                      );
                    } else {
                      return Icon(
                        Icons.star_border,
                        color: Colors.amber.shade400,
                        size: 16,
                      );
                    }
                  }),
                ),
                const SizedBox(width: 6),
                Text(
                  (double.tryParse(
                        profile.overallRating,
                      )?.toStringAsFixed(1)) ??
                      '0.0',
                  style: const TextStyle(
                    fontWeight: AppFontWeights.semiBold,
                    fontSize: AppFontSizes.bodySmall,
                    color: ColorRes.textColor,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  "(${profile.totalReviews} review${profile.totalReviews == 1 ? '' : 's'})",
                  style: const TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.textSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Divider(color: ColorRes.border, thickness: 1),
            const SizedBox(height: 10),

            /// ===================== SERVICES / PROJECTS STATS =====================
            Row(
              children: [
                Expanded(
                  child: _buildStatContainer(
                    title: 'Total Services',
                    value: profile.totalServices.toString(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatContainer(
                    title: 'Active Services',
                    value: profile.activeServices.toString(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatContainer(
                    title: 'Total Reviews',
                    value: profile.totalReviews.toString(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatContainer({required String title, required String value}) {
    return Container(
      width: 85, // fixed width for consistent alignment
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: ColorRes.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorRes.border, width: 1),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: AppFontSizes.caption,
              color: ColorRes.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: AppFontSizes.medium,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textColor,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildStatContainer({required String title, required String value}) {
  return Container(
    width: 95, // fixed width for consistent alignment
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
    decoration: BoxDecoration(
      color: ColorRes.background,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: ColorRes.border, width: 1),
    ),
    child: Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: AppFontSizes.caption,
            color: ColorRes.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: AppFontSizes.medium,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textColor,
          ),
        ),
      ],
    ),
  );
}
