import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/home/views/compare_screen/comapre_screen.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/constants/img_res.dart';
import '../../../../app/constants/size_manager.dart';
import '../../../../app/manager/compare_manager.dart';
import '../../../../app/widgets/snack_bar/custom_snackbar.dart';
import '../../../../data/network/property/models/property_model.dart';
import '../../../../widgets/button/button.dart';
import '../../../../widgets/display/card.dart';
import '../../../../widgets/bar/navigation_bar/navigation_Bar.dart';
import '../property_detail_screen.dart';

class PropertyListScreenCard extends StatelessWidget {
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
            // Image with Compare & Favorite Icons
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
                // Compare & Favorite buttons
                Positioned(
                  top: 12,
                  right: 12,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Compare button
                      Builder(
                        builder: (context) {
                          final compare = Get.put(CompareManager(), permanent: true);
                          return GestureDetector(
                            onTap: () {
                              final before = compare.count;
                              compare.toggle(items!, max: 2);
                              final after = compare.count;

                              final ctx = Get.overlayContext;
                              if (ctx != null) {
                                if (after > before) {
                                  CustomSnackBar.show(
                                    ctx,
                                    message: after == 2
                                        ? 'Ready to compare!'
                                        : 'Added to compare (${after}/2)',
                                    type: SnackBarType.success,
                                    actionLabel: after == 2 ? 'Compare Now' : null,
                                    onActionPressed: after == 2
                                        ? () {
                                            Get.back(); // Close snackbar first
                                            if (Get.isRegistered<NavigationController>()) {
                                              Get.find<NavigationController>().changeIndex(2);
                                            }
                                          }
                                        : null,
                                  );
                                } else if (after < before) {
                                  CustomSnackBar.show(
                                    ctx,
                                    message: after == 0
                                        ? 'Removed from compare'
                                        : 'Removed from compare (${after}/2)',
                                    type: SnackBarType.info,
                                  );
                                } else if (after == before && before >= 2) {
                                  CustomSnackBar.show(
                                    ctx,
                                    message: 'You can only compare 2 properties',
                                    type: SnackBarType.warning,
                                  );
                                }
                              }
                            },
                            child: Obx(() {
                              final selected = compare.isSelected(items?.id);
                              return CircleAvatar(
                                backgroundColor: ColorRes.white,
                                radius: 18,
                                child: Icon(
                                  Icons.compare_arrows,
                                  color: selected ? ColorRes.primary : ColorRes.leadGreyColor,
                                  size: 20,
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ],
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
                          style:  TextStyle(
                            fontWeight: AppFontWeights.extraBold,
                            color: ColorRes.black,
                            fontSize: AppFontSizes.medium,
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
                                  style:  TextStyle(
                                    fontWeight: AppFontWeights.semiBold,
                                    fontSize: AppFontSizes.small,
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
                    color: ColorRes.leadGreyColor.shade200,
                    // color: .shade200,
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
                                style:  TextStyle(
                                  fontSize: AppFontSizes.medium,
                                  color: ColorRes.black,
                                  fontWeight: AppFontWeights.extraBold,
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
                          color: ColorRes.leadGreyColor.shade200,
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
                                    fontSize: AppFontSizes.medium,
                                    color: ColorRes.black,
                                    fontWeight: AppFontWeights.extraBold,
                                  ),
                                ),
                              SizedBox(
                                width: 80,
                                child: Text(
                                  "Built Up area",
                                  style: TextStyle(
                                    fontSize: AppFontSizes.small,
                                    color: ColorRes.leadGreyColor[700],
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
                          color: ColorRes.leadGreyColor.shade200,
                        ),
                        const SizedBox(width: 6),

                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${items!.propertyDetails!.bhk ?? '0'} BHK',
                                style:  TextStyle(
                                  fontSize: AppFontSizes.medium,
                                  color: ColorRes.black,
                                  fontWeight: AppFontWeights.extraBold,
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
                                    fontSize: AppFontSizes.small,
                                    color: ColorRes.leadGreyColor[700],
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
                      fontSize: AppFontSizes.small,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.leadGreyColor.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Divider(
                    indent: 12,
                    endIndent: 12,
                    color: ColorRes.leadGreyColor.shade200,
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
                                color: ColorRes.leadGreyColor,
                                fontSize: AppFontSizes.small,
                                fontWeight: AppFontWeights.medium,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              items!.ownerName!,
                              style:  TextStyle(
                                fontWeight: AppFontWeights.extraBold,
                                fontSize: AppFontSizes.small,
                                color: ColorRes.black,
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
