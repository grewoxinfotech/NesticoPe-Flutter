import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';

// Controller for managing the feedback state
class FeedbackController extends GetxController {
  var overallRating = 0.0.obs;
  var reviewMessage = ''.obs;
  var recommendSeller = false.obs;


  void setRating(double rating) {
    overallRating.value = rating;
  }

  void setReviewMessage(String message) {
    reviewMessage.value = message;
  }

  void toggleRecommendation(bool? value) {
    recommendSeller.value = value ?? false;
  }

  void submitFeedback() {
    // Handle feedback submission
    Get.snackbar(
      'Success',
      'Feedback submitted successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: ColorRes.success,
      colorText: ColorRes.black,
    );
  }
}

