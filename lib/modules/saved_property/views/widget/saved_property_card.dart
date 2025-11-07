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
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart';

class SavedPropertyCard extends StatelessWidget {
  final String imageUrl;
  final bool isForRent;
  final String location;
  final String price;
  final bool isFavorite;
  final VoidCallback? onContactPressed;
  final VoidCallback? onFavoritePressed;

  const SavedPropertyCard({
    super.key,
    required this.imageUrl,
    required this.isForRent,
    required this.location,
    required this.price,
    this.isFavorite = false,
    this.onContactPressed,
    this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image Section with Badge and Favorite
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: CustomImage(
                  type: CustomImageType.network,
                  src: imageUrl,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              // Gradient overlay for better text readability
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.1), Colors.transparent],
                    stops: const [0.0, 0.3],
                  ),
                ),
              ),
              // Rent/Sell Badge
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          isForRent
                              ? [
                                const Color(0xFF14B8A6),
                                const Color(0xFF0D9488),
                              ]
                              : [ColorRes.primary, const Color(0xFF3B5FC7)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: (isForRent
                                ? const Color(0xFF14B8A6)
                                : ColorRes.primary)
                            .withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isForRent ? Icons.key : Icons.sell,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isForRent ? 'For Rent' : 'For Sale',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Favorite Button
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: onFavoritePressed,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color:
                          isFavorite ? ColorRes.error : const Color(0xFF9CA3AF),
                      size: 22,
                    ),
                  ),
                ),
              ),

              // Zoom Button (bottom right of image)
            ],
          ),
          // Content Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: ColorRes.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: ColorRes.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.1,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        height: 1.2,
                      ),
                    ),
                    if (isForRent)
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 3),
                        child: Text(
                          '/month',
                          style: TextStyle(
                            color: const Color(0xFF6B7280),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                // Contact Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: onContactPressed ?? () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorRes.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.phone, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Contact Agent',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
