// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/constants/img_res.dart';
// import 'package:housing_flutter_app/app/constants/size_manager.dart';
// import 'package:housing_flutter_app/app/constants/svg_res.dart';
// import 'package:housing_flutter_app/app/utils/formater/formater.dart';
// import 'package:housing_flutter_app/app/utils/svg_widget.dart';
// import 'package:housing_flutter_app/modules/property/views/property_detail_screen.dart';
// import '../../../../data/network/property/models/property_model.dart';

// class SellerPropertyCard extends StatefulWidget {
//   final Items property;
//   final bool isRecentlyViewed;

//   const SellerPropertyCard({
//     Key? key,
//     required this.property,
//     this.isRecentlyViewed = false,
//   }) : super(key: key);

//   @override
//   State<SellerPropertyCard> createState() => _SellerPropertyCardState();
// }

// class _SellerPropertyCardState extends State<SellerPropertyCard> {
//   bool isFavorite = false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap:
//           () => Get.to(() => PropertyDetailScreen(property: widget.property)),
//       child: Container(
//         width: 260,
//         margin: const EdgeInsets.only(right: 12, bottom: 12),
//         decoration: BoxDecoration(
//           color: ColorRes.white,
//           borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
//           border: Border.all(
//             color: ColorRes.grey.withOpacity(0.15),
//             width: 0.8,
//           ),
//           // boxShadow: [
//           //   BoxShadow(
//           //     color: Colors.black.withOpacity(0.05),
//           //     blurRadius: 6,
//           //     offset: const Offset(0, 3),
//           //   ),
//           // ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🔹 Image Section
//             ClipRRect(
//               borderRadius: const BorderRadius.vertical(
//                 top: Radius.circular(15),
//               ),
//               child: Stack(
//                 children: [

//                   // Dark Gradient Overlay
//                   Container(
//                     height: 170,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.black.withOpacity(0.6),
//                           Colors.transparent,
//                         ],
//                         begin: Alignment.bottomCenter,
//                         end: Alignment.topCenter,
//                       ),
//                     ),
//                   ),

//                   // 🔹 Rent/Sale Tag
//                   Positioned(
//                     top: 12,
//                     left: 12,
//                     child: _buildTag(widget.property.listingType ?? "-"),
//                   ),

//                   // 🔹 Favorite Button
//                   Positioned(
//                     top: 12,
//                     right: 12,
//                     child: GestureDetector(
//                       onTap: () => setState(() => isFavorite = !isFavorite),
//                       child: CircleAvatar(
//                         backgroundColor: ColorRes.white,
//                         radius: 18,
//                         child: Icon(
//                           isFavorite ? Icons.favorite : Icons.favorite_border,
//                           color: isFavorite ? Colors.red : Colors.grey,
//                           size: 20,
//                         ),
//                       ),
//                     ),
//                   ),

//                   // 🔹 Recently Viewed Badge
//                   if (widget.isRecentlyViewed)
//                     Positioned(
//                       bottom: 12,
//                       left: 12,
//                       child: _buildBadge("Recently Viewed"),
//                     ),
//                 ],
//               ),
//             ),

//             // 🔹 Content Section
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title
//                   Text(
//                     widget.property.title ?? "-",
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 16,
//                       color: Colors.black87,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 6),

//                   // Location
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.location_on_rounded,
//                         size: 14,
//                         color: ColorRes.grey,
//                       ),
//                       const SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           widget.property.address ?? "-",
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Colors.grey.shade700,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 10),

//                   // Property Info Chips
//                   if (widget.property.propertyDetails != null)
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 2),
//                         child: Row(
//                           children: [
//                             if (widget.property.propertyDetails?.bhk != null)
//                               _buildChip(
//                                 "${widget.property.propertyDetails!.bhk} BHK",
//                                 AppSvgRes.bedroom,
//                                 15,
//                               ),

//                             if (widget
//                                     .property
//                                     .propertyDetails
//                                     ?.furnishInfo
//                                     ?.furnishType !=
//                                 null)
//                               _buildChip(
//                                 widget
//                                         .property
//                                         .propertyDetails!
//                                         .furnishInfo!
//                                         .furnishType ??
//                                     "",
//                                 AppSvgRes.furniture,
//                                 15,
//                               ),
//                             if (widget
//                                     .property
//                                     .propertyDetails
//                                     ?.propertyFacing !=
//                                 null)
//                               _buildChip(
//                                 widget
//                                     .property
//                                     .propertyDetails!
//                                     .propertyFacing!,
//                                 AppSvgRes.direction,
//                                 15,
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),

//                   const SizedBox(height: 10),

