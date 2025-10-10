import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/constants/color_res.dart';

// Controller
class ReportPropertyController extends GetxController {
  var selectedReason = ''.obs;
  var additionalDetails = ''.obs;

  final List<String> reportReasons = [
    'Already Sold',
    'Wrong Information',
    'Fake Photos',
    'Listed Without Permission',
    'Scam/Spam',
  ];

  void setReason(String reason) {
    selectedReason.value = reason;
  }

  void setAdditionalDetails(String details) {
    additionalDetails.value = details;
  }

  void submitReport() {
    print('dhufgyuedgyujhsudhjsahxsiusbusdysdhsudsh');
    if (selectedReason.value.isEmpty) {
      print('Not sfijwdjish');
      Get.snackbar(
        'Error',
        'Please select a reason for reporting',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: ColorRes.white,
      );
    }
    else
      {
        print('ntiy gkfgki kgk ');
        // Handle report submission
        Get.snackbar(
          'Success',
          'Report submitted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: ColorRes.white,
        );

      }

  }

  void cancel() {
    Get.back();
  }
}


// Report Property Screen
