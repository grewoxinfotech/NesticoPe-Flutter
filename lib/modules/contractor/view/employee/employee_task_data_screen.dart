import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/data/network/contractor/model/employee/employee_task_model.dart';
import 'package:nesticope_app/modules/contractor/controller/employee_task_data_controller.dart';
import 'package:nesticope_app/app/widgets/shimmer/shimmer_widget.dart';

class EmployeeTaskDataScreen extends StatefulWidget {
  final String employeeId;
  const EmployeeTaskDataScreen({super.key, required this.employeeId});

  @override
  State<EmployeeTaskDataScreen> createState() => _EmployeeTaskDataScreenState();
}

class _EmployeeTaskDataScreenState extends State<EmployeeTaskDataScreen> {
  late final EmployeeTaskDataController controller;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = Get.put(EmployeeTaskDataController());
    controller.init(widget.employeeId);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        controller.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.background,
      appBar: AppBar(
        backgroundColor: ColorRes.surface,
        title: const Text(
          'Employee Tasks',
          style: TextStyle(
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textPrimary,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 6,
            itemBuilder: (context, index) => _buildTaskShimmerCard(),
          );
        }
        // if (controller.items.isEmpty) {
        //   return const Center(
        //     child: Text(
        //       'No tasks found',
        //       style: TextStyle(color: ColorRes.textSecondary),
        //     ),
        //   );
        // }
        return RefreshIndicator(
          onRefresh: controller.refreshTasks,
          child:
              (controller.items.isEmpty)
                  ? Center(
                    child: Text(
                      'No tasks found',
                      style: TextStyle(color: ColorRes.textSecondary),
                    ),
                  )
                  : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount:
                        controller.items.length +
                        (controller.isPaging.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= controller.items.length) {
                        return const Padding(
                          padding: EdgeInsets.all(12),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final t = controller.items[index];
                      // return Container(
                      //   margin: const EdgeInsets.only(bottom: 12),
                      //   padding: const EdgeInsets.all(12),
                      //   decoration: BoxDecoration(
                      //     color: ColorRes.white,
                      //     borderRadius: BorderRadius.circular(12),
                      //     border:
                      //         Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Row(
                      //         children: [
                      //           Icon(
                      //             Icons.assignment_outlined,
                      //             color: ColorRes.primary,
                      //           ),
                      //           const SizedBox(width: 8),
                      //           Expanded(
                      //             child: Text(
                      //               t.taskTitle,
                      //               style: const TextStyle(
                      //                 fontSize: AppFontSizes.medium,
                      //                 fontWeight: AppFontWeights.semiBold,
                      //               ),
                      //             ),
                      //           ),
                      //           Container(
                      //             padding: const EdgeInsets.symmetric(
                      //                 horizontal: 8, vertical: 4),
                      //             decoration: BoxDecoration(
                      //               color: ColorRes.primary.withOpacity(0.1),
                      //               borderRadius: BorderRadius.circular(20),
                      //             ),
                      //             child: Text(
                      //               t.priority,
                      //               style: const TextStyle(
                      //                 fontSize: AppFontSizes.caption,
                      //                 fontWeight: AppFontWeights.medium,
                      //                 color: ColorRes.primary,
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       const SizedBox(height: 6),

                      //       Text(
                      //         t.taskDescription,
                      //         style: TextStyle(
                      //           color: ColorRes.textSecondary,
                      //           fontSize: AppFontSizes.caption,
                      //         ),
                      //       ),
                      //       const SizedBox(height: 8),
                      //       Row(
                      //         children: [
                      //           Icon(
                      //             Icons.event_available_outlined,
                      //             size: 16,
                      //             color: ColorRes.leadGreyColor.shade600,
                      //           ),
                      //           const SizedBox(width: 6),
                      //           Text(
                      //             t.dueDate != null
                      //                 ? t.dueDate!.toLocal().toString().split(' ').first
                      //                 : '-',
                      //             style: TextStyle(
                      //               color: ColorRes.leadGreyColor.shade700,
                      //               fontSize: AppFontSizes.caption,
                      //             ),
                      //           ),
                      //           const Spacer(),
                      //           Container(
                      //             padding: const EdgeInsets.symmetric(
                      //                 horizontal: 8, vertical: 4),
                      //             decoration: BoxDecoration(
                      //               color: ColorRes.leadGreyColor.shade100,
                      //               borderRadius: BorderRadius.circular(20),
                      //             ),
                      //             child: Text(
                      //               t.status,
                      //               style: TextStyle(
                      //                 fontSize: AppFontSizes.caption,
                      //                 fontWeight: AppFontWeights.medium,
                      //                 color: ColorRes.leadGreyColor.shade700,
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // );
                      return _buildTaskCard(t);
                    },
                  ),
        );
      }),
    );
  }

  //   Widget _buildTaskCard(EmployeeTaskItem t) {
  //     Color priorityColor;

  //     switch (t.priority.toLowerCase()) {
  //       case 'high':
  //         break;
  //       case 'medium':
  //         priorityColor = Colors.orange;
  //         break;
  //       case 'low':
  //         priorityColor = Colors.green;
  //         break;
  //       default:
  //         priorityColor = Colors.blue;
  //     }

  //     return Container(
  //       margin: const EdgeInsets.only(bottom: 14),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(18),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.05),
  //             blurRadius: 10,
  //             offset: const Offset(0, 4),
  //           ),
  //         ],
  //       ),
  //       child: Row(
  //         children: [
  //           // LEFT COLOR STRIP
  //           Container(
  //             width: 5,
  //             height: 120,
  //             decoration: BoxDecoration(
  //               color: priorityColor,
  //               borderRadius: const BorderRadius.only(
  //                 topLeft: Radius.circular(18),
  //                 bottomLeft: Radius.circular(18),
  //               ),
  //             ),
  //           ),

  //           // CONTENT
  //           Expanded(
  //             child: Padding(
  //               padding: const EdgeInsets.all(14),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Container(
  //                         padding: const EdgeInsets.symmetric(
  //                           horizontal: 10,
  //                           vertical: 4,
  //                         ),
  //                         decoration: BoxDecoration(
  //                           color: Colors.blue.withOpacity(0.1),
  //                           borderRadius: BorderRadius.circular(20),
  //                         ),
  //                         child: Text(
  //                           t.status.capitalize ?? '',
  //                           style: TextStyle(
  //                             fontSize: 11,
  //                             fontWeight: AppFontWeights.medium,
  //                             color: Colors.blue,
  //                           ),
  //                         ),
  //                       ),
  //                       Container(
  //                         padding: const EdgeInsets.symmetric(
  //                           horizontal: 10,
  //                           vertical: 4,
  //                         ),
  //                         decoration: BoxDecoration(
  //                           color: priorityColor.withOpacity(0.1),
  //                           borderRadius: BorderRadius.circular(20),
  //                         ),
  //                         child: Text(
  //                           t.priority.toUpperCase(),
  //                           style: TextStyle(
  //                             color: priorityColor,
  //                             fontSize: 11,
  //                             fontWeight: AppFontWeights.semiBold,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(height: 8),

  //                   /// TITLE + PRIORITY
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: Text(
  //                           t.taskTitle,
  //                           style: TextStyle(
  //                             fontSize: 16,
  //                             fontWeight: AppFontWeights.semiBold,
  //                             color: ColorRes.textPrimary,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),

  //                   const SizedBox(height: 6),
  //                   if ((t.project?.title ?? '').isNotEmpty)
  //                     Row(
  //                       children: [
  //                         Icon(
  //                           Icons.work_outline,
  //                           size: 14,
  //                           color: ColorRes.leadGreyColor.shade600,
  //                         ),
  //                         const SizedBox(width: 6),
  //                         Expanded(
  //                           child: Text(
  //                             t.project!.title,
  //                             maxLines: 1,
  //                             overflow: TextOverflow.ellipsis,
  //                             style: TextStyle(
  //                               fontSize: 12,
  //                               color: ColorRes.leadGreyColor.shade700,
  //                               fontWeight: AppFontWeights.medium,
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   if ((t.project?.title ?? '').isNotEmpty)
  //                     const SizedBox(height: 6),

  //                   /// DESCRIPTION
  //                   Text(
  //                     t.taskDescription,

  //                     // overflow: TextOverflow.ellipsis,
  //                     style: TextStyle(
  //                       fontSize: 12,
  //                       color: ColorRes.leadGreyColor.shade600,
  //                       fontWeight: AppFontWeights.medium,
  //                     ),
  //                   ),

  //                   const SizedBox(height: 10),

  //                   /// STATUS CHIP
  //                   const SizedBox(height: 10),

  //                   /// FOOTER DATES
  //                   Row(
  //                     children: [
  //                       Icon(
  //                         Icons.calendar_today,
  //                         size: 14,
  //                         color: Colors.grey.shade500,
  //                       ),
  //                       const SizedBox(width: 6),
  //                       Text(
  //                         t.dueDate != null
  //                             ? t.dueDate!.toLocal().toString().split(' ').first
  //                             : '-',
  //                         style: TextStyle(
  //                           fontSize: 11,
  //                           color: ColorRes.leadGreyColor.shade600,
  //                           fontWeight: AppFontWeights.medium,
  //                         ),
  //                       ),
  //                       const Spacer(),
  //                       Text(
  //                         "Created: ${t.createdAt != null ? t.createdAt!.toLocal().toString().split(' ').first : '-'}",
  //                         style: TextStyle(
  //                           fontSize: 11,
  //                           color: ColorRes.leadGreyColor.shade600,
  //                           fontWeight: AppFontWeights.medium,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

  Widget _buildTaskCard(EmployeeTaskItem t) {
    Color statusColor;
    Color priorityColor;

    /// STATUS COLOR
    switch (t.status.toLowerCase()) {
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'completed':
        statusColor = Colors.green;
        break;
      case 'in progress':
        statusColor = Colors.blue;
        break;
      default:
        statusColor = Colors.grey;
    }

    /// PRIORITY COLOR
    switch (t.priority.toLowerCase()) {
      case 'high':
        priorityColor = ColorRes.error;
        break;
      case 'medium':
        priorityColor = ColorRes.homeAmber;
        break;
      case 'low':
        priorityColor = Colors.green;
        break;
      default:
        priorityColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 TOP BADGES
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  t.status.capitalize ?? '',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  t.priority.capitalize ?? '',
                  style: TextStyle(
                    color: priorityColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// 🧾 TITLE
          Text(
            t.taskTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),

          const SizedBox(height: 6),

          /// 📝 DESCRIPTION
          Text(
            t.taskDescription,
     
            // overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: AppFontWeights.medium,
              color: ColorRes.leadGreyColor.shade600,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 10),

          /// 📌 PROJECT CHIP
          if ((t.project?.title ?? '').isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "PROJECT: ${t.project!.title.toUpperCase()}",
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),

          const SizedBox(height: 14),

          /// 📅 FOOTER
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 6),
              Text(
                t.dueDate != null
                    ? "Due: ${t.dueDate!.toLocal().toString().split(' ').first}"
                    : "No due date",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: AppFontWeights.medium,
                  color: ColorRes.leadGreyColor.shade600,
                ),
              ),
              
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskShimmerCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerShapes.text(width: double.infinity, height: 16),
                  const SizedBox(height: 8),
                  ShimmerShapes.text(width: 120, height: 12),
                  const SizedBox(height: 8),
                  ShimmerShapes.text(width: double.infinity, height: 12),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ShimmerShapes.rounded(width: 80, height: 22, borderRadius: 20),
                      const Spacer(),
                      ShimmerShapes.text(width: 90, height: 12),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ShimmerShapes.text(width: 120, height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
