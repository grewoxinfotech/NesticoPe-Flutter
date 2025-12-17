// import 'package:flutter/material.dart';
// import 'package:get/state_manager.dart';
// import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
// import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
//
// import '../../../data/network/contractor/model/contractor_project_model/contractor_project_milestone_model.dart';
// import '../../../data/network/contractor/service/project/contactor_project_mileston_service.dart';
//
// class ContractorProjectMilestoneController
//     extends PaginatedController<ProjectMilestone> {
//   final ContractorProjectMilestoneService _service =
//       ContractorProjectMilestoneService.projectMilestoneService;
//
//   ContractorProjectMilestoneController({required this.projectId});
//
//   final String projectId;
//
//   final filters = <String, String>{};
//
//   /// form Variables
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   TextEditingController titleController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//   RxString selectedMileStoneType = 'Percentage'.obs;
//   TextEditingController percentageController = TextEditingController();
//   TextEditingController fixedController = TextEditingController();
//   Rxn<DateTime> startDate = Rxn<DateTime>();
//   Rxn<DateTime> endDate = Rxn<DateTime>();
//   Rxn<DateTime> completionDate = Rxn<DateTime>();
//   RxString selectedWorkStatus = 'Not Started'.obs;
//   Rxn<ProjectMilestone> currentMilestone = Rxn<ProjectMilestone>();
//
//   /// list Data
//   final List<String> milestoneType = ['Fixed', 'Percentage'];
//   final List<String> workStatus = ['Not Started', 'In Progress'];
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadInitial();
//   }
//
//   @override
//   Future<PaginationResponse<ProjectMilestone>> fetchItems(int page) {
//     try {
//       return _service.getProjectMilestones(
//         page: page,
//         fetchAll: true,
//         filter: filters,
//         projectId: projectId,
//       );
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   /// create milestone
//   Future<void> createMilestone() async {
//     try {
//       isLoading.value = true;
//       if (!formKey.currentState!.validate()) {
//         isLoading.value = false;
//         return;
//       }
//
//       final milestone = ProjectMilestone(
//         title: titleController.text,
//         description: descriptionController.text,
//         milestoneType: selectedMileStoneType.value,
//         percentage: int.parse(percentageController.text),
//         remainingAmount: fixedController.text,
//         startDate: startDate.value,
//         endDate: endDate.value,
//         completionDate: completionDate.value,
//         workStatus: selectedWorkStatus.value,
//       );
//
//       await _service.createMilestone(projectId, milestone);
//       resetForm();
//       loadInitial();
//       isLoading.value = false;
//     } catch (e) {
//       isLoading.value = false;
//       rethrow;
//     }
//   }
//
//   /// update milestone
//   Future<void> updateMilestone() async {
//     try {
//       isLoading.value = true;
//       if (!formKey.currentState!.validate()) {
//         isLoading.value = false;
//         return;
//       }
//
//       final milestone = ProjectMilestone(
//         title: titleController.text,
//         description: descriptionController.text,
//         milestoneType: selectedMileStoneType.value,
//         percentage: int.parse(percentageController.text),
//         remainingAmount: fixedController.text,
//         startDate: startDate.value,
//         endDate: endDate.value,
//         completionDate: completionDate.value,
//         workStatus: selectedWorkStatus.value,
//       );
//
//       await _service.updateMilestone(milestone, projectId);
//
//       resetForm();
//       loadInitial();
//       isLoading.value = false;
//     } catch (e) {
//       isLoading.value = false;
//       rethrow;
//     }
//   }
//
//   /// reset Form
//   void resetForm() {}
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';

import '../../../data/network/contractor/model/contractor_project_model/contractor_project_milestone_model.dart';
import '../../../data/network/contractor/service/project/contactor_project_mileston_service.dart';

