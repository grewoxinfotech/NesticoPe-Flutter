// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';
import 'package:housing_flutter_app/app/manager/data_masker.dart';
import 'package:housing_flutter_app/app/manager/property/property_name_manager.dart';
import 'package:housing_flutter_app/app/manager/property/property_pricemanager.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';
import 'package:housing_flutter_app/modules/home/views/compare_screen/comapre_screen.dart';
import 'package:housing_flutter_app/modules/property/views/property_detail_screen.dart';
import 'package:housing_flutter_app/modules/saved_property/controllers/property_favorite_controller.dart';
import 'package:housing_flutter_app/utils/common_widget/rera_widget.dart';

import '../../../../app/manager/property/proiperty_feature_manager.dart';
import '../../../../app/manager/property_highlight_manager.dart';
import '../../../../app/manager/compare_manager.dart';
import '../../../../app/widgets/snack_bar/custom_snackbar.dart';
import '../../../../app/utils/svg_widget.dart';
import '../../../../widgets/bar/navigation_bar/navigation_Bar.dart';
import '../../../feedback/views/feedback_and_report.dart';
import '../../../property/controllers/property_controller.dart';

class PropertyCardWidget extends StatefulWidget {
  final Items property;
  final String role;
  final bool isFeedbackEnabled;

  const PropertyCardWidget({
    super.key,
    required this.property,
    required this.role,
    this.isFeedbackEnabled = false,
  });

  @override
  State<PropertyCardWidget> createState() => _PropertyCardWidgetState();
}

