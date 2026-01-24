import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/care/pagination/view/pagination_list_view.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/data/network/contractor/model/contractor_quotation/contractor_quotation.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_quotation_controller.dart';
import 'package:housing_flutter_app/modules/contractor/view/widget/contractor_quotation_screen.dart';
import 'package:housing_flutter_app/modules/reseller/view/lead_overview/widget/lead_follow_up_screen.dart';

/// Screen for displaying list of contractor quotations
class ContractorQuotationListScreen extends StatelessWidget {
  const ContractorQuotationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContractorQuotationController());

    return Scaffold(
      backgroundColor: ColorRes.background,
      appBar: AppBar(
        backgroundColor: ColorRes.surface,
        elevation: 0,
        title: const Text(
          'My Quotations',
          style: TextStyle(
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorRes.textPrimary),
          onPressed: Get.back,
        ),
      ),
      body: Obx(() {
        // 1. Loading state
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // 2. Empty state (RefreshIndicator must still work)
        if (controller.items.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.refreshQuotation,
            color: ColorRes.primary,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 200),
                Center(child: Text('No quotations found')),
              ],
            ),
          );
        }

        // 3. Data state
        return RefreshIndicator(
          onRefresh: controller.refreshQuotation,
          color: ColorRes.primary,
          child: ListView.builder(
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              final quotation = controller.items[index];
              return _QuotationListItem(quotation: quotation);
            },
          ),
        );
      }),
    );
  }
}


class _QuotationListItem extends StatelessWidget {
  final ContractorQuotation quotation;

  const _QuotationListItem({required this.quotation});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorRes.leadGreyColor.shade300,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.to(() => ContractorQuotationScreen(quotation: quotation));
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row with ID and Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quotation ID',
                            style: TextStyle(
                              fontSize: AppFontSizes.extraSmall,
                              color: ColorRes.textSecondary,
                              fontWeight: AppFontWeights.medium,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '#${quotation.id.toUpperCase().substring(0, 8)}',
                            style: const TextStyle(
                              fontSize: AppFontSizes.small,
                              color: ColorRes.textPrimary,
                              fontWeight: AppFontWeights.semiBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(quotation.status),
                  ],
                ),

                const SizedBox(height: 16),

                // Customer Info
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 16,
                      color: ColorRes.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        quotation.user.name,
                        style: const TextStyle(
                          fontSize: AppFontSizes.small,
                          color: ColorRes.textPrimary,
                          fontWeight: AppFontWeights.medium,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Phone
                Row(
                  children: [
                    const Icon(
                      Icons.phone_outlined,
                      size: 16,
                      color: ColorRes.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      quotation.user.phone,
                      style: const TextStyle(
                        fontSize: AppFontSizes.small,
                        color: ColorRes.textPrimary,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Location
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: ColorRes.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${quotation.meta.propertyDetails?.city}, ${quotation.meta.propertyDetails?.state}',
                        style: const TextStyle(
                          fontSize: AppFontSizes.small,
                          color: ColorRes.textPrimary,
                          fontWeight: AppFontWeights.medium,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Divider
                Container(
                  height: 1,
                  color: ColorRes.border,
                ),

                const SizedBox(height: 16),

                // Bottom Row with Price and Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quotation Price',
                          style: TextStyle(
                            fontSize: AppFontSizes.extraSmall,
                            color: ColorRes.textSecondary,
                            fontWeight: AppFontWeights.medium,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${Formatter.formatPrice(num.tryParse(quotation.price)??0)}',
                          style: const TextStyle(
                            fontSize: AppFontSizes.medium,
                            color: ColorRes.primary,
                            fontWeight: AppFontWeights.bold,
                          ),
                        ),
                      ],
                    ),

                    // Date
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Created On',
                          style: TextStyle(
                            fontSize: AppFontSizes.extraSmall,
                            color: ColorRes.textSecondary,
                            fontWeight: AppFontWeights.medium,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(quotation.createdAt),
                          style: const TextStyle(
                            fontSize: AppFontSizes.small,
                            color: ColorRes.textPrimary,
                            fontWeight: AppFontWeights.medium,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Converted Badge
                if (quotation.isConverted) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: ColorRes.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorRes.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: ColorRes.primary,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Converted to Lead',
                          style: TextStyle(
                            fontSize: AppFontSizes.extraSmall,
                            color: ColorRes.primary,
                            fontWeight: AppFontWeights.semiBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color statusColor;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'accepted':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case 'completed':
        statusColor = Colors.blue;
        statusIcon = Icons.done_all;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
    }

    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            color: statusColor,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            capitalizeEachWord(status),
            style: TextStyle(
              fontSize: AppFontSizes.extraSmall,
              fontWeight: AppFontWeights.semiBold,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
