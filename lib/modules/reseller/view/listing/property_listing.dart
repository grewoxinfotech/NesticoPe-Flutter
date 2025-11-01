// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/utils/formater/formater.dart';
// import 'package:housing_flutter_app/app/widgets/image/custom_image.dart';
// import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
// import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';
// import 'package:housing_flutter_app/modules/reseller/controller/dashborad_controller/dashboard_controller.dart';
// import 'package:housing_flutter_app/modules/reseller/controller/property_share/reseller_property_share_controller.dart';
// import 'package:housing_flutter_app/modules/reseller/model/reseller_lead_model/reseller_lead_overview.dart';
// import 'package:housing_flutter_app/modules/reseller/view/property_share/reseller_property_share_link_screen.dart';
// import 'package:housing_flutter_app/modules/seller/module/seller_home_screen/views/property_overview_screen.dart';
// import '../../../../app/constants/app_font_sizes.dart';
// import '../../../../app/manager/property/property_name_manager.dart';
// import '../../../../app/manager/property/property_pricemanager.dart';
// import '../../../../app/manager/property_highlight_manager.dart';
// import '../../../../data/network/property/models/property_model.dart';
// import '../../../seller/view/widget/property_overview_seller.dart';
// import '../../model/dashboard/dashboard_model.dart';
// import '../lead/lead_screen.dart';
// import '../lead_overview/lead_detail.dart';
// import '../property_share/reseller_property_share.dart';
// import '../report/report_screen.dart';
//
// const String reseller = "ReSeller";
//
// class ProductListingScreen extends StatefulWidget {
//   ProductListingScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ProductListingScreen> createState() => _ProductListingScreenState();
// }
//
// class _ProductListingScreenState extends State<ProductListingScreen> {
//   final DashboardController controller = Get.put(DashboardController());
//
//   final PropertyController propertyController = Get.put(
//     PropertyController(),
//     tag: reseller,
//   );
//
//   @override
//   void initState() {
//     fetchResellerAssignProperty();
//     super.initState();
//   }
//
//   Future<void> fetchResellerAssignProperty() async {
//     final user = await SecureStorage.getUserData();
//     final userId = user?.user?.id ?? '';
//     if (user != null) {
//       final filter = {"assignedTo": userId};
//       propertyController.applyFilters(filter);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorRes.white,
//       appBar: AppBar(
//         backgroundColor: ColorRes.white,
//         elevation: 0,
//         title: Text(
//           'Property Listing',
//           style: TextStyle(
//             color: ColorRes.textColor,
//             fontWeight: AppFontWeights.bold,
//             fontSize: getResponsiveFontSize(
//               context,
//               AppFontSizes.large,
//               AppFontSizes.body,
//             ),
//           ),
//         ),
//         automaticallyImplyLeading: false,
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(1),
//           child: Container(color: ColorRes.leadGreyColor[200], height: 1),
//         ),
//         actions: [
//           // Filter Button with Active Badge
//           GestureDetector(
//             onTap: () {
//               FocusScope.of(context).unfocus();
//               showModalBottomSheet(
//                 context: context,
//                 isScrollControlled: true,
//                 backgroundColor: ColorRes.transparentColor,
//                 builder: (_) => FilterPanel(),
//               );
//             },
//             child: Container(
//               height: 35,
//               margin: EdgeInsets.only(right: 8),
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: ColorRes.primary.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: ColorRes.primary.withOpacity(0.3),
//                   width: 1.5,
//                 ),
//               ),
//               child: Text(
//                 'Filter',
//                 style: TextStyle(
//                   color: ColorRes.primary,
//                   fontSize: AppFontSizes.bodySmall,
//                   fontWeight: AppFontWeights.semiBold,
//                 ),
//               ),
//             ),
//           ),
//
//           // Sort Button
//           Container(
//             height: 35,
//             margin: EdgeInsets.only(right: 12),
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             decoration: BoxDecoration(
//               color: ColorRes.leadGreyColor[100],
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: ColorRes.leadGreyColor[300]!, width: 1),
//             ),
//             child: PopupMenuButton<SortOption>(
//               icon: Text(
//                 'Sort',
//                 style: TextStyle(
//                   color: ColorRes.leadGreyColor[700],
//                   fontSize: AppFontSizes.bodySmall,
//                   fontWeight: AppFontWeights.semiBold,
//                 ),
//               ),
//               onSelected: controller.updateSortOption,
//               offset: Offset(0, 40),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//                 side: BorderSide(
//                   color: ColorRes.leadGreyColor.shade300,
//                   width: 0.7,
//                 ),
//               ),
//               elevation: 8,
//               itemBuilder:
//                   (context) => [
//                     _buildSortMenuItem(
//                       Icons.sort_by_alpha_rounded,
//                       'Name',
//                       SortOption.name,
//                       ColorRes.primary,
//                     ),
//                     _buildSortMenuItem(
//                       Icons.arrow_upward_rounded,
//                       'Price: Low to High',
//                       SortOption.priceAsc,
//                       ColorRes.green,
//                     ),
//                     _buildSortMenuItem(
//                       Icons.arrow_downward_rounded,
//                       'Price: High to Low',
//                       SortOption.priceDesc,
//                       ColorRes.error,
//                     ),
//                     _buildSortMenuItem(
//                       Icons.star_rounded,
//                       'Rating',
//                       SortOption.rating,
//                       ColorRes.homeAmber,
//                     ),
//                   ],
//             ),
//           ),
//
//           // Share Multiple
//           IconButton(
//             onPressed: () {},
//             icon: Icon(Icons.share_outlined),
//             color: ColorRes.primary,
//             iconSize: 22,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Enhanced Search Bar
//           Container(
//             color: ColorRes.white,
//             padding: EdgeInsets.fromLTRB(
//               getResponsivePadding(context),
//               12,
//               getResponsivePadding(context),
//               12,
//             ),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: ColorRes.leadGreyColor[50],
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: ColorRes.leadGreyColor.shade200,
//                   width: 1.5,
//                 ),
//               ),
//               child: TextField(
//                 onChanged: controller.updateSearch,
//                 style: TextStyle(fontSize: AppFontSizes.medium),
//                 decoration: InputDecoration(
//                   hintText: 'Search properties by name or location...',
//                   hintStyle: TextStyle(
//                     fontSize: AppFontSizes.medium,
//                     color: ColorRes.leadGreyColor[400],
//                   ),
//                   prefixIcon: Icon(
//                     Icons.search_rounded,
//                     color: ColorRes.leadGreyColor[400],
//                   ),
//                   suffixIcon: Obx(
//                     () =>
//                         controller.searchQuery.value.isNotEmpty
//                             ? IconButton(
//                               icon: Icon(
//                                 Icons.clear_rounded,
//                                 color: ColorRes.leadGreyColor[400],
//                               ),
//                               onPressed: () => controller.updateSearch(''),
//                             )
//                             : SizedBox.shrink(),
//                   ),
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.symmetric(vertical: 16),
//                 ),
//               ),
//             ),
//           ),
//
//           // Active Filters Display
//           // Replace the Active Filters Display section in your ProductListingScreen
//
//           // Active Filters Display - UPDATED VERSION
//           Obx(() {
//             bool hasPriceFilter =
//                 controller.filterMinPrice.value > controller.minPrice.value ||
//                 controller.filterMaxPrice.value < controller.maxPrice.value;
//
//             bool hasCategoryFilter =
//                 controller.selectedProductCategories.isNotEmpty;
//
//             bool hasActiveFilters = hasCategoryFilter || hasPriceFilter;
//
//             return hasActiveFilters
//                 ? Container(
//                   color: ColorRes.white,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: getResponsivePadding(context),
//                     vertical: 8,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             'Active Filters:',
//                             style: TextStyle(
//                               fontSize: AppFontSizes.small,
//                               fontWeight: AppFontWeights.semiBold,
//                               color: ColorRes.leadGreyColor[700],
//                             ),
//                           ),
//                           const Spacer(),
//                           TextButton.icon(
//                             onPressed: () {
//                               controller.clearFilters();
//
//                               controller.selectedProductCategories.addAll([]);
//                             },
//
//                             label: Text(
//                               'Clear All',
//                               style: TextStyle(
//                                 fontSize: AppFontSizes.small,
//                                 color: ColorRes.primary,
//                                 fontWeight: AppFontWeights.medium,
//                               ),
//                             ),
//                             style: TextButton.styleFrom(
//                               padding: EdgeInsets.zero,
//                               minimumSize: Size.zero,
//                               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       SizedBox(
//                         height: 36,
//                         child: ListView(
//                           scrollDirection: Axis.horizontal,
//                           children: [
//                             // Category filters
//                             ...controller.selectedProductCategories.map((
//                               category,
//                             ) {
//                               return Container(
//                                 margin: EdgeInsets.only(right: 8),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(12),
//                                   color: ColorRes.primary.withOpacity(0.1),
//                                   border: Border.all(
//                                     color: ColorRes.primary.withOpacity(0.3),
//                                     width: 1,
//                                   ),
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 12,
//                                     vertical: 6,
//                                   ),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Text(
//                                         category,
//                                         style: TextStyle(
//                                           fontSize: AppFontSizes.small,
//                                           color: ColorRes.primary,
//                                           fontWeight: AppFontWeights.semiBold,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 6),
//                                       InkWell(
//                                         onTap: () {
//                                           controller.selectedProductCategories
//                                               .remove(category);
//                                           controller.applyFilters();
//                                         },
//                                         borderRadius: BorderRadius.circular(12),
//                                         child: Container(
//                                           padding: const EdgeInsets.all(2),
//                                           child: Icon(
//                                             Icons.close,
//                                             size: 14,
//                                             color: ColorRes.primary,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//
//                             // Price filter
//                             if (hasPriceFilter)
//                               Container(
//                                 margin: EdgeInsets.only(right: 8),
//                                 decoration: BoxDecoration(
//                                   color: ColorRes.primary.withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(20),
//                                   border: Border.all(
//                                     color: ColorRes.primary.withOpacity(0.3),
//                                     width: 1,
//                                   ),
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 12,
//                                     vertical: 6,
//                                   ),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Text(
//                                         '${Formatter.formatPrice(controller.filterMinPrice.value)} - ${Formatter.formatPrice(controller.filterMaxPrice.value)}',
//                                         style: TextStyle(
//                                           fontSize: AppFontSizes.small,
//                                           color: ColorRes.primary,
//                                           fontWeight: AppFontWeights.semiBold,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 6),
//                                       InkWell(
//                                         onTap: () {
//                                           controller.updatePriceRange(
//                                             controller.minPrice.value,
//                                             controller.maxPrice.value,
//                                           );
//                                           controller.applyFilters();
//                                         },
//                                         borderRadius: BorderRadius.circular(12),
//                                         child: Container(
//                                           padding: const EdgeInsets.all(2),
//                                           child: Icon(
//                                             Icons.close,
//                                             size: 14,
//                                             color: ColorRes.primary,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//                 : SizedBox.shrink();
//           }),
//
//           // Products Grid
//           // Expanded(
//           //   child: Obx(() {
//           //     if (controller.isLoading.value) {
//           //       return Center(
//           //         child: CircularProgressIndicator(color: ColorRes.primary),
//           //       );
//           //     }
//           //
//           //     if (controller.error.value.isNotEmpty) {
//           //       return ErrorWidgetCustom();
//           //     }
//           //
//           //     if (controller.filteredProducts.isEmpty) {
//           //       return EmptyStateWidget();
//           //     }
//           //
//           //     return ProductsGrid();
//           //   }),
//           // ),
//           Expanded(
//             child: Obx(() {
//               if (propertyController.isLoading.value) {
//                 return Center(
//                   child: CircularProgressIndicator(color: ColorRes.primary),
//                 );
//               }
//
//               if (!propertyController.isLoading.value &&
//                   propertyController.items.isEmpty) {
//                 // return ErrorWidgetCustom(
//                 //   onPressed: () {
//                 //     fetchResellerAssignProperty();
//                 //   },
//                 // );
//
//                 return Center(child: Text("No Listing Yet."));
//               }
//
//               // if (propertyController.filteredProducts.isEmpty) {
//               //   return EmptyStateWidget();
//               // }
//
//               return NotificationListener<ScrollEndNotification>(
//                 onNotification: (scrollEnd) {
//                   final metrics = scrollEnd.metrics;
//                   if (metrics.atEdge && metrics.pixels != 0) {
//                     propertyController.loadMore();
//                   }
//                   return false;
//                 },
//                 child: RefreshIndicator(
//                   onRefresh: propertyController.refreshList,
//                   child: ProductsGrid(),
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActiveFilterChip(String label, VoidCallback onRemove) {
//     return Container(
//       margin: EdgeInsets.only(right: 8, top: 8, bottom: 8),
//       child: Chip(
//         label: Text(
//           label,
//           style: TextStyle(
//             fontSize: AppFontSizes.small,
//             color: ColorRes.primary,
//             fontWeight: AppFontWeights.semiBold,
//           ),
//         ),
//         deleteIcon: Icon(
//           Icons.close_rounded,
//           size: 16,
//           color: ColorRes.primary,
//         ),
//         onDeleted: onRemove,
//         backgroundColor: ColorRes.primary.withOpacity(0.1),
//         side: BorderSide(color: ColorRes.primary.withOpacity(0.3), width: 1),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }
//
//   PopupMenuItem<SortOption> _buildSortMenuItem(
//     IconData icon,
//     String text,
//     SortOption value,
//     Color color,
//   ) {
//     return PopupMenuItem(
//       value: value,
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.08),
//               border: Border.all(width: 1, color: color.withOpacity(0.3)),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(icon, size: 15, color: color),
//           ),
//           SizedBox(width: 12),
//           Text(text, style: TextStyle(fontSize: AppFontSizes.caption)),
//         ],
//       ),
//     );
//   }
// }
//
// class FilterPanel extends StatefulWidget {
//   @override
//   _FilterPanelState createState() => _FilterPanelState();
// }
//
// class _FilterPanelState extends State<FilterPanel> {
//   final DashboardController controller = Get.find();
//
//   // Temporary filter values
//   late RxList<String> tempSelectedCategories;
//   late double tempMinPrice;
//   late double tempMaxPrice;
//
//   @override
//   void initState() {
//     super.initState();
//
//     tempSelectedCategories =
//         <String>[...controller.selectedProductCategories].obs;
//
//     // FIX: Ensure we use the actual filter values, not uninitialized ones
//     tempMinPrice = controller.filterMinPrice.value;
//     tempMaxPrice = controller.filterMaxPrice.value;
//
//     // Safety check: if values are invalid, use min/max
//     if (tempMinPrice < controller.minPrice.value ||
//         tempMaxPrice > controller.maxPrice.value ||
//         tempMinPrice > tempMaxPrice) {
//       tempMinPrice = controller.minPrice.value;
//       tempMaxPrice = controller.maxPrice.value;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             margin: EdgeInsets.only(top: 12),
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//               color: ColorRes.leadGreyColor[300],
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//
//           Padding(
//             padding: EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Header
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Filters',
//                       style: TextStyle(
//                         fontSize: AppFontSizes.body,
//                         fontWeight: AppFontWeights.semiBold,
//                       ),
//                     ),
//                     Spacer(),
//                     TextButton(
//                       onPressed: () {
//                         setState(() {
//                           tempSelectedCategories.clear();
//                           tempMinPrice = controller.minPrice.value;
//                           tempMaxPrice = controller.maxPrice.value;
//                         });
//                         controller.clearFilters();
//                         Navigator.pop(context);
//                       },
//                       child: Text(
//                         'Clear All',
//                         style: TextStyle(
//                           fontWeight: AppFontWeights.medium,
//                           fontSize: AppFontSizes.small,
//                           color: ColorRes.error[400],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 24),
//
//                 // Category Filter Section
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: ColorRes.primary.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Icon(
//                         Icons.category_outlined,
//                         size: 18,
//                         color: ColorRes.primary,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Text(
//                       'Property Type',
//                       style: TextStyle(
//                         fontSize: AppFontSizes.bodySmall,
//                         fontWeight: AppFontWeights.semiBold,
//                         color: ColorRes.textColor,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 12),
//                 Obx(
//                   () => Wrap(
//                     spacing: 8,
//                     runSpacing: -4,
//                     children:
//                         controller.categories.where((cat) => cat != 'All').map((
//                           category,
//                         ) {
//                           bool isSelected = tempSelectedCategories.contains(
//                             category,
//                           );
//                           return FilterChip(
//                             label: Text(
//                               category,
//                               style: TextStyle(fontSize: AppFontSizes.caption),
//                             ),
//                             selected: isSelected,
//                             onSelected: (_) {
//                               setState(() {
//                                 if (isSelected) {
//                                   tempSelectedCategories.remove(category);
//                                 } else {
//                                   tempSelectedCategories.add(category);
//                                 }
//                               });
//                             },
//                             backgroundColor: Colors.grey[100],
//                             checkmarkColor: ColorRes.primary,
//                             selectedColor: ColorRes.primary.withOpacity(0.15),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                               side: BorderSide(
//                                 color:
//                                     isSelected
//                                         ? ColorRes.primary
//                                         : ColorRes.leadGreyColor[300]!,
//                                 width: 1,
//                               ),
//                             ),
//                             labelStyle: TextStyle(
//                               color:
//                                   isSelected
//                                       ? ColorRes.primary
//                                       : ColorRes.blackShade87,
//                               fontWeight:
//                                   isSelected
//                                       ? AppFontWeights.semiBold
//                                       : AppFontWeights.regular,
//                               fontSize: AppFontSizes.small,
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 8,
//                             ),
//                           );
//                         }).toList(),
//                   ),
//                 ),
//                 SizedBox(height: 24),
//
//                 // Price Range Filter Section
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: ColorRes.primary.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Icon(
//                         Icons.attach_money,
//                         size: 18,
//                         color: ColorRes.primary,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Text(
//                       'Price Range',
//                       style: TextStyle(
//                         fontSize: AppFontSizes.bodySmall,
//                         fontWeight: AppFontWeights.semiBold,
//                         color: ColorRes.textColor,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//
//                 // FIX: Add safety check for RangeSlider
//                 Obx(() {
//                   // Get actual min/max from controller
//                   final minVal = controller.minPrice.value;
//                   final maxVal = controller.maxPrice.value;
//
//                   // Ensure temp values are within bounds
//                   if (tempMinPrice < minVal) tempMinPrice = minVal;
//                   if (tempMaxPrice > maxVal) tempMaxPrice = maxVal;
//                   if (tempMinPrice > tempMaxPrice) tempMinPrice = minVal;
//
//                   return SliderTheme(
//                     data: SliderThemeData(
//                       activeTrackColor: ColorRes.primary,
//                       inactiveTrackColor: ColorRes.leadGreyColor[200],
//                       thumbColor: ColorRes.primary,
//                       overlayColor: ColorRes.primary.withOpacity(0.2),
//                       rangeThumbShape: RoundRangeSliderThumbShape(
//                         enabledThumbRadius: 10,
//                         elevation: 3,
//                       ),
//                       rangeTrackShape: RoundedRectRangeSliderTrackShape(),
//                     ),
//                     child: RangeSlider(
//                       values: RangeValues(tempMinPrice, tempMaxPrice),
//                       min: minVal,
//                       max: maxVal,
//                       divisions: 20,
//                       labels: RangeLabels(
//                         '${Formatter.formatPrice(tempMinPrice)}',
//                         '${Formatter.formatPrice(tempMaxPrice)}',
//                       ),
//                       onChanged: (RangeValues values) {
//                         setState(() {
//                           tempMinPrice = values.start;
//                           tempMaxPrice = values.end;
//                         });
//                       },
//                     ),
//                   );
//                 }),
//
//                 SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 8,
//                       ),
//                       decoration: BoxDecoration(
//                         color: ColorRes.primary.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: ColorRes.primary.withOpacity(0.3),
//                         ),
//                       ),
//                       child: Text(
//                         '${Formatter.formatPrice(tempMinPrice)}',
//                         style: TextStyle(
//                           color: ColorRes.primary,
//                           fontSize: AppFontSizes.bodySmall,
//                           fontWeight: AppFontWeights.semiBold,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 8,
//                       ),
//                       decoration: BoxDecoration(
//                         color: ColorRes.primary.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: ColorRes.primary.withOpacity(0.3),
//                         ),
//                       ),
//                       child: Text(
//                         '${Formatter.formatPrice(tempMaxPrice)}',
//                         style: TextStyle(
//                           color: ColorRes.primary,
//                           fontSize: AppFontSizes.bodySmall,
//                           fontWeight: AppFontWeights.semiBold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 24),
//
//                 // Apply Button
//                 SafeArea(
//                   child: SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: ColorRes.primary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         elevation: 2,
//                       ),
//                       onPressed: () {
//                         // Apply all filters to controller
//                         controller.selectedProductCategories.clear();
//                         controller.selectedProductCategories.addAll(
//                           tempSelectedCategories,
//                         );
//                         controller.updatePriceRange(tempMinPrice, tempMaxPrice);
//                         controller.applyFilters();
//                         Navigator.pop(context);
//                       },
//                       child: Obx(
//                         () => Text(
//                           'Apply Filters (${tempSelectedCategories.length})',
//                           style: TextStyle(
//                             fontSize: AppFontSizes.bodyMedium,
//                             fontWeight: AppFontWeights.semiBold,
//                             color: ColorRes.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ProductsGrid extends StatelessWidget {
//   final DashboardController controller = Get.find();
//   final PropertyController propertyController = Get.find(tag: reseller);
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       // Use the already filtered products from controller
//       final displayProducts = propertyController.items.value;
//
//       if (displayProducts.isEmpty) {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.search_off,
//                 size: 64,
//                 color: ColorRes.leadGreyColor[400],
//               ),
//               SizedBox(height: 16),
//               Text(
//                 'No properties found',
//                 style: TextStyle(
//                   fontSize: AppFontSizes.large,
//                   fontWeight: AppFontWeights.semiBold,
//                   color: ColorRes.leadGreyColor[600],
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'Try adjusting your filters',
//                 style: TextStyle(
//                   fontSize: AppFontSizes.medium,
//                   color: ColorRes.leadGreyColor[500],
//                 ),
//               ),
//             ],
//           ),
//         );
//       }
//
//       return Padding(
//         padding: const EdgeInsets.all(12),
//         child: ListView.separated(
//           itemCount: displayProducts.length,
//           separatorBuilder: (_, __) => SizedBox(height: 12),
//           itemBuilder: (context, index) {
//             return ProductCard(product: displayProducts[index]);
//           },
//         ),
//       );
//     });
//   }
// }
//
// class ProductCard extends StatelessWidget {
//   final Items product;
//
//   const ProductCard({Key? key, required this.product}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     Get.lazyPut(() => ReSellerPropertyShareController());
//     final propertyShareController = Get.find<ReSellerPropertyShareController>();
//     final manager = PropertyNameManager(product);
//     final priceManager = PropertyPriceManager(
//       listingType: product.listingType ?? 'sale',
//       financialInfo: product.propertyDetails?.financialInfo,
//     );
//     return Material(
//       color: ColorRes.white,
//       borderRadius: BorderRadius.circular(12),
//       elevation: 1,
//       shadowColor: ColorRes.black.withOpacity(0.06),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () {
//           Get.to(() => LeadDetailScreen(property: product));
//           // Get.to(() => PropertyOverviewSellerScreen(property: product));
//         },
//         child: Container(
//           height: 120,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: ColorRes.leadGreyColor.shade200,
//               width: 1,
//             ),
//           ),
//           child: Row(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.horizontal(
//                   left: Radius.circular(11),
//                 ),
//                 child: CustomImage(
//                   type: CustomImageType.network,
//                   src: product.propertyMedia?.images?.first,
//                   width: 110,
//                   height: 121,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//
//               // Content Section
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Title
//                       Row(
//                         children: [
//                           SizedBox(
//                             width: 180,
//                             child: Text(
//                               '${manager.displayName}',
//                               style: TextStyle(
//                                 fontSize: AppFontSizes.bodyMedium,
//                                 fontWeight: AppFontWeights.semiBold,
//                                 color: ColorRes.textColor,
//                                 height: 1.2,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           Spacer(),
//                           GestureDetector(
//                             onTap: () async {
//                               final user = await SecureStorage.getUserData();
//                               final resellerId = user?.user?.id ?? '';
//                               final propertyId = product.id ?? '';
//
//                               if (resellerId.isEmpty || propertyId.isEmpty) {
//                                 Get.snackbar(
//                                   "Error",
//                                   "Missing reseller or property information.",
//                                 );
//                                 return;
//                               }
//
//                               // ✅ Call controller method
//                               await propertyShareController
//                                   .handleShareButtonTap(
//                                     propertyId: propertyId,
//                                     resellerId: resellerId,
//                                   );
//                             },
//                             child: const Icon(Icons.share, size: 16),
//                           ),
//                         ],
//                       ),
//
//                       // SizedBox(height: 6),
//                       Spacer(),
//
//                       // Address with icon
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               product.address ?? 'No address provided',
//                               style: TextStyle(
//                                 fontSize: AppFontSizes.caption,
//                                 color: ColorRes.leadGreyColor[600],
//                                 height: 1.3,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       // SizedBox(height: 8),
//                       Spacer(),
//
//                       Facilities(property: product),
//                       Spacer(),
//
//                       // Price and Visit Button Row
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               '${priceManager.displayPrice}',
//                               style: TextStyle(
//                                 fontSize: AppFontSizes.body,
//                                 fontWeight: AppFontWeights.bold,
//                                 color: ColorRes.textColor,
//                                 height: 1,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           SizedBox(width: 8),
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 14,
//                               vertical: 6,
//                             ),
//                             decoration: BoxDecoration(
//                               color: ColorRes.primary,
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             child: Text(
//                               'Visit',
//                               style: TextStyle(
//                                 fontWeight: AppFontWeights.semiBold,
//                                 fontSize: AppFontSizes.small,
//                                 color: ColorRes.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFeature(IconData icon, String text) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 13, color: ColorRes.leadGreyColor[600]),
//         SizedBox(width: 4),
//         Text(
//           text,
//           style: TextStyle(
//             fontSize: AppFontSizes.caption,
//             color: ColorRes.leadGreyColor[700],
//             fontWeight: AppFontWeights.medium,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class Facilities extends StatelessWidget {
//   final Items property;
//
//   const Facilities({super.key, required this.property});
//
//   @override
//   Widget build(BuildContext context) {
//     final highlights = PropertyHighlightManager(property).getHighlights();
//
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: List.generate(highlights.length > 3 ? 3 : highlights.length, (
//           index,
//         ) {
//           final item = highlights[index];
//
//           return Row(
//             children: [
//               if (index != 0) ...[
//                 const Text('  •', style: TextStyle(fontSize: 10)),
//                 const SizedBox(width: 6),
//               ],
//               _buildChip(item.value, 13, icon: item.icon),
//             ],
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget _buildChip(String text, double size, {IconData? icon}) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (icon != null)
//           Icon(icon, size: size, color: const Color(0xFF2563EB)),
//         const SizedBox(width: 4),
//         Text(
//           text,
//           style: TextStyle(
//             fontSize: AppFontSizes.caption,
//             fontWeight: AppFontWeights.medium,
//             color: ColorRes.blackShade54,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class ErrorWidgetCustom extends StatelessWidget {
//   final VoidCallback? onPressed;
//   final DashboardController controller = Get.find();
//
//   ErrorWidgetCustom({super.key, this.onPressed});
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: ColorRes.error[50],
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.error_outline_rounded,
//                 size: 48,
//                 color: ColorRes.error[400],
//               ),
//             ),
//             SizedBox(height: 24),
//             Text(
//               'Something went wrong',
//               style: TextStyle(
//                 fontSize: AppFontSizes.large,
//                 fontWeight: AppFontWeights.extraBold,
//                 color: ColorRes.textColor,
//               ),
//             ),
//             SizedBox(height: 8),
//             Obx(
//               () => Text(
//                 controller.error.value,
//                 style: TextStyle(
//                   color: ColorRes.leadGreyColor[600],
//                   fontSize: AppFontSizes.medium,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: onPressed ?? controller.loadProducts,
//               icon: Icon(Icons.refresh_rounded),
//               label: Text('Try Again'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: ColorRes.primary,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // Empty State Widget
// class EmptyStateWidget extends StatelessWidget {
//   final DashboardController controller = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(32),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: EdgeInsets.all(32),
//                 decoration: BoxDecoration(
//                   color: ColorRes.leadGreyColor[100],
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.search_off_rounded,
//                   size: 64,
//                   color: ColorRes.leadGreyColor[400],
//                 ),
//               ),
//               SizedBox(height: 24),
//               Text(
//                 'No properties found',
//                 style: TextStyle(
//                   fontSize: AppFontSizes.large,
//                   fontWeight: AppFontWeights.extraBold,
//                   color: ColorRes.textColor,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'Try adjusting your filters or search terms',
//                 style: TextStyle(
//                   color: ColorRes.leadGreyColor[600],
//                   fontSize: AppFontSizes.medium,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 24),
//               OutlinedButton.icon(
//                 onPressed: () {
//                   controller.clearFilters();
//                   controller.updateSearch('');
//                   controller.selectedProductCategories.clear();
//                   controller.selectedProductCategories.addAll([]);
//                   controller.updatePriceRange(1600, 4800);
//                   controller.applyFilters();
//                 },
//                 icon: Icon(Icons.filter_alt_off_rounded),
//                 label: Text('Clear Filters'),
//                 style: OutlinedButton.styleFrom(
//                   foregroundColor: ColorRes.primary,
//                   side: BorderSide(color: ColorRes.primary),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';
import 'package:housing_flutter_app/modules/reseller/controller/dashborad_controller/dashboard_controller.dart';
import 'package:housing_flutter_app/modules/reseller/controller/property_share/reseller_property_share_controller.dart';
import 'package:housing_flutter_app/modules/reseller/model/reseller_lead_model/reseller_lead_overview.dart';
import 'package:housing_flutter_app/modules/reseller/view/property_share/reseller_property_share_link_screen.dart';
import 'package:housing_flutter_app/modules/seller/module/seller_home_screen/views/property_overview_screen.dart';
import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/manager/property/property_name_manager.dart';
import '../../../../app/manager/property/property_pricemanager.dart';
import '../../../../app/manager/property_highlight_manager.dart';
import '../../../../data/network/property/models/property_model.dart';
import '../../../seller/view/widget/property_overview_seller.dart';
import '../../model/dashboard/dashboard_model.dart';
import '../lead/lead_screen.dart';
import '../lead_overview/lead_detail.dart';
import '../property_share/reseller_property_share.dart';
import '../report/report_screen.dart';

const String reseller = "ReSeller";

class ProductListingScreen extends StatefulWidget {
  ProductListingScreen({Key? key}) : super(key: key);

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  final DashboardController controller = Get.put(DashboardController());

  final PropertyController propertyController = Get.put(
    PropertyController(),
    tag: reseller,
  );

  // Multi-select state
  final RxBool isSelectionMode = false.obs;
  final RxList<String> selectedPropertyIds = <String>[].obs;

  @override
  void initState() {
    fetchResellerAssignProperty();
    super.initState();
  }

  Future<void> fetchResellerAssignProperty() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? '';
    if (user != null) {
      final filter = {"assignedTo": userId};
      propertyController.applyFilters(filter);
    }
  }

  void toggleSelectionMode() {
    isSelectionMode.value = !isSelectionMode.value;
    if (!isSelectionMode.value) {
      selectedPropertyIds.clear();
    }
  }

  void togglePropertySelection(String propertyId) {
    if (selectedPropertyIds.contains(propertyId)) {
      selectedPropertyIds.remove(propertyId);
    } else {
      selectedPropertyIds.add(propertyId);
    }

    // Exit selection mode if no items selected
    if (selectedPropertyIds.isEmpty) {
      isSelectionMode.value = false;
    }
  }

  Future<void> shareSelectedProperties() async {
    if (selectedPropertyIds.isEmpty) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: "Please select at least one property to share.",
        contentType: ContentType.failure,
      );
      return;
    }

    final user = await SecureStorage.getUserData();
    final resellerId = user?.user?.id ?? '';

    if (resellerId.isEmpty) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: "Missing reseller information.",
        contentType: ContentType.failure,
      );
      return;
    }
    print("Selected Property IDs: $selectedPropertyIds");
    await Get.to(
      () => ReSellerPropertyShare(
        propertyId: selectedPropertyIds,
        isMultiShare: true,
      ),
    );

    // Exit selection mode and clear selections
    isSelectionMode.value = false;
    selectedPropertyIds.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,

      // appBar: AppBar(
      //   backgroundColor: ColorRes.white,
      //   elevation: 0,
      //   leading: Obx(() {
      //     return isSelectionMode.value
      //         ? IconButton(
      //           icon: Icon(Icons.close, color: ColorRes.textColor),
      //           onPressed: toggleSelectionMode,
      //         )
      //         : const SizedBox.shrink(); // ✅ return an empty widget instead of null
      //   }),
      //
      //   title: Obx(
      //     () => Text(
      //       isSelectionMode.value
      //           ? '${selectedPropertyIds.length} Selected'
      //           : 'Property Listing',
      //       style: TextStyle(
      //         color: ColorRes.textColor,
      //         fontWeight: AppFontWeights.bold,
      //         fontSize: getResponsiveFontSize(
      //           context,
      //           AppFontSizes.large,
      //           AppFontSizes.body,
      //         ),
      //       ),
      //     ),
      //   ),
      //   automaticallyImplyLeading: false,
      //   bottom: PreferredSize(
      //     preferredSize: Size.fromHeight(1),
      //     child: Container(color: ColorRes.leadGreyColor[200], height: 1),
      //   ),
      //   actions: [
      //     Obx(() {
      //       if (isSelectionMode.value) {
      //         // Show "Select All" and "Share" when in selection mode
      //         return Row(
      //           children: [
      //             TextButton(
      //               onPressed: () {
      //                 if (selectedPropertyIds.length ==
      //                     propertyController.items.length) {
      //                   // Deselect all
      //                   selectedPropertyIds.clear();
      //                 } else {
      //                   // Select all
      //                   selectedPropertyIds.clear();
      //                   for (var property in propertyController.items) {
      //                     if (property.id != null) {
      //                       selectedPropertyIds.add(property.id!);
      //                     }
      //                   }
      //                 }
      //               },
      //               child: Text(
      //                 selectedPropertyIds.length ==
      //                         propertyController.items.length
      //                     ? 'Deselect All'
      //                     : 'Select All',
      //                 style: TextStyle(
      //                   color: ColorRes.primary,
      //                   fontSize: AppFontSizes.small,
      //                   fontWeight: AppFontWeights.semiBold,
      //                 ),
      //               ),
      //             ),
      //             SizedBox(width: 8),
      //           ],
      //         );
      //       }
      //
      //       // Normal mode actions
      //       return Row(
      //         children: [
      //           // Filter Button
      //           GestureDetector(
      //             onTap: () {
      //               FocusScope.of(context).unfocus();
      //               showModalBottomSheet(
      //                 context: context,
      //                 isScrollControlled: true,
      //                 backgroundColor: ColorRes.transparentColor,
      //                 builder: (_) => FilterPanel(),
      //               );
      //             },
      //             child: Container(
      //               height: 35,
      //               margin: EdgeInsets.only(right: 8),
      //               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      //               decoration: BoxDecoration(
      //                 color: ColorRes.primary.withOpacity(0.1),
      //                 borderRadius: BorderRadius.circular(12),
      //                 border: Border.all(
      //                   color: ColorRes.primary.withOpacity(0.3),
      //                   width: 1.5,
      //                 ),
      //               ),
      //               child: Text(
      //                 'Filter',
      //                 style: TextStyle(
      //                   color: ColorRes.primary,
      //                   fontSize: AppFontSizes.bodySmall,
      //                   fontWeight: AppFontWeights.semiBold,
      //                 ),
      //               ),
      //             ),
      //           ),
      //
      //           // Sort Button
      //           Container(
      //             height: 35,
      //             margin: EdgeInsets.only(right: 12),
      //             padding: EdgeInsets.symmetric(horizontal: 16),
      //             decoration: BoxDecoration(
      //               color: ColorRes.leadGreyColor[100],
      //               borderRadius: BorderRadius.circular(12),
      //               border: Border.all(
      //                 color: ColorRes.leadGreyColor[300]!,
      //                 width: 1,
      //               ),
      //             ),
      //             child: PopupMenuButton<SortOption>(
      //               icon: Text(
      //                 'Sort',
      //                 style: TextStyle(
      //                   color: ColorRes.leadGreyColor[700],
      //                   fontSize: AppFontSizes.bodySmall,
      //                   fontWeight: AppFontWeights.semiBold,
      //                 ),
      //               ),
      //               onSelected: controller.updateSortOption,
      //               offset: Offset(0, 40),
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(16),
      //                 side: BorderSide(
      //                   color: ColorRes.leadGreyColor.shade300,
      //                   width: 0.7,
      //                 ),
      //               ),
      //               elevation: 8,
      //               itemBuilder:
      //                   (context) => [
      //                     _buildSortMenuItem(
      //                       Icons.sort_by_alpha_rounded,
      //                       'Name',
      //                       SortOption.name,
      //                       ColorRes.primary,
      //                     ),
      //                     _buildSortMenuItem(
      //                       Icons.arrow_upward_rounded,
      //                       'Price: Low to High',
      //                       SortOption.priceAsc,
      //                       ColorRes.green,
      //                     ),
      //                     _buildSortMenuItem(
      //                       Icons.arrow_downward_rounded,
      //                       'Price: High to Low',
      //                       SortOption.priceDesc,
      //                       ColorRes.error,
      //                     ),
      //                     _buildSortMenuItem(
      //                       Icons.star_rounded,
      //                       'Rating',
      //                       SortOption.rating,
      //                       ColorRes.homeAmber,
      //                     ),
      //                   ],
      //             ),
      //           ),
      //
      //           // Share Multiple Button
      //           IconButton(
      //             onPressed: toggleSelectionMode,
      //             icon: Icon(Icons.share_outlined),
      //             color: ColorRes.primary,
      //             iconSize: 22,
      //           ),
      //         ],
      //       );
      //     }),
      //   ],
      // ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(
          () => AppBar(
            backgroundColor: ColorRes.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            leading:
                isSelectionMode.value
                    ? IconButton(
                      icon: Icon(Icons.close, color: ColorRes.textColor),
                      onPressed: toggleSelectionMode,
                    )
                    : null,
            title: Text(
              isSelectionMode.value
                  ? '${selectedPropertyIds.length} Selected'
                  : 'Property Listing',
              style: TextStyle(
                color: ColorRes.textColor,
                fontWeight: AppFontWeights.bold,
                fontSize: getResponsiveFontSize(
                  context,
                  AppFontSizes.large,
                  AppFontSizes.body,
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: ColorRes.leadGreyColor[200], height: 1),
            ),
            actions: [
              if (isSelectionMode.value) ...[
                TextButton(
                  onPressed: () {
                    if (selectedPropertyIds.length ==
                        propertyController.items.length) {
                      selectedPropertyIds.clear();
                    } else {
                      selectedPropertyIds
                        ..clear()
                        ..addAll(
                          propertyController.items
                              .where((p) => p.id != null)
                              .map((p) => p.id!),
                        );
                    }
                  },
                  child: Text(
                    selectedPropertyIds.length ==
                            propertyController.items.length
                        ? 'Deselect All'
                        : 'Select All',
                    style: TextStyle(
                      color: ColorRes.primary,
                      fontSize: AppFontSizes.small,
                      fontWeight: AppFontWeights.semiBold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ] else ...[
                // Filter + Sort + Share buttons
                // _buildFilterButton(context),
                // _buildSortButton(context),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: ColorRes.transparentColor,
                      builder: (_) => FilterPanel(),
                    );
                  },
                  child: Container(
                    height: 35,
                    margin: EdgeInsets.only(right: 8),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: ColorRes.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColorRes.primary.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      'Filter',
                      style: TextStyle(
                        color: ColorRes.primary,
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                  ),
                ),

                // Sort Button
                Container(
                  height: 35,
                  margin: EdgeInsets.only(right: 12),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: ColorRes.leadGreyColor[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ColorRes.leadGreyColor[300]!,
                      width: 1,
                    ),
                  ),
                  child: PopupMenuButton<SortOption>(
                    icon: Text(
                      'Sort',
                      style: TextStyle(
                        color: ColorRes.leadGreyColor[700],
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                    onSelected: controller.updateSortOption,
                    offset: Offset(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: ColorRes.leadGreyColor.shade300,
                        width: 0.7,
                      ),
                    ),
                    elevation: 8,
                    itemBuilder:
                        (context) => [
                          _buildSortMenuItem(
                            Icons.sort_by_alpha_rounded,
                            'Name',
                            SortOption.name,
                            ColorRes.primary,
                          ),
                          _buildSortMenuItem(
                            Icons.arrow_upward_rounded,
                            'Price: Low to High',
                            SortOption.priceAsc,
                            ColorRes.green,
                          ),
                          _buildSortMenuItem(
                            Icons.arrow_downward_rounded,
                            'Price: High to Low',
                            SortOption.priceDesc,
                            ColorRes.error,
                          ),
                          _buildSortMenuItem(
                            Icons.star_rounded,
                            'Rating',
                            SortOption.rating,
                            ColorRes.homeAmber,
                          ),
                        ],
                  ),
                ),
                IconButton(
                  onPressed: toggleSelectionMode,
                  icon: const Icon(Icons.share_outlined),
                  color: ColorRes.primary,
                  iconSize: 22,
                ),
              ],
            ],
          ),
        ),
      ),

      body: Column(
        children: [
          // Enhanced Search Bar
          Container(
            color: ColorRes.white,
            padding: EdgeInsets.fromLTRB(
              getResponsivePadding(context),
              12,
              getResponsivePadding(context),
              12,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: ColorRes.leadGreyColor[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: ColorRes.leadGreyColor.shade200,
                  width: 1.5,
                ),
              ),
              child: TextField(
                onChanged: controller.updateSearch,
                style: TextStyle(fontSize: AppFontSizes.medium),
                decoration: InputDecoration(
                  hintText: 'Search properties by name or location...',
                  hintStyle: TextStyle(
                    fontSize: AppFontSizes.medium,
                    color: ColorRes.leadGreyColor[400],
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: ColorRes.leadGreyColor[400],
                  ),
                  suffixIcon: Obx(
                    () =>
                        controller.searchQuery.value.isNotEmpty
                            ? IconButton(
                              icon: Icon(
                                Icons.clear_rounded,
                                color: ColorRes.leadGreyColor[400],
                              ),
                              onPressed: () => controller.updateSearch(''),
                            )
                            : SizedBox.shrink(),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),

          // Active Filters Display
          Obx(() {
            bool hasPriceFilter =
                controller.filterMinPrice.value > controller.minPrice.value ||
                controller.filterMaxPrice.value < controller.maxPrice.value;

            bool hasCategoryFilter =
                controller.selectedProductCategories.isNotEmpty;

            bool hasActiveFilters = hasCategoryFilter || hasPriceFilter;

            return hasActiveFilters
                ? Container(
                  color: ColorRes.white,
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
                          TextButton.icon(
                            onPressed: () {
                              controller.clearFilters();
                              controller.selectedProductCategories.addAll([]);
                            },
                            label: Text(
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
                      SizedBox(
                        height: 36,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            // Category filters
                            ...controller.selectedProductCategories.map((
                              category,
                            ) {
                              return Container(
                                margin: EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: ColorRes.primary.withOpacity(0.1),
                                  border: Border.all(
                                    color: ColorRes.primary.withOpacity(0.3),
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
                                      Text(
                                        category,
                                        style: TextStyle(
                                          fontSize: AppFontSizes.small,
                                          color: ColorRes.primary,
                                          fontWeight: AppFontWeights.semiBold,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      InkWell(
                                        onTap: () {
                                          controller.selectedProductCategories
                                              .remove(category);
                                          controller.applyFilters();
                                        },
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          child: Icon(
                                            Icons.close,
                                            size: 14,
                                            color: ColorRes.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),

                            // Price filter
                            if (hasPriceFilter)
                              Container(
                                margin: EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: ColorRes.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: ColorRes.primary.withOpacity(0.3),
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
                                      Text(
                                        '${Formatter.formatPrice(controller.filterMinPrice.value)} - ${Formatter.formatPrice(controller.filterMaxPrice.value)}',
                                        style: TextStyle(
                                          fontSize: AppFontSizes.small,
                                          color: ColorRes.primary,
                                          fontWeight: AppFontWeights.semiBold,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      InkWell(
                                        onTap: () {
                                          controller.updatePriceRange(
                                            controller.minPrice.value,
                                            controller.maxPrice.value,
                                          );
                                          controller.applyFilters();
                                        },
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          child: Icon(
                                            Icons.close,
                                            size: 14,
                                            color: ColorRes.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                : SizedBox.shrink();
          }),

          // Products Grid
          Expanded(
            child: Obx(() {
              if (propertyController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: ColorRes.primary),
                );
              }

              if (!propertyController.isLoading.value &&
                  propertyController.items.isEmpty) {
                return Center(child: Text("No Listing Yet."));
              }

              return NotificationListener<ScrollEndNotification>(
                onNotification: (scrollEnd) {
                  final metrics = scrollEnd.metrics;
                  if (metrics.atEdge && metrics.pixels != 0) {
                    propertyController.loadMore();
                  }
                  return false;
                },
                child: RefreshIndicator(
                  onRefresh: propertyController.refreshList,
                  child: ProductsGrid(
                    isSelectionMode: isSelectionMode,
                    selectedPropertyIds: selectedPropertyIds,
                    onPropertyTap: togglePropertySelection,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      // Floating Action Button for Share (when in selection mode)
      floatingActionButton: Obx(
        () =>
            isSelectionMode.value && selectedPropertyIds.isNotEmpty
                ? FloatingActionButton.extended(
                  onPressed: shareSelectedProperties,
                  backgroundColor: ColorRes.primary,
                  icon: Icon(Icons.share, color: ColorRes.white),
                  label: Text(
                    'Share (${selectedPropertyIds.length})',
                    style: TextStyle(
                      color: ColorRes.white,
                      fontWeight: AppFontWeights.semiBold,
                    ),
                  ),
                )
                : SizedBox.shrink(),
      ),
    );
  }

  PopupMenuItem<SortOption> _buildSortMenuItem(
    IconData icon,
    String text,
    SortOption value,
    Color color,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              border: Border.all(width: 1, color: color.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: color),
          ),
          SizedBox(width: 12),
          Text(text, style: TextStyle(fontSize: AppFontSizes.caption)),
        ],
      ),
    );
  }
}

// Update FilterPanel (no changes needed, keeping for completeness)
class FilterPanel extends StatefulWidget {
  @override
  _FilterPanelState createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  final DashboardController controller = Get.find();
  late RxList<String> tempSelectedCategories;
  late double tempMinPrice;
  late double tempMaxPrice;

  @override
  void initState() {
    super.initState();
    tempSelectedCategories =
        <String>[...controller.selectedProductCategories].obs;
    tempMinPrice = controller.filterMinPrice.value;
    tempMaxPrice = controller.filterMaxPrice.value;

    if (tempMinPrice < controller.minPrice.value ||
        tempMaxPrice > controller.maxPrice.value ||
        tempMinPrice > tempMaxPrice) {
      tempMinPrice = controller.minPrice.value;
      tempMaxPrice = controller.maxPrice.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: ColorRes.leadGreyColor[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: AppFontSizes.body,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          tempSelectedCategories.clear();
                          tempMinPrice = controller.minPrice.value;
                          tempMaxPrice = controller.maxPrice.value;
                        });
                        controller.clearFilters();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Clear All',
                        style: TextStyle(
                          fontWeight: AppFontWeights.medium,
                          fontSize: AppFontSizes.small,
                          color: ColorRes.error[400],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ColorRes.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.category_outlined,
                        size: 18,
                        color: ColorRes.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Property Type',
                      style: TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Obx(
                  () => Wrap(
                    spacing: 8,
                    runSpacing: -4,
                    children:
                        controller.categories.where((cat) => cat != 'All').map((
                          category,
                        ) {
                          bool isSelected = tempSelectedCategories.contains(
                            category,
                          );
                          return FilterChip(
                            label: Text(
                              category,
                              style: TextStyle(fontSize: AppFontSizes.caption),
                            ),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() {
                                if (isSelected) {
                                  tempSelectedCategories.remove(category);
                                } else {
                                  tempSelectedCategories.add(category);
                                }
                              });
                            },
                            backgroundColor: Colors.grey[100],
                            checkmarkColor: ColorRes.primary,
                            selectedColor: ColorRes.primary.withOpacity(0.15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color:
                                    isSelected
                                        ? ColorRes.primary
                                        : ColorRes.leadGreyColor[300]!,
                                width: 1,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color:
                                  isSelected
                                      ? ColorRes.primary
                                      : ColorRes.blackShade87,
                              fontWeight:
                                  isSelected
                                      ? AppFontWeights.semiBold
                                      : AppFontWeights.regular,
                              fontSize: AppFontSizes.small,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          );
                        }).toList(),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ColorRes.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.attach_money,
                        size: 18,
                        color: ColorRes.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Price Range',
                      style: TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Obx(() {
                  final minVal = controller.minPrice.value;
                  final maxVal = controller.maxPrice.value;

                  if (tempMinPrice < minVal) tempMinPrice = minVal;
                  if (tempMaxPrice > maxVal) tempMaxPrice = maxVal;
                  if (tempMinPrice > tempMaxPrice) tempMinPrice = minVal;

                  return SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: ColorRes.primary,
                      inactiveTrackColor: ColorRes.leadGreyColor[200],
                      thumbColor: ColorRes.primary,
                      overlayColor: ColorRes.primary.withOpacity(0.2),
                      rangeThumbShape: RoundRangeSliderThumbShape(
                        enabledThumbRadius: 10,
                        elevation: 3,
                      ),
                      rangeTrackShape: RoundedRectRangeSliderTrackShape(),
                    ),
                    child: RangeSlider(
                      values: RangeValues(tempMinPrice, tempMaxPrice),
                      min: minVal,
                      max: maxVal,
                      divisions: 20,
                      labels: RangeLabels(
                        '${Formatter.formatPrice(tempMinPrice)}',
                        '${Formatter.formatPrice(tempMaxPrice)}',
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          tempMinPrice = values.start;
                          tempMaxPrice = values.end;
                        });
                      },
                    ),
                  );
                }),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: ColorRes.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: ColorRes.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        '${Formatter.formatPrice(tempMinPrice)}',
                        style: TextStyle(
                          color: ColorRes.primary,
                          fontSize: AppFontSizes.bodySmall,
                          fontWeight: AppFontWeights.semiBold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: ColorRes.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: ColorRes.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        '${Formatter.formatPrice(tempMaxPrice)}',
                        style: TextStyle(
                          color: ColorRes.primary,
                          fontSize: AppFontSizes.bodySmall,
                          fontWeight: AppFontWeights.semiBold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorRes.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        controller.selectedProductCategories.clear();
                        controller.selectedProductCategories.addAll(
                          tempSelectedCategories,
                        );
                        controller.updatePriceRange(tempMinPrice, tempMaxPrice);
                        controller.applyFilters();
                        Navigator.pop(context);
                      },
                      child: Obx(
                        () => Text(
                          'Apply Filters (${tempSelectedCategories.length})',
                          style: TextStyle(
                            fontSize: AppFontSizes.bodyMedium,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Updated ProductsGrid with selection support
class ProductsGrid extends StatelessWidget {
  final RxBool isSelectionMode;
  final RxList<String> selectedPropertyIds;
  final Function(String) onPropertyTap;

  final DashboardController controller = Get.find();
  final PropertyController propertyController = Get.find(tag: reseller);

  ProductsGrid({
    Key? key,
    required this.isSelectionMode,
    required this.selectedPropertyIds,
    required this.onPropertyTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final displayProducts = propertyController.items.value;

      if (displayProducts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: ColorRes.leadGreyColor[400],
              ),
              SizedBox(height: 16),
              Text(
                'No properties found',
                style: TextStyle(
                  fontSize: AppFontSizes.large,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.leadGreyColor[600],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Try adjusting your filters',
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
                  color: ColorRes.leadGreyColor[500],
                ),
              ),
            ],
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.separated(
          itemCount: displayProducts.length,
          separatorBuilder: (_, __) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            return Obx(
              () => ProductCard(
                product: displayProducts[index],
                isSelectionMode: isSelectionMode,
                isSelected: selectedPropertyIds.contains(
                  displayProducts[index].id ?? '',
                ),
                onSelectionTap: onPropertyTap,
              ),
            );
          },
        ),
      );
    });
  }
}

// Updated ProductCard with selection support
class ProductCard extends StatelessWidget {
  final Items product;
  final RxBool isSelectionMode;
  final bool isSelected;
  final Function(String) onSelectionTap;

  const ProductCard({
    Key? key,
    required this.product,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onSelectionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ReSellerPropertyShareController());
    final propertyShareController = Get.find<ReSellerPropertyShareController>();
    final manager = PropertyNameManager(product);
    final priceManager = PropertyPriceManager(
      listingType: product.listingType ?? 'sale',
      financialInfo: product.propertyDetails?.financialInfo,
    );

    return Obx(() {
      return Material(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(14),
        elevation: isSelected ? 3 : 1,
        shadowColor:
            isSelected
                ? ColorRes.primary.withOpacity(0.3)
                : ColorRes.black.withOpacity(0.06),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (isSelectionMode.value) {
              // Handle selection
              onSelectionTap(product.id ?? '');
            } else {
              // Normal navigation
              Get.to(() => LeadDetailScreen(property: product));
            }
          },
          onLongPress: () {
            // Enable selection mode on long press
            if (!isSelectionMode.value) {
              isSelectionMode.value = true;
              onSelectionTap(product.id ?? '');
            }
          },
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isSelected
                        ? ColorRes.primary
                        : ColorRes.leadGreyColor.shade200,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Image Section with Selection Overlay
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(11),
                      ),
                      child: CustomImage(
                        type: CustomImageType.network,
                        src: product.propertyMedia?.images?.first,
                        width: 110,
                        height: 121,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Selection Checkbox Overlay
                    if (isSelectionMode.value)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color:
                                isSelected ? ColorRes.primary : ColorRes.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  isSelected
                                      ? ColorRes.primary
                                      : ColorRes.leadGreyColor[400]!,
                              width: 2,
                            ),
                          ),
                          child:
                              isSelected
                                  ? Icon(
                                    Icons.check,
                                    size: 16,
                                    color: ColorRes.white,
                                  )
                                  : null,
                        ),
                      ),
                  ],
                ),

                // Content Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Title
                        Row(
                          children: [
                            SizedBox(
                              width: 180,
                              child: Text(
                                '${manager.displayName}',
                                style: TextStyle(
                                  fontSize: AppFontSizes.bodyMedium,
                                  fontWeight: AppFontWeights.semiBold,
                                  color: ColorRes.textColor,
                                  height: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Spacer(),
                            // Only show share icon in normal mode
                            if (!isSelectionMode.value)
                              GestureDetector(
                                onTap: () async {
                                  final user =
                                      await SecureStorage.getUserData();
                                  final resellerId = user?.user?.id ?? '';
                                  final propertyId = product.id ?? '';

                                  if (resellerId.isEmpty ||
                                      propertyId.isEmpty) {
                                    Get.snackbar(
                                      "Error",
                                      "Missing reseller or property information.",
                                    );
                                    return;
                                  }

                                  await propertyShareController
                                      .handleShareButtonTap(
                                        propertyId: propertyId,
                                        resellerId: resellerId,
                                      );
                                },
                                child: const Icon(Icons.share, size: 16),
                              ),
                          ],
                        ),

                        Spacer(),

                        // Address with icon
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                product.address ?? 'No address provided',
                                style: TextStyle(
                                  fontSize: AppFontSizes.caption,
                                  color: ColorRes.leadGreyColor[600],
                                  height: 1.3,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        Spacer(),

                        Facilities(property: product),
                        Spacer(),

                        // Price and Visit Button Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                '${priceManager.displayPrice}',
                                style: TextStyle(
                                  fontSize: AppFontSizes.body,
                                  fontWeight: AppFontWeights.bold,
                                  color: ColorRes.textColor,
                                  height: 1,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8),
                            if (!isSelectionMode.value)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorRes.primary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Visit',
                                  style: TextStyle(
                                    fontWeight: AppFontWeights.semiBold,
                                    fontSize: AppFontSizes.small,
                                    color: ColorRes.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
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
              _buildChip(item.value, 13, icon: item.icon),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildChip(String text, double size, {IconData? icon}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null)
          Icon(icon, size: size, color: const Color(0xFF2563EB)),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: AppFontSizes.caption,
            fontWeight: AppFontWeights.medium,
            color: ColorRes.blackShade54,
          ),
        ),
      ],
    );
  }
}

class ErrorWidgetCustom extends StatelessWidget {
  final VoidCallback? onPressed;
  final DashboardController controller = Get.find();

  ErrorWidgetCustom({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: ColorRes.error[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: ColorRes.error[400],
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: AppFontSizes.large,
                fontWeight: AppFontWeights.extraBold,
                color: ColorRes.textColor,
              ),
            ),
            SizedBox(height: 8),
            Obx(
              () => Text(
                controller.error.value,
                style: TextStyle(
                  color: ColorRes.leadGreyColor[600],
                  fontSize: AppFontSizes.medium,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onPressed ?? controller.loadProducts,
              icon: Icon(Icons.refresh_rounded),
              label: Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorRes.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final DashboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: ColorRes.leadGreyColor[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.search_off_rounded,
                  size: 64,
                  color: ColorRes.leadGreyColor[400],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'No properties found',
                style: TextStyle(
                  fontSize: AppFontSizes.large,
                  fontWeight: AppFontWeights.extraBold,
                  color: ColorRes.textColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Try adjusting your filters or search terms',
                style: TextStyle(
                  color: ColorRes.leadGreyColor[600],
                  fontSize: AppFontSizes.medium,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () {
                  controller.clearFilters();
                  controller.updateSearch('');
                  controller.selectedProductCategories.clear();
                  controller.selectedProductCategories.addAll([]);
                  controller.updatePriceRange(1600, 4800);
                  controller.applyFilters();
                },
                icon: Icon(Icons.filter_alt_off_rounded),
                label: Text('Clear Filters'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: ColorRes.primary,
                  side: BorderSide(color: ColorRes.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
