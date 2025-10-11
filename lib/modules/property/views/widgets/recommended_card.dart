

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import '../../../../data/network/property/models/property_model.dart';
import '../property_detail_screen.dart';

class RecommendedCard extends StatefulWidget {
  final Items property;
  // final String imageUrl;
  // final String title;
  // final String price;
  // final String location;
  final bool isRecentlyViewed;

  const RecommendedCard({
    Key? key,
    // required this.imageUrl,
    // required this.title,
    // required this.price,
    // required this.location,
    this.isRecentlyViewed = false,
    required this.property,
  }) : super(key: key);

  @override
  State<RecommendedCard> createState() => _RecommendedCardState();
}

class _RecommendedCardState extends State<RecommendedCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Get.to(() => PropertyDetailScreen(property: widget.property)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 200,
        decoration: BoxDecoration(
          // color: ColorRes.overlay.withOpacity(0.1),
          border: Border.all(color: ColorRes.grey.withOpacity(0.3), width: 0.8),
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Image Section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  widget.property.propertyMedia!.images!.isNotEmpty
                      ? Image.network(
                        widget.property.propertyMedia!.images!.first,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                      : Image.asset(
                        IMGRes.home1,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                  // Overlay gradient
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ColorRes.black.withOpacity(0.4),
                          ColorRes.transparentColor,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),

                  // Rent Tag (top-left)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: ColorRes.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.property.listingType ?? '-',
                        style: const TextStyle(
                          color: ColorRes.primary,
                          fontSize: AppFontSizes.small,
                          fontWeight: AppFontWeights.semiBold,
                        ),
                      ),
                    ),
                  ),

                  // Favorite Button (top-right)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: ColorRes.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavorite ? ColorRes.error : ColorRes.leadGreyColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ),

                  // Recently Viewed Badge (bottom-left)
                  if (widget.isRecentlyViewed) // only show if true
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: ColorRes.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "Recently Viewed",
                          style: TextStyle(
                            color: ColorRes.white,
                            fontSize: AppFontSizes.extraSmall,
                            fontWeight: AppFontWeights.medium,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // 🔹 Content Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Price
                    Text(
                      '${widget.property.propertyDetails?.propertyCondition} ' ??
                          '-',
                      style: TextStyle(
                        fontSize: AppFontSizes.caption,
                        color: ColorRes.leadGreyColor.shade800,
                        fontWeight: AppFontWeights.medium,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.property.title ?? '-',
                            style: const TextStyle(
                              fontWeight: AppFontWeights.semiBold,
                              fontSize: AppFontSizes.medium,
                              color: ColorRes.blackShade87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
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
                            fontSize: AppFontSizes.body,
                            color: ColorRes.primary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    // Property Info
                    // if (widget.property.propertyDetails?.bhk != null) ...[
                    //   Text(
                    //     "${widget.property.propertyDetails!.bhk} BHK · 3000 sqft",
                    //     style: TextStyle(
                    //       fontSize: 13,
                    //       color: Colors.grey.shade700,
                    //     ),
                    //   ),
                    // ],
                    // Inside your property card
                    if (widget.property.propertyDetails != null) ...[
                      Text(
                        [
                          if (widget.property.propertyDetails!.bhk != null)
                            "${widget.property.propertyDetails!.bhk} BHK",
                          // if (widget.property.propertyDetails!.area != null)
                          //   "${widget.property.propertyDetails!.area} sqft",
                          if (widget
                                  .property
                                  .propertyDetails
                                  ?.furnishInfo
                                  ?.furnishType !=
                              null)
                            widget
                                .property
                                .propertyDetails!
                                .furnishInfo!
                                .furnishType,
                          if (widget.property.propertyDetails?.propertyFacing !=
                              null)
                            widget.property.propertyDetails!.propertyFacing!,
                          // if (widget.property.propertyDetails!.bathrooms != null)
                          //   "${widget.property.propertyDetails!.bathrooms} Bath",
                        ].join(" · "),
                        style: TextStyle(
                          fontSize: AppFontSizes.caption,
                          color: ColorRes.leadGreyColor.shade800,
                          fontWeight: AppFontWeights.medium,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        Transform.translate(
                          offset: const Offset(-2, 0), // move left by 2px
                          child: const Icon(
                            Icons.location_on_rounded,
                            size: 10,
                            color: ColorRes.grey,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            widget.property.address ?? '-',

                            style: TextStyle(
                              fontSize: AppFontSizes.mini,
                              color: ColorRes.leadGreyColor.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    // Text(
                    //   '${widget.property.propertyDetails?.propertyCondition} ' ??
                    //       '-',
                    //   style: TextStyle(
                    //     fontSize: 10,
                    //     color: Colors.grey.shade800,
                    //     fontWeight: AppFontWeights.medium,
                    //   ),
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    // SizedBox(height: 5),
                    Text(
                      '${widget.property.propertyDetails?.propertyBuiltUpArea} sq.ft' ??
                          '-',
                      style: TextStyle(
                        fontSize: AppFontSizes.mini,
                        color: ColorRes.leadGreyColor.shade800,
                        fontWeight: AppFontWeights.medium,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    // Divider
                    Divider(
                      color: ColorRes.grey.withOpacity(0.2),
                      thickness: 1,
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      height: 30,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              // ignore: deprecated_member_use
                              color: ColorRes.primary.withOpacity(0.1),
                            ),
                            child: Image.asset(
                              'assets/logo/whatsapp.png',
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),

                                // ignore: deprecated_member_use
                                border: Border.all(
                                  color: ColorRes.primary,
                                  width: 1,
                                ),
                                color: ColorRes.white,
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "View Phone",
                                style: TextStyle(
                                  fontSize: AppFontSizes.caption,
                                  fontWeight: AppFontWeights.medium,
                                  color: ColorRes.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: AppFontSizes.small,
        color: ColorRes.leadGreyColor.shade800,
        fontWeight: AppFontWeights.medium,
      ),
    );
  }
}
