import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/img_res.dart';
import 'package:nesticope_app/app/widgets/image/custom_image.dart'
    hide ColorRes;
import 'package:nesticope_app/modules/property_price_trend/view/widget/price_formate.dart'
    as Formatter;
import 'package:nesticope_app/modules/seller/view/widget/property_overview_seller.dart';
import 'package:nesticope_app/utils/property_mapper/property_mapper.dart';
import 'package:nesticope_app/utils/shimmer/seller/owner/property_screen/proeprty_list_screen_shimmer.dart';

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
          "My Properties",
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
              child: Row(
                children: [
                  Icon(Icons.filter_list, color: ColorRes.primary, size: 20),
                  SizedBox(width: 6),
                  Text("Filter", style: TextStyle(color: ColorRes.primary, fontWeight: FontWeight.w600)),
                ],
              ),
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
          // Expanded(
          //   child: Obx(() {
          //     // Initial Loading State
          //     if (propertyController.isLoading.value &&
          //         propertyController.items.isEmpty) {
          //       // return const Center(child: CircularProgressIndicator());
          //       return PropertyListScreenShimmer();
          //     }
          //
          //     // Empty State
          //     if (propertyController.items.isEmpty) {
          //       return Center(
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             const Text("No Property found."),
          //             TextButton(
          //               onPressed: () {
          //                 selectedFilters.clear();
          //                 propertyController.clearAllFilters();
          //               },
          //               child: const Text("Clear Filters"),
          //             ),
          //           ],
          //         ),
          //       );
          //     }
          //
          //     return RefreshIndicator(
          //       onRefresh: () => propertyController.refreshList(),
          //       child: NotificationListener<ScrollNotification>(
          //         onNotification: (ScrollNotification scrollInfo) {
          //           if (scrollInfo.metrics.pixels ==
          //               scrollInfo.metrics.maxScrollExtent) {
          //             propertyController.loadMore();
          //           }
          //           return false;
          //         },
          //         child: ListView.builder(
          //           padding: const EdgeInsets.all(16),
          //           itemCount:
          //               propertyController.items.length +
          //               (propertyController.hasMore.value ? 1 : 0),
          //           itemBuilder: (context, index) {
          //             if (index == propertyController.items.length) {
          //               return const Padding(
          //                 padding: EdgeInsets.all(16.0),
          //                 child: Center(child: CircularProgressIndicator()),
          //               );
          //             }
          //
          //             final property = propertyController.items[index];
          //             return _buildPropertyCard(property, () {
          //               propertyController.refreshList();
          //             });
          //           },
          //         ),
          //       ),
          //     ); th======= Flutter Developer ==============================
          //   }),
          // ),
          Expanded(
            child: Obx(() {
              switch (propertyController.state.value) {
                case PropertyListState.initialLoading:
                case PropertyListState.filtering:
                  return const PropertyListScreenShimmer();

                case PropertyListState.empty:
                  return _EmptyState(
                    onClear: () {
                      selectedFilters.clear();
                      propertyController.clearAllFilters();
                    },
                  );

                case PropertyListState.error:
                  return const Center(child: Text("Something went wrong"));

                case PropertyListState.loaded:
                case PropertyListState.loadingMore:
                  return NotificationListener<ScrollEndNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.pixels ==
                          notification.metrics.maxScrollExtent) {
                        propertyController.loadMore();
                      }
                      return false;
                    },
                    child: RefreshIndicator(
                      onRefresh: propertyController.loadInitial,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount:
                            propertyController.items.length +
                            (propertyController.state.value ==
                                    PropertyListState.loadingMore
                                ? 1
                                : 0),
                        itemBuilder: (context, index) {
                          if (index == propertyController.items.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final property = propertyController.items[index];
                          return _buildPropertyCard(property, () {
                            propertyController.loadInitial();
                          });
                        },
                      ),
                    ),
                  );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(Items property, Function() onDelete) {
    final statusLower = property.propertyStatus?.toLowerCase() ?? '';
    final bool isSold = statusLower == 'sold';
    final bool isRented = statusLower == 'rented';
    final priceManager = PropertyPriceManager(
      listingType: property.listingType ?? "",
      financialInfo: property.propertyDetails?.financialInfo ?? FinancialInfo(),
      pgInfo: property.propertyDetails?.pgInfo ?? PgInfo(),
    );

    // final bool isFeatured = property['featured'] ?? false this seller builder overview screen e property model a featured field nai tai isFeatured remove kore disi
    // final bool isFeatured = false and then if you want to add featured badge then you can use this isFeatured variable and show badge in ui
    // log("Building card for property ID: ${property.id}, Status: ${property.propertyStatus}, Listing Type: ${property.listingType}, Price: ${priceManager.displayPrice}")
    // Most If the Ui ;

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
                        SizedBox(
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
                        if (isSold || isRented)
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
                                      color: isSold ? Colors.red : Colors.amber,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      isSold ? "SOLD" : "RENTED",
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
                                color: isSold
                                    ? ColorRes.error
                                    : (isRented ? Colors.amber : ColorRes.white),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                property.propertyStatus?.capitalize ??
                                    'Available',
                                style: TextStyle(
                                  color: (isSold || isRented)
                                      ? ColorRes.white
                                      : ColorRes.primary,
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
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Price
                          SizedBox(height: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    property.propertyType?.capitalize
                                            ?.replaceAll('_', ' ') ??
                                        'Property Title',
                                    style: TextStyle(
                                      fontSize: AppFontSizes.body,
                                      fontWeight: AppFontWeights.semiBold,
                                      color: ColorRes.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorRes.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      priceManager.displayPrice,
                                      style: TextStyle(
                                        fontSize: AppFontSizes.small,
                                        fontWeight: AppFontWeights.semiBold,
                                        color: ColorRes.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 12,
                                    color: ColorRes.leadGreyColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      property.location ?? 'Location',
                                      style: TextStyle(
                                        fontSize: AppFontSizes.caption,
                                        color: ColorRes.leadGreyColor[600],
                                        fontWeight: AppFontWeights.medium,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
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
                                Color(0xffEF4444),
                              ),
                              _buildAnalyticsItem(
                                Icons.share,
                                _formatNumber(property.totalShares ?? 0),
                                'Shares',
                                Color(0xff6366F1),
                              ),
                              _buildAnalyticsItem(
                                Icons.people,
                                _formatNumber(property.totalVisits ?? 0),
                                'Visits',
                                Color(0xff10B981),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
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
            shape: BoxShape.circle,
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
    return Formatter.formatNumber(number);
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onClear;

  const _EmptyState({required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "No properties found",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onClear, child: const Text("Clear Filters")),
        ],
      ),
    );
  }
}
