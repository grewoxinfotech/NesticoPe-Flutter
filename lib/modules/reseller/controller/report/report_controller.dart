import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/data/network/report/model/property_report_model.dart';
import 'package:housing_flutter_app/data/network/report/service/property_report_service.dart';
import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';

import '../../../../app/constants/color_res.dart';
import '../../../../data/database/secure_storage_service.dart';

// Controller
class ReportPropertyController extends PaginatedController<PropertyReportItem> {
  final PropertyReportService _reportService = PropertyReportService();
  var selectedReason = ''.obs;
  var additionalDetails = ''.obs;
  final isSubmitting = false.obs;
  final RxString propertyId = ''.obs;
  final RxString createdBy = ''.obs;

  final List<String> reportReasons = [
    'Already Sold',
    'Wrong Information',
    'Fake Photos',
    'Listed Without Permission',
    'Scam/Spam',
  ];

  @override
  void onInit() {
    // _reportService.getPropertyReports(propertyId: propertyId, createdBy: createdBy)
    super.onInit();
  }

  Future<void> getPropertyReportsById(String propertyId) async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? "";
    this.propertyId.value = propertyId;
    this.createdBy.value = userId;
    await refreshList();
  }

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
      getPropertyReportsById(propertyId);
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

  Map<String, String> get filters {
    final Map<String, String> filterMap = {};
    if (propertyId.isNotEmpty) {
      filterMap['propertyId'] = propertyId.value;
    }
    if (createdBy.isNotEmpty) {
      filterMap['created_by'] = createdBy.value;
    }
    return filterMap;
  }

  @override
  Future<PaginationResponse<PropertyReportItem>> fetchItems(int page) async {
    try {
      final response = await _reportService.fetchPropertyReports(
        page: page,
        filters: filters,
      );

      print("Fetched items: ${response.items.length}");
      return response; // ✅ full response with items + meta
    } catch (e) {
      print("Exception in fetchItems: $e");
      rethrow;
    }
  }
}
