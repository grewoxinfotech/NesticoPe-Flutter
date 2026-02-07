import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart'
    hide ColorRes;
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/contractor/model/contractor_compare_model/contractor_compare_model.dart';
import 'package:housing_flutter_app/data/network/contractor/model/contractor_profile_model/contractor_profile_model.dart';
import 'package:housing_flutter_app/modules/hire_contractor/view/widget/hire_contractor_filter.dart';
import 'package:housing_flutter_app/utils/logger/app_logger.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../data/network/contractor/model/contractot_service_model/contractor_service_model.dart';
import '../../../../data/network/contractor/model/hire-contractor_service_model.dart';
import '../../../../data/network/contractor/model/new_hire_contractor.dart';
import '../../../../widgets/bar/filter_bar/filter_chip_bar.dart';
import '../../../../widgets/messages/snack_bar.dart';
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
import '../../controller/hire_contractor_new_controller.dart';

class HireContractorProfileList extends StatelessWidget {
  const HireContractorProfileList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HireContractorController>();
    final controllerNew = Get.find<HireContractorNewController>();
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
                  result.remove('city');
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
              // final hasFilters =
              //     controllerFilter.selectedCategoryName.isNotEmpty &&
              //     controllerFilter.selectedCategoryId.isNotEmpty;

              final hasFilters =
                  selectedFilters.isNotEmpty ||
                  controllerFilter.selectedCategoryId.isNotEmpty;

