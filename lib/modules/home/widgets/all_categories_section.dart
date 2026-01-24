import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

import 'package:housing_flutter_app/modules/hire_contractor/controller/hire_contractor_controller.dart';

import 'package:housing_flutter_app/modules/hire_contractor/controller/hire_contractor_list_of_profile_controller.dart';


import '../../../app/constants/app_font_sizes.dart';
import '../../../data/network/contractor/model/contractot_service_model/contractor_service_category_model.dart';
import '../../../utils/global.dart';
import '../../hire_contractor/controller/hire_contractor_filter_controller.dart';
import '../../hire_contractor/view/widget/hire_contractor_profilelist.dart';

class AllCategoriesSection extends StatefulWidget {
  final List<TopCategoryItem> categories;

  const AllCategoriesSection({
    super.key,
    required this.categories,
  });

  @override
  State<AllCategoriesSection> createState() => _AllCategoriesSectionState();
}

class _AllCategoriesSectionState extends State<AllCategoriesSection> {
  @override
  Widget build(BuildContext context) {
    final categories = widget.categories ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Categories',
          style: TextStyle(
            color: ColorRes.textPrimary,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
      ),
      body: categories.isEmpty
          ? const Center(child: Text('No categories available'))
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = categories[index];
          return _AllCategoryCard(item: item);
        },
      ),
    );
  }
}

class _AllCategoryCard extends StatelessWidget {
  final TopCategoryItem item;

  const _AllCategoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final matched = contractorServiceCategories.firstWhere(
          (c) => c["name"] == item.name,
      orElse: () => {"icon": Icons.category, "color": Colors.grey},
    );

    final fallbackIcon = matched["icon"] as IconData;
    final fallbackColor = matched["color"] as Color;
    final controller = Get.put(HireContractorController());
    final controllerProfileData = Get.put(HireContractorListOfProfileController());
    final controllerFilterData = Get.put(HireContractorFilterProfileController());

    return GestureDetector(
      onTap: () {
        // controllerFilterData.fetchHireContractorByCategoryID(item.id, item.name);
        controllerFilterData. fetchHireContractorCategories(item.id,item.name);
        Get.to(() => HireContractorProfileList());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (item.icon != null && (item.icon?.isNotEmpty ?? false))
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.network(item.icon ?? '', fit: BoxFit.contain),
                  )
                else
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: fallbackColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12), // 👈 square with rounded corners
                    ),
                    child: Icon(
                      fallbackIcon,
                      color: fallbackColor,
                      size: 25,
                    ),
                  ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    item.name.toUpperCase(),
                    style:  TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ColorRes.primary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
           /* Text(
              (item.name ?? '').toUpperCase(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: ColorRes.primary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),*/
            SizedBox(height: 6,),
            Text(
              item.description ?? 'No description available',
              style: TextStyle(
                fontSize: 11,
                color: ColorRes.leadGreyColor.shade600,
                fontWeight: AppFontWeights.medium,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Divider(color: ColorRes.leadGreyColor.shade300,),
            const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, color: ColorRes.homeAmber, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    (item.averageRating ?? 0).toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: ColorRes.textColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '(${item.serviceCount ?? 0} services)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
