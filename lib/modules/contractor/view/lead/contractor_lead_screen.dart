import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/data/network/contractor/model/contractor_lead_model/contractor_lead_model.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_lead_controller.dart';
import 'package:housing_flutter_app/modules/contractor/view/lead/follow_up/contractor_lead_filter.dart';
import 'package:housing_flutter_app/modules/contractor/view/lead/widget/contractor_lead_edit_screen.dart';
import 'package:housing_flutter_app/modules/contractor/view/lead/widget/contractor_lead_overview.dart';
import 'package:housing_flutter_app/modules/contractor/view/lead/widget/convert_to_project_form.dart';

import '../../../../data/network/contractor/model/contractot_service_model/contractor_service_model.dart';
import '../../../../widgets/New folder/inputs/dropdown_field.dart';
import '../../../../widgets/bar/filter_bar/filter_chip_bar.dart';
import '../../../add_property/view/create_property.dart';
import '../../controller/contractor_my_service_controller.dart';

class ContractorLeadScreen extends StatelessWidget {
  const ContractorLeadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContractorLeadController());
    RxMap<String, String> selectedFilters = <String, String>{}.obs;
    final serviceController=Get.find<ContractorMyServiceController>();

    return Scaffold(
      backgroundColor: ColorRes.background,
      appBar: AppBar(
        backgroundColor: ColorRes.surface,
        title: const Text(
          "Contractor Leads",
          style: TextStyle(
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textPrimary,
          ),
        ),
        elevation: 1,
        actions: [
          // IconButton(onPressed: () {
          //   Get.to(()=>ContractorInquiryFilter());
          // }, icon: Icon(Icons.filter_list))
          IconButton(
            onPressed: () async {
              final result = await Get.dialog<Map<String, String>>(
                const ContractorLeadFilter(),
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
            icon: const Icon(Icons.filter_list),
          )

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
                final items = controller.items;
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // if (controller.items.isEmpty) {
                //   return const Center(
                //     child: Text(
                //       "No leads found.",
                //       style: TextStyle(
                //         color: ColorRes.textSecondary,
                //         fontSize: AppFontSizes.body,
                //       ),
                //     ),
                //   );
                // }

                return RefreshIndicator(
                    onRefresh: controller.refreshLead,
                    color: ColorRes.primary,
                    child: items.isEmpty?SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Center(
                          child: Text(
                            "No Lead available",
                            style: TextStyle(
                              fontSize: AppFontSizes.body,
                              color: ColorRes.textSecondary,
                              fontWeight: AppFontWeights.medium,
                            ),
                          ),
                        ),
                      ),
                    ) :ListView.separated(
                  padding: const EdgeInsets.all(12),
                  separatorBuilder: (_, __) => const SizedBox(height: 2),
                  itemCount: controller.items.length,
                  itemBuilder: (context, index) {
                    final item = controller.items[index];
                    ContractorServiceItem? serviceData = serviceController.items.value.firstWhere(
                          (e) => e.id == item.customFields?.serviceId,
                      orElse: () => ContractorServiceItem(
                        id: '',
                        category: '',
                        contractorId: '',
                        serviceName: '',
                        description: '',
                        isActive: false,
                        meta: ContractorMetaData(
                          priceModel: '',
                          maxPriceRange: 0,
                          minPriceRange: 0,
                          workAvailability: '',
                          provideMaterials: false,
                          brandsUsed: '',
                          equipmentProvided: false,
                          insuranceAvailable: false,
                          acceptedPaymentModes: [],
                          advanceRequiredPercentage: 0,
                          billingType: '',
                        ),
                        createdAt: '',
                        updatedAt: '',
                      ),
                    );


                    return Obx(
                      () => ContractorLeadCard(
                        item: item,
                        isExpanded: controller.isExpanded(item.id ?? ''),
                        onPress: () => controller.toggleCard(item.id ?? ""),
                        onConvert:()=> Get.to(()=>AddProjectScreen(item: item,)),
                        onOverview: () => Get.to(()=>ContractorLeadOverview(leadItem: item,serviceItem: serviceData,)),
                        // onConvert: () => controller.showConvertDialog(item),

                        onDelete: ()=> controller.deleteLead(item.id??'',item.name??''),
                        onAction: ()=>_showStatusDialog(context,controller,item),
                        onEdit: () => Get.to(()=>ContractorLeadEditScreen(lead: item,)),
                      ),
                    );
                  },
                ),);
              }),
            ),
          ],
        ),
      ),
    );
  }
}

///
/// ✅ Reusable Contractor Lead Card
///
class ContractorLeadCard extends StatelessWidget {
  final ContractorLeadItem item;
  final bool isExpanded;
  final VoidCallback onPress;
  final VoidCallback onConvert;
  final VoidCallback onDelete;
  final VoidCallback onAction;
  final VoidCallback onOverview;
  final VoidCallback onEdit;

