import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/data/network/contractor/service/contractor_inquiry_service.dart';

import '../../../app/care/pagination/controller/pagination_controller.dart';
import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';
import '../../../data/database/secure_storage_service.dart';
import '../../../data/network/auth/model/user_model.dart';
import '../../../data/network/contractor/model/contractot_service_model/contractor_inquiry_model.dart';

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
      Get.snackbar(
        'Status Updated',
        colorText: ColorRes.white,
        backgroundColor: ColorRes.green,
        'Status changed to $newStatus',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      refreshList();
      getFilterData();
    } else {
      Get.snackbar(
        'Status Update Failed',
        colorText: ColorRes.white,
        backgroundColor: ColorRes.error,
        'Could not change status to $newStatus',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
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
      getFilterData();
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
              Get.snackbar(
                'Deleted',
                'Inquiry deleted successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: ColorRes.error,
                colorText: ColorRes.white,
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
      Get.snackbar(
        'Error',
        'No services available to convert',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorRes.error,
        colorText: ColorRes.white,
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
      Get.snackbar(
        'Info',
        'All services are already converted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorRes.warning,
        colorText: ColorRes.white,
      );
      return;
    }

    // ✅ CASE 1: Only one unconverted service — directly convert
    if (unconvertedServices.length == 1) {
      final service = unconvertedServices.first;
      convertIntoLead(item, service.serviceId, service.serviceName);
      Get.snackbar(
        'Success',
        'Converted "${service.serviceName}" to lead successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorRes.success,
        colorText: ColorRes.white,
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
                 Text('Select one service to convert:',style: TextStyle(
              fontSize: AppFontSizes.small,
              fontWeight: AppFontWeights.medium,
              color: ColorRes.textSecondary,
            ),),
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
                Get.snackbar(
                  'Error',
                  'Please select one service',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              Get.back();
              await convertIntoLead(
                item,
                selectedServiceId.value,
                selectedServiceName.value,
              );

              Get.snackbar(
                'Success',
                'Converted "${selectedServiceName.value}" to lead successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: ColorRes.success,
                colorText: ColorRes.white,
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
