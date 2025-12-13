import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart';
import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';
import 'package:housing_flutter_app/modules/seller/view/widget/property_overview_seller.dart';
import 'package:housing_flutter_app/utils/property_mapper/property_mapper.dart';

import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../app/manager/property/property_pricemanager.dart';
import '../../../../../app/manager/property_highlight_manager.dart';
import '../../../../../app/utils/svg_widget.dart';
import '../../../../../data/database/secure_storage_service.dart';
import '../../../../../data/network/auth/model/user_model.dart';
import '../../../../../data/network/property/models/property_model.dart';
import '../../../../../widgets/bar/filter_bar/filter_chip_bar.dart';
import '../../../../add_property/view/create_property.dart';
import '../../../../propert_detail/view/property_details.dart';
import '../../../../reseller/view/lead_overview/lead_detail.dart';
import '../../../../reseller/view/listing/property_listing.dart';
import '../../../../reseller/widget/reseller_filter/resseller_property_filter.dart';

class PropertyOverviewScreen extends StatefulWidget {
  final List<Items> properties;
  final Function() onDelete;

  const PropertyOverviewScreen({
    super.key,
    required this.properties,
    required this.onDelete,
  });

  @override
  State<PropertyOverviewScreen> createState() => _PropertyOverviewScreenState();
}

