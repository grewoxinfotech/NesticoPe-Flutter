import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/data/network/review/model/review_model.dart';
import 'package:nesticope_app/widgets/button/button.dart';
import 'package:nesticope_app/widgets/New folder/inputs/text_field.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/constants/size_manager.dart';
import '../../../../data/network/overall_rating/model/overall_rating_model.dart';
import '../../../../widgets/messages/snack_bar.dart';
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  isRequired: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: controller.contentController,
                  title: 'Your Review',
                  hintText: 'Share your detailed experience...',
                  maxLines: 4,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your review';
                    if (v.length < 20)
                      return 'Review must be at least 20 characters';
                    return null;
                  },
                ),
                SizedBox(height: 13),
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
                NesticoPeTextField(
                  // isRequired: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: controller.prosController,
                  title: 'Pros (Optional)',
                  hintText: 'What did you like about this property',
                  maxLines: 4,
                ),
                SizedBox(height: 16),
                Text(
                  'Selective Pros(Optional)',
                  style: TextStyle(
                    fontSize: AppFontSizes.headingTitle,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 13),
                Obx(() {
                  final prosToDisplay =
                      controller.showAllPros.value
                          ? controller.prosTags
                          : controller.prosTags.take(6).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            prosToDisplay.map((tag) {
                              final isSelected = controller.selectedListOfProc
                                  .contains(tag);
                              final isDisabled = controller.selectedListOfCons
                                  .any((cons) => cons.id == tag.counterpart);

                              return GestureDetector(
                                onTap:
                                    isDisabled
                                        ? null
                                        : () => controller.toggleTag(tag),
                                child: Opacity(
                                  opacity: isDisabled ? 0.4 : 1.0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? Colors.green.shade100
                                              : Colors.grey.shade100,
                                      border: Border.all(
                                        color:
                                            isSelected
                                                ? Colors.green.shade300
                                                : Colors.grey.shade300,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      tag.label,
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.green.shade900
                                                : Colors.grey.shade700,
                                        fontSize: AppFontSizes.small,
                                        fontWeight:
                                            isSelected
                                                ? AppFontWeights.medium
                                                : AppFontWeights.regular,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),

                      if (controller.prosTags.length > 6)
                        Center(
                          child: TextButton(
                            onPressed: controller.toggleShowAllPros,
                            child: Text(
                              controller.showAllPros.value
                                  ? 'Show Less ▲'
                                  : 'Show More ▼',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }),

                SizedBox(height: 16),
                NesticoPeTextField(
                  // isRequired: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: controller.consController,
                  title: 'Cons (Optional)',
                  hintText: 'What did you like about this property',
                  maxLines: 4,
                ),
                SizedBox(height: 13),
                Text(
                  'Selective Cons(Optional)',
                  style: TextStyle(
                    fontSize: AppFontSizes.headingTitle,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                  textAlign: TextAlign.left,
                ),

                SizedBox(height: 13),
                Obx(() {
                  final consToDisplay =
                      controller.showAllCons.value
                          ? controller.consTags
                          : controller.consTags.take(6).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            consToDisplay.map((tag) {
                              final isSelected = controller.selectedListOfCons
                                  .contains(tag);
                              final isDisabled = controller.selectedListOfProc
                                  .any((pro) => pro.id == tag.counterpart);

                              return GestureDetector(
                                onTap:
                                    isDisabled
                                        ? null
                                        : () => controller.toggleConsTag(tag),
                                child: Opacity(
                                  opacity: isDisabled ? 0.4 : 1.0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? Colors.red.shade100
                                              : Colors.grey.shade100,
                                      border: Border.all(
                                        color:
                                            isSelected
                                                ? Colors.red.shade300
                                                : Colors.grey.shade300,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      tag.label,
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.red.shade900
                                                : Colors.grey.shade700,
                                        fontSize: AppFontSizes.small,
                                        fontWeight:
                                            isSelected
                                                ? AppFontWeights.medium
                                                : AppFontWeights.regular,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),

                      if (controller.consTags.length > 6)
                        Center(
                          child: TextButton(
                            onPressed: controller.toggleShowAllCons,
                            child: Text(
                              controller.showAllCons.value
                                  ? 'Show Less ▲'
                                  : 'Show More ▼',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }),

                // Divider(height: 32, color: ColorRes.leadGreyColor.shade300),

                // Detailed Ratings Header
                Text(
                  'Detailed Ratings',
                  style: TextStyle(
                    fontSize: AppFontSizes.headingTitle,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 16),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: ColorRes.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ColorRes.leadGreyColor.shade300,
                      width: 1,
                    ),
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
                          title: 'Nightlife',

                          rating: controller.nightlifeRating.value,
                          onRatingChanged: (rating) {
                            controller.nightlifeRating.value = rating;
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
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            return NesticoPeButton(
              title:
                  controller.isLoading.value
                      ? 'Submitting...'
                      : 'Submit Review',
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
                      color:
                          rating == 0
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
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Required',
        message: 'Please provide an overall rating',
        contentType: ContentType.failure,
      );
      return;
    }

    final prosText = controller.prosController.text.trim();
    final consText = controller.consController.text.trim();

    final data = ReviewItem(
      entityType: entityType,
      entityId: entityId,
      rating: controller.overallRating.value.toDouble(),
      title: controller.titleController.text.trim(),
      content: controller.contentController.text.trim(),
      detailedRatings: DetailedRatings(
        amenities: controller.amenitiesRating.value.toDouble(),
        nightlifeRating: controller.nightlifeRating.value.toDouble(),
        cleanliness: controller.cleanlinessRating.value.toDouble(),
        location: controller.locationRating.value.toDouble(),
        value: controller.valueRating.value.toDouble(),
      ),
      pros: ReviewProsCons(
        text: prosText,
        tags: controller.selectedListOfProc.value.map((e) => e.id).toList(),
      ),
      // add tag list later if needed
      cons: ReviewProsCons(
        text: consText,
        tags: controller.selectedListOfCons.value.map((e) => e.id).toList(),
      ),
    );

    log("Print the section ${data.toJson()}");

    try {
      final success = await controller.createReview(data);
      if (success) {
        controller.resetForm();
        Get.back(result: true); // return true to previous screen
      } else
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: 'Failed to submit review',
          contentType: ContentType.failure,
        );
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: e.toString(),
        contentType: ContentType.failure,
      );
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
                rating == 0 ? 'Not rated' : '${rating.toInt()}/5',
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.medium,
                  color: ColorRes.leadGreyColor,
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
                    color:
                        index < rating
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
