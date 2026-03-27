import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/modules/contractor/controller/employee_task_controller.dart';
import 'package:nesticope_app/modules/property_rating/view/widget/read_more_or_less.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../app/constants/color_res.dart';
import '../../../../../data/network/contractor/model/employee/employee_task_model.dart';
import 'package:nesticope_app/widgets/New%20folder/inputs/text_field.dart';
import 'package:nesticope_app/widgets/New%20folder/inputs/dropdown_field.dart';

class EmployeeTaskListScreen extends StatefulWidget {
  final String projectId;
  final String projectName;
  final String employeeId;
  final String employeeName;
  const EmployeeTaskListScreen({
    super.key,
    required this.projectId,
    required this.projectName,
    required this.employeeId,
    required this.employeeName,
  });

  @override
  State<EmployeeTaskListScreen> createState() => _EmployeeTaskListScreenState();
}

class _EmployeeTaskListScreenState extends State<EmployeeTaskListScreen> {
  final EmployeeTaskController controller = Get.find<EmployeeTaskController>();
  final TextEditingController _dueDateCtrl = TextEditingController();

  @override
  void dispose() {
    _dueDateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.background,
      appBar: AppBar(
        backgroundColor: ColorRes.surface,
        title: const Text(
          "Employee Tasks",
          style: TextStyle(
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textPrimary,
          ),
        ),
        elevation: 1,
        actions: [
          TextButton(
            child: const Text(
              "Assign Task",
              style: TextStyle(
                color: ColorRes.primary,
                fontSize: AppFontSizes.bodySmall,
              ),
            ),
            onPressed: () => _openAssignDialog(context),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          // Replace CircularProgressIndicator with the Shimmer List
          return _buildShimmerList();
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshtask(),
          child:
              (controller.items.isNotEmpty)
                  ? ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final task = controller.items[index];
                      return _taskTile(task);
                    },
                  )
                  : Center(
                    child: Text(
                      "No tasks found",
                      style: const TextStyle(
                        color: ColorRes.leadGreyColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
        );
      }),
    );
  }

