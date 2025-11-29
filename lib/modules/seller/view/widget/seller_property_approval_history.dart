import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/widgets/dialogs/show_long_text_dialog.dart';
import 'package:intl/intl.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../data/network/property_approval_history/model/property_approval_history.dart';
import '../../controllers/seller_property_approval_history_controller.dart';

class SellerPropertyApprovalHistory extends StatelessWidget {
  final String propertyId;

  const SellerPropertyApprovalHistory({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ApprovalHistoryController());

    // Load data on screen open
    controller.loadApprovalHistory(propertyId);

    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        backgroundColor: ColorRes.white,
        elevation: 0,
        title: const Text(
          "Approval History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.approvalHistory.isEmpty) {
          return const Center(child: Text("No approval history found"));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildCountHeader(controller.approvalHistory.length),
            const SizedBox(height: 16),
            ...controller.approvalHistory
                .map((item) => _buildHistoryCard(item, context))
                .toList(),
          ],
        );
      }),
    );
  }

  // ---------------------------------------------------------------------------
  // UI: TOP COUNT HEADER
  // ---------------------------------------------------------------------------
  Widget _buildCountHeader(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorRes.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.history, color: Colors.blue, size: 20),
          const SizedBox(width: 8),
          const Text(
            "Approval History",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text("$count Record", style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UI: APPROVAL HISTORY CARD
  // ---------------------------------------------------------------------------
  Widget _buildHistoryCard(ApprovalHistory item, context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              // STATUS TAG
              _buildAdmin(item.adminName),

              Spacer(),

              _buildStatusTag(item.action),
              // ACTION DATE (right side)
            ],
          ),
          const SizedBox(height: 12),

          // MAIN DATA SECTION
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _buildDateTime(item.actionDate),
              // const SizedBox(height: 12),

              // const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildStatusTransition(item)),
                  SizedBox(width: 12),
                  Text(
                    _timeAgo(item.actionDate),
                    style: const TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildReason(item.reason, context),

              // const SizedBox(height: 12),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UI SUB-COMPONENTS
  // ---------------------------------------------------------------------------

  Widget _buildStatusTag(String status) {
    final isApproved = status == "approved";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: isApproved ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isApproved ? Colors.green : Colors.red),
      ),
      child: Text(
        status.capitalize ?? "",
        style: TextStyle(
          fontWeight: AppFontWeights.semiBold,
          fontSize: AppFontSizes.small,
          color: isApproved ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  Widget _buildDateTime(DateTime date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Date & Time",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat("dd MMM yyyy, hh:mm a").format(date),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildAdmin(String name) {
    return Row(
      children: [
        const Icon(Icons.person, size: 16),
        const SizedBox(width: 6),
        Text(
          name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildStatusTransition(ApprovalHistory item) {
    return Row(
      children: [
        _chip(item.previousStatus),
        const SizedBox(width: 6),
        const Icon(Icons.arrow_forward, size: 18, color: Colors.grey),
        const SizedBox(width: 6),
        _chip(item.newStatus),
      ],
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildReason(String? reason, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (reason != null) {
          showContentDialog(context: context, content: reason);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue.shade100),
        ),
        child: Text(
          reason ?? "No reason provided",
          style: const TextStyle(fontSize: AppFontSizes.bodySmall),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UTILITY: Time Ago
  // ---------------------------------------------------------------------------
  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return "${diff.inDays} day(s) ago";
    if (diff.inHours > 0) return "${diff.inHours} hour(s) ago";
    if (diff.inMinutes > 0) return "${diff.inMinutes} min ago";
    return "Just now";
  }
}