class _PropertyOverviewScreenState extends State<PropertyOverviewScreen> {
  final RxBool isSelectionMode = false.obs;
  PropertyController propertyController = Get.find<PropertyController>();
  final RxList<String> selectedPropertyIds = <String>[].obs;
  final RxMap<String, String> selectedFilters = <String, String>{}.obs;
  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     await fetchResellerAssignProperty();
  //   });
  //   // controller.resellerPropertyList.value = propertyController.items.value
  //   //     .map((e) => e.state ?? '')
  //   //     .toSet()
  //   //     .toList();
  //
  //   super.initState();
  // }
  //
  // Future<void> fetchResellerAssignProperty() async {
  //   try {
  //     final user = await SecureStorage.getUserData();
  //     final userId = user?.user?.id;
  //
  //     if (userId != null && userId.isNotEmpty) {
  //       final filter = {"created_by": userId};
  //
  //       await propertyController.applyFilters(filter);
  //
  //       // Then load initial data
  //       log("=============$filter");
  //       await propertyController.loadInitial();
  //       log("=======Apply======$filter");
  //     } else {
  //       print("Warning: User ID is null or empty");
  //     }
  //   } catch (e) {
  //     print("Error fetching reseller properties: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorRes.white,
        foregroundColor: ColorRes.textPrimary,
        title: Text(
          "Property Overview",
          style: TextStyle(
            fontWeight: AppFontWeights.semiBold,
            fontSize: AppFontSizes.subtitle,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              // FocusScope.of(context).unfocus();
              // showModalBottomSheet(
              //   context: context,
              //   isScrollControlled: true,
              //   backgroundColor: ColorRes.transparentColor,
              //   builder: (_) => FilterPanel(),
              // );

              // When navigating to the filter screen
              final result = await Get.to(() => ResellerPropertyFilter());

              if (result != null) {
                // Use the filter result
                final newFilter = convertFiltersToString(result);
                final user = await SecureStorage.getUserData();
                final userId = user?.user?.id;

                if (userId != null && userId.isNotEmpty) {
                  newFilter["created_by"] = userId;
                  log("New Filter ${newFilter}");
                  await propertyController.applyFilters(newFilter);
                  selectedFilters
                    ..clear()
                    ..addAll(newFilter);

                  propertyController.applyFilters(
                    Map<String, String>.from(selectedFilters),
                  );
                  print(
                    "Filter Project applied: $result   t   ${selectedFilters.value}",
                  );
                  // Example: {'bhk': 5, 'city': 'Surat', 'state': 'Gujarat'}
                }
              }
            },
            child: Icon(Icons.filter_list),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            return FilterChipsBar(
              filters: selectedFilters.value,
              onClearAll: () {
                selectedFilters.clear();
                propertyController.applyFilters(<String, String>{});
              },
              onRemoveFilter: (key) {
                selectedFilters.remove(key);
                propertyController.applyFilters(
                  Map<String, String>.from(selectedFilters),
                );
              },
              priceRangeFormatter: (min, max) => formatPriceRange(min, max),
            );
          }),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.properties.length,
              itemBuilder: (context, index) {
                final property = widget.properties[index];
                return _buildPropertyCard(property, widget.onDelete);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(Items property, Function() onDelete) {
    final bool isSold = property.propertyStatus == 'Sold';
    final priceManager = PropertyPriceManager(
      listingType: property.listingType ?? "",
      financialInfo: property.propertyDetails?.financialInfo ?? FinancialInfo(),
    );

    // final bool isFeatured = property['featured'] ?? false;

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(
              () => PropertyOverviewSellerScreen(
                propertyId: property.id ?? '',
                onDelete: onDelete,
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: ColorRes.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                color: ColorRes.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Property Image with Status Badge
                    Stack(
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          child: CustomImage(
                            type: CustomImageType.network,
                            src: property.propertyMedia?.images?.first ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Status Badge
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isSold ? ColorRes.error : ColorRes.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              property.propertyStatus?.capitalize ??
                                  'Available',
                              style: TextStyle(
                                color:
                                    isSold ? ColorRes.white : ColorRes.primary,
                                fontSize: AppFontSizes.small,
                                fontWeight: AppFontWeights.semiBold,
                              ),
                            ),
                          ),
                        ),

                        if (property.listingType != null)
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: ColorRes.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                property.listingType!.capitalize.toString(),
                                style: TextStyle(
                                  color: ColorRes.white,
                                  fontSize: AppFontSizes.small,
                                  fontWeight: AppFontWeights.semiBold,
                                ),
                              ),
                            ),
                          ),
                        // Featured Badge
                      ],
                    ),

                    // Property Details
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      property.propertyType ?? 'Property Title',
                                      style: TextStyle(
                                        fontSize: AppFontSizes.body,
                                        fontWeight: AppFontWeights.semiBold,
                                        color: ColorRes.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 14,
                                          color: ColorRes.leadGreyColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            property.location ?? 'Location',
                                            style: TextStyle(
                                              fontSize: AppFontSizes.medium,
                                              color:
                                                  ColorRes.leadGreyColor[600],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorRes.blueColor[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  priceManager.displayPrice,
                                  style: TextStyle(
                                    fontSize: AppFontSizes.small,
                                    fontWeight: AppFontWeights.semiBold,
                                    color: ColorRes.blueColor[700],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Facilities(property: property),

                          const SizedBox(height: 16),

                          // Divider
                          Container(
                            height: 1,
                            color: ColorRes.leadGreyColor[200],
                          ),

                          const SizedBox(height: 16),

                          // Analytics Overview
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildAnalyticsItem(
                                Icons.visibility,
                                _formatNumber(property.totalViews ?? 0),
                                'Views',
                                ColorRes.primary,
                              ),
                              _buildAnalyticsItem(
                                Icons.favorite,
                                _formatNumber(property.totalFavorites ?? 0),
                                'Likes',
                                ColorRes.primary,
                              ),
                              _buildAnalyticsItem(
                                Icons.share,
                                _formatNumber(property.totalShares ?? 0),
                                'Shares',
                                ColorRes.primary,
                              ),
                              _buildAnalyticsItem(
                                Icons.people,
                                _formatNumber(property.totalVisits ?? 0),
                                'Visits',
                                ColorRes.primary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Positioned(
        //   top: 10,
        //   left: 10,
        //   child: IconButton(
        //     onPressed: () {
        //       Get.to(
        //         () => CreatePropertyScreen(
        //           isLogin: true,
        //           isEdit: true,
        //           property: property.toAddPropertyModel(),
        //         ),
        //       );
        //     },
        //     icon: Icon(Icons.edit_outlined),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildFeatureChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ColorRes.leadGreyColor[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: ColorRes.leadGreyColor[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: AppFontSizes.small,
              color: ColorRes.leadGreyColor[700],
              fontWeight: AppFontWeights.medium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsItem(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: AppFontSizes.bodySmall,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textPrimary,
          ),
        ),
        // const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: AppFontSizes.caption,
            color: ColorRes.leadGreyColor[600],
            fontWeight: AppFontWeights.medium,
          ),
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

class Facilities extends StatelessWidget {
  final Items property;

  const Facilities({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final highlights = PropertyHighlightManager(property).getHighlights();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(highlights.length > 3 ? 3 : highlights.length, (
          index,
        ) {
          final item = highlights[index];

          return Row(
            children: [
              if (index != 0) ...[
                const Text('  •', style: TextStyle(fontSize: 10)),
                const SizedBox(width: 6),
              ],
              _buildChip(item.value, 16, icon: item.icon),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildChip(
    String text,
    double size, {
    String? svgIcon,
    IconData? icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ColorRes.leadGreyColor[200],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          svgIcon == null
              ? Icon(icon, size: size, color: ColorRes.primary)
              : AppSvgIcon(assetName: svgIcon, size: size),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: AppFontSizes.small,
              fontWeight: AppFontWeights.medium,
              color: ColorRes.grey,
            ),
          ),
        ],
      ),
    );
  }
}