class _PropertyCardWidgetState extends State<PropertyCardWidget> {
  final int _currentImageIndex = 0;
  final CompareManager compare = Get.put(CompareManager(), permanent: true);
  @override
  Widget build(BuildContext context) {
    final price = PropertyPriceManager(
      listingType: widget.property.listingType ?? '',
      financialInfo:
          widget.property.propertyDetails?.financialInfo ?? FinancialInfo(),
    );
    final title = PropertyNameManager(widget.property);
    final features = PropertyFeatureManager.getFeatures(widget.property);
    final controller = Get.find<PropertyController>();
    final PropertyFavoriteController favoriteController =
        Get.find<PropertyFavoriteController>();
    // print('Building PropertyCardWidget for ${widget.role}');
    return GestureDetector(
      onTap: () {
        Get.to(() => PropertyDetailScreen(property: widget.property));
      },
      child: Card(
        color: ColorRes.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          // ignore: deprecated_member_use
          side: BorderSide(color: ColorRes.leadGreyColor[300]!, width: 1),
        ),
        // elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: AppPadding.small),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 138, // adjust height as needed
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.antiAliasWithSaveLayer,

                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.small,
                      vertical: AppPadding.small,
                    ),
                    itemCount:
                        widget.property.propertyMedia?.images?.length ?? 0,
                    separatorBuilder:
                        (context, index) =>
                            const SizedBox(width: 6), // gap between images
                    itemBuilder: (context, index) {
                      final property =
                          widget.property.propertyMedia?.images?[index];
                      return Container(
                        width:
                            MediaQuery.of(context).size.width / 2 -
                            2, // show 2 images
                        decoration: BoxDecoration(
                          color: ColorRes.leadGreyColor.shade200,
                          borderRadius: BorderRadius.circular(12),
                          // image: DecorationImage(
                          //   image: NetworkImage(property),
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                        child:
                            property != null
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  //   child: Image.network(
                                  //     property,
                                  //     fit: BoxFit.cover,
                                  //     bu
                                  //     errorBuilder: (context, error, stackTrace) {
                                  //       return Center(
                                  //         child: const Icon(
                                  //           Icons.broken_image,
                                  //           size: 40,
                                  //           color: Colors.grey,
                                  //         ),
                                  //
                                  //       );
                                  //     },
                                  //   ),
                                  // )
                                  child: CustomImage(
                                    type: CustomImageType.network,
                                    src: property,
                                  ),
                                )
                                : Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 40,
                                    color: ColorRes.leadGreyColor,
                                  ),
                                ),
                      );
                    },
                  ),
                ),

                // TODO: fetch by role
                Positioned(
                  left: 14,
                  bottom: 14,
                  child: ReraComponent(
                    text:
                        (widget.role.trim().toLowerCase() == 'owner')
                            ? "Verified"
                            : "rera",
                    backgroundColor: ColorRes.black.withOpacity(0.7),
                    textColor: ColorRes.background,
                    fontSize: AppFontSizes.extraSmall,

                    borderRadius: AppRadius.small,
                    fontWeight: AppFontWeights.bold,
                    showIcon: true,
                    iconColor: ColorRes.success,
                    iconSize: 14,
                  ),
                ),

                // Compare & Favorite buttons
                Positioned(
                  top: 16,
                  right: 16,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Compare button
                      GestureDetector(
                        onTap: () {
                          final before = compare.count;
                          compare.toggle(widget.property, max: 2);
                          final after = compare.count;

                          final ctx = Get.overlayContext;
                          if (ctx != null) {
                            if (after > before) {
                              CustomSnackBar.show(
                                ctx,
                                message:
                                    after == 2
                                        ? 'Ready to compare!'
                                        : 'Added to compare (${after}/2)',
                                type: SnackBarType.success,
                                actionLabel: after == 2 ? 'Compare Now' : null,
                                onActionPressed:
                                    after == 2
                                        ? () {
                                          Get.back(); // Close snackbar first
                                          if (Get.isRegistered<
                                            NavigationController
                                          >()) {
                                            Get.find<NavigationController>()
                                                .changeIndex(2);
                                          }
                                        }
                                        : null,
                              );
                            } else if (after < before) {
                              CustomSnackBar.show(
                                ctx,
                                message:
                                    after == 0
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
                          final selected = compare.isSelected(
                            widget.property.id,
                          );
                          return CircleAvatar(
                            radius: 14,
                            backgroundColor:
                                selected ? ColorRes.primary : ColorRes.white,

                            child: Icon(
                              Icons.compare_arrows,
                              color:
                                  selected ? ColorRes.white : ColorRes.primary,
                              size: 17,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(width: 6),
                      // Favorite button
                      GestureDetector(
                        onTap: () {
                          favoriteController.toggleFavorite(
                            widget.property.id ?? '',
                          );
                        },
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: ColorRes.white,
                          child: Obx(() {
                            final isFavorite = favoriteController.favorites
                                .contains(widget.property.id);
                            return Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  isFavorite
                                      ? ColorRes.error
                                      : ColorRes.leadGreyColor,
                              size: 17,
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // SizedBox(height: AppSpacing.small),

            // title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.small),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title.displayName,
                      style: const TextStyle(
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            //--------here
            const SizedBox(height: 4),
            //=======================================================
            //=======================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.small),
              child: Row(
                children: [
                  // const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  Expanded(
                    child: Text(
                      widget.property.address ?? 'N/A',
                      style: const TextStyle(
                        color: ColorRes.grey,
                        fontSize: AppFontSizes.extraSmall,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.small),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.small),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // const SizedBox(width: 13),
                    // ...List.generate(
                    //   widget.apartments.length,
                    //   (index) => Row(
                    //     children: [
                    //       Column(
                    //         children: [
                    //           Text(
                    //             widget.apartments[index]['bhk'],
                    //             style: const TextStyle(
                    //               fontSize: AppFontSizes.caption,
                    //             ),
                    //           ),
                    //           const SizedBox(height: 4),
                    //           Text(
                    //             widget.apartments[index]['priceRange'],
                    //             style: TextStyle(
                    //               fontSize:
                    //                   (widget.role.trim().toLowerCase() ==
                    //                           'owner')
                    //                       ? AppFontSizes.body
                    //                       : AppFontSizes.caption,
                    //               fontWeight:
                    //                   (widget.role.trim().toLowerCase() ==
                    //                           'owner')
                    //                       ? AppFontWeights.bold
                    //                       : AppFontWeights.semiBold,
                    //               color: ColorRes.textColor,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       if (index != widget.apartments.length - 1) ...[
                    //         const SizedBox(width: 12),
                    //         Container(
                    //           height: 25,
                    //           width: 1,
                    //           color: Colors.grey.shade300,
                    //         ),
                    //         const SizedBox(width: 12),
                    //       ],
                    //     ],
                    //   ),
                    // ),
                    Row(
                      children: [
                        Column(
                          children: [
                            // Text(
                            //   '${widget.property.propertyDetails?.bhk.toString() ?? '0'} BHK',
                            //   style: const TextStyle(
                            //     fontSize: AppFontSizes.caption,
                            //   ),
                            // ),
                            // const SizedBox(height: 4),
                            Text(
                              price.displayPrice,
                              style: TextStyle(
                                fontSize:
                                    (widget.role.trim().toLowerCase() ==
                                            'owner')
                                        ? AppFontSizes.body
                                        : AppFontSizes.caption,
                                fontWeight:
                                    (widget.role.trim().toLowerCase() ==
                                            'owner')
                                        ? AppFontWeights.bold
                                        : AppFontWeights.semiBold,
                                color: ColorRes.textColor,
                              ),
                            ),
                          ],
                        ),
                        // if (index != widget.apartments.length - 1) ...[
                        //   const SizedBox(width: 12),
                        //   Container(
                        //     height: 25,
                        //     width: 1,
                        //     color: Colors.grey.shade300,
                        //   ),
                        //   const SizedBox(width: 12),
                        // ],
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: AppPadding.small,
            //     vertical: 2,
            //   ),
            //   child: SizedBox(
            //     height: 40,
            //     child: ListView.separated(
            //       scrollDirection: Axis.horizontal,
            //       itemCount: features.length,
            //       itemBuilder: (context, index) {
            //         final feature = features[index];
            //         return Container(
            //           margin: const EdgeInsets.only(top: 8, bottom: 8),
            //           padding: const EdgeInsets.symmetric(
            //             horizontal: AppPadding.small,
            //           ),
            //           decoration: BoxDecoration(
            //             color: ColorRes.leadGreyColor.shade100,
            //             borderRadius: BorderRadius.circular(AppRadius.small),
            //           ),
            //           child: Row(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Text(
            //                 feature,
            //                 style: const TextStyle(
            //                   fontSize: AppFontSizes.caption,
            //                   color: ColorRes.grey,
            //                   fontWeight: AppFontWeights.medium,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         );
            //       },
            //       separatorBuilder:
            //           (context, index) => const SizedBox(width: 5),
            //     ),
            //   ),
            // ),
            SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Facilities(property: widget.property),
            ),
            SizedBox(height: 8),
            Divider(
              height: 15,
              color: ColorRes.leadGreyColor.shade300,
              indent: 12,
              endIndent: 12,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.small),
              child: Row(
                children: [
                  // TODO: Change Image
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorRes.primary, width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      backgroundImage:
                          CustomImage(
                            type: CustomImageType.asset,
                            src: IMGRes.user_1,
                          ).toImageProvider(),
                      radius: 13,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DataMasker.maskName(widget.property.ownerName),
                          style: const TextStyle(
                            fontSize: AppFontSizes.small,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.textColor,
                          ),
                        ),
                        Text(
                          widget.role,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: AppFontWeights.medium,
                            color: ColorRes.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.small,
                      vertical: AppPadding.small,
                    ),
                    decoration: BoxDecoration(
                      // color: ColorRes.primary,
                      border: Border.all(color: ColorRes.primary, width: 1.5),
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                    child: const Text(
                      "View Details",
                      style: TextStyle(
                        color: ColorRes.primary,
                        fontSize: AppFontSizes.extraSmall,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.isFeedbackEnabled) ...[
              const SizedBox(height: AppSpacing.small),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Get.to(
                        () => FeedBackAndReportScreen(
                          propertyId: widget.property.id ?? '',
                        ),
                        transition: Transition.cupertino,
                      );
                    },
                    label: const Text(
                      'Give Feedback or Report',
                      style: TextStyle(
                        color: ColorRes.primary,
                        fontSize: AppFontSizes.bodyMedium,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: ColorRes.primary,
                        width: 1.4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.white,
                      foregroundColor: ColorRes.primary,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.small),
          ],
        ),
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
