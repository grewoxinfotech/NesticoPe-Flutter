  import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../app/constants/color_res.dart';
import '../../../../../data/network/contractor/model/contractor_project_model/contracto_project_model.dart';
import '../../../../../data/network/contractor/model/employee/contractor_employee_model.dart';
import '../../../controller/contractot_employee_controller.dart';

class ContractorProjectEmployee extends StatefulWidget {
  final List<ContractorEmployee> employeeList;
   ContractorProjectEmployee({super.key, required this.employeeList});
  

  @override
  State<ContractorProjectEmployee> createState() => _ContractorProjectEmployeeState();
}

class _ContractorProjectEmployeeState extends State<ContractorProjectEmployee> {
  final ContractorEmployeeController controller = Get.put(
    ContractorEmployeeController(),
  );
  @override
  Widget build(BuildContext context) {
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
      body: Obx(() {
        controller.items.value = controller.items
            .where((item) => widget.employeeList.any((emp) => emp.id == item.id))
            .toList();


        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
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
              return GestureDetector(onTap: () {
                _showServiceDialog(context,employee);

              },child: _buildEmployeeCard(employee, controller));
            },
          ),
        );
      }),
    );
  }
}
void _showServiceDialog(BuildContext context, ContractorEmployeeItem service) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: ColorRes.white,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
      border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
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
                child: Row(
                  children: [
                    Column(
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
                            color: ColorRes.leadGreyColor.shade600,
                            fontSize: AppFontSizes.caption,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Phone
          Container(
            padding: EdgeInsets.symmetric(vertical: 6,horizontal: 8),
            decoration: BoxDecoration(
              color: ColorRes.leadGreyColor.shade200,
              borderRadius: BorderRadius.circular(16)
            ),
            child: Row(
              children: [
                 Icon(Icons.phone, size: 16, color: ColorRes.primary),
                const SizedBox(width: 6),
                Text(
                  employee.phone.isEmpty ? "-" : employee.phone,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ColorRes.textPrimary,
                    fontSize: AppFontSizes.small,
                    fontWeight: AppFontWeights.medium
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Experience
          Container(
            padding: EdgeInsets.symmetric(vertical: 6,horizontal: 8),
            decoration: BoxDecoration(
                color: ColorRes.leadGreyColor.shade200,
                borderRadius: BorderRadius.circular(16)
            ),
            child: Row(
              children: [
                 Icon(Icons.work_outline, size: 16, color: ColorRes.primary),

                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    employee.experience.isEmpty
                        ? "No experience info"
                        : '${employee.experience}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: ColorRes.textPrimary,
                        fontSize: AppFontSizes.small,
                        fontWeight: AppFontWeights.medium
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

        ],
      ),
    ),
  );
}