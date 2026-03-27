import 'package:flutter/material.dart';

import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/modules/property_rating/view/widget/rating_star.dart';
import 'package:nesticope_app/modules/search_property/view/search_screen.dart';

class RatingWidget extends StatelessWidget {
  final Map<int, int> ratingCounts;
  final double averageRating;

  const RatingWidget({
    super.key,
    required this.ratingCounts,
    required this.averageRating,
  });

  @override
  Widget build(BuildContext context) {
    int total = ratingCounts.values.fold(0, (a, b) => a + b);
    print('total ${ratingCounts.values.fold(0, (a, b) => a + b)}');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Side
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) {
                      int star = 5 - index; // reverse order
                      double percent =
                          total == 0 ? 0 : ratingCounts[star]! / total;
                      return Row(
                        children: [
                          buildCommonText(
                            '$star',
                            AppFontSizes.caption,
                            AppFontWeights.medium,
                            ColorRes.textPrimary,
                            1,
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 100,
                            child: LinearProgressIndicator(
                              borderRadius: BorderRadius.circular(15),
                              value: percent,
                              backgroundColor: ColorRes.leadGreyColor[300],
                              color: ColorRes.primary,
                              minHeight: 4,
                            ),
                          ),
                          const SizedBox(width: 8),
                          buildCommonText(
                            '${ratingCounts[star]}',
                            AppFontSizes.caption,
                            AppFontWeights.medium,
                            ColorRes.textPrimary,
                            1,
                          ),
                        ],
                      );
                    }),
                  ),
                ),

                // Vertical Divider inside SizedBox
                SizedBox(
                  height: 80,
                  child: VerticalDivider(
                    width: 1,
                    thickness: 0.5,
                    color: ColorRes.leadGreyColor.shade300,
                  ),
                ),

                // Right Side
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildCommonText(
                        averageRating.toStringAsFixed(1),
                        AppFontSizes.heading,
                        AppFontWeights.semiBold,
                        ColorRes.textPrimary,
                        1,
                      ),

                      const RatingStars(value: 3.25, fillColor: ColorRes.primary),
                      const SizedBox(height: 5),
                      buildCommonText(
                        '($total) Ratings',
                        AppFontSizes.extraSmall,
                        AppFontWeights.regular,
                        ColorRes.leadGreyColor.shade600,
                        1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
