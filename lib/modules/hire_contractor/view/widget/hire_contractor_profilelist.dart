import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/hire_contractor/view/widget/hire_contractor_filter.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../data/network/contractor/model/contractor_compare_model/contractor_compare_model.dart';
import '../../../contractor/view/profile/contractot_profile.dart';
import '../../../home/controllers/contractor_profile_controller/contractor_compare_manager.dart';
import '../../../home/widgets/contractor_profile_card.dart';
import '../../controller/hire_contractor_controller.dart';
import '../../controller/hire_contractor_list_of_profile_controller.dart';

class HireContractorProfileList extends StatelessWidget {
  const HireContractorProfileList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HireContractorController>();
    final controllerProfileData = Get.find<HireContractorListOfProfileController>();
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
        title: Text(
          'All Contractor',
          style: TextStyle(
            color: ColorRes.textPrimary,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(onPressed: () {
            Get.to(()=>HireContractorFilter());
          }, icon: Icon(Icons.filter_list))
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
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
            // child: ListView.builder(
            //   itemCount: controllerProfileData.items.length,
            //   itemBuilder: (context, index) {
            //     final category = controllerProfileData.items[index];
            //     return GestureDetector(
            //       onTap: () {
            //         // _showCategoryDialog(context, category);
            //         // controllerProfileData.fetchHireContractorByCategoryID(category.id, category.name);
            //       },
            //       child:AllContractorCard(contractor: )
            //     );
            //   },
            // ),
            child: ListView.builder(
              itemCount: controllerProfileData.combinedList.length,
              itemBuilder: (context, index) {
                final item = controllerProfileData.combinedList[index];
                return AllContractorCard(data: item);
              },
            )
          ),
        );
      }),
    );
  }
}
class AllContractorCard extends StatelessWidget {
  final HireContractorUserWithProfile data;

  const AllContractorCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final compare = Get.put(ContractorCompareManager(), permanent: true);

    final user = data.user;
    final profile = data.profile;

    return GestureDetector(
      onTap: () {
        // Navigate to profile detail (pass user or combined model)
        // Get.to(() => ContractorProfileScreen(user: user, profile: profile));
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
                  backgroundImage: (user.profilePic?.isNotEmpty ?? false)
                      ? NetworkImage(user.profilePic!)
                      : null,
                  onBackgroundImageError: (user.profilePic?.isNotEmpty ?? false)
                      ? (_, __) {} // only active if image is non-null
                      : null,
                  child: (user.profilePic?.isEmpty ?? true)
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
                  onTap: () {
                    // compare.toggle(user, max: 2);
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
                      return const Icon(Icons.star, color: Colors.amber, size: 16);
                    } else if (index < rating) {
                      return const Icon(Icons.star_half, color: Colors.amber, size: 16);
                    } else {
                      return Icon(Icons.star_border, color: Colors.amber.shade400, size: 16);
                    }
                  }),
                ),
                const SizedBox(width: 6),
                Text(
                  (double.tryParse(profile.overallRating)?.toStringAsFixed(1)) ?? '0.0',
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
