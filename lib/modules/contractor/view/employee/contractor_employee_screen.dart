import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/modules/contractor/controller/contractor_dashboard_controller.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/modules/contractor/controller/contractot_employee_controller.dart';
import 'package:nesticope_app/modules/contractor/view/employee/employee_task_data_screen.dart';
import '../../../../data/network/contractor/model/employee/contractor_employee_model.dart';
import '../../../../utils/shimmer/contractor/employee/contractor_employee_list_screen_shimmer.dart';
import '../../../../widgets/New folder/inputs/text_field.dart';
import '../../../../widgets/messages/snack_bar.dart';
// import '../../../data/network/contractor/model/employee/contractor_employee_model.dart';

class ContractorEmployeeScreen extends StatelessWidget {
  const ContractorEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ContractorEmployeeController controller = Get.put(
      ContractorEmployeeController(),
    );
    final ContractorDashboardController dashboardController =
        Get.isRegistered<ContractorDashboardController>()
            ? Get.find<ContractorDashboardController>()
            : Get.put(ContractorDashboardController());

    return Scaffold(
      backgroundColor: ColorRes.background,
      appBar: AppBar(
        backgroundColor: ColorRes.surface,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          "Employee List",
          style: TextStyle(
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textPrimary,
          ),
        ),
        elevation: 1,
      ),