  const ContractorLeadCard({
    super.key,
    required this.item,
    required this.isExpanded,
    required this.onPress,
    required this.onConvert, required this.onDelete, required this.onAction, required this.onOverview,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPress,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.name ?? "Unknown Lead",
                      style: const TextStyle(
                        fontSize: AppFontSizes.medium,
                        color: ColorRes.textColor,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  _buildStatusBadge(item.status ?? ''),
                  SizedBox(width: 8),
                  _buildStageBadge(item.stage ?? ''),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.phone, item.phone ?? ''),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.email, item.email ?? ''),

              if (isExpanded) ...[
                const SizedBox(height: 12),
                const Divider(height: 1, color: ColorRes.divider),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (item.customFields?.isConvertedToProject ?? false)
                            ? null // 👈 Disable tap when converted
                            : onEdit,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (item.customFields?.isConvertedToProject ?? false)
                                ? ColorRes.leadGreyColor.withOpacity(0.15)
                                : ColorRes.blueColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.edit,
                            color: (item.customFields?.isConvertedToProject ?? false)
                                ? ColorRes.grey
                                : ColorRes.blueColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),
                    // Delete Icon
                    Expanded(
                      child: GestureDetector(
                        onTap:onDelete,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ColorRes.error.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: ColorRes.error,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Visibility Icon
                    Expanded(
                      child: GestureDetector(
                        onTap:
                           onOverview,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ColorRes.grey.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: const Icon(
                            Icons.visibility,
                            color: ColorRes.grey,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: ColorRes.divider),
                const SizedBox(height: 12),

                _infoRow("Source", item.source ?? "-"),
                _infoRow(
                  "Created Date",
                  item.createdAt != null
                      ? "${item.createdAt!.day}-${item.createdAt!.month}-${item.createdAt!.year}"
                      : "-",
                ),
                _infoRow(
                  "Contractor Username",
                  "@${item.customFields?.contractorUsername ?? '-'}",
                ),
                // _infoRow(
                //     "Service Name", item.customFields?.serviceName ?? "-"),
                _infoRow(
                  "Project Conversion",
                  (item.customFields?.isConvertedToProject ?? false)
                      ? "Converted"
                      : "Not Converted",
                ),
                Divider(color: ColorRes.leadGreyColor.shade300),
                const SizedBox(height: 12),
                _buildSectionTitle('Service Description'),
                const SizedBox(height: 8),
                Text(
                  item.customFields?.serviceName ?? '',
                  style: const TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                // Convert Button
                if (!(item.customFields?.isConvertedToProject ?? false))
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onConvert,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorRes.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Convert to Project",
                        style: TextStyle(
                          color: ColorRes.white,
                          fontSize: AppFontSizes.bodySmall,
                          fontWeight: AppFontWeights.semiBold,
                        ),
                      ),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () {
                      Get.snackbar(
                        'Already Convert',
                        colorText: ColorRes.white,
                        backgroundColor: ColorRes.error,
                        'One time convert into project',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    child: Container(
                      height: 42,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ColorRes.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Already Converted",
                        style: TextStyle(
                          color: ColorRes.green,

                          fontSize: AppFontSizes.bodySmall,
                          fontWeight: AppFontWeights.semiBold,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 8),

                // Action Buttons
                // SizedBox(
                //   width: double.infinity,
                //   child: ElevatedButton(
                //     onPressed: onAction,
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: ColorRes.primary,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //     ),
                //     child: const Text(
                //       "Action",
                //       style: TextStyle(
                //         color: ColorRes.white,
                //         fontSize: AppFontSizes.bodySmall,
                //         fontWeight: AppFontWeights.semiBold,
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (item.customFields?.isConvertedToProject ?? false)
                        ? null // 👈 disables button when converted
                        : onAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (item.customFields?.isConvertedToProject ?? false)
                          ? ColorRes.grey.withOpacity(0.4)
                          : ColorRes.primary,
                      disabledBackgroundColor: ColorRes.grey.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      (item.customFields?.isConvertedToProject ?? false)
                          ? "Action Disabled"
                          : "Action",
                      style: TextStyle(
                        color: (item.customFields?.isConvertedToProject ?? false)
                            ? ColorRes.textSecondary
                            : ColorRes.white,
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) => Row(
    children: [
      Icon(icon, size: 16, color: ColorRes.primary),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          style: TextStyle(
            fontSize: AppFontSizes.caption,
            color: ColorRes.textSecondary,
            fontWeight: AppFontWeights.medium,
          ),
        ),
      ),
    ],
  );

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            '$label : ',
            style: const TextStyle(
              fontSize: AppFontSizes.caption,
              color: ColorRes.textSecondary,
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            flex: 3,
            child: Text(
              '$value',
              style: const TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChips(ContractorLeadItem item) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
      child: Wrap(
        spacing: 8,
        children: [
          Chip(
            backgroundColor: ColorRes.green.withOpacity(0.1),
            label: Text(
              "Status: ${item.status ?? '-'}",
              style: const TextStyle(
                color: ColorRes.green,
                fontSize: AppFontSizes.small,
              ),
            ),
          ),
          Chip(
            backgroundColor: ColorRes.purpleColor.withOpacity(0.1),
            label: Text(
              "Stage: ${item.stage ?? '-'}",
              style: const TextStyle(
                color: ColorRes.purpleColor,
                fontSize: AppFontSizes.small,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildStatusBadge(String status) {
  Color color;

  switch (status.toLowerCase()) {
    case 'converted':
      color = ColorRes.green;
      break;
    case 'new':
      color = ColorRes.primary;
      break;
    case 'contacted':
      color = ColorRes.blueColor; // adjust if you have a different color
      break;
    case 'qualified':
      color = ColorRes.orangeColor;
      break;
    case 'negotiation':
      color = ColorRes.purpleColor; // assign a color
      break;
    case 'lost':
      color = ColorRes.error;
      break;
    default:
      color = ColorRes.grey;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      // Capitalize each word properly
      status
          .split(RegExp(r'[_\s]')) // split by underscore or space
          .map(
            (word) =>
                word.isNotEmpty
                    ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                    : '',
          )
          .join(' '),
      style: TextStyle(
        fontSize: AppFontSizes.caption,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    ),
  );
}

Widget _buildSectionTitle(String title) => Text(
  title,
  style: const TextStyle(
    fontSize: AppFontSizes.medium,
    fontWeight: AppFontWeights.semiBold,
    color: ColorRes.textPrimary,
  ),
);

Widget _buildStageBadge(String stage) {
  Color color;

  switch (stage.toLowerCase().replaceAll("_", " ")) {
    case 'new lead':
      color = ColorRes.primary;
      break;
    case 'contacted':
      color = ColorRes.blueColor; // adjust if needed
      break;
    case 'interested':
      color = ColorRes.orangeColor;
      break;
    case 'site visit':
      color = ColorRes.purpleColor; // assign a color
      break;
    case 'sell':
      color = ColorRes.green;
      break;
    default:
      color = ColorRes.grey;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      // Capitalize each word properly
      stage
          .split(RegExp(r'[_\s]')) // split by underscore or space
          .map(
            (word) =>
                word.isNotEmpty
                    ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                    : '',
          )
          .join(' '),
      style: TextStyle(
        fontSize: AppFontSizes.caption,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    ),
  );
}

void _showStatusDialog(
    BuildContext context,
    ContractorLeadController controller,
    ContractorLeadItem inquiry,
    ) {
  const List<String> leadStatuses = [
    'New',
    'Contacted',
    'Qualified',
    'Negotiation',
    'Lost',
    'Converted',
  ];

  const List<String> leadStages = [
    'New Lead',
    'Contacted',
    'Interested',
    'Site Visit',
    'Sell',
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
                    child: const Icon(Icons.close_rounded,
                        color: ColorRes.white, size: 20),
                  ),
                ],
              ),
            ),

            // ---------------- BODY ----------------
            Flexible(
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                        items: leadStatuses
                            .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) {
                          controller.setValue(controller.changeStatus, val);
                          log("Contractor_status ${controller.changeStatus.value}");
                        },
                        darkText: true,
                      );
                    }),

                    const SizedBox(height: 20),
                    buildSectionTitle('Change Stage'),
                    const SizedBox(height: 8),
                    Obx(() {
                      return NesticoPeDropdownField<String>(
                        isRequired: true,
                        value: controller.changeStage.value,
                        hintText: "Select stage",
                        prefixIcon: Icons.stacked_bar_chart_outlined,
                        items: leadStages
                            .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) {
                          controller.setValue(controller.changeStage, val);
                          log("Contractor_stage ${controller.changeStage.value}");
                        },
                        darkText: true,
                      );
                    }),
                  ],
                ),
              ),
            ),

            // ---------------- FOOTER BUTTONS ----------------
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        final stage = controller.changeStage.value;

                        if (status.isEmpty && stage.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Please select at least one value",
                            backgroundColor: ColorRes.error.shade100,
                            colorText: ColorRes.error.shade700,
                          );
                          return;
                        }

                         controller.updateTheStatusAndStage(
                          leadId: inquiry.id ?? "",
                          status: status,
                          stage: stage,
                        );
                        Get.back(); // close dialog
                        controller.changeStatus.value='';
                        controller.changeStage.value='';
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
