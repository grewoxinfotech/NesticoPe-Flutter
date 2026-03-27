import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/utils/validation.dart';
import 'package:nesticope_app/app/widgets/snackbar/snackbar.dart';
import 'package:nesticope_app/modules/review/views/widget/rating_widget.dart';
import 'package:nesticope_app/widgets/New%20folder/inputs/text_field.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/constants/size_manager.dart';
import '../../controllers/review_controller.dart';

class AddAppReviewDialog extends StatelessWidget {
  AddAppReviewDialog({super.key});

  final ReviewController controller = Get.put(ReviewController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorRes.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.medium),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// Header
                Stack(
                  alignment: Alignment.center,
                  children: [
                    /// Close Button
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close),
                      ),
                    ),

                    /// Title
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Add App Review",
                        style: TextStyle(
                          fontSize: AppFontSizes.body,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.textColor
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /// Rating
                Obx(
                  () => RatingField(
                    title: 'Overall Rating',
                    rating: controller.overallRating.value,
                    isRequired: true,
                    onRatingChanged: (value) {
                      controller.overallRating.value = value;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                const SizedBox(height: 20),

                /// Title Field
                NesticoPeTextField(
                  title: 'Title',
                  controller: controller.titleController,
                  hintText: 'Title',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => requiredField(value, 'Title'),
                ),
                const SizedBox(height: 20),

                /// Description Field
                NesticoPeTextField(
                  title: 'Description',
                  controller: controller.contentController,
                  hintText: 'Description',
                  maxLines: 5,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.trim().length < 10) {
                      return 'Description must be at least 10 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),

                /// Submit Button
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final success = await controller.addAppReview(
                        title: controller.titleController.text.trim(),
                        content: controller.contentController.text.trim(),
                        rating: controller.overallRating.value,
                      );

                      if (success) {
                        Get.back(); // Close dialog
                        controller.resetForm();
                      }
                    }
                  },
                  child: const Text("Submit Review"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
