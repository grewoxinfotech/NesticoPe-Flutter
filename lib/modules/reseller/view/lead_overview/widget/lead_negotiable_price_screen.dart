import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart';
import 'package:housing_flutter_app/modules/reseller/view/lead_overview/widget/lead_follow_up_screen.dart';
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
        final buyerIds = widget.controller.items
            .map((item) => item.buyerId)
            .whereType<String>() // removes null values safely
            .toList();

        // Log or debug
        log("✅ Extracted Buyer IDs: $buyerIds");

        // Optionally: fetch profiles for each buyer
        for (final id in buyerIds) {

          widget.controller.getTheVisitersProfile(id);
        }



        return RefreshIndicator(
          onRefresh: widget.controller.refreshLead,
          color: ColorRes.primary,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: ColorRes.white,
        border: Border.all(color: ColorRes.leadGreyColor.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -------------------- BUYER + STATUS --------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // BUYER SECTION
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "BUYER",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: AppFontSizes.small,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: ColorRes.leadGreyColor.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.account_circle_outlined,
                              size: 20, color: Colors.grey),
                          const SizedBox(width: 6),

                          Flexible(
                            child: Obx(() {
                              final username = controller.buyerProfiles[item.buyerId]?.username ?? 'John D.';
                              return Text(
                                username,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: AppFontWeights.semiBold,
                                  color: ColorRes.textColor,
                                  fontSize: AppFontSizes.bodySmall,
                                ),
                              );
                            }),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // STATUS SECTION
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [

                    Column(
                      children: [
                        Text(
                          "New Status",
                          style: TextStyle(
                            color: ColorRes.leadGreyColor.shade600,
                            fontSize: AppFontSizes.small,
                            fontWeight: AppFontWeights.medium,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                             Icon(Icons.circle, size: 10, color:getStatusColor(item.newStatus)),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                (item.newStatus!=null)?capitalizeEachWord(item.newStatus):"N/A",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: AppFontWeights.semiBold,
                                  fontSize: AppFontSizes.bodySmall,
                                  color: ColorRes.textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Column(
                      children: [
                        Text(
                          "Old Status",
                          style: TextStyle(
                            color: ColorRes.leadGreyColor.shade600,
                            fontSize: AppFontSizes.small,
                            fontWeight: AppFontWeights.medium,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                             Icon(Icons.circle, size: 10, color: getStatusColor(item.oldStatus)),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                  (item.oldStatus!=null)?capitalizeEachWord(item.oldStatus):"N/A",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: AppFontWeights.semiBold,
                                  fontSize: AppFontSizes.bodySmall,
                                  color: ColorRes.textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // -------------------- PRICE SECTION --------------------

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Negotiable Price",
                style: TextStyle(
                  color: ColorRes.leadGreyColor.shade600,
                  fontWeight: AppFontWeights.medium,
                  fontSize: AppFontSizes.small,
                ),
              ),
              Text(
                "Previous Price",
                style: TextStyle(
                  color: ColorRes.leadGreyColor.shade600,
                  fontWeight: AppFontWeights.medium,
                  fontSize: AppFontSizes.small,
                ),
              ),

            ],
          ),
          Row(

            children: [
              Expanded(
                child: Text(
      item.negotiablePrice.toString(),
                  style:  TextStyle(
                    fontSize: AppFontSizes.body,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textColor,
                  ),
                ),
              ),


              Text(
                "${item.previousNegotiablePrice}",
                style: TextStyle(
                  color: ColorRes.textColor,
                  fontWeight: AppFontWeights.medium,
                  fontSize: AppFontSizes.body,
                ),
              ),
            ],
          ),



          // -------------------- BUTTONS --------------------
          if(item.newStatus?.toLowerCase()=="pending")...[
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.openAddFollowUpDialog();
                      controller.populatedContainData(item);
                    },
                    icon: const Icon(Icons.close, color: ColorRes.error),
                    label: const Text(
                      "Reject",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorRes.error,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFFFFEAEA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.updateTheDataApproved(item.id ?? '');
                    },
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text(
                      "Approve",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ]
        ],
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
