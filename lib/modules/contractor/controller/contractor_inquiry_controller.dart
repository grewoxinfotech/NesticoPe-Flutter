import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/data/network/contractor/service/contractor_inquiry_service.dart';
import 'package:nesticope_app/utils/logger/app_logger.dart';

import '../../../app/care/pagination/controller/pagination_controller.dart';
import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';
import '../../../data/database/secure_storage_service.dart';
import '../../../data/network/auth/model/user_model.dart';
import '../../../data/network/contractor/model/contractot_service_model/contractor_inquiry_model.dart';
import '../../../widgets/messages/snack_bar.dart';
import '../../../data/network/contractor/service/subscription/subscription_limit_guard.dart';

class ContractorInquiryController
    extends PaginatedController<ContractorInquiryItem> {
  // final expandedCards = <String>{}.obs;
  final expandedCards = <String, bool>{}.obs;
  final selectedStatus = <String, String>{}.obs;
  RxMap<String, String> filters = <String, String>{}.obs;

  RxList<ContractorInquiryItem> itemInquiryList = <ContractorInquiryItem>[].obs;

  final txtStartDate = TextEditingController();
  final txtEndDate = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  RxString conversionStatus = ''.obs;
  RxString inquiryStatus = "".obs;

  @override
  void onInit() {
    super.onInit();
    // getCategoryService();

    ever(filters, (_) => refreshList());

    loadInitial();
  }

  Future<void> applyFilters(Map<String, String> filter) async {
    filters.assignAll(filter);
    log("Apply Filter in Inquiry Contractor Section ${filters} ");
    // await loadInitial();
    refreshList();
  }

  Future<void> refreshInquiry() async {
    try {
      isRefreshing.value = true;
      refreshList();
      await Future.delayed(const Duration(seconds: 1));

      // Update metrics with new values
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to refresh ',
        contentType: ContentType.failure,
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  void resetFilters() {
    txtStartDate.clear();
    txtEndDate.clear();
    startDate = DateTime.now();
    endDate = DateTime.now();
    conversionStatus.value = '';
    inquiryStatus.value = '';
    // update();
  }

  void toggleCard(String id) {
    expandedCards[id] = !(expandedCards[id] ?? false);
    expandedCards.refresh(); // 🔥 important to update UI
  }

  Future<void> getFilterData() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? '';

    print("Fetched itemsdsfkdf: ${items.length}");
    itemInquiryList.value =
        items.where((item) => item.contractorId == userId).toList();
    print("Filtered items;gofdpog: ${itemInquiryList.length}");
  }

  // bool isExpanded(String id) => expandedCards.contains(id);

  bool isExpanded(String id) => expandedCards[id] ?? false;

  Future<void> changeStatus(String id, String newStatus) async {
    selectedStatus[id] = newStatus;
    final formattedStatus = newStatus.trim().toLowerCase().replaceAll(' ', '_');
    final response = await ContractorInquiryService.contractorInquiryService
        .updateStatusOfInquiry(id, formattedStatus);

    if (response) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Status Updated',
        message: 'Status changed to $newStatus',
        contentType: ContentType.success,
      );
      refreshList();
      getFilterData();
    } else {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Status Update Failed',
        message: 'Could not change status to $newStatus',
        contentType: ContentType.failure,
      );
    }
  }

  void setValue<T>(Rx<T> target, T value) {
    target.value = value;
  }

  Future<void> deletedContractorInquiry(String id) async {
    final response = await ContractorInquiryService.contractorInquiryService
        .deleteInquiry(id);
    if (response) {
      refreshList();
      getFilterData();
    }
  }

  Future<void> convertIntoLead(
    ContractorInquiryItem item,
    String serviceID,
    String serviceName,
  ) async {
    UserModel user = await SecureStorage.getUserData() ?? UserModel();
    final String contractorName = user.user?.username ?? '';

    final payload = {
      "name": item.name,
      "email": item.email,
      "phone": item.phone,
      "inquiry_id": item.id,
      "reseller_id": item.contractorId,
      "source": "website",
      "status": "new",
      "stage": "new_lead",
      "notes":
          "Converted from contractor inquiry on ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      "customFields": {
        "serviceId": serviceID,
        "serviceName": serviceName,
        "contractorId": item.contractorId,
        "contractorUsername": contractorName,
      },
    };

    print("Lead Payload: $payload");
    final response = await ContractorInquiryService.contractorInquiryService
        .convertInquiryIntoLead(payload);
    if (response) {
      refreshList();
    } else {
      // Reset plan-limit "handled" state so it doesn't leak into other actions.
      SubscriptionLimitGuard.consumeHandledState();
    }
  }

  bool areAllServicesConverted(
    List<String> convertedServices,
    List<InquiryService> services,
  ) {
    final serviceIds = services.map((s) => s.serviceId).toList();

    if (convertedServices.length != serviceIds.length) return false;
    for (var id in serviceIds) {
      if (!convertedServices.contains(id)) {
        return false;
      }
    }

    return true;
  }

  void deleteInquiry(String id, String name) {
    Get.dialog(
      AlertDialog(
        backgroundColor: ColorRes.white,
        title: const Text(
          'Delete Inquiry',
          style: TextStyle(
            fontSize: AppFontSizes.large,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textColor,
          ),
        ),
        content: Text('Are you sure you want to delete inquiry for $name?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ColorRes.error),
            onPressed: () {
              Get.back();
              deletedContractorInquiry(id);

              NesticoPeSnackBar.showAwesomeSnackbar(
                title: 'Deleted',
                message: 'Inquiry deleted successfully',
                contentType: ContentType.success,
              );
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void convertToLead(
    ContractorInquiryItem item,
    List<InquiryService> services,
    List<String> convertedServices,
  ) {
    if (services.isEmpty) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'No services available to convert',
        contentType: ContentType.failure,
      );
      return;
    }

    // 🔹 Get only unconverted services
    final unconvertedServices =
        services
            .where((service) => !convertedServices.contains(service.serviceId))
            .toList();

    // ✅ CASE 0: All converted
    if (unconvertedServices.isEmpty) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Info',
        message: 'All services are already converted',
        contentType: ContentType.help,
      );
      return;
    }

    // ✅ CASE 1: Only one unconverted service — directly convert
    if (unconvertedServices.length == 1) {
      final service = unconvertedServices.first;
      convertIntoLead(item, service.serviceId, service.serviceName);
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Success',
        message: 'Converted "${service.serviceName}" to lead successfully',
        contentType: ContentType.success,
      );
      return;
    }

    // ✅ CASE 2: Multiple unconverted services — show dialog
    RxString selectedServiceId = ''.obs;
    RxString selectedServiceName = ''.obs;

    Get.dialog(
      AlertDialog(
        backgroundColor: ColorRes.white,
        title: const Text(
          'Convert to Lead',
          style: TextStyle(
            fontSize: AppFontSizes.large,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textColor,
          ),
        ),
        content: Obx(
          () => SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select one service to convert:',
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    fontWeight: AppFontWeights.medium,
                    color: ColorRes.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                ...unconvertedServices.map(
                  (service) => RadioListTile<String>(
                    title: Text(service.serviceName),
                    value: service.serviceId,
                    groupValue: selectedServiceId.value,
                    onChanged: (value) {
                      selectedServiceId.value = value!;
                      selectedServiceName.value = service.serviceName;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ColorRes.green),
            onPressed: () async {
              if (selectedServiceId.value.isEmpty) {
                NesticoPeSnackBar.showAwesomeSnackbar(
                  title: 'Error',
                  message: 'Please select one service',
                  contentType: ContentType.failure,
                );
                return;
              }

              Get.back();
              await convertIntoLead(
                item,
                selectedServiceId.value,
                selectedServiceName.value,
              );

              NesticoPeSnackBar.showAwesomeSnackbar(
                title: 'Success',
                message:
                    'Converted "${selectedServiceName.value}" to lead successfully',
                contentType: ContentType.success,
              );
            },
            child: const Text("Convert"),
          ),
        ],
      ),
    );
  }

  // void convertToLead(ContractorInquiryItem item, List<InquiryService> services) {
  //   if (services.isEmpty) {
  //     Get.snackbar(
  //       'Error',
  //       'No services available to convert',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: ColorRes.error,
  //       colorText: ColorRes.white,
  //     );
  //     return;
  //   }
  //
  //   if (services.length == 1) {
  //     convertIntoLead(item, services.first.serviceId, services.first.serviceName);
  //     Get.snackbar(
  //       'Success',
  //       'Converted to lead successfully',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: ColorRes.success,
  //       colorText: ColorRes.white,
  //     );
  //     return;
  //   }
  //
  //   // ✅ CASE 2: Multiple services — show dialog
  //   RxString selectedServiceId = ''.obs;
  //   RxString selectedServiceName = ''.obs;
  //
  //   Get.dialog(
  //     AlertDialog(
  //       backgroundColor: ColorRes.white,
  //       title: const Text(
  //         'Convert to Lead',
  //         style: TextStyle(
  //           fontSize: AppFontSizes.large,
  //           fontWeight: AppFontWeights.semiBold,
  //           color: ColorRes.textColor,
  //         ),
  //       ),
  //       content: Obx(
  //             () => SizedBox(
  //           width: double.maxFinite,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const Text('Select one service to convert:'),
  //               const SizedBox(height: 16),
  //               ...services.map(
  //                     (service) => RadioListTile<String>(
  //                   title: Text(service.serviceName),
  //                   value: service.serviceId,
  //                   groupValue: selectedServiceId.value,
  //                   onChanged: (value) {
  //                     selectedServiceId.value = value!;
  //                     selectedServiceName.value = service.serviceName;
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Get.back(),
  //           child: const Text('Cancel'),
  //         ),
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(backgroundColor: ColorRes.green),
  //           onPressed: () async {
  //             if (selectedServiceId.value.isEmpty) {
  //               Get.snackbar(
  //                 'Error',
  //                 'Please select one service',
  //                 snackPosition: SnackPosition.BOTTOM,
  //               );
  //               return;
  //             }
  //
  //             Get.back();
  //             await convertIntoLead(
  //               item,
  //               selectedServiceId.value,
  //               selectedServiceName.value,
  //             );
  //
  //             Get.snackbar(
  //               'Success',
  //               'Converted to lead successfully',
  //               snackPosition: SnackPosition.BOTTOM,
  //               backgroundColor: ColorRes.success,
  //               colorText: ColorRes.white,
  //             );
  //           },
  //           child: const Text("Convert"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Future<void> submitQuotation({
    required String inquiryId,
    required int quotationPrice,
    required String status,
    required String note,
    required ContractorInquiryItem inquiry,
    required String userId,
    required int discountedPrice,
    required String date,
    required bool gstEnabled,
    int? gst,
    int? afterGstPrice,
    required int discountPercentage,
    required int discountAmount,
  }) async {
    try {
      // TODO: Implement API call to save quotation
      // For now, just update the status
      Map<String, dynamic> payload = {
        "related_id": inquiryId,
        "user": {
          "id": inquiry.userId,
          "name": inquiry.name,
          "email": inquiry.email,
          "phone": inquiry.phone,
        },
        "meta": {
          "notes": note,
          "basePrice": quotationPrice,
          "isGstEnabled": gstEnabled,
          "discountPercentage": discountPercentage,
          "discountAmount": discountAmount,
          "totalPrice": discountedPrice,
          if (discountPercentage > 0)
            "discountReason": "Buyer's referral points benefit",
          if (gstEnabled) 'gstPercentage': gst,
          if (gstEnabled) 'gstAmount': afterGstPrice,
          "inquiryCustomerId": userId,
          "expectedStartDate": date,
          "propertyDetails": {
            "propertyType": inquiry.meta.propertyType,
            "city": inquiry.meta.city,
            "location": inquiry.meta.location,
            "state": inquiry.meta.state,
            "bhk": inquiry.meta.bhk,
            "carpetArea": inquiry.meta.carpetArea,
            "serviceDescription": inquiry.meta.serviceDescription,
          },
        },
        "price": discountedPrice,
        "status": status.toLowerCase().replaceAll(" ", "_"),
      };

      AppLogger.structured("Contractor quotation Payload", payload);
      final response = await ContractorInquiryService.contractorInquiryService
          .convertInquiryQuotation(payload);

      if (response) {
        refreshList();

        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: 'Quotation submitted successfully',
          contentType: ContentType.success,
        );
        refreshList();
        getFilterData();
      } else {
        if (SubscriptionLimitGuard.consumeHandledState()) return;
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: 'Failed to submit quotation',
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'An error occurred: $e',
        contentType: ContentType.failure,
      );
    }
  }

  @override
  Future<PaginationResponse<ContractorInquiryItem>> fetchItems(int page) async {
    try {
      final user = await SecureStorage.getUserData();
      final userId = user?.user?.id ?? '';

      final response = await ContractorInquiryService.contractorInquiryService
          .fetchContractorInquiry(page: page, filters: filters, id: userId);

      print("Fetched items: ${response.items.length}");
      final filteredItems =
          response.items.where((item) => item.contractorId == userId).toList();
      print("Filtered items: ${filteredItems.length}");
      getFilterData();
      return response;
    } catch (e) {
      print("Exception in fetchItems: $e");
      rethrow;
    }
  }
}
