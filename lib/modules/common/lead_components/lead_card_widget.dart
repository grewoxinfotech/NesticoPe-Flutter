import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/manager/data_masker.dart';
import 'package:housing_flutter_app/app/manager/property/property_pricemanager.dart';
import 'package:housing_flutter_app/modules/seller/module/lead_screen/model/lead_model.dart';
import 'lead_helpers.dart';

/// Reusable Lead Card Widget
/// Used across Reseller, Seller, and Builder lead screens
class LeadCardWidget extends StatelessWidget {
  final LeadItem lead;
  final bool isCompact;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onView;
  final bool showDataMasking;

  const LeadCardWidget({
    Key? key,
    required this.lead,
    this.isCompact = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onView,
    this.showDataMasking = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardPadding = isCompact ? 12.0 : 16.0;
    final priceManager = PropertyPriceManager(
      listingType: lead.customFields?.listingType ?? '',
      financialInfo: lead.customFields?.propertyDetails?.financialInfo,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: isCompact ? 18 : 20,
                  backgroundColor: ColorRes.primary.withOpacity(0.2),
                  child: Text(
                    getInitials(lead.name!),
                    style: TextStyle(
                      color: ColorRes.primary,
                      fontWeight: AppFontWeights.bold,
                      fontSize:
                          isCompact ? AppFontSizes.small : AppFontSizes.medium,
                    ),
                  ),
                ),
                SizedBox(width: isCompact ? 8 : 12),

                // Lead Details
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 180,
                        child: Text(
                          showDataMasking
                              ? DataMasker.maskName(lead.name!)
                              : lead.name!,
                          style: TextStyle(
                            fontSize:
                                isCompact
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
                          showDataMasking
                              ? DataMasker.maskPhone(lead.phone!)
                              : lead.phone!,
                          style: TextStyle(
                            fontSize:
                                isCompact
                                    ? AppFontSizes.extraSmall
                                    : AppFontSizes.small,
                            color: ColorRes.leadGreyColor[700],
                            fontWeight: AppFontWeights.regular,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (lead.email != null && lead.email!.isNotEmpty) ...[
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                showDataMasking
                                    ? DataMasker.maskEmail(lead.email!)
                                    : lead.email!,
                                style: TextStyle(
                                  fontSize: AppFontSizes.extraSmall,
                                  color: ColorRes.leadGreyColor[600],
                                  fontWeight: AppFontWeights.regular,
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
                      '${priceManager.displayPrice}',
                      style: TextStyle(
                        fontSize:
                            isCompact ? AppFontSizes.medium : AppFontSizes.body,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.success,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      formatTime(lead.createdAt!),
                      style: TextStyle(
                        fontSize: AppFontSizes.caption,
                        color: ColorRes.leadGreyColor[600],
                        fontWeight: AppFontWeights.regular,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: isCompact ? 8 : 12),
            Divider(color: ColorRes.leadGreyColor, thickness: 0.5),
            SizedBox(height: isCompact ? 8 : 12),

            // Status & Stage Badges + Action Buttons
            Row(
              children: [
                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 10 : 14,
                    vertical: isCompact ? 6 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor(
                      getLeadStatusFromString(lead.status!),
                    ).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: getStatusColor(
                        getLeadStatusFromString(lead.status!),
                      ).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    getStatusText(getLeadStatusFromString(lead.status!)),
                    style: TextStyle(
                      fontSize:
                          isCompact
                              ? AppFontSizes.extraSmall
                              : AppFontSizes.small,
                      color: getStatusColor(
                        getLeadStatusFromString(lead.status!),
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
                    horizontal: isCompact ? 10 : 14,
                    vertical: isCompact ? 6 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: getStageColor(
                      getLeadStageFromString(lead.stage),
                    ).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: getStageColor(
                        getLeadStageFromString(lead.stage),
                      ).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    getStageText(getLeadStageFromString(lead.stage)),
                    style: TextStyle(
                      fontSize:
                          isCompact
                              ? AppFontSizes.extraSmall
                              : AppFontSizes.small,
                      color: getStageColor(getLeadStageFromString(lead.stage)),
                      fontWeight: AppFontWeights.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Spacer(),

                // Action Buttons
                Row(
                  children: [
                    if (onView != null) ...[
                      buildActionButton(
                        icon: Icons.visibility,
                        color: ColorRes.blueColor,
                        onPressed: onView!,
                        tooltip: 'View Lead',
                        isCompact: isCompact,
                      ),
                      SizedBox(width: 8),
                    ],
                    if (onEdit != null) ...[
                      buildActionButton(
                        icon: Icons.edit,
                        color: ColorRes.orangeColor,
                        onPressed: onEdit!,
                        tooltip: 'Edit Lead',
                        isCompact: isCompact,
                      ),
                      SizedBox(width: 8),
                    ],
                    if (onDelete != null)
                      buildActionButton(
                        icon: Icons.delete,
                        color: ColorRes.error,
                        onPressed: onDelete!,
                        tooltip: 'Delete Lead',
                        isCompact: isCompact,
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
