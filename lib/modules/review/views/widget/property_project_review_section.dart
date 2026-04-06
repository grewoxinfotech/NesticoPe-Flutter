// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../../app/constants/color_res.dart';
// import '../../../../app/utils/helper_function/user_helper/user_helper.dart';
// import '../../../../app/widgets/texts/headline_text.dart';
// import '../../../../data/network/overall_rating/model/overall_rating_model.dart';
// import '../../../../widgets/button/button.dart';
// import '../../../auth/views/login_screen.dart';
// import '../../../property/controllers/overall_rating_controller.dart';
// import '../../controllers/review_controller.dart';
// import 'add_property_review.dart';
// import 'all_review_screen.dart';

// class ReviewSection extends StatelessWidget {
//   final RxBool canAddReview;
//   final OverallRatingController overallController;
//   final ReviewController reviewController;

//   final String entityType;
//   final String entityId;

//   final Widget Function(BuildContext, dynamic reviewItem) reviewCardBuilder;
//   final Widget Function(
//     int totalReviews,
//     double rating,
//     DetailedRatings details,
//   )
//   overallWidgetBuilder;

//   const ReviewSection({
//     super.key,
//     required this.canAddReview,
//     required this.overallController,
//     required this.reviewController,
//     required this.entityType,
//     required this.entityId,
//     required this.reviewCardBuilder,
//     required this.overallWidgetBuilder,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Obx(() {
//           final overallCtrl = overallController;
//           final reviewCtrl = reviewController;

//           final isOverallLoading =
//               overallCtrl.isLoading.value &&
//               overallCtrl.ratingData.value == null;
//           final isReviewLoading =
//               reviewCtrl.isLoading.value && reviewCtrl.items.isEmpty;

//           // Loader for both
//           if (isOverallLoading && isReviewLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           // Hide if both empty & done loading
//           if (!overallCtrl.isLoading.value &&
//               !reviewCtrl.isLoading.value &&
//               (overallCtrl.ratingData.value == null ||
//                   overallCtrl.ratingData.value?.data?.totalReviews == 0) &&
//               reviewCtrl.items.isEmpty) {
//             return const SizedBox.shrink();
//           }

//           // Extract
//           final overallData = overallCtrl.ratingData.value?.data;
//           final totalReviews = overallData?.totalReviews ?? 0;
//           final overallRating = overallData?.overallRating ?? 0.0;
//           final detailedRatings =
//               overallData?.detailedRatings ??
//               DetailedRatings(
//                 nightlifeRating: 0,
//                 amenities: 0,
//                 cleanliness: 0,
//                 location: 0,
//                 value: 0,
//               );

//           return Container(
//             padding: const EdgeInsets.symmetric(vertical: 12),
            