      // BODY SECTION
      body: Obx(() {
        if (controller.isLoading.value) {
          return ContractorEmployeeListScreenShimmer();
        }

        // ✅ Always wrap content inside RefreshIndicator
        return RefreshIndicator(
          onRefresh: () async {
            await controller.refreshEmployee();
          },
          child:
              controller.items.isEmpty
                  ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 250),
                      Center(
                        child: Text(
                          "No employees found.\nPull down to refresh 🔄",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColorRes.leadGreyColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.items.length,
                    itemBuilder: (context, index) {
                      final employee = controller.items[index];
                      return GestureDetector(
                        onTap: () {
                          _showServiceDialog(context, employee);
                        },
                        child: _buildEmployeeCard(employee, controller),
                      );
                    },
                  ),
        );
      }),
      floatingActionButton: Obx(() {
        final bool showDisabledStyle =
            !dashboardController.hasActivePlan ||
            dashboardController.hasReachedUserLimit;

        return FloatingActionButton(
          backgroundColor:
              showDisabledStyle ? Colors.grey.shade400 : ColorRes.primary,
          foregroundColor: ColorRes.white,
          onPressed: () async {
            if (showDisabledStyle) {
              await dashboardController.showUpgradePlanDialog(
                title:
                    dashboardController.hasActivePlan
                        ? 'Limit Reached'
                        : 'Active plan required',
                message:
                    dashboardController.hasActivePlan
                        ? 'Limit Reached, please upgrade your plan.'
                        : 'You do not have an active subscription. Please activate a plan to continue.',
                        buttonText: dashboardController.hasActivePlan?'Active Plan':'Upgrade Plan'
              );
              return;
            }

            controller.isEditing.value = false;
            showAddEmployeeDialog(context, controller);
          },
          child: const Icon(Icons.add),
        );
      }),
    );
  }

  void _showServiceDialog(
    BuildContext context,
    ContractorEmployeeItem service,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: ColorRes.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      service.name,
                      style: TextStyle(
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Description
                Text(
                  service.experience,
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.textSecondary,
                  ),
                ),

                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight: AppFontWeights.medium,
                        color: ColorRes.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // EMPLOYEE CARD
  Widget _buildEmployeeCard(
    ContractorEmployeeItem employee,
    ContractorEmployeeController controller,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with avatar, name, and email
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: ColorRes.primary.withOpacity(0.2),
                  child: Text(
                    employee.name.isNotEmpty
                        ? employee.name[0].toUpperCase()
                        : "?",
                    style: TextStyle(
                      fontSize: AppFontSizes.body,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: AppFontSizes.medium,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.textPrimary,
                        ),
                      ),
                      Text(
                        employee.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ColorRes.leadGreyColor.shade800,
                          fontSize: AppFontSizes.caption,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Phone
            Row(
              children: [
                Icon(
                  Icons.phone,
                  size: 16,
                  color: ColorRes.leadGreyColor.shade700,
                ),
                const SizedBox(width: 6),
                Text(
                  employee.phone.isEmpty ? "-" : employee.phone,
                  style: TextStyle(
                    color: ColorRes.leadGreyColor.shade800,
                    fontSize: AppFontSizes.caption,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Experience
            Row(
              children: [
                Icon(
                  Icons.work_outline,
                  size: 16,
                  color: ColorRes.leadGreyColor.shade700,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    employee.experience.isEmpty
                        ? "No experience info"
                        : '${employee.experience}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: ColorRes.leadGreyColor.shade800,
                      fontSize: AppFontSizes.caption,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Delete employee
                      deleteLead(employee.id, controller, employee.name);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: ColorRes.error,
                      size: 14,
                    ),
                    label: Text(
                      "Delete",
                      style: TextStyle(
                        color: ColorRes.error.shade600,
                        fontSize: AppFontSizes.small,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorRes.error.shade50,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.populateControllers(employee, true);
                      showAddEmployeeDialog(Get.context!, controller);
                    },
                    icon: Icon(Icons.edit, color: ColorRes.white, size: 14),
                    label: Text(
                      "Update",
                      style: TextStyle(
                        color: ColorRes.white,
                        fontSize: AppFontSizes.small,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorRes.primary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.to(
                        () => EmployeeTaskDataScreen(employeeId: employee.id),
                      );
                    },
                    icon: const Icon(
                      Icons.assignment_outlined,
                      color: ColorRes.white,
                      size: 14,
                    ),
                    label: const Text(
                      "View Tasks",
                      style: TextStyle(
                        color: ColorRes.white,
                        fontSize: AppFontSizes.small,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorRes.success,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showAddEmployeeDialog(
  BuildContext context,
  ContractorEmployeeController controller,
) {
  Get.dialog(
    Dialog(
      backgroundColor: ColorRes.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- HEADER ----------------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: ColorRes.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "${controller.isEditing.value ? 'Update' : "Add"} Employee",
                      style: const TextStyle(
                        fontSize: AppFontSizes.body,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.white,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                      controller.clearControllers();
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: const Icon(
                      Icons.close_rounded,
                      color: ColorRes.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // ---------------- BODY ----------------
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Form(
                  key: controller.addEmployeeFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NesticoPeTextField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: controller.txtName,
                        title: 'Name',
                        hintText: 'Enter full name',
                        isRequired: true,
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Name is required'
                                    : null,
                      ),
                      const SizedBox(height: 16),

                      NesticoPeTextField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: controller.txtEmail,
                        title: 'Email',
                        hintText: 'Enter email address',
                        keyboardType: TextInputType.emailAddress,
                        isRequired: true,
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Email is required';
                          if (!GetUtils.isEmail(v))
                            return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      NesticoPeTextField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: controller.txtPhone,
                        title: 'Phone',
                        hintText: 'Enter phone number',
                        keyboardType: TextInputType.phone,

                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Phone number is required'
                                    : null,
                      ),
                      const SizedBox(height: 16),

                      NesticoPeTextField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: controller.txtExp,
                        title: 'Experience',
                        hintText: 'Enter experience in details',
                        maxLines: 3,

                        keyboardType: TextInputType.text,
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Experience is required'
                                    : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ---------------- FOOTER BUTTONS ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                        controller.clearControllers();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: ColorRes.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: AppFontSizes.medium,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          (controller.isEditing.value)
                              ? () {
                                if (controller.addEmployeeFormKey.currentState!
                                    .validate()) {
                                  Get.back();
                                  controller.updateEmployee();
                                }
                              }
                              : () {
                                if (controller.addEmployeeFormKey.currentState!
                                    .validate()) {
                                  final dashboardController =
                                      Get.find<ContractorDashboardController>();
                                  final limitReached =
                                      dashboardController
                                          .activeSubscription
                                          .value
                                          ?.isUserLimitReached ??
                                      true;

                                  if (limitReached) {
                                    dashboardController.showUpgradePlanDialog(
                                      title: 'Limit Reached',
                                      message:
                                          'Limit Reached, please upgrade your plan.',
                                          buttonText: 'Upgrade Plan'
                                    );
                                    return;
                                  }
                                  Get.back();
                                  controller.addEmployee();
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorRes.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        '${controller.isEditing.value ? "Update" : "Add"} Employee',
                        style: TextStyle(
                          fontSize: AppFontSizes.medium,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: true,
  );
}

void deleteLead(
  String id,
  ContractorEmployeeController controller,
  String name,
) {
  Get.dialog(
    AlertDialog(
      backgroundColor: ColorRes.white,
      title: const Text(
        'Delete Employee',
        style: TextStyle(
          fontSize: AppFontSizes.large,
          fontWeight: AppFontWeights.semiBold,
          color: ColorRes.textColor,
        ),
      ),
      content: Text('Are you sure you want to delete $name?'),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: ColorRes.error),
          onPressed: () {
            Get.back();
            controller.deletedContractorEmployeeData(id);
            // deletedContractorLead(id);

            NesticoPeSnackBar.showAwesomeSnackbar(
              title: 'Deleted',
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
