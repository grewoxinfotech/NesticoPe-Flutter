// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/widgets/button/button.dart';
// import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';
//
// import '../../../../app/constants/size_manager.dart';
// import '../../../../widgets/New folder/inputs/text_field.dart';
//
// class AddReviewForm extends StatefulWidget {
//   final String entityType; // "property"
//   final String entityId; // Property ID
//
//   const AddReviewForm({
//     super.key,
//     required this.entityType,
//     required this.entityId,
//   });
//
//   @override
//   State<AddReviewForm> createState() => _AddReviewFormState();
// }
//
// class _AddReviewFormState extends State<AddReviewForm> {
//   final _formKey = GlobalKey<FormState>();
//
//   // Form controllers
//   final _titleController = TextEditingController();
//   final _contentController = TextEditingController();
//   final _prosController = TextEditingController();
//   final _consController = TextEditingController();
//
//   // Rating values
//   double _overallRating = 0;
//   double _locationRating = 0;
//   double _cleanlinessRating = 0;
//   double _accuracyRating = 0;
//   double _valueRating = 0;
//   double _amenitiesRating = 0;
//
//   bool _isSubmitting = false;
//
//   @override
//   void dispose() {
//     _titleController.dispose();
//     _contentController.dispose();
//     _prosController.dispose();
//     _consController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(title: const Text('Add Review'), elevation: 0),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: const EdgeInsets.all(20),
//           children: [
//             // Title Field
//             NesticoPeTextField(
//               controller: _titleController,
//               autovalidateMode: AutovalidateMode.onUserInteraction,
//
//               title: 'Review Title',
//               hintText: 'Summarize your experience',
//               prefixIcon: Icons.title,
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return 'Please enter a title';
//                 }
//                 return null;
//               },
//             ),
//
//             const SizedBox(height: 20),
//
//             // Content Field (Multiline)
//             NesticoPeTextField(
//               controller: _contentController,
//               autovalidateMode: AutovalidateMode.onUserInteraction,
//               title: 'Your Review',
//               hintText: 'Share your detailed experience...',
//               maxLines: 3,
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return 'Please enter your review';
//                 }
//                 if (value.trim().length < 20) {
//                   return 'Review should be at least 20 characters';
//                 }
//                 return null;
//               },
//             ),
//
//             const SizedBox(height: 24),
//
//             // Overall Rating
//             _buildRatingSection(
//               title: 'Overall Rating',
//               autovalidateMode: AutovalidateMode.onUserInteraction,
//               rating: _overallRating,
//               onRatingChanged: (rating) {
//                 setState(() => _overallRating = rating);
//               },
//               isRequired: true,
//             ),
//
//             const SizedBox(height: 16),
//             Divider(height: 32, color: ColorRes.leadGreyColor.shade300),
//
//             // Detailed Ratings Header
//             Text(
//               'Detailed Ratings',
//               style: TextStyle(
//                 fontSize: AppFontSizes.body,
//                 fontWeight: AppFontWeights.bold,
//                 color: ColorRes.leadGreyColor.shade800,
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             // Location Rating
//             _buildRatingSection(
//               title: 'Location',
//               rating: _locationRating,
//               onRatingChanged: (rating) {
//                 setState(() => _locationRating = rating);
//               },
//             ),
//
//             const SizedBox(height: 12),
//
//             // Cleanliness Rating
//             _buildRatingSection(
//               title: 'Cleanliness',
//               rating: _cleanlinessRating,
//               onRatingChanged: (rating) {
//                 setState(() => _cleanlinessRating = rating);
//               },
//             ),
//
//             const SizedBox(height: 12),
//
//             // Accuracy Rating
//             _buildRatingSection(
//               title: 'Accuracy',
//               rating: _accuracyRating,
//               onRatingChanged: (rating) {
//                 setState(() => _accuracyRating = rating);
//               },
//             ),
//
//             const SizedBox(height: 12),
//
//             // Value Rating
//             _buildRatingSection(
//               title: 'Value',
//               rating: _valueRating,
//               onRatingChanged: (rating) {
//                 setState(() => _valueRating = rating);
//               },
//             ),
//
//             const SizedBox(height: 12),
//
//             // Amenities Rating
//             _buildRatingSection(
//               title: 'Amenities',
//               rating: _amenitiesRating,
//               onRatingChanged: (rating) {
//                 setState(() => _amenitiesRating = rating);
//               },
//             ),
//
//             const SizedBox(height: 24),
//             const Divider(height: 32),
//
//             // Pros Field
//             NesticoPeTextField(
//               controller: _prosController,
//               title: 'Pros (Optional)',
//               hintText:
//                   'What did you like? e.g., Great location, modern appliances',
//               prefixIcon: Icons.thumb_up_outlined,
//               maxLines: 3,
//             ),
//
//             const SizedBox(height: 20),
//
//             // Cons Field
//             NesticoPeTextField(
//               controller: _consController,
//               title: 'Cons (Optional)',
//               hintText: 'What could be improved? e.g., Limited parking',
//               prefixIcon: Icons.thumb_down_outlined,
//               maxLines: 3,
//             ),
//
//             const SizedBox(height: 32),
//           ],
//         ),
//       ),
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: NesticoPeButton(
//             onTap: _isSubmitting ? null : _submitReview,
//             title: _isSubmitting ? 'Submitting...' : 'Submit Review',
//             backgroundColor: _isSubmitting ? ColorRes.grey : ColorRes.primary,
//             boxShadow: [],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRatingSection({
//     required String title,
//     required double rating,
//     required Function(double) onRatingChanged,
//     bool isRequired = false,
//     AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
//   }) {
//     return FormField<double>(
//       initialValue: rating,
//       autovalidateMode: autovalidateMode,
//       validator: (value) {
//         if (isRequired && (value == null || value == 0)) {
//           return 'Please provide a rating';
//         }
//         return null;
//       },
//       builder: (state) {
//         return Container(
//           padding: const EdgeInsets.all(AppPadding.medium),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(AppRadius.medium),
//             border: Border.all(
//               color:
//                   state.hasError
//                       ? ColorRes.error
//                       : ColorRes.leadGreyColor.shade300,
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: AppFontSizes.medium,
//                       fontWeight: AppFontWeights.semiBold,
//                       color: ColorRes.textPrimary,
//                     ),
//                   ),
//                   if (isRequired)
//                     Text(
//                       ' *',
//                       style: TextStyle(
//                         color: ColorRes.error,
//                         fontSize: AppFontSizes.medium,
//                       ),
//                     ),
//                   const Spacer(),
//                   Text(
//                     rating == 0 ? 'Not rated' : rating.toStringAsFixed(1),
//                     style: TextStyle(
//                       fontSize: AppFontSizes.medium,
//                       fontWeight: AppFontWeights.bold,
//                       color:
//                           rating == 0
//                               ? ColorRes.leadGreyColor.shade300
//                               : ColorRes.primary.withOpacity(0.9),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(5, (index) {
//                   return GestureDetector(
//                     onTap: () {
//                       final newRating = (index + 1).toDouble();
//                       onRatingChanged(newRating);
//                       state.didChange(newRating); // update FormField state
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 4),
//                       child: Icon(
//                         index < rating.floor()
//                             ? Icons.star
//                             : (index < rating
//                                 ? Icons.star_half
//                                 : Icons.star_outline),
//                         color:
//                             index < rating
//                                 ? ColorRes.primary.withOpacity(0.9)
//                                 : ColorRes.leadGreyColor.shade300,
//                         size: 36,
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//               if (state.hasError)
//                 Padding(
//                   padding: EdgeInsets.only(top: AppPadding.small),
//                   child: Text(
//                     state.errorText!,
//                     style: TextStyle(
//                       color: ColorRes.error,
//                       fontSize: AppFontSizes.small,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _submitReview() async {
//     // Validate form
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//
//     // Validate overall rating
//     if (_overallRating == 0) {
//       NesticoPeSnackBar.showAwesomeSnackbar(
//         title: 'Required Field',
//         message: 'Please provide an overall rating',
//         contentType: ContentType.failure,
//       );
//       return;
//     }
//
//     setState(() => _isSubmitting = true);
//
//     try {
//       // Prepare review data
//       final reviewData = {
//         "entity_type": widget.entityType,
//         "entity_id": widget.entityId,
//         "rating": _overallRating.toInt(),
//         "title": _titleController.text.trim(),
//         "content": _contentController.text.trim(),
//         "detailed_ratings": {
//           "location": _locationRating.toInt(),
//           "cleanliness": _cleanlinessRating.toInt(),
//           "accuracy": _accuracyRating.toInt(),
//           "value": _valueRating.toInt(),
//           "amenities": _amenitiesRating.toInt(),
//         },
//         "pros": _prosController.text.trim(),
//         "cons": _consController.text.trim(),
//       };
//
//       // TODO: Call your API service here
//       // await reviewService.createReview(reviewData);
//
//       print('Review Data: $reviewData');
//
//       NesticoPeSnackBar.showAwesomeSnackbar(
//         title: 'Success',
//         message: 'Your review has been submitted successfully!',
//         contentType: ContentType.success,
//       );
//
//       // Navigate back or clear form
//       await Future.delayed(const Duration(seconds: 1));
//       Get.back(result: true); // Return true to indicate success
//     } catch (e) {
//       NesticoPeSnackBar.showAwesomeSnackbar(
//         title: 'Error',
//         message: 'Failed to submit review. Please try again.',
//         contentType: ContentType.failure,
//       );
//     } finally {
//       setState(() => _isSubmitting = false);
//     }
//   }
// }

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
      appBar: AppBar(title: const Text('Add Review')),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title
            NesticoPeTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: controller.titleController,
              title: 'Review Title',
              hintText: 'Summarize your experience',
              prefixIcon: Icons.title,
              validator:
                  (v) => (v == null || v.isEmpty) ? 'Enter a title' : null,
            ),
            const SizedBox(height: 16),

            // Content
            NesticoPeTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: controller.contentController,
              title: 'Your Review',
              hintText: 'Share your detailed experience...',
              maxLines: 3,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Enter your review';
                if (v.length < 20)
                  return 'Review must be at least 20 characters';
                return null;
              },
            ),
            const SizedBox(height: 24),

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
            Divider(height: 32, color: ColorRes.leadGreyColor.shade300),

            // Detailed Ratings Header
            Text(
              'Detailed Ratings',
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: AppFontWeights.bold,
                color: ColorRes.leadGreyColor.shade800,
              ),
            ),
            const SizedBox(height: 16),

            // Location Rating
            Obx(
              () => _buildRatingSection(
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
              () => _buildRatingSection(
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
              () => _buildRatingSection(
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
              () => _buildRatingSection(
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
              () => _buildRatingSection(
                title: 'Amenities',
                rating: controller.amenitiesRating.value,
                onRatingChanged: (rating) {
                  controller.amenitiesRating.value = rating;
                },
              ),
            ),

            const SizedBox(height: 24),
            const Divider(height: 32),
            //
            // Pros & Cons
            NesticoPeTextField(
              controller: controller.prosController,
              title: 'Pros (Optional)',
              hintText: 'What did you like?',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            NesticoPeTextField(
              controller: controller.consController,
              title: 'Cons (Optional)',
              hintText: 'What could be improved?',
              maxLines: 3,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return NesticoPeButton(
            title:
                controller.isLoading.value ? 'Submitting...' : 'Submit Review',
            onTap: controller.isLoading.value ? null : _submit,
          );
        }),
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
            color: Colors.white,
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
                      fontSize: AppFontSizes.medium,
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
                    rating == 0 ? 'Not rated' : rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.bold,
                      color:
                          rating == 0
                              ? ColorRes.leadGreyColor.shade300
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
                                ? ColorRes.primary.withOpacity(0.9)
                                : ColorRes.leadGreyColor.shade300,
                        size: 36,
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
      pros: controller.prosController.text.trim(),
      cons: controller.consController.text.trim(),
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
