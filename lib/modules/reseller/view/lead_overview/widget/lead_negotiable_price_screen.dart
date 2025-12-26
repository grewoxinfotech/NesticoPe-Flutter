import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart';
import 'package:intl/intl.dart';
import '../../../../../app/constants/color_res.dart';
import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../data/network/lead/model/lead_property_price_negotiable.dart';
import '../../../../contractor/controller/contractor_lead_controller.dart';
import '../../../../seller/module/lead_screen/controllers/lead_property_negotiable_price_controller.dart';

class LeadNegotiablePriceScreen extends StatefulWidget {
  final LeadPropertyNegotiablePriceController controller;

  LeadNegotiablePriceScreen({super.key, required this.controller});

  @override
  State<LeadNegotiablePriceScreen> createState() =>
      _LeadNegotiablePriceScreenState();
}

class _LeadNegotiablePriceScreenState extends State<LeadNegotiablePriceScreen> {
  String formatDate(String? isoDate) {
    if (isoDate == null) return '-';
    try {
      final date = DateTime.parse(isoDate).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (_) {
      return isoDate;
    }
  }

  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Negotiable Prices',
          style: TextStyle(fontWeight: AppFontWeights.semiBold),
        ),
      ),
      body: Obx(() {
        if (widget.controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = widget.controller.items;

        if (items.isEmpty) {
          return const Center(child: Text('No negotiable prices found.'));
        }

        return RefreshIndicator(
          onRefresh: widget.controller.refreshLead,
          color: ColorRes.primary,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              widget.controller.getTheVisitersProfile(item.buyerId ?? '');
              return _buildNegotiableCard(item, context, widget.controller);
            },
          ),
        );
      }),
    );
  }

  Widget _buildNegotiableCard(
    NegotiableItem item,
    BuildContext context,
    LeadPropertyNegotiablePriceController controller,
  ) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Obx(() =>  _buildLabelValue('Buyer ID', controller.selectedVisit.value?.username ?? '-')),
                ),
              ],
            ),
            Divider(height: 20,color: ColorRes.leadGreyColor.shade300,),
            // Top Row - Buyer and Selle
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabelValue(
                      'Proposed New Price',
                      '₹ ${_formatNumber(item.negotiablePrice)}',
                    ),
                    const SizedBox(height: 8),
                    _buildLabelValue(
                      'Negotiable Price',
                      '₹ ${_formatNumber(item.previousNegotiablePrice)}',
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    buildSectionTitle('New Status'),
                    SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: getStatusColor(item.newStatus).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (capitalizeEachWord(item.newStatus) ?? 'N/A'),
                        style: TextStyle(
                          fontWeight: AppFontWeights.semiBold,
                          fontSize: AppFontSizes.small,
                          color: getStatusColor(item.newStatus),
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    buildSectionTitle('Old Status'),
                    SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: getStatusColor(item.oldStatus).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          item.oldStatus == null
                              ? Text(
                                ('N/A'),
                                style: TextStyle(
                                  fontWeight: AppFontWeights.semiBold,
                                  fontSize: AppFontSizes.small,
                                  color: getStatusColor(item.oldStatus),
                                ),
                              )
                              : Text(
                                (capitalizeEachWord(item.oldStatus ?? 'N/A') ??
                                    'N/A'),
                                style: TextStyle(
                                  fontWeight: AppFontWeights.semiBold,
                                  fontSize: AppFontSizes.small,
                                  color: getStatusColor(item.oldStatus),
                                ),
                              ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Dates
            _buildLabelValue('Created At', formatDate(item.createdAt)),
            _buildLabelValue('Updated At', formatDate(item.updatedAt)),
            if (item.rejectionReason?.isNotEmpty ?? false) ...[
              _buildLabelValue('Rejection Reason', item.rejectionReason ?? ''),
            ],

            const SizedBox(height: 12),

            // Action Buttons
            Row(
              children: [

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: reject action
                         controller.openAddFollowUpDialog();
                        controller.populatedContainData(item);
                      },
                      icon: const Icon(Icons.timer_outlined, color: ColorRes.white),
                      label: const Text(
                        "Rejected",
                        style: TextStyle(color: ColorRes.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorRes.error,
                        side: const BorderSide(color: ColorRes.error),
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
                        // if(visit.status!="confirmed"){
                        //   controller.approvedVisite(visit.id??'');
                        // }else{
                        //
                        // }
                        controller.updateTheDataApproved(item.id??'');



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
      ),
    );
  }

  Widget _buildLabelValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.leadGreyColor.shade600,
              fontSize: AppFontSizes.small,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(String? value) {
    if (value == null) return '-';
    try {
      final number = double.parse(value);
      final formatter = NumberFormat('#,##,###');
      return formatter.format(number);
    } catch (_) {
      return value;
    }
  }
}
