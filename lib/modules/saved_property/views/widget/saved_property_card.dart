// import 'package:flutter/material.dart';
// import 'package:nesticope_app/app/constants/color_res.dart';
// import 'package:nesticope_app/app/widgets/image/custom_image.dart';
//
// class SavedPropertyCard extends StatelessWidget {
//   final String imageUrl;
//   final bool isForRent;
//   final String location;
//   final String price;
//   final bool isFavorite;
//   final VoidCallback? onContactPressed;
//   final VoidCallback? onFavoritePressed;
//   final VoidCallback? onZoomPressed;
//
//   const SavedPropertyCard({
//     super.key,
//     required this.imageUrl,
//     required this.isForRent,
//     required this.location,
//     required this.price,
//     this.isFavorite = false,
//     this.onContactPressed,
//     this.onFavoritePressed,
//     this.onZoomPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 380,
//       margin: EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: ColorRes.leadGreyColor.withOpacity(0.3)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Image Section with Badge and Favorite
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(16),
//                   topRight: Radius.circular(16),
//                 ),
//                 child: CustomImage(
//                   type: CustomImageType.network,
//                   src: imageUrl,
//                   fit: BoxFit.cover,
//                   height: 180,
//                   width: double.infinity,
//                 ),
//               ),
//               // Rent/Sell Badge
//               Positioned(
//                 top: 12,
//                 left: 12,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color:
//                         isForRent ? ColorRes.leadTealColor : ColorRes.primary,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     isForRent ? 'For Rent' : 'For Sale',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//               // Favorite Button
//               Positioned(
//                 top: 12,
//                 right: 12,
//                 child: GestureDetector(
//                   onTap: onFavoritePressed,
//                   child: Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.95),
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.08),
//                           blurRadius: 12,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Icon(
//                       isFavorite ? Icons.favorite : Icons.favorite_border,
//                       color:
//                           isFavorite
//                               ? const Color(0xFFFF6B6B)
//                               : Colors.grey[700],
//                       size: 22,
//                     ),
//                   ),
//                 ),
//               ),
//               // Zoom Button
//             ],
//           ),
//           // Content Section
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Location
//                 Row(
//                   children: [
//                     Icon(Icons.location_on, color: ColorRes.primary, size: 20),
//                     const SizedBox(width: 6),
//                     Expanded(
//                       child: Text(
//                         location,
//                         style: TextStyle(
//                           color: Colors.grey[700],
//                           fontSize: 15,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 1,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 14),
//                 // Price
//                 Text(
//                   price,
//                   style: const TextStyle(
//                     color: Color(0xFF1A1A1A),
//                     fontSize: 26,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: -0.5,
//                   ),
//                 ),
//                 const SizedBox(height: 18),
//                 // Contact Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: OutlinedButton(
//                     onPressed: () {},
//                     child: Text('Contact'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/app/manager/property/property_pricemanager.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/app/widgets/image/custom_image.dart'
    hide ColorRes;
import 'package:nesticope_app/data/network/property/models/inquiry_model.dart';
import 'package:nesticope_app/data/network/property/models/property_model.dart';

import '../../controllers/property_favorite_controller.dart';
import '../../../../data/database/secure_storage_service.dart';
import '../../../../data/network/property/services/property_service.dart';
import '../../../../data/network/property/services/property_contacted_service.dart';
import '../../../../data/network/builder/service/builder_service.dart';
import '../../../../data/network/builder/model/builder_model.dart';
import '../../../../widgets/New folder/inputs/text_field.dart';
import '../../../../widgets/New folder/inputs/dropdown_field.dart';
import '../../../../widgets/messages/snack_bar.dart';

