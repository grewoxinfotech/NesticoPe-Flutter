import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/contractor/model/contractor_lead_model/contractor_lead_followup_model.dart';
import 'package:housing_flutter_app/data/network/contractor/model/contractor_lead_model/contractor_lead_model.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_lead_followup_controller.dart';

import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../app/constants/color_res.dart';
import '../../../../../widgets/New folder/inputs/dropdown_field.dart';
import '../../../../reseller/view/lead_overview/widget/lead_follow_up_screen.dart';

class ContractorFollowUpScreen extends StatefulWidget {
  ContractorLeadItem lead;

  ContractorFollowUpScreen({super.key, required this.lead});

  @override
  State<ContractorFollowUpScreen> createState() =>
      _ContractorFollowUpScreenState();
}

class _ContractorFollowUpScreenState extends State<ContractorFollowUpScreen> {
  final controller = Get.put(ContractorLeadFollowupController());

  @override
  void initState() {
    super.initState();
    controller.initFollowups(widget.lead.id ?? "");
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initFollowups(widget.lead.id ?? "");
    });
    return Scaffold(
      backgroundColor: ColorRes.background,
      appBar: AppBar(
        backgroundColor: ColorRes.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorRes.textPrimary),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Follow-Ups',
          style: TextStyle(
            color: ColorRes.textPrimary,

            fontWeight: AppFontWeights.semiBold,
          ),
        ),
        // actions: [
        //   PopupMenuButton<String>(
        //     icon: const Icon(Icons.more_vert),
        //     onSelected: (value) {
        //       controller.selectedFilter.value = value;
        //       controller.setFilter(value);
        //       log("Contractor_status $value");
        //     },
        //     itemBuilder:
        //         (context) => [
        //           const PopupMenuItem(value: 'All', child: Text('All')),
        //           const PopupMenuItem(value: 'Pending', child: Text('Pending')),
        //           const PopupMenuItem(value: 'Cancel', child: Text('Cancel')),
        //           const PopupMenuItem(
        //             value: 'Completed',
        //             child: Text('Completed'),
        //           ),
        //         ],
        //   ),
        // ],
      ),
      body: Column(
        children: [
          // Container(
          //   color: ColorRes.white,
          //   padding: const EdgeInsets.all(16),
          //   child: TextField(
          //     onChanged: controller.setSearchQuery,
          //     decoration: InputDecoration(
          //       hintText: 'Search follow-ups...',
          //       hintStyle: TextStyle(
          //         color: ColorRes.textSecondary,
          //         fontSize: AppFontSizes.medium,
          //       ),
          //       prefixIcon: const Icon(
          //         Icons.search,
          //         color: ColorRes.textSecondary,
          //       ),
          //       filled: true,
          //       fillColor: ColorRes.background,
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(12),
          //         borderSide: BorderSide.none,
          //       ),
          //       contentPadding: const EdgeInsets.symmetric(vertical: 12),
          //     ),
          //   ),
          // ),
          Expanded(
            child: Obx(() {
              final items = controller.items;
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.items.isEmpty && (!controller.isLoading.value)) {
                return Center(
                  child: Text(
                    'No follow-ups found',
                    style: TextStyle(
                      color: ColorRes.textSecondary,
                      fontSize: AppFontSizes.body,
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                  onRefresh: controller.refreshFollowUp,
                  color: ColorRes.primary,
                  child: items.isEmpty
                      ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: Text(
                          "No FollowUp available",
                          style: TextStyle(
                            fontSize: AppFontSizes.body,
                            color: ColorRes.textSecondary,
                            fontWeight: AppFontWeights.medium,
                          ),
                        ),
                      ),
                    ),
                  ) :ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  final item = controller.items[index];
                  return _buildFollowUpCard(item, controller);
                },
                  )
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorRes.primary,
        onPressed:() {controller.changeTheStatus(false);controller.openAddFollowUpDialog();},
        child: const Icon(Icons.add, color: ColorRes.white),
      ),
    );
  }

  Widget _buildFollowUpCard(
    ContractorLeadFollowUpItem item,
    ContractorLeadFollowupController controller,
  ) {
    return Obx(() {
      final isExpanded = controller.isExpanded(item.id);

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () => controller.toggleExpanded(item.id),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: getIconColor(item.type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        getIcon(item.type),
                        color: getIconColor(item.type),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${getTitle(item.type)}',
                                  style: TextStyle(
                                    color: ColorRes.textPrimary,
                                    fontSize: AppFontSizes.medium,
                                    fontWeight: AppFontWeights.semiBold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              _buildStatusChip(item.status??''),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.formatDateTime(item.date??'', item.time??''),
                            style: TextStyle(
                              color: ColorRes.textSecondary,
                              fontSize: AppFontSizes.caption,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Expanded Content
            if (isExpanded) ...[
              Divider(height: 1, color: ColorRes.leadGreyColor.shade300),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.notes?.isNotEmpty??false) ...[
                      Text(
                        'Notes',

                        style: TextStyle(
                          color: ColorRes.textPrimary,
                          fontSize: AppFontSizes.small,
                          fontWeight: AppFontWeights.semiBold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.notes??'',
                        style: TextStyle(
                          color: ColorRes.textSecondary,
                          fontSize: AppFontSizes.small,
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    Text(
                      'Reminder',
                      style: TextStyle(
                        color: ColorRes.textPrimary,
                        fontSize: AppFontSizes.small,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.reminder ? 'Yes' : 'No'}',
                      style: TextStyle(
                        color: ColorRes.textSecondary,
                        fontSize: AppFontSizes.small,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (item.type != 'call') ...[
                      Text(
                        'Location',
                        style: TextStyle(
                          color: ColorRes.textPrimary,
                          fontSize: AppFontSizes.small,
                          fontWeight: AppFontWeights.semiBold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.location!,
                        style: TextStyle(
                          color: ColorRes.textSecondary,
                          fontSize: AppFontSizes.small,
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Action Buttons
                    Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {

                              controller.changeTheStatus(true);
                              controller.populatedFollowUpData(item);
                             controller.openAddFollowUpDialog();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: ColorRes.primary.withOpacity(0.15),
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 20,
                                color: ColorRes.primary,
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.dialog(
                                Dialog(
                                  backgroundColor: ColorRes.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  insetPadding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 24,
                                  ),
                                  child: Container(
                                    constraints: const BoxConstraints(
                                      maxWidth: 600,
                                      maxHeight: 700,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorRes.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // ---------- HEADER ----------
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 10,
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
                                              const Expanded(
                                                child: Text(
                                                  "Lead Details",
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

                                        // ---------- BODY ----------
                                        Flexible(
                                          child: SingleChildScrollView(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 16,
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // TYPE
                                                if ((item.type ?? '').toString().trim().isNotEmpty) ...[
                                                  _buildDetailRow('Type', capitalizeEachWord(item.type)),
                                                  _buildDivider(),
                                                ],

                                                // DATE
                                                if ((item.date ?? '').toString().trim().isNotEmpty) ...[
                                                  _buildDetailRow('Date', item.date??''),
                                                  _buildDivider(),
                                                ],

                                                // REMINDER
                                                if (item.reminder != null) ...[
                                                  _buildDetailRow(
                                                    'Reminder',
                                                    item.reminder ? 'Yes' : 'No',
                                                  ),
                                                  _buildDivider(),
                                                ],

                                                // TIME
                                                if ((item.time ?? '').toString().trim().isNotEmpty) ...[
                                                  _buildDetailRow('Time', item.time??''),
                                                  _buildDivider(),
                                                ],

                                                // STATUS
                                                if ((item.status ?? '').toString().trim().isNotEmpty) ...[
                                                  _buildDetailRow('Status', capitalizeEachWord(item.status)),
                                                  _buildDivider(),
                                                ],

                                                // LOCATION
                                                if ((item.location ?? '').toString().trim().isNotEmpty) ...[
                                                  _buildDetailRow('Location', item.location??''),
                                                  _buildDivider(),
                                                ],

                                                // NOTE
                                                if ((item.notes ?? '').toString().trim().isNotEmpty) ...[
                                                  _buildDetailRow('Note', item.notes??''),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                barrierDismissible: true,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: ColorRes.textSecondary.withOpacity(0.15),
                              ),
                              child: Icon(
                                Icons.visibility,
                                size: 20,
                                color: ColorRes.textSecondary,
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              controller.deleteLead(item.id,item.type);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: ColorRes.error.withOpacity(0.15),
                              ),
                              child: Icon(
                                Icons.delete,
                                size: 20,
                                color: ColorRes.error,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
  Widget _buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: ColorRes.textSecondary,
              fontSize: AppFontSizes.small,
              fontWeight: AppFontWeights.medium,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: ColorRes.textSecondary,
              fontSize: AppFontSizes.small,
              fontWeight: AppFontWeights.medium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 20,
      color: ColorRes.leadGreyColor.shade300,
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    String displayText = status.capitalize ?? status;

    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = ColorRes.warning.withOpacity(0.1);
        textColor = ColorRes.warning;
        break;
      case 'completed':
        backgroundColor = ColorRes.success.withOpacity(0.1);
        textColor = ColorRes.success;
        break;
      case 'cancelled':
        backgroundColor = ColorRes.error.withOpacity(0.1);
        textColor = ColorRes.error;
        break;
      default:
        backgroundColor = ColorRes.grey.withOpacity(0.1);
        textColor = ColorRes.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontSize: AppFontSizes.caption,
          fontWeight: AppFontWeights.medium,
        ),
      ),
    );
  }
}

IconData getIcon(String type) {
  switch (type) {
    case 'call':
      return Icons.phone;
    case 'meeting':
      return Icons.event;
    case 'email':
      return Icons.email;
    case 'site_visit':
      return Icons.home;
    default:
      return Icons.event;
  }
}

Color getIconColor(String type) {
  switch (type) {
    case 'call':
      return Colors.blue;
    case 'meeting':
      return Colors.purple;
    case 'email':
      return Colors.blue;
    case 'site_visit':
      return Colors.blue;
    default:
      return Colors.grey;
  }
}

String getTitle(String type) {
  switch (type) {
    case 'meeting':
      return 'Meeting';
    case 'call':
      return 'Call';
    case 'email':
      return 'Email';
    case 'site_visit':
      return 'Site Visit';
    default:
      return type;
  }
}


