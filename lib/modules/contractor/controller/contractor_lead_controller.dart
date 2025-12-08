import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/auth/model/user_model.dart';
import 'package:housing_flutter_app/data/network/contractor/service/contractor_lead_service.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';
import '../../../data/network/contractor/model/contractor_lead_model/contractor_lead_model.dart';

class ContractorLeadController extends PaginatedController<ContractorLeadItem>{
  final expandedCards = <String, bool>{}.obs;
  RxMap<String, String> filters = <String, String>{}.obs;
  RxString changeStage=''.obs;
  RxString changeStatus=''.obs;
  RxList<String> sourceList=<String>[].obs;
  final txtTitle = TextEditingController();
  final txtService = TextEditingController();
  final txtClientName = TextEditingController();
  final txtClientEmail = TextEditingController();
  final txtClientPhone = TextEditingController();
  final txtNotes = TextEditingController();
  final txtStartDate = TextEditingController();
  final txtEndDate = TextEditingController();
  DateTime startCreate = DateTime.now();
  DateTime endCreate = DateTime.now();
  RxString leadStatus = ''.obs;
  RxString leadStage = "".obs;
  RxString leadSource = "".obs;


  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> deadline = Rx<DateTime?>(null);

  RxString selectedService = ''.obs;
  /// ---------------- Controllers ----------------
  final txtName = TextEditingController();
  final txtPhone = TextEditingController();
  final txtEmail = TextEditingController();
  final txtEditNotes = TextEditingController();
  /// ---------------- Reactive dropdown values ----------------
  RxString selectedContractor = ''.obs;
  RxString selectedContractorName = ''.obs;
  RxString selectedEditService = ''.obs;
  RxString selectedSource = ''.obs;
  RxString selectedStatus = ''.obs;
  RxString selectedStage = ''.obs;
  RxString selectedServiceId = ''.obs;
  RxString selectedServiceName = ''.obs;
  RxString selectedServiceDescription = ''.obs;
  /// ---------------- Dropdown data lists ----------------
  RxList<String> contractorList = <String>[].obs;
  RxList<String> serviceList = <String>[].obs;
  RxList<String> sourceEditList = <String>[].obs;
  late ContractorLeadItem currentLead;

    void populateLeadData(ContractorLeadItem lead) {

      print("Josn lead Data ${lead.toMap()}");
      currentLead = lead;
      txtName.text = lead.name ?? '';
      txtPhone.text = lead.phone ?? '';
      txtEmail.text = lead.email ?? '';

      selectedContractor.value = lead.customFields?.contractorId ?? '';
      selectedContractorName.value=lead.customFields?.contractorUsername??'';
      print("sdsadgsa Previous ${selectedContractorName.value}");
      selectedServiceId.value = lead.customFields?.serviceId ?? '';
      selectedServiceName.value = lead.customFields?.serviceName ?? '';
      selectedServiceDescription.value = lead.customFields?.serviceDescription ?? '';
      selectedSource.value = capitalizeEachWord(lead.source) ?? '';
      selectedStatus.value =
          capitalizeEachWord(lead.status);

      selectedStage.value =
          capitalizeEachWord(lead.stage);

      print("✅ Lead data populated for edit: ${lead.id}");
    }

  void resetForm() {
    /// 🟢 Clear all add/edit text controllers
    txtTitle.clear();
    txtService.clear();
    txtClientName.clear();
    txtClientEmail.clear();
    txtClientPhone.clear();
    txtNotes.clear();

    txtName.clear();
    txtPhone.clear();
    txtEmail.clear();
    txtEditNotes.clear();

    /// 🟢 Reset all date values
    startDate.value = null;
    deadline.value = null;
    startCreate = DateTime.now();
    endCreate = DateTime.now();

    /// 🟢 Reset all dropdowns
    selectedService.value = '';
    selectedContractor.value = '';
    selectedContractorName.value = '';
    selectedEditService.value = '';
    selectedSource.value = '';
    selectedStatus.value = '';
    selectedStage.value = '';
    selectedServiceId.value = '';
    selectedServiceName.value = '';
    selectedServiceDescription.value = '';

    /// 🟢 Reset current lead
    currentLead = ContractorLeadItem();

    print("✅ Form reset successfully");
  }

