import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/data/network/review/model/review_model.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/size_manager.dart';

class AppReviewCard extends StatelessWidget {
  final ReviewItem review;

  const AppReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.medium),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ⭐ Rating Row + Verified Badge
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < (review.rating ?? review.rating ?? 0)
                        ? Icons.star
                        : Icons.star_border,
                    color: ColorRes.homeAmber.withOpacity(0.9),
                    size: 20,
                  );
                }),
              ),

              const SizedBox(width: 10),

              if (review.isVerified == true)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: ColorRes.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.verified, size: 14, color: ColorRes.primary),
                      const SizedBox(width: 4),
                      Text(
                        "Verified",
                        style: TextStyle(
                          fontSize: AppFontSizes.small,
                          fontWeight: AppFontWeights.medium,
                          color: ColorRes.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              Spacer(),
              Text(
                review.status?.toUpperCase() ?? "",
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  color:
                      review.status == "published"
                          ? Colors.green
                          : ColorRes.error,
                  fontWeight: AppFontWeights.medium,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// 📝 Title
          Text(
            review.title ?? "",
            style: TextStyle(
              fontSize: AppFontSizes.bodyMedium,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),

          const SizedBox(height: 6),

          /// 📄 Content / Description
          Text(
            review.content ?? "",
            style: TextStyle(
              fontSize: AppFontSizes.bodySmall,
              color: ColorRes.textSecondary,
              height: 1.35,
            ),
          ),

          // const SizedBox(height: 12),
          //
          // Row(
          //   children: [
          //     Icon(Icons.person, size: 18, color: ColorRes.leadGreyColor),
          //     const SizedBox(width: 6),
          //     Text(
          //       review.reviewerId ?? "Unknown User",
          //       style: TextStyle(
          //         fontSize: AppFontSizes.small,
          //         color: ColorRes.leadGreyColor,
          //       ),
          //     ),
          //     const Spacer(),
          //     Text(
          //       review.status?.toUpperCase() ?? "",
          //       style: TextStyle(
          //         fontSize: AppFontSizes.small,
          //         color:
          //             review.status == "published"
          //                 ? Colors.green
          //                 : ColorRes.error,
          //         fontWeight: AppFontWeights.medium,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
