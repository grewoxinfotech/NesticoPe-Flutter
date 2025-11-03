import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/manager/icon_manager.dart';
import 'package:housing_flutter_app/app/manager/property/property_name_manager.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/manager/property/property_pricemanager.dart';
import '../../../../data/network/property/models/property_model.dart';
import '../../../property/controllers/property_controller.dart';
import '../../../property/views/property_detail_screen.dart';
import '../../../property/views/widgets/property_media_gallery.dart';

// Import your existing files
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
// import 'package:housing_flutter_app/app/utils/formater/formater.dart';

class PropertyOverviewSellerScreen extends StatelessWidget {
  final Items property;

  const PropertyOverviewSellerScreen({Key? key, required this.property})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PropertyController>();
    final isCompact = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Property Overview',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: ColorRes.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Images Gallery
            // _buildPropertyImageGallery(context),
            PropertyMediaGallery(
              images: property.propertyMedia?.images,
              videos: property.propertyMedia?.videos,
              itemId: property.id,
              showReraTag: !controller.isDeveloper.value,
              showBackButton: false,
              showFavorite: false,
              showShare: false,
            ),

            Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),

            // Property Status & Performance
            _buildStatusSection(context, isCompact),

            Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),

            // Property Overview
            _buildPropertyOverviewSection(context, isCompact),

            Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),

            // Financial Information
            _buildFinancialSection(context, isCompact),

            Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),

            // Property Details
            _buildPropertyDetailsSection(context, isCompact),

            Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),

            // Amenities
            if (property.propertyDetails?.amenities?.isNotEmpty ?? false) ...[
              _buildAmenitiesSection(context, isCompact),
              Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
            ],

            // Performance Metrics
            _buildPerformanceSection(context, isCompact),

            Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),

            // Assignment Info (if assigned)
            if (property.assignedTo != null) ...[
              _buildAssignmentSection(context, isCompact),
              Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
            ],

            // Action Buttons
            _buildActionButtons(context, isCompact),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyImageGallery(BuildContext context) {
    final images =
        property.propertyMedia?.images ?? property.propertyImages ?? [];

    if (images.isEmpty) {
      return Container(
        height: 280,
        color: ColorRes.leadGreyColor[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 80, color: ColorRes.leadGreyColor[400]),
            SizedBox(height: 8),
            Text(
              property.title ?? 'No images available',
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: AppFontWeights.extraBold,
                color: ColorRes.leadGreyColor[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      height: 280,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Image.network(
                images[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: ColorRes.leadGreyColor[300],
                    child: Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: ColorRes.leadGreyColor[400],
                    ),
                  );
                },
              );
            },
          ),

          // Image counter
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: ColorRes.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '1/${images.length}',
                style: TextStyle(
                  color: ColorRes.white,
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.semiBold,
                ),
              ),
            ),
          ),

          // Status Badge
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _getStatusColor(property.propertyStatus ?? 'active'),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _formatStatus(property.propertyStatus ?? 'active'),
                style: TextStyle(
                  color: ColorRes.white,
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.extraBold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context, bool isCompact) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Property Status',
                style: TextStyle(
                  fontSize: AppFontSizes.body,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.leadGreyColor[800],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: ColorRes.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    ' ${property.propertyStatus?.toUpperCase() ?? 'N/A'} ',
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      color: ColorRes.primary,
                      fontWeight: AppFontWeights.extraBold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatusCard(
                  'Approval',
                  _formatStatus(property.approvalStatus ?? 'pending'),
                  _getStatusColor(property.approvalStatus ?? 'pending'),
                  Icons.verified_outlined,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatusCard(
                  'Verified',
                  property.isVerified ?? false ? 'Yes' : 'No',
                  property.isVerified ?? false
                      ? ColorRes.success
                      : ColorRes.orangeColor,
                  Icons.check_circle_outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  color: ColorRes.leadGreyColor[600],
                  fontWeight: AppFontWeights.medium,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.extraBold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyOverviewSection(BuildContext context, bool isCompact) {
    final propertyDetails = property.propertyDetails;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        //   child: Text(
        //     'Property Overview',
        //     style: TextStyle(
        //       fontSize: 16,
        //       fontWeight: AppFontWeights.semiBold,
        //       color: ColorRes.leadGreyColor[800],
        //     ),
        //   ),
        // ),
        // SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Builder(
            builder: (context) {
              final title = PropertyNameManager(property);
              final type = property.type?.toLowerCase() ?? '';
              final propertyType = property.propertyType?.capitalize ?? '';
              final bhk = property.propertyDetails?.bhk ?? 0;

              return Text(
                title.displayName,
                style: TextStyle(
                  fontWeight: AppFontWeights.semiBold,
                  fontSize: AppFontSizes.body,
                  color: ColorRes.blackShade87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
        ),

        SizedBox(height: 8),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: ColorRes.leadGreyColor[600],
              ),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${property.address ?? ''}, ${property.city ?? ''}, ${property.state ?? ''} - ${property.zipCode ?? ''}',
                  style: TextStyle(
                    fontSize: AppFontSizes.bodySmall,
                    color: ColorRes.leadGreyColor[600],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),

        Facilities(property: property ?? Items()),
        SizedBox(height: 20),

        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     if (propertyDetails?.propertyCarpetArea != null)
        //       _buildStatItem(
        //         '${propertyDetails!.propertyCarpetArea}',
        //         'Carpet Area\n(sq.ft)',
        //         Icons.straighten,
        //       ),
        //     if (propertyDetails?.bathroom != null) ...[
        //       Container(width: 1, height: 50, color: ColorRes.leadGreyColor[300]),
        //       _buildStatItem(
        //         '${propertyDetails!.bathroom}',
        //         'Bathrooms',
        //         Icons.bathtub_outlined,
        //       ),
        //     ],
        //     if (propertyDetails?.balcony != null) ...[
        //       Container(width: 1, height: 50, color: ColorRes.leadGreyColor[300]),
        //       _buildStatItem(
        //         '${propertyDetails!.balcony}',
        //         'Balconies',
        //         Icons.balcony_outlined,
        //       ),
        //     ],
        //   ],
        // ),
      ],
    );
  }

  Widget _buildOverviewChip(String text, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: AppFontSizes.small,
              color: color,
              fontWeight: AppFontWeights.semiBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 22, color: ColorRes.blueColor.shade700),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: AppFontSizes.body,
            fontWeight: AppFontWeights.extraBold,
            color: ColorRes.leadGreyColor[900],
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: AppFontSizes.caption,
            color: ColorRes.leadGreyColor[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFinancialSection(BuildContext context, bool isCompact) {
    final financialInfo = property.propertyDetails?.financialInfo;
    final listingType = property.listingType ?? "";

    // Use the price manager
    final priceManager = PropertyPriceManager(
      listingType: listingType,
      financialInfo: financialInfo,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Financial Information',
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.leadGreyColor[800],
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ColorRes.success.shade200, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// --- Property Price Section ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listingType.toLowerCase() == "rent"
                              ? 'Monthly Rent'
                              : 'Property Price',
                          style: TextStyle(
                            fontSize: AppFontSizes.bodySmall,
                            fontWeight: AppFontWeights.medium,
                            color: ColorRes.leadGreyColor[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          priceManager.displayPrice,
                          style: TextStyle(
                            fontSize: AppFontSizes.title,
                            fontWeight: AppFontWeights.extraBold,
                            color: ColorRes.success.shade800,
                          ),
                        ),
                      ],
                    ),

                    // Negotiable Badge
                    if (financialInfo?.negotiable ?? false)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: ColorRes.orangeColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: ColorRes.orangeColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Negotiable',
                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            color: ColorRes.orangeColor.shade700,
                            fontWeight: AppFontWeights.extraBold,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),
                // Divider(thickness: 1, color: ColorRes.leadGreyColor[300]),
                // const SizedBox(height: 8),

                /// --- Optional Details ---
                if (priceManager.pricePerSqft != null)
                  _buildInfoRow("Price per Sqft", priceManager.pricePerSqft!),

                if (priceManager.maintenance != null)
                  _buildInfoRow("Maintenance", priceManager.maintenance!),

                if (priceManager.securityDeposit != null)
                  _buildInfoRow(
                    "Security Deposit",
                    priceManager.securityDeposit!,
                  ),

                if (priceManager.brokerCommission != null)
                  _buildInfoRow(
                    "Broker Commission",
                    priceManager.brokerCommission!,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable Row Builder for financial items
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppFontSizes.bodySmall,
              color: ColorRes.leadGreyColor[700],
              fontWeight: AppFontWeights.medium,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.extraBold,
              color: ColorRes.blueColor.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyDetailsSection(BuildContext context, bool isCompact) {
    final propertyDetails = property.propertyDetails;

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Property Details',
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.leadGreyColor[800],
            ),
          ),
          SizedBox(height: 16),

          // if (property.builderName != null)
          //   _buildDetailRow('Builder', property.builderName!),
          // if (property.projectName != null)
          //   _buildDetailRow('Project', property.projectName!),
          // _buildDetailRow(
          //   'Property Type',
          //   property.propertyType?.toUpperCase() ?? 'N/A',
          // ),
          // if (propertyDetails?.zoneType != null)
          //   _buildDetailRow('Zone Type', propertyDetails!.zoneType!),
          // if (propertyDetails?.propertyFacing != null)
          //   _buildDetailRow('Facing', propertyDetails!.propertyFacing!),
          // if (propertyDetails?.floorInfo != null)
          //   _buildDetailRow(
          //     'Floor',
          //     '${propertyDetails!.floorInfo!.floorNumber ?? 'N/A'} of ${propertyDetails.floorInfo!.totalFloors ?? 'N/A'}',
          //   ),
          // if (propertyDetails?.furnishInfo?.furnishType != null)
          //   _buildDetailRow(
          //     'Furnishing',
          //     propertyDetails!.furnishInfo!.furnishType!.toUpperCase(),
          //   ),
          // if (propertyDetails?.parkingInfo != null)
          //   _buildDetailRow(
          //     'Parking',
          //     _formatParking(propertyDetails!.parkingInfo!),
          //   ),
          Details(property: property),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppFontSizes.bodySmall,
                color: ColorRes.leadGreyColor[600],
                fontWeight: AppFontWeights.medium,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppFontSizes.bodySmall,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.leadGreyColor[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesSection(BuildContext context, bool isCompact) {
    final amenities = property.propertyDetails?.amenities ?? [];

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amenities',
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.leadGreyColor[800],
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                amenities.map((amenity) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: ColorRes.blueColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorRes.blueColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          IconManager.getAmenitiesIcon(amenity),
                          size: 12,
                          color: ColorRes.primary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          amenity,
                          style: TextStyle(
                            fontSize: AppFontSizes.small,
                            color: ColorRes.blueColor.shade700,
                            fontWeight: AppFontWeights.semiBold,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceSection(BuildContext context, bool isCompact) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Metrics',
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.leadGreyColor[800],
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Views',
                  '${property.totalViews ?? 0}',
                  Icons.visibility_outlined,
                  ColorRes.blueColor,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Inquiries',
                  '${property.totalInquiries ?? 0}',
                  Icons.question_answer_outlined,
                  ColorRes.orangeColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Favorites',
                  '${property.totalFavorites ?? 0}',
                  Icons.favorite_border,
                  ColorRes.error,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Shares',
                  '${property.totalShares ?? 0}',
                  Icons.share_outlined,
                  ColorRes.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor.shade300),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    color: ColorRes.leadGreyColor[600],
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: AppFontSizes.large,
                    fontWeight: AppFontWeights.extraBold,
                    color: ColorRes.leadGreyColor[900],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentSection(BuildContext context, bool isCompact) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assignment Information',
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.leadGreyColor[800],
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ColorRes.purpleColor.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColorRes.purpleColor.shade200),
            ),
            child: Column(
              children: [
                _buildDetailRow('Assigned To', property.assignedTo ?? 'N/A'),
                _buildDetailRow(
                  'Status',
                  _formatStatus(property.assignmentStatus ?? 'N/A'),
                ),
                if (property.assignmentDate != null)
                  _buildDetailRow(
                    'Assigned On',
                    _formatDate(property.assignmentDate!),
                  ),
                if (property.potentialEarnings != null)
                  _buildDetailRow(
                    'Potential Earnings',
                    '₹${_formatPrice(double.tryParse(property.potentialEarnings!) ?? 0)}',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isCompact) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Edit property
                },
                icon: Icon(Icons.edit_outlined),
                label: Text(
                  'Edit Property',
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.extraBold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorRes.blueColor.shade700,
                  foregroundColor: ColorRes.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Share property
                      },
                      child: Icon(Icons.share_outlined),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorRes.success.shade700,
                        foregroundColor: ColorRes.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Share property
                      },
                      child: Icon(Icons.delete_outline),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorRes.error.shade700,
                        foregroundColor: ColorRes.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'active':
        return ColorRes.success;
      case 'pending':
        return ColorRes.orangeColor;
      case 'rejected':
      case 'inactive':
        return ColorRes.error;
      default:
        return ColorRes.leadGreyColor;
    }
  }

  String _formatStatus(String status) {
    return status
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _formatPrice(double price) {
    if (price >= 10000000) {
      return '${(price / 10000000).toStringAsFixed(2)} Cr';
    } else if (price >= 100000) {
      return '${(price / 100000).toStringAsFixed(2)} L';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(2)} K';
    }
    return price.toStringAsFixed(0);
  }

  String _formatParking(ParkingInfo parkingInfo) {
    List<String> parking = [];
    if (parkingInfo.open ?? false) parking.add('Open');
    if (parkingInfo.covered ?? false) parking.add('Covered');
    return parking.isEmpty ? 'None' : parking.join(' & ');
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}
