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
  void resetFilters() {
    txtStartDate.clear();
    txtEndDate.clear();
    startDate = DateTime.now();
    endDate = DateTime.now();

    statusChange.value = '';
    // update();
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

  Future<void> updateChangeStatus(String id,String status,String dateUpdate)
  async {
    log("dgfysgfysdgfysd ${dateUpdate}");
    // 🟦 Prepare payload with only non-null, non-empty values
    final Map<String, dynamic> payload = {};

    if (status != null && status.trim().isNotEmpty) {
      payload['status'] = status.trim().toLowerCase().replaceAll(" ", "_");
    }
    if (dateUpdate != null && dateUpdate.isNotEmpty) {
      payload['deadline'] = dateUpdate;
    }

    if (payload.isEmpty) {
      print("⚠️ No valid status or date provided to update.");
      Get.snackbar(
        "Warning",
        "Please select at least one value to update.",
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.black87,
      );
      return;
    }

    print("🟩 Payload ready for update: $payload");

    final date=await ContractorProjectService.contractorProjectService.updateStatus(payload, id);
    if(date){
      refreshList();
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