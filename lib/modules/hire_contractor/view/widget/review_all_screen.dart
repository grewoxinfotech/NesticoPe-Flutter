import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/app/widgets/texts/headline_text.dart';
import 'package:nesticope_app/data/network/platform_review/model/platform_review_model.dart';
import 'package:nesticope_app/modules/home/controllers/home_controller/platform_review-controller.dart';
import 'package:nesticope_app/modules/home/views/home_screen/home_screen.dart';
import 'package:nesticope_app/modules/property_rating/view/widget/read_more_or_less.dart';

class ReviewAllScreenData extends StatefulWidget {
  const ReviewAllScreenData({super.key});

  @override
  State<ReviewAllScreenData> createState() => _ReviewAllScreenDataState();
}

class _ReviewAllScreenDataState extends State<ReviewAllScreenData> {
  late final PlatformReviewController reviewController;

  @override
  void initState() {
    super.initState();
    // Register if not already registered, reuse if it exists
    reviewController =
        Get.isRegistered<PlatformReviewController>(
              tag: 'hire_contractor_reviews',
            )
            ? Get.find<PlatformReviewController>(tag: 'hire_contractor_reviews')
            : Get.put(
              PlatformReviewController(
                type: ['site', 'seller', 'reseller', 'contractor'],
                filters: {'status': 'published'},
              ),
              tag: 'hire_contractor_reviews',
            );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Review Screen',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
      ),
      body: Obx(() {
        if (reviewController.isLoading.value &&
            reviewController.allReviews.isEmpty) {
          return const ReviewsTestimonialsShimmer();
        }

        if (reviewController.allReviews.isEmpty) {
          return const SizedBox.shrink();
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12),
              ReviewsVerticalAndTestimonials(
                reviewController: reviewController,
              ),
              SizedBox(height: AppSpacing.medium),
            ],
          ),
        );
      }),
    );
  }
}

class ReviewsVerticalAndTestimonials extends StatelessWidget {
  final PlatformReviewController reviewController; // ← a
  const ReviewsVerticalAndTestimonials({
    super.key,
    required this.reviewController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          // Show loading indicator
          if (reviewController.isLoading.value &&
              reviewController.allReviews.isEmpty) {
            return SizedBox(
              height: 250,
              child: Center(
                child: CircularProgressIndicator(color: ColorRes.homeGreenFade),
              ),
            );
          }

          // Show empty state
          if (reviewController.allReviews.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.rate_review_outlined,
                    size: 48,
                    color: ColorRes.leadGreyColor.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No reviews available',
                    style: TextStyle(
                      fontSize: AppFontSizes.body,
                      color: ColorRes.leadGreyColor.shade600,
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                ],
              ),
            );
          }

          // Show reviews list
          // Show reviews list  ← inside the Obx, replace ListView with:
          return ListView.separated(
            shrinkWrap: true, // ← add this
            physics: const NeverScrollableScrollPhysics(), // ← add this
            itemCount: reviewController.allReviews.length,
            clipBehavior: Clip.none,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            separatorBuilder:
                (_, __) => const SizedBox(height: AppSpacing.medium),
            itemBuilder: (context, index) {
              return _buildVerticalReviewCard(
                context,
                reviewController.allReviews[index],
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildVerticalReviewCard(BuildContext context, ReviewItem review) {
    final rating = review.rating ?? 0.0;
    final isVerified = review.isVerified ?? false;

    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
          // border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 2,

              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header with avatar and rating
              Row(
                children: [
                  /// Avatar (placeholder since we don't have reviewer details)
                 Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          ColorRes.homeGreenFade.withOpacity(0.08),
                          ColorRes.homeGreenDarkFade.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: Color(0xFF2E7D63).withOpacity(0.25),
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: (() {
                      final user = review.reviewer;
                      final profilePic = user?.profilePic?.trim() ?? '';
                      final username = user?.username?.trim() ?? '';
                      final initial =
                          username.isNotEmpty ? username[0].toUpperCase() : '?';

                      if (profilePic.isNotEmpty) {
                        return ClipOval(
                          child: Image.network(
                            profilePic,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Text(
                              initial,
                              style: TextStyle(
                                fontSize: AppFontSizes.large,
                                fontWeight: AppFontWeights.semiBold,
                                color: ColorRes.homeGreenDarkFade,
                              ),
                            ),
                          ),
                        );
                      }

                      return Text(
                        initial,
                        style: TextStyle(
                          fontSize: AppFontSizes.large,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.homeGreenDarkFade,
                        ),
                      );
                    })(),
                  ),

                  const SizedBox(width: 12),

                  /// Reviewer ID and status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${review.reviewer?.username?.replaceAll("_", " ").capitalize}',
                                      maxLines: 1,

                                      style: TextStyle(
                                        fontSize: AppFontSizes.medium,
                                        fontWeight: AppFontWeights.semiBold,
                                        color: ColorRes.homeBlackFade,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    _formatDate(review.createdAt?.toIso8601String()),
                                    style: TextStyle(
                                      fontSize: AppFontSizes.extraSmall,
                                      fontWeight: AppFontWeights.medium,
                                      color: ColorRes.leadGreyColor.shade600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            if (isVerified) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: ColorRes.homeGreenDarkFade,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: ColorRes.white,
                                  size: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          '${review.reviewer?.userType?.replaceAll("_", " ").capitalize??''}',
                          maxLines: 1,

                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            fontWeight: AppFontWeights.medium,
                            color: ColorRes.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ...List.generate(5, (starIndex) {
                              if (starIndex < rating.floor()) {
                                return const Icon(
                                  Icons.star,
                                  color: ColorRes.homeYellow,
                                  size: 16,
                                );
                              } else if (starIndex < rating) {
                                return const Icon(
                                  Icons.star_half,
                                  color: ColorRes.homeYellow,
                                  size: 16,
                                );
                              } else {
                                return Icon(
                                  Icons.star_outline,
                                  color: ColorRes.leadGreyColor.shade300,
                                  size: 16,
                                );
                              }
                            }),
                            const SizedBox(width: 8),
                            Text(
                              rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: AppFontSizes.small,
                                fontWeight: AppFontWeights.semiBold,
                                color: ColorRes.homeBlackFade,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (review.title != null && review.title!.isNotEmpty) ...[
                Text(
                  review.title!,
                  style: TextStyle(
                    fontSize: AppFontSizes.bodySmall,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.homeBlackFade,
                  ),
                
                ),
              ],
              const SizedBox(height: 8),
              // SizedBox(
              //   width: 280,
              //   child: Text(
              //     '"${review.content ?? 'No review content'}"',
              //     style: TextStyle(
              //       fontSize: AppFontSizes.caption,
              //       color: ColorRes.leadGreyColor.shade700,
              //       height: 1.5,
              //     ),
              //     maxLines: 2,
              //     overflow: TextOverflow.ellipsis,
              //   ),
              // ),
              ReadMoreClass(
                description: review.content ?? 'N/A',
                trimLines: 3,
                size: AppFontSizes.caption,
                colorClickableText: ColorRes.primary,
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to get status color

  /// Helper method to get status icon 

  /// Helper method to format date
  String _formatDate(String? dateString) {
    if (dateString == null) return 'Recently';

    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return '$months ${months == 1 ? 'month' : 'months'} ago';
      } else {
        final years = (difference.inDays / 365).floor();
        return '$years ${years == 1 ? 'year' : 'years'} ago';
      }
    } catch (e) {
      return 'Recently';
    }
  }

  /// Show review details in a bottom sheet
}