  void resetFilters() {
    txtStartDate.clear();
    txtEndDate.clear();
    startCreate = DateTime.now();
    endCreate= DateTime.now();
    leadSource.value = '';
    leadStage.value = '';
    leadStatus.value = '';
    // update();
  }

  void getAllSourceData() {
    sourceList.value = items.value
        .map((e) => e.source ?? '')
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList();
  }

  void setValue<T>(Rx<T> target, T value) {
    target.value = value;
  }
  Future<void> applyFilters(Map<String, String> filter) async {
    filters.assignAll(filter);
    print("Apply Filter in Inquiry Contractor Section ${filters} ");
    // await loadInitial();
    refreshList();
  }
  Future<void> convertIntoProject(String id) async {

    debugPrint("📦 Project Payload => $id");
    if (deadline.value == null || startDate.value == null) {
      Get.snackbar("Error", "Please fill required fields",
          backgroundColor: ColorRes.error.shade100,
          colorText: ColorRes.error.shade700);
      return;
    }


    final payload = getProjectPayload(id);
    debugPrint("📦 Project Payload => $payload");
    final response=await ContractorLeadService.contractorLeadService.convertIntoProject(payload);
    if(response)
      {

        refreshList();
        resetForm();
        Get.back();
      }
  }
  void populateFormFromItem(ContractorLeadItem item) {
    // Safely check keys and assign to controllers
    txtTitle.text = item.name ?? "";
    txtClientName.text = item.name ?? "";
    txtClientEmail.text = item.email ?? "";
    txtClientPhone.text = item.phone ?? "";


      selectedService.value = item.customFields?.serviceName??'';

    debugPrint("✅ Form populated from item: $item");
  }

  Map<String, dynamic> getProjectPayload(String leadId) {
    return {
      "title": txtTitle.text.trim(),
      "startDate": startDate.value?.toUtc().toIso8601String(),
      "deadline": deadline.value?.toUtc().toIso8601String(),
      "leadId": leadId ?? "", // optional or set dynamically
      "client": {
        "name": txtClientName.text.trim(),
        "email": txtClientEmail.text.trim(),
        "phone": txtClientPhone.text.trim(),
      },
      "notes": txtNotes.text.trim(),
    };
  }
  void toggleCard(String id) {
    expandedCards[id] = !(expandedCards[id] ?? false);
    print("toggle Card $id");
    expandedCards.refresh();
  }
  bool isExpanded(String id) => expandedCards[id] ?? false;
  @override
  void onInit() {
    super.onInit();
    // getCategoryService();

    ever(filters, (_) => refreshList());


    loadInitial();

  }
  @override
  Future<PaginationResponse<ContractorLeadItem>> fetchItems(int page) async {
    UserModel user=await SecureStorage.getUserData()??UserModel();
    final userId=user.user?.id??'';
    final response = await ContractorLeadService.contractorLeadService.fetchContractorLead(id: userId,filter: filters.value);
    print("Contractor Lead items: ${response.items.length}");
    getAllSourceData();
    return response;
  }



  void showConvertDialog(ContractorLeadItem item) {
    Get.dialog(
      AlertDialog(
        backgroundColor: ColorRes.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          "Convert to Project",
          style: TextStyle(
            fontWeight: AppFontWeights.semiBold,
            fontSize: AppFontSizes.large,
            color: ColorRes.textColor,
          ),
        ),
        content: Text(
          "Are you sure you want to convert '${item.name}' to a project?",
          style: const TextStyle(
              color: ColorRes.textSecondary, fontSize: AppFontSizes.bodySmall),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel",
                style: TextStyle(color: ColorRes.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ColorRes.green),
            onPressed: () {
              Get.back();
              Get.snackbar(
                "Converted",
                "'${item.name}' converted successfully!",
                backgroundColor: ColorRes.green,
                colorText: ColorRes.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text("Convert", style: TextStyle(color: ColorRes.white)),
          )
        ],
      ),
    );
  }

