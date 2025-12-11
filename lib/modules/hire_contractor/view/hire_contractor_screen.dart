import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/hire_contractor/view/widget/hire_contractor_profilelist.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../data/network/contractor/model/contractot_service_model/contractor_category_model.dart';
import '../controller/hire_contractor_controller.dart';
import '../controller/hire_contractor_list_of_profile_controller.dart';

class HireContractorScreen extends StatelessWidget {
  const HireContractorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HireContractorController());
    final controllerProfileData = Get.put(HireContractorListOfProfileController());

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
          'Hire Contractor',
          style: TextStyle(
            color: ColorRes.textPrimary,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
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

        return RefreshIndicator(
          onRefresh: () => controller.refreshService(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              itemCount: controller.items.length,
              itemBuilder: (context, index) {
                final category = controller.items[index];
                return GestureDetector(
                  onTap: () {
                    // _showCategoryDialog(context, category);
                    Get.to(()=>HireContractorProfileList());
                    controllerProfileData.fetchHireContractorByCategoryID(category.id, category.name);
                  },
                  child: _buildCategoryCard(category),
                );
              },
            ),
          ),
        );
      }),
    );
  }

  void _showCategoryDialog(BuildContext context, ContractorServiceCategory category) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: ColorRes.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
                        color: category.isActive
                            ? ColorRes.success.withOpacity(0.1)
                            : ColorRes.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: AppFontSizes.small,
                          fontWeight: AppFontWeights.medium,
                          color: category.isActive
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
                  category.description,
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorRes.leadGreyColor.shade300,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and status row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: category.isActive
                      ? ColorRes.success.withOpacity(0.1)
                      : ColorRes.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  category.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    fontWeight: AppFontWeights.medium,
                    color: category.isActive
                        ? ColorRes.success
                        : ColorRes.error,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Description
          Text(
            category.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              color: ColorRes.textSecondary,
              fontWeight: AppFontWeights.regular,
            ),
          ),

          const SizedBox(height: 10),

          // Date
          Text(
            _formatDate(category.createdAt),
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              color: ColorRes.textDisabled,
            ),
          ),
        ],
      ),
    );
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
      'Dec'
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }
}