import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/data/network/contractor/model/contractor_project_model/contracto_project_model.dart';
import 'package:nesticope_app/modules/contractor/controller/contractor_lead_controller.dart';
import 'package:nesticope_app/modules/contractor/view/project/widget/contractor_project_filter.dart';
import 'package:nesticope_app/modules/contractor/view/project/widget/contractor_project_overview_screen.dart';
import 'package:intl/intl.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../utils/shimmer/contractor/project/contractor_project_list_screen_shimmer.dart';
import '../../../../widgets/New folder/inputs/dropdown_field.dart';
import '../../../../widgets/bar/filter_bar/filter_chip_bar.dart';
import '../../../../widgets/messages/snack_bar.dart';
import '../../../add_property/view/create_property.dart';
import '../../../reseller/view/lead_overview/widget/lead_follow_up_screen.dart';
import '../../controller/contractor_project_controller.dart';

class ContractorProjectScreen extends StatefulWidget {
  const ContractorProjectScreen({super.key});

  @override
  State<ContractorProjectScreen> createState() =>
      _ContractorProjectScreenState();
}

class _ContractorProjectScreenState extends State<ContractorProjectScreen> {
  final ContractorProjectController controller = Get.put(
    ContractorProjectController(),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.refreshList();
    });
  }

  @override
  Widget build(BuildContext context) {
    RxMap<String, String> selectedFilters = <String, String>{}.obs;

    return Scaffold(
      backgroundColor: ColorRes.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorRes.surface,
        // leading: IconButton(
        //   onPressed: () {
        //     Get.back();
        //   },
        //   icon: Icon(Icons.arrow_back),
        // ),
        automaticallyImplyLeading: false,
        title: Text(
          "Contractor Projects",
          style: TextStyle(
            fontWeight: AppFontWeights.semiBold,
            // fontSize: AppFontSizes.medium,
            color: ColorRes.textColor,
          ),
        ),
        actions: [
          // IconButton(onPressed: () {
          //   Get.to(()=>ContractorInquiryFilter());
          // }, icon: Icon(Icons.filter_list))
          TextButton.icon(
            onPressed: () async {
              final result = await Get.dialog<Map<String, String>>(
                const ContractorProjectFilter(),
                barrierDismissible: true,
              );

              if (result != null) {
                log("Selected Filters → $result");
                if (result != null) {
                  selectedFilters.value = result;
                  controller.applyFilters(result);
                }
                // You can now apply filters to your list, API call, etc.
                // controller.fetchFilteredInquiries(result);
              }
            },
            icon: const Icon(Icons.filter_list, color: ColorRes.primary),
            label: const Text(
              "Filter",
              style: TextStyle(color: ColorRes.primary, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obx(() {
              return FilterChipsBar(
                filters: selectedFilters.value,
                onClearAll: () {
                  selectedFilters.clear();
                  controller.resetFilters();
                  controller.applyFilters(<String, String>{});
                },
                onRemoveFilter: (key) {
                  selectedFilters.remove(key);
                  controller.applyFilters(
                    Map<String, String>.from(selectedFilters),
                  );
                },
              );
            }),
            Expanded(
              child: Obx(() {
                final projects = controller.items;
                if (controller.isLoading.value) {
                  return ContractorProjectListScreenShimmer();
                }
                if (controller.items.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: controller.refreshProject,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: double.infinity,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "No project found.",
                                style: TextStyle(
                                  color: ColorRes.textSecondary,
                                  fontSize: AppFontSizes.body,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: controller.refreshProject,
                                // icon: const Icon(Icons.refresh, size: 16),
                                child: const Text('Refresh'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorRes.primary,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: controller.refreshProject,
                  color: ColorRes.primary,
                  child:
                      projects.isEmpty
                          ? SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: Center(
                                child: Text(
                                  "No Project available",
                                  style: TextStyle(
                                    fontSize: AppFontSizes.body,
                                    color: ColorRes.textSecondary,
                                    fontWeight: AppFontWeights.medium,
                                  ),
                                ),
                              ),
                            ),
                          )
                          : ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            itemCount: projects.length,
                            separatorBuilder:
                                (_, _) => const SizedBox(height: 2),
                            itemBuilder: (context, index) {
                              final project = projects[index];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => ContractorProjectOverviewScreen(
                                      projectId: project.id,
                                      controller: controller,
                                    ),
                                  );
                                },
                                child: ProjectCard(
                                  project: project,
                                  onDelete: () {
                                    controller.deleteLead(
                                      project.id,
                                      project.title,
                                    );
                                  },
                                  onChangeStatus: () {
                                    log("Data of String ${project.toJson()}");
                                    controller.populatedProjectData(project);
                                    showStatusDialog(
                                      context,
                                      controller,
                                      project,
                                    );
                                  },
                                  onChangeTime: () {},
                                ),
                              );
                            },
                          ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final ContractorProjectItem project;

  final VoidCallback onChangeTime;
  final VoidCallback onChangeStatus;
  final VoidCallback onDelete;

  const ProjectCard({
    super.key,
    required this.project,

    required this.onChangeTime,
    required this.onChangeStatus,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final p = project;
    final client = p.client;
    final meta = p.meta;

    Color statusColor;
    switch (p.status.toLowerCase()) {
      case 'completed':
        statusColor = Colors.green;
        break;
      case 'pending':
        statusColor = ColorRes.grey;
        break;
      case 'in_progress':
        statusColor = ColorRes.orangeColor;
        break;
      default:
        statusColor = ColorRes.error;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: ColorRes.surface,
        // border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
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
            /// ---------------- HEADER ----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    p.title.capitalize?.replaceAll("_", " ") ?? '',
                    style: const TextStyle(
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: AppFontSizes.medium,
                      color: ColorRes.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    capitalizeEachWord(p.status) ?? "",

                    style: TextStyle(
                      color: statusColor,
                      fontSize: AppFontSizes.caption,
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            /// Deadline
            Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  size: 16,
                  color: ColorRes.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  p.deadline != null ? _formatDate(p.deadline!) : "No Deadline",
                  style: const TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.textSecondary,
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.currency_rupee_outlined,
                  size: 16,
                  color: ColorRes.primary,
                ),
                const SizedBox(width: 4),

                /// print formated price by comma separator
                Text(
                  Formatter.formatNumber(double.parse(p.projectPrice)),
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.textSecondary,
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ----------- PROGRESS INDICATOR -----------
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Progress",
                      style: TextStyle(
                        fontSize: AppFontSizes.caption,
                        color: ColorRes.textSecondary,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                    Text(
                      "${p.progress.toStringAsFixed(0)}%",
                      style: const TextStyle(
                        fontSize: AppFontSizes.caption,
                        color: ColorRes.textPrimary,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    // Ensure progress stays between 0.0 and 1.0
                    value: (p.progress.clamp(0, 100)) / 100,
                    minHeight: 8,
                    backgroundColor: ColorRes.leadGreyColor.shade200,

                    // Dynamic color: orange for active, blue for others
                    valueColor: AlwaysStoppedAnimation<Color>(
                      p.status.toLowerCase() == 'in_progress'
                          ? ColorRes.orangeColor
                          : Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),

            /// ---------------- EXPANDED DETAILS ----------------
            // if (isExpanded) ...[
            //   const SizedBox(height: 12),
            //   const Divider(height: 1, color: ColorRes.divider),
            //   const SizedBox(height: 12),
            //
            //   _sectionTitle("Client Information"),
            //   _infoRow(
            //     "Name",
            //     client.name,
            //     "Property",
            //     "${client.bhk ?? '-'} BHK ${client.propertyType}",
            //   ),
            //   _infoRow(
            //     "Email",
            //     client.email,
            //     "Area",
            //     "${client.carpetArea ?? '-'} sqft",
            //   ),
            //   _infoRow(
            //     "Phone",
            //     client.phone,
            //     "Location",
            //     "${client.city}, ${client.state}",
            //   ),
            //
            //   const SizedBox(height: 10),
            //   _sectionTitle("Meta Information"),
            //   _infoRow(
            //     "Service",
            //     meta.serviceName,
            //     "Inquiry ID",
            //     meta.inquiryId,
            //   ),
            //
            //   const SizedBox(height: 10),
            //   _sectionTitle("Notes"),
            //   Text(
            //     p.notes ?? 'No notes available',
            //     style: const TextStyle(
            //       fontSize: AppFontSizes.bodySmall,
            //       color: ColorRes.textSecondary,
            //     ),
            //   ),
            //
            //   const SizedBox(height: 10),
            //   _sectionTitle("Key Dates"),
            //   _infoRow(
            //     "Start",
            //     _formatDate(p.startDate),
            //     "Deadline",
            //     _formatDate(p.deadline),
            //   ),
            //   // _infoRow("Completed", _formatDate(p.completedAt), "", ""),
            //
            //   const SizedBox(height: 12),
            //   const Divider(height: 1, color: ColorRes.divider),
            //   const SizedBox(height: 12),
            //
            //   /// ACTION BUTTONS
            //   Row(
            //     children: [
            //       Expanded(
            //         child: _actionButton(
            //           Icons.check_circle,
            //           "Update",
            //           ColorRes.green,
            //           onTap: onChangeStatus,
            //         ),
            //       ),
            //       const SizedBox(width: 8),
            //       Expanded(
            //         child: _actionButton(
            //           Icons.delete,
            //           "Delete",
            //           ColorRes.error,
            //           isDelete: true,
            //           onTap: onDelete,
            //         ),
            //       ),
            //     ],
            //   ),
            // ],
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6, top: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: AppFontWeights.semiBold,
        fontSize: AppFontSizes.medium,
        color: ColorRes.textPrimary,
      ),
    ),
  );

  Widget _infoRow(
    String label1,
    String? value1,
    String label2,
    String? value2,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label1,
                style: const TextStyle(
                  fontSize: AppFontSizes.caption,
                  fontWeight: AppFontWeights.medium,
                  color: ColorRes.textColor,
                ),
              ),
              Text(
                value1 ?? "-",
                style: const TextStyle(
                  fontSize: AppFontSizes.caption,
                  fontWeight: AppFontWeights.regular,
                  color: ColorRes.textSecondary,
                ),
              ),
              // Row(
              //   children: [
              //     const SizedBox(height: 4),
              //     Text(
              //       label2,
              //       style: const TextStyle(
              //         fontSize: AppFontSizes.caption,
              //         fontWeight: AppFontWeights.medium,
              //         color: ColorRes.textColor,
              //       ),
              //     ),
              //     Text(
              //       value2 ?? "-",
              //       style: const TextStyle(
              //         fontSize: AppFontSizes.small,
              //         fontWeight: AppFontWeights.regular,
              //         color: ColorRes.textSecondary,
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label2,
                style: const TextStyle(
                  fontSize: AppFontSizes.caption,
                  fontWeight: AppFontWeights.medium,
                  color: ColorRes.textColor,
                ),
              ),
              Text(
                value2 ?? "-",
                style: const TextStyle(
                  fontSize: AppFontSizes.caption,
                  fontWeight: AppFontWeights.regular,
                  color: ColorRes.textSecondary,
                ),
              ),
              // Row(
              //   children: [
              //     const SizedBox(height: 4),
              //     Text(
              //       label2,
              //       style: const TextStyle(
              //         fontSize: AppFontSizes.caption,
              //         fontWeight: AppFontWeights.medium,
              //         color: ColorRes.textColor,
              //       ),
              //     ),
              //     Text(
              //       value2 ?? "-",
              //       style: const TextStyle(
              //         fontSize: AppFontSizes.small,
              //         fontWeight: AppFontWeights.regular,
              //         color: ColorRes.textSecondary,
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    IconData icon,
    String label,
    Color color, {
    bool isDelete = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color:
              isDelete ? Colors.red.withOpacity(0.2) : color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isDelete ? Colors.red : color,
                fontSize: AppFontSizes.bodySmall,
                fontWeight: AppFontWeights.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    final date = DateTime.tryParse(dateStr);
    if (date == null) return '-';
    return "${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)} ${date.year}";
  }

  String _monthName(int month) {
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
    return months[month - 1];
  }
}

void showStatusDialog(
  BuildContext context,
  ContractorProjectController controller,
  ContractorProjectItem inquiry,
) {
  const List<String> leadStatuses = [
    'Pending',
    'In Progress',
    'Completed',
    'Cancelled',
  ];

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
                  const Expanded(
                    child: Text(
                      "Change Status",
                      style: TextStyle(
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

            // ---------------- BODY ----------------
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    buildSectionTitle('Change Status'),
                    const SizedBox(height: 8),
                    Obx(() {
                      return NesticoPeDropdownField<String>(
                        isRequired: true,
                        value: controller.changeStatus.value,
                        hintText: "Select status",
                        prefixIcon: Icons.emoji_flags_rounded,
                        items:
                            leadStatuses
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) {
                          controller.setValue(controller.changeStatus, val);
                          log(
                            "Contractor_status ${controller.changeStatus.value}",
                          );
                        },
                        darkText: true,
                      );
                    }),

                    const SizedBox(height: 20),
                    buildSectionTitle('Change Stage'),
                    const SizedBox(height: 8),
                    buildTextField(
                      'Start Date',
                      Icons.calendar_month_outlined,
                      controller.txtTime,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid date';
                        }
                        return null;
                      },
                      isEnable: false,
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: Get.context!,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: ColorRes.primary,
                                  onPrimary: ColorRes.white,
                                  onSurface: ColorRes.black,
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: ColorRes.primary,
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (picked != null) {
                          // 👇 Save picked date for submission
                          controller.selectedDate = picked;

                          // 👇 Show formatted date in TextField
                          controller.txtTime.text =
                              "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                        }
                      },
                      isPhoneKey: true,
                    ),
                  ],
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
                      onPressed: () async {
                        final status = controller.changeStatus.value;

                        if (status.isEmpty &&
                            (controller.selectedDate == null)) {
                          NesticoPeSnackBar.showAwesomeSnackbar(
                            title: 'Error',
                            message: "Please select at least one value",
                            contentType: ContentType.failure,
                          );
                          return;
                        }

                        // 👇 Convert to ISO UTC format for backend
                        String? deadlineIso =
                            controller.selectedDate != null
                                ? DateTime.utc(
                                  controller.selectedDate!.year,
                                  controller.selectedDate!.month,
                                  controller.selectedDate!.day,
                                  controller.selectedDate!.hour,
                                  controller.selectedDate!.minute,
                                ).toIso8601String()
                                : null;

                        log("Deadline to send → $deadlineIso");
                        log("Display date → ${controller.txtTime.text}");

                        log("Deadline to send → $deadlineIso");
                        log("Display date → ${controller.txtTime.text}");

                        // Example of passing to API
                        // controller.updateTheStatusAndStage(
                        //   leadId: inquiry.id ?? "",
                        //   status: status,
                        //   deadline: deadlineIso,
                        // );
                        controller.updateChangeStatus(
                          inquiry.id,
                          status,
                          deadlineIso ?? '',
                        );
                        Get.back();
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorRes.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Submit',
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