  void deleteLead(String id, String name) {
    Get.dialog(
      AlertDialog(
        backgroundColor: ColorRes.white,
        title: const Text(
          'Delete Lead',
          style: TextStyle(
            fontSize: AppFontSizes.large,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textColor,
          ),
        ),
        content: Text('Are you sure you want to delete lead for $name?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ColorRes.error),
            onPressed: () {
              Get.back();
              deletedContractorLead(id);
              Get.snackbar(
                'Deleted',
                'Lead deleted successfully',
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
  Future<void> deletedContractorLead(String id) async {
    final response = await ContractorLeadService.contractorLeadService
        .deleteContractorLead(id);
    if (response) {
      refreshList();
    }
  }
  /// 🔹 Build Update Payload to match backend JSON structure
  Map<String, dynamic> getUpdateLeadPayload(String leadId) {

    return {
      "id": leadId,
      "data": {
        "name": txtName.text.trim(),
        "phone": txtPhone.text.trim(),
        "email": txtEmail.text.trim(),
        "source": selectedSource.value.trim().toLowerCase().replaceAll(" ", "_"),
        "status": selectedStatus.value.trim().toLowerCase().replaceAll(" ", "_"),
        "stage": selectedStage.value.trim().toLowerCase().replaceAll(" ", "_"),
        "notes": txtEditNotes.text.trim(),
        "customFields": {
          "contractorId": selectedContractor.value,
          "serviceId": selectedServiceId.value,
          "serviceName": selectedServiceName.value,
        }
      },
      "reseller_id": selectedContractor.value,
      "contractorUsername": selectedContractorName.value
    };
  }
  Future<void> updateLeadDetails(String leadId) async {
    try {
      final payload = getUpdateLeadPayload(leadId);
      debugPrint("🟩 Lead Update Payload => $payload");

      final response = await ContractorLeadService.contractorLeadService
          .updateContractorLead(leadId, payload);

      if (response) {
        Get.snackbar(
          "Success",
          "Lead updated successfully!",
          backgroundColor: ColorRes.green,
          colorText: ColorRes.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        refreshList();
        Get.back();
        resetForm();
      } else {
        Get.snackbar(
          "Error",
          "Failed to update lead.",
          backgroundColor: ColorRes.error.shade100,
          colorText: ColorRes.error.shade700,
        );
      }
    } catch (e, s) {
      debugPrint("🚨 Error in updateLeadDetails: $e\n$s");
      Get.snackbar(
        "Error",
        "Something went wrong while updating.",
        backgroundColor: ColorRes.error.shade100,
        colorText: ColorRes.error.shade700,
      );
    }
  }



  void updateTheStatusAndStage({
    required String leadId,
    String? status,
    String? stage,
  }) async {
    try {
      // 🟦 Prepare payload with only non-null, non-empty values
      final Map<String, dynamic> payload = {};

      if (status != null && status.trim().isNotEmpty) {
        payload['status'] = status.trim().toLowerCase().replaceAll(" ", "_");
      }
      if (stage != null && stage.trim().isNotEmpty) {
        payload['stage'] = stage.trim().toLowerCase().replaceAll(" ", "_");
      }

      if (payload.isEmpty) {
        print("⚠️ No valid status or stage provided to update.");
        Get.snackbar(
          "Warning",
          "Please select at least one value to update.",
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.black87,
        );
        return;
      }

      print("🟩 Payload ready for update: $payload");

      // 🔥 Call the service
      final success = await ContractorLeadService.contractorLeadService
          .updateTheLeadStatusAndStage(payload, leadId);

      if (success) {
        print("✅ Lead updated successfully with $payload");

        Get.snackbar(
          "Updated",
          "Lead status/stage updated successfully.",
          backgroundColor: ColorRes.green,
          colorText: ColorRes.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        refreshList(); // reloads data from API
      } else {
        print("🔴 Failed to update lead with $payload");

        Get.snackbar(
          "Error",
          "Failed to update lead.",
          backgroundColor: ColorRes.error.shade100,
          colorText: ColorRes.error.shade700,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e, stack) {
      print("🚨 Exception in updateTheStatusAndStage: $e");
      print("🧠 Stack trace: $stack");

      Get.snackbar(
        "Error",
        "Something went wrong while updating.",
        backgroundColor: ColorRes.error.shade100,
        colorText: ColorRes.error.shade700,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }



}
String capitalizeEachWord(String? text) {
  if (text == null || text.isEmpty) return '';
  return text
      .split(RegExp(r'\s+|_+')) // split by space or underscore
      .map((word) => word.isNotEmpty
      ? word[0].toUpperCase() + word.substring(1).toLowerCase()
      : '')
      .join(' ');
}