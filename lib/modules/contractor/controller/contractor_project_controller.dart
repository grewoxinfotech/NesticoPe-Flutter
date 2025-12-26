import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/auth/model/user_model.dart';
import 'package:housing_flutter_app/data/network/contractor/model/contractor_project_model/contracto_project_model.dart';
import 'package:housing_flutter_app/data/network/contractor/service/project/contractor_project_service.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_lead_controller.dart';
import 'package:intl/intl.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';

class ContractorProjectController extends PaginatedController<ContractorProjectItem>{
  RxMap<String, String> filters = <String, String>{}.obs;
  final expandedCards = <String, bool>{}.obs;
  RxString changeStatus=''.obs;
  final txtTime=TextEditingController();
  final txtStartDate = TextEditingController();
  final txtEndDate = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  RxString statusChange = "".obs;
  DateTime? selectedDate;
  void toggleCard(String id) {
    expandedCards[id] = !(expandedCards[id] ?? false);
    print("toggle Card $id");
    expandedCards.refresh();
  }
  Future<void> fetchContractorProjects() async {
    try {
      isLoading.value = true;
      final user = await SecureStorage.getUserData();
      final userId = user?.user?.id ?? '';

      final response = await ContractorProjectService.contractorProjectService
          .getContractorProjectData(contractorId: userId, filter: filters);

      if (response.items.isNotEmpty) {
        items.assignAll(response.items); // ✅ reactive update
        items.refresh(); // ensure UI rebuild
        log("✅ Projects list updated: ${items.length} projects loaded");
      } else {
        items.clear();
      }
    } catch (e, s) {
      log("❌ Error fetching projects: $e\n$s");
    } finally {
      isLoading.value = false;
    }
  }

  void resetFilters() {
    txtStartDate.clear();
    txtEndDate.clear();
    startDate = DateTime.now();
    endDate = DateTime.now();

    statusChange.value = '';
    // update();
  }
  Future<void> refreshProject() async {
    try {
      isRefreshing.value = true;
      refreshList();
      await Future.delayed(const Duration(seconds: 1));

      // Update metrics with new values
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh',
        backgroundColor: Colors.red,
        colorText: ColorRes.white,
      );
    } finally {
      isRefreshing.value = false;
    }
  }
  Future<void> applyFilters(Map<String, String> filter) async {
    filters.assignAll(filter);
    log("Apply Filter in Inquiry Contractor Section ${filters} ");
    // await loadInitial();
    refreshList();
  }
  bool isExpanded(String id) => expandedCards[id] ?? false;

  @override
  void onInit() {
    super.onInit();
    ever(filters, (_) => refreshList());

    loadInitial();
  }
  void resetChangeStatus()
  {
    selectedDate=null;
    changeStatus.value='';
  }
  void setValue<T>(Rx<T> target, T value) {
    target.value = value;
  }
  void populatedProjectData(ContractorProjectItem project) {
    if (project.deadline != null && project.deadline!.isNotEmpty) {
      selectedDate = DateTime.tryParse(project.deadline!);
      log("String Date Timer Convert $selectedDate  ============ ${project.deadline}");

      if (selectedDate != null) {
        // 👇 Update the text controller so the UI shows it
        txtTime.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
      }
    } else {
      txtTime.clear();
    }

    changeStatus.value = capitalizeEachWord(project.status);
  }




  Future<void> deleteFollowUpByID(String id) async {
    final response=await ContractorProjectService.contractorProjectService.deletedProject(id);
    if(response){
      refreshList();
    }
  }

  void deleteLead(String id, String name) {
    Get.dialog(
      AlertDialog(
        backgroundColor: ColorRes.white,
        title: const Text(
          'Delete Follow Up',
          style: TextStyle(
            fontSize: AppFontSizes.large,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textColor,
          ),
        ),
        content: Text('Are you sure you want to delete Project for $name?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ColorRes.error),
            onPressed: () {
              Get.back();
              Get.back();
              deleteFollowUpByID(id);
              Get.snackbar(
                'Deleted',
                'Follow Up deleted successfully',
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

  // Future<void> updateChangeStatus(String id,String status,String dateUpdate)
  // async {
  //   log("dgfysgfysdgfysd ${dateUpdate}");
  //   // 🟦 Prepare payload with only non-null, non-empty values
  //   final Map<String, dynamic> payload = {};
  //
  //   if (status != null && status.trim().isNotEmpty) {
  //     payload['status'] = status.trim().toLowerCase().replaceAll(" ", "_");
  //   }
  //   if (dateUpdate != null && dateUpdate.isNotEmpty) {
  //     payload['deadline'] = dateUpdate;
  //   }
  //
  //   if (payload.isEmpty) {
  //     print("⚠️ No valid status or date provided to update.");
  //     Get.snackbar(
  //       "Warning",
  //       "Please select at least one value to update.",
  //       backgroundColor: Colors.orange.shade100,
  //       colorText: Colors.black87,
  //     );
  //     return;
  //   }
  //
  //   print("🟩 Payload ready for update: $payload");
  //
  //   final date=await ContractorProjectService.contractorProjectService.updateStatus(payload, id);
  //   if(date){
  //     refreshList();
  //   }
  // }
  // In ContractorProjectController
  Future<void> updateChangeStatus(
      String id,
      String status,
      String dateUpdate
      ) async {
    log("Updating project: $dateUpdate");

    final Map<String, dynamic> payload = {};

    if (status.trim().isNotEmpty) {
      payload['status'] = status.trim().toLowerCase().replaceAll(" ", "_");
    }
    if (dateUpdate.isNotEmpty) {
      payload['deadline'] = dateUpdate;
    }

    if (payload.isEmpty) {
      Get.snackbar(
        "Warning",
        "Please select at least one value to update.",
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.black87,
      );
      return;
    }

    final success = await ContractorProjectService
        .contractorProjectService
        .updateStatus(payload, id);

    if (success) {
      // Option A: Refresh entire list
      await refreshList();

      // Option B: Update specific item locally (faster UI update)
      final index = items.indexWhere((item) => item.id == id);
      if (index != -1) {
        // Create updated project object
        final updatedProject = items[index].copyWith(
          status: payload['status'],
          deadline: payload['deadline'],
        );
        items[index] = updatedProject;
        items.refresh(); // Trigger Obx update
      }

      Get.snackbar(
        "Success",
        "Project updated successfully",
        backgroundColor: ColorRes.green.shade100,
        colorText: ColorRes.green.shade700,
      );
    }
  }

  @override
  Future<PaginationResponse<ContractorProjectItem>> fetchItems(int page) async {
    // TODO: implement fetchItems
    final UserModel user= await SecureStorage.getUserData()??UserModel();
    final userId=user.user?.id;
    final response= await ContractorProjectService.contractorProjectService.getContractorProjectData(contractorId: userId??'',filter: filters);

    return response;
  }

}