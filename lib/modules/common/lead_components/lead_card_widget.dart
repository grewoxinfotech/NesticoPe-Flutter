import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/manager/data_masker.dart';
import 'package:nesticope_app/app/manager/property/property_name_manager.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/data/network/property/models/property_model.dart';
import 'package:nesticope_app/modules/reseller/view/lead_overview/widget/lead_follow_up_screen.dart';
import 'package:nesticope_app/modules/seller/module/lead_screen/model/lead_model.dart';
import 'lead_helpers.dart';

/// Reusable Lead Card Widget
/// Used across Reseller, Seller, and Builder lead screens
class LeadCardWidget extends StatefulWidget {
  final LeadItem lead;
  final bool isCompact;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onView;
  final bool showDataMasking;
  final String? propertyPrice; // Add property price from matching property
  final RxList<Items>? leadPropertiesList; // List of properties to match

  /// When true (default), expanded section shows project-oriented fields.
  /// Set to false on property lead screens to show listing/property details.
  final bool isProjectLeadContext;

  const LeadCardWidget({
    Key? key,
    required this.lead,
    this.isCompact = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onView,
    this.showDataMasking = true,
    this.propertyPrice, // Accept property price
    this.leadPropertiesList, // Accept properties list
    this.isProjectLeadContext = true,
  }) : super(key: key);

  @override
  State<LeadCardWidget> createState() => _LeadCardWidgetState();
}

class _LeadCardWidgetState extends State<LeadCardWidget> {
  var isExpanded = false;

  String _getDisplayListingStatus() {
    final projectStatus = widget.lead.projectStatus?.trim();
    if (projectStatus != null && projectStatus.isNotEmpty) {
      return projectStatus;
    }

    final propertyStatus = widget.lead.propertyListingStatus?.trim();
    if (propertyStatus != null && propertyStatus.isNotEmpty) {
      return propertyStatus;
    }

    final leadStatus = widget.lead.status?.trim();
    if (leadStatus != null && leadStatus.isNotEmpty) {
      return leadStatus;
    }

    return 'Unknown';
  }

  // /// Method to match lead property ID with leadPropertiesList
  @override
  Widget build(BuildContext context) {
    final cardPadding = widget.isCompact ? 12.0 : 16.0;

    debugPrint("check project leads ${widget.lead.toJson()}");
    // Get financial info and listing type from matching property
    // final matchingFinancialInfo = _getMatchingPropertyFinancialInfo();
    // final matchingListingType = _getMatchingPropertyListingType();
    // Priority order: matching property > customFields
    // final listingType = matchingListingType ?? lead.customFields?.listingType ?? '';
    // final financialInfo = matchingFinancialInfo ?? lead.customFields?.propertyDetails?.financialInfo;
    //
    // // Use propertyPrice if available, otherwise calculate from financial info
    // final displayPrice = propertyPrice ??
    //     PropertyPriceManager(
    //       listingType: listingType,
    //       financialInfo: financialInfo,
    //     ).displayPrice;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(12),
          // border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: ColorRes.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: widget.isCompact ? 18 : 20,
                  backgroundColor: ColorRes.primary.withOpacity(0.2),
                  child: Text(
                    getInitials(widget.lead.name!),
                    style: TextStyle(
                      color: ColorRes.primary,
                      fontWeight: AppFontWeights.bold,
                      fontSize:
                          widget.isCompact
                              ? AppFontSizes.small
                              : AppFontSizes.medium,
                    ),
                  ),
                ),
                SizedBox(width: widget.isCompact ? 8 : 12),

