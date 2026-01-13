import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/auth/model/user_model.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_lead_controller.dart';
import 'package:intl/intl.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/seller/module/lead_screen/controllers/lead_visit_controller.dart';

import '../../../../../data/network/lead/model/lead_visit_model.dart';
import '../../../../seller/module/lead_screen/controllers/lead_property_inquiry_controller.dart';
import 'lead_follow_up_screen.dart';

class LeadVisit extends StatefulWidget {
  final LeadVisitController leadVisitController;
  final LeadPropertyInquiryController propertyInquiryController;
  final String? propertyId;
  final String? buyerID;

  const LeadVisit({
    super.key,
    required this.leadVisitController,
    required this.propertyInquiryController,
    this.propertyId,
    this.buyerID,
  });

  @override
  State<LeadVisit> createState() => _LeadVisitState();
}

class _LeadVisitState extends State<LeadVisit> {
  String formatDate(String? date) {
    if (date == null) return "N/A";
    try {
      final parsed = DateTime.parse(date);
      return DateFormat(' MM/dd/yyyy').format(parsed);
    } catch (_) {
      return date;
    }
  }

  String formatTime(String? time) {
    if (time == null || time.isEmpty) return "N/A";
    try {
      // Parse 24-hour time (HH:mm)
      final parsedTime = DateFormat("HH:mm").parse(time);
      // Format to 12-hour with AM/PM
      return DateFormat("h:mm a").format(parsedTime);
    } catch (e) {
      return time; // fallback to original if parsing fails
    }
  }

  late final leadVisitController = widget.leadVisitController;
  late final propertyInquiryController = widget.propertyInquiryController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final selectedInquiry = propertyInquiryController?.selectedInquiry.value;

    if (selectedInquiry != null) {
      // Set visit id
      print(
        'Setting visit ID for uservcgfd ${widget.buyerID} and property ${widget.propertyId}',
      );
      print(
        'Setting USer ID for user ${selectedInquiry.toMap()} and property ${selectedInquiry.propertyId}',
      );
      leadVisitController.setLeadVisitId(widget.buyerID, widget.propertyId);
      print('Visit ID set: ${leadVisitController.items.map((e) => e.toMap())}');
    }
    else if(widget.propertyId!=null){
      print(
        'Setting Buyeer ID for uservcgfd ${widget.buyerID} and property ${widget.propertyId}',
      );
      leadVisitController.setLeadVisitId(widget.buyerID, widget.propertyId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        backgroundColor: ColorRes.white,
        elevation: 0,
        title: Text(
          'Visit Request',
          style: TextStyle(
            color: ColorRes.textColor,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
      ),
      body: Obx(() {
        if (leadVisitController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (leadVisitController.items.isEmpty) {
          return Center(
            child: Text(
              'No Visit Requests Found',
              style: TextStyle(
                fontSize: AppFontSizes.large,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.leadGreyColor[600],
              ),
            ),
          );
        } else {
          // Convert all visit items to a list of buyerIds (non-null, non-empty)
          final buyerIds = leadVisitController.items
              .map((element) => element.buyerId)
              .where((id) => id != null && id!.isNotEmpty)
              .cast<String>()
              .toList();

          // Fetch visitors’ profiles using the collected buyerIds
          // if (buyerIds.isNotEmpty) {
          //   leadVisitController.getTheVisitersProfile(buyerIds);
          // }
          for(var visit in buyerIds)
            {
              log("Selected Data From Visit ${visit}");
              leadVisitController.getTheVisitersProfile(visit);
            }

          log("Selected Visit: ${leadVisitController.selectedVisit.value?.toJson()}");

          return RefreshIndicator(
            onRefresh: leadVisitController.refreshLead,
            color: ColorRes.primary,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: leadVisitController.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final visit = leadVisitController.items[index];

                // Retrieve the user profile based on buyerId
                final user = leadVisitController.userProfiles[visit.buyerId];
                log("USrtr Data From Visit ${user?.toJson()}");

                return _buildVisitCard(context, visit, leadVisitController, user);
              },
            ),
          );
        }

      }),
    );
  }