  Widget _taskTile(EmployeeTaskItem task) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorRes.leadGreyColor.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title + Edit
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  task.taskTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                ),
              ),
              // IconButton(
              //   visualDensity: VisualDensity.compact,
              //   icon: const Icon(Icons.edit_outlined, size: 18),
              //   onPressed: () => _openEditDialog(task),
              // ),
              GestureDetector(
                onTap: () => _openEditDialog(task),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: ColorRes.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.edit_outlined, size: 18),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          ReadMoreClass(
            description: task.taskDescription,
            trimLines: 2,
            size: AppFontSizes.small,
            colorClickableText: ColorRes.primary,
          ),

          const SizedBox(height: 14),

          /// Bottom Row
          Row(
            children: [
              _priorityChip(task.priority),
              const SizedBox(width: 8),
              _statusChip(task.status),

              const Spacer(),

              const Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: ColorRes.textSecondary,
              ),

              const SizedBox(width: 6),

              Text(
                task.dueDate == null
                    ? '-'
                    : "${task.dueDate!.day.toString().padLeft(2, '0')} "
                        "${_month(task.dueDate!.month)} "
                        "${task.dueDate!.year}",
                style: TextStyle(fontSize: 11, color: ColorRes.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Number of shimmer items to show
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _shimmerTaskTile();
      },
    );
  }

  Widget _shimmerTaskTile() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorRes.leadGreyColor.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      // We wrap the internal content in the Shimmer to keep the card border static
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title & Edit Icon Shimmer
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 18,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 18,
                        width: 150, // Shorter second line for the title
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  height: 26,
                  width: 26,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Description Shimmer (2 lines)
            Container(
              height: 12,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 12,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            const SizedBox(height: 14),

            /// Bottom Row Shimmer (Chips + Date)
            Row(
              children: [
                // Priority Chip Placeholder
                Container(
                  height: 24,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 8),
                // Status Chip Placeholder
                Container(
                  height: 24,
                  width: 85,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                const Spacer(),

                // Calendar Icon Placeholder
                Container(
                  height: 14,
                  width: 14,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                // Date Text Placeholder
                Container(
                  height: 12,
                  width: 65,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _priorityChip(String priority) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: ColorRes.leadGreyColor.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _statusChip(String status) {
    Color color;

    switch (status.toLowerCase().replaceAll('_', ' ')) {
      case "pending":
        color = ColorRes.orangeColor;
        break;
      case "in progress":
        color = ColorRes.primary;
        break;
      case "completed":
        color = ColorRes.success;
        break;
      case "cancelled":
        color = ColorRes.error;
        break;
      default:
        color = ColorRes.leadGreyColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            status.toUpperCase().replaceAll('_', " "),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _month(int m) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',

      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[(m - 1).clamp(0, 11)];
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ColorRes.leadGreyColor.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: AppFontSizes.caption,
          color: ColorRes.textPrimary,
        ),
      ),
    );
  }

  void _openAssignDialog(BuildContext context) {
    controller.clearForm();
    _openTaskDialog(
      context: context,
      title: "Assign Task",
      onSubmit: () async {
        final ok = await controller.createTask(
          employeeId: widget.employeeId,
          projectId: widget.projectId,
        );
        if (ok) {
          await controller.refreshList();
          Get.back();
        }
      },
    );
  }

  void _openEditDialog(EmployeeTaskItem task) {
    controller.taskTitleController.text = task.taskTitle;
    controller.taskDescriptionController.text = task.taskDescription;
    controller.priority.value = task.priority;
    controller.status.value = task.status;
    controller.dueDate.value = task.dueDate;
    _openTaskDialog(
      context: context,
      title: "Update Task",
      onSubmit: () async {
        final ok = await controller.updateTask(task.id);
        if (ok) {
          await controller.refreshList();
          Get.back();
        }
      },
    );
  }

  void _openTaskDialog({
    required BuildContext context,
    required String title,
    required VoidCallback onSubmit,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: ColorRes.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          decoration: BoxDecoration(
            color: ColorRes.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
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
                        title,
                        style: const TextStyle(
                          fontSize: AppFontSizes.body,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.white,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.back(),
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
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.person_outline,
                                  size: 18,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Employee: ${widget.employeeName}',
                                    style: const TextStyle(
                                      fontSize: AppFontSizes.medium,
                                      fontWeight: AppFontWeights.medium,
                                      color: ColorRes.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.folder_open,
                                  size: 18,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Project: ${widget.projectName}',
                                    style: const TextStyle(
                                      fontSize: AppFontSizes.medium,
                                      fontWeight: AppFontWeights.medium,
                                      color: ColorRes.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      NesticoPeTextField(
                        controller: controller.taskTitleController,
                        title: "Task Title",
                        hintText: "Enter task title",
                      ),
                      const SizedBox(height: 12),
                      NesticoPeTextField(
                        controller: controller.taskDescriptionController,
                        title: "Description",
                        hintText: "Enter task description",

                        maxLines: 3,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() {
                              return NesticoPeDropdownField<String>(
                                title: "Priority",
                                hintText: "Select priority",

                                value: controller.priority.value,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'low',
                                    child: Text('Low'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'medium',
                                    child: Text('Medium'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'high',
                                    child: Text('High'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'urgent',
                                    child: Text('Urgent'),
                                  ),
                                ],
                                onChanged: (val) {
                                  controller.priority.value = val ?? 'medium';
                                },
                              );
                            }),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Obx(() {
                              return NesticoPeDropdownField<String>(
                                title: "Status",
                                hintText: "Select status",

                                value: controller.status.value,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'pending',
                                    child: Text('Pending'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'in_progress',
                                    child: Text('In Progress'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'completed',
                                    child: Text('Completed'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'cancelled',
                                    child: Text('Cancelled'),
                                  ),
                                ],
                                onChanged: (val) {
                                  controller.status.value = val ?? 'pending';
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Obx(() {
                        final date = controller.dueDate.value;
                        _dueDateCtrl.text =
                            date == null
                                ? ''
                                : "${date.day.toString().padLeft(2, '0')} ${_month(date.month)} ${date.year}";
                        return NesticoPeTextField(
                          controller: _dueDateCtrl,
                          title: "Due Date",
                          hintText: "Select date",

                          readOnly: true,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: date ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              controller.dueDate.value = picked;
                            }
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
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
                        onPressed: onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorRes.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Save',
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
}
