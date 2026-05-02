import 'package:flutter/material.dart';
import 'package:nesticope_app/modules/contractor/controller/contractor_category_service_controller.dart';
import 'package:nesticope_app/modules/contractor/view/widget/contractor_subcategory_service.dart';
import 'package:nesticope_app/modules/hire_contractor/view/widget/category_service_explorer.dart';
import 'package:nesticope_app/utils/shimmer/buyer/hire_contractor/buyer_hire_contractor_category_list_screen_shimmer.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../data/network/contractor/model/contractot_service_model/contractor_category_model.dart';
import '../../controller/contractor_my_service_controller.dart';
import 'package:get/get.dart';


class MyServiceScreen extends StatelessWidget {
  const MyServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContractorCategoryServiceController());

    
    return Scaffold(
      backgroundColor: ColorRes.background,
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Get.back();
        }, icon: Icon(Icons.arrow_back)),
        backgroundColor: ColorRes.white,
        elevation: 0,
        title: Text(
          'Service Categories',
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
                      Get.to(() => ContractorCategoryServiceExplorer(
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
  Widget _buildCategoryCard(ContractorServiceCategory category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.surface,
        borderRadius: BorderRadius.circular(12),
      boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ], 
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
            ],
          ),

          const SizedBox(height: 6),

          // Description
          Text(
            category.description.join('\n'),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppFontSizes.extraSmall,
              color: ColorRes.textSecondary,
              height: 1.6,
              
              fontWeight: AppFontWeights.medium,
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
  void _showServiceDialog(BuildContext context, ContractorServiceCategory service) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: ColorRes.white,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                    Text(
                      service.name,
                      style: TextStyle(
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: service.isActive
                            ? ColorRes.success.withOpacity(0.1)
                            : ColorRes.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        service.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: AppFontSizes.small,
                          fontWeight: AppFontWeights.medium,
                          color: service.isActive
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
                  service.description.join('\n'),
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.textSecondary,
                  ),
                ),

                const SizedBox(height: 16),
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

  Widget _buildServiceCard(ContractorServiceCategory service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.surface,
        borderRadius: BorderRadius.circular(12),
      border: Border.all(color: ColorRes.leadGreyColor.shade300,width: 1)
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
                  service.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: service.isActive
                      ? ColorRes.success.withOpacity(0.1)
                      : ColorRes.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  service.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    fontWeight: AppFontWeights.medium,
                    color:
                    service.isActive ? ColorRes.success : ColorRes.error,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Description
          Text(
            service.description.join('\n'),
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
            _formatDate(service.createdAt),
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
    // Format like "15 Aug 2023"
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
