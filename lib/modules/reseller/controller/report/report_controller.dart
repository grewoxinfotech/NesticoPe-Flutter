import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/report/model/property_report_model.dart';
import 'package:housing_flutter_app/data/network/report/property_report_service.dart';
import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';

import '../../../../app/constants/color_res.dart';

// Controller
class ReportPropertyController extends GetxController {
  final PropertyReportService _reportService = PropertyReportService();
  var selectedReason = ''.obs;
  var additionalDetails = ''.obs;
  final isSubmitting = false.obs;

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

  Future<void> submitReport(String propertyId) async {
    if (selectedReason.value.isEmpty) {
      print('Not sfijwdjish');
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: 'Please select a reason for reporting',
        contentType: ContentType.failure,
      );
      return;
    }
    try {
      isSubmitting.value = true;
      final data = PropertyReportModel(
        propertyId: propertyId,
        reason: selectedReason.value.toLowerCase().replaceAll(' ', '_'),
        description: additionalDetails.value,
      );
      final success = await _reportService.createPropertyReport(data);
      if (!success) {
        throw Exception('Failed to submit report');
      }

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Success",
        message: 'Report submitted successfully',
        contentType: ContentType.success,
      );
    } catch (e) {
      print('Error submitting report: $e');
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: 'Failed to submit report. Please try again later.',
        contentType: ContentType.failure,
      );
      return;
    } finally {
      isSubmitting.value = false;
    }
  }

  void cancel() {
    Get.back();
  }
}

// Report Property Screen
