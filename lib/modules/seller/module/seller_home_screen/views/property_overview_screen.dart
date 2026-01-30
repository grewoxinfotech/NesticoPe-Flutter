import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart'
    hide ColorRes;
import 'package:housing_flutter_app/modules/seller/view/widget/property_overview_seller.dart';
import 'package:housing_flutter_app/utils/property_mapper/property_mapper.dart';

import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../app/manager/property/property_pricemanager.dart';
import '../../../../../data/network/property/models/property_model.dart';
import '../../../../../widgets/bar/filter_bar/filter_chip_bar.dart';
import '../../../../propert_detail/view/property_details.dart';
import '../../../../propert_detail/view/widget/property_card_widget.dart';
import '../../../../reseller/view/listing/property_listing.dart';
import '../../../../reseller/widget/reseller_filter/resseller_property_filter.dart';
import '../../../controllers/seller_property_controller.dart';

class PropertyOverviewScreen extends StatefulWidget {
  const PropertyOverviewScreen({super.key});

  @override
  State<PropertyOverviewScreen> createState() => _PropertyOverviewScreenState();
}

class _PropertyOverviewScreenState extends State<PropertyOverviewScreen> {
  // Inject the controller
  final SellerListedPropertyController propertyController = Get.put(
    SellerListedPropertyController(),
  );

  final RxMap<String, String> selectedFilters = <String, String>{}.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorRes.white,
        foregroundColor: ColorRes.textPrimary,
        automaticallyImplyLeading: false,
        title: const Text(
          "Property Overview",
          style: TextStyle(fontWeight: AppFontWeights.semiBold),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              final result = await Get.to(() => ResellerPropertyFilter());

              if (result != null) {
                // convertFiltersToString is assumed to be a utility you have
                final newFilter = convertFiltersToString(result);

                selectedFilters.assignAll(newFilter);
                // The controller handles adding 'createdBy' internally
                propertyController.applyFilters(
                  Map<String, String>.from(selectedFilters),
                );
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.filter_list),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          /// 🔹 Filter chips UI
          Obx(() {
            if (selectedFilters.isEmpty) return const SizedBox.shrink();
            return FilterChipsBar(
              filters: selectedFilters,
              onClearAll: () {
                selectedFilters.clear();
                propertyController.clearAllFilters();
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

          /// 🔹 Property List with Pagination
          Expanded(
            child: Obx(() {
              // Initial Loading State
              if (propertyController.isLoading.value &&
                  propertyController.items.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              // Empty State
              if (propertyController.items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No Property found."),
                      TextButton(
                        onPressed: () {
                          selectedFilters.clear();
                          propertyController.clearAllFilters();
                        },
                        child: const Text("Clear Filters"),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => propertyController.refreshList(),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                      propertyController.loadMore();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount:
                        propertyController.items.length +
                        (propertyController.hasMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == propertyController.items.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final property = propertyController.items[index];
                      return _buildPropertyCard(property, () {
                        propertyController.refreshList();
                      });
                    },
                  ),
                ),
              );
            }),
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
            log("Tapped on property ID: ${property.toJson()}");
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
                            src:
                                (property.propertyMedia?.images != null &&
                                        property
                                            .propertyMedia!
                                            .images!
                                            .isNotEmpty)
                                    ? property.propertyMedia?.images?.first
                                    : IMGRes.home1,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (property.propertyStatus?.toLowerCase() == 'sold')
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(11),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Transform.rotate(
                                angle: 24.85,

                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorRes.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      "SOLD",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                        letterSpacing: 1.8,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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

  Widget _buildBadge(String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(color: text, fontSize: AppFontSizes.small),
      ),
    );
  }

  Widget _buildAnalyticsRow(Items property) {
    return Row(
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
          Icons.people,
          _formatNumber(property.totalVisits ?? 0),
          'Visits',
          ColorRes.primary,
        ),
      ],
    );
  }

  // Widget _buildAnalyticsItem(IconData icon, String value, String label) {
  //   return Column(
  //     children: [
  //       Icon(icon, size: 16, color: ColorRes.primary),
  //       Text(
  //         value,
  //         style: const TextStyle(fontWeight: AppFontWeights.semiBold),
  //       ),
  //       Text(
  //         label,
  //         style: const TextStyle(
  //           fontSize: AppFontSizes.caption,
  //           color: Colors.grey,
  //         ),
  //       ),
  //     ],
  //   );
  // }

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
    if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}K';
    return number.toString();
  }
}
