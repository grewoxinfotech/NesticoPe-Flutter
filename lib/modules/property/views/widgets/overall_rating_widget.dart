// import 'package:flutter/material.dart';
// import 'package:nesticope_app/app/constants/app_font_sizes.dart';
// import 'package:nesticope_app/app/constants/color_res.dart';
//
// import '../../../../data/network/overall_rating/model/overall_rating_model.dart';
//
// class OverallRatingWidget extends StatelessWidget {
//   final int totalReviews;
//   final double overallRating;
//   final DetailedRatings detailedRatings;
//
//   const OverallRatingWidget({
//     super.key,
//     required this.totalReviews,
//     required this.overallRating,
//     required this.detailedRatings,
//   });
//
//   Widget _buildRatingBar(String label, double value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontSize: AppFontSizes.caption,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 6,
//             child: LinearProgressIndicator(
//               value: value / 5,
//               backgroundColor: Colors.grey.shade200,
//               color: ColorRes.primary,
//               minHeight: 6,
//               borderRadius: BorderRadius.circular(6),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             value.toStringAsFixed(1),
//             style: const TextStyle(fontSize: 13, color: Colors.black54),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 1,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ⭐ Overall rating section
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   overallRating.toStringAsFixed(1),
//                   style: const TextStyle(
//                     fontSize: 26,
//                     fontWeight: FontWeight.bold,
//                     color: ColorRes.textPrimary,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Row(
//                   children: List.generate(5, (index) {
//                     final starIndex = index + 1;
//                     if (overallRating >= starIndex) {
//                       return const Icon(
//                         Icons.star,
//                         color: ColorRes.warning,
//                         size: 22,
//                       );
//                     } else if (overallRating >= starIndex - 0.5) {
//                       return const Icon(
//                         Icons.star_half,
//                         color: ColorRes.warning,
//
//                         size: 22,
//                       );
//                     } else {
//                       return const Icon(
//                         Icons.star_border,
//                         color: ColorRes.warning,
//
//                         size: 22,
//                       );
//                     }
//                   }),
//                 ),
//                 const Spacer(),
//                 Text(
//                   "$totalReviews Reviews",
//                   style: const TextStyle(fontSize: 14, color: Colors.black54),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//
//             // 🧮 Detailed ratings
//             _buildRatingBar("Location", detailedRatings.location),
//             _buildRatingBar("Cleanliness", detailedRatings.cleanliness),
//             _buildRatingBar("nightlife", detailedRatings.nightlifeRating),
//             _buildRatingBar("Value", detailedRatings.value),
//             _buildRatingBar("Amenities", detailedRatings.amenities),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import '../../../../data/network/overall_rating/model/overall_rating_model.dart';

class OverallRatingWidget extends StatelessWidget {
  final int totalReviews;
  final double overallRating;
  final DetailedRatings detailedRatings;

  const OverallRatingWidget({
    super.key,
    required this.totalReviews,
    required this.overallRating,
    required this.detailedRatings,
  });

  Widget _buildRatingBar(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: AppFontSizes.caption,
                color: ColorRes.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value / 5,
                backgroundColor: Colors.grey.shade200,
                color: ColorRes.primary,
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "${(value / 5 * 100).toStringAsFixed(0)}%",
            style: const TextStyle(
              fontSize: AppFontSizes.caption,
              color: ColorRes.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 2,

            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ⭐ Overall rating section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating value
                Text(
                  overallRating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: AppFontSizes.displayMediumSmall,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                ),
                const SizedBox(width: 10),

                // Stars and review count
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        if (overallRating >= starIndex) {
                          return const Icon(
                            Icons.star,
                            color: ColorRes.warning,
                            size: 22,
                          );
                        } else if (overallRating >= starIndex - 0.5) {
                          return const Icon(
                            Icons.star_half,
                            color: ColorRes.warning,
                            size: 22,
                          );
                        } else {
                          return const Icon(
                            Icons.star_border,
                            color: ColorRes.warning,
                            size: 22,
                          );
                        }
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$totalReviews reviews",
                      style: const TextStyle(
                        fontSize: AppFontSizes.small,
                        color: ColorRes.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(width: 16),

            // 🧮 Detailed ratings breakdown
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    _buildRatingBar("5", detailedRatings.location),
                    _buildRatingBar("4", detailedRatings.cleanliness),
                    _buildRatingBar("3", detailedRatings.nightlifeRating),
                    _buildRatingBar("2", detailedRatings.value),
                    _buildRatingBar("1", detailedRatings.amenities),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
