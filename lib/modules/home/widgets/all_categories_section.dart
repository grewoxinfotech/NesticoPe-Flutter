import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';

import 'package:nesticope_app/modules/hire_contractor/controller/hire_contractor_controller.dart';

import 'package:nesticope_app/modules/hire_contractor/controller/hire_contractor_list_of_profile_controller.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../data/network/contractor/model/contractot_service_model/contractor_service_category_model.dart';
import '../../../utils/global.dart';
import '../../hire_contractor/controller/hire_contractor_filter_controller.dart';
import '../../hire_contractor/view/widget/category_service_explorer.dart';

class AllCategoriesSection extends StatefulWidget {
  final List<TopCategoryItem> categories;

  const AllCategoriesSection({super.key, required this.categories});

  @override
  State<AllCategoriesSection> createState() => _AllCategoriesSectionState();
}

class _AllCategoriesSectionState extends State<AllCategoriesSection> {
  @override
  Widget build(BuildContext context) {
    final categories = widget.categories ?? [];
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
    final sorted = [...categories]..sort((a, b) {
      final ai = order[norm(a.name)] ?? 999;
      final bi = order[norm(b.name)] ?? 999;
      return ai.compareTo(bi);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorRes.white,
        title: Text(
          'All Categories',
          style: TextStyle(
            color: ColorRes.textPrimary,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
      ),
      body:
          sorted.isEmpty
              ? const Center(child: Text('No categories available'))
              : SafeArea(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: sorted.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = sorted[index];
                    return _AllCategoryCard(item: item);
                  },
                ),
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
    final controllerProfileData = Get.put(
      HireContractorListOfProfileController(),
    );
    final controllerFilterData = Get.put(
      HireContractorFilterProfileController(),
    );

    return GestureDetector(
      onTap: () {
        Get.to(
          () => CategoryServiceExplorer(
            categoryId: item.id,
            categoryName: item.name,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
          border:
              (() {
                final key = item.name
                    .trim()
                    .toLowerCase()
                    .replaceAll('&', 'and')
                    .replaceAll(RegExp(r'[^a-z0-9]+'), '_');

                return key == 'home_construction'
                    ? Border.all(color: ColorRes.primary, width: 1.5)
                    : null;
              })(),
          boxShadow:
              (() {
                final key = item.name
                    .trim()
                    .toLowerCase()
                    .replaceAll('&', 'and')
                    .replaceAll(RegExp(r'[^a-z0-9]+'), '_');

                return key != 'home_construction'
                    ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ]
                    : null;
              })(),
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
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // 👈 square with rounded corners
                    ),
                    child: Icon(fallbackIcon, color: fallbackColor, size: 25),
                  ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    item.name.capitalize?.replaceAll("_", " ") ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ColorRes.primary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Builder(
                  builder: (context) {
                    final key = item.name
                        .trim()
                        .toLowerCase()
                        .replaceAll('&', 'and')
                        .replaceAll(RegExp(r'[^a-z0-9]+'), '_');
                    final showBadge = key == 'home_construction';
                    if (!showBadge) return const SizedBox.shrink();
                    return Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ColorRes.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: ColorRes.primary.withOpacity(0.4),
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
                    );
                  },
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
            const SizedBox(height: 8),
            // Bullet points description
            ...((item.description).where((line) => line.trim().isNotEmpty).map((line) {
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
                        line.trim().startsWith('•') ? line.trim().substring(1).trim() : line.trim(),
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
            }).toList()),
            const SizedBox(height: 4),
            Divider(color: ColorRes.leadGreyColor.shade300),
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
