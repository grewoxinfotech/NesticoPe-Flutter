import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/utils/logger/app_logger.dart';

import '../../../app/constants/color_res.dart';
import '../../../data/database/secure_storage_service.dart';
import '../../../data/network/auth/model/user_model.dart';
import '../../../data/network/contractor/model/contractor_quotation/contractor_quotation.dart';
import '../../../data/network/contractor/model/contractot_service_model/contractor_inquiry_model.dart';
import '../../../data/network/contractor/service/contractor_inquiry_service.dart';
import '../../../widgets/messages/snack_bar.dart';
import 'contractor_lead_controller.dart';

class ContractorQuotationController
    extends PaginatedController<ContractorQuotation> {
  RxMap<String, String> filters = <String, String>{}.obs;

  ContractorLeadController controllerLead=ContractorLeadController();
  @override
  void onInit() async {
    super.onInit();

    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? '';

    filters.assignAll({'created_by': userId});
    ever(filters, (_) {
      if (!isLoading.value) {
        refreshList();
      }
    });

    loadInitial();
  }

  Future<void> applyFilters(Map<String, String> filter) async {
    filters.assignAll(filter);
    print("Apply Filter in Quotation Contractor Section ${filters} ");
    refreshList();
  }

  @override
  Future<PaginationResponse<ContractorQuotation>> fetchItems(int page) async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? '';

    final response = await ContractorInquiryService.contractorInquiryService
        .fetchContractorQuotation(page: page, filters: filters, id: userId);
    return response;
  }

  /// Update the status of a quotation
  Future<void> updateQuotationStatus(String quotationId, String status) async {
    try {
      final success = await ContractorInquiryService.contractorInquiryService
          .updateStatusOfQuotation(
            quotationId,
            status.toLowerCase().replaceAll(" ", "_"),
          );

      if (success) {
        // Refresh the list to update UI
        await refreshList();

        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Success",
          message: 'Quotation status updated successfully',
          contentType: ContentType.success,
        );
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Error",
          message: 'Failed to update quotation status',
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: 'An error occurred: ${e.toString()}',
        contentType: ContentType.failure,
      );
    }
  }

  /// Convert quotation to lead
  Future<void> convertQuotationToLead(ContractorQuotation quotation) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Prepare lead data from quotation
      final leadData = {
        'related_id': quotation.relatedId,
        'user_id': quotation.user.id,
        'quotation_id': quotation.id,
        'price': quotation.price,
        'status': 'New',
        'meta': {
          'notes': quotation.meta.notes,
          'propertyDetails': quotation.meta.propertyDetails?.toMap(),
          'serviceNames': quotation.meta.serviceNames,
        },
      };

      final success = await ContractorInquiryService.contractorInquiryService
          .convertInquiryIntoLead(leadData);

      Get.back(); // Close loading dialog

      if (success) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Success",
          message: 'Quotation converted to lead successfully',
          contentType: ContentType.success,
        );

        // Refresh the list
        refresh();
        Get.back(); // Go back to previous screen
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Error",
          message: 'Failed to convert quotation to lead',
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: 'An error occurred: ${e.toString()}',
        contentType: ContentType.failure,
      );
    }
  }

  /// Delete a quotation
  Future<void> deleteQuotation(String quotationId) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final success = await ContractorInquiryService.contractorInquiryService
          .deleteQuotation(quotationId);

      refreshList();
      items.refresh();
      Navigator.of(Get.context!).pop();

      if (success) {
        refreshList();
        items.refresh();
        Navigator.of(Get.context!).pop();

        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Success",
          message: 'Quotation deleted successfully',
          contentType: ContentType.success,
        );

        // Go back to previous screen
      } else {
        refreshList();
        items.refresh();
        Navigator.of(Get.context!).pop();

        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Error",
          message: 'Failed to delete quotation',
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      refreshList();
      items.refresh();
      Navigator.of(Get.context!).pop();

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: 'An error occurred: ${e.toString()}',
        contentType: ContentType.failure,
      );
    }
  }

  Future<void> refreshQuotation() async {
    try {
      isRefreshing.value = true;

      await Future.delayed(const Duration(seconds: 1));
      refreshList();

      // Update metrics with new values
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: 'Failed to refresh ',
        contentType: ContentType.failure,
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  /// Update quotation details
  Future<void> updateQuotation({
    required ContractorQuotation quotationId,
    required int price,
    required String status,
    required String note,
    required String userId,
    required int discountedPrice,
    required String date
  }) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final quotationData = {
        "id": "${quotationId.id}",
        "created_by": "${quota tionId.user.id}",
        "updated_by": null,
        "related_id": "${quotationId.relatedId}",
        "user": {
          "id": "${quotationId.user.id}",
          "name": "${quotationId.user.name}",
          "email": "${quotationId.user.email}",
          "phone": "${quotationId.user.phone}",
        },
        "status": status.toLowerCase().replaceAll(" ", '_'),
        "meta": {
          "notes": note,
          "originalPrice": price,
          "expectedStartDate": date,
          "inquiryCustomerId": userId,

        },
        "price": discountedPrice,
        "is_converted": false,
        "createdAt": DateTime.now().toIso8601String(),
        "updatedAt": DateTime.now().toIso8601String(),
      };

      final success = await ContractorInquiryService.contractorInquiryService
          .updateQuotation(quotationData);

      Navigator.pop(Get.context!);

      if (success) {
        refreshList();

        items.refresh();

        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Success",
          message: 'Quotation updated successfully',
          contentType: ContentType.success,
        );
        Navigator.pop(Get.context!);
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Error",
          message: 'Failed to update quotation',
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      Navigator.pop(Get.context!);

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: 'An error occurred: ${e.toString()}',
        contentType: ContentType.failure,
      );
    }
  }

  Future<void> convertIntoLead(
    ContractorQuotation item,
    // String serviceID,
    // String serviceName,
  ) async {
    UserModel user = await SecureStorage.getUserData() ?? UserModel();
    final String contractorName = user.user?.username ?? '';

    // final payload = {
    //   "name": item.name,
    //   "email": item.email,
    //   "phone": item.phone,
    //   "inquiry_id": item.id,
    //   "reseller_id": item.contractorId,
    //   "source": "website",
    //   "status": "new",
    //   "stage": "new_lead",
    //   "notes":
    //   "Converted from contractor inquiry on ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
    //   "customFields": {
    //     "serviceId": serviceID,
    //     "serviceName": serviceName,
    //     "contractorId": item.contractorId,
    //     "contractorUsername": contractorName,
    //   },
    // };

    AppLogger.structured("Quotation Item:", item.toMap());
    AppLogger.structured("Quotation User:", user.user?.toJson());
    final payload = {
      "name": item.user.name,
      "email": item.user.email,
      "phone": item.user.phone,
      "source": "website",
      "status": "new",
      "stage": "new_lead",
      "reseller_id": item.user.id,
      "customFields": {
        "serviceId": item.meta.inquiryServices?.first.serviceId,
        "serviceName": item.meta.inquiryServices?.first.serviceName,
        "contractorId": item.user.id,
        "contractorUsername": user.user?.username,
        "serviceDescription": item.meta.propertyDetails?.serviceDescription,
        "quotationId": item.id,
        "quotationPrice": item.price,
      },
    };

    print("Lead Payload: $payload");
    final response = await ContractorInquiryService.contractorInquiryService
        .convertInquiryIntoLead(payload);
    if (response) {
      print("Check to plau ");
      controllerLead.loadInitial();
      controllerLead.refreshLead();
      controllerLead.items.refresh();
      refreshList();
      Navigator.pop(Get.context!);
    }
  }
}
