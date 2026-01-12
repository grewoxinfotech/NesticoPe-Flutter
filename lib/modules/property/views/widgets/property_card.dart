import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';
import 'package:housing_flutter_app/app/constants/svg_res.dart';
import 'package:housing_flutter_app/app/manager/property/property_name_manager.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/app/utils/svg_widget.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart'
    hide ColorRes;
import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';
import 'package:housing_flutter_app/modules/property/views/property_detail_screen.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/manager/compare_manager.dart';
import '../../../../app/widgets/snack_bar/custom_snackbar.dart';
import '../../../../widgets/bar/navigation_bar/navigation_Bar.dart';
import '../../../../app/manager/property/property_pricemanager.dart';
import '../../../../app/manager/property_highlight_manager.dart';
import '../../../../data/network/property/models/property_model.dart';
import '../../../saved_property/controllers/property_favorite_controller.dart';

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
  final controller = Get.find<PropertyController>();
  final PropertyFavoriteController favoriteController =
      Get.find<PropertyFavoriteController>();

  final CompareManager compare = Get.put(CompareManager(), permanent: true);
  bool isFavorite = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final priceManager = PropertyPriceManager(
      listingType: widget.property.listingType ?? "",
      financialInfo:
          widget.property.propertyDetails?.financialInfo ?? FinancialInfo(),
      pgInfo: widget.property.propertyDetails?.pgInfo, // Added for PG support
    );

    return GestureDetector(
      onTap:
          () => Get.to(
            () => PropertyDetailScreen(propertyId: widget.property.id),
          ),
      child: Container(
        width: 260,
        // margin: const EdgeInsets.only(right: 12, bottom: 12),
        decoration: BoxDecoration(
          color: ColorRes.white,
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
                  CustomImage(
                    type:
                        (widget.property.propertyMedia?.images?.isNotEmpty ??
                                false)
                            ? CustomImageType.network
                            : CustomImageType.asset,
                    src:
                        (widget.property.propertyMedia?.images?.isNotEmpty ??
                                false)
                            ? widget.property.propertyMedia!.images!.first
                            : IMGRes.home1,
                    fit: BoxFit.cover,
                    height: 170,
                    width: double.infinity,
                  ),

                  Positioned(
                    top: 12,
                    left: 12,
                    child: _buildTag(widget.property.listingType ?? "-"),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Compare toggle
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
                  Text(
                    PropertyNameManager(widget.property).displayName,
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
                  Facilities(property: widget.property),

                  // Property Info Chips
                  // if (widget.property.type == "residential") ...[
                  //   if (widget.property.propertyDetails != null)
                  //     SingleChildScrollView(
                  //       scrollDirection: Axis.horizontal,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(left: 2),
                  //         child: Row(
                  //           children: [
                  //             if (widget.property.propertyDetails?.bhk != null)
                  //               _buildChip(
                  //                 "${widget.property.propertyDetails!.bhk} BHK",
                  //                 svgIcon: AppSvgRes.bedroom,
                  //                 15,
                  //                 isFirst: true, // first chip → no dot
                  //               ),
                  //
                  //             if (widget
                  //                     .property
                  //                     .propertyDetails
                  //                     ?.furnishInfo
                  //                     ?.furnishType !=
                  //                 null)
                  //               _buildChip(
                  //                 widget
                  //                         .property
                  //                         .propertyDetails!
                  //                         .furnishInfo!
                  //                         .furnishType ??
                  //                     "",
                  //                 15,
                  //                 svgIcon: AppSvgRes.furniture,
                  //               ),
                  //
                  //             if (widget
                  //                     .property
                  //                     .propertyDetails
                  //                     ?.propertyFacing !=
                  //                 null)
                  //               _buildChip(
                  //                 widget
                  //                     .property
                  //                     .propertyDetails!
                  //                     .propertyFacing!,
                  //                 svgIcon: AppSvgRes.direction,
                  //                 15,
                  //               ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  // ] else if (widget.property.type == "commercial" &&
                  //     widget.property.propertyType?.toLowerCase() ==
                  //         "office") ...[
                  //   if (widget.property.propertyDetails?.facilitiesInfo !=
                  //       null) ...[
                  //     if (widget.property.propertyDetails != null)
                  //       SingleChildScrollView(
                  //         scrollDirection: Axis.horizontal,
                  //         child: Padding(
                  //           padding: const EdgeInsets.only(left: 2),
                  //           child: Row(
                  //             children: [
                  //               if (widget
                  //                       .property
                  //                       .propertyDetails
                  //                       ?.facilitiesInfo
                  //                       ?.minSeats !=
                  //                   null)
                  //                 _buildChip(
                  //                   "${widget.property.propertyDetails!.facilitiesInfo!.minSeats} Seat",
                  //                   // svgIcon: AppSvgRes.sofa,
                  //                   15,
                  //                   isFirst: true, // first chip → no dot
                  //                   icon: Icons.chair_alt_outlined,
                  //                 ),
                  //
                  //               if (widget
                  //                       .property
                  //                       .propertyDetails
                  //                       ?.facilitiesInfo
                  //                       ?.numberOfCabins !=
                  //                   null)
                  //                 _buildChip(
                  //                   "${widget.property.propertyDetails!.facilitiesInfo!.numberOfCabins.toString() ?? ""} Cabin",
                  //                   // svgIcon: AppSvgRes.office,
                  //                   15,
                  //                   icon: Icons.cabin_outlined,
                  //                 ),
                  //
                  //               if (widget
                  //                       .property
                  //                       .propertyDetails
                  //                       ?.facilitiesInfo
                  //                       ?.numberOfMeetingRooms !=
                  //                   null)
                  //                 _buildChip(
                  //                   "${widget.property.propertyDetails!.facilitiesInfo!.numberOfMeetingRooms.toString()} Meeting Room",
                  //                   // svgIcon: AppSvgRes.intercom,
                  //                   15,
                  //                   icon: Icons.meeting_room_outlined,
                  //                 ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //   ] else ...[
                  //     SingleChildScrollView(
                  //       scrollDirection: Axis.horizontal,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(left: 2),
                  //         child: Row(
                  //           children: [
                  //             if (widget
                  //                     .property
                  //                     .propertyDetails
                  //                     ?.propertyBuiltUpArea !=
                  //                 null)
                  //               _buildChip(
                  //                 "${widget.property.propertyDetails!.propertyBuiltUpArea} sq.ft.",
                  //                 // svgIcon: AppSvgRes.sofa,
                  //                 15,
                  //                 isFirst: true, // first chip → no dot
                  //                 icon: Icons.square_foot_outlined,
                  //               ),
                  //
                  //             if (widget
                  //                     .property
                  //                     .propertyDetails
                  //                     ?.floorInfo
                  //                     ?.totalFloors !=
                  //                 null)
                  //               _buildChip(
                  //                 "${widget.property.propertyDetails?.floorInfo?.totalFloors.toString() ?? ""} Floors",
                  //                 // svgIcon: AppSvgRes.office,
                  //                 15,
                  //                 icon: Icons.elevator_outlined,
                  //               ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ],
                  const SizedBox(height: 10),

                  // Price & CTA
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.property.listingType?.toLowerCase() ==
                              "rent" ||
                          widget.property.listingType?.toLowerCase() ==
                              "pg") ...[
                        Flexible(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${Formatter.formatPrice(widget.property.propertyDetails?.financialInfo?.propertyRentPerMonth ?? 0)}",
                                style: TextStyle(
                                  fontWeight: AppFontWeights.semiBold,
                                  fontSize: AppFontSizes.body,
                                  color: ColorRes.textColor,
                                ),
                              ),

                              Text(" /month", style: TextStyle(fontSize: 10)),
                            ],
                          ),
                        ),
                      ] else ...[
                        Text(
                          "${Formatter.formatPrice(widget.property.propertyDetails?.financialInfo?.price ?? 0)}",
                          style: TextStyle(
                            fontWeight: AppFontWeights.semiBold,
                            fontSize: AppFontSizes.body,
                            color: ColorRes.textColor,
                          ),
                        ),
                      ],

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

  Widget _buildChip(
    String text,

    double size, {
    String? svgIcon,
    IconData? icon,
    bool isFirst = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        children: [
          if (!isFirst) ...[
            const Text('•', style: TextStyle(fontSize: 10)),
            const SizedBox(width: 2),
          ],
          svgIcon == null
              ? Icon(icon, size: size, color: ColorRes.primary)
              : AppSvgIcon(assetName: svgIcon, size: size),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontWeight: AppFontWeights.medium,
              color: ColorRes.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// class Facilities extends StatelessWidget {
//   final Items property;
//   final Color bgColor;
//   final Color txtColor;
//
//   Facilities({
//     super.key,
//     required this.property,
//     this.bgColor = const Color(0xFFDBEAFE),
//     this.txtColor = const Color(0xFF2563EB),
//   });
//
//   // Map detail keys to icons
//   final Map<String, IconData> iconMap = {
//     "BHK": Icons.bed,
//     "Furnishing": Icons.chair_alt,
//     "Built-up Area": Icons.zoom_out_map_outlined,
//     "Carpet Area": Icons.square_foot,
//     "Floor": Icons.layers_outlined,
//     "Age of Property": Icons.date_range,
//     "Rent": Icons.attach_money,
//     "Price": Icons.price_change,
//     "Possession": Icons.home_work,
//     "Amenities": Icons.checklist_rtl,
//     "Parking": Icons.local_parking,
//     "Facing": Icons.explore,
//     "Condition": Icons.handyman,
//     "Room Type": Icons.meeting_room,
//     // Add more mappings if needed
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     final highlights = PropertyHighlightManager(property).getHighlights();
//
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: List.generate(highlights.length > 3 ? 3 : highlights.length, (
//           index,
//         ) {
//           final item = highlights[index];
//           final key = item.keys.first;
//           final value = item.values.first;
//           final icon = iconMap[key];
//
//           return Row(
//             children: [
//               if (index != 0) ...[
//                 const Text('  •', style: TextStyle(fontSize: 10)),
//                 const SizedBox(width: 6),
//               ],
//               _buildChip(
//                 value.toString(),
//                 16, // icon size
//                 icon: icon,
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//   }

class Facilities extends StatelessWidget {
  final Items property;

  const Facilities({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final highlights = PropertyHighlightManager(property).getHighlights();

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
            fontSize: AppFontSizes.small,
            fontWeight: AppFontWeights.medium,
            color: ColorRes.grey,
          ),
        ),
      ],
    );
  }
}
