import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../seller/module/lead_screen/model/lead_model.dart';
import '../../controllers/my_contractor_controller.dart';
// import 'widgets/contractor_card_widget.dart';

class MyContractorScreen extends StatelessWidget {
  const MyContractorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyContractorController());

    return Scaffold(
      appBar: AppBar(
        title:  Text('My Contractors',style: TextStyle(fontWeight: AppFontWeights.semiBold),),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F6F8),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.items.isEmpty) {
          return const Center(child: Text("No contractor leads found"));
        }

        // ✅ Filter the list safely before building UI
        final validItems = controller.items.where((lead) {
          final custom = lead.customFields;
          return custom != null && (custom.serviceId?.isNotEmpty ?? false);
        }).toList();

        log("My Contractor Data ${controller.items.map((element) => element.toJson(),)}");
        if (validItems.isEmpty) {
          return const Center(child: Text("No valid contractor services found"));
        }

        return RefreshIndicator(
          onRefresh: controller.refreshLead,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: validItems.length,
            itemBuilder: (context, index) {
              final lead = validItems[index];
              return ContractorCardWidget(lead: lead,controller: controller,);
            },
          ),
        );
      }),
    );
  }
}


class ContractorCardWidget extends StatefulWidget {
  final NewUpdatedLeadModel lead;
  final MyContractorController controller;

  const ContractorCardWidget({
    super.key,
    required this.lead,
    required this.controller,
  });

  @override
  State<ContractorCardWidget> createState() => _ContractorCardWidgetState();
}

class _ContractorCardWidgetState extends State<ContractorCardWidget> {
  bool hasReviewed = false;
  bool isLoadingReview = false;

  @override
  void initState() {
    super.initState();
    _checkReviewStatus();
  }

  Future<void> _checkReviewStatus() async {
    final custom = widget.lead.customFields;
    if (custom?.serviceId == null) return;

    setState(() => isLoadingReview = true);

    try {
      final result = await widget.controller.checkReviewDone(custom!.serviceId!);
      setState(() {
        hasReviewed = result;
      });
    } catch (e) {
      debugPrint("❌ Error checking review: $e");
    } finally {
      setState(() => isLoadingReview = false);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "N/A";
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final lead = widget.lead;
    final custom = lead.customFields;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: ColorRes.propertyBg,
                child: const Icon(Icons.work_outline, color: ColorRes.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      custom?.serviceName ?? 'N/A',
                      maxLines: 1,
                      style: const TextStyle(
                        fontWeight: AppFontWeights.semiBold,
                        fontSize: AppFontSizes.body,
                        color: ColorRes.textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Service Request',
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        color: ColorRes.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  (lead.status ?? 'Converted').toUpperCase(),
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    fontWeight: AppFontWeights.semiBold,
                    color: Colors.green.shade800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          const Divider(color: ColorRes.divider),

          const SizedBox(height: 8),
          _buildInfoRow(Icons.check_circle_outline, 'Status:',
              lead.status?.capitalizeFirst ?? 'N/A', Colors.black),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.list_alt_outlined, 'Stage:',
              _capitalizeWords(lead.stage ?? ''), Colors.blue),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.calendar_today_outlined, 'Created:',
              _formatDate(lead.createdAt), Colors.black),

          const SizedBox(height: 8),
          const Divider(color: ColorRes.divider),

          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person_outline,
                  color: ColorRes.textSecondary, size: 20),
              const SizedBox(width: 8),
              const Text(
                "Contractor:",
                style: TextStyle(
                  fontSize: AppFontSizes.bodySmall,
                  fontWeight: AppFontWeights.medium,
                  color: ColorRes.textColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                custom?.contractorUsername ?? 'N/A',
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: AppFontSizes.bodySmall,
                  fontWeight: AppFontWeights.semiBold,
                  decoration: TextDecoration.underline,
                ),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, color: ColorRes.textSecondary),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(color: ColorRes.divider),
          const SizedBox(height: 12),

          // ✅ Review Button (dynamic)
          SizedBox(
            width: double.infinity,
            child: isLoadingReview
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
              onPressed: hasReviewed
                  ? null
                  : () {
                widget.controller.openAddFollowUpDialog(
                  custom?.serviceName ?? '',
                  custom?.contractorUsername ?? '',
                  custom?.serviceId??''
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                hasReviewed ? Colors.green : Colors.blue.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: Icon(
                hasReviewed ? Icons.check_circle : Icons.star,
                color: Colors.white,
              ),
              label: Text(
                hasReviewed ? "Reviewed" : "Add Review",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppFontSizes.body,
                  fontWeight: AppFontWeights.semiBold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, String value, Color valueColor) {
    return Row(
      children: [
        Icon(icon, color: ColorRes.textSecondary, size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: ColorRes.textSecondary,
            fontSize: AppFontSizes.bodySmall,
            fontWeight: AppFontWeights.medium,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value.isNotEmpty ? value : 'N/A',
          style: TextStyle(
            fontSize: AppFontSizes.bodySmall,
            fontWeight: AppFontWeights.semiBold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  String _capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text
        .split('_')
        .map((word) =>
    word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
}