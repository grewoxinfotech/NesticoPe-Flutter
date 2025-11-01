
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/review/model/review_model.dart';
import 'package:housing_flutter_app/widgets/button/button.dart';
import 'package:housing_flutter_app/widgets/New folder/inputs/text_field.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/constants/size_manager.dart';
import '../../controllers/review_controller.dart';

class AddReviewScreen extends StatelessWidget {
  final String entityType;
  final String entityId;

  AddReviewScreen({
    required this.entityType,
    required this.entityId,
    super.key,
  });

  final ReviewController controller = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,

      appBar: AppBar(title: Text('Add Review')),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title
         Container(
           padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
           decoration: BoxDecoration(
             color: ColorRes.white,
             borderRadius: BorderRadius.circular(12),
             border: Border.all(color: ColorRes.leadGreyColor.shade300,width: 1)
           ),
           child: Column(
             children: [
               NesticoPeTextField(
                 isRequired: true,
                 autovalidateMode: AutovalidateMode.onUserInteraction,
                 controller: controller.titleController,
                 title: 'Review Title',
                 hintText: 'Summarize your experience',

                 validator:
                     (v) => (v == null || v.isEmpty) ? 'Enter a title' : null,
               ),
               const SizedBox(height: 13),

               // Content
               NesticoPeTextField(
                 // isRequired: true,
                 autovalidateMode: AutovalidateMode.onUserInteraction,
                 controller: controller.contentController,
                 title: 'Your Review (Optional)',
                 hintText: 'Share your detailed experience...',
                 maxLines: 4,
                 validator: (v) {
                   if (v == null || v.isEmpty) return 'Enter your review';
                   if (v.length < 20)
                     return 'Review must be at least 20 characters';
                   return null;
                 },
               ),
             ],
           ),
         ),
            const SizedBox(height: 20),

            // Overall Rating
            Obx(
              () => _buildRatingSection(
                title: 'Overall Rating',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                rating: controller.overallRating.value,
                onRatingChanged: (rating) {
                  controller.overallRating.value = rating;
                },
                isRequired: true,
              ),
            ),

            const SizedBox(height: 16),
            // Divider(height: 32, color: ColorRes.leadGreyColor.shade300),