              if (!hasFilters) {
                // Show all contractors (combined list)
                if (controllerNew.isLoading.value &&
                    controllerNew.items.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controllerNew.items.isEmpty) {
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
                AppLogger.structured(
                  'Check any thing missing ',
                  controllerNew.items.map((e) => e.toMap()),
                );
                return RefreshIndicator(
                  onRefresh: () => controllerNew.refreshService(),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView.builder(
                      itemCount: controllerNew.items.length,
                      itemBuilder: (context, index) {
                        final item = controllerNew.items[index];
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
                        final contractors = controllerFilter.items;

                        if (controllerFilter.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (contractors.isEmpty) {
                          return const Center(
                            child: Text(
                              'No contractors available for this category.',
                              style: TextStyle(color: ColorRes.textSecondary),
                            ),
                          );
                        }

                        AppLogger.structured(
                          'Check any thing missing form selected category ',

                          contractors.map((e) => e.toMap()),
                        );
                        return RefreshIndicator(
                          onRefresh:
                              ()
                              // await controllerFilter
                              //     .fetchHireContractorByCategoryID(
                              //       controllerFilter.selectedCategoryId.value,
                              //       controllerFilter.selectedCategoryName.value,
                              //     );
                              => controllerFilter.fetchHireContractorCategories(
                                controllerFilter.selectedCategoryId.value,
                                controllerFilter.selectedCategoryName.value,
                              ),
                          child: ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: contractors.length,
                            separatorBuilder:
                                (context, index) => SizedBox(height: 12),
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

/*class HireContractorCard extends StatefulWidget {
  final OverAllContractorItem data;
  final TopContractorsController contractor;

  HireContractorCard({super.key, required this.data, required this.contractor});

  @override
  State<HireContractorCard> createState() => _HireContractorCardState();
}

class _HireContractorCardState extends State<HireContractorCard> {
  Contractor? contractorProfile;

  @override
  void initState() {
    super.initState();
    _fetchUserByID();
  }

  void _fetchUserByID() async {
    final userId = widget.data.userId;
    contractorProfile = await widget.contractor.getContractorById(userId);
  }

  @override
  Widget build(BuildContext context) {
    final compare = Get.put(ContractorCompareManager(), permanent: true);
    final user = widget.data;

    return GestureDetector(
      onTap: () async {
        contractorProfile?.username = widget.data.username ?? '';
        contractorProfile?.firstName = widget.data.firstName ?? '';
        contractorProfile?.lastName = widget.data.lastName ?? '';
        contractorProfile?.totalExperience = widget.data.totalExperience ?? 0;

        if (contractorProfile != null) {
          Get.to(
            () => ContractorProfileDetailsScreen(
              contractor: contractorProfile ?? Contractor.fromJson({}),
              isPremium: widget.data.subscription?.hasPremiumPlan ?? false,
            ),
          );
        } else {
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Not Found',
            message: 'Contractor profile could not be loaded.',
            contentType: ContentType.failure,
          );
        }
      },
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorRes.leadGreyColor.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===================== HEADER SECTION =====================
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Profile Avatar
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorRes.primary.withOpacity(0.1),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: ColorRes.primary.withOpacity(0.1),
                      backgroundImage:
                          (widget.data.profilePic?.isNotEmpty ?? false)
                              ? NetworkImage(widget.data.profilePic!)
                              : null,
                      onBackgroundImageError:
                          (widget.data.profilePic?.isNotEmpty ?? false)
                              ? (_, __) {}
                              : null,
                      child:
                          (widget.data.profilePic?.isEmpty ?? true)
                              ? Text(
                                _getInitials(widget.data.username ?? 'U'),
                                style: TextStyle(
                                  fontSize: AppFontSizes.large,
                                  fontWeight: AppFontWeights.bold,
                                  color: ColorRes.primary,
                                ),
                              )
                              : null,
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// Name and Type/Premium Badges
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data.username ?? 'Unknown Contractor',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: ColorRes.textColor,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            if (widget.data.contractorType != null &&
                                widget.data.contractorType!.isNotEmpty) ...[
                              _buildBadge(
                                label: widget.data.contractorType!,
                                backgroundColor: ColorRes.primary.withOpacity(
                                  0.08,
                                ),
                                textColor: ColorRes.primary,
                              ),
                              const SizedBox(width: 6),
                            ],
                            if (widget.data.subscription?.hasPremiumPlan ==
                                true)
                              _buildBadge(
                                label: 'Premium',
                                backgroundColor: ColorRes.homeYellow
                                    .withOpacity(0.12),
                                textColor: ColorRes.homeYellow,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// Compare Button
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
                      final selected = compare.isSelected(user.id ?? '');
                      return Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color:
                              selected ? ColorRes.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:
                                selected ? ColorRes.primary : ColorRes.border,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.compare_arrows_rounded,
                          color:
                              selected
                                  ? ColorRes.white
                                  : ColorRes.textSecondary,
                          size: 20,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            /// ===================== STATS ROW =====================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildStatItem(
                    label: 'Total Services',
                    value: widget.data.activeServices?.toString() ?? '0',
                  ),
                  const SizedBox(width: 24),
                  if (widget.data.totalExperience != null &&
                      widget.data.totalExperience! > 0)
                    _buildStatItem(
                      label: 'Experience',
                      value: '${widget.data.totalExperience}+ Years Experience',
                    ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// ===================== PER VISIT PRICE =====================
            if (widget.data.contractorVisitCharge != null &&
                widget.data.contractorVisitCharge! > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'Per Visit Price',
                    //   style: TextStyle(
                    //     fontSize: AppFontSizes.caption,
                    //     fontWeight: AppFontWeights.medium,
                    //     color: ColorRes.textSecondary,
                    //   ),
                    // ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '₹${widget.data.contractorVisitCharge!}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: ColorRes.textColor,
                              letterSpacing: -0.5,
                            ),
                          ),
                          TextSpan(
                            text: ' per visit',
                            style: TextStyle(
                              fontSize: AppFontSizes.small,
                              fontWeight: AppFontWeights.medium,
                              color: ColorRes.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 14),

            /// ===================== RATING ROW =====================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      final rating =
                          double.tryParse(widget.data.overallRating) ?? 0;
                      if (index < rating.floor()) {
                        return const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFB800),
                          size: 18,
                        );
                      } else if (index < rating) {
                        return const Icon(
                          Icons.star_half_rounded,
                          color: Color(0xFFFFB800),
                          size: 18,
                        );
                      } else {
                        return Icon(
                          Icons.star_outline_rounded,
                          color: Colors.grey.shade300,
                          size: 18,
                        );
                      }
                    }),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    (double.tryParse(
                          widget.data.overallRating,
                        )?.toStringAsFixed(1)) ??
                        '0.0',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: ColorRes.textColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "(${widget.data.totalReviews} review${widget.data.totalReviews == 1 ? '' : 's'})",
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      color: ColorRes.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// ===================== SERVICES CHIPS =====================
            if (widget.data.servicesInCategory.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...widget.data.servicesInCategory.take(3).map((service) {
                      return _buildServiceChip(
                        serviceName: service.serviceName ?? '',
                        rating: service.rating?.toString(),
                      );
                    }),
                    if (widget.data.servicesInCategory.length > 3)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: ColorRes.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '+${widget.data.servicesInCategory.length - 3} more',
                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge({
    required String label,
    required Color backgroundColor,

    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildStatItem({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppFontSizes.caption,
            fontWeight: AppFontWeights.medium,
            color: ColorRes.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: AppFontSizes.medium,
            fontWeight: FontWeight.w600,
            color: ColorRes.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceChip({required String serviceName, String? rating}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ColorRes.leadGreyColor.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorRes.border.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              serviceName,
              style: TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.textColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          if (rating != null && rating.isNotEmpty) ...[
            const SizedBox(width: 6),
            Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFB800)),
            const SizedBox(width: 2),
            Text(
              rating,
              style: TextStyle(
                fontSize: AppFontSizes.caption,
                fontWeight: FontWeight.w600,
                color: ColorRes.textColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}*/

class HireContractorCard extends StatefulWidget {
  final OverAllContractorItem data;
  final TopContractorsController contractor;

  HireContractorCard({super.key, required this.data, required this.contractor});

  @override
  State<HireContractorCard> createState() => _HireContractorCardState();
}

class _HireContractorCardState extends State<HireContractorCard> {
  Contractor? contractorProfile;

  @override
  void initState() {
    super.initState();
    _fetchUserByID();
  }

  void _fetchUserByID() async {
    final userId = widget.data.userId;
    contractorProfile = await widget.contractor.getContractorById(userId);
  }

  @override
  Widget build(BuildContext context) {
    final compare = Get.put(ContractorCompareManager(), permanent: true);
    final user = widget.data;
    return GestureDetector(
      onTap: () {
        contractorProfile?.username = widget.data.username ?? '';
        contractorProfile?.firstName = widget.data.firstName ?? '';
        contractorProfile?.lastName = widget.data.lastName ?? '';
        contractorProfile?.totalExperience = widget.data.totalExperience ?? 0;
        if (contractorProfile != null) {
          Get.to(
            () => ContractorProfileDetailsScreen(
              contractor: contractorProfile ?? Contractor.fromJson({}),
              isPremium: widget.data.subscription?.hasPremiumPlan ?? false,
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        /*margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),*/
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorRes.leadGreyColor.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER: Profile + Name + Badges + Price
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*  CircleAvatar(
                  radius: 28,
                  backgroundColor: ColorRes.primary.withOpacity(0.1),
                  backgroundImage: widget.data.profilePic != null && widget.data.profilePic!.isNotEmpty
                      ? NetworkImage(widget.data.profilePic!)
                      : null,
                  child: (widget.data.profilePic?.isEmpty ?? true)
                      ? Text(
                    _getInitials(widget.data.username ?? 'U'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorRes.primary,
                    ),
                  )
                      : null,
                ),*/
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: ColorRes.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child:
                        (widget.data.profilePic != null &&
                                widget.data.profilePic!.isNotEmpty)
                            ? CustomImage(
                              src: widget.data.profilePic!,
                              type: CustomImageType.network,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            )
                            : Center(
                              child: Text(
                                _getInitials(widget.data.username ?? 'U'),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ColorRes.primary,
                                ),
                              ),
                            ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Name + top badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.data.username ?? 'Unknown Contractor',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: ColorRes.textColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8),
                          if (widget.data.contractorVisitCharge != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: ColorRes.green.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '\$${widget.data.contractorVisitCharge}/visit',
                                style: TextStyle(
                                  fontSize: AppFontSizes.small,
                                  fontWeight: FontWeight.w600,
                                  color: ColorRes.green,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      /// Location + Experience
                      Text(
                        '${widget.data.city ?? ''}, ${widget.data.state ?? ''}',
                        style: TextStyle(
                          fontSize: AppFontSizes.caption,
                          fontWeight: AppFontWeights.medium,
                          color: ColorRes.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (widget.data.subscription?.hasPremiumPlan ?? false)
                            _buildBadge(
                              label: 'PREMIUM',
                              backgroundColor: ColorRes.orangeColor.withOpacity(
                                0.12,
                              ),
                              textColor: ColorRes.orangeColor,
                            ),
                          if (widget.data.contractorType != null &&
                              widget.data.contractorType!.isNotEmpty) ...[
                            _buildBadge(
                              label:
                                  widget.data.contractorType?.toUpperCase() ??
                                  '',
                              backgroundColor: ColorRes.primary.withOpacity(
                                0.12,
                              ),
                              textColor: ColorRes.primary,
                            ),
                          ],
                          if (widget.data.totalExperience != null &&
                              widget.data.totalExperience! > 0) ...[
                            _buildBadge(
                              label:
                                  '${widget.data.totalExperience.toString()} Year Experience' ??
                                  '',
                              backgroundColor: ColorRes.primary.withOpacity(
                                0.12,
                              ),
                              textColor: ColorRes.primary,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            /// SERVICES CHIPS
            if (widget.data.servicesInCategory.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  ...widget.data.servicesInCategory
                      .take(2)
                      .map(
                        (service) => _buildServiceChip(
                          serviceName: service.serviceName ?? '',
                          rating: service.rating.toString(),
                        ),
                      ),
                  if (widget.data.servicesInCategory.length > 2)
                    _buildServiceChip(
                      serviceName:
                          '+${widget.data.servicesInCategory.length - 2} more services',
                      isMore: true,
                    ),
                ],
              ),
            const SizedBox(height: 10),

            /// RATING + CONTACT BUTTON
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: ColorRes.homeAmber.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: ColorRes.leadGreyColor.shade300,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Stars
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      // Rating text
                      Text(
                        '${double.tryParse(widget.data.overallRating)?.toStringAsFixed(1) ?? '0.0'} '
                        '(${Formatter.formatNumber(widget.data.totalReviews) ?? 0} reviews)',
                        style: TextStyle(
                          fontSize: AppFontSizes.caption,
                          fontWeight: AppFontWeights.medium,
                          color: ColorRes.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
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
                    final selected = compare.isSelected(user.id ?? '');
                    return Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: selected ? ColorRes.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected ? ColorRes.primary : ColorRes.border,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.compare_arrows_rounded,
                        color:
                            selected ? ColorRes.white : ColorRes.textSecondary,
                        size: 20,
                      ),
                    );
                  }),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    contractorProfile?.username = widget.data.username ?? '';
                    contractorProfile?.firstName = widget.data.firstName ?? '';
                    contractorProfile?.lastName = widget.data.lastName ?? '';
                    contractorProfile?.totalExperience =
                        widget.data.totalExperience ?? 0;
                    if (contractorProfile != null) {
                      Get.to(
                        () => ContractorProfileDetailsScreen(
                          contractor:
                              contractorProfile ?? Contractor.fromJson({}),
                          isPremium:
                              widget.data.subscription?.hasPremiumPlan ?? false,
                        ),
                      );
                    }
                  },
                  // icon: const Icon(Icons.phone, size: 16),
                  child: const Text('Contact Now'),
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge({
    required String label,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: textColor.withOpacity(0.3), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildServiceChip({
    required String serviceName,
    bool isMore = false,
    String rating = '',
  }) {
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color:
              isMore
                  ? ColorRes.primary.withOpacity(0.1)
                  : ColorRes.leadGreyColor.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // <-- important
          children: [
            Text(
              serviceName,
              style: TextStyle(
                fontSize: AppFontSizes.caption,
                fontWeight: AppFontWeights.medium,
                color: isMore ? ColorRes.primary : ColorRes.textColor,
              ),
            ),
            if (!isMore) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: ColorRes.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: ColorRes.leadGreyColor.shade300,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${double.tryParse(rating)?.toStringAsFixed(1) ?? '0.0'}',
                      style: TextStyle(
                        fontSize: AppFontSizes.caption,
                        fontWeight: AppFontWeights.medium,
                        color: ColorRes.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

/*class AllContractorCard extends StatefulWidget {
    final OverAllContractorItem data;
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
      final userId = widget.data.userId;

      contractorProfile = await widget.contractor.getContractorById(userId);
    }

    @override
    Widget build(BuildContext context) {
      final compare = Get.put(ContractorCompareManager(), permanent: true);

      final user = widget.data;

      return GestureDetector(
        onTap: () async {
          log("Tapped Contractor Profile Data: ${contractorProfile?.toJson()}");

          contractorProfile?.username = widget.data.username ?? '';
          contractorProfile?.firstName = widget.data.firstName ?? '';
          contractorProfile?.lastName = widget.data.lastName ?? '';
          contractorProfile?.totalExperience = widget.data.totalExperience ?? 0;
          // contractorProfile?.projectStats.totalProjects = data.profile.??  0;

          if (contractorProfile != null) {
            Get.to(
              () => ContractorProfileDetailsScreen(
                contractor: contractorProfile ?? Contractor.fromJson({}),
              ),
            );
          } else {
            NesticoPeSnackBar.showAwesomeSnackbar(
              title: 'Not Found',
              message: 'Contractor profile could not be loaded.',
              contentType: ContentType.failure,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          final rating =
                              double.tryParse(widget.data.overallRating) ?? 0;
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
                              widget.data.overallRating,
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
                        "(${widget.data.totalReviews} review${widget.data.totalReviews == 1 ? '' : 's'})",
                        style: const TextStyle(
                          fontSize: AppFontSizes.caption,
                          color: ColorRes.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  if (widget.data.contractorType != null &&
                      widget.data.contractorType!.isNotEmpty) ...[
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
                        widget.data.contractorType!,
                        style: TextStyle(
                          fontSize: AppFontSizes.caption,
                          fontWeight: AppFontWeights.medium,
                          color: ColorRes.primary,
                        ),
                      ),
                    ),
                  ],
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
                      value: widget.data.totalServices.toString(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatContainer(
                      title: 'Active Services',
                      value: widget.data.activeServices.toString(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatContainer(
                      title: 'Total Reviews',
                      value: widget.data.totalReviews.toString(),
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
  }*/

class AllContractorCard extends StatefulWidget {
  final OverAllContractorItem data;
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
    final userId = widget.data.userId;

    contractorProfile = await widget.contractor.getContractorById(userId);
  }

  @override
  Widget build(BuildContext context) {
    final compare = Get.put(ContractorCompareManager(), permanent: true);

    final user = widget.data;

    return GestureDetector(
      onTap: () async {
        log("Tapped Contractor Profile Data: ${contractorProfile?.toJson()}");

        contractorProfile?.username = widget.data.username ?? '';
        contractorProfile?.firstName = widget.data.firstName ?? '';
        contractorProfile?.lastName = widget.data.lastName ?? '';
        contractorProfile?.totalExperience = widget.data.totalExperience ?? 0;
        // contractorProfile?.projectStats.totalProjects = data.profile.??  0;

        if (contractorProfile != null) {
          Get.to(
            () => ContractorProfileDetailsScreen(
              contractor: contractorProfile ?? Contractor.fromJson({}),
            ),
          );
        } else {
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Not Found',
            message: 'Contractor profile could not be loaded.',
            contentType: ContentType.failure,
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
                Container(
                  width: 80, // same as radius * 2 of CircleAvatar
                  height: 80,
                  decoration: BoxDecoration(
                    color: ColorRes.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    // square with rounded corners, adjust as needed
                    image:
                        (widget.data.profilePic != null &&
                                widget.data.profilePic!.isNotEmpty)
                            ? DecorationImage(
                              image: NetworkImage(widget.data.profilePic!),
                              fit: BoxFit.cover,
                            )
                            : null,
                  ),
                  child:
                      (widget.data.profilePic?.isEmpty ?? true)
                          ? Center(
                            child: Text(
                              _getInitials(widget.data.username ?? 'U'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorRes.primary,
                              ),
                            ),
                          )
                          : null,
                ),

                const SizedBox(width: 12),

                /// ===================== NAME & EXPERIENCE =====================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.data.username ?? 'Unknown Contractor',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: ColorRes.textColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8),
                          if (widget.data.contractorVisitCharge != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: ColorRes.green.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '\$${widget.data.contractorVisitCharge}/visit',
                                style: TextStyle(
                                  fontSize: AppFontSizes.small,
                                  fontWeight: FontWeight.w600,
                                  color: ColorRes.green,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      /// Location + Experience
                      Text(
                        '${widget.data.city ?? ''}, ${widget.data.state ?? ''}',
                        style: TextStyle(
                          fontSize: AppFontSizes.caption,
                          fontWeight: AppFontWeights.medium,
                          color: ColorRes.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 4,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (widget.data.subscription?.hasPremiumPlan ?? false)
                            _buildBadge(
                              label: 'PREMIUM',
                              backgroundColor: ColorRes.orangeColor.withOpacity(
                                0.12,
                              ),
                              textColor: ColorRes.orangeColor,
                            ),
                          if (widget.data.contractorType != null &&
                              widget.data.contractorType!.isNotEmpty) ...[
                            _buildBadge(
                              label:
                                  widget.data.contractorType?.toUpperCase() ??
                                  '',
                              backgroundColor: ColorRes.primary.withOpacity(
                                0.12,
                              ),
                              textColor: ColorRes.primary,
                            ),
                          ],
                          if (widget.data.totalExperience != null &&
                              widget.data.totalExperience! > 0) ...[
                            _buildBadge(
                              label:
                                  '${widget.data.totalExperience.toString()} Year Experience' ??
                                  '',
                              backgroundColor: ColorRes.primary.withOpacity(
                                0.12,
                              ),
                              textColor: ColorRes.primary,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                /// ===================== COMPARE BUTTON =====================
              ],
            ),

            const SizedBox(height: 10),

            /// SERVICES CHIPS
            if (widget.data.servicesInCategory.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  ...widget.data.servicesInCategory
                      .take(2)
                      .map(
                        (service) => _buildServiceChip(
                          serviceName: service.serviceName ?? '',
                          rating: service.rating.toString(),
                        ),
                      ),
                  if (widget.data.servicesInCategory.length > 2)
                    _buildServiceChip(
                      serviceName:
                          '+${widget.data.servicesInCategory.length - 2} more services',
                      isMore: true,
                    ),
                ],
              ),
            const SizedBox(height: 10),

            /// RATING + CONTACT BUTTON
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: ColorRes.homeAmber.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: ColorRes.leadGreyColor.shade300,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Stars
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      // Rating text
                      Text(
                        '${double.tryParse(widget.data.overallRating)?.toStringAsFixed(1) ?? '0.0'} '
                        '(${Formatter.formatNumber(widget.data.totalReviews) ?? 0} reviews)',
                        style: TextStyle(
                          fontSize: AppFontSizes.caption,
                          fontWeight: AppFontWeights.medium,
                          color: ColorRes.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
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
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    log(
                      "Tapped Contractor Profile Data: ${contractorProfile?.toJson()}",
                    );

                    contractorProfile?.username = widget.data.username ?? '';
                    contractorProfile?.firstName = widget.data.firstName ?? '';
                    contractorProfile?.lastName = widget.data.lastName ?? '';
                    contractorProfile?.totalExperience =
                        widget.data.totalExperience ?? 0;
                    // contractorProfile?.projectStats.totalProjects = data.profile.??  0;

                    if (contractorProfile != null) {
                      Get.to(
                        () => ContractorProfileDetailsScreen(
                          contractor:
                              contractorProfile ?? Contractor.fromJson({}),
                        ),
                      );
                    } else {
                      NesticoPeSnackBar.showAwesomeSnackbar(
                        title: 'Not Found',
                        message: 'Contractor profile could not be loaded.',
                        contentType: ContentType.failure,
                      );
                    }
                  },
                  // icon: const Icon(Icons.phone, size: 16),
                  child: const Text('Contact Now'),
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceChip({
    required String serviceName,
    bool isMore = false,
    String rating = '',
  }) {
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color:
              isMore
                  ? ColorRes.primary.withOpacity(0.1)
                  : ColorRes.leadGreyColor.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // <-- important
          children: [
            Text(
              serviceName,
              style: TextStyle(
                fontSize: AppFontSizes.caption,
                fontWeight: AppFontWeights.medium,
                color: isMore ? ColorRes.primary : ColorRes.textColor,
              ),
            ),
            if (!isMore) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: ColorRes.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: ColorRes.leadGreyColor.shade300,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${double.tryParse(rating)?.toStringAsFixed(1) ?? '0.0'}',
                      style: TextStyle(
                        fontSize: AppFontSizes.caption,
                        fontWeight: AppFontWeights.medium,
                        color: ColorRes.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBadge({
    required String label,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: textColor.withOpacity(0.3), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
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

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
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
