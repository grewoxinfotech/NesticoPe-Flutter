//
// ///MARK:Change City Card Widget Change in 13-09-2025
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/constants/img_res.dart';
// import 'package:housing_flutter_app/app/constants/size_manager.dart';
// import 'package:housing_flutter_app/app/utils/common_text.dart';
// import 'package:housing_flutter_app/app/utils/formater/formater.dart';
// import 'package:housing_flutter_app/modules/property_price_trend/view/property_price_trend.dart';
//
// import '../../../data/network/property/models/property_model.dart';
//
// class TopPropertyByLocation extends StatelessWidget {
//   final Items property;
//   final double rating;
//   final bool isPositive;
//   const TopPropertyByLocation({
//     super.key,
//     required this.rating,
//     required this.isPositive,
//     required this.property,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Get.to(() => const PriceDetails());
//       },
//       child: Container(
//         width: 180,
//         decoration: BoxDecoration(
//           color: ColorRes.white,
//           borderRadius: BorderRadius.circular(AppRadius.medium),
//           border: Border.all(color: ColorRes.grey.withOpacity(0.3), width: 0.8),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(AppRadius.medium),
//               child: Stack(
//                 children: [
//                   Image(
//                     image:
//                         property.propertyMedia!.images!.isNotEmpty
//                             ? NetworkImage(
//                               property.propertyMedia!.images!.first,
//                             )
//                             : const AssetImage(IMGRes.home1) as ImageProvider,
//                     height: 120,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                   Positioned(
//                     right: 8,
//                     top: 8,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 6,
//                         vertical: 2,
//                       ),
//                       decoration: BoxDecoration(
//                         color: ColorRes.white.withOpacity(0.90),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             isPositive
//                                 ? Icons.arrow_upward
//                                 : Icons.arrow_downward,
//                             color:
//                                 isPositive ? ColorRes.success : ColorRes.error,
//                             size: 12,
//                           ),
//                           const SizedBox(width: 2),
//                           Text(
//                             rating.toStringAsFixed(1),
//                             style: const TextStyle(
//                               fontSize: 11,
//                               fontWeight: AppFontWeights.bold,
//                               color: ColorRes.textPrimary,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CustomText(
//                     property.title ?? "Property",
//                     fontSize: 13,
//                     fontWeight: AppFontWeights.semiBold,
//                     color: ColorRes.textPrimary,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//
//                   CustomText(
//                     "${property.city}, ${property.state}",
//                     fontSize: 11,
//                     fontWeight: AppFontWeights.regular,
//                     color: Colors.grey.shade700,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       CustomText(
//                         '${Formatter.formatPriceCompact(property.propertyDetails!.financialInfo!.price ?? 0.0)} ',
//                         fontSize: 11,
//                         fontWeight: AppFontWeights.semiBold,
//                         color: ColorRes.textColor,
//                       ),
//                       const Spacer(),
//                       SizedBox(
//                         width: 65,
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 '${property.propertyDetails!.propertyBuiltUpArea ?? 0}',
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   fontWeight: AppFontWeights.regular,
//                                   color: Colors.grey.shade600,
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               '/ sqft',
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: AppFontWeights.regular,
//                                 color: Colors.grey.shade600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       //Add space between area and '/ sqft'
//                     ],
//                   ),
//                   // const SizedBox(height: 4),
//                   Divider(
//                     color: ColorRes.grey.withOpacity(0.4),
//                     thickness: 0.5,
//                   ),
//                   InkWell(
//                     onTap: () {},
//                     child: const Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CustomText(
//                           "Price Trends",
//                           fontSize: 12,
//                           fontWeight: AppFontWeights.semiBold,
//                           color: ColorRes.primary,
//                         ),
//                         SizedBox(width: 4),
//                         Icon(
//                           Icons.arrow_forward_ios,
//                           color: ColorRes.primary,
//                           size: 14,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//

///MARK:Change City Card Widget Change in 13-09-2025

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';
import 'package:housing_flutter_app/app/utils/common_text.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/modules/property_price_trend/view/property_price_trend.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../data/network/property/models/property_model.dart';

class TopPropertyByLocation extends StatelessWidget {
  final Items property;
  final double rating;
  final bool isPositive;

  const TopPropertyByLocation({
    super.key,
    required this.rating,
    required this.isPositive,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const PriceDetails());
      },
      child: SizedBox(
        height: 80,
        width: 180,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: Stack(
            children: [
              Positioned.fill(
                child:
                    (property.propertyMedia!.images!.isNotEmpty)
                        ? Image.network(
                          property.propertyMedia!.images!.first,
                          fit: BoxFit.cover,
                        )
                        : Image.asset(IMGRes.home1, fit: BoxFit.cover),
              ),

              /// Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ColorRes.transparentColor,
                        ColorRes.black.withOpacity(0.85),
                      ],

                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 8,
                top: 8,

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: ColorRes.white.withOpacity(0.90),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                        color: isPositive ? ColorRes.success : ColorRes.error,
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: AppFontSizes.caption,
                          fontWeight: AppFontWeights.bold,
                          color: ColorRes.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        property.title ?? "Property",
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.white,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      CustomText(
                        "${property.city}, ${property.state}",
                        fontSize: AppFontSizes.caption,
                        fontWeight: AppFontWeights.regular,
                        color: ColorRes.whiteShade,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (property.propertyDetails?.financialInfo?.price !=
                              null)
                            CustomText(
                              '${Formatter.formatPriceCompact(property.propertyDetails!.financialInfo!.price ?? 0.0)} ',
                              fontSize: AppFontSizes.caption,
                              fontWeight: AppFontWeights.bold,
                              color: ColorRes.white,
                            ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: ColorRes.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: CustomText(
                              "Price Trends",
                              fontSize: AppFontSizes.extraSmall,
                              fontWeight: AppFontWeights.semiBold,
                              color: ColorRes.white,
                            ),
                          ),
                        ],
                      ),

                      // const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
