import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/hire_contractor/view/widget/hire_contractor_profilelist.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../data/network/contractor/model/contractot_service_model/contractor_category_model.dart';
import '../../../utils/shimmer/buyer/hire_contractor/buyer_hire_contractor_category_list_screen_shimmer.dart';
import '../controller/hire_contractor_controller.dart';
import '../controller/hire_contractor_filter_controller.dart';
import '../controller/hire_contractor_list_of_profile_controller.dart';
import '../controller/hire_contractor_new_controller.dart';
import 'widget/category_service_explorer.dart';

class HireContractorScreen extends StatelessWidget {
  const HireContractorScreen({super.key});

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

    return Scaffold(
      backgroundColor: ColorRes.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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

        return RefreshIndicator(
          onRefresh: () => controller.refreshService(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Builder(builder: (context) {
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
              return ListView.builder(
                itemCount: sorted.length,
                itemBuilder: (context, index) {
                  final category = sorted[index];
                return GestureDetector(
                  onTap: () {
                      Get.to(() => CategoryServiceExplorer(
                            categoryId: category.id,
                            categoryName: category.name,
                          ));
                  },
                  child: _buildCategoryCard(category),
                );
                },
              );
            }),
          ),
        );
      }),
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
          color: isHomeConstruction ? ColorRes.primary : ColorRes.leadGreyColor.shade300,
          width:isHomeConstruction?2.5: 1,
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
                  child: Image.network(category.icon ?? '', fit: BoxFit.contain),
                )
              else
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: ColorRes.leadGreyColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.category, color: ColorRes.textSecondary, size: 24),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ColorRes.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: ColorRes.primary.withOpacity(0.35)),
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
          Text(
            category.description,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppFontSizes.extraSmall,
              color: ColorRes.textSecondary,
              height: 1.6,
              
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
      'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }
}
