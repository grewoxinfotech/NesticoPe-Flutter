import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';

import '../../../data/network/contractor/model/contractor_project_model/contractor_project_milestone_model.dart';
import '../../../data/network/contractor/model/contractor_project_model/contractor_project_payment_model.dart';
import '../../../data/network/contractor/service/project/contactor_project_mileston_service.dart';
import '../../../data/network/contractor/service/project/contractor_project_payment_service.dart';

class ContractorProjectMilestonePaymentController
    extends PaginatedController<MilestonePaymentItem> {
  ContractorProjectMilestonePaymentController({required this.projectId});

  /// 🔹 Project
  final String projectId;

  /// 🔹 Services
  final MilestonePaymentService service = MilestonePaymentService.instance;
  final ContractorProjectMilestoneService milestoneService =
      ContractorProjectMilestoneService.projectMilestoneService;

  /// 🔹 Form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool isEditMode = false.obs;
  RxString editingPaymentId = ''.obs;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController referenceNoteController = TextEditingController();

  /// 🔹 Dropdown / Date State
  final RxString selectedMilestoneId = ''.obs;
  final RxString selectedPaymentMode = 'Cash'.obs;
  final RxString selectedPaymentStatus = 'Pending'.obs;
  final Rx<DateTime?> paidOn = Rx<DateTime?>(null);

  /// 🔹 Dropdown Data
  final RxList<ProjectMilestone> milestones = <ProjectMilestone>[].obs;

  final List<String> paymentModes = const [
    'Cash',
    'Cheque',
    'Bank Transfer',
    'UPI',
  ];

  final List<String> paymentStatus = const [
    'Pending',
    'Success',
    'Failed',
    'Refunded',
  ];

  /// 🔹 UI State
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitial();
    fetchMilestones();
  }

  /// 🔹 Pagination Fetch
  @override
  Future<PaginationResponse<MilestonePaymentItem>> fetchItems(int page) async {
    try {
      return await service.getMilestonePayments(
        page: page,
        fetchAll: true,
        projectId: projectId,
      );
    } catch (e) {
      log("Exception in fetchItems: $e");
      rethrow;
    }
  }

  /// 🔹 Initialize for Add
  void initializeForAdd() {
    isEditMode.value = false;
    editingPaymentId.value = '';
    resetForm();
  }

  /// 🔹 Initialize for Edit
  void initializeForEdit(MilestonePaymentItem payment) {
    isEditMode.value = true;
    editingPaymentId.value = payment.id ?? '';

    // Pre-populate form fields
    selectedMilestoneId.value = payment.milestoneId ?? '';
    amountController.text = payment.amount ?? '0.00';

    // Capitalize first letter for dropdown match
    selectedPaymentMode.value =
        payment.paymentMode?.replaceAll("_", " ").capitalize.toString() ?? '';
    selectedPaymentStatus.value =
        payment.paymentStatus?.replaceAll("_", " ").capitalize.toString() ?? '';

    paidOn.value = payment.paidOn;
    referenceNoteController.text = payment.referenceNote ?? '';
  }

  /// 🔹 Save (Create or Update)
  Future<void> saveMilestone() async {
    if (isEditMode.value) {
      await updateMilestone();
    } else {
      await createMilestone();
    }
  }

  /// 🔹 Fetch Milestones (for dropdown)
  Future<void> fetchMilestones() async {
    try {
      final response = await milestoneService.getProjectMilestones(
        projectId: projectId,
        fetchAll: true,
      );

      milestones.assignAll(response.items);
    } catch (e) {
      log("Failed to load milestones: $e");
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Failed to load milestones",
        contentType: ContentType.failure,
      );
    }
  }

  /// 🔹 Create Payment
  Future<void> createMilestone() async {
    try {
      isLoading.value = true;

      if (!formKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }

      if (selectedMilestoneId.value.isEmpty) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Validation',
          message: "Please select milestone",
          contentType: ContentType.failure,
        );
        isLoading.value = false;
        return;
      }

      if (paidOn.value == null) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Validation',
          message: "Please select payment date",
          contentType: ContentType.failure,
        );
        isLoading.value = false;
        return;
      }
      log("Creating payment for milestone ID: ${selectedPaymentMode.value}");
      final payload = {
        "projectId": projectId,
        "milestoneId": selectedMilestoneId.value,
        "amount": amountController.text.trim(),
        "paymentMode": selectedPaymentMode.value.toLowerCase().replaceAll(
          " ",
          "_",
        ),
        "paymentStatus": selectedPaymentStatus.value.toLowerCase(),
        "paidOn": paidOn.value!.toIso8601String(),
        "referenceNote": referenceNoteController.text.trim(),
      };

      log("Create Payment Payload => $payload");

      final success = await service.createMilestonePayment(payload);

      if (success) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Success",
          message: 'Payment added successfully',
          contentType: ContentType.success,
        );
        Future.delayed(const Duration(milliseconds: 300), () {
          Get.back(result: true);
        });
        resetForm();
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: "Failed to add payment",
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      log("Submit Payment Error: $e");

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong: $e",
        contentType: ContentType.failure,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Update Payment
  Future<void> updateMilestone() async {
    try {
      isLoading.value = true;

      if (!formKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }

      if (selectedMilestoneId.value.isEmpty) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Validation',
          message: "Please select milestone",
          contentType: ContentType.failure,
        );
        isLoading.value = false;
        return;
      }

      if (paidOn.value == null) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Validation',
          message: "Please select payment date",
          contentType: ContentType.failure,
        );
        isLoading.value = false;
        return;
      }

      // Find the selected milestone from the list
      final selectedMilestone = milestones.firstWhereOrNull(
        (m) => m.id == selectedMilestoneId.value,
      );

      if (selectedMilestone == null) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: "Selected milestone not found",
          contentType: ContentType.failure,
        );
        isLoading.value = false;
        return;
      }

      final payload = MilestonePaymentItem(
        id: editingPaymentId.value,
        projectId: projectId,
        milestoneId: selectedMilestoneId.value,
        amount: amountController.text.trim(),
        paymentMode: selectedPaymentMode.value.toLowerCase(),
        paymentStatus: selectedPaymentStatus.value.toLowerCase(),
        paidOn: paidOn.value!,
        referenceNote: referenceNoteController.text.trim(),
        milestone: Milestone(
          id: selectedMilestone.id ?? '',
          projectId: selectedMilestone.projectId ?? projectId,
          title: selectedMilestone.title ?? '',
          description: selectedMilestone.description ?? '',
          milestoneType: selectedMilestone.milestoneType ?? '',
          percentage: selectedMilestone.percentage ?? 0,
          milestoneAmount: selectedMilestone.milestoneAmount ?? '0.00',
          paidAmount: selectedMilestone.paidAmount ?? '0.00',
          remainingAmount: selectedMilestone.remainingAmount ?? '0.00',
          paymentStatus: selectedMilestone.paymentStatus ?? 'pending',
          workStatus: selectedMilestone.workStatus ?? '',
          startDate: selectedMilestone.startDate ?? DateTime.now(),
          endDate: selectedMilestone.endDate ?? DateTime.now(),
        ),
      );

      log("Update Payment Payload => ${payload.toJson()}");

      final success = await service.updateMilestonePayment(
        paymentId: editingPaymentId.value,
        payload: payload,
      );

      if (success) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Success",
          message: 'Payment updated successfully',
          contentType: ContentType.success,
        );
        Future.delayed(const Duration(milliseconds: 300), () {
          Get.back(result: true);
        });
        resetForm();
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: "Failed to update payment",
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      log("Update Payment Error: $e");

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong: $e",
        contentType: ContentType.failure,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Delete Payment
  Future<void> deletePayment(String paymentId) async {
    try {
      // Show confirmation dialog
      final confirm = await Get.dialog<bool>(
        AlertDialog(
          backgroundColor: ColorRes.white,
          title: const Text('Delete Payment'),
          content: const Text('Are you sure you want to delete this payment?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      isLoading.value = true;

      final success = await service.deleteMilestonePayment(paymentId);

      if (success) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Success",
          message: 'Payment deleted successfully',
          contentType: ContentType.success,
        );
        loadInitial();
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Error",
          message: 'Failed to delete payment',
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      log("Delete Payment Error: $e");

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong: $e",
        contentType: ContentType.failure,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Reset Form
  void resetForm() {
    amountController.clear();
    referenceNoteController.clear();

    selectedMilestoneId.value = '';
    selectedPaymentMode.value = 'Cash';
    selectedPaymentStatus.value = 'Pending';
    paidOn.value = null;
    isEditMode.value = false;
    editingPaymentId.value = '';
    formKey.currentState?.reset();
  }

  @override
  void onClose() {
    amountController.dispose();
    referenceNoteController.dispose();
    super.onClose();
  }
}
