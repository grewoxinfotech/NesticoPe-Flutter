import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/svg_res.dart';
import 'package:housing_flutter_app/app/manager/icon_manager.dart';
import 'package:housing_flutter_app/app/manager/property/property_name_manager.dart';
import 'package:housing_flutter_app/app/manager/property/property_pricemanager.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';

import '../../../../app/utils/svg_widget.dart';
import '../../../../data/network/property/models/property_model.dart';
import '../../controller/dashborad_controller/dashboard_controller.dart';
import '../../model/reseller_lead_model/reseller_lead_overview.dart';
import '../report/report_screen.dart';

class LeadDetailScreen extends StatelessWidget {
  final ResellerLeadOverview? lead;
  final Items? property;
  final bool isFromLead;

  LeadDetailScreen({
    Key? key,
    this.lead,
    this.property,
    this.isFromLead = false,
  }) : assert(
         (lead != null) != (property != null),
         'You must provide either lead OR property, not both.',
       ),
       super(key: key);

  // Initialize controller
  final DashboardController controller = Get.put(DashboardController());

  // Helper getters to access data from either lead or property
  Items get propertyData => isFromLead ? lead!.customFields : property!;

  String get propertyTitle =>
      isFromLead ? lead!.customFields.title ?? '' : property!.title ?? '';

  String get propertyAddress =>
      isFromLead ? lead!.customFields.address ?? '' : property!.address ?? '';

  String get propertyCity =>
      isFromLead ? lead!.customFields.city ?? '' : property!.city ?? '';

  String get propertyState =>
      isFromLead ? lead!.customFields.state ?? '' : property!.state ?? '';

  String get propertyZipCode =>
      isFromLead ? lead!.customFields.zipCode ?? '' : property!.zipCode ?? '';

  String get propertyType =>
      isFromLead
          ? lead!.customFields.propertyType ?? ''
          : property!.propertyType ?? '';

  String get listingType =>
      isFromLead
          ? lead!.customFields.listingType ?? ''
          : property!.listingType ?? '';

  String get builderName =>
      isFromLead
          ? lead!.customFields.builderName ?? ''
          : property!.builderName ?? '';

  String get projectName =>
      isFromLead
          ? lead!.customFields.projectName ?? ''
          : property!.projectName ?? '';

