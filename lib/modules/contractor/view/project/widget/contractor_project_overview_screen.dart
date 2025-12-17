import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_project_controller.dart';
import 'package:housing_flutter_app/modules/contractor/view/project/widget/contactor_project_milestone_screen.dart';
import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../app/constants/color_res.dart';
import '../../../../../data/network/contractor/model/contractor_project_model/contracto_project_model.dart';
import '../contractor_project.dart';

class ContractorProjectOverviewScreen extends StatelessWidget {
  final String projectId;
  final ContractorProjectController controller;

  const ContractorProjectOverviewScreen({
    super.key,
    required this.projectId,
    required this.controller,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'in_progress':
      default:
        return ColorRes.warning;
    }
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return 'N/A';
    return "${_monthName(parsed.month)} ${parsed.day}, ${parsed.year}";
  }

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.background,
      appBar: AppBar(
        title: Text(
          'Project Overview',
          style: TextStyle(
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textColor,
          ),
        ),
        backgroundColor: ColorRes.surface,
        elevation: 0.5,
      ),
      body: Obx(() {
        final project = controller.items.firstWhereOrNull(
          (p) => p.id == projectId,
        );

        if (project == null) {
          return Center(child: Text('Project not found'));
        }

        final client = project.client;
        final meta = project.meta;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: ColorRes.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ColorRes.leadGreyColor.shade300,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        project.title,
                        style: const TextStyle(
                          fontSize: AppFontSizes.body,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.textColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          project.status,
                        ).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        project.status.replaceAll('_', ' ').capitalize!,
                        style: TextStyle(
                          fontSize: AppFontSizes.caption,
                          color: _getStatusColor(project.status),
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "ID: ${project.id}",
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.textSecondary,
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
                const SizedBox(height: 8),
                Divider(color: ColorRes.leadGreyColor.shade300),
                // const SizedBox(height: 12),
                //
                // // Progress
                // Text(
                //   "Progress",
                //   style: const TextStyle(
                //     fontWeight: AppFontWeights.medium,
                //     fontSize: AppFontSizes.bodySmall,
                //     color: ColorRes.textColor
                //   ),
                // ),
                // const SizedBox(height: 6),
                // Row(
                //   children: [
                //     Expanded(
                //       child: LinearProgressIndicator(
                //         value: project.progress / 100,
                //         color: _getStatusColor(project.status),
                //         backgroundColor: ColorRes.border,
                //         borderRadius: BorderRadius.circular(10),
                //         minHeight: 8,
                //       ),
                //     ),
                //     const SizedBox(width: 8),
                //     Text("${project.progress}%",
                //         style: const TextStyle(
                //             fontWeight: AppFontWeights.medium,
                //             fontSize: AppFontSizes.small)),
                //   ],
                // ),
                const SizedBox(height: 8),

                // Timeline Section
                _buildSectionTitle(Icons.timeline, "Timeline"),
                const SizedBox(height: 10),
                _buildTimelineRow("Start Date", _formatDate(project.startDate)),
                _buildTimelineRow("Deadline", _formatDate(project.deadline)),
                _buildTimelineRow(
                  "Completed At",
                  _formatDate(project.completedAt),
                ),
                const SizedBox(height: 10),

                // Client Details
                _buildSectionTitle(Icons.person_outline, "Client Details"),
                const SizedBox(height: 10),
                _buildClientDetails(client),
                const SizedBox(height: 20),

                // Service Information
                _buildSectionTitle(Icons.info_outline, "Service Information"),
                const SizedBox(height: 10),
                _buildServiceInformation(meta),
                const SizedBox(height: 20),

                // Notes Section
                if (project.notes != null && project.notes!.isNotEmpty) ...[
                  _buildSectionTitle(Icons.note_outlined, "Notes"),
                  const SizedBox(height: 10),
                  _buildNotes(project.notes),
                  const SizedBox(height: 20),
                ],

                _buildSectionTitle(Icons.timeline, "Milestones and Payment"),
                const SizedBox(height: 10),
                _buildMilestonesAndPayment(
                  projectId,
                  double.parse(project.projectPrice),
                ),
                const SizedBox(height: 20),

                // Created and Updated
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Created info
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: ColorRes.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              "Created: ${_formatDate(project.createdAt)}",
                              style: const TextStyle(
                                fontSize: AppFontSizes.caption,
                                color: ColorRes.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Updated info
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.update_outlined,
                            size: 14,
                            color: ColorRes.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              "Updated: ${_formatDate(project.updatedAt)}",
                              style: const TextStyle(
                                fontSize: AppFontSizes.caption,
                                color: ColorRes.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              softWrap: true,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Buttons
                SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            log("Data of String ${project.toMap()}");
                            controller.populatedProjectData(project);
                            showStatusDialog(context, controller, project);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorRes.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Update",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSizes.bodyMedium,
                              fontWeight: AppFontWeights.medium,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            controller.deleteLead(project.id, project.title);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: ColorRes.error,
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Delete",
                            style: TextStyle(
                              color: ColorRes.error,
                              fontSize: AppFontSizes.bodyMedium,
                              fontWeight: AppFontWeights.medium,
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
        );
      }),
    );
  }

  // Section title widget
  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: AppFontSizes.medium,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textColor,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(
    String label1,
    String? value1,
    String label2,
    String? value2,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabelValueRow(label1, value1),
          const SizedBox(height: 6),
          _buildLabelValueRow(label2, value2),
        ],
      ),
    );
  }

  Widget _buildLabelValueRow(String label, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Label
        Text(
          label,
          style: const TextStyle(
            fontSize: AppFontSizes.caption,
            fontWeight: AppFontWeights.medium,
            color: ColorRes.textColor,
          ),
          overflow: TextOverflow.visible,
        ),
        const SizedBox(width: 60),
        // Value
        Expanded(
          child: Text(
            value?.isNotEmpty == true ? value! : "-",
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: AppFontWeights.regular,
              color: ColorRes.textSecondary,
            ),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }

  // Timeline item
  Widget _buildTimelineRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ColorRes.background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: AppFontSizes.caption,
                color: ColorRes.textSecondary,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: AppFontSizes.small,
                color: ColorRes.textPrimary,
                fontWeight: AppFontWeights.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Client details card
  Widget _buildClientDetails(ContractorProjectClient client) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorRes.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow("Name", client.name, "Email", client.email),

          _infoRow(
            "Phone",
            client.phone,
            "Location",
            "${client.location}, ${client.city}, ${client.state}",
          ),
          Divider(color: ColorRes.leadGreyColor.shade300),
          _infoRow(
            "Property Type",
            "${client.propertyType}  |  ${client.bhk ?? '-'} BHK",
            "Carpet Area",
            "${client.carpetArea ?? 0} sq ft",
          ),
        ],
      ),
    );
  }

  Widget _buildServiceInformation(ContractorProjectMeta meta) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorRes.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow(
            "Service Name",
            meta.serviceName,
            "Service ID",
            meta.serviceId,
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Inquiry ID",
                style: const TextStyle(
                  fontSize: AppFontSizes.caption,
                  fontWeight: AppFontWeights.medium,
                  color: ColorRes.textColor,
                ),
              ),
              Text(
                meta.inquiryId ?? "-",
                style: const TextStyle(
                  fontSize: AppFontSizes.caption,
                  fontWeight: AppFontWeights.regular,
                  color: ColorRes.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotes(String? notes) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorRes.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        notes ?? "No notes available",
        style: const TextStyle(
          fontSize: AppFontSizes.caption,
          color: ColorRes.textColor,
        ),
      ),
    );
  }

  Widget _buildMilestonesAndPayment(String projectId, double projectPrice) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorRes.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.track_changes, size: 20),
            title: Text(
              "Milestones",
              style: const TextStyle(
                fontSize: AppFontSizes.caption,
                color: ColorRes.textColor,
              ),
            ),
            onTap: () {
              Get.to(
                () => ContactorProjectMileStoneScreen(
                  projectId: projectId,
                  projectPrice: projectPrice,
                ),
              );
            },
            trailing: Icon(Icons.arrow_forward_ios, size: 15),
          ),
          ListTile(
            leading: Icon(Icons.payment, size: 20),
            title: Text(
              "Payment",
              style: const TextStyle(
                fontSize: AppFontSizes.caption,
                color: ColorRes.textColor,
              ),
            ),
            onTap: () {},
            trailing: Icon(Icons.arrow_forward_ios, size: 15),
          ),
        ],
      ),
    );
  }
}
