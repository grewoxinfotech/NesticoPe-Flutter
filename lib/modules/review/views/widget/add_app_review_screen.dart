import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/utils/validation.dart';
import 'package:housing_flutter_app/app/widgets/snackbar/snackbar.dart';
import 'package:housing_flutter_app/modules/review/views/widget/rating_widget.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/text_field.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/constants/size_manager.dart';
import '../../controllers/review_controller.dart';

class AddAppReviewScreen extends StatelessWidget {
  AddAppReviewScreen({super.key});

  final ReviewController controller = Get.put(ReviewController());

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add App Review'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.medium),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Rating
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

              // Title
              NesticoPeTextField(
                title: 'Title',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller.titleController,
                validator: (value) => requiredField(value, 'Title'),
                hintText: 'Title',
              ),
              const SizedBox(height: 20),

              // Description
              NesticoPeTextField(
                title: 'Description',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                hintText: 'Description',
                controller: controller.contentController,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().length < 10) {
                    return 'Description must be at least 10 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Submit Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final success = await controller.addAppReview(
                      title: controller.titleController.text.trim(),
                      content: controller.contentController.text.trim(),
                      rating: controller.overallRating.value,
                    );
                    if (success) {
                      Get.back(); // go back after successful submission

                      controller.resetForm();
                    }
                  }
                },
                child: const Text('Submit Review'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
