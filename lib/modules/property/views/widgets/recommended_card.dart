import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';
import 'package:housing_flutter_app/app/manager/property/property_name_manager.dart';
import 'package:housing_flutter_app/app/manager/property/property_pricemanager.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/modules/home/views/compare_screen/comapre_screen.dart';
import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';
import '../../../../app/manager/property/proiperty_feature_manager.dart';
import '../../../../app/manager/property_highlight_manager.dart';
import '../../../../app/manager/compare_manager.dart';
import '../../../../app/widgets/snack_bar/custom_snackbar.dart';
import '../../../../app/utils/svg_widget.dart';
import '../../../../data/network/property/models/property_model.dart';
import '../../../../widgets/bar/navigation_bar/navigation_Bar.dart';
import '../../../saved_property/controllers/property_favorite_controller.dart';
import '../property_detail_screen.dart';

class RecommendedCard extends StatefulWidget {
  final Items property;

  final bool isRecentlyViewed;

  const RecommendedCard({
    Key? key,
    this.isRecentlyViewed = false,
    required this.property,
  }) : super(key: key);

  @override
  State<RecommendedCard> createState() => _RecommendedCardState();
}

class _RecommendedCardState extends State<RecommendedCard> {
  bool isFavorite = false;
  final RxString compareMessage = ''.obs;
  final RxBool compareShowAction = false.obs;
  final RxBool compareIsWarning = false.obs;
  final RxBool compareVisible = false.obs;

  final CompareManager compare = Get.put(CompareManager(), permanent: true);

  @override
  Widget build(BuildContext context) {
    final title = PropertyNameManager(widget.property);
    final price = PropertyPriceManager(
      listingType: widget.property.listingType ?? '',
      financialInfo:
          widget.property.propertyDetails?.financialInfo ?? FinancialInfo(),
      pgInfo: widget.property.propertyDetails?.pgInfo, // Added for PG support
    );
    return GestureDetector(
      onTap:
          () => Get.to(
            () => PropertyDetailScreen(property: widget.property),
            routeName: '/property_${widget.property.id}',
          ),

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

                  // Favorite & Compare Buttons (top-right)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Compare button
                        GestureDetector(
                          onTap: () {
                            compare.toggle(widget.property, max: 2);
                          },
                          child: Obx(() {
                            final selected = compare.isSelected(
                              widget.property.id,
                            );
                            return CircleAvatar(
                              backgroundColor:
                                  selected ? ColorRes.primary : ColorRes.white,

                              radius: 16,
                              child: Icon(
                                Icons.compare_arrows,
                                color:
                                    selected
                                        ? ColorRes.white
                                        : ColorRes.primary,
                                size: 16,
                              ),
                            );
                          }),
                        ),

                        const SizedBox(width: 6),
                        // Favorite button
                        Obx(() {
                          final controller = Get.find<PropertyController>();
                          final PropertyFavoriteController favoriteController =
                              Get.find<PropertyFavoriteController>();

                          final isFavorite = favoriteController.favorites
                              .contains(widget.property.id);
                          return CircularIcon(
                            iconSize: 16,
                            sizeContainer: 32,
                            icon:
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border_rounded,
                            backgroundColor: ColorRes.white,
                            iconColor:
                                isFavorite
                                    ? ColorRes.redAccentColor
                                    : ColorRes.black,
                            onPressed: () {
                              favoriteController.toggleFavorite(
                                widget.property.id ?? '',
                              );
                            },
                          );
                        }),
                      ],
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
                      title.displayName,
                      style: TextStyle(
                        fontSize: AppFontSizes.medium,
                        color: ColorRes.textPrimary,
                        fontWeight: AppFontWeights.medium,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.property.address ?? '-',
                            style:  TextStyle(
                              fontWeight: AppFontWeights.medium,
                              fontSize: AppFontSizes.extraSmall,
                              color: ColorRes.leadGreyColor.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

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
                      // Text(
                      //   [
                      //     if (widget.property.propertyDetails!.bhk != null)
                      //       "${widget.property.propertyDetails!.bhk} BHK",
                      //     // if (widget.property.propertyDetails!.area != null)
                      //     //   "${widget.property.propertyDetails!.area} sqft",
                      //     if (widget
                      //             .property
                      //             .propertyDetails
                      //             ?.furnishInfo
                      //             ?.furnishType !=
                      //         null)
                      //       widget
                      //           .property
                      //           .propertyDetails!
                      //           .furnishInfo!
                      //           .furnishType,
                      //     if (widget.property.propertyDetails?.propertyFacing !=
                      //         null)
                      //       widget.property.propertyDetails!.propertyFacing!,
                      //     // if (widget.property.propertyDetails!.bathrooms != null)
                      //     //   "${widget.property.propertyDetails!.bathrooms} Bath",
                      //   ].join(" · "),
                      //   style: TextStyle(
                      //     fontSize: AppFontSizes.caption,
                      //     color: ColorRes.leadGreyColor.shade800,
                      //     fontWeight: AppFontWeights.medium,
                      //   ),
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      Facilities(property: widget.property),
                    ],

                    const SizedBox(height: 6),

                    // Row(
                    //   children: [
                    //     Transform.translate(
                    //       offset: const Offset(-2, 0), // move left by 2px
                    //       child: const Icon(
                    //         Icons.location_on_rounded,
                    //         size: 10,
                    //         color: ColorRes.grey,
                    //       ),
                    //     ),
                    //     const SizedBox(width: 3),
                    //     Expanded(
                    //       child: Text(
                    //         widget.property.address ?? '-',
                    //
                    //         style: TextStyle(
                    //           fontSize: AppFontSizes.mini,
                    //           color: ColorRes.leadGreyColor.shade600,
                    //         ),
                    //         maxLines: 1,
                    //         overflow: TextOverflow.ellipsis,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 5),
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
                    const SizedBox(width: 10),
                    Text(
                      price.displayPrice.toString() ?? '0',

                      style:  TextStyle(
                        fontWeight:AppFontWeights.semiBold ,
                        fontSize: AppFontSizes.bodyMedium,
                        color: ColorRes.primary,
                      ),
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

class Facilities extends StatelessWidget {
  final Items property;

  const Facilities({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    
    final highlights = PropertyHighlightManager(property).getHighlights();
log('Highkiutjhg ${highlights.map((e) => e.title,)}');
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
              _buildChip(item.value, 16, icon: item.icon),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildChip(
    String text,
    double size, {
    String? svgIcon,
    IconData? icon,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        svgIcon == null
            ? Icon(icon, size: size, color: ColorRes.primary)
            : AppSvgIcon(assetName: svgIcon, size: size),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: AppFontSizes.extraSmall,
            fontWeight: AppFontWeights.medium,
            color: ColorRes.leadGreyColor.shade700,
          ),
        ),
      ],
    );
  }
}
