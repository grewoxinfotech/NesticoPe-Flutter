import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';
import 'package:housing_flutter_app/data/network/property_share/property_share_model.dart';
import 'package:housing_flutter_app/widgets/button/button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../data/network/interest_form/interest_form_model.dart';
import '../../controller/property_share/reseller_property_share_controller.dart';

class ReSellerPropertyShare extends StatefulWidget {
  final List<String> propertyId;
  final bool isMultiShare;

  const ReSellerPropertyShare({
    super.key,
    required this.propertyId,
    this.isMultiShare = false,
  });

  @override
  State<ReSellerPropertyShare> createState() => _ReSellerPropertyShareState();
}

class _ReSellerPropertyShareState extends State<ReSellerPropertyShare> {
  @override
  void initState() {
    Get.lazyPut(() => ReSellerPropertyShareController());
    final controller = Get.find<ReSellerPropertyShareController>();
    // controller.isLoading.value = false;
    controller.getMultiPropertyShare();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReSellerPropertyShareController>();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Share Link'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Click any platform button below to generate share link. You can customize form fields before sharing.',
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Custom Form Fields (Optional)',
                style: TextStyle(
                  fontSize: AppFontSizes.bodyMedium,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              // Custom Form Fields Section
              Container(
                padding: const EdgeInsets.all(AppPadding.medium),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  border: Border.all(color: ColorRes.grey.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add additional fields to collect specific information from buyers.',
                      style: TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Default Fields (Always Included):',
                      style: TextStyle(
                        fontSize: AppFontSizes.bodyMedium,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Default Fields
                    Container(
                      padding: EdgeInsets.all(AppPadding.medium),
                      decoration: BoxDecoration(
                        color: ColorRes.success.withOpacity(0.2),
                        border: Border.all(color: ColorRes.success),
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                      ),
                      child: Column(
                        children: [
                          _buildDefaultField('Name', 'Text', true),
                          const SizedBox(height: 10),
                          _buildDefaultField('Email', 'Email', true),
                          const SizedBox(height: 10),
                          _buildDefaultField('Phone', 'Phone', true),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Additional Custom Fields:',
                      style: TextStyle(
                        fontSize: AppFontSizes.bodyMedium,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Display custom fields
                    Obx(
                      () => Column(
                        children:
                            controller.customFields
                                .map(
                                  (field) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: _buildCustomFieldItem(
                                      field,
                                      controller,
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),

                    // Add Custom Field Button
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorRes.grey.withOpacity(0.3),
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton.icon(
                        onPressed:
                            () => controller.showAddCustomFieldDialog(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Custom Field'),
                        style: TextButton.styleFrom(
                          foregroundColor: ColorRes.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Helper text
                    Obx(
                      () => Text(
                        controller.customFields.isEmpty
                            ? 'No additional custom fields added. Click the button above to add more fields beyond the default ones.'
                            : 'Click the button above to add more custom fields.',
                        style: TextStyle(
                          fontSize: AppFontSizes.caption,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (widget.isMultiShare) ...[
                Obx(() {
                  if (controller.isLoading.value) {
                    return SizedBox.shrink();
                  }
                  if (!controller.isLoading.value &&
                      controller.multiShareItems.isEmpty) {
                    return SizedBox.shrink();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shared Property Bundles',
                        style: TextStyle(
                          fontSize: AppFontSizes.bodyMedium,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12),

                      _buildPropertyShareBundles(controller.multiShareItems),
                    ],
                  );
                }),
              ],
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: NesticoPeButton(
            title:
                controller.isLoading.value ? "Generate Link" : "Generate Link",
            onTap: () {
              print("2. Selected Property IDs: ${widget.propertyId}");
              if (widget.isMultiShare) {
                Get.lazyPut(() => ReSellerPropertyShareController());
                final propertyShareController =
                    Get.find<ReSellerPropertyShareController>();

                // Share multiple properties
                print("Selected Property IDs: ${widget.propertyId}");
                propertyShareController.createMultiPropertyShare(
                  widget.propertyId,
                );
              } else {
                print("Selected Property ID: ${widget.propertyId}");
                controller.createInterestForm(
                  propertyId: widget.propertyId.first,
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultField(String label, String type, bool required) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: ColorRes.primary,
          ),
        ),
        const SizedBox(width: 8),
        Text('• Type: $type', style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 8),
        Text(
          '• ${required ? "Required" : "Optional"}',
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildCustomFieldItem(
    CustomFormField field,
    ReSellerPropertyShareController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Type: ${field.type} • ${field.required ? "Required" : "Optional"}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => controller.removeField(field),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyShareBundles(List<MultiShareData> links) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      // padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: links.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildPropertyShareBundleCard(links[index]);
      },
    );
  }

  Widget _buildPropertyShareBundleCard(MultiShareData data) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with slug and share info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorRes.grey.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Icon(Icons.folder_shared, color: ColorRes.primary, size: 24),
                // const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bundle ${data.slug}",
                        style: TextStyle(
                          fontSize: AppFontSizes.bodyMedium,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${data.items.length} properties',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.copy, color: ColorRes.primary, size: 20),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: data.url));
                  },
                  tooltip: 'Copy link',
                ),
                IconButton(
                  icon: Icon(
                    Icons.open_in_new,
                    color: ColorRes.primary,
                    size: 20,
                  ),
                  onPressed: () async {
                    await launchUrl(
                      Uri.parse(data.url),
                      mode: LaunchMode.platformDefault,
                    );
                  },
                  tooltip: 'Share',
                ),
              ],
            ),
          ),

          // Properties list
          _buildPropertyItem(data.items.first),
          // ListView.separated(
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   padding: const EdgeInsets.all(16),
          //   itemCount: data.items.length,
          //   separatorBuilder: (context, index) => const Divider(height: 24),
          //   itemBuilder: (context, index) {
          //     return
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildPropertyItem(MultiShareItem item) {
    return InkWell(
      onTap: () {
        // Navigate to property details
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: Icon(Icons.home, size: 40, color: Colors.grey[500]),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),

            // Property details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property type and listing type badges
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildBadge(item.propertyType, Colors.purple),
                      _buildBadge(item.listingType, Colors.green),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      // Icon(
                      //   Icons.location_on,
                      //   size: 16,
                      //   color: Colors.grey[600],
                      // ),
                      // const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.state != null
                              ? '${item.city}, ${item.state}'
                              : item.city,
                          style: TextStyle(
                            fontSize: AppFontSizes.small,
                            color: ColorRes.textSecondary,
                            fontWeight: AppFontWeights.regular,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Price
                  Text(
                    _formatPrice(item.price, item.pricePerMonth),
                    style: TextStyle(
                      fontSize: AppFontSizes.bodyMedium,
                      fontWeight: AppFontWeights.bold,
                      // color: ColorRes.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label.capitalize.toString(),
        style: TextStyle(
          fontSize: AppFontSizes.caption,
          fontWeight: AppFontWeights.semiBold,
        ),
      ),
    );
  }

  String _formatPrice(num price, bool pricePerMonth) {
    String formattedPrice =
        price >= 1000000
            ? '${(price / 1000000).toStringAsFixed(2)}M'
            : price >= 1000
            ? '${(price / 1000).toStringAsFixed(0)}K'
            : price.toString();

    return '₹$formattedPrice${pricePerMonth ? '/month' : ''}';
  }
}
