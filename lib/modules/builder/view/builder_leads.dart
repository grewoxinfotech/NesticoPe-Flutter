import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';

import '../../../data/network/property/models/property_model.dart';

import '../../reseller/view/lead/lead_screen.dart';
import '../../seller/module/lead_screen/model/lead_model.dart';


class BuilderLeads extends StatefulWidget {
  final bool isViewAll;
  const BuilderLeads({super.key, this.isViewAll = false});

  @override
  State<BuilderLeads> createState() => _BuilderLeadsState();
}

class _BuilderLeadsState extends State<BuilderLeads> {
  String searchQuery = '';
  List<String> selectedFilters = [];
  bool isLoading = false;

  // Dummy leads data
  final dummyLeads = [
    LeadItem(
      id: "lead_001",
      createdBy: "admin_user",
      name: "John Doe",
      email: "john@example.com",
      phone: "+91 9876543210",
      status: "new",
      source: "Website",
      stage: "contacted",
      notes: "Interested in 2BHK apartment",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      customFields: Items(
        id: "property_001",
        title: "Modern 2BHK Apartment",
        type: "Residential",
        listingType: "Rent",
        propertyType: "Apartment",
        propertyDescription: "Spacious 2BHK flat near city center with all modern amenities.",
        propertyImages: [
          "https://picsum.photos/id/1018/800/400",
          "https://picsum.photos/id/1019/800/400",
        ],
        propertyDetails: PropertyDetails(
          bhk: 2,
          bathroom: 2,
          balcony: 1,
          amenities: ["Gym", "Swimming Pool", "Parking"],
          propertyBuiltUpArea: 1200.0,
          propertyBuiltUpAreaUnit: "sqft",
          propertyFacing: "East",
          floorInfo: FloorInfo(floorNumber: 3, totalFloors: 10),
          furnishInfo: FurnishInfo(
            furnishType: "Semi-Furnished",
            furnishDetails: FurnishDetails(
              modularKitchen: true,
              wardrobes: true,
              acInstalled: false,
            ),
          ),
          financialInfo: FinancialInfo(
            price: 3000000,
            propertyRentPerMonth: 15000,
            maintenance: 1000,
            pricePerSqft: 2500,
            negotiable: true,
          ),
          possessionInfo: PossessionInfo(
            possessionStatus: "Ready to Move",
            propertyAgeInYear: "2",
          ),
        ),
        address: "123 Main Street",
        city: "Pune",
        state: "Maharashtra",
        zipCode: "411001",
        builderName: "Skyline Builders",
        projectName: "Skyline Residency",
        ownerName: "Rahul Mehta",
        ownerPhone: "+91 9988776655",
        isVerified: true,
        createdAt: DateTime.now().toIso8601String(),
      ),
    ),

    LeadItem(
      id: "lead_002",
      createdBy: "agent_01",
      name: "Alice Brown",
      email: "alice.brown@example.com",
      phone: "+91 9123456789",
      status: "interested",
      source: "Agent Referral",
      stage: "site_visit_done",
      notes: "Visited site, requested price negotiation.",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      customFields: Items(
        id: "property_002",
        title: "Luxury Villa with Private Pool",
        type: "Residential",
        listingType: "Sale",
        propertyType: "Villa",
        propertyDescription: "Elegant 4BHK villa with private garden and swimming pool.",
        propertyImages: [
          "https://picsum.photos/id/1025/800/400",
          "https://picsum.photos/id/1026/800/400",
        ],
        propertyDetails: PropertyDetails(
          bhk: 4,
          bathroom: 4,
          balcony: 2,
          amenities: ["Private Pool", "Garden", "CCTV", "Power Backup"],
          propertyBuiltUpArea: 3500.0,
          propertyBuiltUpAreaUnit: "sqft",
          propertyFacing: "North",
          floorInfo: FloorInfo(floorNumber: 1, totalFloors: 2),
          furnishInfo: FurnishInfo(
            furnishType: "Fully-Furnished",
            furnishDetails: FurnishDetails(
              modularKitchen: true,
              wardrobes: true,
              acInstalled: true,
            ),
          ),
          financialInfo: FinancialInfo(
            price: 12000000,
            propertyRentPerMonth: 200,
            maintenance: 2500,
            pricePerSqft: 3400,
            negotiable: false,
          ),
          possessionInfo: PossessionInfo(
            possessionStatus: "Ready to Move",
            propertyAgeInYear: "1",
          ),
        ),
        address: "Palm Meadows, Whitefield",
        city: "Bangalore",
        state: "Karnataka",
        zipCode: "560066",
        builderName: "Prestige Group",
        projectName: "Palm Meadows Estate",
        ownerName: "Amit Sharma",
        ownerPhone: "+91 9898989898",
        isVerified: true,
        createdAt: DateTime.now().toIso8601String(),
      ),
    ),

    LeadItem(
      id: "lead_003",
      createdBy: "sales_team",
      name: "Michael Smith",
      email: "michael.smith@example.com",
      phone: "+91 9988776655",
      status: "new",
      source: "Social Media",
      stage: "new_lead",
      notes: "Generated via Instagram campaign for office space inquiry.",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      customFields: Items(
        id: "property_003",
        title: "Premium Office Space at Connaught Place",
        type: "Commercial",
        listingType: "Lease",
        propertyType: "Office",
        propertyDescription: "Furnished office with 20 workstations and 3 meeting rooms.",
        propertyImages: [
          "https://picsum.photos/id/1031/800/400",
          "https://picsum.photos/id/1032/800/400",
        ],
        propertyDetails: PropertyDetails(
          bhk: null,
          bathroom: 2,
          balcony: null,
          amenities: ["Conference Room", "Security", "Cafeteria", "Wi-Fi"],
          propertyBuiltUpArea: 2500.0,
          propertyBuiltUpAreaUnit: "sqft",
          propertyFacing: "West",
          floorInfo: FloorInfo(floorNumber: 5, totalFloors: 12),
          furnishInfo: FurnishInfo(
            furnishType: "Fully-Furnished",
            furnishDetails: FurnishDetails(
              modularKitchen: false,
              wardrobes: false,
              acInstalled: true,
            ),
          ),
          financialInfo: FinancialInfo(
            price: 2000,
            propertyRentPerMonth: 90000,
            maintenance: 5000,
            pricePerSqft: 5563,
            negotiable: true,
          ),
          possessionInfo: PossessionInfo(
            possessionStatus: "Ready to Move",
            propertyAgeInYear: "3",
          ),
        ),
        address: "Connaught Place",
        city: "New Delhi",
        state: "Delhi NCR",
        zipCode: "110001",
        builderName: "DLF Builders",
        projectName: "DLF Tower",
        ownerName: "Rohit Kapoor",
        ownerPhone: "+91 9000000000",
        isVerified: false,
        createdAt: DateTime.now().toIso8601String(),
      ),
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        leading: (widget.isViewAll)
            ? IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        )
            : null,
        title: Text(
          'Property Buyer Leads',
          style: TextStyle(
            fontWeight: AppFontWeights.bold,
            fontSize: getResponsiveFontSize(
              context,
              AppFontSizes.large,
              AppFontSizes.body,
            ),
          ),
        ),
        automaticallyImplyLeading: (widget.isViewAll),
        backgroundColor: ColorRes.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: ColorRes.primary),
            onPressed: () {
              showFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          buildSearchAndFilter(context),
          buildSelectedFiltersChips(context),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : dummyLeads.isEmpty
                ? Center(
              child: Text(
                'No leads available. Tap + to add a new lead.',
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
                  color: ColorRes.leadGreyColor[600],
                  fontWeight: AppFontWeights.medium,
                ),
              ),
            )
                : RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  isLoading = true;
                });
                await Future.delayed(Duration(seconds: 1));
                setState(() {
                  isLoading = false;
                });
              },
              child: ListView.separated(
                padding: EdgeInsets.all(getResponsivePadding(context)),
                itemCount: dummyLeads.length,
                separatorBuilder: (context, index) => SizedBox(
                  height: getResponsiveSpacing(context),
                ),
                itemBuilder: (context, index) {
                  final lead = dummyLeads[index];
                  return buildLeadCard(context, lead);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchAndFilter(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(getResponsivePadding(context)),
      padding: EdgeInsets.symmetric(horizontal: getResponsivePadding(context)),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        style: TextStyle(fontSize: AppFontSizes.medium),
        decoration: InputDecoration(
          hintText: 'Search buyer leads...',
          hintStyle: TextStyle(fontSize: AppFontSizes.medium),
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget buildSelectedFiltersChips(BuildContext context) {
    if (selectedFilters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getResponsivePadding(context),
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Active Filters:',
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.leadGreyColor[700],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedFilters.clear();
                  });
                },
                child: Text(
                  'Clear All',
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    color: ColorRes.primary,
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: selectedFilters.map((filter) {
                final parts = filter.split(':');
                final filterType = parts[0];
                final filterValue = parts[1];
                final chipColor =
                filterType == 'Stage' ? ColorRes.primary : ColorRes.green;

                return Container(
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: chipColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: chipColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: chipColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            filterType,
                            style: TextStyle(
                              fontSize: AppFontSizes.extraSmall,
                              color: ColorRes.white,
                              fontWeight: AppFontWeights.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          filterValue,
                          style: TextStyle(
                            fontSize: AppFontSizes.small,
                            color: chipColor,
                            fontWeight: AppFontWeights.semiBold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedFilters.remove(filter);
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            child: Icon(
                              Icons.close,
                              size: 14,
                              color: chipColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLeadCard(BuildContext context, LeadItem lead) {
    final isCompact = MediaQuery.of(context).size.width < 600;
    final cardPadding = isCompact ? 12.0 : 16.0;
    final price = lead.customFields?.propertyDetails?.financialInfo?.price ?? 0;
    final displayPrice = formatPrice(price);

    return Container(
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
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 180,
                      child: Text(
                        lead.name!,
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
                        '${lead.name}',
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
                              lead.email!.replaceRange(
                                lead.email!.length < 4 ? lead.email!.length : 4,
                                lead.email!.length,
                                'XXXXXXXXXXX',
                              ),
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
                    displayPrice,
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
          Row(
            children: [
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
              Row(
                children: [
                  buildActionButton(
                    icon: Icons.visibility,
                    color: ColorRes.blueColor,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('View ${lead.name}')),
                      );
                    },
                    tooltip: 'View Details',
                    isCompact: isCompact,
                  ),
                  SizedBox(width: 8),
                  buildActionButton(
                    icon: Icons.edit,
                    color: ColorRes.orangeColor,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Edit ${lead.name}')),
                      );
                    },
                    tooltip: 'Edit Lead',
                    isCompact: isCompact,
                  ),
                  SizedBox(width: 8),
                  buildActionButton(
                    icon: Icons.delete,
                    color: ColorRes.error,
                    onPressed: () => showDeleteConfirmation(context, lead),
                    tooltip: 'Delete Lead',
                    isCompact: isCompact,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showFilterBottomSheet(BuildContext context) {
    List<String> tempSelectedFilters = [...selectedFilters];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorRes.transparentColor,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: const BoxDecoration(
              color: ColorRes.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: ColorRes.leadGreyColor[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Leads',
                        style: TextStyle(
                          fontSize: AppFontSizes.body,
                          fontWeight: AppFontWeights.semiBold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            tempSelectedFilters.clear();
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: ColorRes.error,
                        ),
                        child: Text(
                          'Clear All',
                          style: TextStyle(
                            fontWeight: AppFontWeights.medium,
                            fontSize: AppFontSizes.small,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: ColorRes.leadGreyColor[300]),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildFilterSection(
                          context: context,
                          title: 'Stage',
                          icon: Icons.stairs,
                          filterType: 'Stage',
                          options: [
                            'New Lead',
                            'Contacted',
                            'Interested',
                            'Site Visit',
                            'Sell',
                          ],
                          tempSelectedFilters: tempSelectedFilters,
                          setModalState: setModalState,
                        ),
                        const SizedBox(height: 24),
                        buildFilterSection(
                          context: context,
                          title: 'Status',
                          icon: Icons.flag,
                          filterType: 'Status',
                          options: [
                            'New',
                            'Contacted',
                            'Qualified',
                            'Negotiating',
                            'Lost',
                            'Converted',
                          ],
                          tempSelectedFilters: tempSelectedFilters,
                          setModalState: setModalState,
                        ),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedFilters = [...tempSelectedFilters];
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorRes.primary,
                        foregroundColor: ColorRes.white,
                        padding: const EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Apply Filters (${tempSelectedFilters.length})',
                        style: TextStyle(
                          fontSize: AppFontSizes.body,
                          fontWeight: AppFontWeights.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildFilterSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String filterType,
    required List<String> options,
    required List<String> tempSelectedFilters,
    required StateSetter setModalState,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorRes.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: ColorRes.primary),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: AppFontSizes.bodySmall,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final fullFilterKey = '$filterType:$option';
            final isSelected = tempSelectedFilters
                .any((e) => e.startsWith('$filterType:') && e == fullFilterKey);

            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                setModalState(() {
                  tempSelectedFilters
                      .removeWhere((e) => e.startsWith('$filterType:'));
                  if (selected) {
                    tempSelectedFilters.add(fullFilterKey);
                  }
                });
              },
              selectedColor: ColorRes.primary.withOpacity(0.15),
              checkmarkColor: ColorRes.primary,
              backgroundColor: ColorRes.leadGreyColor[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? ColorRes.primary
                      : ColorRes.leadGreyColor[300]!,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              labelStyle: TextStyle(
                color: isSelected ? ColorRes.primary : ColorRes.blackShade87,
                fontWeight:
                isSelected ? AppFontWeights.semiBold : AppFontWeights.regular,
                fontSize: AppFontSizes.small,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            );
          }).toList(),
        ),
      ],
    );
  }

  void showDeleteConfirmation(BuildContext context, LeadItem lead) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorRes.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Delete Buyer Lead',
            style: TextStyle(
              fontSize: AppFontSizes.large,
              fontWeight: AppFontWeights.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete ${lead.name}?',
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              color: ColorRes.leadGreyColor[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
                  fontWeight: AppFontWeights.medium,
                  color: ColorRes.leadGreyColor[600],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${lead.name} deleted')),
                );
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
                  fontWeight: AppFontWeights.bold,
                  color: ColorRes.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}


String formatPrice(double price) {
  if (price >= 10000000) {
    return '₹${(price / 10000000).toStringAsFixed(2)} Cr';
  } else if (price >= 100000) {
    return '₹${(price / 100000).toStringAsFixed(2)} L';
  } else if (price >= 1000) {
    return '₹${(price / 1000).toStringAsFixed(2)} K';
  } else {
    return '₹${price.toStringAsFixed(0)}';
  }
}


