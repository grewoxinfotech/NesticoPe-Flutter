// // Models
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/utils/formater/formater.dart';
// import 'package:housing_flutter_app/modules/reseller/controller/dashborad_controller/dashboard_controller.dart';
// import '../../../../app/constants/app_font_sizes.dart';
// import '../../model/dashboard/dashboard_model.dart';
// import '../lead/lead_screen.dart';
//
// // Main Screen
// class ProductListingScreen extends StatelessWidget {
//   final DashboardController controller = Get.put(DashboardController());
//
//   ProductListingScreen({Key? key}) : super(key: key);
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
//                 context, AppFontSizes.large, AppFontSizes.body),
//
//           ),
//         ),
//         automaticallyImplyLeading: false,
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(1),
//           child: Container(
//             color: ColorRes.leadGreyColor[200],
//             height: 1,
//           ),
//         ),
//         actions: [
//           // Filter Button with badge-style design
//           GestureDetector(
//             onTap: () {
//               FocusScope.of(context).unfocus();
//               showModalBottomSheet(
//                 context: context,
//                 isScrollControlled: true,
//                 backgroundColor: ColorRes.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                 ),
//                 builder: (_) => FilterPanel(),
//               );
//             },
//             child: Container(
//               margin: EdgeInsets.only(right: 8),
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               decoration: BoxDecoration(
//                 color: ColorRes.primary.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                   color: ColorRes.primary.withOpacity(0.2),
//                   width: 1,
//                 ),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.tune_rounded,
//                     color: ColorRes.primary,
//                     size: 18,
//                   ),
//                   SizedBox(width: 4),
//                   Text(
//                     'Filter',
//                     style: TextStyle(
//                       color: ColorRes.primary,
//                       fontSize: 13,
//                       fontWeight: AppFontWeights.semiBold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // Sort Button with modern styling
//           Container(
//             margin: EdgeInsets.only(right: 12),
//             decoration: BoxDecoration(
//               color: ColorRes.leadGreyColor[100],
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: PopupMenuButton<SortOption>(
//               icon: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.sort_rounded, color: ColorRes.leadGreyColor[700], size: 18),
//                   SizedBox(width: 4),
//                   Text(
//                     'Sort',
//                     style: TextStyle(
//                       color: ColorRes.leadGreyColor[700],
//                       fontSize: 13,
//                       fontWeight: AppFontWeights.semiBold,
//                     ),
//                   ),
//                   SizedBox(width: 4),
//                 ],
//               ),
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               onSelected: controller.updateSortOption,
//               offset: Offset(0, 48),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               elevation: 8,
//               itemBuilder: (context) => [
//                 _buildSortMenuItem(Icons.sort_by_alpha_rounded, 'Name', SortOption.name, ColorRes.primary),
//                 _buildSortMenuItem(Icons.arrow_upward_rounded, 'Price: Low to High', SortOption.priceAsc, ColorRes.green),
//                 _buildSortMenuItem(Icons.arrow_downward_rounded, 'Price: High to Low', SortOption.priceDesc, ColorRes.error),
//                 _buildSortMenuItem(Icons.star_rounded, 'Rating', SortOption.rating, ColorRes.homeAmber),
//               ],
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Search Bar
//           Container(
//             margin: EdgeInsets.all(getResponsivePadding(context)),
//             padding: EdgeInsets.symmetric(horizontal:getResponsivePadding(context)),
//             decoration: BoxDecoration(
//                 color: ColorRes.white,
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1)
//             ),
//             child: TextField(
//
//     onChanged: controller.updateSearch,
//     style: TextStyle(fontSize: AppFontSizes.medium),
//     decoration: InputDecoration(
//     hintText: 'Search Property...',
//     hintStyle: TextStyle(fontSize: AppFontSizes.medium),
//     prefixIcon: const Icon(Icons.search),
//     border: InputBorder.none,
//     contentPadding: const EdgeInsets.symmetric(vertical: 16),
//     ),)),
//
//           // Products Grid
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return Center(child: CircularProgressIndicator());
//               }
//
//               if (controller.error.value.isNotEmpty) {
//                 return ErrorWidgetCustom();
//               }
//
//               if (controller.filteredProducts.isEmpty) {
//                 return EmptyStateWidget();
//               }
//
//               return ProductsGrid();
//             }),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Helper method for PopupMenuButton
//   PopupMenuItem<SortOption> _buildSortMenuItem(IconData icon, String text, SortOption value,Color color) {
//     return PopupMenuItem(
//       value: value,
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: color),
//           SizedBox(width: 8),
//           Text(text),
//         ],
//       ),
//     );
//   }
// }
//
// // Filter Panel Widget (BottomSheet)
// class FilterPanel extends StatelessWidget {
//   final DashboardController controller = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Filters',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: AppFontWeights.semiBold,
//                     color: ColorRes.textColor
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: controller.clearFilters,
//                   child: Text('Clear All',style: TextStyle(fontSize: 12,color: ColorRes.primary),),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//
//             // Category Filter
//             Text(
//               'Category',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: AppFontWeights.semiBold,
//                 color: ColorRes.textColor
//               ),
//             ),
//             SizedBox(height: 8),
//             Obx(() => Wrap(
//               spacing: 8,
//               children: controller.categories.map((category) {
//                 bool isSelected = controller.selectedCategory.value == category;
//                 return FilterChip(
//                   label: Text(category, style: TextStyle(
//                     fontSize: AppFontSizes.caption
//                   ),),
//                   // labelStyle: TextStyle(fontSize: 12,color:(isSelected)?ColorRes.white: ColorRes.textColor),
//                   selected: isSelected,
//
//                   onSelected: (_) => controller.updateCategory(category),
//                   backgroundColor: ColorRes.white,
//                   checkmarkColor:isSelected ? ColorRes.white : Colors
//                       .grey[700] ,
//                   selectedColor: ColorRes.primary,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(color: ColorRes.grey.withOpacity(0.3,),width: 1)),
//                   labelStyle: TextStyle(
//                     color: isSelected ? ColorRes.white : Colors
//                         .grey[700],
//                     fontWeight: isSelected
//                         ? AppFontWeights.semiBold
//                         : AppFontWeights.regular,
//                   ),
//
//                 );
//               }).toList(),
//             )),
//             SizedBox(height: 24),
//
//             // Price Range Filter
//             Text(
//               'Price Range',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: AppFontWeights.semiBold,
//                 color: ColorRes.textColor
//               ),
//             ),
//             SizedBox(height: 8),
//             Obx(() => RangeSlider(
//               values: RangeValues(
//                 controller.filterMinPrice.value,
//                 controller.filterMaxPrice.value,
//               ),
//               min: controller.minPrice.value,
//               max: controller.maxPrice.value,
//               divisions: 20,
//               labels: RangeLabels(
//                 '${Formatter.formatPrice(controller.filterMinPrice.value)}',
//                 '${Formatter.formatPrice(controller.filterMaxPrice.value)}',
//               ),
//               onChanged: (RangeValues values) {
//                 controller.updatePriceRange(values.start, values.end);
//               },
//             )),
//             Obx(() => Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('${Formatter.formatPrice(controller.filterMinPrice.value)}',style: TextStyle(color: ColorRes.textColor,fontSize: 12),),
//                 Text('${Formatter.formatPrice(controller.filterMaxPrice.value)}',style: TextStyle(color: ColorRes.textColor,fontSize: 12)),
//               ],
//             )),
//             SizedBox(height: 10,),
//             SafeArea(
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(ColorRes.primary)),
//                   onPressed: () {
//                     controller.applyFilters(); // Call method to apply filters
//                     Navigator.pop(context);     // Close BottomSheet
//                   },
//                   child: Text('Apply Filters'),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // Products Grid Widget
// class ProductsGrid extends StatelessWidget {
//   final DashboardController controller = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     final query = controller.searchQuery.value.toLowerCase();
//     final filteredData = controller.filteredProducts
//         .where((e) => e.name.toLowerCase().contains(query))
//         .toList();
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       child: ListView.separated(
//         itemCount: filteredData.length,
//         separatorBuilder: (_, __) => SizedBox(height: 16),
//         itemBuilder: (context, index) {
//
//           return ProductCard(product:filteredData[index]);
//         },
//       ),
//     );
//   }
// }
//
// // Product Card Widget
// class ProductCard extends StatelessWidget {
//   final Product product;
//
//   const ProductCard({Key? key, required this.product}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(14),
//       onTap: () {
//         Get.snackbar(
//           'Property Selected',
//           product.name,
//           snackPosition: SnackPosition.BOTTOM,
//           duration: Duration(seconds: 2),
//
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: ColorRes.white,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: ColorRes.grey.withOpacity(0.2), width: 1),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image
//             ClipRRect(
//               borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
//               child: Image.network(
//                 product.image,
//                 width: 120,
//                 height: 122,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             // Info
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SizedBox(
//                           width: 150,
//                           child: Text(
//                             '${product.name}',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: AppFontWeights.semiBold,
//                               color: ColorRes.textColor,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         Icon(Icons.favorite_border, color: ColorRes.leadGreyColor[600],size: 20,),
//                       ],
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       product.category,
//                       style: TextStyle(
//                         fontSize: 10,
//                         color: ColorRes.textDisabled,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: 8),
//
//                     // Feature Row
//                     Row(
//                       children: [
//                         Icon(Icons.bed_outlined, size: 16, color: ColorRes.primary),
//                         SizedBox(width: 4),
//                         Text('${product.beds}', style: TextStyle(fontSize: 12)),
//                         SizedBox(width: 12),
//                         Icon(Icons.square_foot, size: 16, color: ColorRes.primary),
//                         SizedBox(width: 4),
//                         Text('${product.area} m²', style: TextStyle(fontSize: 12)),
//                         SizedBox(width: 12),
//                         Icon(Icons.garage_outlined, size: 16, color: ColorRes.primary),
//                         SizedBox(width: 4),
//                         Text('${product.garage}', style: TextStyle(fontSize: 12)),
//                       ],
//                     ),
//                     SizedBox(height: 8),
//
//                     // Price & Favorite
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           '${Formatter.formatPrice(product.price)}',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: AppFontWeights.semiBold,
//                             color: ColorRes.primary,
//                           ),
//                         ),
//
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
//                           decoration: BoxDecoration(
//                             color: ColorRes.primary,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Text('Visit',style: TextStyle(
//                             fontWeight: AppFontWeights.semiBold,
//                             fontSize: 10,
//                             color: ColorRes.white
//                           ),),
//                         )
//
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // Error Widget
// class ErrorWidgetCustom extends StatelessWidget {
//   final DashboardController controller = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.error_outline, size: 64, color: ColorRes.error[300]),
//           SizedBox(height: 16),
//           Text(
//             'Something went wrong',
//             style: TextStyle(fontSize: 18, fontWeight: AppFontWeights.semiBold),
//           ),
//           SizedBox(height: 8),
//           Obx(() => Text(
//             controller.error.value,
//             style: TextStyle(color: ColorRes.leadGreyColor[600]),
//           )),
//           SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: controller.loadProducts,
//             child: Text('Try Again'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // Empty State Widget
// class EmptyStateWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.search_off, size: 64, color: ColorRes.leadGreyColor[400]),
//             SizedBox(height: 16),
//             Text(
//               'No products found',
//               style: TextStyle(fontSize: 18, fontWeight: AppFontWeights.semiBold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Try adjusting your filters or search terms',
//               style: TextStyle(color: ColorRes.leadGreyColor[600]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
// //
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:housing_flutter_app/app/constants/color_res.dart';
// // import 'package:housing_flutter_app/app/utils/formater/formater.dart';
// // import 'package:housing_flutter_app/modules/reseller/controller/dashborad_controller/dashboard_controller.dart';
// // import '../../../../app/constants/app_font_sizes.dart';
// // import '../../model/dashboard/dashboard_model.dart';
// //
// // // Main Screen
// // class ProductListingScreen extends StatelessWidget {
// //   final DashboardController controller = Get.put(DashboardController());
// //
// //   ProductListingScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: ColorRes.white,
// //       appBar: AppBar(
// //         backgroundColor: ColorRes.white,
// //         elevation: 0,
// //         title: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Property Listing',
// //               style: TextStyle(
// //                 color: ColorRes.textColor,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),    ],
// //         ),
// //         automaticallyImplyLeading: false,
// //         actions: [
// //           // Filter Button with Badge
// //           Stack(
// //             alignment: Alignment.center,
// //             children: [
// //               Material(
// //                 color: ColorRes.transparentColor,
// //                 child: InkWell(
// //                   onTap: () {
// //                     FocusScope.of(context).unfocus();
// //                     showModalBottomSheet(
// //                       context: context,
// //                       isScrollControlled: true,
// //                       backgroundColor: ColorRes.transparentColor,
// //                       builder: (_) => FilterPanel(),
// //                     );
// //                   },
// //                   borderRadius: BorderRadius.circular(20),
// //                   child: Container(
// //                     padding: EdgeInsets.all(10),
// //                     child: Icon(Icons.tune_rounded, color: ColorRes.primary, size: 22),
// //                   ),
// //                 ),
// //               ),
// //               // Active filters indicator
// //               Obx(() {
// //                 int activeFilters = 0;
// //                 if (controller.selectedCategory.value.isNotEmpty) activeFilters++;
// //                 if (controller.filterMinPrice.value > controller.minPrice.value ||
// //                     controller.filterMaxPrice.value < controller.maxPrice.value) {
// //                   activeFilters++;
// //                 }
// //                 return activeFilters > 0
// //                     ? Positioned(
// //                   right: 8,
// //                   top: 8,
// //                   child: Container(
// //                     padding: EdgeInsets.all(4),
// //                     decoration: BoxDecoration(
// //                       color: ColorRes.primary,
// //                       shape: BoxShape.circle,
// //                     ),
// //                     child: Text(
// //                       '$activeFilters',
// //                       style: TextStyle(
// //                         color: ColorRes.white,
// //                         fontSize: 10,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                   ),
// //                 )
// //                     : SizedBox.shrink();
// //               }),
// //             ],
// //           ),
// //
// //           // Sort Menu with improved design
// //           Material(
// //             color: ColorRes.transparentColor,
// //             child: PopupMenuButton<SortOption>(
// //               icon: Container(
// //                 padding: EdgeInsets.all(10),
// //                 child: Icon(Icons.swap_vert_rounded, color: ColorRes.primary, size: 22),
// //               ),
// //               onSelected: controller.updateSortOption,
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(16),
// //               ),
// //               elevation: 8,
// //               itemBuilder: (context) => [
// //                 _buildSortMenuItem(Icons.sort_by_alpha_rounded, 'Name', SortOption.name),
// //                 _buildSortMenuItem(Icons.arrow_upward_rounded, 'Price: Low to High', SortOption.priceAsc),
// //                 _buildSortMenuItem(Icons.arrow_downward_rounded, 'Price: High to Low', SortOption.priceDesc),
// //                 _buildSortMenuItem(Icons.star_rounded, 'Rating', SortOption.rating),
// //               ],
// //             ),
// //           ),
// //           SizedBox(width: 8),
// //         ],
// //       ),
// //       body: Column(
// //         children: [
// //           // Enhanced Search Bar with shadow
// //           Container(
// //             color: ColorRes.white,
// //             padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
// //             child: Container(
// //               decoration: BoxDecoration(
// //               ),
// //               child: TextField(
// //                 onChanged: controller.updateSearch,
// //                 decoration: InputDecoration(
// //                   hintText: 'Search by name, location, or type...',
// //                   hintStyle: TextStyle(color: ColorRes.leadGreyColor[400]),
// //                   prefixIcon: Icon(Icons.search_rounded, color: ColorRes.leadGreyColor[500]),
// //                   suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
// //                       ? IconButton(
// //                     icon: Icon(Icons.clear_rounded, color: ColorRes.leadGreyColor[500], size: 20),
// //                     onPressed: () => controller.updateSearch(''),
// //                   )
// //                       : SizedBox.shrink()),
// //                   border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(12),
// //                       borderSide: BorderSide(width: 1,color: ColorRes.grey.withOpacity(0.3))
// //                   ),
// //                   focusedBorder:OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(12),
// //                       borderSide: BorderSide(width: 1,color: ColorRes.primary)
// //                   ),
// //                   disabledBorder: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(12),
// //                       borderSide: BorderSide(width: 1,color: ColorRes.grey.withOpacity(0.3))
// //                   ),
// //                   enabledBorder: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(12),
// //                       borderSide: BorderSide(width: 1,color: ColorRes.grey.withOpacity(0.3))
// //                   ),
// //                   filled: true,
// //                   fillColor: ColorRes.white,
// //                   contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
// //                 ),
// //               ),
// //             ),
// //           ),
// //
// //           // Active Filters Display
// //           Obx(() {
// //             bool hasActiveFilters = (controller.selectedCategory.value.isNotEmpty &&
// //                 controller.selectedCategory.value != 'All') ||
// //                 controller.filterMinPrice.value > controller.minPrice.value ||
// //                 controller.filterMaxPrice.value < controller.maxPrice.value;
// //
// //             return hasActiveFilters
// //                 ? Container(
// //               height: 40,
// //               margin: EdgeInsets.symmetric(vertical: 8),
// //               child: ListView(
// //                 scrollDirection: Axis.horizontal,
// //                 padding: EdgeInsets.symmetric(horizontal: 16),
// //                 children: [
// //                   if (controller.selectedCategory.value.isNotEmpty &&
// //                       controller.selectedCategory.value != 'All')
// //                     _buildActiveFilterChip(
// //                       controller.selectedCategory.value,
// //                           () => controller.updateCategory(''),
// //                     ),
// //                   if (controller.filterMinPrice.value > controller.minPrice.value ||
// //                       controller.filterMaxPrice.value < controller.maxPrice.value)
// //                     _buildActiveFilterChip(
// //                       '${Formatter.formatPrice(controller.filterMinPrice.value)} - ${Formatter.formatPrice(controller.filterMaxPrice.value)}',
// //                           () => controller.updatePriceRange(
// //                         controller.minPrice.value,
// //                         controller.maxPrice.value,
// //                       ),
// //                     ),
// //                 ],
// //               ),
// //             )
// //                 : SizedBox.shrink();
// //           }),
// //
// //
// //           // Products Grid
// //           Expanded(
// //             child: Obx(() {
// //               if (controller.isLoading.value) {
// //                 return ShimmerLoadingGrid();
// //               }
// //
// //               if (controller.error.value.isNotEmpty) {
// //                 return ErrorWidgetCustom();
// //               }
// //
// //               if (controller.filteredProducts.isEmpty) {
// //                 return EmptyStateWidget();
// //               }
// //
// //               return ProductsGrid();
// //             }),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildActiveFilterChip(String label, VoidCallback onRemove) {
// //     return Container(
// //       margin: EdgeInsets.only(right: 8),
// //       child: Chip(
// //         label: Text(
// //           label,
// //           style: TextStyle(fontSize: 12, color: ColorRes.primary),
// //         ),
// //         deleteIcon: Icon(Icons.close_rounded, size: 16),
// //         onDeleted: onRemove,
// //         backgroundColor: ColorRes.primary.withOpacity(0.1),
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(20),
// //           side: BorderSide(color: ColorRes.primary.withOpacity(0.3)),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   PopupMenuItem<SortOption> _buildSortMenuItem(IconData icon, String text, SortOption value) {
// //     return PopupMenuItem(
// //       value: value,
// //       child: Container(
// //         padding: EdgeInsets.symmetric(vertical: 4),
// //         child: Row(
// //           children: [
// //             Container(
// //               padding: EdgeInsets.all(8),
// //               decoration: BoxDecoration(
// //                 color: ColorRes.primary.withOpacity(0.1),
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //               child: Icon(icon, size: 18, color: ColorRes.primary),
// //             ),
// //             SizedBox(width: 12),
// //             Text(text),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // // Enhanced Filter Panel
// // class FilterPanel extends StatelessWidget {
// //   final DashboardController controller = Get.find();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: ColorRes.white,
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
// //       ),
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           // Handle bar
// //           Container(
// //             margin: EdgeInsets.only(top: 12),
// //             width: 40,
// //             height: 4,
// //             decoration: BoxDecoration(
// //               color: ColorRes.leadGreyColor[300],
// //               borderRadius: BorderRadius.circular(2),
// //             ),
// //           ),
// //           Padding(
// //             padding: EdgeInsets.all(20),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 // Header
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Row(
// //                       children: [
// //                         Container(
// //                           padding: EdgeInsets.all(8),
// //                           decoration: BoxDecoration(
// //                             color: ColorRes.primary.withOpacity(0.1),
// //                             borderRadius: BorderRadius.circular(10),
// //                           ),
// //                           child: Icon(Icons.tune_rounded, color: ColorRes.primary, size: 20),
// //                         ),
// //                         SizedBox(width: 12),
// //                         Text(
// //                           'Filters',
// //                           style: TextStyle(
// //                             fontSize: 18,
// //                             fontWeight: FontWeight.bold,
// //                             color: ColorRes.textColor,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     TextButton.icon(
// //                       onPressed: controller.clearFilters,
// //                       icon: Icon(Icons.clear_all_rounded, size: 16),
// //                       label: Text('Clear All', style: TextStyle(fontSize: 12)),
// //                       style: TextButton.styleFrom(
// //                         foregroundColor: ColorRes.error[400],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 SizedBox(height: 24),
// //
// //                 // Category Filter
// //                 Container(
// //                   padding: EdgeInsets.all(16),
// //                   decoration: BoxDecoration(
// //                     color: ColorRes.leadGreyColor[50],
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Row(
// //                         children: [
// //                           Icon(Icons.category_rounded, size: 18, color: ColorRes.primary),
// //                           SizedBox(width: 8),
// //                           Text(
// //                             'Category',
// //                             style: TextStyle(
// //                               fontSize: 14,
// //                               fontWeight: AppFontWeights.semiBold,
// //                               color: ColorRes.textColor,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       SizedBox(height: 12),
// //                       Obx(() => Wrap(
// //                         spacing: 8,
// //                         runSpacing: 8,
// //                         children: controller.categories.map((category) {
// //                           bool isSelected = controller.selectedCategory.value == category;
// //                           return AnimatedContainer(
// //                             duration: Duration(milliseconds: 200),
// //                             child: FilterChip(
// //                               label: Text(
// //                                 category,
// //                                 style: TextStyle(fontSize: AppFontSizes.caption),
// //                               ),
// //                               selected: isSelected,
// //                               onSelected: (_) => controller.updateCategory(category),
// //                               backgroundColor: ColorRes.white,
// //                               checkmarkColor: isSelected ? ColorRes.white : ColorRes.leadGreyColor[700],
// //                               selectedColor: ColorRes.primary,
// //                               shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(20),
// //                                 side: BorderSide(
// //                                   color: isSelected ? ColorRes.primary : ColorRes.leadGreyColor[300]!,
// //                                 ),
// //                               ),
// //                               labelStyle: TextStyle(
// //                                 color: isSelected ? ColorRes.white : ColorRes.leadGreyColor[700],
// //                                 fontWeight: isSelected
// //                                     ? AppFontWeights.semiBold
// //                                     : AppFontWeights.regular,
// //                               ),
// //                               elevation: isSelected ? 2 : 0,
// //                             ),
// //                           );
// //                         }).toList(),
// //                       )),
// //                     ],
// //                   ),
// //                 ),
// //                 SizedBox(height: 20),
// //
// //                 // Price Range Filter
// //                 Container(
// //                   padding: EdgeInsets.all(16),
// //                   decoration: BoxDecoration(
// //                     color: ColorRes.leadGreyColor[50],
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Row(
// //                         children: [
// //                           Icon(Icons.attach_money_rounded, size: 18, color: ColorRes.primary),
// //                           SizedBox(width: 8),
// //                           Text(
// //                             'Price Range',
// //                             style: TextStyle(
// //                               fontSize: 14,
// //                               fontWeight: AppFontWeights.semiBold,
// //                               color: ColorRes.textColor,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       SizedBox(height: 16),
// //                       Obx(() => SliderTheme(
// //                         data: SliderThemeData(
// //                           rangeThumbShape: RoundRangeSliderThumbShape(
// //                             enabledThumbRadius: 8,
// //                           ),
// //                           overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
// //                         ),
// //                         child: RangeSlider(
// //                           values: RangeValues(
// //                             controller.filterMinPrice.value,
// //                             controller.filterMaxPrice.value,
// //                           ),
// //                           min: controller.minPrice.value,
// //                           max: controller.maxPrice.value,
// //                           divisions: 50,
// //                           activeColor: ColorRes.primary,
// //                           inactiveColor: ColorRes.leadGreyColor[300],
// //                           labels: RangeLabels(
// //                             '${Formatter.formatPrice(controller.filterMinPrice.value)}',
// //                             '${Formatter.formatPrice(controller.filterMaxPrice.value)}',
// //                           ),
// //                           onChanged: (RangeValues values) {
// //                             controller.updatePriceRange(values.start, values.end);
// //                           },
// //                         ),
// //                       )),
// //                       SizedBox(height: 8),
// //                       Obx(() => Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           Container(
// //                             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                             decoration: BoxDecoration(
// //                               color: ColorRes.white,
// //                               borderRadius: BorderRadius.circular(8),
// //                               border: Border.all(color: ColorRes.leadGreyColor[300]!),
// //                             ),
// //                             child: Text(
// //                               '${Formatter.formatPrice(controller.filterMinPrice.value)}',
// //                               style: TextStyle(
// //                                 color: ColorRes.textColor,
// //                                 fontSize: 12,
// //                                 fontWeight: AppFontWeights.medium,
// //                               ),
// //                             ),
// //                           ),
// //                           Icon(Icons.arrow_forward_rounded, size: 16, color: ColorRes.leadGreyColor[400]),
// //                           Container(
// //                             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                             decoration: BoxDecoration(
// //                               color: ColorRes.white,
// //                               borderRadius: BorderRadius.circular(8),
// //                               border: Border.all(color: ColorRes.leadGreyColor[300]!),
// //                             ),
// //                             child: Text(
// //                               '${Formatter.formatPrice(controller.filterMaxPrice.value)}',
// //                               style: TextStyle(
// //                                 color: ColorRes.textColor,
// //                                 fontSize: 12,
// //                                 fontWeight: AppFontWeights.medium,
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       )),
// //                     ],
// //                   ),
// //                 ),
// //                 SizedBox(height: 20),
// //
// //                 // Apply Button
// //                 SafeArea(
// //                   child: SizedBox(
// //                     width: double.infinity,
// //                     height: 48,
// //                     child: ElevatedButton(
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: ColorRes.primary,
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                         elevation: 2,
// //                       ),
// //                       onPressed: () {
// //                         controller.applyFilters();
// //                         Navigator.pop(context);
// //                       },
// //                       child: Row(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           Icon(Icons.check_rounded, size: 20),
// //                           SizedBox(width: 8),
// //                           Text('Apply Filters'),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // // Enhanced Products Grid
// // class ProductsGrid extends StatelessWidget {
// //   final DashboardController controller = Get.find();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return RefreshIndicator(
// //       onRefresh: () async => controller.loadProducts(),
// //       color: ColorRes.primary,
// //       child: ListView.builder(
// //         padding: const EdgeInsets.all(16),
// //         itemCount: controller.filteredProducts.length,
// //         itemBuilder: (context, index) {
// //           return AnimatedContainer(
// //             duration: Duration(milliseconds: 300),
// //             margin: EdgeInsets.only(bottom: 16),
// //             child: ProductCard(product: controller.filteredProducts[index]),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// //
// // // Enhanced Product Card with Modern Design
// // class ProductCard extends StatelessWidget {
// //   final Product product;
// //
// //   const ProductCard({Key? key, required this.product}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Material(
// //       elevation: 4,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(20),
// //       ),
// //       shadowColor: ColorRes.black.withOpacity(0.15),
// //       child: InkWell(
// //         borderRadius: BorderRadius.circular(20),
// //         onTap: () {
// //           Get.snackbar(
// //             'Property Selected',
// //             product.name,
// //             snackPosition: SnackPosition.BOTTOM,
// //             backgroundColor: ColorRes.primary,
// //             colorText: ColorRes.white,
// //             margin: EdgeInsets.all(16),
// //             borderRadius: 12,
// //             icon: Icon(Icons.home_rounded, color: ColorRes.white),
// //             duration: Duration(seconds: 2),
// //           );
// //         },
// //         child: Container(
// //           decoration: BoxDecoration(
// //             color: ColorRes.white,
// //             borderRadius: BorderRadius.circular(20),
// //             border: Border.all(
// //               color: ColorRes.grey.withOpacity(0.15),
// //               width: 1,
// //             ),
// //           ),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               // Image Section with Enhanced Overlay
// //               Stack(
// //                 children: [
// //                   // Main Image with Gradient Overlay
// //                   ClipRRect(
// //                     borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
// //                     child: Stack(
// //                       children: [
// //                         Container(
// //                           height: 200,
// //                           width: double.infinity,
// //                           child: Image.network(
// //                             product.image,
// //                             fit: BoxFit.cover,
// //                             errorBuilder: (context, error, stackTrace) {
// //                               return Container(
// //                                 color: ColorRes.leadGreyColor[200],
// //                                 child: Icon(
// //                                   Icons.broken_image_outlined,
// //                                   size: 50,
// //                                   color: ColorRes.leadGreyColor[400],
// //                                 ),
// //                               );
// //                             },
// //                             loadingBuilder: (context, child, loadingProgress) {
// //                               if (loadingProgress == null) return child;
// //                               return Container(
// //                                 color: ColorRes.leadGreyColor[200],
// //                                 child: Center(
// //                                   child: CircularProgressIndicator(
// //                                     value: loadingProgress.expectedTotalBytes != null
// //                                         ? loadingProgress.cumulativeBytesLoaded /
// //                                         loadingProgress.expectedTotalBytes!
// //                                         : null,
// //                                   ),
// //                                 ),
// //                               );
// //                             },
// //                           ),
// //                         ),
// //                         // Subtle gradient overlay at bottom
// //                         Positioned(
// //                           bottom: 0,
// //                           left: 0,
// //                           right: 0,
// //                           child: Container(
// //                             height: 60,
// //                             decoration: BoxDecoration(
// //                               gradient: LinearGradient(
// //                                 begin: Alignment.topCenter,
// //                                 end: Alignment.bottomCenter,
// //                                 colors: [
// //                                   ColorRes.transparentColor,
// //                                   ColorRes.black.withOpacity(0.3),
// //                                 ],
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //
// //                   // Status Badge with Animation-ready Design
// //                   Positioned(
// //                     top: 16,
// //                     left: 16,
// //                     child: Container(
// //                       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                       decoration: BoxDecoration(
// //                         gradient: LinearGradient(
// //                           colors: [Colors.green[400]!, Colors.green[600]!],
// //                         ),
// //                         borderRadius: BorderRadius.circular(20),
// //                       ),
// //                       child: Text(
// //                         'AVAILABLE',
// //                         style: TextStyle(
// //                           color: ColorRes.white,
// //                           fontSize: 10,
// //                           fontWeight: FontWeight.bold,
// //                           letterSpacing: 0.5,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //
// //                   // Enhanced Favorite Button
// //                   Positioned(
// //                     top: 16,
// //                     right: 16,
// //                     child: Container(
// //                       decoration: BoxDecoration(
// //                         color: ColorRes.white,
// //                         shape: BoxShape.circle,
// //                       ),
// //                       child: Material(
// //                         color: ColorRes.transparentColor,
// //                         child: InkWell(
// //                           onTap: () {},
// //                           borderRadius: BorderRadius.circular(20),
// //                           child: Padding(
// //                             padding: EdgeInsets.all(10),
// //                             child: Icon(
// //                               Icons.favorite_border_rounded,
// //                               color: ColorRes.primary,
// //                               size: 20,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //
// //               // Content Section
// //               Padding(
// //                 padding: const EdgeInsets.all(16),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     // Category Chip with Icon
// //                     Row(
// //                       children: [
// //                         Container(
// //                           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
// //                           decoration: BoxDecoration(
// //                             // gradient: LinearGradient(
// //                             //   colors: [
// //                             //     ColorRes.primary.withOpacity(0.15),
// //                             //     ColorRes.primary.withOpacity(0.08),
// //                             //   ],
// //                             // ),
// //                             color: ColorRes.primary.withOpacity(0.15),
// //                             borderRadius: BorderRadius.circular(8),
// //                           ),
// //                           child: Text(
// //                             product.category.toUpperCase(),
// //                             style: TextStyle(
// //                               fontSize: 9,
// //                               color: ColorRes.primary,
// //                               fontWeight: AppFontWeights.semiBold,
// //                               letterSpacing: 0.5,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     SizedBox(height: 12),
// //
// //                     // Property Name with Better Typography
// //                     Text(
// //                       product.name,
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: AppFontWeights.semiBold,
// //                         color: ColorRes.textColor,
// //                         height: 1.3,
// //                       ),
// //                       maxLines: 2,
// //                       overflow: TextOverflow.ellipsis,
// //                     ),
// //                     SizedBox(height: 16),
// //
// //                     // Enhanced Features Grid
// //                     Container(
// //                       padding: EdgeInsets.all(12),
// //                       decoration: BoxDecoration(
// //                         // gradient: LinearGradient(
// //                         //   begin: Alignment.topLeft,
// //                         //   end: Alignment.bottomRight,
// //                         //   colors: [
// //                         //     ColorRes.leadGreyColor[50]!,
// //                         //     ColorRes.leadGreyColor[100]!,
// //                         //   ],
// //                         // ),
// //                         borderRadius: BorderRadius.circular(12),
// //                         border: Border.all(
// //                           color: ColorRes.leadGreyColor[200]!,
// //                           width: 1,
// //                         ),
// //                       ),
// //                       child: Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceAround,
// //                         children: [
// //                           _buildFeature(Icons.bed_rounded, '${product.beds}', 'Beds'),
// //                           _buildDivider(),
// //                           _buildFeature(Icons.square_foot_rounded, '${product.area}', 'm²'),
// //                           _buildDivider(),
// //                           _buildFeature(Icons.garage_rounded, '${product.garage}', 'Garage'),
// //                         ],
// //                       ),
// //                     ),
// //                     SizedBox(height: 16),
// //
// //                     // Price Section with Enhanced Design
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       crossAxisAlignment: CrossAxisAlignment.center,
// //                       children: [
// //                         Expanded(
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Text(
// //                                 'Starting from',
// //                                 style: TextStyle(
// //                                   fontSize: 10,
// //                                   color: ColorRes.leadGreyColor[600],
// //                                   fontWeight: AppFontWeights.medium,
// //                                 ),
// //                               ),
// //                               SizedBox(height: 4),
// //                               Text(
// //                                 '${Formatter.formatPrice(product.price)}',
// //                                 style: TextStyle(
// //                                   fontSize: 22,
// //                                   fontWeight: FontWeight.bold,
// //                                   color: ColorRes.primary,
// //                                   letterSpacing: -0.5,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //
// //                         // Enhanced CTA Button
// //                         Container(
// //                           decoration: BoxDecoration(
// //
// //                               color: ColorRes.primary,
// //
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                           child: Material(
// //                             color: ColorRes.transparentColor,
// //                             child: InkWell(
// //                               onTap: () {},
// //                               borderRadius: BorderRadius.circular(12),
// //                               child: Padding(
// //                                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
// //                                 child: Text(
// //                                   'View Details',
// //                                   style: TextStyle(
// //                                     fontSize: 13,
// //                                     fontWeight: FontWeight.bold,
// //                                     color: ColorRes.white,
// //                                     letterSpacing: 0.3,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildFeature(IconData icon, String value, String label) {
// //     return Expanded(
// //       child: Column(
// //         children: [
// //           Container(
// //             padding: EdgeInsets.all(8),
// //             decoration: BoxDecoration(
// //               color: ColorRes.primary.withOpacity(0.1),
// //               shape: BoxShape.circle,
// //             ),
// //             child: Icon(
// //               icon,
// //               size: 15,
// //               color: ColorRes.primary,
// //             ),
// //           ),
// //           SizedBox(height: 6),
// //           Text(
// //             value,
// //             style: TextStyle(
// //               fontSize: 12,
// //               color: ColorRes.textColor,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //           SizedBox(height: 2),
// //           Text(
// //             label,
// //             style: TextStyle(
// //               fontSize: 10,
// //               color: ColorRes.leadGreyColor[600],
// //               fontWeight: AppFontWeights.medium,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildDivider() {
// //     return Container(
// //       height: 40,
// //       width: 1,
// //       margin: EdgeInsets.symmetric(horizontal: 4),
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           begin: Alignment.topCenter,
// //           end: Alignment.bottomCenter,
// //           colors: [
// //             ColorRes.transparentColor,
// //             ColorRes.leadGreyColor[300]!,
// //             ColorRes.transparentColor,
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // // Shimmer Loading Effect
// // class ShimmerLoadingGrid extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return ListView.builder(
// //       padding: EdgeInsets.all(16),
// //       itemCount: 3,
// //       itemBuilder: (context, index) {
// //         return Container(
// //           margin: EdgeInsets.only(bottom: 16),
// //           height: 360,
// //           decoration: BoxDecoration(
// //             color: ColorRes.white,
// //             borderRadius: BorderRadius.circular(16),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: ColorRes.black.withOpacity(0.05),
// //                 blurRadius: 10,
// //               ),
// //             ],
// //           ),
// //           child: Column(
// //             children: [
// //               Container(
// //                 height: 180,
// //                 decoration: BoxDecoration(
// //                   color: ColorRes.leadGreyColor[300],
// //                   borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
// //                 ),
// //                 child: Center(
// //                   child: CircularProgressIndicator(
// //                     color: ColorRes.primary,
// //                     strokeWidth: 2,
// //                   ),
// //                 ),
// //               ),
// //               Padding(
// //                 padding: EdgeInsets.all(16),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Container(
// //                       width: 80,
// //                       height: 20,
// //                       decoration: BoxDecoration(
// //                         color: ColorRes.leadGreyColor[300],
// //                         borderRadius: BorderRadius.circular(4),
// //                       ),
// //                     ),
// //                     SizedBox(height: 8),
// //                     Container(
// //                       width: double.infinity,
// //                       height: 16,
// //                       decoration: BoxDecoration(
// //                         color: ColorRes.leadGreyColor[300],
// //                         borderRadius: BorderRadius.circular(4),
// //                       ),
// //                     ),
// //                     SizedBox(height: 12),
// //                     Container(
// //                       width: 120,
// //                       height: 24,
// //                       decoration: BoxDecoration(
// //                         color: ColorRes.leadGreyColor[300],
// //                         borderRadius: BorderRadius.circular(4),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }
// //
// // // Enhanced Error Widget
// // class ErrorWidgetCustom extends StatelessWidget {
// //   final DashboardController controller = Get.find();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Center(
// //       child: Padding(
// //         padding: EdgeInsets.all(32),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Container(
// //               padding: EdgeInsets.all(24),
// //               decoration: BoxDecoration(
// //                 color: ColorRes.error[50],
// //                 shape: BoxShape.circle,
// //               ),
// //               child: Icon(Icons.error_outline_rounded, size: 48, color: ColorRes.error[400]),
// //             ),
// //             SizedBox(height: 24),
// //             Text(
// //               'Oops! Something went wrong',
// //               style: TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.bold,
// //                 color: ColorRes.textColor,
// //               ),
// //             ),
// //             SizedBox(height: 8),
// //             Obx(() => Text(
// //               controller.error.value,
// //               style: TextStyle(
// //                 color: ColorRes.leadGreyColor[600],
// //                 fontSize: 14,
// //               ),
// //               textAlign: TextAlign.center,
// //             )),
// //             SizedBox(height: 32),
// //             ElevatedButton.icon(
// //               onPressed: controller.loadProducts,
// //               icon: Icon(Icons.refresh_rounded),
// //               label: Text('Try Again'),
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: ColorRes.primary,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // // Enhanced Empty State
// // class EmptyStateWidget extends StatelessWidget {
// //   final DashboardController controller = Get.find();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Center(
// //       child: Padding(
// //         padding: EdgeInsets.all(32),
// //         child: SingleChildScrollView(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Container(
// //                 padding: EdgeInsets.all(32),
// //                 decoration: BoxDecoration(
// //                   color: ColorRes.leadGreyColor[100],
// //                   shape: BoxShape.circle,
// //                 ),
// //                 child: Icon(Icons.search_off_rounded, size: 64, color: ColorRes.leadGreyColor[400]),
// //               ),
// //               SizedBox(height: 24),
// //               Text(
// //                 'No properties found',
// //                 style: TextStyle(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.bold,
// //                   color: ColorRes.textColor,
// //                 ),
// //               ),
// //               SizedBox(height: 8),
// //               Text(
// //                 'Try adjusting your filters or search terms',
// //                 style: TextStyle(
// //                   color: ColorRes.leadGreyColor[600],
// //                   fontSize: 14,
// //                 ),
// //                 textAlign: TextAlign.center,
// //               ),
// //               SizedBox(height: 32),
// //               OutlinedButton.icon(
// //                 onPressed: () {
// //                   controller.clearFilters();
// //                   controller.updateSearch('');
// //                 },
// //                 icon: Icon(Icons.filter_alt_off_rounded),
// //                 label: Text('Clear Filters'),
// //                 style: OutlinedButton.styleFrom(
// //                   foregroundColor: ColorRes.primary,
// //                   side: BorderSide(color: ColorRes.primary),
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';
import 'package:housing_flutter_app/modules/reseller/controller/dashborad_controller/dashboard_controller.dart';
import 'package:housing_flutter_app/modules/reseller/model/reseller_lead_model/reseller_lead_overview.dart';
import 'package:housing_flutter_app/modules/seller/module/seller_home_screen/views/property_overview_screen.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/manager/property/property_name_manager.dart';
import '../../../../app/manager/property/property_pricemanager.dart';
import '../../../../app/manager/property_highlight_manager.dart';
import '../../../../data/network/property/models/property_model.dart';
import '../../../seller/view/widget/property_overview_seller.dart';
import '../../model/dashboard/dashboard_model.dart';
import '../lead/lead_screen.dart';
import '../lead_overview/lead_detail.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.leadGreyColor[50],
      appBar: AppBar(
        backgroundColor: ColorRes.white,
        elevation: 0,
        title: Text(
          'Property Listing',
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
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(color: ColorRes.leadGreyColor[200], height: 1),
        ),
        actions: [
          // Filter Button with Active Badge
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
                  fontSize: 13,
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
              border: Border.all(color: ColorRes.leadGreyColor[300]!, width: 1),
            ),
            child: PopupMenuButton<SortOption>(
              icon: Text(
                'Sort',
                style: TextStyle(
                  color: ColorRes.leadGreyColor[700],
                  fontSize: 13,
                  fontWeight: AppFontWeights.semiBold,
                ),
              ),
              onSelected: controller.updateSortOption,
              offset: Offset(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade300, width: 0.7),
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
        ],
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
                border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 1.5),
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
          // Replace the Active Filters Display section in your ProductListingScreen

          // Active Filters Display - UPDATED VERSION
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
                              color: Colors.grey[700],
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
          // Expanded(
          //   child: Obx(() {
          //     if (controller.isLoading.value) {
          //       return Center(
          //         child: CircularProgressIndicator(color: ColorRes.primary),
          //       );
          //     }
          //
          //     if (controller.error.value.isNotEmpty) {
          //       return ErrorWidgetCustom();
          //     }
          //
          //     if (controller.filteredProducts.isEmpty) {
          //       return EmptyStateWidget();
          //     }
          //
          //     return ProductsGrid();
          //   }),
          // ),
          Expanded(
            child: Obx(() {
              if (propertyController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: ColorRes.primary),
                );
              }

              if (!propertyController.isLoading.value &&
                  propertyController.items.isEmpty) {
                return ErrorWidgetCustom();
              }

              // if (propertyController.filteredProducts.isEmpty) {
              //   return EmptyStateWidget();
              // }

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
                  child: ProductsGrid(),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: EdgeInsets.only(right: 8, top: 8, bottom: 8),
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: AppFontSizes.small,
            color: ColorRes.primary,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
        deleteIcon: Icon(
          Icons.close_rounded,
          size: 16,
          color: ColorRes.primary,
        ),
        onDeleted: onRemove,
        backgroundColor: ColorRes.primary.withOpacity(0.1),
        side: BorderSide(color: ColorRes.primary.withOpacity(0.3), width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
          Text(text, style: TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}

class FilterPanel extends StatefulWidget {
  @override
  _FilterPanelState createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  final DashboardController controller = Get.find();

  // Temporary filter values
  late RxList<String> tempSelectedCategories;
  late double tempMinPrice;
  late double tempMaxPrice;

  @override
  void initState() {
    super.initState();

    tempSelectedCategories =
        <String>[...controller.selectedProductCategories].obs;

    // FIX: Ensure we use the actual filter values, not uninitialized ones
    tempMinPrice = controller.filterMinPrice.value;
    tempMaxPrice = controller.filterMaxPrice.value;

    // Safety check: if values are invalid, use min/max
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
                // Header
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

                // Category Filter Section
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
                                        : Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color:
                                  isSelected
                                      ? ColorRes.primary
                                      : Colors.black87,
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

                // Price Range Filter Section
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

                // FIX: Add safety check for RangeSlider
                Obx(() {
                  // Get actual min/max from controller
                  final minVal = controller.minPrice.value;
                  final maxVal = controller.maxPrice.value;

                  // Ensure temp values are within bounds
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

                // Apply Button
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
                        // Apply all filters to controller
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
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
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
// Products Grid Widget
// class ProductsGrid extends StatelessWidget {
//   final DashboardController controller = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     final query = controller.searchQuery.value.toLowerCase();
//     final filteredData =
//         controller.dummyResellerLeads
//             .where((e) => e.name.toLowerCase().contains(query))
//             .toList();
//
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: ListView.separated(
//         itemCount: filteredData.length,
//         separatorBuilder: (_, __) => SizedBox(height: 12),
//         itemBuilder: (context, index) {
//           return ProductCard(product: filteredData[index]);
//         },
//       ),
//     );
//   }
// }

// Replace your ProductsGrid widget with this fixed version:

class ProductsGrid extends StatelessWidget {
  final DashboardController controller = Get.find();
  final PropertyController propertyController = Get.find(tag: reseller);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Use the already filtered products from controller
      final displayProducts = propertyController.items.value;

      if (displayProducts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: ColorRes.leadGreyColor[400]),
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
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
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
            return ProductCard(product: displayProducts[index]);
          },
        ),
      );
    });
  }
}

class ProductCard extends StatelessWidget {
  final Items product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final manager = PropertyNameManager(product);
    final priceManager = PropertyPriceManager(
      listingType: product.listingType ?? 'sale',
      financialInfo: product.propertyDetails?.financialInfo,
    );
    return Material(
      color: ColorRes.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      shadowColor: ColorRes.black.withOpacity(0.06),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Get.to(() => LeadDetailScreen(property: product));
          // Get.to(() => PropertyOverviewSellerScreen(property: product));
        },
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 1),
          ),
          child: Row(
            children: [
              // Image Section
              // ClipRRect(
              //   borderRadius: BorderRadius.horizontal(
              //     left: Radius.circular(11),
              //   ),
              //   child: Image.network(
              //     'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=800',
              //     width: 110,
              //     height: 121,
              //     fit: BoxFit.cover,
              //   ),
              // ),
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

              // Content Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title
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

                      // SizedBox(height: 6),
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

                      // SizedBox(height: 8),
                      Spacer(),

                      // Features Row
                      // Row(
                      //   children: [
                      //     _buildFeature(
                      //       Icons.bed_outlined,
                      //       '${product.customFields.propertyDetails.furnishInfo.furnishDetails.bed}',
                      //     ),
                      //     SizedBox(width: 14),
                      //     _buildFeature(
                      //       Icons.square_foot,
                      //       '${product.customFields.propertyDetails.propertyBuiltUpArea}',
                      //     ),
                      //     SizedBox(width: 14),
                      //     _buildFeature(
                      //       Icons.meeting_room_outlined,
                      //       '${product.customFields.propertyDetails.bhk}',
                      //     ),
                      //   ],
                      // ),
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
  }

  Widget _buildFeature(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: ColorRes.leadGreyColor[600]),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: AppFontSizes.caption,
            color: ColorRes.leadGreyColor[700],
            fontWeight: AppFontWeights.medium,
          ),
        ),
      ],
    );
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
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

// class ProductCard extends StatelessWidget {
//   final ResellerLeadOverview product;
//
//   const ProductCard({Key? key, required this.product}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: ColorRes.white,
//       borderRadius: BorderRadius.circular(16),
//       elevation: 2,
//       shadowColor: ColorRes.black.withOpacity(0.08),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(16),
//         onTap: () {
//           Get.snackbar(
//             'Property Selected',
//             product.name,
//             snackPosition: SnackPosition.BOTTOM,
//             duration: Duration(seconds: 2),
//             backgroundColor: ColorRes.primary,
//             colorText: ColorRes.white,
//             margin: EdgeInsets.all(16),
//             borderRadius: 12,
//           );
//         },
//         child: Container(
//           height: 125,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 1),
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.horizontal(left: Radius.circular(15)),
//                     child: Image.network(
//                       'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=800',
//                       width: 110,
//                       height: 140,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Positioned(
//                     top: 10,
//                     left: 10,
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: ColorRes.white,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.star_rounded,
//                             color: ColorRes.homeAmber[600],
//                             size: 12,
//                           ),
//                           SizedBox(width: 4),
//                           Text(
//                             '4.8',
//                             style: TextStyle(
//                               color: ColorRes.textColor,
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                 ],
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 8,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         width: 150,
//                         child: Text(
//                           '${product.customFields.builderName}',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: AppFontWeights.semiBold,
//                             color: ColorRes.textColor,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//
//
//                       SizedBox(height: 8),
//                       SizedBox(
//                         width: 150,
//                         child: Text(
//                           product.customFields.address,
//                           style: TextStyle(
//                             fontSize: 10,
//                             color: ColorRes.textDisabled,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//
//                       // Feature Row
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.bed_outlined,
//                             size: 14,
//                             color: ColorRes.primary,
//                           ),
//                           SizedBox(width: 4),
//                           Text(
//                             '${product.customFields.propertyDetails.furnishInfo.furnishDetails.bed}',
//                             style: TextStyle(fontSize: 10, fontWeight: AppFontWeights.medium),
//                           ),
//                           SizedBox(width: 12),
//                           Icon(
//                             Icons.square_foot,
//                             size: 14,
//                             color: ColorRes.primary,
//                           ),
//                           SizedBox(width: 4),
//                           Text(
//                             '${product.customFields.propertyDetails.propertyBuiltUpArea} m²',
//                             style: TextStyle(fontSize: 10, fontWeight: AppFontWeights.medium),
//                           ),
//                           SizedBox(width: 12),
//                           Icon(
//                             Icons.garage_outlined,
//                             size: 14,
//                             color: ColorRes.primary,
//                           ),
//                           SizedBox(width: 4),
//                           Text(
//                             '${product.customFields.propertyDetails.bhk}',
//                             style: TextStyle(fontSize: 10, fontWeight: AppFontWeights.medium),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 10),
//
//                       // Price & Visit Button
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             '${Formatter.formatPrice(product.customFields.propertyDetails.financialInfo.propertyPrice)}',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: AppFontWeights.semiBold,
//                               color: ColorRes.primary,
//                             ),
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 8,
//                             ),
//                             decoration: BoxDecoration(
//                               color: ColorRes.primary,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(
//                               'Visit',
//                               style: TextStyle(
//                                 fontWeight: AppFontWeights.semiBold,
//                                 fontSize: 10,
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
//       children: [
//         Icon(icon, size: 14, color: ColorRes.primary),
//         SizedBox(width: 4),
//         Text(
//           text,
//           style: TextStyle(
//             fontSize: 11,
//             color: ColorRes.leadGreyColor[700],
//             fontWeight: AppFontWeights.medium,
//           ),
//         ),
//       ],
//     );
//   }
// }

class ErrorWidgetCustom extends StatelessWidget {
  final DashboardController controller = Get.find();

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
                style: TextStyle(color: ColorRes.leadGreyColor[600], fontSize: AppFontSizes.medium),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.loadProducts,
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

// Empty State Widget
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
                style: TextStyle(color: ColorRes.leadGreyColor[600], fontSize: AppFontSizes.medium),
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
