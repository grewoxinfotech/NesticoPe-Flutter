import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/app/widgets/texts/headline_text.dart';
import 'package:nesticope_app/modules/home/controllers/contractor_profile_controller/contractor_profile_controller.dart';
import 'package:nesticope_app/modules/home/widgets/contractor_profile_card.dart';
import 'package:nesticope_app/modules/contractor/view/all_contractors_list_screen.dart';
import 'package:nesticope_app/app/widgets/image/custom_image.dart';
import 'package:nesticope_app/modules/hire_contractor/view/widget/hire_contractor_profilelist.dart';
import 'package:nesticope_app/modules/home/widgets/top_categories_section.dart';
import 'package:nesticope_app/utils/shimmer/buyer/hire_contractor/buyer_hire_contractor_list_screen_shimmer.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../data/network/contractor/model/contractot_service_model/contractor_category_model.dart';
import '../../../utils/shimmer/buyer/hire_contractor/buyer_hire_contractor_category_list_screen_shimmer.dart';
import '../controller/hire_contractor_controller.dart';
import '../controller/hire_contractor_filter_controller.dart';
import '../controller/hire_contractor_list_of_profile_controller.dart';
import '../controller/hire_contractor_new_controller.dart';
import 'widget/category_service_explorer.dart';

import 'package:nesticope_app/modules/home/widgets/unified_comparison_floating_button.dart';

