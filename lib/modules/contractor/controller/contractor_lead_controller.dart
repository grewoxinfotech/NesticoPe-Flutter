import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/auth/model/user_model.dart';
import 'package:nesticope_app/data/network/contractor/service/contractor_lead_service.dart';
import 'package:nesticope_app/utils/logger/app_logger.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';
import '../../../data/network/contractor/model/contractor_lead_model/contractor_lead_model.dart';
import '../../../data/network/contractor/model/contractor_project_model/contracto_project_model.dart';
import '../../../data/network/contractor/model/employee/contractor_employee_model.dart';
import '../../../data/network/contractor/service/project/contractor_project_service.dart';
import '../../../widgets/messages/snack_bar.dart';
import '../../reseller/view/lead_overview/widget/lead_follow_up_screen.dart';
import 'contractor_project_controller.dart';
import 'contractot_employee_controller.dart';

class ContractorLeadController extends PaginatedController<ContractorLeadItem> {
  final expandedCards = <String, bool>{}.obs;
  RxMap<String, String> filters = <String, String>{}.obs;
  RxString changeStage = ''.obs;

  RxString changeStatus = ''.obs;
  RxList<String> sourceList = <String>[].obs;
  final txtTitle = TextEditingController();
  final txtService = TextEditingController();
  final txtClientName = TextEditingController();
  final txtClientEmail = TextEditingController();
  final txtClientPhone = TextEditingController();
  final txtNotes = TextEditingController();
  final txtProjectPrice = TextEditingController();
  final txtStartDate = TextEditingController();
  final selectedPropertyType = ''.obs;
  final txtClientCity = TextEditingController();
  final txtClientLocation = TextEditingController();
  final txtClientState = TextEditingController();
  final txtCarpetArea = TextEditingController();

  final txtEndDate = TextEditingController();
  DateTime startCreate = DateTime.now();
  DateTime endCreate = DateTime.now();
  final selectedEmployees = <ContractorEmployeeItem>[].obs;

  RxString leadStatus = ''.obs;
  RxString leadStage = "".obs;
  RxString leadSource = "".obs;

  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> deadline = Rx<DateTime?>(null);

  RxString selectedService = ''.obs;
  ContractorProjectController controller = ContractorProjectController();

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
  RxString quotationId = "".obs;
  RxString quotationPrice = "".obs;
  RxBool isConvertedToProject = false.obs;

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
    /*txtNotes.text=lead*/

    selectedContractor.value = lead.customFields?.contractorId ?? '';
    selectedContractorName.value = lead.customFields?.contractorUsername ?? '';
    print("sdsadgsa Previous ${selectedContractorName.value}");
    selectedServiceId.value = lead.customFields?.serviceId?.trim() ?? '';

    selectedServiceName.value = lead.customFields?.serviceName ?? '';
    selectedServiceDescription.value =
        lead.customFields?.serviceDescription ?? '';
    quotationId.value = lead.customFields?.quotationId ?? '';
    quotationPrice.value = lead.customFields?.quotationPrice.toString() ?? '';
    isConvertedToProject.value =
        lead.customFields?.isConvertedToProject ?? false;
    print(
      "Edit of lead in contractor ${selectedServiceName.value} = == = = === = == = =  =${selectedServiceId.value}",
    );
    selectedSource.value = capitalizeEachWord(lead.source) ?? '';
    selectedStatus.value = capitalizeEachWord(lead.status);

    selectedStage.value = capitalizeEachWord(lead.stage);