//           color: ColorRes.leadGreyColor.shade100,

             
          
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Divider(
//                 //   indent: 18,
//                 //   endIndent: 18,
//                 //   color: ColorRes.leadGreyColor.shade300,
//                 // ),
//                 const SizedBox(height: 12),
            
//                 TitleWithViewAll(
//                   title: "Reviews & Ratings",
//                   showViewAll: true,
//                   icon: Icons.star_rate,
//                   iconColor: ColorRes.primary,
//                   iconBgColor: ColorRes.white,
//                   showIcon: true,
//                   onViewAll: () {
//                     Get.to(() => AllReviewScreen(reviewController: reviewCtrl));
//                   },
//                 ),
            
//                 const SizedBox(height: 12),
            
//                 // ⭐ Overall Rating (reusable)
//                 overallWidgetBuilder(
//                   totalReviews,
//                   overallRating,
//                   detailedRatings,
//                 ),
            
//                 const SizedBox(height: 12),
            
//                 // 📋 Review List (reusable)
//                 if (reviewCtrl.items.isNotEmpty)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: reviewCardBuilder(
//                       context,
//                       reviewCtrl.items.first, // 👈 show only the first review
//                     ),
//                   )
//                 // ) SizedBox(
//                 //   height: 580,
//                 //   child: ListView.separated(
//                 //     scrollDirection: Axis.horizontal,
//                 //     padding: const EdgeInsets.symmetric(horizontal: 16),
//                 //     itemCount: reviewCtrl.items.length,
//                 //     separatorBuilder: (_, __) => const SizedBox(width: 16),
//                 //     itemBuilder: (context, index) {
//                 //       return reviewCardBuilder(
//                 //         context,
//                 //         reviewCtrl.items[index],
//                 //       );
//                 //     },
//                 //   ),
//                 // )
//                 else if (!reviewCtrl.isLoading.value && totalReviews == 0)
//                   const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     child: Text(
//                       "No reviews yet",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//               ],
//             ),
//           );
//         }),

//         // ➕ Add Review Button
//         Obx(() {
//           if (!canAddReview.value) return const SizedBox.shrink();

//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: NesticoPeButton(
//               width: double.infinity,
//               boxShadow: [],
//               title: "Add Review",
//               onTap: () async {
//                 if (UserHelper.isGuest) {
//                   Get.to(() => LoginScreen());
//                   return;
//                 }

//                 final result = await Get.to(
//                   () => AddReviewScreen(
//                     entityType: entityType,
//                     entityId: entityId,
//                   ),
//                 );

//                 if (result == true) {
//                   canAddReview.value = false;
//                   reviewController.refreshList();
//                   overallController.fetchOverallRating(entityId);
//                 }
//               },
//             ),
//           );
//         }),

//         // const SizedBox(height: 12),
//       ],
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/constants/color_res.dart';
import '../../../../app/utils/helper_function/user_helper/user_helper.dart';
import '../../../../app/widgets/texts/headline_text.dart';
import '../../../../data/network/overall_rating/model/overall_rating_model.dart';
import '../../../../widgets/button/button.dart';
import '../../../auth/views/login_screen.dart';
import '../../../property/controllers/overall_rating_controller.dart';
import '../../controllers/review_controller.dart';
import 'add_property_review.dart';
import 'all_review_screen.dart';

class ReviewSection extends StatelessWidget {
  final RxBool canAddReview;
  final OverallRatingController overallController;
  final ReviewController reviewController;

  final String entityType;
  final String entityId;

  final Widget Function(BuildContext, dynamic reviewItem) reviewCardBuilder;
  final Widget Function(
    int totalReviews,
    double rating,
    DetailedRatings details,
  )
  overallWidgetBuilder;

  const ReviewSection({
    super.key,
    required this.canAddReview,
    required this.overallController,
    required this.reviewController,
    required this.entityType,
    required this.entityId,
    required this.reviewCardBuilder,
    required this.overallWidgetBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          final overallCtrl = overallController;
          final reviewCtrl = reviewController;

          final isOverallLoading =
              overallCtrl.isLoading.value &&
              overallCtrl.ratingData.value == null;
          final isReviewLoading =
              reviewCtrl.isLoading.value && reviewCtrl.items.isEmpty;

          // Loader for both
          if (isOverallLoading && isReviewLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Hide if both empty & done loading
          if (!overallCtrl.isLoading.value &&
              !reviewCtrl.isLoading.value &&
              (overallCtrl.ratingData.value == null ||
                  overallCtrl.ratingData.value?.data?.totalReviews == 0) &&
              reviewCtrl.items.isEmpty) {
            return const SizedBox.shrink();
          }

          // Extract
          final overallData = overallCtrl.ratingData.value?.data;
          final totalReviews = overallData?.totalReviews ?? 0;
          final overallRating = overallData?.overallRating ?? 0.0;
          final detailedRatings =
              overallData?.detailedRatings ??
              DetailedRatings(
                nightlifeRating: 0,
                amenities: 0,
                cleanliness: 0,
                location: 0,
                value: 0,
              );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                indent: 18,
                endIndent: 18,
                color: ColorRes.leadGreyColor.shade300,
              ),
              const SizedBox(height: 12),

              TitleWithViewAll(
                title: "Reviews & Ratings",
                showViewAll: true,
                onViewAll: () {
                  Get.to(() => AllReviewScreen(reviewController: reviewCtrl));
                },
              ),

              const SizedBox(height: 12),

              // ⭐ Overall Rating (reusable)
              overallWidgetBuilder(
                totalReviews,
                overallRating,
                detailedRatings,
              ),

              const SizedBox(height: 12),

              // 📋 Review List (reusable)
              if (reviewCtrl.items.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: reviewCardBuilder(
                    context,
                    reviewCtrl.items.first, // 👈 show only the first review
                  ),
                )
              // ) SizedBox(
              //   height: 580,
              //   child: ListView.separated(
              //     scrollDirection: Axis.horizontal,
              //     padding: const EdgeInsets.symmetric(horizontal: 16),
              //     itemCount: reviewCtrl.items.length,
              //     separatorBuilder: (_, __) => const SizedBox(width: 16),
              //     itemBuilder: (context, index) {
              //       return reviewCardBuilder(
              //         context,
              //         reviewCtrl.items[index],
              //       );
              //     },
              //   ),
              // )
              else if (!reviewCtrl.isLoading.value && totalReviews == 0)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "No reviews yet",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
            ],
          );
        }),

        // ➕ Add Review Button
        Obx(() {
          if (!canAddReview.value) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: NesticoPeButton(
              width: double.infinity,
              boxShadow: [],
              title: "Add Review",
              onTap: () async {
                if (UserHelper.isGuest) {
                  Get.to(() => LoginScreen());
                  return;
                }

                final result = await Get.to(
                  () => AddReviewScreen(
                    entityType: entityType,
                    entityId: entityId,
                  ),
                );

                if (result == true) {
                  canAddReview.value = false;
                  reviewController.refreshList();
                  overallController.fetchOverallRating(entityId);
                }
              },
            ),
          );
        }),

        const SizedBox(height: 12),
      ],
    );
  }
}