class HireContractorScreen extends StatelessWidget {
  final bool fromDashboard;
  const HireContractorScreen({super.key, this.fromDashboard = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HireContractorController());
    final controllerNew = Get.put(HireContractorNewController());
    final controllerProfileData = Get.put(
      HireContractorListOfProfileController(),
    );
    final controllerFilterData = Get.put(
      HireContractorFilterProfileController(),
    );
    final contractorsController = Get.put(
      TopContractorsController(withoutCity: true),
      tag: 'contractors_home',
    );

    // Service journey data to render the horizontal timeline cards
    final serviceJourney = [
      {
        'step': '1',
        'title': 'Select Service',
        'subtitle': 'Choose Your Requirement',
        'desc':
            'Browse and select the service you need (Plumber, Electrician, Interior, etc.).',
        'icon': Icons.search,
        'color': ColorRes.primary,
      },
      {
        'step': '2',
        'title': 'Filter Contractors',
        'subtitle': 'Find the Best Match',
        'desc':
            'Apply filters like location, budget, rating, and experience to shortlist contractors.',
        'icon': Icons.filter_list,
        'color': ColorRes.lightPurpleColor,
      },
      {
        'step': '3',
        'title': 'Compare Contractors',
        'subtitle': 'Make the Right Choice',
        'desc':
            'Compare profiles, reviews, pricing, and past work before selecting.',
        'icon': Icons.compare_arrows,
        'color': ColorRes.success,
      },
      {
        'step': '4',
        'title': 'Add Inquiry',
        'subtitle': 'Submit Your Requirement',
        'desc': 'Share your project details, budget, and preferred timeline.',
        'icon': Icons.edit_note,
        'color': ColorRes.warning,
      },
      {
        'step': '5',
        'title': 'Get Quotation & Confirm',
        'subtitle': 'Finalize the Deal',
        'desc':
            'Receive quotations, negotiate, and confirm booking with the contractor.',
        'icon': Icons.question_answer_outlined,
        'color': ColorRes.primary,
      },
      {
        'step': '6',
        'title': 'Work In Progress',
        'subtitle': 'Track Your Project',
        'desc':
            'Monitor updates, communicate with the contractor, and stay informed.',
        'icon': Icons.work,
        'color': ColorRes.lightPurpleColor,
      },
      {
        'step': '7',
        'title': 'Work Completion & Payment',
        'subtitle': 'Secure Payment & Closure',
        'desc': 'Approve completed work and make payment safely.',
        'icon': Icons.check_circle,
        'color': ColorRes.success,
      },
    ];

    return Scaffold(
      backgroundColor: ColorRes.background,
      appBar: AppBar(
        leading:
            fromDashboard
                ? null
                : IconButton(
                  icon: Icon(Icons.arrow_back, color: ColorRes.textPrimary),
                  onPressed: () => Get.back(),
                ),
        backgroundColor: ColorRes.white,
        elevation: 0,
        title: Text(
          'NesticoPe Verified Services',
          style: TextStyle(
            color: ColorRes.textPrimary,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.value && controller.items.isEmpty) {
              return BuyerHireContractorCategoryListScreenShimmer();
            }

            if (controller.items.isEmpty) {
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

            return SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.refreshService();
                  await contractorsController.refreshList();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Builder(
                    builder: (context) {
                      String norm(String s) => s
                          .trim()
                          .toLowerCase()
                          .replaceAll('&', 'and')
                          .replaceAll(RegExp(r'[^a-z0-9]+'), '_');
                      final order = <String, int>{
                        'home_construction': 1,
                        'building_material_supply': 2,
                        'material_supply': 2,
                        'home_services': 3,
                        'interior_design': 4,
                        'packers_and_movers': 5,
                        'packers_movers': 5,
                        'legal_services': 6,
                      };
                      final sorted = [...controller.items]..sort((a, b) {
                        final ai = order[norm(a.name)] ?? 999;
                        final bi = order[norm(b.name)] ?? 999;
                        return ai.compareTo(bi);
                      });
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            color: Color.fromARGB(255, 235, 244, 252),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // const SizedBox(height: 12),
                                  TitleWithViewAll(
                                    title: "NesticoPe Verified Services",
                                    showViewAll: false,
                                    subTitle: 'View all verified services',
                                    isSubTitle: true,
                                    showIcon: true,
                                    iconBgColor: ColorRes.primary.withOpacity(
                                      0.1,
                                    ),

                                    icon: Icons.verified_user,
                                    iconColor: ColorRes.primary,

                                    // size: 24,
                                    // margin: const EdgeInsets.only(right: 8),
                                  ),
                                  const SizedBox(height: 12),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 6,
                                          // mainAxisSpacing: 8,
                                          // childAspectRatio: 1,
                                          mainAxisSpacing: 12,
                                          childAspectRatio: 0.75,
                                        ),
                                    itemCount: sorted.length,
                                    itemBuilder: (context, index) {
                                      final category = sorted[index];
                                      return CategoryCard(
                                        // context,
                                        item: category,
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 12),

                          // Service Journey - horizontal scroll cards
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleWithViewAll(
                                title: "Complete Service Journey",
                                subTitle: 'How the process works',
                                isSubTitle: true,
                                icon: Icons.timeline,
                                iconColor: ColorRes.primary,
                                showIcon: true,
                                showViewAll: false,
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 180,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,

                                  itemCount: serviceJourney.length,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  separatorBuilder:
                                      (_, __) => Row(
                                        children: List.generate(4, (index) {
                                          return Container(
                                            // margin: const EdgeInsets.symmetric(horizontal: 2),
                                            width: 6,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  ColorRes.primary.withOpacity(
                                                    0.8,
                                                  ),
                                                  ColorRes.primary.withOpacity(
                                                    0.3,
                                                  ),
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              ),
                                              // shape: BoxShape.circle,
                                            ),
                                          );
                                        }),
                                      ),
                                  itemBuilder: (context, idx) {
                                    final s = serviceJourney[idx];
                                    return _ServiceJourneyCard(
                                      step: s['step'] as String,
                                      title: s['title'] as String,
                                      subtitle: s['subtitle'] as String,
                                      desc: s['desc'] as String,
                                      icon: s['icon'] as IconData,
                                      color: s['color'] as Color,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),

                          Obx(() {
                            if (contractorsController.isLoading.value &&
                                contractorsController.items.isEmpty) {
                              return const BuyerHireContractorListScreenShimmer(
                                embedded: true,
                              );
                            }
                            if (contractorsController.items.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            final count =
                                contractorsController.items.length > 6
                                    ? 6
                                    : contractorsController.items.length;
                            return Column(
                              children: [
                                TitleWithViewAll(
                                  title: "Top Rated Contractors",
                                  subTitle: 'Connect with top contractors',
                                  isSubTitle: true,
                                  icon: Icons.home_repair_service_outlined,
                                  iconColor: ColorRes.lightPurpleColor,
                                  showIcon: true,

                                  iconBgColor: ColorRes.lightPurpleColor
                                      .withOpacity(0.1),
                                  showViewAll: true,

                                  onViewAll:
                                      () => Get.to(
                                        () => const AllContractorsListScreen(),
                                      ),
                                  // size: 24,
                                  // margin: const EdgeInsets.only(right: 8),
                                ),
                                const SizedBox(height: 8),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(
                                //     horizontal: 16.0,
                                //   ),
                                //   child: ListView.separated(
                                //     shrinkWrap: true,
                                //     physics:
                                //         const NeverScrollableScrollPhysics(),
                                //     itemCount: count,
                                //     separatorBuilder:
                                //         (_, __) => const SizedBox(height: 8),
                                //     itemBuilder: (context, index) {
                                //       final data =
                                //           contractorsController.items[index];
                                //       return ContractorCard(contractor: data);
                                //     },
                                //   ),
                                // ),
                                _HorizontalContractorList(
                                  items: contractorsController.items.sublist(
                                    0,
                                    count,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          }),
          const UnifiedComparisonFloatingButton(bottom: 16),
        ],
      ),
    );
  }

  void _showCategoryDialog(
    BuildContext context,
    ContractorServiceCategory category,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: ColorRes.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        category.name,
                        style: TextStyle(
                          fontSize: AppFontSizes.medium,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            category.isActive
                                ? ColorRes.success.withOpacity(0.1)
                                : ColorRes.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: AppFontSizes.small,
                          fontWeight: AppFontWeights.medium,
                          color:
                              category.isActive
                                  ? ColorRes.success
                                  : ColorRes.error,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  category.description.join('\n'),
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.textSecondary,
                  ),
                ),

                const SizedBox(height: 16),

                // Close button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight: AppFontWeights.medium,
                        color: ColorRes.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(ContractorServiceCategory category) {
    String norm(String s) => s
        .trim()
        .toLowerCase()
        .replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    final key = norm(category.name);
    final isHomeConstruction = key == 'home_construction';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isHomeConstruction
                  ? ColorRes.primary
                  : ColorRes.leadGreyColor.shade300,
          width: isHomeConstruction ? 2.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and status row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if ((category.icon ?? '').isNotEmpty)
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.network(
                    category.icon ?? '',
                    fit: BoxFit.contain,
                  ),
                )
              else
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: ColorRes.leadGreyColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.category,
                    color: ColorRes.textSecondary,
                    size: 24,
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category.name,

                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                ),
              ),
              if (isHomeConstruction)
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: ColorRes.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: ColorRes.primary.withOpacity(0.35),
                      ),
                    ),
                    child: Text(
                      'MOST POPULAR',
                      style: TextStyle(
                        color: ColorRes.primary,
                        fontSize: 10,
                        fontWeight: AppFontWeights.semiBold,
                        letterSpacing: .3,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 6),

          // Description
          // Bullet points description
          ...((category.description)
              .where((line) => line.trim().isNotEmpty)
              .map((line) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Icon(
                          Icons.check_circle,
                          size: 14,
                          color: ColorRes.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          line.trim().startsWith('•')
                              ? line.trim().substring(1).trim()
                              : line.trim(),
                          style: TextStyle(
                            fontSize: 11,
                            color: ColorRes.leadGreyColor.shade700,
                            fontWeight: AppFontWeights.medium,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })
              .toList()),

          const SizedBox(height: 10),

          // Date
          Text(
            'Created on ${_formatDate(category.createdAt)}',
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: AppFontWeights.medium,
              color: ColorRes.textDisabled,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildCategoryImageTile(
  //   BuildContext context,
  //   ContractorServiceCategory category,
  // ) {
  //   final img = _categoryImageFor(category.name);
  //   String norm(String s) => s
  //       .trim()
  //       .toLowerCase()
  //       .replaceAll('&', 'and')
  //       .replaceAll(RegExp(r'[^a-z0-9]+'), '_');
  //   final key = norm(category.name);
  //   final isHomeConstruction = key == 'home_construction';

  //   return Material(
  //     color: Colors.transparent,
  //     child: InkWell(
  //       borderRadius: BorderRadius.circular(14),
  //       onTap: () {
  //         Get.to(
  //           () => CategoryServiceExplorer(
  //             categoryId: category.id,
  //             categoryName: category.name,
  //           ),
  //         );
  //       },
  //       child: Stack(
  //         children: [
  //           /// ✅ IMAGE (no blend, no color)
  //           // Image.asset(
  //           //   img,
  //           //   fit: BoxFit.cover,
  //           //   width: double.infinity,
  //           //   height: double.infinity,
  //           // ),
  //           Positioned.fill(
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
  //               child: CustomImage(
  //                 type: CustomImageType.asset,
  //                 src: img,
  //                 fit: BoxFit.cover,

  //                 // height: 170,
  //                 // width: double.infinity,
  //               ),
  //             ),
  //           ),
  //           Positioned.fill(
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
  //                 boxShadow:
  //                     isHomeConstruction
  //                         ? [
  //                           BoxShadow(
  //                             color: ColorRes.primary.withOpacity(0.2),
  //                             blurRadius: 12,
  //                             offset: const Offset(0, 4),
  //                           ),
  //                         ]
  //                         : null,
  //                 gradient: LinearGradient(
  //                   begin: Alignment.topCenter,
  //                   end: Alignment.bottomCenter,
  //                   colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
  //                 ),
  //                 border:
  //                     isHomeConstruction
  //                         ? Border.all(color: ColorRes.primary, width: 2.5)
  //                         : null,
  //               ),
  //             ),
  //           ),
  // if (isHomeConstruction)
  //   Positioned(
  //     top: 8,
  //     right: 8,
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(
  //         horizontal: 6,
  //         vertical: 2,
  //       ),
  //       decoration: BoxDecoration(
  //         color: ColorRes.primary,
  //         borderRadius: BorderRadius.circular(4),
  //       ),
  //       child: const Text(
  //         'Most Popular',
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: AppFontSizes.caption,
  //           fontWeight: AppFontWeights.bold,
  //         ),
  //       ),
  //     ),
  //   ),

  //           /// ✅ TEXT
  //           Positioned(
  //             left: 10,
  //             right: 10,
  //             bottom: 10,
  //             child: Text(
  //               category.name,
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontWeight: AppFontWeights.semiBold,
  //                 fontSize: AppFontSizes.small,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildCategoryImageTile(
    BuildContext context,
    ContractorServiceCategory category,
  ) {
    String norm(String s) => s
        .trim()
        .toLowerCase()
        .replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_');

    final key = norm(category.name);

    final isPopular = key == 'home_construction';

    /// 🎨 Gradient mapping
    final gradientMap = {
      'home_construction': [Color(0xFF8E7CFF), Color(0xFF6A5AE0)],
      'interior_design': [Color(0xFF1EC8C8), Color(0xFF2FA4A9)],
      'packers_and_movers': [Color(0xFFFF7A3D), Color(0xFFFF5C2B)],
      'legal_services': [Color(0xFFFF5F8F), Color(0xFFE94057)],
      'home_services': [
        Color.fromARGB(255, 254, 120, 79),
        Color.fromARGB(255, 212, 0, 254),
      ],
      'building_material_supply': [Color(0xFFB06AB3), Color(0xFF4568DC)],
    };

    final colors =
        gradientMap[key] ??
        [ColorRes.primary, ColorRes.primary.withOpacity(0.7)];

    /// 🎯 Icon mapping
    final iconMap = {
      'home_construction': Icons.home_work_outlined,
      'interior_design': Icons.chair_alt_outlined,
      'packers_and_movers': Icons.local_shipping,
      'legal_services': Icons.gavel_outlined,
      'home_services': Icons.miscellaneous_services_outlined,
      'building_material_supply': Icons.inventory_2_outlined,
    };

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Get.to(
          () => CategoryServiceExplorer(
            categoryId: category.id,
            categoryName: category.name,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border:
              isPopular
                  ? Border.all(color: ColorRes.primary, width: 2)
                  : Border.all(color: Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            /// 🔥 Faded Icon
            Positioned(
              right: -5,
              bottom: -5,
              child: Icon(
                iconMap[key] ?? Icons.home,
                size: 80,
                color: Colors.white.withOpacity(0.3),
              ),
            ),

            // if (isPopular)
            //   Positioned(
            //     top: 8,
            //     left: 8,
            //     child: Container(
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 6,
            //         vertical: 2,
            //       ),
            //       decoration: BoxDecoration(
            //         color: ColorRes.primary,
            //         borderRadius: BorderRadius.circular(4),
            //       ),
            //       child: const Text(
            //         'Most Popular',
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: AppFontSizes.caption,
            //           fontWeight: AppFontWeights.bold,
            //         ),
            //       ),
            //     ),
            //   ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isPopular)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      margin: const EdgeInsets.only(left: 8, top: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Most Popular',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppFontSizes.caption,
                          fontWeight: AppFontWeights.bold,
                        ),
                      ),
                    ),
                  ),

                /// ⭐ Badge
                // if (isPopular)
                //   Container(
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                //     decoration: BoxDecoration(
                //       color: Colors.black.withOpacity(0.2),
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     child: const Text(
                //       'Most Popular',
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 10,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
                //   ),

                /// 🧾 Title
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    category.name,
                    // maxLines: 2,
                    // overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                /// 🎯 CTA Button
                // Container(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                //   child: const Text(
                //     "BOOK NOW",
                //     style: TextStyle(
                //       fontSize: 10,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _categoryImageFor(String name) {
    String norm(String s) => s
        .trim()
        .toLowerCase()
        .replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    final key = norm(name);
    if (key == 'home_construction') {
      return 'assets/images/home_construction_image.png';
    }
    if (key == 'building_material_supply' || key == 'material_supply') {
      return 'assets/images/material_supply_image.png';
    }
    if (key == 'interior_design') {
      return 'assets/images/interio_design_image.png';
    }
    if (key == 'packers_and_movers' || key == 'packers_movers') {
      return 'assets/images/packer_and_mover_image.png';
    }
    if (key == 'home_services') {
      return 'assets/images/home_service_image.png';
    }
    if (key == 'legal_services') {
      return 'assets/images/legal_service_image.png';
    }
    return 'assets/images/not_available_image.png';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }
}

class _ServiceJourneyCard extends StatelessWidget {
  final String step;
  final String title;
  final String subtitle;
  final String desc;
  final IconData icon;
  final Color color;

  const _ServiceJourneyCard({
    required this.step,
    required this.title,
    required this.subtitle,
    required this.desc,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color, width: 2),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 68,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(child: Icon(icon, color: color, size: 22)),
                    ),
                    Positioned(
                      left: -5,
                      // right: 10,
                      // bottom: -6,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: color,
                        child: Text(
                          step,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: AppFontWeights.semiBold,
                            fontSize: AppFontSizes.caption,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: AppFontSizes.bodyMedium,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        color: ColorRes.textPrimary,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      desc,
                      style: TextStyle(
                        fontSize: AppFontSizes.caption,
                        color: ColorRes.leadGreyColor.shade700,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HorizontalContractorList extends StatefulWidget {
  final List items;

  const _HorizontalContractorList({required this.items});

  @override
  State<_HorizontalContractorList> createState() =>
      _HorizontalContractorListState();
}

class _HorizontalContractorListState extends State<_HorizontalContractorList> {
  final PageController _pageController = PageController(
    viewportFraction: 0.88, // shows a peek of the next card
  );

  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.items.length;

    return Column(
      children: [
        SizedBox(
          height: 350,
          // adjust to match your ContractorCard height
          child: PageView.builder(
            controller: _pageController,
            itemCount: count,

            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: 6, right: 6),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: ContractorCard(contractor: widget.items[index]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(count, (index) {
            final isActive = index == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color:
                    isActive
                        ? ColorRes.primary
                        : ColorRes.primary.withOpacity(0.25),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class CategoryCard extends StatefulWidget {
  final ContractorServiceCategory item;

  const CategoryCard({required this.item});

  @override
  State<CategoryCard> createState() => CategoryCardState();
}

class CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double scrollOffset = 0;

  String norm(String s) => s
      .trim()
      .toLowerCase()
      .replaceAll('&', 'and')
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_');

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _assetFor(String name) {
    final key = name
        .trim()
        .toLowerCase()
        .replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    if (key == 'home_construction') {
      return 'assets/images/home_construction_image.png';
    } else if (key == 'material_supply' || key == 'building_material_supply') {
      return 'assets/images/material_supply_image.png';
    } else if (key == 'interior_design' || key == 'interio_design') {
      return 'assets/images/interio_design_image.png';
    } else if (key == 'packers_and_movers' ||
        key == 'packers_movers' ||
        key == 'packer_and_mover') {
      return 'assets/images/packer_and_mover_image.png';
    } else if (key == 'home_services' || key == 'home_service') {
      return 'assets/images/home_service_image.png';
    } else if (key == 'legal_services' || key == 'legal_service') {
      return 'assets/images/legal_service_image.png';
    }
    return 'assets/images/not_available_image.png';
  }

  // @override
  @override
  Widget build(BuildContext context) {
    Get.put(HireContractorController());
    Get.put(HireContractorNewController());
    Get.put(HireContractorListOfProfileController());
    Get.put(HireContractorFilterProfileController());

    String norm(String s) => s
        .trim()
        .toLowerCase()
        .replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_');

    final key = norm(widget.item.name);
    final isPopular = key == 'home_construction';

    /// 🎨 Gradient map
    final gradientMap = {
      'home_construction': [Color(0xFF8E7CFF), Color(0xFF6A5AE0)],
      'interior_design': [Color(0xFF1EC8C8), Color(0xFF2FA4A9)],
      'packers_and_movers': [Color(0xFFFF7A3D), Color(0xFFFF5C2B)],
      'legal_services': [Color(0xFFFF5F8F), Color(0xFFE94057)],
      'home_services': [
        Color.fromARGB(255, 254, 120, 79),
        Color.fromARGB(255, 212, 0, 254),
      ],
      'material_supply': [Color(0xFFB06AB3), Color(0xFF4568DC)],
      'building_material_supply': [Color(0xFFB06AB3), Color(0xFF4568DC)],
    };

    final colors =
        gradientMap[key] ??
        [ColorRes.primary, ColorRes.primary.withOpacity(0.7)];

    /// 🎯 Icon map
    final iconMap = {
      'home_construction': Icons.home_work_outlined,
      'interior_design': Icons.chair_alt_outlined,
      'packers_and_movers': Icons.local_shipping,
      'legal_services': Icons.gavel_outlined,
      'home_services': Icons.miscellaneous_services_outlined,
      'material_supply': Icons.inventory_2_outlined,
      'building_material_supply': Icons.inventory_2_outlined,
    };

    // return GestureDetector(
    //   onTap: () {
    //     Get.to(
    //       () => CategoryServiceExplorer(
    //         categoryId: widget.item.id,
    //         categoryName: widget.item.name,
    //       ),
    //     );
    //   },
    //   child: Container(
    //     // padding: const EdgeInsets.all(10),
    //     decoration: BoxDecoration(
    //       border:
    //           isPopular
    //               ? Border.all(color: ColorRes.primary, width: 2)
    //               : Border.all(color: Colors.transparent),
    //       gradient: LinearGradient(
    //         colors: colors,
    //         begin: Alignment.topLeft,
    //         end: Alignment.bottomRight,
    //       ),
    //       borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
    //       boxShadow: [
    //         BoxShadow(
    //           color: colors.first.withOpacity(0.25),
    //           blurRadius: 10,
    //           offset: const Offset(0, 6),
    //         ),
    //       ],
    //     ),
    //     child: Stack(
    //       children: [
    //         /// 🔥 Faded Icon (background)
    //         Positioned.fill(
    //       child: CustomPaint(painter: DiagonalDashPatternPainter()),
    //     ),
    //         Positioned(
    //           right: -5,
    //           bottom: -5,
    //           child: Icon(
    //             iconMap[key] ?? Icons.home,
    //             size: 80,
    //             color: Colors.white.withOpacity(0.3),
    //           ),
    //         ),

    //         Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             /// ⭐ Badge
    //             if (isPopular)
    //               Positioned(
    //                 top: 8,
    //                 left: 8,
    //                 child: Container(
    //                   margin: const EdgeInsets.only(left: 8, top: 8),
    //                   padding: const EdgeInsets.symmetric(
    //                     horizontal: 6,
    //                     vertical: 2,
    //                   ),
    //                   decoration: BoxDecoration(
    //                     color: Colors.black.withOpacity(0.2),
    //                     borderRadius: BorderRadius.circular(10),
    //                   ),
    //                   child: const Text(
    //                     'Most Popular',
    //                     style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: AppFontSizes.caption,
    //                       fontWeight: AppFontWeights.bold,
    //                     ),
    //                   ),
    //                 ),
    //               ),

    //             // const Spacer(),

    //             /// 🧾 Title
    //             Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Text(
    //                 widget.item.name.capitalize?.replaceAll("_", " ") ?? '',
    //                 // maxLines: 2,
    //                 // overflow: TextOverflow.ellipsis,
    //                 style: TextStyle(
    //                   color: Colors.white,
    //                   fontWeight: AppFontWeights.semiBold,
    //                   fontSize: 12,
    //                 ),
    //               ),
    //             ),

    //             const SizedBox(height: 6),

    //             /// 🎯 CTA Button
    //             // Container(
    //             //   padding: const EdgeInsets.symmetric(
    //             //     horizontal: 10,
    //             //     vertical: 5,
    //             //   ),
    //             //   decoration: BoxDecoration(
    //             //     color: Colors.white,
    //             //     borderRadius: BorderRadius.circular(20),
    //             //   ),
    //             //   child: const Text(
    //             //     "BOOK NOW",
    //             //     style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
    //             //   ),
    //             // ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return GestureDetector(
      onTap: () {
        Get.to(
          () => CategoryServiceExplorer(
            categoryId: widget.item.id,
            categoryName: widget.item.name,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border:
              isPopular ? Border.all(color: ColorRes.primary, width: 2) : null,
          borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
        ),
        child: Stack(
          children: [
            /// 🎨 BACKGROUND GRADIENT
            // Positioned.fill(
            //   child: Container(
            //     decoration: BoxDecoration(
            //       gradient: LinearGradient(
            //         colors: [
            //           ColorRes.primary,
            //           ColorRes.primary.withOpacity(0.7),
            //         ],
            //       ),
            //       borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
            //     ),
            //   ),
            // ),

            /// 🔥 PATTERN (DYNAMIC)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  return CustomPaint(painter: _getPainter(widget.item.name));
                },
              ),
            ),

            /// 🎯 ICON
            Positioned(
              right: -5,
              bottom: -5,
              child: Icon(
                iconMap[key] ?? Icons.home,
                size: 80,
                color: Colors.white.withOpacity(0.25),
              ),
            ),

            /// ⭐ BADGE (FIXED POSITION)
            if (isPopular)
              Positioned(
                top: 8,
                left: 4,
                child: _buildShinyText("Most Popular"),
              ),

            /// 🧾 TITLE
            Positioned(
              left: 8,
              bottom: 10,
              right: 10,
              child: Text(
                widget.item.name.capitalize?.replaceAll("_", " ") ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: AppFontWeights.semiBold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomPainter _getPainter(String name) {
    final key = norm(name);

    if (key == 'home_construction') {
      return AdvancedDashPatternPainter(
        animationValue: _controller.value,
        scrollOffset: scrollOffset,
      );
    }

    if (key == 'interior_design') {
      return WaveDashedPatternPainter();
    }

    if (key == 'packers_and_movers') {
      return WaveDashedPatternPainter();
    }

    return SmartDashPatternPainter();
  }

  Widget _buildShinyText(String text) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        /// 🎯 Smooth pulse scale
        final scale = 1 + (0.04 * sin(_controller.value * 2 * 3.1416));

        return Transform.scale(
          scale: scale,

          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: ColorRes.homeYellow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                /// 🧾 Base text (dim)
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: AppFontSizes.caption,
                    fontWeight: AppFontWeights.bold,
                  ),
                ),

                /// ✨ Shimmer text
                ShaderMask(
                  blendMode: BlendMode.srcATop,
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      begin: Alignment(-1.5 + _controller.value * 3, 0),
                      end: Alignment(-0.5 + _controller.value * 3, 0),
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.8),
                        Colors.white,
                        Colors.white.withOpacity(0.8),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.4, 0.5, 0.6, 1.0],
                    ).createShader(bounds);
                  },
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: ColorRes.textPrimary,
                      fontSize: AppFontSizes.caption,
                      fontWeight: AppFontWeights.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class WaveDashedPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.2)
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round;

    const spacingX = 24.0;
    const spacingY = 20.0;
    const dashLength = 8.0;

    for (double x = 0; x < size.width; x += spacingX) {
      for (double y = 0; y < size.height; y += spacingY) {
        final waveOffset = 6 * ((x / spacingX) % 2 == 0 ? 1 : -1);

        canvas.drawLine(
          Offset(x, y + waveOffset),
          Offset(x + dashLength, y - waveOffset),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SmartDashPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.2)
          ..strokeWidth = 1.3
          ..strokeCap = StrokeCap.round;

    const spacing = 26.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        final isEven = ((x ~/ spacing) + (y ~/ spacing)) % 2 == 0;

        if (isEven) {
          // horizontal dash
          canvas.drawLine(Offset(x, y), Offset(x + 6, y), paint);
        } else {
          // vertical dash
          canvas.drawLine(Offset(x, y), Offset(x, y + 6), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DiagonalDashPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.4)
          ..strokeWidth = 1.4
          ..strokeCap = StrokeCap.round;

    const spacing = 22.0;
    const dashLength = 10.0;

    for (double x = -size.height; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashLength, dashLength), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AdvancedDashPatternPainter extends CustomPainter {
  final double animationValue; // 0 → 1
  final double scrollOffset;
  final double opacity;
  final double density;

  AdvancedDashPatternPainter({
    required this.animationValue,
    required this.scrollOffset,
    this.opacity = 0.4,
    this.density = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    /// 🎨 Animated Gradient
    final gradient = LinearGradient(
      begin: Alignment(-1 + animationValue * 2, -1),
      end: Alignment(1 + animationValue * 2, 1),
      colors: [
        Colors.white.withOpacity(opacity * 0.4),
        Colors.white.withOpacity(opacity),
        Colors.white.withOpacity(opacity * 0.4),
      ],
    );

    final paint =
        Paint()
          ..strokeWidth = 1.4
          ..strokeCap = StrokeCap.round
          ..shader = gradient.createShader(
            Rect.fromLTWH(0, 0, size.width, size.height),
          );

    /// 🎯 Dynamic spacing (density control)
    final spacing = 24.0 / density;
    const dashLength = 10.0;

    /// 🌊 Parallax
    final parallax = scrollOffset * 0.15;

    for (double x = -spacing; x < size.width + spacing; x += spacing) {
      for (double y = -spacing; y < size.height + spacing; y += spacing) {
        /// 🔁 Flow animation
        final animatedX = x + (animationValue * spacing);

        /// 🎯 Slight wave offset (adds uniqueness)
        final wave = 4 * ((y / spacing) % 2 == 0 ? 1 : -1);

        final finalY = y + parallax + wave;

        canvas.drawLine(
          Offset(animatedX, finalY),
          Offset(animatedX + dashLength, finalY + dashLength),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant AdvancedDashPatternPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.scrollOffset != scrollOffset ||
        oldDelegate.opacity != opacity ||
        oldDelegate.density != density;
  }
}
