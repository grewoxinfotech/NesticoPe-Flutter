import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';
import 'package:housing_flutter_app/app/constants/svg_res.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/app/utils/svg_widget.dart';
import '../../../../data/network/property/models/property_model.dart';
import '../property_detail_screen.dart';

class PropertyCard extends StatefulWidget {
  final Items property;
  final bool isRecentlyViewed;

  const PropertyCard({
    Key? key,
    required this.property,
    this.isRecentlyViewed = false,
  }) : super(key: key);

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Get.to(() => PropertyDetailScreen(property: widget.property)),
      child: Container(
        width: 260,
        // margin: const EdgeInsets.only(right: 12, bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
          border: Border.all(color: ColorRes.grey.withOpacity(0.3), width: 0.8),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.05),
          //     blurRadius: 6,
          //     offset: const Offset(0, 3),
          //   ),
          // ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Image Section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: Stack(
                children: [
                  widget.property.propertyMedia?.images?.isNotEmpty == true
                      ? Image.network(
                        widget.property.propertyMedia!.images!.first,
                        height: 170,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                      : Image.asset(
                        IMGRes.home1,
                        height: 170,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),

                  // Dark Gradient Overlay
                  Container(
                    height: 170,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),

                  // 🔹 Rent/Sale Tag
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _buildTag(widget.property.listingType ?? "-"),
                  ),

                  // 🔹 Favorite Button
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () => setState(() => isFavorite = !isFavorite),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 18,
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  // 🔹 Recently Viewed Badge
                  if (widget.isRecentlyViewed)
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: _buildBadge("Recently Viewed"),
                    ),
                ],
              ),
            ),

            // 🔹 Content Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.property.title ?? "-",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Location
                  Row(
                    children: [
                      // const Icon(
                      //   Icons.location_on_rounded,
                      //   size: 14,
                      //   color: ColorRes.grey,
                      // ),
                      //const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.property.address ?? "-",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Property Info Chips
                  if (widget.property.propertyDetails != null)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Row(
                          children: [
                            if (widget.property.propertyDetails?.bhk != null)
                              _buildChip(       
                                "${widget.property.propertyDetails!.bhk} BHK",
                                AppSvgRes.bedroom,
                                15,
                                isFirst: true, // first chip → no dot
                              ),

                            if (widget.property.propertyDetails?.furnishInfo?.furnishType != null)
                              _buildChip(
                                widget.property.propertyDetails!.furnishInfo!.furnishType ?? "",
                                AppSvgRes.furniture,
                                15,
                              ),

                            if (widget.property.propertyDetails?.propertyFacing != null)
                              _buildChip(
                                widget.property.propertyDetails!.propertyFacing!,
                                AppSvgRes.direction,
                                15,
                              ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 10),

                  // Price & CTA
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: ColorRes.textColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: ColorRes.primary,
                        ),
                        child: const Text(
                          'Contact Now',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: ColorRes.primary,
        ),
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildChip(String text, String svgIcon, double size, {bool isFirst = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        children: [
          if (!isFirst) ...[
            const Text('•', style: TextStyle(fontSize: 10)),
            const SizedBox(width: 2),
          ],
          AppSvgIcon(assetName: svgIcon, size: size),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: ColorRes.grey,
            ),
          ),
        ],
      ),
    );
  }
}
