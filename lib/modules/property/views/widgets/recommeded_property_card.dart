// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/constants/img_res.dart';
// import 'package:housing_flutter_app/app/constants/size_manager.dart';
// import 'package:housing_flutter_app/utils/common_widget/rera_widget.dart';
// import '../../../../data/network/property/models/property_model.dart';
// import '../property_detail_screen.dart';

// class RecommededPropertyCard extends StatefulWidget {
//   final Items property;
//   // final String imageUrl;
//   // final String title;
//   // final String price;
//   // final String location;
//   final bool isRecentlyViewed;

//   const RecommededPropertyCard({
//     Key? key,
//     // required this.imageUrl,
//     // required this.title,
//     // required this.price,
//     // required this.location,
//     this.isRecentlyViewed = false,
//     required this.property,
//   }) : super(key: key);

//   @override
//   State<RecommededPropertyCard> createState() => _RecommededPropertyCardState();
// }

// class _RecommededPropertyCardState extends State<RecommededPropertyCard> {
//   bool isFavorite = false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap:
//           () => Get.to(() => PropertyDetailScreen(property: widget.property)),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 250),
//         curve: Curves.easeInOut,
//         width: 240,
//         decoration: BoxDecoration(
//           color: ColorRes.white,
//           borderRadius: BorderRadius.circular(AppRadius.medium),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🔹 Image Section
//             ClipRRect(
//               borderRadius: const BorderRadius.vertical(
//                 top: Radius.circular(16),
//               ),
//               child: Stack(
//                 children: [
//                   widget.property.propertyMedia!.images!.isNotEmpty
//                       ? Image.network(
//                         widget.property.propertyMedia!.images!.first,
//                         height: 150,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       )
//                       : Image.asset(
//                         IMGRes.home1,
//                         height: 150,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                   // Overlay gradient
//                   Container(
//                     height: 150,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.black.withOpacity(0.4),
//                           Colors.transparent,
//                         ],
//                         begin: Alignment.bottomCenter,
//                         end: Alignment.topCenter,
//                       ),
//                     ),
//                   ),

//                   // Rent Tag (top-left)
//                   // Positioned(
//                   //   top: 10,
//                   //   left: 10,
//                   //   child: Container(
//                   //     padding: const EdgeInsets.symmetric(
//                   //       vertical: 4,
//                   //       horizontal: 8,
//                   //     ),
//                   //     decoration: BoxDecoration(
//                   //       color: ColorRes.white,
//                   //       borderRadius: BorderRadius.circular(8),
//                   //     ),
//                   //     child: Text(
//                   //       widget.property.listingType ?? '-',
//                   //       style: TextStyle(
//                   //         color: ColorRes.primary,
//                   //         fontSize: 12,
//                   //         fontWeight: AppFontWeights.semiBold,
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                   Positioned(
//                     top: 10,
//                     left: 10,
//                     child: ReraComponent(
//                       text: "RERA",
//                       backgroundColor: ColorRes.black.withOpacity(0.5),
//                       textColor: ColorRes.background,
//                       fontSize: AppFontSizes.extraSmall,

//                       borderRadius: AppRadius.small,
//                       fontWeight: AppFontWeights.bold,
//                       showIcon: true,
//                       iconColor: ColorRes.story,
//                       iconSize: 13,
//                     ),
//                   ),

//                   // Favorite Button (top-right)
//                   Positioned(
//                     top: 10,
//                     right: 10,
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           isFavorite = !isFavorite;
//                         });
//                       },
//                       child: Container(
//                         height: 32,
//                         width: 32,
//                         decoration: BoxDecoration(
//                           color: ColorRes.white,
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 4,
//                             ),
//                           ],
//                         ),
//                         child: Icon(
//                           isFavorite
//                               ? Icons.favorite_rounded
//                               : Icons.favorite_border_rounded,
//                           color: isFavorite ? Colors.red : Colors.grey,
//                           size: 18,
//                         ),
//                       ),
//                     ),
//                   ),

//                   // Recently Viewed Badge (bottom-left)
//                   if (widget.isRecentlyViewed) // only show if true
//                     Positioned(
//                       bottom: 10,
//                       left: 10,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 4,
//                           horizontal: 8,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.7),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: const Text(
//                           "Recently Viewed",
//                           style: TextStyle(
//                             color: ColorRes.white,
//                             fontSize: 10,
//                             fontWeight: AppFontWeights.medium,
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),

//             // 🔹 Content Section
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Title & Price
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             widget.property.title ?? '-',
//                             style: const TextStyle(
//                               fontWeight: AppFontWeights.semiBold,
//                               fontSize: 14,
//                               color: Colors.black87,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Text(
//                           "₹ ${widget.property.propertyDetails?.financialInfo?.price ?? '0'}",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: ColorRes.primary,
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 6),

//                     // Property Info
//                     // if (widget.property.propertyDetails?.bhk != null) ...[
//                     //   Text(
//                     //     "${widget.property.propertyDetails!.bhk} BHK · 3000 sqft",
//                     //     style: TextStyle(
//                     //       fontSize: 13,
//                     //       color: Colors.grey.shade700,
//                     //     ),
//                     //   ),
//                     // ],
//                     // Inside your property card
//                     if (widget.property.propertyDetails != null) ...[
//                       Text(
//                         [
//                           if (widget.property.propertyDetails!.bhk != null)
//                             "${widget.property.propertyDetails!.bhk} BHK",
//                           // if (widget.property.propertyDetails!.area != null)
//                           //   "${widget.property.propertyDetails!.area} sqft",
//                           if (widget
//                                   .property
//                                   .propertyDetails
//                                   ?.furnishInfo
//                                   ?.furnishType !=
//                               null)
//                             widget
//                                 .property
//                                 .propertyDetails!
//                                 .furnishInfo!
//                                 .furnishType,
//                           if (widget.property.propertyDetails?.propertyFacing !=
//                               null)
//                             widget.property.propertyDetails!.propertyFacing!,
//                           // if (widget.property.propertyDetails!.bathrooms != null)
//                           //   "${widget.property.propertyDetails!.bathrooms} Bath",
//                         ].join(" · "),
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey.shade800,
//                           fontWeight: AppFontWeights.medium,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],

//                     const SizedBox(height: 4),

//                     Row(
//                       children: [
//                         Transform.translate(
//                           offset: const Offset(-2, 0), // move left by 2px
//                           child: const Icon(
//                             Icons.location_on_rounded,
//                             size: 14,
//                             color: ColorRes.grey,
//                           ),
//                         ),
//                         const SizedBox(width: 3),
//                         Expanded(
//                           child: Text(
//                             widget.property.address ?? '-',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey.shade600,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailChip(String text) {
//     return Text(
//       text,
//       style: TextStyle(
//         fontSize: 12,
//         color: Colors.grey.shade800,
//         fontWeight: AppFontWeights.medium,
//       ),
//     );
//   }
// }