  PropertyDetails? get propertyDetails =>
      isFromLead
          ? lead!.customFields.propertyDetails
          : property!.propertyDetails;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Get.back();
          },
        ),
        title: Text(
          '${(isFromLead) ? 'Lead Details' : 'Property Overview'}',
          style: TextStyle(
            fontWeight: AppFontWeights.bold,
            fontSize: AppFontSizes.large,
          ),
        ),
        backgroundColor: ColorRes.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMoreOptions(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Contact Information (Only for Leads)
            if (isFromLead) ...[
              _buildContactSection(context, isCompact),
              Divider(thickness: 8, color: Colors.grey[100]),
            ],

            // 2. Property Image Gallery (Always Visible)
            _buildPropertyImageGallery(context),

            Divider(thickness: 8, color: Colors.grey[100]),

            // 3. Property Overview (Always Visible)
            _buildPropertyOverviewSection(context, isCompact),

            // Expand/Collapse Button

            // Conditional Sections (Show when expanded)
            Obx(
              () =>
                  controller.isResellerDetailExpanded.value
                      ? Column(
                        children: [
                          Divider(thickness: 8, color: Colors.grey[100]),

                          // 4. Property Details
                          _buildPropertyDetailsSection(context, isCompact),

                          Divider(thickness: 8, color: Colors.grey[100]),

                          // 5. Amenities
                          _buildAmenitiesSection(context, isCompact),

                          Obx(() => _buildExpandButton(context)),
                        ],
                      )
                      : Obx(() => _buildExpandButton(context)),
            ),
            Divider(thickness: 8, color: Colors.grey[100]),

            // 6. Financial Information
            _buildFinancialSection(context, isCompact),

            if (isFromLead) ...[
              Divider(thickness: 8, color: Colors.grey[100]),

              // 7. Lead Status & Timeline
              _buildStatusTimelineSection(context, isCompact),
            ],

            Divider(thickness: 8, color: Colors.grey[100]),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child:
                  lead != null
                      ? PropertyOverviewCard(lead: lead)
                      : PropertyOverviewCard(property: property),
            ),

            if (property != null) ...[
              Divider(thickness: 8, color: Colors.grey[100]),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: _buildSectionHeader(
                  'Report',
                  Icons.report_gmailerrorred_outlined,
                  isCompact,
                ),
              ),
              ReportPropertyCard(propertyId: property!.id!),
            ],

            // 8. Notes Section (Only for Leads)
            if (isFromLead && lead?.notes != null) ...[
              Divider(thickness: 8, color: Colors.grey[100]),
              _buildNotesSection(context, isCompact),
            ],

            Divider(thickness: 8, color: Colors.grey[100]),

            // 9. Action Buttons
            _buildActionButtons(context, isCompact),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandButton(BuildContext context) {
    return InkWell(
      onTap: () => controller.toggleExpanded(),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              controller.isResellerDetailExpanded.value
                  ? 'Hide Additional Details'
                  : 'Show Additional Details',
              style: TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(BuildContext context, bool isCompact) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                radius: isCompact ? 24 : 28,
                backgroundColor: ColorRes.primary.withOpacity(0.2),
                child: Text(
                  lead!.name.split(' ').map((e) => e[0]).join().toUpperCase(),
                  style: TextStyle(
                    color: ColorRes.primary,
                    fontWeight: AppFontWeights.semiBold,
                    fontSize:
                        isCompact ? AppFontSizes.medium : AppFontSizes.large,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lead!.name,
                      style: TextStyle(
                        fontSize:
                            isCompact ? AppFontSizes.body : AppFontSizes.large,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Lead Source: ${lead!.source.toUpperCase()}',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: AppFontSizes.extraSmall,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Property Type: ${propertyType.toUpperCase()}',
                              style: TextStyle(
                                fontSize: AppFontSizes.extraSmall,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildContactRow(
            Icons.email_outlined,
            'Email',
            lead!.email,
            Colors.blue,
            () => _launchEmail(lead!.email),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildContactRow(
                  Icons.phone_outlined,
                  'Phone',
                  lead!.phone,
                  Colors.green,
                  () => _launchPhone(lead!.phone),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildContactRow(
    IconData icon,
    String label,
    String value,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: AppFontSizes.extraSmall,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      fontWeight: FontWeight.w500,
                      color: ColorRes.textColor,
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

  Widget _buildPropertyImageGallery(BuildContext context) {
    final dummyImages = [
      'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800',
      'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800',
      'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=800',
    ];

    return Container(
      height: 280,
      color: ColorRes.white,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: dummyImages.length,
            onPageChanged: (value) {},
            itemBuilder: (context, index) {
              return Image.network(
                dummyImages[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home, size: 80, color: Colors.grey[400]),
                        SizedBox(height: 8),
                        Text(
                          propertyTitle,
                          style: TextStyle(
                            fontSize: AppFontSizes.large,
                            fontWeight: AppFontWeights.bold,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '1/${dummyImages.length}',
                style: TextStyle(
                  color: ColorRes.white,
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.semiBold,
                ),
              ),
            ),
          ),
          if (isFromLead)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _getStatusColor(lead!.status),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getStatusColor(lead!.status).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  _getStatusText(lead!.status),
                  style: TextStyle(
                    color: ColorRes.white,
                    fontSize: AppFontSizes.extraSmall,
                    fontWeight: AppFontWeights.semiBold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPropertyOverviewSection(BuildContext context, bool isCompact) {
    final details = propertyDetails;
    if (details == null) return SizedBox.shrink();
    final nameManager = PropertyNameManager(propertyData);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Property Overview',
            Icons.home_outlined,
            isCompact,
          ),
          const SizedBox(height: 16),
          Text(
            nameManager.displayName,
            style: TextStyle(
              fontSize: isCompact ? AppFontSizes.medium : AppFontSizes.large,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textColor,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 300,
            child: Text(
              '$propertyAddress, $propertyCity, $propertyState - $propertyZipCode',
              style: TextStyle(
                fontSize:
                    isCompact ? AppFontSizes.extraSmall : AppFontSizes.small,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildOverviewChip(
                '${details.bhk ?? 0} BHK',
                Icons.bed_outlined,
                ColorRes.primary,
                isCompact,
              ),
              _buildOverviewChip(
                propertyType.toUpperCase(),
                Icons.apartment_outlined,
                Colors.purple,
                isCompact,
              ),
              _buildOverviewChip(
                listingType,
                Icons.sell_outlined,
                Colors.orange,
                isCompact,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                '${details.propertyCarpetArea ?? 0}',
                'Carpet Area\n(sq.ft)',
                Icons.straighten,
                isCompact,
              ),
              Container(width: 1, height: 50, color: Colors.grey[300]),
              _buildStatItem(
                '${details.bathroom ?? 0}',
                'Bathrooms',
                Icons.bathtub_outlined,
                isCompact,
              ),
              Container(width: 1, height: 50, color: Colors.grey[300]),
              _buildStatItem(
                '${details.balcony ?? 0}',
                'Balconies',
                Icons.balcony_outlined,
                isCompact,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isCompact) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isCompact ? AppFontSizes.body : AppFontSizes.large,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewChip(
    String text,
    IconData icon,
    Color color,
    bool isCompact,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize:
                  isCompact ? AppFontSizes.extraSmall : AppFontSizes.small,
              color: color,
              fontWeight: AppFontWeights.semiBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    IconData icon,
    bool isCompact,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: isCompact ? 18 : 22,
          color: ColorRes.primary.withOpacity(0.8),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isCompact ? AppFontSizes.small : AppFontSizes.medium,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: isCompact ? AppFontSizes.extraSmall : AppFontSizes.small,
            color: Colors.grey[700],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPropertyDetailsSection(BuildContext context, bool isCompact) {
    final details = propertyDetails;
    if (details == null) return SizedBox.shrink();

    final furnishInfo = details.furnishInfo;
    final floorInfo = details.floorInfo;
    final possessionInfo = details.possessionInfo;

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Property Details', Icons.info_outline, true),
          SizedBox(height: 16),
          _buildDetailRow('Builder', builderName),
          _buildDetailRow('Project', projectName),
          _buildDetailRow('Property Type', propertyType.toUpperCase()),
          if (details.zoneType != null)
            _buildDetailRow('Zone Type', details.zoneType!),
          if (details.propertyFacing != null)
            _buildDetailRow('Facing', details.propertyFacing!),
          if (floorInfo != null)
            _buildDetailRow(
              'Floor',
              '${floorInfo.floorNumber ?? 0} of ${floorInfo.totalFloors ?? 0}',
            ),
          if (details.propertyBuiltUpArea != null)
            _buildDetailRow(
              'Built-up Area',
              '${details.propertyBuiltUpArea} sq.ft',
            ),
          if (details.propertyCarpetArea != null)
            _buildDetailRow(
              'Carpet Area',
              '${details.propertyCarpetArea} sq.ft',
            ),
          if (furnishInfo?.furnishType != null)
            _buildDetailRow(
              'Furnishing',
              furnishInfo!.furnishType!.toUpperCase(),
            ),
          if (furnishInfo?.furnishDetails?.acInstalled != null)
            _buildDetailRow(
              'AC Installed',
              furnishInfo!.furnishDetails!.acInstalled! ? 'Yes' : 'No',
            ),
          if (details.parkingInfo != null)
            _buildDetailRow(
              'Parking',
              '${details.parkingInfo!.open == true ? "Open" : ""}${details.parkingInfo!.open == true && details.parkingInfo!.covered == true ? " & " : ""}${details.parkingInfo!.covered == true ? "Covered" : ""}',
            ),
          if (possessionInfo?.possessionStatus != null)
            _buildDetailRow('Possession', possessionInfo!.possessionStatus!),
          if (possessionInfo?.propertyAgeInYear != null)
            _buildDetailRow(
              'Property Age',
              '${possessionInfo!.propertyAgeInYear} years',
            ),
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
                fontSize: AppFontSizes.caption,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesSection(BuildContext context, bool isCompact) {
    final amenities = propertyDetails?.amenities ?? [];
    if (amenities.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Amenities', Icons.star_outline, true),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                amenities.map((amenity) {
                  final matchedItem = IconManager.allAmenities.firstWhere(
                    (item) => item.title.toLowerCase() == amenity.toLowerCase(),
                    orElse:
                        () => IconItem(
                          key: '',
                          title: amenity,
                          icon: Icons.help_outline,
                        ),
                  );

                  final hasIcon = matchedItem.key.isNotEmpty;

                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: ColorRes.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorRes.primary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hasIcon) ...[
                          AppSvgIcon(
                            assetName: matchedItem.key,
                            size: 16,
                            color: ColorRes.primary,
                            folder: 'amenities',
                          ),
                          SizedBox(width: 6),
                        ],
                        Text(
                          amenity,
                          style: TextStyle(
                            fontSize: AppFontSizes.extraSmall,
                            color: ColorRes.primary,
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

  Widget _buildFinancialSection(BuildContext context, bool isCompact) {
    final financialInfo = _resolvedFinancialInfo;
    if (financialInfo == null) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Financial Information',
            Icons.currency_rupee_outlined,
            isCompact,
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.shade200, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Property Price Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Property Price',
                                style: TextStyle(
                                  fontSize: AppFontSizes.medium,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            Formatter.formatPrice(financialInfo.price),
                            style: TextStyle(
                              fontSize: isCompact ? AppFontSizes.large : 32,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade800,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (financialInfo.negotiable)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: (isFromLead
                                  ? _getStatusColor(lead!.status)
                                  : Colors.green)
                              .withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: (isFromLead
                                    ? _getStatusColor(lead!.status)
                                    : Colors.green)
                                .withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Negotiable',
                              style: TextStyle(
                                fontSize: AppFontSizes.extraSmall,
                                color:
                                    isFromLead
                                        ? _getStatusColor(lead!.status)
                                        : Colors.green,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 16),
                Divider(thickness: 0.65, color: ColorRes.grey.withOpacity(0.4)),
                SizedBox(height: 16),

                // Broker Commission Section
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColorRes.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: ColorRes.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 20,
                              color: ColorRes.primary,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Broker Commission',
                            style: TextStyle(
                              fontSize: AppFontSizes.small,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        Formatter.formatPrice(financialInfo.brokerCommission),
                        style: TextStyle(
                          fontSize:
                              isCompact
                                  ? AppFontSizes.medium
                                  : AppFontSizes.large,
                          fontWeight: FontWeight.w600,
                          color: ColorRes.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Reactive Section with Obx
                Obx(() {
                  final hasOffer = controller.submittedOfferAmount.value != 0.0;

                  return Column(
                    children: [
                      // Submitted Offer Section
                      if (hasOffer) ...[
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade50,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.handshake_rounded,
                                          size: 20,
                                          color: Colors.orange.shade700,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      SizedBox(
                                        width: 150,
                                        child: Text(
                                          'Negotiable Price',
                                          style: TextStyle(
                                            fontSize: AppFontSizes.small,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    Formatter.formatPrice(
                                      controller.submittedOfferAmount.value,
                                    ),
                                    style: TextStyle(
                                      fontSize:
                                          isCompact
                                              ? AppFontSizes.medium
                                              : AppFontSizes.large,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.orange.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.pending_outlined,
                                      size: 14,
                                      color: Colors.orange.shade700,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Pending Review',
                                      style: TextStyle(
                                        fontSize: AppFontSizes.extraSmall,
                                        color: Colors.orange.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Negotiation Button
                      if (financialInfo.negotiable) ...[
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed:
                                !hasOffer
                                    ? () => _handleNegotiation(context)
                                    : null,
                            icon: Icon(
                              !hasOffer
                                  ? Icons.chat_bubble_outline
                                  : Icons.check_circle_outline,
                              size: 18,
                            ),
                            label: Text(
                              !hasOffer
                                  ? 'Start Negotiation'
                                  : 'Offer Submitted',
                              style: TextStyle(
                                fontSize: AppFontSizes.medium,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  !hasOffer
                                      ? Colors.green.shade600
                                      : Colors.grey.shade400,
                              foregroundColor: ColorRes.white,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                              shadowColor: Colors.green.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimelineSection(BuildContext context, bool isCompact) {
    if (!isFromLead) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Lead Timeline', Icons.timeline_outlined, true),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: Column(
              children: [
                _buildTimelineItem(
                  'Lead Created',
                  _formatDateTime(lead!.createdAt),
                  Icons.add_circle_outline,
                  Colors.blue,
                  true,
                  false,
                ),
                if (lead!.lastContactedAt != null)
                  _buildTimelineItem(
                    'Last Contacted',
                    _formatDateTime(lead!.lastContactedAt!),
                    Icons.phone_outlined,
                    Colors.orange,
                    false,
                    false,
                  ),
                _buildTimelineItem(
                  'Current Status',
                  _getStatusText(lead!.status),
                  Icons.flag_outlined,
                  _getStatusColor(lead!.status),
                  false,
                  true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool isFirst,
    bool isLast,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorRes.white,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2.5),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [color.withOpacity(0.6), color.withOpacity(0.4)],
                  ),
                ),
                margin: EdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppFontSizes.bodySmall,
                      fontWeight: FontWeight.w600,
                      color: ColorRes.textColor,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleNegotiation(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) {
        final priceManager = PropertyPriceManager(
          listingType: _listingTypeValue,
          financialInfo: _resolvedFinancialInfo,
        );
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: ColorRes.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Handle
                Container(
                  margin: EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(24, 8, 24, 24),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Section
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.green.shade50,
                                  Colors.green.shade100.withOpacity(0.5),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: ColorRes.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: ColorRes.green,
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.handshake_rounded,
                                    color: Colors.green.shade700,
                                    size: 25,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Negotiate Price',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[900],
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Make your best offer',
                                        style: TextStyle(
                                          fontSize: AppFontSizes.caption,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 24),

                          // Current Price Info
                          Container(
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue.shade100),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.blue.shade700,
                                  size: 20,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Current Asking Price',
                                        style: TextStyle(
                                          fontSize: AppFontSizes.extraSmall,
                                          color: Colors.blue.shade700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        priceManager.displayPrice,
                                        style: TextStyle(
                                          fontSize: AppFontSizes.medium,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 24),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Offer Amount *',
                                style: TextStyle(
                                  fontSize: AppFontSizes.small,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: controller.offerController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your offer amount';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter a valid amount';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter amount',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[400],
                                  ),
                                  prefixIcon: Icon(
                                    Icons.currency_rupee,
                                    color: Colors.green.shade700,
                                    size: 22,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: ColorRes.primary,
                                      width: 1,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: Colors.red.shade300,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: ColorRes.white,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20),

                          // Message Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Message (Optional)',
                                style: TextStyle(
                                  fontSize: AppFontSizes.small,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: controller.messageController,
                                minLines: 1,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  hintText: 'Add a message...',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[400],
                                  ),
                                  prefixIcon: Icon(
                                    Icons.message_outlined,
                                    color: Colors.orange.shade700,
                                    size: 22,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: ColorRes.primary,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: ColorRes.white,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 28),

                          // Action Buttons
                          SafeArea(
                            child: Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      controller.offerController.clear();
                                      controller.messageController.clear();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: AppFontSizes.medium,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.grey[700],
                                      side: BorderSide(
                                        color: Colors.grey.shade400,
                                        width: 1.5,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),

                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        // Store the offer amount
                                        final offerAmount = double.parse(
                                          controller.offerController.text,
                                        );
                                        final message =
                                            controller.messageController.text;

                                        // Update the state to display the offer

                                        controller.submittedOfferAmount.value =
                                            offerAmount;

                                        controller.offerController.clear();
                                        controller.messageController.clear();
                                        Navigator.pop(context);

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: [
                                                Icon(
                                                  Icons.check_circle,
                                                  color: ColorRes.white,
                                                ),
                                                SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    'Offer submitted successfully!',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            backgroundColor: ColorRes.primary,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            duration: Duration(seconds: 3),
                                          ),
                                        );
                                      }
                                    },
                                    label: Text(
                                      'Submit Offer',
                                      style: TextStyle(
                                        fontSize: AppFontSizes.medium,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorRes.primary,
                                      foregroundColor: ColorRes.white,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      shadowColor: Colors.green.withOpacity(
                                        0.3,
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
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotesSection(BuildContext context, bool isCompact) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Notes', Icons.note_outlined, true),
          SizedBox(height: 16),
          Text(
            lead!.notes!,
            style: TextStyle(
              fontSize: AppFontSizes.small,
              color: Colors.grey[800],
              height: 1.5,
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
                onPressed:
                    () =>
                        _launchPhone(lead?.phone ?? property?.ownerPhone ?? ''),
                icon: Icon(Icons.phone),
                label: Text(
                  'Call',
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
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
              child: ElevatedButton.icon(
                onPressed:
                    () =>
                        _launchEmail(lead?.email ?? property?.ownerEmail ?? ''),
                icon: Icon(Icons.email),
                label: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorRes.primary,
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
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorRes.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Icon(Icons.share, color: Colors.blue),
                title: Text('Share Lead'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement share functionality
                },
              ),
              ListTile(
                leading: Icon(Icons.flag, color: Colors.orange),
                title: Text('Mark as Fake'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement mark as fake
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete Lead'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement delete functionality
                },
              ),
              SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return Colors.blue;
      case 'contacted':
        return Colors.orange;
      case 'qualified':
        return Colors.purple;
      case 'negotiating':
        return Colors.indigo;
      case 'sold':
        return Colors.green;
      case 'lost':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    return status
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _launchPhone(String phone) {
    // Implement phone call functionality
    // url_launcher package: launch('tel:$phone');
  }

  void _launchEmail(String email) {
    // Implement email functionality
    // url_launcher package: launch('mailto:$email');
  }

  String get _listingTypeValue {
    if (property != null) return property!.listingType ?? '';
    if (lead != null) return lead!.customFields.listingType ?? '';
    return '';
  }

  FinancialInfo? get _resolvedFinancialInfo {
    if (property?.propertyDetails?.financialInfo != null)
      return property!.propertyDetails!.financialInfo;
    if (lead?.customFields.propertyDetails?.financialInfo != null)
      return lead!.customFields.propertyDetails!.financialInfo;
    return null;
  }
}