    print("✅ Lead data populated for edit: ${lead.id}");
  }

  void populateProjectForm(ContractorProjectItem item) {
    try {
      debugPrint("🟢 Populating project form from project: ${item.id}");

      // ---------------- Basic Text Fields ----------------
      txtTitle.text = item.title ?? '';
      txtClientName.text = item.client.name ?? '';
      txtClientEmail.text = item.client.email ?? '';
      txtClientPhone.text = item.client.phone ?? '';
      txtProjectPrice.text = item.projectPrice?.toString() ?? '';
      txtNotes.text = item.notes ?? '';

      // ---------------- Client Additional Fields ----------------
      selectedPropertyType.value = item.client.propertyType ?? '';
      txtClientCity.text = item.client.city ?? '';
      txtClientLocation.text = item.client.location ?? '';
      txtClientState.text = item.client.state ?? '';
      txtCarpetArea.text = item.client.carpetArea?.toString() ?? '';
      selectedServiceDescription.value = item.client.serviceDescription ?? '';

      // ---------------- Service Info ----------------
      selectedService.value = item.meta?.serviceName ?? '';
      selectedServiceId.value = item.meta?.serviceId ?? '';
      selectedServiceName.value = item.meta?.serviceName ?? '';

      // ---------------- Dates ----------------
      if (item.startDate != null) {
        startDate.value = DateTime.tryParse(item.startDate ?? '');
      }
      if (item.deadline != null) {
        deadline.value = DateTime.tryParse(item.deadline ?? '');
      }

      // ---------------- Employees ----------------

      selectedEmployees.clear();
      final employeesFromMeta = item.meta?.employees ?? [];

      if (employeesFromMeta.isNotEmpty) {
        final employeeIds =
            employeesFromMeta.map((e) => e.id).whereType<String>().toList();
        final controllerEmployee = Get.find<ContractorEmployeeController>();
        if (controllerEmployee.items.isNotEmpty) {
          final matchedEmployees =
              controllerEmployee.items
                  .where((emp) => employeeIds.contains(emp.id))
                  .toList();

          selectedEmployees.assignAll(matchedEmployees);
          debugPrint(
            "✅ Populated ${selectedEmployees.length} employees from project meta",
          );
        } else {
          debugPrint(
            "⚠️ Employee controller list is empty — cannot match IDs yet",
          );
        }
      } else {
        debugPrint("⚠️ No employees found in project meta");
      }

      debugPrint("✅ Project form populated successfully for edit.");
    } catch (e, s) {
      debugPrint("🚨 Error populating project form: $e\n$s");
    }
  }

  Future<void> refreshLead() async {
    try {
      isRefreshing.value = true;
      refreshList();
      await Future.delayed(const Duration(seconds: 1));

      // Update metrics with new values
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to refresh',
        contentType: ContentType.failure,
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  void resetForm() {
    /// 🟢 Clear all add/edit text controllers
    txtTitle.clear();
    txtService.clear();
    txtClientName.clear();
    txtClientEmail.clear();
    txtClientPhone.clear();
    txtNotes.clear();
    txtProjectPrice.clear();
    txtName.clear();
    txtPhone.clear();
    txtEmail.clear();
    txtEditNotes.clear();
    selectedEmployees.clear();

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
    endCreate = DateTime.now();
    leadSource.value = '';
    leadStage.value = '';
    leadStatus.value = '';
    // update();
  }

  void getAllSourceData() {
    sourceList.value =
        items.value
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
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Please fill required fields",
        contentType: ContentType.failure,
      );
      return;
    }

    final payload = getProjectPayload(id);
    debugPrint("📦 Project Payload => $payload");
    final response = await ContractorLeadService.contractorLeadService
        .convertIntoProject(payload);
    if (response) {
      items.removeWhere((element) => element.id == id);
      items.refresh();

      controller.items.refresh();
      controller.refreshList();
      // refreshList();
      try {
        final projectController = Get.find<ContractorProjectController>();
        await projectController.fetchContractorProjects();
        items.removeWhere((element) => element.id == id);
        print("✅ Contractor projects refreshed after conversion");
      } catch (e) {
        print("⚠️ Could not refresh projects: $e");
      }
      resetForm();
      Get.back();
    }
  }

  Future<void> updateProject(String id) async {
    debugPrint("📦 Project Payload => $id");
    if (deadline.value == null || startDate.value == null) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Please fill required fields",
        contentType: ContentType.failure,
      );
      return;
    }

    final payload = updateProjectPayload();
    debugPrint("📦 Project Payload => $payload");
    final response = await ContractorProjectService.contractorProjectService
        .updateProject(payload, id);
    if (response) {
      items.refresh();
      refreshList();
      try {
        final projectController = Get.find<ContractorProjectController>();
        await projectController.fetchContractorProjects();
        print("✅ Contractor projects refreshed after conversion");
      } catch (e) {
        print("⚠️ Could not refresh projects: $e");
      }
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
    txtProjectPrice.text = item.customFields?.quotationPrice.toString() ?? '';

    selectedService.value = item.customFields?.serviceName ?? '';

    debugPrint("✅ Form populated from item: $item");
  }

  Map<String, dynamic> getProjectPayload(String leadId) {
    return {
      "title": txtTitle.text.trim(),
      "startDate": startDate.value?.toUtc().toIso8601String(),
      "deadline": deadline.value?.toUtc().toIso8601String(),
      "leadId": leadId,
      "price": txtProjectPrice.text.trim(),
      "client": {
        "name": txtClientName.text.trim(),
        "email": txtClientEmail.text.trim(),
        "phone": txtClientPhone.text.trim(),
      },
      "notes": txtNotes.text.trim(),
      "meta": {
        "employees":
            selectedEmployees
                .map((e) => {"id": e.id})
                .toList(), // ✅ matches your backend structure
      },
    };
  }

  Map<String, dynamic> updateProjectPayload() {
    debugPrint("🟢 Updating project payload");
    debugPrint("🟢 Updating $startDate    ------ $deadline");

    return {
      "title": txtTitle.text.trim(),
      "startDate":
          "${startDate.value?.year}-${startDate.value?.month}-${startDate.value?.day}",
      "deadline":
          "${deadline.value?.year}-${deadline.value?.month}-${deadline.value?.day}",

      "price": txtProjectPrice.text.trim(),
      "notes": txtNotes.text.trim(),
      "client": {
        "name": txtClientName.text.trim(),
        "email": txtClientEmail.text.trim(),
        "phone": txtClientPhone.text.trim(),
        "propertyType": selectedPropertyType.value,
        // add a reactive dropdown/controller
        "city": txtClientCity.text.trim(),
        "location": txtClientLocation.text.trim(),
        "state": txtClientState.text.trim(),
        "carpetArea": int.tryParse(txtCarpetArea.text.trim()) ?? 0,
        "serviceDescription": selectedServiceDescription.value,
      },
      "meta": {
        "employees":
            selectedEmployees
                .map((e) => {"id": e.id})
                .toList(), // your current logic is fine
        "serviceId": selectedServiceId.value,
        "serviceName": selectedServiceName.value,
      },
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
    UserModel user = await SecureStorage.getUserData() ?? UserModel();
    final userId = user.user?.id ?? '';
    final response = await ContractorLeadService.contractorLeadService
        .fetchContractorLead(
          id: userId,
          filter: filters.value,
          isConverted: false,
        );
    print("Contractor Lead items: ${response.items.length}");
    getAllSourceData();
    return response;
  }

  void showConvertDialog(ContractorLeadItem item) {
    Get.dialog(
      AlertDialog(
        backgroundColor: ColorRes.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            color: ColorRes.textSecondary,
            fontSize: AppFontSizes.bodySmall,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Cancel",
              style: TextStyle(color: ColorRes.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ColorRes.green),
            onPressed: () {
              Get.back();

              NesticoPeSnackBar.showAwesomeSnackbar(
                title: "Converted",
                message: "'${item.name}' converted successfully!",
                contentType: ContentType.success,
              );
            },
            child: const Text(
              "Convert",
              style: TextStyle(color: ColorRes.white),
            ),
          ),
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
              deletedContractorLead(id);
              Navigator.of(Get.context!).pop();

              NesticoPeSnackBar.showAwesomeSnackbar(
                title: "Deleted",
                message: 'Lead deleted successfully',
                contentType: ContentType.success,
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
        "contractorUsername": selectedContractorName.value,
        "serviceDescription": selectedServiceDescription.value,
        "quotationId": quotationId.value,
        "quotationPrice": quotationPrice.value,
        "isConvertedToProject": isConvertedToProject.value,
      },
      "reseller_id": selectedContractor.value,
    };

    /*  "contractorUsername": selectedContractorName.value,*/
  }

  Future<void> updateLeadDetails(String leadId) async {
    try {
      final payload = getUpdateLeadPayload(leadId);
      AppLogger.structured("🟩 Lead Update Payload =>", payload);

      final response = await ContractorLeadService.contractorLeadService
          .updateContractorLead(leadId, payload);

      if (response) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Success",
          message: "Lead updated successfully!",
          contentType: ContentType.success,
        );
        refreshList();
        Get.back();
        resetForm();
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Error",
          message: "Failed to update lead.",
          contentType: ContentType.failure,
        );
      }
    } catch (e, s) {
      debugPrint("🚨 Error in updateLeadDetails: $e\n$s");

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: "Something went wrong while updating.",
        contentType: ContentType.failure,
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

        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Warning",
          message: "Please select at least one value to update.",
          contentType: ContentType.warning,
        );
        return;
      }

      print("🟩 Payload ready for update: $payload");

      // 🔥 Call the service
      final success = await ContractorLeadService.contractorLeadService
          .updateTheLeadStatusAndStage(payload, leadId);

      if (success) {
        print("✅ Lead updated successfully with $payload");

        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Updated",
          message: "Lead status/stage updated successfully.",
          contentType: ContentType.success,
        );

        refreshList(); // reloads data from API
      } else {
        print("🔴 Failed to update lead with $payload");

        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Error",
          message: "Failed to update lead.",
          contentType: ContentType.failure,
        );
      }
    } catch (e, stack) {
      print("🚨 Exception in updateTheStatusAndStage: $e");
      print("🧠 Stack trace: $stack");

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: "Something went wrong while updating.",
        contentType: ContentType.failure,
      );
    }
  }
}
