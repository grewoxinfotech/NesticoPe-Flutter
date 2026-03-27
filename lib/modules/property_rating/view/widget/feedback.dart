import 'package:flutter/material.dart';

import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/modules/property_rating/view/widget/rating_star.dart';
import 'package:nesticope_app/modules/property_rating/view/widget/read_more_or_less.dart';
import 'package:nesticope_app/modules/search_property/view/search_screen.dart';

import '../../../../app/constants/app_font_sizes.dart';

class FeedbackCard extends StatelessWidget {
  final String userName;
  final String feedback;
  final double rating;
  final String date;
  final String profileUrl;

  const FeedbackCard({
    super.key,
    required this.userName,
    required this.feedback,
    required this.rating,
    required this.date,
    required this.profileUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        // margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row -> Profile + User Info + Date
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Image
                CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(profileUrl),
                ),
                const SizedBox(width: 12),

                // Username + Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          buildCommonText(
                            userName,
                            AppFontSizes.medium,
                            AppFontWeights.semiBold,
                            ColorRes.textPrimary,
                            1,
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.verified,
                            color: ColorRes.primary,
                            size: 15,
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.more_vert_outlined,
                            color: ColorRes.textPrimary,
                            size: 20,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          RatingStars(
                            value: rating,
                            fillColor: ColorRes.primary,
                            size: 14,
                          ),

                          const SizedBox(width: 5),

                          buildCommonText(
                            date,
                            AppFontSizes.extraSmall,
                            AppFontWeights.regular,
                            ColorRes.leadGreyColor,
                            1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Rating (Stars)
            const SizedBox(height: 8),

            ReadMoreClass(
              description: feedback,
              size: AppFontSizes.small,
              trimLines: 3,
              colorClickableText: ColorRes.primary,
            ),
          ],
        ),
      ),
    );
  }
}
