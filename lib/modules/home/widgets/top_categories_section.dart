import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

import '../../../data/network/contractor/model/contractot_service_model/contractor_service_category_model.dart';

class TopCategoriesSection extends StatelessWidget {
  final List<TopCategoryItem> categories;

  const TopCategoriesSection({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
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
    return Container(
      width: 260,
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
          Container(
            height: 4,
            width: 60,
            decoration: BoxDecoration(
              color: ColorRes.primary,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          const SizedBox(height: 16),

          /// Title
          Text(
            item.name.toUpperCase(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ColorRes.primary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 12),

          /// Description
          Text(
            item.description,
            style: TextStyle(
              fontSize: 13,
              color: ColorRes.leadGreyColor,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          const Spacer(),

          /// Rating Row (only if available)
          if (item.serviceCount > 0)
            Row(
              children: [
                 Icon(
                  Icons.star,
                  color: ColorRes.homeYellowDark,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  item.averageRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '(${item.serviceCount} services)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
