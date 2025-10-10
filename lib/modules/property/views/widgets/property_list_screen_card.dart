import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/constants/color_res.dart';
import '../../../../app/constants/img_res.dart';
import '../../../../app/constants/size_manager.dart';
import '../../../../data/network/property/models/property_model.dart';
import '../../../../widgets/button/button.dart';
import '../../../../widgets/display/card.dart';
import '../property_detail_screen.dart';

class PropertyListScreenCard extends StatelessWidget {
  // final Map<String, dynamic> property;
  final Items? items;

  const PropertyListScreenCard({super.key, this.items});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => PropertyDetailScreen(property: items)),
      child: NesticoPeCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Favorite Icon
            Stack(
              children: [
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    // child: Image.network(items!.propertyMedia!.images?.first ?? IMGRes.home1, fit: BoxFit.fill),
                    child:
                        (items?.propertyMedia?.images?.isNotEmpty ?? false)
                            ? Image.network(
                              items!.propertyMedia!.images!.first,
                              fit: BoxFit.cover,
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) {
                                  return child; // Loaded
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  IMGRes.home1, // fallback image
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                            : Image.asset(IMGRes.home1, fit: BoxFit.cover),
                  ),
                ),
              ],
            ),

            // Info Section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          items!.title!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 6,
                        ),
                        decoration: BoxDecoration(
                          color: ColorRes.primary,
                          borderRadius: BorderRadius.circular(AppRadius.small),
                        ),
                        child:
                            items?.listingType != null
                                ? Text(
                                  "${items!.listingType}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: ColorRes.white,
                                  ),
                                )
                                : const SizedBox(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Divider(
                    indent: 12,
                    endIndent: 12,
                    color: Colors.grey.shade200,
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 4.5,
                              child: Text(
                                items!.propertyDetails!.financialInfo!.price
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   width: 80,
                            //   child:
                            //   Text(
                            //     property["availability"],
                            //     style: TextStyle(
                            //       fontSize: 12,
                            //       color: Colors.grey[700],
                            //     ),
                            //     overflow: TextOverflow.ellipsis,
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(width: 6),
                        VerticalDivider(
                          thickness: 1,
                          width: 20, // space between items
                          color: Colors.grey.shade200,
                        ),
                        const SizedBox(width: 6),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4.5,
                          child: Column(
                            children: [
                              if (items?.propertyDetails?.propertyBuiltUpArea !=
                                  null)
                                Text(
                                  "${items!.propertyDetails!.propertyBuiltUpArea} sq.ft",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              SizedBox(
                                width: 80,
                                child: Text(
                                  "Built Up area",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        VerticalDivider(
                          thickness: 1,
                          width: 20, // space between items
                          color: Colors.grey.shade200,
                        ),
                        const SizedBox(width: 6),

                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${items!.propertyDetails!.bhk ?? '0'} BHK',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (items
                                      ?.propertyDetails
                                      ?.furnishInfo
                                      ?.furnishType !=
                                  null)
                                Text(
                                  items!
                                      .propertyDetails!
                                      .furnishInfo!
                                      .furnishType!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 4),

                  const SizedBox(height: 4),

                  /// Description
                  Text(
                    items!.propertyDescription!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Divider(
                    indent: 12,
                    endIndent: 12,
                    color: Colors.grey.shade200,
                  ),
                  Row(
                    children: [
                      // Profile picture
                      const SizedBox(
                        height: 35,
                        width: 35,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                            IMGRes.home1, // Replace with actual image URL
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Column with 'Posted by' and name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Posted by',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              items!.ownerName!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Button 1
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 40,
                            child: NesticoPeButton(onTap: () {}, title: "Call"),
                          ),
                        ],
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
}
