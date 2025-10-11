// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';
import 'package:housing_flutter_app/modules/property/views/property_detail_screen.dart';
import 'package:housing_flutter_app/utils/common_widget/rera_widget.dart';

import '../../../../app/manager/property/proiperty_feature_manager.dart';
import '../../../property/controllers/property_controller.dart';

class PropertyCardWidget extends StatefulWidget {
  final Items property;
  // final String imageUrl;
  // final String title;
  // final String location;
  // final String price;
  // final String ownerName;
  // final List<String> images;
  // final String ownerAvatar;
  final String role;
  // final String beds;
  //
  // final List<Map<String, dynamic>> apartments;
  // final List<String> features;

  const PropertyCardWidget({
    super.key,
    required this.property,
    // required this.imageUrl,
    // required this.features,
    // required this.images,
    // required this.apartments,
    // required this.title,
    // required this.location,
    // required this.price,
    // required this.ownerName,
    // required this.ownerAvatar,
    required this.role,
    // required this.beds,
  });

  @override
  State<PropertyCardWidget> createState() => _PropertyCardWidgetState();
}

class _PropertyCardWidgetState extends State<PropertyCardWidget> {
  final int _currentImageIndex = 0;
  // bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    final features = PropertyFeatureManager.getFeatures(widget.property);
    final controller = Get.find<PropertyController>();
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

                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      controller.toggleFavorite(widget.property.id ?? '');
                    },
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: ColorRes.white,
                      child: Obx(
                        () {
                          final isFavorite = controller.favoriteIds.contains(widget.property.id);
                          return Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: ColorRes.primary,
                          size: 17,
                        );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // SizedBox(height: AppSpacing.small),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.small),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.property.title?.toString() ?? ' N/A',
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
                              Formatter.formatPrice(
                                widget
                                        .property
                                        .propertyDetails
                                        ?.financialInfo
                                        ?.price ??
                                    0,
                              ),
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

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.small,
                vertical: 2,
              ),
              child: SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: features.length,
                  itemBuilder: (context, index) {
                    final feature = features[index];
                    return Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.small,
                      ),
                      decoration: BoxDecoration(
                        color: ColorRes.leadGreyColor.shade100,
                        borderRadius: BorderRadius.circular(AppRadius.small),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            feature,
                            style: const TextStyle(
                              fontSize: AppFontSizes.caption,
                              color: ColorRes.grey,
                              fontWeight: AppFontWeights.medium,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder:
                      (context, index) => const SizedBox(width: 5),
                ),
              ),
            ),
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
                          widget.property.ownerName ?? 'N/A',
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
                      color: ColorRes.primary,
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                    child: const Icon(
                      Icons.call,
                      color: ColorRes.background,
                      size: AppFontSizes.medium,
                    ),
                  ),
                  const SizedBox(width: 8),
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
            const SizedBox(height: AppSpacing.small),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/constants/size_manager.dart';
// import 'package:housing_flutter_app/utils/common_widget/rera_widget.dart';

// class PropertyCardWidget extends StatefulWidget {
//   final String imageUrl;
//   final String title;
//   final String location;
//   final String price;
//   final String ownerName;
//   final List<String> images;
//   final String ownerAvatar;
//   final String role;
//   final String beds;
//   final List<Map<String, dynamic>> apartments;
//   final List<String> features;

//   const PropertyCardWidget({
//     super.key,
//     required this.imageUrl,
//     required this.features,
//     required this.images,
//     required this.apartments,
//     required this.title,
//     required this.location,
//     required this.price,
//     required this.ownerName,
//     required this.ownerAvatar,
//     required this.role,
//     required this.beds,
//   });

//   @override
//   State<PropertyCardWidget> createState() => _PropertyCardWidgetState();
// }

