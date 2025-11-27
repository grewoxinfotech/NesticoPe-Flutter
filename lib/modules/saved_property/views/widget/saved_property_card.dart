// import 'package:flutter/material.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/widgets/image/custom_image.dart';
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

import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart';

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
//                         color: ColorRes.story,
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
//         return ColorRes.story;
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
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 140,
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorRes.border.withOpacity(0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: CustomImage(
                    type: CustomImageType.network,
                    src: imageUrl,
                    fit: BoxFit.cover,
                    height: 140,
                    width: 140,
                  ),
                ),
                // Gradient overlay
                Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                      stops: const [0.0, 0.4, 1.0],
                    ),
                  ),
                ),
                // Rent/Sell Badge
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isForRent
                              ? const Color(0xFF14B8A6)
                              : ColorRes.primary,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isForRent ? Icons.key : Icons.sell_outlined,
                          color: Colors.white,
                          size: 11,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isForRent ? 'Rent' : 'Sale',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Verified Badge
                if (isVerified == true)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: ColorRes.success,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.verified,
                        color: Colors.white,
                        size: 11,
                      ),
                    ),
                  ),
                // Property Type Badge
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      entityType ?? '',
                      style: const TextStyle(
                        color: ColorRes.textPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.1,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            // Content Section
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Row(
                      children: [
                        // Entity Type Badge
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
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Status Badge

                        // Favorite Button
                        GestureDetector(
                          onTap: onFavoritePressed,
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color:
                                isFavorite
                                    ? ColorRes.error
                                    : ColorRes.textSecondary,
                            size: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Project Name (for projects)
                    // Location Row
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: ColorRes.textSecondary.withOpacity(0.8),
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            city ?? location,
                            style: TextStyle(
                              color: ColorRes.textSecondary.withOpacity(0.9),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        if (postedDaysAgo != null) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: ColorRes.background.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${postedDaysAgo}d ago',
                              style: TextStyle(
                                color: ColorRes.textSecondary.withOpacity(0.8),
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
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
                                color: ColorRes.textSecondary.withOpacity(0.8),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                height: 1,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    // Contact Button
                    if (ifFeedbackEnable) ...[
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: OutlinedButton(
                          onPressed: onFeedbackPressed ?? () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: ColorRes.primary,
                            side: BorderSide(
                              color: ColorRes.primary,
                              width: 1.2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.feedback_outlined, size: 14),
                              SizedBox(width: 6),
                              Text(
                                'Give Feedback',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                    ] else ...[
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: ElevatedButton(
                          onPressed: onContactPressed ?? () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorRes.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.phone_outlined, size: 14),
                              SizedBox(width: 6),
                              Text(
                                'Contact Agent',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
            ),
          ],
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
