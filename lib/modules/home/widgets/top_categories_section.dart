import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:lottie/lottie.dart';

import '../../../data/network/contractor/model/contractot_service_model/contractor_service_category_model.dart';
import '../../../utils/global.dart';
import '../../hire_contractor/controller/hire_contractor_controller.dart';
import '../../hire_contractor/controller/hire_contractor_filter_controller.dart';
import '../../hire_contractor/controller/hire_contractor_list_of_profile_controller.dart';
import '../../hire_contractor/controller/hire_contractor_new_controller.dart';
import '../../hire_contractor/view/widget/hire_contractor_profilelist.dart';



class TopCategoriesSection extends StatelessWidget {
  final List<TopCategoryItem> categories;

  const TopCategoriesSection({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 165,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),

        itemBuilder: (context, index) {
          return _CategoryCard(item: categories[index]);
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final TopCategoryItem item;

  const _CategoryCard({required this.item});

  @override
  Widget build(BuildContext context) {

    final matched = contractorServiceCategories.firstWhere(
          (c) => c["name"] == item.name,
      orElse: () => {"icon": Icons.category, "color": Colors.grey},
    );

    final fallbackIcon = matched["icon"] as IconData;
    final fallbackColor = matched["color"] as Color;

    final controller = Get.put(HireContractorController());
    final controllerNew = Get.put(HireContractorNewController());
    final controllerProfileData = Get.put(HireContractorListOfProfileController());
    final controllerFilterData = Get.put(HireContractorFilterProfileController());
    return GestureDetector(
      onTap: () {
        // controllerFilterData.fetchHireContractorByCategoryID(item.id, item.name);
        controllerFilterData. fetchHireContractorCategories(item.id,item.name);
        Get.to(()=>HireContractorProfileList());
      },
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Blue Line
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

            const SizedBox(height: 8),
            /// Description
            Text(
              '${item.description}',
              style: TextStyle(
                fontSize: 11,
                color: ColorRes.leadGreyColor.shade600,
                fontWeight: AppFontWeights.medium,
                height: 1.4,
              ),
              maxLines:2,
              overflow: TextOverflow.ellipsis,
            ),
Spacer(),
            Divider(color: ColorRes.leadGreyColor.shade300,),
            SizedBox(height: 2,),

            /// Rating Row (only if available)

              Row(
                children: [
                   Icon(
                    Icons.star,
                    color: ColorRes.homeAmber,
                    size: 15,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item.averageRating.toStringAsFixed(1),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: ColorRes.textColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '(${item.serviceCount} services)',
                    style: TextStyle(
                      fontSize: 10,
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