                // Lead Details
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 180,
                        child: Text(
                          DataMasker.maskName(widget.lead.name!),
                          style: TextStyle(
                            fontSize:
                                widget.isCompact
                                    ? AppFontSizes.medium
                                    : AppFontSizes.body,
                            fontWeight: AppFontWeights.bold,
                            color: ColorRes.textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 2),
                      SizedBox(
                        width: 180,
                        child: Text(
                          DataMasker.maskPhone(widget.lead.phone!),
                          style: TextStyle(
                            fontSize:
                                widget.isCompact
                                    ? AppFontSizes.extraSmall
                                    : AppFontSizes.small,
                            color: ColorRes.leadGreyColor[700],
                            fontWeight: AppFontWeights.medium,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.lead.email != null &&
                          widget.lead.email!.isNotEmpty) ...[
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                DataMasker.maskEmail(widget.lead.email!),
                                style: TextStyle(
                                  fontSize: AppFontSizes.extraSmall,
                                  color: ColorRes.leadGreyColor[700],
                                  fontWeight: AppFontWeights.medium,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Budget Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (widget.lead.priceRange != null) ...[
                      Text(
                        'Budget',
                        style: TextStyle(
                          fontSize: AppFontSizes.extraSmall,
                          color: ColorRes.leadGreyColor[800],
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${Formatter.formatPriceRangeFromString(widget.lead.priceRange)}',
                        style: TextStyle(
                          fontSize:
                              widget.isCompact
                                  ? AppFontSizes.medium
                                  : AppFontSizes.body,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.success,
                        ),
                      ),
                      SizedBox(height: 4),
                    ] else ...[
                      Text(
                        'Budget',
                        style: TextStyle(
                          fontSize: AppFontSizes.extraSmall,
                          color: ColorRes.leadGreyColor[800],
                          fontWeight: AppFontWeights.regular,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${Formatter.formatPrice(num.tryParse(widget.lead.price.toString() ?? "0") ?? 0)}',

                        style: TextStyle(
                          fontSize:
                              widget.isCompact
                                  ? AppFontSizes.medium
                                  : AppFontSizes.body,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.success,
                        ),
                      ),
                      SizedBox(height: 4),
                    ],
                    Text(
                      formatTime(widget.lead.createdAt!),
                      style: TextStyle(
                        fontSize: AppFontSizes.caption,
                        color: ColorRes.leadGreyColor[700],
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: widget.isCompact ? 8 : 12),
            Divider(color: ColorRes.leadGreyColor.shade300, thickness: 0.5),
            SizedBox(height: widget.isCompact ? 8 : 12),

            // Status & Stage Badges + Action Buttons
            Row(
              children: [
                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.isCompact ? 10 : 14,
                    vertical: widget.isCompact ? 6 : 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        (widget.lead.isFake ?? false)
                            ? ColorRes.error.withOpacity(0.08)
                            : getStatusColor(
                              getLeadStatusFromString(widget.lead.status!),
                            ).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          (widget.lead.isFake ?? false)
                              ? ColorRes.error.shade300
                              : getStatusColor(
                                getLeadStatusFromString(widget.lead.status!),
                              ).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    (widget.lead.isFake ?? false)
                        ? "Fake"
                        : getStatusText(
                          getLeadStatusFromString(widget.lead.status!),
                        ),
                    style: TextStyle(
                      fontSize:
                          widget.isCompact
                              ? AppFontSizes.extraSmall
                              : AppFontSizes.small,
                      color:
                          (widget.lead.isFake ?? false)
                              ? ColorRes.error
                              : getStatusColor(
                                getLeadStatusFromString(widget.lead.status!),
                              ),
                      fontWeight: AppFontWeights.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),

                // Stage Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.isCompact ? 10 : 14,
                    vertical: widget.isCompact ? 6 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: getStageColor(
                      getLeadStageFromString(widget.lead.stage),
                    ).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: getStageColor(
                        getLeadStageFromString(widget.lead.stage),
                      ).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    getStageText(getLeadStageFromString(widget.lead.stage)),
                    style: TextStyle(
                      fontSize:
                          widget.isCompact
                              ? AppFontSizes.extraSmall
                              : AppFontSizes.small,
                      color: getStageColor(
                        getLeadStageFromString(widget.lead.stage),
                      ),
                      fontWeight: AppFontWeights.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                // Stage Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.isCompact ? 10 : 14,
                    vertical: widget.isCompact ? 6 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: getSourceColor(
                      getSourceFromString(widget.lead.source ?? ''),
                    ).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: getSourceColor(
                        getSourceFromString(widget.lead.source ?? ''),
                      ).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    getSourceText(
                      getSourceFromString(widget.lead.source ?? ''),
                    ),
                    style: TextStyle(
                      fontSize:
                          widget.isCompact
                              ? AppFontSizes.extraSmall
                              : AppFontSizes.small,
                      color: getSourceColor(
                        getSourceFromString(widget.lead.source ?? ''),
                      ),

                      fontWeight: AppFontWeights.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child:
                      isExpanded
                          ? Icon(Icons.keyboard_arrow_down_outlined)
                          : Icon(Icons.keyboard_arrow_up_outlined),
                ),
              ],
            ),

            if (widget.lead.status != null &&
                widget.lead.stage != null &&
                widget.lead.status!.toLowerCase() == 'converted' &&
                widget.lead.stage!.toLowerCase() == 'sell') ...[
              if (widget.lead.commissionStatus != null &&
                  widget.lead.commissionStatus!.isNotEmpty) ...[
                SizedBox(height: widget.isCompact ? 8 : 12),
                buildCommissionStatus(isPaid: true),
              ] else ...[
                SizedBox(height: widget.isCompact ? 8 : 12),
                buildCommissionStatus(isPaid: false),
              ],
            ],

            if (isExpanded) ...[
              const SizedBox(height: 10),

              Divider(color: ColorRes.leadGreyColor.shade300),
              const SizedBox(height: 10),
              // Project Name
              if (widget.isProjectLeadContext) ...[
                Text(
                  widget.lead.projectName ?? "-",
                  style: TextStyle(
                    fontSize: AppFontSizes.bodySmall,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                ),
              ] else ...[
                Text(
                  '${(widget.lead.bhk.toString() != 'null' && widget.lead.bhk.toString() != "0") ? 'BHK ${widget.lead.bhk}' : ""} ${widget.lead.propertyType?.capitalize} ${widget.lead.listingType?.capitalize ?? ""}',
                  style: TextStyle(
                    fontSize: AppFontSizes.bodySmall,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                ),
              ],

              const SizedBox(height: 6),

              // City + Property Type
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: ColorRes.leadGreyColor.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.lead.city ?? "-",
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.home_work_outlined,
                    size: 14,
                    color: ColorRes.leadGreyColor.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.lead.propertyType ?? "-",
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Status Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoChip(
                    label: capitalizeEachWord(_getDisplayListingStatus()),
                    color: ColorRes.orangeColor,
                  ),
                  if (widget.lead.priceRange != null &&
                      widget.lead.priceRange!.isNotEmpty) ...[
                    _infoChip(
                      label:
                          Formatter.formatPriceRangeFromString(
                            widget.lead.priceRange,
                          ) ??
                          "-",
                      color: ColorRes.success,
                    ),
                  ] else ...[
                    _infoChip(
                      label:
                          Formatter.formatPrice(
                            num.tryParse(widget.lead.price.toString() ?? "0") ??
                                0,
                          ) ??
                          "-",
                      color: ColorRes.success,
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 10),

              // Reseller Info
              /*  if (widget.lead.reseller != null)
                Row(
                  children: [
                    Icon(Icons.person_outline,
                        size: 16, color: ColorRes.leadGreyColor),
                    const SizedBox(width: 6),
                    Text(
                      "Reseller: ${widget.lead.reseller?.username}",
                      style: TextStyle(
                        fontSize: AppFontSizes.caption,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                  ],
                ),*/
            ],
          ],
        ),
      ),
    );
  }
}

Widget _infoChip({required String label, required Color color}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
    ),
  );
}

Widget buildCommissionStatus({required bool isPaid, VoidCallback? onTap}) {
  final Color green = ColorRes.success;
  final Color lightGreen = ColorRes.white;

  return InkWell(
    onTap: isPaid ? null : onTap,
    borderRadius: BorderRadius.circular(8),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: green),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon(Icons.currency_rupee, size: 14, color: ColorRes.success),
          // const SizedBox(width: 6),
          Text(
            isPaid ? 'Commission Paid' : 'Pay Partner Commission Now',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: ColorRes.success,
            ),
          ),
        ],
      ),
    ),
  );
}