// class HorizontalPropertyCard extends StatelessWidget {
//   final String imageUrl;
//   final bool isForRent;
//   final String? projectName;
//   final String location;
//   final String price;
//   final String? propertyType;
//   final String? listingType;
//   final String? priceType;
//   final String? status;
//   final String? city;
//   final String? entityType;
//   final bool? isVerified;
//   final int? postedDaysAgo;
//   final bool isFavorite;
//   final VoidCallback? onContactPressed;
//   final VoidCallback? onFavoritePressed;
//   final VoidCallback? onTap;
//
//   const HorizontalPropertyCard({
//     super.key,
//     required this.imageUrl,
//     required this.isForRent,
//     required this.location,
//     required this.price,
//     this.propertyType,
//     this.projectName,
//     this.listingType,
//     this.priceType,
//     this.status,
//     this.city,
//     this.entityType,
//     this.isVerified,
//     this.postedDaysAgo,
//     this.isFavorite = false,
//     this.onContactPressed,
//     this.onFavoritePressed,
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         height: 180,
//         decoration: BoxDecoration(
//           color: ColorRes.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: ColorRes.border.withOpacity(0.3), width: 1),
//         ),
//         child: Row(
//           children: [
//             // Image Section
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(16),
//                     bottomLeft: Radius.circular(16),
//                   ),
//                   child: CustomImage(
//                     type: CustomImageType.network,
//                     src: imageUrl,
//                     fit: BoxFit.cover,
//                     height: 180,
//                     width: 140,
//                   ),
//                 ),
//                 // Gradient overlay
//                 Container(
//                   height: 180,
//                   width: 140,
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(16),
//                       bottomLeft: Radius.circular(16),
//                     ),
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.black.withOpacity(0.4),
//                         Colors.transparent,
//                         Colors.black.withOpacity(0.7)
//                       ],
//                       stops: const [0.0, 0.5, 1.0],
//                     ),
//                   ),
//                 ),
//                 // Rent/Sell Badge
//                 Positioned(
//                   top: 8,
//                   left: 8,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: isForRent
//                           ? const Color(0xFF14B8A6)
//                           : ColorRes.primary,
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           isForRent ? Icons.key : Icons.sell_outlined,
//                           color: Colors.white,
//                           size: 12,
//                         ),
//                         const SizedBox(width: 3),
//                         Text(
//                           isForRent ? 'Rent' : 'Sale',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 10,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Verified Badge
//                 if (isVerified == true)
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: Container(
//                       padding: const EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         color: ColorRes.success,
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: const Icon(
//                         Icons.verified,
//                         color: Colors.white,
//                         size: 12,
//                       ),
//                     ),
//                   ),
//                 // Property Type Badge
//                 Positioned(
//                   bottom: 8,
//                   left: 8,
//                   right: 8,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.95),
//                       borderRadius: BorderRadius.circular(6),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.15),
//                           blurRadius: 8,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Text(
//                       entityType == 'project'
//                           ? (projectName ?? 'Project')
//                           : (propertyType ?? 'Property'),
//                       style: const TextStyle(
//                         color: ColorRes.textPrimary,
//                         fontSize: 10,
//                         fontWeight: FontWeight.w700,
//                       ),
//                       textAlign: TextAlign.center,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             // Content Section
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Entity Type and Status Row
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 6,
//                             vertical: 3,
//                           ),
//                           decoration: BoxDecoration(
//                             color: entityType == 'project'
//                                 ? ColorRes.primary.withOpacity(0.1)
//                                 : ColorRes.leadTealColor.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(4),
//                             border: Border.all(
//                               color: entityType == 'project'
//                                   ? ColorRes.primary.withOpacity(0.3)
//                                   : ColorRes.leadTealColor.withOpacity(0.3),
//                               width: 1,
//                             ),
//                           ),
//                           child: Text(
//                             entityType == 'project' ? '🏢 Project' : '🏠 Property',
//                             style: TextStyle(
//                               color: entityType == 'project'
//                                   ? ColorRes.primary
//                                   : ColorRes.leadTealColor,
//                               fontSize: 9,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                         if (status != null && status!.isNotEmpty) ...[
//                           const SizedBox(width: 4),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 6,
//                               vertical: 3,
//                             ),
//                             decoration: BoxDecoration(
//                               color: _getStatusColor(status!).withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(4),
//                               border: Border.all(
//                                 color: _getStatusColor(status!).withOpacity(0.3),
//                                 width: 1,
//                               ),
//                             ),
//                             child: Text(
//                               status!.toUpperCase(),
//                               style: TextStyle(
//                                 color: _getStatusColor(status!),
//                                 fontSize: 8,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                         ],
//                         const Spacer(),
//                         // Favorite Button
//                         GestureDetector(
//                           onTap: onFavoritePressed,
//                           child: Container(
//                             padding: const EdgeInsets.all(6),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: ColorRes.border.withOpacity(0.3),
//                                 width: 1,
//                               ),
//                             ),
//                             child: Icon(
//                               isFavorite ? Icons.favorite : Icons.favorite_border,
//                               color: isFavorite ? ColorRes.error : ColorRes.textSecondary,
//                               size: 16,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     // Project Name (for projects)
//                     if (entityType == 'project' && projectName != null)
//                       Text(
//                         projectName!,
//                         style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                           color: ColorRes.textPrimary,
//                           letterSpacing: -0.3,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     if (entityType == 'project' && projectName != null)
//                       const SizedBox(height: 4),
//                     // Location
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.location_on_outlined,
//                           color: ColorRes.textSecondary,
//                           size: 14,
//                         ),
//                         const SizedBox(width: 3),
//                         Expanded(
//                           child: Text(
//                             city ?? location,
//                             style: const TextStyle(
//                               color: ColorRes.textSecondary,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                           ),
//                         ),
//                         if (postedDaysAgo != null) ...[
//                           const SizedBox(width: 6),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 6,
//                               vertical: 2,
//                             ),
//                             decoration: BoxDecoration(
//                               color: ColorRes.background.withOpacity(0.6),
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             child: Text(
//                               '${postedDaysAgo}d',
//                               style: const TextStyle(
//                                 color: ColorRes.textSecondary,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     // Price
//                     Row(
//                       children: [
//                         Text(
//                           price,
//                           style: const TextStyle(
//                             color: ColorRes.textPrimary,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w700,
//                             letterSpacing: -0.3,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         if (priceType != null && priceType == 'monthly')
//                           const Padding(
//                             padding: EdgeInsets.only(left: 3),
//                             child: Text(
//                               '/mo',
//                               style: TextStyle(
//                                 color: ColorRes.textSecondary,
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                     const Spacer(),
//                     // Contact Button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 40,
//                       child: ElevatedButton(
//                         onPressed: onContactPressed ?? () {},
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: ColorRes.primary,
//                           foregroundColor: Colors.white,
//                           elevation: 0,
//                           padding: const EdgeInsets.symmetric(horizontal: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Icon(Icons.phone_outlined, size: 12),
//                             SizedBox(width: 6),
//                             Text(
//                               'Contact Agent',
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
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
//
//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'approved':
//         return ColorRes.success;
//       case 'upcoming':
//         return const Color(0xFFF59E0B);
//       case 'ongoing':
//         return const Color(0xFF3B82F6);
//       case 'completed':
//         return const Color(0xFF10B981);
//       default:
//         return ColorRes.textSecondary;
//     }
//   }
// }

class HorizontalPropertyCard extends StatelessWidget {
  final String imageUrl;
  final bool isForRent;
  final String? projectName;
  final String location;
  final String price;
  final String? propertyType;
  final String? listingType;
  final String? priceType;
  final String? status;
  final String? city;
  final String? entityType;
  final bool? isVerified;
  final int? postedDaysAgo;
  final bool isFavorite;
  final bool ifFeedbackEnable;
  final String propertyId;
  final VoidCallback? onContactPressed;
  final VoidCallback? onFeedbackPressed;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onTap;

  const HorizontalPropertyCard({
    super.key,
    required this.imageUrl,
    required this.isForRent,
    required this.location,
    required this.price,
    this.propertyType,
    this.projectName,
    this.listingType,
    this.priceType,

    this.status,
    this.city,
    this.entityType,
    this.isVerified,
    this.postedDaysAgo,
    this.isFavorite = false,
    this.onContactPressed,
    this.onFavoritePressed,
    this.onFeedbackPressed,
    this.onTap,
    this.ifFeedbackEnable = false,
    required this.propertyId,
  });

  // @override
  // Widget build(BuildContext context) {
  //   final PropertyFavoriteController favoriteController =
  //       Get.find<PropertyFavoriteController>();
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       margin: const EdgeInsets.only(bottom: 16),
  //       height: 200,
  //       decoration: BoxDecoration(
  //         color: ColorRes.white,
  //         borderRadius: BorderRadius.circular(
  //           AppRadius.mediumLarge,
  //         ),
  //         border: Border.all(color: ColorRes.border.withOpacity(0.2), width: 1),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.04),
  //             blurRadius: 8,
  //             offset: const Offset(0, 2),
  //           ),
  //         ],
  //       ),
  //       child: Row(
  //         children: [
  //           // Image Section
  //           Stack(
  //             children: [
  //               ClipRRect(
  //                 borderRadius: const BorderRadius.only(
  //                   topLeft: Radius.circular(AppRadius.mediumLarge),
  //                   bottomLeft: Radius.circular(AppRadius.mediumLarge),
  //                 ),
  //                 child: CustomImage(
  //                   type: CustomImageType.network,
  //                   src: imageUrl,
  //                   fit: BoxFit.cover,
  //                   height: 140,
  //                   width: 140,
  //                 ),
  //               ),
  //               // Gradient overlay
  //               Container(
  //                 height: 140,
  //                 width: 140,
  //                 decoration: BoxDecoration(
  //                   borderRadius: const BorderRadius.only(
  //                     topLeft: Radius.circular(AppRadius.mediumLarge),
  //                     bottomLeft: Radius.circular(AppRadius.mediumLarge),
  //                   ),
  //                   gradient: LinearGradient(
  //                     begin: Alignment.topCenter,
  //                     end: Alignment.bottomCenter,
  //                     colors: [
  //                       Colors.black.withOpacity(0.3),
  //                       Colors.transparent,
  //                       Colors.black.withOpacity(0.6),
  //                     ],
  //                     stops: const [0.0, 0.4, 1.0],
  //                   ),
  //                 ),
  //               ),
  //               // Rent/Sell Badge
  //               Positioned(
  //                 top: 10,
  //                 left: 10,
  //                 child: Container(
  //                   padding: const EdgeInsets.symmetric(
  //                     horizontal: 10,
  //                     vertical: 5,
  //                   ),
  //                   decoration: BoxDecoration(
  //                     color:
  //                         isForRent
  //                             ? const Color(0xFF14B8A6)
  //                             : ColorRes.primary,
  //                     borderRadius: BorderRadius.circular(6),
  //                     boxShadow: [
  //                       BoxShadow(
  //                         color: Colors.black.withOpacity(0.2),
  //                         blurRadius: 4,
  //                         offset: const Offset(0, 1),
  //                       ),
  //                     ],
  //                   ),
  //                   child: Row(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Icon(
  //                         isForRent ? Icons.key : Icons.sell_outlined,
  //                         color: Colors.white,
  //                         size: 11,
  //                       ),
  //                       const SizedBox(width: 4),
  //                       Text(
  //                         isForRent ? 'Rent' : 'Sale',
  //                         style: const TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 10,
  //                           fontWeight: FontWeight.w600,
  //                           letterSpacing: 0.2,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               // Verified Badge
  //               if (isVerified == true)
  //                 Positioned(
  //                   top: 10,
  //                   right: 10,
  //                   child: Container(
  //                     padding: const EdgeInsets.all(5),
  //                     decoration: BoxDecoration(
  //                       color: ColorRes.success,
  //                       borderRadius: BorderRadius.circular(6),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.black.withOpacity(0.2),
  //                           blurRadius: 4,
  //                           offset: const Offset(0, 1),
  //                         ),
  //                       ],
  //                     ),
  //                     child: const Icon(
  //                       Icons.verified,
  //                       color: Colors.white,
  //                       size: 11,
  //                     ),
  //                   ),
  //                 ),
  //               // Property Type Badge
  //               Positioned(
  //                 bottom: 10,
  //                 left: 10,
  //                 right: 10,
  //                 child: Container(
  //                   padding: const EdgeInsets.symmetric(
  //                     horizontal: 8,
  //                     vertical: 5,
  //                   ),
  //                   decoration: BoxDecoration(
  //                     color: Colors.white.withOpacity(0.95),
  //                     borderRadius: BorderRadius.circular(6),
  //                     boxShadow: [
  //                       BoxShadow(
  //                         color: Colors.black.withOpacity(0.1),
  //                         blurRadius: 4,
  //                         offset: const Offset(0, 1),
  //                       ),
  //                     ],
  //                   ),
  //                   child: Text(
  //                     entityType ?? '',
  //                     style: const TextStyle(
  //                       color: ColorRes.textPrimary,
  //                       fontSize: 10,
  //                       fontWeight: FontWeight.w600,
  //                       letterSpacing: 0.1,
  //                     ),
  //                     textAlign: TextAlign.center,
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           // Content Section
  //           Expanded(
  //             child: Padding(
  //               padding: EdgeInsets.symmetric(horizontal: 16),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   SizedBox(height: 8),
  //                   Row(
  //                     children: [
  //                       // Entity Type Badge
  //                       Expanded(
  //                         child: Text(
  //                           entityType == 'project'
  //                               ? (projectName ?? 'Project')
  //                               : (propertyType ?? 'Property'),
  //                           style: TextStyle(
  //                             color: ColorRes.textPrimary,
  //                             fontSize: AppFontSizes.medium,
  //                             fontWeight: AppFontWeights.semiBold,
  //                             letterSpacing: 0.1,
  //                           ),
  //                           textAlign: TextAlign.left,
  //                           maxLines: 1,
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //                       ),
  //                       // Status Badge

  //                       // Favorite Button
  //                       GestureDetector(
  //                         onTap: onFavoritePressed,
  //                         child: Icon(
  //                           isFavorite ? Icons.favorite : Icons.favorite_border,
  //                           color:
  //                               isFavorite
  //                                   ? ColorRes.error
  //                                   : ColorRes.textSecondary,
  //                           size: 15,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 10),
  //                   // Project Name (for projects)
  //                   // Location Row
  //                   Row(
  //                     children: [
  //                       Icon(
  //                         Icons.location_on_outlined,
  //                         color: ColorRes.textSecondary.withOpacity(0.8),
  //                         size: 13,
  //                       ),
  //                       const SizedBox(width: 4),
  //                       Expanded(
  //                         child: Text(
  //                           city ?? location,
  //                           style: TextStyle(
  //                             color: ColorRes.textSecondary.withOpacity(0.9),
  //                             fontSize: 12,
  //                             fontWeight: FontWeight.w500,
  //                             height: 1.3,
  //                           ),
  //                           overflow: TextOverflow.ellipsis,
  //                           maxLines: 1,
  //                         ),
  //                       ),
  //                       if (postedDaysAgo != null) ...[
  //                         const SizedBox(width: 6),
  //                         Container(
  //                           padding: const EdgeInsets.symmetric(
  //                             horizontal: 6,
  //                             vertical: 3,
  //                           ),
  //                           decoration: BoxDecoration(
  //                             color: ColorRes.background.withOpacity(0.5),
  //                             borderRadius: BorderRadius.circular(4),
  //                           ),
  //                           child: Text(
  //                             '${postedDaysAgo}d ago',
  //                             style: TextStyle(
  //                               color: ColorRes.textSecondary.withOpacity(0.8),
  //                               fontSize: 8,
  //                               fontWeight: FontWeight.w600,
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ],
  //                   ),
  //                   const SizedBox(height: 10),
  //                   Row(
  //                     children: [
  //                       Text(
  //                         price,
  //                         style: TextStyle(
  //                           color: ColorRes.textPrimary,
  //                           fontSize: AppFontSizes.bodyMedium,
  //                           fontWeight: FontWeight.w700,
  //                           letterSpacing: -0.4,
  //                           height: 1,
  //                         ),
  //                       ),
  //                       if (priceType != null && priceType == 'monthly')
  //                         Padding(
  //                           padding: const EdgeInsets.only(left: 2),
  //                           child: Text(
  //                             '/mo',
  //                             style: TextStyle(
  //                               color: ColorRes.textSecondary.withOpacity(0.8),
  //                               fontSize: 11,
  //                               fontWeight: FontWeight.w500,
  //                               height: 1,
  //                             ),
  //                           ),
  //                         ),
  //                     ],
  //                   ),
  //                   const Spacer(),
  //                   // Feedback + Negotiable Price Buttons
  //                   if (ifFeedbackEnable) ...[
  //                     SizedBox(
  //                       width: double.infinity,
  //                       height: 36,
  //                       child: OutlinedButton(
  //                         onPressed: onFeedbackPressed ?? () {},
  //                         style: OutlinedButton.styleFrom(
  //                           foregroundColor: ColorRes.primary,
  //                           side: BorderSide(
  //                             color: ColorRes.primary,
  //                             width: 1.2,
  //                           ),
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(8),
  //                           ),
  //                           padding: const EdgeInsets.symmetric(horizontal: 12),
  //                         ),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: const [
  //                             Icon(Icons.feedback_outlined, size: 14),
  //                             SizedBox(width: 6),
  //                             Text(
  //                               'Give Feedback',
  //                               style: TextStyle(
  //                                 fontSize: 12,
  //                                 fontWeight: FontWeight.w600,
  //                                 letterSpacing: 0.1,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(height: 8),
  //                     // Ask for Your Negotiable Price (only when already contacted)
  //                     Obx(() {
  //                       // final isInquirySubmitted =
  //                       //     favoriteController.hasSubmittedInquiryMap[propertyId] ?? false;
  //                       // if (!isInquirySubmitted) {
  //                       //   return const SizedBox.shrink();
  //                       // }
  //                       // Try to locate existing offer
  //                       final offer = favoriteController.inquiryResponse
  //                           .where((e) => e.propertyId == propertyId)
  //                           .map((e) => e.meta?.negotiablePrice)
  //                           .firstWhere((v) => v != null, orElse: () => null);
  //                       final hasOffer = offer != null;
  //                       final offerText = hasOffer
  //                           ? '₹ ${NumberFormat.decimalPattern().format(offer)} (YOUR OFFER)'
  //                           : 'Ask for Your Negotiable Price';
  //                       return SizedBox(
  //                         width: double.infinity,
  //                         height: 36,
  //                         child: ElevatedButton(
  //                           onPressed: hasOffer ? null : () => _openNegotiablePriceDialog(context),
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: hasOffer ? const Color(0xFFDCFCE7) : const Color(0xFFE7F5FF),
  //                             foregroundColor: hasOffer ? Colors.black87 : ColorRes.textPrimary,
  //                             elevation: 0,
  //                             padding: const EdgeInsets.symmetric(horizontal: 12),
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(8),
  //                             ),
  //                           ),
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               Text(
  //                                 offerText,
  //                                 maxLines: 2,
  //                                 style: const TextStyle(
  //                                   fontSize: 10,
  //                                   fontWeight: FontWeight.w600,
  //                                   letterSpacing: 0.1,
  //                                 ),
  //                                 overflow: TextOverflow.ellipsis,
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       );
  //                     }),
  //                     SizedBox(height: 8),
  //                   ] else ...[
  //                     /*SizedBox(
  //                       width: double.infinity,
  //                       height: 36,
  //                       child: ElevatedButton(
  //                         onPressed: onContactPressed ?? () {},
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: ColorRes.primary,
  //                           foregroundColor: Colors.white,
  //                           elevation: 0,
  //                           padding: const EdgeInsets.symmetric(horizontal: 12),
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(8),
  //                           ),
  //                         ),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: const [
  //                             Icon(Icons.phone_outlined, size: 14),
  //                             SizedBox(width: 6),
  //                             Text(
  //                               'Contact Agent',
  //                               style: TextStyle(
  //                                 fontSize: 12,
  //                                 fontWeight: FontWeight.w600,
  //                                 letterSpacing: 0.1,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),*/
  //                     Obx(() {
  //                       final isInquirySubmitted =
  //                           favoriteController
  //                               .hasSubmittedInquiryMap[propertyId] ??
  //                           false;
  //                       return SizedBox(
  //                         width: double.infinity,
  //                         height: 36,
  //                         child: ElevatedButton(
  //                           onPressed:
  //                               isInquirySubmitted
  //                                   ? null
  //                                   : (onContactPressed ?? () {}),
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor:
  //                                 isInquirySubmitted
  //                                     ? Colors
  //                                         .grey
  //                                         .shade400 // Disabled color
  //                                     : ColorRes.primary,
  //                             foregroundColor: Colors.white,
  //                             elevation: 0,
  //                             padding: const EdgeInsets.symmetric(
  //                               horizontal: 12,
  //                             ),
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(8),
  //                             ),
  //                           ),
  //                           child:
  //                               (isInquirySubmitted)
  //                                   ? Text(
  //                                     'Already Contacted',
  //                                     style: TextStyle(
  //                                       fontSize: 12,
  //                                       fontWeight: FontWeight.w600,
  //                                       letterSpacing: 0.1,
  //                                     ),
  //                                   )
  //                                   : Row(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.center,
  //                                     children: const [
  //                                       Icon(Icons.phone_outlined, size: 14),
  //                                       SizedBox(width: 6),
  //                                       Text(
  //                                         'Contact Agent',
  //                                         style: TextStyle(
  //                                           fontSize: 12,
  //                                           fontWeight: FontWeight.w600,
  //                                           letterSpacing: 0.1,
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                         ),
  //                       );
  //                     }),
  //                     SizedBox(height: 8),
  //                   ],
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
   @override
  Widget build(BuildContext context) {
    final PropertyFavoriteController favoriteController =
        Get.find<PropertyFavoriteController>();
 
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Row: image + info ──────────────────────────────
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Image with badges ────────────────────────────
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomImage(
                          type: CustomImageType.network,
                          src: imageUrl,
                          fit: BoxFit.cover,
                          height: 110,
                          width: 110,
                        ),
                      ),
                      // Gradient overlay
                      Container(
                        height: 110,
                        width: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.25),
                              Colors.transparent,
                              Colors.black.withOpacity(0.45),
                            ],
                            stops: const [0.0, 0.45, 1.0],
                          ),
                        ),
                      ),
                      // Rent / Sale badge — top-left
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isForRent
                                ? const Color(0xFF14B8A6)
                                : ColorRes.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isForRent ? 'RENT' : 'SALE',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      // Entity-type badge — bottom-left
                      if (entityType != null)
                        Positioned(
                          bottom: 8,
                          left: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.92),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              entityType!.toUpperCase(),
                              style: TextStyle(
                                color: ColorRes.textPrimary,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                    ],
                  ),
 
                  const SizedBox(width: 14),
 
                  // ── Text content ─────────────────────────────────
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title + favourite
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                entityType == 'project'
                                    ? (projectName ?? 'Project')
                                    : (propertyType ?? 'Property'),
                                style: TextStyle(
                                  color: ColorRes.textPrimary,
                                  fontSize: AppFontSizes.medium,
                                  fontWeight: AppFontWeights.semiBold,
                                  letterSpacing: 0.1,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: onFavoritePressed,
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite
                                    ? ColorRes.error
                                    : ColorRes.primary,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
 
                        const SizedBox(height: 6),
 
                        // Location row
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: ColorRes.textSecondary.withOpacity(0.75),
                              size: 13,
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                city ?? location,
                                style: TextStyle(
                                  color: ColorRes.textSecondary
                                      .withOpacity(0.85),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 1.3,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
 
                        const SizedBox(height: 8),
 
                        // Price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              price,
                              style: TextStyle(
                                color: ColorRes.textPrimary,
                                fontSize: AppFontSizes.bodyMedium,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.4,
                                height: 1,
                              ),
                            ),
                            if (priceType != null && priceType == 'monthly')
                              Padding(
                                padding: const EdgeInsets.only(left: 2),
                                child: Text(
                                  '/mo',
                                  style: TextStyle(
                                    color: ColorRes.textSecondary
                                        .withOpacity(0.8),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    height: 1,
                                  ),
                                ),
                              ),
                          ],
                        ),
 
                        const SizedBox(height: 8),
 
                        // "Xd ago" chip
                        // if (postedDaysAgo != null)
                        //   Container(
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 8, vertical: 4),
                        //     decoration: BoxDecoration(
                        //       color: const Color(0xFFF1F5F9),
                        //       borderRadius: BorderRadius.circular(6),
                        //     ),
                        //     child: Text(
                        //       '${postedDaysAgo}D AGO',
                        //       style: TextStyle(
                        //         color: ColorRes.textSecondary.withOpacity(0.85),
                        //         fontSize: 9,
                        //         fontWeight: FontWeight.w700,
                        //         letterSpacing: 0.4,
                        //       ),
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
 
            // ── Bottom action buttons ──────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                children: [
                  if (ifFeedbackEnable) ...[
                    // Give Feedback — outlined
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: OutlinedButton(
                        onPressed: onFeedbackPressed ?? () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ColorRes.primary,
                          side: BorderSide(color: ColorRes.primary, width: 1.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.feedback_outlined, size: 15),
                            SizedBox(width: 6),
                            Text(
                              'Give Feedback',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
 
                    const SizedBox(height: 8),
 
                  Obx(() {
                    final hasOffer =
                        favoriteController.hasNegotiableOfferMap[propertyId] ??
                            false;
                    final priceStr =
                        favoriteController.negotiableOfferPriceMap[propertyId];
                    num parsed = 0;
                    if (priceStr != null) {
                      parsed =
                          double.tryParse(priceStr) ?? int.tryParse(priceStr) ?? 0;
                    }
                    final offerText = hasOffer && priceStr != null
                        ? '${Formatter.formatPrice(parsed)} (YOUR OFFER)'
                        : 'Ask for Your Negotiable Price';
                    return SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: hasOffer
                            ? () {
                                NesticoPeSnackBar.showAwesomeSnackbar(
                                  title: 'Already Submitted',
                                  message:
                                      'You have already submitted your offer for this property',
                                  contentType: ContentType.warning,
                                );
                              }
                            : () => _openNegotiablePriceDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hasOffer
                              ? const Color(0xFFDCFCE7)
                              : const Color(0xFFF1F5F9),
                          foregroundColor:
                              hasOffer ? Colors.black87 : ColorRes.textSecondary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          offerText,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }),
                  ] else ...[
                    // Contact Agent — full-width solid blue
                    Obx(() {
                      final isInquirySubmitted = favoriteController
                              .hasSubmittedInquiryMap[propertyId] ??
                          false;
 
                      return SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            if (isInquirySubmitted) {
                              NesticoPeSnackBar.showAwesomeSnackbar(
                                title: 'Already Contacted',
                                message:
                                    'You have already contacted for this property',
                                contentType: ContentType.warning,
                              );
                            } else {
                              (onContactPressed ?? () {})();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isInquirySubmitted
                                ? Colors.grey.shade400
                                : ColorRes.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: isInquirySubmitted
                              ? const Text(
                                  'Already Contacted',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.1,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.phone_outlined, size: 16),
                                    SizedBox(width: 8),
                                    Text(
                                      'Contact Agent',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openNegotiablePriceDialog(BuildContext context) async {
    final favoriteController = Get.find<PropertyFavoriteController>();
    final contactedService = PropertyContactedService();
    final propertyService = PropertyService();
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? '';

    final bool isProject = (entityType?.toLowerCase() == 'project');
    double originalPrice = 0;
    double minPrice = 0;
    String listing = listingType?.toLowerCase() ?? 'sell';
    ProjectItem? project;
    List<ProjectVariant> variantOptions = [];
    Map<String, int> variantBhkMap = {};
    ProjectVariant? selectedVariant;

    if (isProject) {
      final builderService = BuilderService();
      project = await builderService.getProjectById(propertyId);
      for (final cfg in project?.configuration ?? []) {
        for (final v in cfg.variants) {
          variantOptions.add(v);
          if (v.variantId != null) {
            variantBhkMap[v.variantId!] = cfg.bhk;
          }
        }
      }
      if (variantOptions.isNotEmpty) {
        selectedVariant = variantOptions.first;
        originalPrice = selectedVariant.price;
        minPrice = (originalPrice * 0.98);
        listing = 'sell';
      }
    } else {
      final Items? prop = await propertyService.getPropertyById(propertyId);
      log("Property Details  for inquiry deatial ${prop?.toJson()}");
      final fetchedListingType = prop?.listingType ?? listingType ?? '';
      final priceManager = PropertyPriceManager(
        listingType: fetchedListingType,
        financialInfo: prop?.propertyDetails?.financialInfo ?? FinancialInfo(),
        pgInfo: prop?.propertyDetails?.pgInfo,
      );
      originalPrice = priceManager.actualPrice;
      listing = fetchedListingType.toLowerCase();
      minPrice = (originalPrice * 0.98);
    }

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final priceCtrl = TextEditingController(
      text: originalPrice > 0 ? originalPrice.toStringAsFixed(0) : '',
    );
    String timePeriod = 'Less than 3 months';
    String visitDate = 'No visit planned';
    String visitTime = 'No time selected';

    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day).add(Duration(days: 3));
    final dateOptions = <String>[
      'No visit planned',
      ...List.generate(
        2,
        (i) => DateFormat('EEEE, d MMMM').format(start.add(Duration(days: i))),
      ),
    ];
    final timeOptions = <String>[
      'No time selected',
      '10:00 AM - 12:00 PM',
      '04:00 PM - 06:00 PM',
    ];
    final planningOptions = <String>[
      'Less than 1 month',
      'Less than 3 months',
      'Less than 6 months',
      'Less than 12 months',
    ];

    Get.dialog(
      Dialog(
        backgroundColor: ColorRes.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 720),
          decoration: BoxDecoration(
            color: ColorRes.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: ColorRes.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Set Your Negotiable Price',
                          style: TextStyle(
                            fontSize: AppFontSizes.body,
                            fontWeight: FontWeight.w600,
                            color: ColorRes.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          
                          timePeriod = 'Less than 3 months';
                          visitDate = 'No visit planned';
                          visitTime = 'No time selected';
                          Get.back();
                        },
                        child: const Icon(Icons.close, color: ColorRes.white),
                      ),
                    ],
                  ),
                ),

                Flexible(
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Property quick header
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CustomImage(
                                  type: CustomImageType.network,
                                  src: imageUrl,
                                  height: 48,
                                  width: 48,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      city ?? location,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      originalPrice > 0
                                          ? 'Original Price: ${Formatter.formatPrice(originalPrice)}'
                                          : 'Original Price: N/A',
                                      style: const TextStyle(
                                        color: ColorRes.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        // if (isProject && variantOptions.isNotEmpty)
                        //   NesticoPeDropdownField<ProjectVariant>(
                        //     title: 'Select Variant',
                        //     value: selectedVariant,
                        //     isRequired: true,
                        //     items: variantOptions
                        //         .map(
                        //           (v) => DropdownMenuItem<ProjectVariant>(
                        //             value: v,
                        //             child: Text(
                        //               '${v.name} • ${Formatter.formatPrice(v.price)}',
                        //             ),
                        //           ),
                        //         )
                        //         .toList(),
                        //     onChanged: (v) {
                        //       if (v != null) {
                        //         selectedVariant = v;
                        //         originalPrice = v.price;
                        //         minPrice = (originalPrice * 0.98);
                        //         priceCtrl.text =
                        //             originalPrice.toStringAsFixed(0);
                        //       }
                        //     },
                        //   ),
                        // const SizedBox(height: 14),
                        if (isProject && variantOptions.isNotEmpty)
                          NesticoPeDropdownField<ProjectVariant>(
                            title: 'Select Variant',
                            value: selectedVariant,
                            isRequired: true,
                            items: variantOptions
                                .map(
                                  (v) => DropdownMenuItem<ProjectVariant>(
                                    value: v,
                                    child: Text(
                                      '${v.name} • ${Formatter.formatPrice(v.price)}',
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              if (v != null) {
                                setState(() {
                                  selectedVariant = v;
                                  originalPrice = v.price;
                                  minPrice = (originalPrice * 0.98);
                                  priceCtrl.text =
                                      originalPrice.toStringAsFixed(0);
                                });
                              }
                            },
                          ),
                        const SizedBox(height: 10),
                        NesticoPeTextField(
                          controller: priceCtrl,
                          title: 'Your Offer Price (₹)',
                          hintText: 'Enter your offer price',
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.currency_rupee,
                          isRequired: true,
                          validator: (v) {
                            final str = (v ?? '').replaceAll(',', '').trim();
                            final val = double.tryParse(str);
                            if (val == null) return 'Enter a valid number';
                            if (originalPrice > 0) {
                              if (val > originalPrice ||
                                  val < minPrice.floorToDouble()) {
                                return 'Enter a price between ₹${NumberFormat.decimalPattern().format(minPrice)} and ₹${NumberFormat.decimalPattern().format(originalPrice)}';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 6),
                        if (originalPrice > 0)
                          Text(
                            'Enter a price between ₹${NumberFormat.decimalPattern().format(minPrice)} and ₹${NumberFormat.decimalPattern().format(originalPrice)}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),
                        const SizedBox(height: 16),
                        NesticoPeDropdownField<String>(
                          title: 'Planning to Buy?',
                          value: timePeriod,
                          isRequired: true,
                          items: planningOptions
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (v) => timePeriod = v ?? timePeriod,
                        ),
                        const SizedBox(height: 16),
                        NesticoPeDropdownField<String>(
                          title: 'Preferred Visit Date (Optional)',
                          value: visitDate,
                          items: dateOptions
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (v) => visitDate = v ?? visitDate,
                        ),
                        const SizedBox(height: 16),
                        NesticoPeDropdownField<String>(
                          title: 'Preferred Visit Time (Optional)',
                          value: visitTime,
                          items: timeOptions
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (v) => visitTime = v ?? visitTime,
                        ),
                      ],
                    ),
                  );
                },
              ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                          
                            timePeriod = 'Less than 3 months';
                            visitDate = 'No visit planned';
                            visitTime = 'No time selected';
                            Get.back();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: ColorRes.primary),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: AppFontSizes.medium,
                                fontWeight: FontWeight.w600,
                                color: ColorRes.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!formKey.currentState!.validate()) return;
                            final entered = priceCtrl.text.replaceAll(',', '').trim();

                            // Find existing inquiry for this property -> this user
                            final inquiries =
                                await contactedService.fetchUserInquiries(
                              userId,
                            );
                            final mine = inquiries.firstWhere(
                              (i) => (i.userId ?? '').toString() == userId,
                              orElse: () => inquiries.isNotEmpty ? inquiries.first : inquiries.firstWhere((_) => false, orElse: () => inquiries.isEmpty ? Inquiry(id: '', propertyId: '', userId: '', name: '', email: '', phone: '', inquiredAt: DateTime.now(), status: '', isConvertedToLead: false, createdAt: DateTime.now(), updatedAt: DateTime.now(), entityType: '', details: null) : inquiries.first),
                            );

                            bool success = false;
                            if ((mine.id).isNotEmpty) {
                              success = await contactedService.updateInquiryNegotiable(
                                inquiryId: mine.id,
                                propertyId: propertyId,
                                meta: {
                                  "isNegotiable": true,
                                  "negotiablePrice": entered,
                                  "timePeriod": timePeriod,
                                  "visitDate": visitDate == 'No visit planned' ? null : visitDate,
                                  "visitTime": visitTime == 'No time selected' ? null : visitTime,
                                  "inquiryType": listing,
                                  if (isProject && selectedVariant != null)
                                    "selectedVariant": {
                                      "id": selectedVariant!.variantId ?? '',
                                      "name": selectedVariant!.name,
                                      "bhk": selectedVariant!.variantId != null
                                          ? (variantBhkMap[selectedVariant!.variantId!] ?? 0)
                                          : 0,
                                      "price": selectedVariant!.price,
                                    },
                                },
                              );
                            } else {
                              // Fallback: create new inquiry with negotiable meta
                              final inquiry = {
                                "name": user?.user?.username ?? "",
                                "phone": user?.user?.phone ?? "",
                                "email": user?.user?.email ?? "",
                                "agreeToContact": true,
                                "meta": {
                                  "isNegotiable": true,
                                  "negotiablePrice": entered,
                                  "timePeriod": timePeriod,
                                  "visitDate": visitDate == 'No visit planned' ? null : visitDate,
                                  "visitTime": visitTime == 'No time selected' ? null : visitTime,
                                  "inquiryType": listing,
                                  if (isProject && selectedVariant != null)
                                    "selectedVariant": {
                                      "id": selectedVariant!.variantId ?? '',
                                      "name": selectedVariant!.name,
                                      "bhk": selectedVariant!.variantId != null
                                          ? (variantBhkMap[selectedVariant!.variantId!] ?? 0)
                                          : 0,
                                      "price": selectedVariant!.price,
                                    },
                                },
                              };
                              success = await contactedService.addInquiry(inquiry, propertyId);
                            }

                            if (success) {
                          
                              await favoriteController.loadNegotiableMetaForProperty(propertyId);
                              NesticoPeSnackBar.showAwesomeSnackbar(
                                title: 'Success',
                                message: 'Offer submitted successfully',
                                contentType: ContentType.success,
                              );
                              Get.back();
                            } else {
                              NesticoPeSnackBar.showAwesomeSnackbar(
                                title: 'Error',
                                message: 'Failed to submit offer',
                                contentType: ContentType.failure,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorRes.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Submit Offer'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return ColorRes.success;
      case 'upcoming':
        return const Color(0xFFF59E0B);
      case 'ongoing':
        return const Color(0xFF3B82F6);
      case 'completed':
        return const Color(0xFF10B981);
      default:
        return ColorRes.textSecondary;
    }
  }
}