// class _PropertyCardWidgetState extends State<PropertyCardWidget> {
//   bool isFavorite = false;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: ColorRes.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(AppRadius.medium),
//       ),
//       elevation: 3,
//       margin: const EdgeInsets.symmetric(vertical: AppPadding.small),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // 🔹 Image Section
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(AppRadius.medium),
//                 ),
//                 child: SizedBox(
//                   height: 160,
//                   width: double.infinity,
//                   child: PageView.builder(
//                     itemCount: widget.images.length,
//                     itemBuilder: (context, index) {
//                       return Image.network(
//                         widget.images[index],
//                         fit: BoxFit.cover,
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               // RERA or Verified Badge
//               Positioned(
//                 left: 12,
//                 bottom: 12,
//                 child: ReraComponent(
//                   text: (widget.role.trim().toLowerCase() == 'owner')
//                       ? "Verified"
//                       : "RERA",
//                   backgroundColor: Colors.black.withOpacity(0.7),
//                   textColor: ColorRes.white,
//                   fontSize: AppFontSizes.extraSmall,
//                   borderRadius: AppRadius.small,
//                   fontWeight: AppFontWeights.bold,
//                   showIcon: true,
//                   iconColor: ColorRes.success,
//                   iconSize: 13,
//                 ),
//               ),
//               // Favorite Button
//               Positioned(
//                 top: 12,
//                 right: 12,
//                 child: GestureDetector(
//                   onTap: () => setState(() => isFavorite = !isFavorite),
//                   child: CircleAvatar(
//                     radius: 16,
//                     backgroundColor: ColorRes.white,
//                     child: Icon(
//                       isFavorite ? Icons.favorite : Icons.favorite_border,
//                       color: ColorRes.primary,
//                       size: 18,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           // 🔹 Title & Location
//           Padding(
//             padding: const EdgeInsets.all(AppPadding.small),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.title,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     fontSize: AppFontSizes.medium,
//                     fontWeight: AppFontWeights.semiBold,
//                     color: ColorRes.textColor,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on,
//                         size: 14, color: ColorRes.grey),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       child: Text(
//                         widget.location,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           fontSize: AppFontSizes.extraSmall,
//                           color: ColorRes.grey,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           // 🔹 Apartment Info (BHK & Price Range)
//           if (widget.apartments.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: AppPadding.small),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: widget.apartments.map((apartment) {
//                     return Padding(
//                       padding: const EdgeInsets.only(right: 16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             apartment['bhk'],
//                             style: const TextStyle(
//                               fontSize: AppFontSizes.caption,
//                               color: ColorRes.textColor,
//                             ),
//                           ),
//                           const SizedBox(height: 2),
//                           Text(
//                             apartment['priceRange'],
//                             style: const TextStyle(
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.bold,
//                               color: ColorRes.primary,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),

//           const SizedBox(height: 8),

//           // 🔹 Features (chips)
//           if (widget.features.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: AppPadding.small),
//               child: Wrap(
//                 spacing: 8,
//                 runSpacing: 6,
//                 children: widget.features.map((feature) {
//                   return Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: AppPadding.small,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade100,
//                       borderRadius: BorderRadius.circular(AppRadius.small),
//                     ),
//                     child: Text(
//                       feature,
//                       style: const TextStyle(
//                         fontSize: AppFontSizes.extraSmall,
//                         color: ColorRes.textDisabled,
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),

//           const Divider(height: 20, thickness: 0.8),

//           // 🔹 Owner Info + Buttons
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: AppPadding.small),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 18,
//                   backgroundColor: ColorRes.white,
//                   child: CircleAvatar(
//                     radius: 16,
//                     backgroundImage: NetworkImage(widget.ownerAvatar),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.ownerName,
//                         style: const TextStyle(
//                           fontSize: AppFontSizes.small,
//                           fontWeight: AppFontWeights.semiBold,
//                           color: ColorRes.textColor,
//                         ),
//                       ),
//                       Text(
//                         widget.role,
//                         style: const TextStyle(
//                           fontSize: 10,
//                           fontWeight: FontWeight.w400,
//                           color: ColorRes.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Call Button
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: ColorRes.primary,
//                     borderRadius: BorderRadius.circular(AppRadius.small),
//                   ),
//                   child: const Icon(Icons.call,
//                       color: ColorRes.white, size: AppFontSizes.medium),
//                 ),
//                 const SizedBox(width: 8),
//                 // View Details Button
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: ColorRes.primary, width: 1.5),
//                     borderRadius: BorderRadius.circular(AppRadius.small),
//                   ),
//                   child: const Text(
//                     "View Details",
//                     style: TextStyle(
//                       fontSize: AppFontSizes.extraSmall,
//                       fontWeight: AppFontWeights.semiBold,
//                       color: ColorRes.primary,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: AppSpacing.small),
//         ],
//       ),
//     );
//   }
// }
