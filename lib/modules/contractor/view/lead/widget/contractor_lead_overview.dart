import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:intl/intl.dart';
import '../../../../../app/constants/color_res.dart';
import '../../../../../app/constants/app_font_sizes.dart';
import 'package:get/get.dart';
import '../../../../../data/network/contractor/model/contractor_lead_model/contractor_lead_model.dart';
import '../../../../../data/network/contractor/model/contractot_service_model/contractor_service_model.dart';
import '../../../../reseller/view/lead_overview/widget/lead_follow_up_screen.dart';
import '../follow_up/contractor_follow_up_screen.dart';

class ContractorLeadOverview extends StatelessWidget {
  final ContractorLeadItem leadItem;
  final ContractorServiceItem serviceItem;


  const ContractorLeadOverview({
    super.key,
    required this.leadItem,
    required this.serviceItem,
  });

  @override
  Widget build(BuildContext context) {
    log("Service Id ${serviceItem.id}");
    log("Lead Items ${leadItem.id}  ${leadItem.customFields?.serviceId}");
    return Scaffold(
      backgroundColor: ColorRes.background,
      appBar: AppBar(
        title: const Text(
          "Overview",
          style: TextStyle(
            color: ColorRes.black,
            fontWeight: AppFontWeights.bold,
          ),
        ),
        backgroundColor: ColorRes.surface,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorRes.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            child:  Text('Follow Up'),
            onPressed: () {

              Get.to(()=>ContractorFollowUpScreen(lead:leadItem));
              log("Lead To Follow Up ${leadItem}");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
        child: Column(
          children: [
            _buildServiceDetailsCard(),
            const SizedBox(height: 12),
            _buildLeadDetailsCard(),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceDetailsCard() {
    final meta = serviceItem.meta;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(color: ColorRes.leadGreyColor.shade300,width: 1)),
      elevation: 1,
      color: ColorRes.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Service Details"),
            const SizedBox(height: 8),

            Text(
              serviceItem.serviceName,
              style: TextStyle(
                fontSize: AppFontSizes.large,
                color: ColorRes.textPrimary,
                fontWeight: AppFontWeights.semiBold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              serviceItem.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:  TextStyle(

                fontSize: AppFontSizes.small,
                color: ColorRes.leadGreyColor.shade700,
                fontWeight: AppFontWeights.medium
              ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                 Icon(Icons.star, color: Colors.amber, size: 20),
                 SizedBox(width: 4),
                Text(
                  "${serviceItem.averageRating} (${Formatter.formatNumber(serviceItem.totalReviews??0)} review)",
                  style: const TextStyle(
                    fontSize: AppFontSizes.small,
                    fontWeight: AppFontWeights.medium,
                    color: ColorRes.textColor
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: serviceItem.isActive
                        ? ColorRes.green.shade50
                        : ColorRes.error.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        serviceItem.isActive
                            ? Icons.check_box
                            : Icons.close_rounded,
                        color: serviceItem.isActive
                            ? ColorRes.green
                            : ColorRes.error,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        serviceItem.isActive ? "Active" : "Inactive",
                        style: TextStyle(
                          color: serviceItem.isActive
                              ? ColorRes.green
                              : ColorRes.error,
                          fontSize: AppFontSizes.small,
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
             Divider(
              color: ColorRes.leadGreyColor.shade300,
            ),

            _rowTwoColumns("Price", "${capitalizeEachWord(meta.priceModel)}"),
            _rowTwoColumns("Minimum Price", "${Formatter.formatPrice(meta.minPriceRange)}"),
            _rowTwoColumns("Maximum Price", "${Formatter.formatPrice(meta.maxPriceRange)}"),
            _rowTwoColumns("Availability", capitalizeEachWord(meta.workAvailability),),
            _rowTwoColumns("Provides Materials", meta.provideMaterials ? "Yes" : "No"),
            _rowTwoColumns("Equipment", meta.equipmentProvided ? "Yes" : "No"),
            _rowTwoColumns("Insurance", meta.insuranceAvailable ? "Yes" : "No"),

            const SizedBox(height: 8),
             Divider(
              color: ColorRes.leadGreyColor.shade300,
            ),

            const Text(
              "Payment Modes",
              style: TextStyle(
                fontSize: AppFontSizes.small,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              meta.acceptedPaymentModes.map((e) => e.toUpperCase().split("_").join(" ")).join(", "),
              style:  TextStyle(
                color: ColorRes.textPrimary,
                fontSize: AppFontSizes.medium,
                fontWeight:AppFontWeights.medium


              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadDetailsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(color: ColorRes.leadGreyColor.shade300,width: 1)),
      elevation: 1,
      color: ColorRes.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Lead Details"),
            const SizedBox(height: 8),

            Row(
              children: [
                Container(padding: EdgeInsets.all(10),decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorRes.primary.withOpacity(0.2)
                ),child: Icon(Icons.person, size: 20, color: ColorRes.primary)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leadItem.name ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        color: ColorRes.textPrimary,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                    const Text("Lead Name",
                        style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            color: ColorRes.textSecondary)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),
            _infoRow(Icons.email_outlined, leadItem.email ?? "", "Email"),
            const SizedBox(height: 5),
            _infoRow(Icons.phone, leadItem.phone ?? "", "Phone"),
             Divider(height: 24,color: ColorRes.leadGreyColor.shade300,),

            _infoLabelValue(
              "Status",
              _formatLabel(leadItem.status),
            ),
            _infoLabelValue(
              "Stage",
              _formatLabel(leadItem.stage),
            ),
            _infoLabelValue(
              "Source",
              _formatLabel(leadItem.source),
            ),

            _infoLabelValue(
              "Created At",
              leadItem.createdAt != null
                  ? DateFormat('MMM dd, yyyy').format(leadItem.createdAt!)
                  : "-",
            ),

          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: AppFontWeights.semiBold,
        fontSize: AppFontSizes.medium,
        color: ColorRes.textColor
      ),
    );
  }

  Widget _rowTwoColumns(String label1, String value1) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label1, style:  TextStyle(color: ColorRes.textSecondary,fontSize: AppFontSizes.small)),
          Text(value1, style: TextStyle(fontWeight: AppFontWeights.medium,color: ColorRes.textColor,fontSize: AppFontSizes.bodySmall)),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String value, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(padding: EdgeInsets.all(10),decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorRes.primary.withOpacity(0.2)
          ),child: Icon(icon, size: 20, color: ColorRes.primary)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(fontSize: AppFontSizes.bodySmall,
                      color: ColorRes.textPrimary,
                      fontWeight: AppFontWeights.medium,)),
                Text(label,
                    style:  TextStyle(
                        fontSize: AppFontSizes.caption,
                        color: ColorRes.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoLabelValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: ColorRes.textSecondary,fontSize: AppFontSizes.small)),
          Text(value, style: const TextStyle(fontWeight: AppFontWeights.medium,color: ColorRes.textColor,fontSize: AppFontSizes.bodySmall)),
        ],
      ),
    );
  }

  Widget _button(String text, Color bg, Color fg) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () {},
        child: Text(
          text,
          style: const TextStyle(fontWeight: AppFontWeights.medium),
        ),
      ),
    );
  }

}

extension on String {
  String capitalize() =>
      isNotEmpty ? "${this[0].toUpperCase()}${substring(1)}" : this;
}
String _formatLabel(String? text) {
  if (text == null || text.isEmpty) return "";
  return text
      .replaceAll("_", " ")
      .split(" ")
      .map((word) => word.isEmpty
      ? ""
      : "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}")
      .join(" ");
}
