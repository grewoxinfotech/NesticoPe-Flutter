import 'package:flutter/material.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/constants/size_manager.dart';
import '../../../../data/network/city/tending_city/trending_city_model.dart';

class TrendingCityCard extends StatelessWidget {
  final TrendingCityData city;
  final double? cardHeight;
  final VoidCallback? onTap;

  const TrendingCityCard({
    super.key,
    required this.city,
    this.onTap,
    this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSpacing.large * 6,
        // height: cardHeight ?? AppSpacing.extraLarge * 2.7,
        margin: const EdgeInsets.symmetric(vertical: AppPadding.small),
        // padding: const EdgeInsets.symmetric(
        //   horizontal: AppPadding.small,
        //   vertical: AppPadding.small,
        // ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: ColorRes.leadGreyColor.shade500, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // City Image
            // ClipRRect(
            //   borderRadius: const BorderRadius.vertical(
            //     top: Radius.circular(16),
            //   ),
            //   child: Image.network(
            //     city.cityImage,
            //     height: 120,
            //     width: double.infinity,
            //     fit: BoxFit.cover,
            //     errorBuilder:
            //         (context, error, stackTrace) => Container(
            //           height: 120,
            //           color: Colors.grey.shade200,
            //           child: const Center(
            //             child: Icon(Icons.broken_image, color: Colors.grey),
            //           ),
            //         ),
            //   ),
            // ),

            // City Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // City name
                  Text(
                    city.city,
                    style: const TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.blackShade87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Property count
                 if(city.propertyCount>0)...[
                   Row(
                     children: [
                       Icon(
                         Icons.home_outlined,
                         size: 16,
                         color: ColorRes.blueGrey,
                       ),
                       const SizedBox(width: 6),
                       Text(
                         '${city.propertyCount} properties',
                         style: TextStyle(color: ColorRes.leadGreyColor[700], fontSize: AppFontSizes.caption),
                       ),
                     ],
                   ),
                 ],
                  const SizedBox(height: 4),
                if(city.projectCount>0)...[
                  Row(
                    children: [
                      Icon(
                        Icons.apartment_outlined,
                        size: 16,
                        color: ColorRes.blueGrey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${city.projectCount} projects',
                        style: TextStyle(color: ColorRes.leadGreyColor[700], fontSize: AppFontSizes.caption),
                      ),
                    ],
                  ),
                ],


                  // // Total views
                  // Row(
                  //   children: [
                  //     const Icon(
                  //       Icons.remove_red_eye_outlined,
                  //       size: 18,
                  //       color: Colors.blueGrey,
                  //     ),
                  //     const SizedBox(width: 6),
                  //     Text(
                  //       '${city.totalViews} views',
                  //       style: TextStyle(color: Colors.grey[700], fontSize: 13),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 4),
                  //
                  // // Total inquiries
                  // Row(
                  //   children: [
                  //     const Icon(
                  //       Icons.chat_bubble_outline,
                  //       size: 18,
                  //       color: Colors.blueGrey,
                  //     ),
                  //     const SizedBox(width: 6),
                  //     Text(
                  //       '${city.totalInquiries} inquiries',
                  //       style: TextStyle(color: Colors.grey[700], fontSize: 13),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