            // Detailed Ratings Header
            Text(
              'Detailed Ratings',
              style: TextStyle(
                fontSize: AppFontSizes.headingTitle,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
            decoration: BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorRes.leadGreyColor.shade300,width: 1)
            ),
            child: Column(
              children: [
                // Location Rating
                Obx(
                      () => _buildRatingSectionWithoutContainer(
                    title: 'Location',

                    rating: controller.locationRating.value,
                    onRatingChanged: (rating) {
                      controller.locationRating.value = rating;
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // Cleanliness Rating
                Obx(
                      () => _buildRatingSectionWithoutContainer(
                    title: 'Cleanliness',

                    rating: controller.cleanlinessRating.value,
                    onRatingChanged: (rating) {
                      controller.cleanlinessRating.value = rating;
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // Accuracy Rating
                Obx(
                      () => _buildRatingSectionWithoutContainer(
                    title: 'Accuracy',

                    rating: controller.accuracyRating.value,
                    onRatingChanged: (rating) {
                      controller.accuracyRating.value = rating;
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // Value Rating
                Obx(
                      () => _buildRatingSectionWithoutContainer(
                    title: 'Value',

                    rating: controller.valueRating.value,
                    onRatingChanged: (rating) {
                      controller.valueRating.value = rating;
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // Amenities Rating
                Obx(
                      () => _buildRatingSectionWithoutContainer(
                    title: 'Amenities',

                    rating: controller.amenitiesRating.value,
                    onRatingChanged: (rating) {
                      controller.amenitiesRating.value = rating;
                    },
                  ),
                ),

              ],
            ),
          ),
            const SizedBox(height: 20),
            //
            // Pros & Cons
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
          //   decoration: BoxDecoration(
          //       color: ColorRes.white,
          //       borderRadius: BorderRadius.circular(12),
          //       border: Border.all(color: ColorRes.leadGreyColor.shade300,width: 1)
          //   ),
          //   child: Column(
          //     children: [
          //       NesticoPeTextField(
          //         controller: controller.prosController,
          //         title: 'Pros',
          //         hintText: 'What did you like?',
          //         maxLines: 3,
          //
          //       ),
          //       const SizedBox(height: 16),
          //       NesticoPeTextField(
          //         controller: controller.consController,
          //         title: 'Cons',
          //         hintText: 'What could be improved?',
          //         maxLines: 3,
          //
          //       ),
          //     ],
          //   ),
          // )
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(

        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            return NesticoPeButton(
              title:
                  controller.isLoading.value ? 'Submitting...' : 'Submit Review',
              onTap: controller.isLoading.value ? null : _submit,
            );
          }),
        ),
      ),
    );
  }

  Widget _buildRatingSection({
    required String title,
    required double rating,
    required Function(double) onRatingChanged,
    bool isRequired = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  }) {
    return FormField<double>(
      initialValue: rating,
      autovalidateMode: autovalidateMode,
      validator: (value) {
        if (isRequired && (value == null || value == 0)) {
          return 'Please provide a rating';
        }
        return null;
      },
      builder: (state) {
        return Container(
          padding: const EdgeInsets.all(AppPadding.medium),
          decoration: BoxDecoration(
            color: ColorRes.white,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(
              color:
                  state.hasError
                      ? ColorRes.error
                      : ColorRes.leadGreyColor.shade300,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(

                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppFontSizes.bodySmall,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textPrimary,
                    ),
                  ),
                  if (isRequired)
                    Text(
                      ' *',
                      style: TextStyle(
                        color: ColorRes.error,
                        fontSize: AppFontSizes.medium,
                      ),
                    ),
                  const Spacer(),
                  Text(
                    rating == 0
                        ? 'Not rated'
                        : rating <= 2
                        ? 'Less'
                        : rating <= 3
                        ? 'Good'
                        : rating <= 4
                        ? 'Very Good'
                        : 'Excellent',
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      fontWeight: AppFontWeights.medium,
                      color: rating == 0
                          ? ColorRes.leadGreyColor
                          : rating <= 2
                          ? Colors.redAccent
                          : rating <= 3
                          ? Colors.orange
                          : rating <= 4
                          ? Colors.green
                          : ColorRes.primary.withOpacity(0.9),
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      final newRating = (index + 1).toDouble();
                      onRatingChanged(newRating);
                      state.didChange(newRating); // update FormField state
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        index < rating.floor()
                            ? Icons.star
                            : (index < rating
                                ? Icons.star_half
                                : Icons.star_outline),
                        color:
                            index < rating
                                ? ColorRes.homeAmber.withOpacity(0.9)
                                : ColorRes.leadGreyColor.shade300,
                        size: 30,
                      ),
                    ),
                  );
                }),
              ),
              if (state.hasError)
                Padding(
                  padding: EdgeInsets.only(top: AppPadding.small),
                  child: Text(
                    state.errorText!,
                    style: TextStyle(
                      color: ColorRes.error,
                      fontSize: AppFontSizes.small,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit() async {
    if (!(controller.formKey.currentState?.validate() ?? false)) return;
    if (controller.overallRating.value == 0) {
      Get.snackbar('Required', 'Please provide an overall rating');
      return;
    }

    // final data = {
    //   "entity_type": entityType,
    //   "entity_id": entityId,
    //   "rating": controller.overallRating.value.toInt(),
    //   "title": controller.titleController.text.trim(),
    //   "content": controller.contentController.text.trim(),
    //   "detailed_ratings": {
    //     "location": controller.locationRating.value.toInt(),
    //     "cleanliness": controller.cleanlinessRating.value.toInt(),
    //     "accuracy": controller.accuracyRating.value.toInt(),
    //     "value": controller.valueRating.value.toInt(),
    //     "amenities": controller.amenitiesRating.value.toInt(),
    //   },
    //   "pros": controller.prosController.text.trim(),
    //   "cons": controller.consController.text.trim(),
    // };
    final data = ReviewItem(
      entityType: entityType,
      entityId: entityId,
      rating: controller.overallRating.value.toDouble(),
      title: controller.titleController.text.trim(),
      content: controller.contentController.text.trim(),
      detailedRatings: DetailedRatings(
        amenities: controller.amenitiesRating.value.toDouble(),
        accuracy: controller.accuracyRating.value.toDouble(),
        cleanliness: controller.cleanlinessRating.value.toDouble(),
        location: controller.locationRating.value.toDouble(),
        value: controller.valueRating.value.toDouble(),
      ),
      pros: controller.prosController.text.trim().isNotEmpty?controller.prosController.text.trim():null,
      cons: controller.consController.text.trim().isNotEmpty?controller.consController.text.trim():null,
    );

    try {
      final success = await controller.createReview(data);
      if (success) {
        controller.resetForm();
        Get.back(result: true); // return true to previous screen
      } else {
        Get.snackbar('Error', 'Failed to submit review');
        return;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return;
    }
  }
}

Widget _buildRatingSectionWithoutContainer({
  required String title,
  required double rating,
  required Function(double) onRatingChanged,
  bool isRequired = false,
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
}) {
  return FormField<double>(
    initialValue: rating,
    autovalidateMode: autovalidateMode,
    validator: (value) {
      if (isRequired && (value == null || value == 0)) {
        return 'Please provide a rating';
      }
      return null;
    },
    builder: (state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(

            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: AppFontSizes.bodySmall,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textPrimary,
                ),
              ),
              if (isRequired)
                Text(
                  ' *',
                  style: TextStyle(
                    color: ColorRes.error,
                    fontSize: AppFontSizes.medium,
                  ),
                ),
              const Spacer(),
              Text(
                rating == 0
                    ? 'Not rated':'${rating.toInt()}/5',
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.medium,
                  color:
                      ColorRes.leadGreyColor

                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  final newRating = (index + 1).toDouble();
                  onRatingChanged(newRating);
                  state.didChange(newRating);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    index < rating.floor()
                        ? Icons.star
                        : (index < rating
                        ? Icons.star_half
                        : Icons.star_outline),
                    color: index < rating
                        ? ColorRes.homeAmber.withOpacity(0.9)
                        : ColorRes.leadGreyColor.shade300,
                    size: 25,
                  ),
                ),
              );
            }),
          ),
          if (state.hasError)
            Padding(
              padding: EdgeInsets.only(top: AppPadding.small),
              child: Text(
                state.errorText!,
                style: TextStyle(
                  color: ColorRes.error,
                  fontSize: AppFontSizes.small,
                ),
              ),
            ),
        ],
      );
    },
  );
}

