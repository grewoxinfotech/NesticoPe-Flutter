import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/img_res.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/app/widgets/image/custom_image.dart'
    hide ColorRes;
import 'package:nesticope_app/data/network/property/models/top_property_model.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/manager/compare_manager.dart';
import '../../../../app/manager/property/property_pricemanager.dart';
import '../../../../data/network/property/models/property_model.dart';
import '../../../saved_property/controllers/property_favorite_controller.dart';
import '../../controllers/property_controller.dart';
import '../property_detail_screen.dart';

class TopPropertyCard extends StatefulWidget {
  final Items property;
  final bool isRecentlyViewed;

  const TopPropertyCard({
    Key? key,
    required this.property,
    this.isRecentlyViewed = false,
  }) : super(key: key);

  @override
  State<TopPropertyCard> createState() => _TopPropertyCardState();
}

class _TopPropertyCardState extends State<TopPropertyCard> {
  final controller = Get.find<PropertyController>();
  final PropertyFavoriteController favoriteController =
      Get.find<PropertyFavoriteController>();

  final CompareManager compare = Get.put(CompareManager(), permanent: true);
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => PropertyDetailScreen(propertyId: widget.property.id));
        // TODO: Navigate to property detail screen if needed
        // You might need to convert AreaTopProperty to Items or create a dedicated detail screen
      },
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
          border: Border.all(color: ColorRes.grey.withOpacity(0.3), width: 0.8),
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
                  CustomImage(
                    type:
                        widget.property.propertyMedia?.images?.isNotEmpty ??
                                false
                            ? CustomImageType.network
                            : CustomImageType.asset,
                    src:
                        widget.property.propertyMedia?.images?.isNotEmpty ??
                                false
                            ? widget.property.propertyMedia?.images?.first
                            : IMGRes.home1,
                    fit: BoxFit.cover,
                    height: 170,
                    width: double.infinity,
                  ),

                  // 🔹 Listing Type Tag
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _buildTag(
                      widget.property.listingType ?? 'Not Specified',
                    ),
                  ),

                  // 🔹 Top Property Badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Compare toggle
                        GestureDetector(
                          onTap: () {
                            compare.toggle(widget.property, max: 5);
                            log("gnjignjrkjn");
                          },
                          child: Obx(() {
                            final selected = compare.isSelected(
                              widget.property.id,
                            );
                            return CircleAvatar(
                              backgroundColor:
                                  selected ? ColorRes.primary : ColorRes.white,

                              radius: 18,
                              child: Icon(
                                Icons.compare_arrows,
                                color:
                                    selected
                                        ? ColorRes.white
                                        : ColorRes.primary,
                                size: 20,
                              ),
                            );
                          }),
                        ),
                        const SizedBox(width: 8),
                        // Favorite toggle
                        GestureDetector(
                          onTap: () {
                            favoriteController.toggleFavorite(
                              widget.property.id ?? '',
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: ColorRes.white,
                            radius: 18,
                            child: Obx(() {
                              isFavorite = favoriteController.favorites
                                  .contains(widget.property.id);
                              return Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    isFavorite
                                        ? ColorRes.error
                                        : ColorRes.leadGreyColor,
                                size: 20,
                              );
                            }),
                          ),
                        ),
                      ],
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
                  if (widget.property.type?.toLowerCase() == "residential") ...[
                    Builder(builder: (context) {
                      final isPg =
                          (widget.property.listingType ?? '').toLowerCase() == 'pg';
                      final bhk = widget.property.propertyDetails?.bhk ?? 0;
                      final typeText = widget.property.propertyType?.capitalize ?? "";
                      final titleText = (!isPg && bhk > 0)
                          ? "$bhk BHK $typeText"
                          : typeText;
                      return Text(
                        titleText,
                        style: TextStyle(
                          fontWeight: AppFontWeights.semiBold,
                          fontSize: AppFontSizes.body,
                          color: ColorRes.blackShade87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    }),
                  ],
                  if (widget.property.type?.toLowerCase() == "commercial")
                    Text(
                      widget.property.propertyType?.capitalize ?? "",
                      style: TextStyle(
                        fontWeight: AppFontWeights.semiBold,
                        fontSize: AppFontSizes.body,
                        color: ColorRes.blackShade87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 4),

                  // Location
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.property.address ?? '',
                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            color: ColorRes.leadGreyColor.shade700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Facilities
                  TopPropertyFacilities(property: widget.property),

                  const SizedBox(height: 10),

                  // Price & CTA
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(builder: (context) {
                        final priceManager = PropertyPriceManager(
                          listingType: widget.property.listingType ?? "",
                          financialInfo: widget
                                  .property.propertyDetails?.financialInfo ??
                              FinancialInfo(),
                          pgInfo: widget.property.propertyDetails?.pgInfo,
                        );
                        final lt =
                            (widget.property.listingType ?? '').toLowerCase();
                        String priceText;
                        if (lt == 'pg') {
                          priceText = priceManager.maxPgPriceDisplay;
                        } else if (lt == 'rent') {
                          priceText = priceManager.displayPrice;
                        } else {
                          priceText = Formatter.formatPrice(widget
                                  .property
                                  .propertyDetails
                                  ?.financialInfo
                                  ?.price ??
                              0);
                        }
                        return Flexible(
                          child: Text(
                            priceText,
                            style: TextStyle(
                              fontWeight: AppFontWeights.semiBold,
                              fontSize: AppFontSizes.body,
                              color: ColorRes.textColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }),

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
                            fontSize: AppFontSizes.small,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.white,
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
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: ColorRes.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppFontSizes.small,
          fontWeight: AppFontWeights.semiBold,
          color: ColorRes.primary,
        ),
      ),
    );
  }
}

class TopPropertyFacilities extends StatelessWidget {
  final Items property;

  const TopPropertyFacilities({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final highlights = _getHighlights();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(highlights.length > 3 ? 3 : highlights.length, (
          index,
        ) {
          final item = highlights[index];
          return Row(
            children: [
              if (index != 0) ...[
                const Text('  •', style: TextStyle(fontSize: 10)),
                const SizedBox(width: 6),
              ],
              _buildChip(
                item['text'] as String,
                16,
                icon: item['icon'] as IconData,
              ),
            ],
          );
        }),
      ),
    );
  }

  List<Map<String, dynamic>> _getHighlights() {
    final details = property.propertyDetails;
    List<Map<String, dynamic>> highlights = [];

    final type = property.type?.toLowerCase() ?? '';

    if (type == "residential") {
      // 🔹 BHK
      final bhk = details?.bhk ?? 0;
      if (bhk > 0) {
        highlights.add({'text': '$bhk BHK', 'icon': Icons.bed_outlined});
      }

      // 🔹 Furnishing
      final furnishType = details?.furnishInfo?.furnishType;
      if (furnishType != null && furnishType.isNotEmpty) {
        highlights.add({'text': furnishType, 'icon': Icons.chair_alt_outlined});
      }

      // 🔹 Built-up Area
      final builtUp = details?.propertyBuiltUpArea ?? 0.0;
      final areaUnit = details?.propertyBuiltUpAreaUnit ?? '';
      if (builtUp > 0) {
        highlights.add({
          'text': '${builtUp.toInt()} $areaUnit',
          'icon': Icons.zoom_out_map_outlined,
        });
      }

      // 🔹 Bathrooms
      final bathrooms = details?.bathroom ?? 0;
      if (bathrooms > 0) {
        highlights.add({
          'text': '$bathrooms Bath',
          'icon': Icons.bathtub_outlined,
        });
      }

      // 🔹 Parking
      final hasParking =
          details?.parkingInfo?.covered == true ||
          details?.parkingInfo?.open == true;
      if (hasParking) {
        highlights.add({
          'text': 'Parking',
          'icon': Icons.local_parking_outlined,
        });
      }
    }
    // 🔹 Commercial Properties
    else if (type == "commercial") {
      final builtUp = details?.propertyBuiltUpArea ?? 0.0;
      final areaUnit = details?.propertyBuiltUpAreaUnit ?? '';
      if (builtUp > 0) {
        highlights.add({
          'text': '${builtUp.toInt()} $areaUnit',
          'icon': Icons.square_foot_outlined,
        });
      }

      final totalFloors = details?.floorInfo?.totalFloors ?? 0;
      if (totalFloors > 0) {
        highlights.add({
          'text': '$totalFloors Floors',
          'icon': Icons.elevator_outlined,
        });
      }

      final hasParking =
          details?.parkingInfo?.covered == true ||
          details?.parkingInfo?.open == true ||
          details?.parkingInfo?.covered == true ||
          details?.parkingInfo?.open == true;
      if (hasParking) {
        highlights.add({
          'text': 'Parking',
          'icon': Icons.local_parking_outlined,
        });
      }
    }

    return highlights;
  }

  Widget _buildChip(String text, double size, {IconData? icon}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) Icon(icon, size: size, color: ColorRes.primary),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: AppFontSizes.small,
            fontWeight: AppFontWeights.medium,
            color: ColorRes.grey,
          ),
        ),
      ],
    );
  }
}

Widget _buildBadge(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    decoration: BoxDecoration(
      color: ColorRes.black.withOpacity(0.75),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: ColorRes.white,
        fontSize: AppFontSizes.extraSmall,
        fontWeight: AppFontWeights.medium,
      ),
    ),
  );
}