//                   // Price & CTA
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         Formatter.formatPrice(
//                           widget
//                                   .property
//                                   .propertyDetails
//                                   ?.financialInfo
//                                   ?.price ??
//                               0,
//                         ),
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                           color: ColorRes.textColor,
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 14,
//                           vertical: 8,
//                         ),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: ColorRes.primary,
//                         ),
//                         child: const Text(
//                           'Book Now',
//                           style: TextStyle(
//                             fontSize: 11,
//                             fontWeight: FontWeight.w600,
//                             color: ColorRes.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTag(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w600,
//           color: ColorRes.primary,
//         ),
//       ),
//     );
//   }

//   Widget _buildBadge(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.75),
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(
//           color: ColorRes.white,
//           fontSize: 10,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }

//   Widget _buildChip(String text, String svgIcon, double size) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 10),
//       child: Row(
//         children: [
//           Text('•', style: TextStyle(fontSize: 10)),
//           SizedBox(width: 2),
//           AppSvgIcon(assetName: svgIcon, size: size),
//           const SizedBox(width: 4),
//           Text(
//             text,
//             style: const TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.w500,
//               color: ColorRes.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/svg_res.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/app/utils/svg_widget.dart';
import 'package:housing_flutter_app/modules/property/views/property_detail_screen.dart';
import 'package:housing_flutter_app/modules/seller/view/seller_profile.dart';
import '../../../../data/network/property/models/property_model.dart';

class SellerPropertyCard extends StatefulWidget {
  final Items property;
  final bool isRecentlyViewed;

  const SellerPropertyCard({
    Key? key,
    required this.property,
    this.isRecentlyViewed = false,
  }) : super(key: key);

  @override
  State<SellerPropertyCard> createState() => _SellerPropertyCardState();
}

class _SellerPropertyCardState extends State<SellerPropertyCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Get.to(() => PropertyDetailScreen(property: widget.property)),
      child: Container(
        // margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: ColorRes.grey.withOpacity(0.12),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorRes.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Left Side: Image & Content
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔹 Image
                        Container(
                          width: 60,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade200,
                            image:
                                (widget
                                            .property
                                            .propertyMedia
                                            ?.images
                                            ?.isNotEmpty ??
                                        false)
                                    ? DecorationImage(
                                      image: NetworkImage(
                                        widget
                                            .property
                                            .propertyMedia!
                                            .images!
                                            .first,
                                      ),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        ColorRes.black.withOpacity(0.25),
                                        BlendMode.darken,
                                      ),
                                    )
                                    : null,
                          ),
                          child:
                              (!(widget
                                          .property
                                          .propertyMedia
                                          ?.images
                                          ?.isNotEmpty ??
                                      false))
                                  ? const Icon(
                                    Icons.image,
                                    size: 36,
                                    color: Colors.grey,
                                  )
                                  : null,
                        ),

                        const SizedBox(width: 12),

                        // 🔹 Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                widget.property.title ?? "-",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: ColorRes.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),

                              // Location
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                    size: 10,
                                    color: ColorRes.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      widget.property.address ?? "-",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Chips Row
                              if (widget.property.propertyDetails != null)
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    spacing: 6,
                                    children: [
                                      if (widget
                                              .property
                                              .propertyDetails
                                              ?.bhk !=
                                          null)
                                        _buildChip(
                                          "${widget.property.propertyDetails!.bhk} BHK",
                                          AppSvgRes.bedroom,
                                          12,
                                        ),
                                      if (widget
                                              .property
                                              .propertyDetails
                                              ?.furnishInfo
                                              ?.furnishType !=
                                          null)
                                        _buildChip(
                                          widget
                                              .property
                                              .propertyDetails!
                                              .furnishInfo!
                                              .furnishType!,
                                          AppSvgRes.furniture,
                                          12,
                                        ),
                                      if (widget
                                              .property
                                              .propertyDetails
                                              ?.propertyFacing !=
                                          null)
                                        _buildChip(
                                          widget
                                              .property
                                              .propertyDetails!
                                              .propertyFacing!,
                                          AppSvgRes.direction,
                                          12,
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    width: 1,
                    height: 50,
                    color: Colors.grey.withOpacity(0.2),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Formatter.formatPrice(
                          widget
                                  .property
                                  .propertyDetails
                                  ?.financialInfo
                                  ?.price ??
                              0,
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: ColorRes.textColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: ColorRes.primary,
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.star, color: ColorRes.white, size: 12),
                            SizedBox(width: 4),
                            Text(
                              "4.8",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: ColorRes.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(thickness: 0.5, color: ColorRes.grey.withOpacity(0.2)),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const InfoTile(title: 'Leads', value: '25'),
                    VerticalDivider(
                      thickness: 0.5,
                      color: ColorRes.grey.withOpacity(0.2),
                    ),
                    const InfoTile(title: 'Visiters', value: '15'),
                    VerticalDivider(
                      thickness: 0.5,
                      color: ColorRes.grey.withOpacity(0.2),
                    ),
                    const InfoTile(title: 'Impression', value: '150'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text) => Container(
    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
    decoration: BoxDecoration(
      color: ColorRes.white,
      borderRadius: BorderRadius.circular(6),
      boxShadow: [
        BoxShadow(
          color: ColorRes.black.withOpacity(0.08),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: ColorRes.primary,
      ),
    ),
  );

  Widget _buildBadge(String text) => Container(
    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
    decoration: BoxDecoration(
      color: ColorRes.black.withOpacity(0.75),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: ColorRes.white,
        fontSize: 9,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  Widget _buildChip(String text, String svgIcon, double size) => Padding(
    padding: const EdgeInsets.only(right: 6),
    child: Row(
      children: [
        AppSvgIcon(assetName: svgIcon, size: size),
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: ColorRes.grey,
          ),
        ),
      ],
    ),
  );
}