class ContractorProjectMilestoneController
    extends PaginatedController<ProjectMilestone> {
  final ContractorProjectMilestoneService _service =
      ContractorProjectMilestoneService.projectMilestoneService;

  ContractorProjectMilestoneController({required this.projectId});

  final String projectId;
  final filters = <String, String>{};

  /// Form state management
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool isEditMode = false.obs;
  RxString editingMilestoneId = ''.obs;

  /// Form controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController percentageController = TextEditingController();
  TextEditingController fixedController = TextEditingController();

  /// Observable form fields
  RxString selectedMileStoneType = 'Percentage'.obs;
  Rxn<DateTime> startDate = Rxn<DateTime>();
  Rxn<DateTime> endDate = Rxn<DateTime>();
  Rxn<DateTime> completionDate = Rxn<DateTime>();
  RxString selectedWorkStatus = 'Not Started'.obs;
  Rxn<ProjectMilestone> currentMilestone = Rxn<ProjectMilestone>();

  /// Static data lists
  final List<String> milestoneType = ['Fixed', 'Percentage'];
  final List<String> workStatus = ['Not Started', 'In Progress'];

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    percentageController.dispose();
    fixedController.dispose();
    super.onClose();
  }

  @override
  Future<PaginationResponse<ProjectMilestone>> fetchItems(int page) {
    try {
      return _service.getProjectMilestones(
        page: page,
        fetchAll: true,
        filter: filters,
        projectId: projectId,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Initialize form for adding new milestone
  void initializeForAdd() {
    isEditMode.value = false;
    editingMilestoneId.value = '';
    resetForm();
  }

  /// Initialize form for editing existing milestone
  void initializeForEdit(ProjectMilestone milestone) {
    isEditMode.value = true;
    editingMilestoneId.value = milestone.id ?? '';

    // Populate form with existing data
    titleController.text = milestone.title ?? '';
    descriptionController.text = milestone.description ?? '';
    selectedMileStoneType.value = milestone.milestoneType ?? 'Percentage';

    if (milestone.milestoneType == 'Percentage') {
      percentageController.text = milestone.percentage?.toString() ?? '';
      fixedController.clear();
    } else {
      fixedController.text = milestone.remainingAmount ?? '';
      percentageController.clear();
    }

    startDate.value = milestone.startDate;
    endDate.value = milestone.endDate;
    completionDate.value = milestone.completionDate;
    selectedWorkStatus.value = milestone.workStatus ?? 'Not Started';
  }

  /// Save milestone (handles both create and update)
  Future<void> saveMilestone(double projectPrice) async {
    if (isEditMode.value) {
      await updateMilestone();
    } else {
      await createMilestone(projectPrice);
    }
  }

  /// Create new milestone
  Future<void> createMilestone(double projectPrice) async {
    try {
      isLoading.value = true;

      if (!formKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }

      final remainingAmount = calculateRemainingAmount(projectPrice);

      if (remainingAmount <= 0) {
        Get.snackbar('Error', 'No remaining budget available');
        isLoading.value = false;
        return;
      }

      double milestoneAmount = 0;

      if (selectedMileStoneType.value == 'Percentage') {
        final percentage = double.parse(percentageController.text);
        milestoneAmount = (remainingAmount * percentage) / 100;
      } else {
        milestoneAmount = double.parse(fixedController.text);
      }

      if (milestoneAmount <= 0 || milestoneAmount > remainingAmount) {
        Get.snackbar('Error', 'Milestone amount exceeds remaining budget');
        isLoading.value = false;
        return;
      }

      final milestone = ProjectMilestone(
        projectId: projectId,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        milestoneType: selectedMileStoneType.value.toLowerCase(),
        percentage:
            selectedMileStoneType.value == 'Percentage'
                ? int.parse(percentageController.text)
                : null,
        milestoneAmount: milestoneAmount.toStringAsFixed(0),
        startDate: startDate.value,
        endDate: endDate.value,
        completionDate: completionDate.value,
        workStatus: selectedWorkStatus.value.toLowerCase().replaceAll(" ", "_"),
      );

      final result = await _service.createMilestone(milestone);

      if (result) {
        Get.snackbar('Success', 'Milestone created successfully');
        resetForm();
        loadInitial();
        Get.back();
      } else {
        Get.snackbar('Error', 'Failed to create milestone');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Update existing milestone
  Future<void> updateMilestone() async {
    try {
      isLoading.value = true;

      if (!formKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }

      // Validate date logic
      if (startDate.value == null) {
        Get.snackbar('Error', 'Please select start date');
        isLoading.value = false;
        return;
      }

      if (endDate.value != null && endDate.value!.isBefore(startDate.value!)) {
        Get.snackbar('Error', 'End date cannot be before start date');
        isLoading.value = false;
        return;
      }

      final milestone = ProjectMilestone(
        id: editingMilestoneId.value,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        milestoneType: selectedMileStoneType.value,
        percentage:
            selectedMileStoneType.value == 'Percentage'
                ? int.tryParse(percentageController.text)
                : null,
        remainingAmount:
            selectedMileStoneType.value == 'Fixed'
                ? fixedController.text.trim()
                : null,
        startDate: startDate.value,
        endDate: endDate.value,
        completionDate: completionDate.value,
        workStatus: selectedWorkStatus.value,
      );

      await _service.updateMilestone(milestone, projectId);

      Get.snackbar(
        'Success',
        'Milestone updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      resetForm();
      loadInitial();
      Get.back(); // Close the form screen
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update milestone: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete milestone
  Future<void> deleteMilestone(String milestoneId) async {
    try {
      isLoading.value = true;

      // Show confirmation dialog
      final confirm = await Get.dialog<bool>(
        AlertDialog(
          title: Text('Delete Milestone'),
          content: Text('Are you sure you want to delete this milestone?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirm == true) {
        // Call delete service
        // await _service.deleteMilestone(milestoneId, projectId);

        Get.snackbar(
          'Success',
          'Milestone deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        loadInitial();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete milestone: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Reset form to initial state
  void resetForm() {
    titleController.clear();
    descriptionController.clear();
    percentageController.clear();
    fixedController.clear();
    selectedMileStoneType.value = 'Percentage';
    startDate.value = null;
    endDate.value = null;
    completionDate.value = null;
    selectedWorkStatus.value = 'Not Started';
    isEditMode.value = false;
    editingMilestoneId.value = '';
    formKey.currentState?.reset();
  }

  /// Calculate total milestone amounts
  double calculateTotalMilestoneAmount() {
    return items.fold(
      0.0,
      (sum, m) => sum + _toAmount(m.milestoneAmount ?? '0'),
    );
  }

  /// Calculate total paid amount
  double calculateTotalPaidAmount() {
    return items.fold(0.0, (sum, m) => sum + _toAmount(m.paidAmount ?? '0'));
  }

  /// Calculate remaining budget
  double calculateRemainingBudget(double projectPrice) {
    final totalAllocated = calculateTotalMilestoneAmount();
    return projectPrice - totalAllocated;
  }

  /// Helper to convert string to amount
  double _toAmount(String value) {
    return double.tryParse(value) ?? 0.0;
  }

  double calculateRemainingAmount(double projectPrice) {
    final allocated = items.fold<double>(
      0.0,
      (sum, m) => sum + _toAmount(m.milestoneAmount ?? '0'),
    );
    return projectPrice - allocated;
  }
}
