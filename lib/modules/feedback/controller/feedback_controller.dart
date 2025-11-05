// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../app/constants/app_font_sizes.dart';
// import '../../../app/constants/color_res.dart';
//
// // Controller for managing the feedback state
// class FeedbackController extends GetxController {
//   var overallRating = 0.0.obs;
//   var reviewMessage = ''.obs;
//   var recommendSeller = false.obs;
//
//
//   void setRating(double rating) {
//     overallRating.value = rating;
//   }
//
//   void setReviewMessage(String message) {
//     reviewMessage.value = message;
//   }
//
//   void toggleRecommendation(bool? value) {
//     recommendSeller.value = value ?? false;
//   }
//
//   void submitFeedback() {
//     // Handle feedback submission
//     Get.snackbar(
//       'Success',
//       'Feedback submitted successfully!',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: ColorRes.success,
//       colorText: ColorRes.black,
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/network/feedback/service/feedback_service.dart';

class FeedbackController extends GetxController {
  final FeedbackService _feedbackService = FeedbackService();

  /// Observables
  var isLoading = false.obs;
  var inquiryType = ''.obs;

  /// Text editing controller if user input is needed
  final TextEditingController inquiryTypeController = TextEditingController();

  ///==================== Submit Feedback ====================
  Future<void> submitFeedback({
    required String propertyId,
    String? inquiry,
  }) async {
    try {
      isLoading.value = true;

      final type = inquiry ?? inquiryTypeController.text.trim();
      if (type.isEmpty) {
        Get.snackbar(
          "Validation",
          "Please select or enter an inquiry type.",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final success = await _feedbackService.createFeedback(
        propertyId: propertyId,
        inquiryType: type,
      );

      if (success) {
        inquiryTypeController.clear();
        inquiryType.value = '';
      }
    } catch (e) {
      debugPrint("Exception in submitFeedback: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    inquiryTypeController.dispose();
    super.onClose();
  }
}
