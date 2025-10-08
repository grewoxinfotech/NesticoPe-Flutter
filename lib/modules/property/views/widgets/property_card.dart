import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';
import 'package:housing_flutter_app/app/constants/svg_res.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/app/utils/svg_widget.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart';
import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';
import '../../../../app/manager/favorite.dart';
import '../../../../app/manager/property/property_pricemanager.dart';
import '../../../../app/manager/property_highlight_manager.dart';
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
  final controller = Get.find<PropertyController>();
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final priceManager = PropertyPriceManager(
      listingType: widget.property.listingType ?? "",
      financialInfo:
          widget.property.propertyDetails?.financialInfo ?? FinancialInfo(),
    );

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

                  // widget.property.propertyMedia?.images?.isNotEmpty == true
                  //     ? Image.network(
                  //       widget.property.propertyMedia!.images!.first,
                  //       height: 170,
                  //       width: double.infinity,
                  //       fit: BoxFit.cover,
                  //     )
                  //     : Image.asset(
                  //       IMGRes.home1,
                  //       height: 170,
                  //       width: double.infinity,
                  //       fit: BoxFit.cover,
                  //     ),

                  // Dark Gradient Overlay
                  // Container(
                  //   height: 170,
                  //   decoration: BoxDecoration(
                  //     gradient: LinearGradient(
                  //       colors: [
                  //         Colors.black.withOpacity(0.6),
                  //         Colors.transparent,
                  //       ],
                  //       begin: Alignment.bottomCenter,
                  //       end: Alignment.topCenter,
                  //     ),
                  //   ),
                  // ),

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
                      onTap: () {
                        // controller.addFavorite(widget.property.id ?? '');
                        // setState(() => isFavorite = !isFavorite);
                        controller.toggleFavorite(widget.property.id ?? '');
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 18,
                        child: Obx(() {
                          isFavorite = controller.favoriteIds.contains(
                            widget.property.id,
                          );
                          return Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                            size: 20,
                          );
                        }),
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
                  if (widget.property.type!.toLowerCase() == "residential")
                    Text(
                      "${widget.property.propertyDetails?.bhk ?? 0} BHK ${widget.property.propertyType?.capitalize}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,

                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (widget.property.type!.toLowerCase() == "commercial")
                    Text(
                      "${widget.property.propertyType?.capitalize}",
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
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
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
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

class Facilities extends StatelessWidget {
  final Items property;
  final Color bgColor;
  final Color txtColor;

  Facilities({
    super.key,
    required this.property,
    this.bgColor = const Color(0xFFDBEAFE),
    this.txtColor = const Color(0xFF2563EB),
  });

  // Map detail keys to icons
  final Map<String, IconData> iconMap = {
    "BHK": Icons.bed,
    "Furnishing": Icons.chair_alt,
    "Built-up Area": Icons.zoom_out_map_outlined,
    "Carpet Area": Icons.square_foot,
    "Floor": Icons.layers_outlined,
    "Age of Property": Icons.date_range,
    "Rent": Icons.attach_money,
    "Price": Icons.price_change,
    "Possession": Icons.home_work,
    "Amenities": Icons.checklist_rtl,
    "Parking": Icons.local_parking,
    "Facing": Icons.explore,
    "Condition": Icons.handyman,
    "Room Type": Icons.meeting_room,
    // Add more mappings if needed
  };

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
          final key = item.keys.first;
          final value = item.values.first;
          final icon = iconMap[key];

          return Row(
            children: [
              if (index != 0) ...[
                const Text('  •', style: TextStyle(fontSize: 10)),
                const SizedBox(width: 6),
              ],
              _buildChip(
                value.toString(),
                16, // icon size
                icon: icon,
              ),
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
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: ColorRes.grey,
          ),
        ),
      ],
    );
  }
}