  Widget _buildVisitCard(
    BuildContext context,
    LeadVisitItem visit,
    LeadVisitController controller, User? user,


  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: ID + Status
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              StatefulBuilder(
                builder: (context, setState) =>  Expanded(
                  child: _buildPersonTile(
                    title: "Buyer",
                    name:
                        user?.username ??
                        "Unknown Buyer",
                    id: "${user?.email}",

                    avatarColor: Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(visit.status).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  (capitalizeEachWord(visit.status) ?? 'N/A'),
                  style: TextStyle(
                    fontWeight: AppFontWeights.semiBold,
                    fontSize: AppFontSizes.small,
                    color: _getStatusColor(visit.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Divider(color: ColorRes.leadGreyColor.shade300),

          // Date + Time
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInfoBox(
                  icon: Icons.calendar_today,
                  label: "DATE",
                  value: formatDate(visit.visitDate),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoBox(
                  icon: Icons.access_time,
                  label: "TIME",
                  value: formatTime(visit.timeSlot),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Notes
          if ((visit.notes ?? '').isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Notes",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                      fontSize: AppFontSizes.small,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      '${visit.notes}' ?? "",
                      style: TextStyle(
                        color: ColorRes.leadGreyColor.shade600,
                        fontSize: AppFontSizes.small,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          if ((visit.cancellationReason?.isNotEmpty ?? false) ||
              (visit.cancellationReason != null)) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Reason",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                      fontSize: AppFontSizes.small,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      '${visit.cancellationReason}' ?? "",
                      style: TextStyle(
                        color: ColorRes.leadGreyColor.shade600,
                        fontSize: AppFontSizes.small,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Created date
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                "Created ${_formatCreatedAt(visit.createdAt)}",
                style: TextStyle(
                  color: ColorRes.leadGreyColor.shade600,
                  fontSize: AppFontSizes.caption,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: reject action
                controller.openAddFollowUpDialog();
                controller.populatePayloadData(visit);
              },
              icon: const Icon(Icons.timer_outlined, color: ColorRes.white),
              label: const Text(
                "Rescheduled",
                style: TextStyle(color: ColorRes.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorRes.primary,
                side: const BorderSide(color: ColorRes.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Accept / Reject buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.deleteLead();
                    controller.populatePayloadData(visit);
                  },
                  icon: const Icon(Icons.cancel_outlined, color: Colors.white),
                  label: const Text("Reject"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorRes.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: accept action

                    controller.approvedVisite(visit.id ?? '');
                  },
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text("Approved"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonTile({
    required String title,
    required String name,
    required String id,
    required Color avatarColor,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: avatarColor.withOpacity(0.2),
          child: Icon(Icons.person, color: avatarColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$title : $name",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textColor,
                  fontSize: AppFontSizes.medium,
                ),
              ),
              Text(
                "$id",
                style: TextStyle(
                  color: ColorRes.leadGreyColor.shade600,
                  fontSize: AppFontSizes.caption,
                  fontWeight: AppFontWeights.medium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorRes.leadGreyColor.shade50,
        border: Border.all(color: ColorRes.leadGreyColor.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(icon, color: ColorRes.primary, size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: ColorRes.leadGreyColor,
                    fontSize: AppFontSizes.caption,
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: AppFontWeights.medium,
                    fontSize: AppFontSizes.small,
                    color: ColorRes.textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCreatedAt(String? date) {
    if (date == null) return "N/A";
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('MMM d, hh:mm a').format(parsed);
    } catch (_) {
      return date;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return ColorRes.orangeColor;
      case 'confirmed':
        return ColorRes.green;
      case 'rescheduled':
        return ColorRes.homeAmber;
        case 'cancelled':
        return ColorRes.error;
      default:
        return Colors.grey;
    }
  }
}
