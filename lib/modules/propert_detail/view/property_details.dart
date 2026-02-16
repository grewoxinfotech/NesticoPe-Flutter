// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/constants/size_manager.dart';
// import 'package:housing_flutter_app/app/utils/formater/formater.dart';
// import 'package:housing_flutter_app/modules/filter_property/view/filter_screen.dart';
// import 'package:housing_flutter_app/modules/propert_detail/view/widget/property_card_widget.dart';
// import 'package:housing_flutter_app/widgets/bar/app_bar/list_screen_appbar.dart';
//
// import '../../../app/constants/app_font_sizes.dart';
// import '../../../app/manager/compare_manager.dart';
// import '../../../data/network/property/models/property_model.dart';
// import '../../../widgets/bar/filter_bar/filter_chip_bar.dart';
// import '../../../widgets/empty_state/empty_state.dart';
// import '../../builder/view/builder_leads.dart';
//
// // import '../../home/widgets/comparison_floating_button.dart';
// // import '../../home/widgets/property_comparison_floating_button.dart';
// import '../../home/widgets/unified_comparison_floating_button.dart';
// import '../../property/controllers/property_controller.dart';
//
// class PropertyDetail extends StatefulWidget {
//   final List<Map<String, String>>? filters;
//   final bool isAppBarShow;
//   final Color backgroundColor;
//   final bool isFromSeeAll;
//
//   PropertyDetail({
//     super.key,
//     this.isAppBarShow = true,
//     this.backgroundColor = ColorRes.white,
//     this.filters,
//     this.isFromSeeAll = false,
//   });
//
//   @override
//   State<PropertyDetail> createState() => _PropertyDetailState();
// }
//
// class _PropertyDetailState extends State<PropertyDetail> {
//   final PropertyController controller = Get.put(PropertyController());
//   final RxMap<String, String> selectedFilters = <String, String>{}.obs;
//   final CompareManager compare = Get.find<CompareManager>();
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (widget.filters != null) {
//         final Map<String, String> filterMap = {};
//         for (var filter in widget.filters!) {
//           filterMap.addAll(filter);
//         }
//         selectedFilters.addAll(filterMap);
//         controller.applyFilters(filterMap);
//       } else {
//         controller.loadInitial();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: widget.backgroundColor,
//       appBar: ListScreenAppbar(
//         showAppBar: widget.isAppBarShow,
//         title: "Property List",
//         isFormScreen: widget.isFromSeeAll,
//         onBack: () {
//           log("Selected City foback ${controller.selectedCity.value}");
//           controller.filters = {'city': controller.selectedCity.value};
//           Get.back();
//         },
//         onFilterTap: () async {
//           final result = await Get.to<Map<String, String>>(
//             () => RealEstateFilterScreen(
//               initialFilters: Map<String, String>.from(selectedFilters),
//             ),
//             transition: Transition.rightToLeft,
//           );
//
//           if (result != null) {
//             selectedFilters
//               ..clear()
//               ..addAll(result);
//
//             controller.applyFilters(Map<String, String>.from(selectedFilters));
//           }
//         },
//       ),
//
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 // Fixed filter bar
//                 // Obx(() {
//                 //   if (selectedFilters.isEmpty) return const SizedBox.shrink();
//                 //
//                 //   return Container(
//                 //     padding: const EdgeInsets.symmetric(
//                 //       horizontal: 12,
//                 //       vertical: 8,
//                 //     ),
//                 //     width: double.infinity,
//                 //     decoration: BoxDecoration(
//                 //       color: ColorRes.white,
//                 //       boxShadow: [
//                 //         BoxShadow(
//                 //           color: ColorRes.black.withOpacity(0.05),
//                 //           blurRadius: 2,
//                 //         ),
//                 //       ],
//                 //     ),
//                 //     child: SingleChildScrollView(
//                 //       scrollDirection: Axis.horizontal,
//                 //       child: Row(
//                 //         children: [
//                 //           GestureDetector(
//                 //             onTap: () {
//                 //               selectedFilters.clear();
//                 //               controller.applyFilters(<String, String>{});
//                 //             },
//                 //             child: Container(
//                 //               margin: const EdgeInsets.only(right: 8),
//                 //               padding: const EdgeInsets.symmetric(
//                 //                 horizontal: 10,
//                 //                 vertical: 6,
//                 //               ),
//                 //               decoration: BoxDecoration(
//                 //                 color: ColorRes.primary.withOpacity(0.1),
//                 //                 borderRadius: BorderRadius.circular(8),
//                 //                 border: Border.all(
//                 //                   color: ColorRes.primary.withOpacity(0.3),
//                 //                 ),
//                 //               ),
//                 //               child: const Row(
//                 //                 mainAxisSize: MainAxisSize.min,
//                 //                 children: [
//                 //                   Text(
//                 //                     "Clear All",
//                 //                     style: TextStyle(
//                 //                       fontSize: AppFontSizes.small,
//                 //                       color: ColorRes.primary,
//                 //                       fontWeight: AppFontWeights.medium,
//                 //                     ),
//                 //                   ),
//                 //                   SizedBox(width: 4),
//                 //                   Icon(
//                 //                     Icons.close,
//                 //                     size: 16,
//                 //                     color: ColorRes.primary,
//                 //                   ),
//                 //                 ],
//                 //               ),
//                 //             ),
//                 //           ),
//                 //           ...selectedFilters.entries.map((entry) {
//                 //             final key = entry.key;
//                 //             final value = entry.value;
//                 //
//                 //             if (value.toString().trim().isEmpty) {
//                 //               return const SizedBox.shrink();
//                 //             }
//                 //
//                 //             String displayValue;
//                 //             try {
//                 //               final parsed = jsonDecode(value);
//                 //               if (parsed is Map &&
//                 //                   parsed.containsKey('min') &&
//                 //                   parsed.containsKey('max')) {
//                 //                 final min = parsed['min'];
//                 //                 final max = parsed['max'];
//                 //                 displayValue = _formatPriceRange(min, max);
//                 //               } else {
//                 //                 displayValue = value.toString();
//                 //               }
//                 //             } catch (e) {
//                 //               // if not JSON, use as-is
//                 //               displayValue = value.toString();
//                 //             }
//                 //
//                 //             return Container(
//                 //               margin: const EdgeInsets.only(right: 8),
//                 //               padding: const EdgeInsets.symmetric(
//                 //                 horizontal: 10,
//                 //                 vertical: 6,
//                 //               ),
//                 //               decoration: BoxDecoration(
//                 //                 color: ColorRes.primary.withOpacity(0.1),
//                 //                 borderRadius: BorderRadius.circular(8),
//                 //                 border: Border.all(
//                 //                   color: ColorRes.primary.withOpacity(0.3),
//                 //                 ),
//                 //               ),
//                 //               child: Row(
//                 //                 mainAxisSize: MainAxisSize.min,
//                 //                 children: [
//                 //                   Text(
//                 //                     "$key: $displayValue",
//                 //                     style: const TextStyle(
//                 //                       fontSize: AppFontSizes.small,
//                 //                       color: ColorRes.primary,
//                 //                       fontWeight: AppFontWeights.medium,
//                 //                     ),
//                 //                   ),
//                 //                   const SizedBox(width: 6),
//                 //                   GestureDetector(
//                 //                     onTap: () {
//                 //                       selectedFilters.remove(key);
//                 //                       controller.applyFilters(
//                 //                         Map<String, String>.from(
//                 //                           selectedFilters,
//                 //                         ),
//                 //                       );
//                 //                     },
//                 //                     child: const Icon(
//                 //                       Icons.close,
//                 //                       size: 16,
//                 //                       color: ColorRes.primary,
//                 //                     ),
//                 //                   ),
//                 //                 ],
//                 //               ),
//                 //             );
//                 //           }).toList(),
//                 //         ],
//                 //       ),
//                 //     ),
//                 //   );
//                 // }),
//                 Obx(() {
//                   return FilterChipsBar(
//                     filters: selectedFilters.value,
//                     onClearAll: () {
//                       selectedFilters.clear();
//                       controller.applyFilters(<String, String>{});
//                     },
//                     onRemoveFilter: (key) {
//                       selectedFilters.remove(key);
//                       controller.applyFilters(
//                         Map<String, String>.from(selectedFilters),
//                       );
//                     },
//                     priceRangeFormatter:
//                         (min, max) => formatPriceRange(min, max),
//                   );
//                 }),
//
//                 // property list
//                 Expanded(
//                   child: Obx(() {
//                     if (controller.isLoading.value &&
//                         controller.items.isEmpty) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//
//                     if (!controller.isLoading.value &&
//                         controller.items.isEmpty) {
//                       // return Center(
//                       //   child: Column(
//                       //     mainAxisAlignment: MainAxisAlignment.center,
//                       //     children: [
//                       //       const Icon(
//                       //         Icons.search_off_rounded,
//                       //         size: 64,
//                       //         color: ColorRes.primary,
//                       //       ),
//                       //       const SizedBox(height: 16),
//                       //       const Text(
//                       //         "No properties found",
//                       //         style: TextStyle(
//                       //           fontSize: AppFontSizes.body,
//                       //           fontWeight: AppFontWeights.semiBold,
//                       //           color: ColorRes.textColor,
//                       //         ),
//                       //       ),
//                       //       const SizedBox(height: 8),
//                       //       Text(
//                       //         selectedFilters.isEmpty
//                       //             ? "Try adjusting your search criteria"
//                       //             : "Try removing some filters",
//                       //         style: TextStyle(
//                       //           fontSize: AppFontSizes.medium,
//                       //           color: ColorRes.textColor.withOpacity(0.7),
//                       //         ),
//                       //       ),
//                       //       if (selectedFilters.isNotEmpty) ...[
//                       //         const SizedBox(height: 24),
//                       //         ElevatedButton(
//                       //           onPressed: () {
//                       //             selectedFilters.clear();
//                       //             controller.applyFilters(<String, String>{});
//                       //           },
//                       //           style: ElevatedButton.styleFrom(
//                       //             backgroundColor: ColorRes.primary,
//                       //             foregroundColor: ColorRes.white,
//                       //             padding: const EdgeInsets.symmetric(
//                       //               horizontal: 24,
//                       //               vertical: 12,
//                       //             ),
//                       //           ),
//                       //           child: const Text("Clear All Filters"),
//                       //         ),
//                       //       ],
//                       //     ],
//                       //   ),
//                       // );
//                       return EmptyStateWidget(
//                         icon: Icons.search_off_rounded,
//                         title: "No properties found",
//                         subtitle: "Try adjusting your search criteria",
//                       );
//                     }
//
//                     final List<Items> approvedProperty =
//                         controller.items.value
//                             .where(
//                               (element) =>
//                                   element.approvalStatus!.toLowerCase() ==
//                                   "approved",
//                             )
//                             .toList();
//
//                     return NotificationListener<ScrollNotification>(
//                       onNotification: (scrollEnd) {
//                         final metrics = scrollEnd.metrics;
//                         if (metrics.atEdge && metrics.pixels != 0) {
//                           controller.loadMore();
//                         }
//                         return false;
//                       },
//                       child: RefreshIndicator(
//                         onRefresh: controller.refreshList,
//                         child: ListView.builder(
//                           padding: const EdgeInsets.symmetric(
//                             vertical: AppPadding.small,
//                             horizontal: AppPadding.small,
//                           ),
//                           itemCount: approvedProperty.length,
//                           itemBuilder: (context, index) {
//                             final data = approvedProperty[index];
//
//                             return PropertyCardWidget(
//                               property: data,
//                               role: 'Developer',
//                             );
//                           },
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ],
//             ),
//             UnifiedComparisonFloatingButton(bottom: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// String formatPriceRange(dynamic min, dynamic max) {
//   double minVal =
//       (min is num) ? min.toDouble() : double.tryParse(min.toString()) ?? 0;
//   double maxVal =
//       (max is num) ? max.toDouble() : double.tryParse(max.toString()) ?? 0;
//
//   // 🧠 Handle special cases
//   if (minVal == 0 && maxVal == 0) return "₹0";
//   if (minVal == 0) return "Up to ${Formatter.formatPrice(maxVal)}";
//   if (maxVal == 0) return "From ${Formatter.formatPrice(minVal)}";
//
//   return "${Formatter.formatPrice(minVal)} - ${Formatter.formatPrice(maxVal)}";
// }

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/modules/filter_property/view/filter_screen.dart';
import 'package:housing_flutter_app/modules/propert_detail/view/widget/property_card_widget.dart';
import 'package:housing_flutter_app/utils/shimmer/buyer/property/buyer_property_list_screen_shimmer.dart';
import 'package:housing_flutter_app/widgets/bar/app_bar/list_screen_appbar.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/manager/compare_manager.dart';
import '../../../data/network/property/models/property_model.dart';
import '../../../widgets/bar/filter_bar/filter_chip_bar.dart';
import '../../../widgets/empty_state/empty_state.dart';
import '../../builder/view/builder_leads.dart';

import '../../home/widgets/unified_comparison_floating_button.dart';
import '../../property/controllers/property_controller.dart';

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/modules/filter_property/view/filter_screen.dart';
import 'package:housing_flutter_app/modules/propert_detail/view/widget/property_card_widget.dart';
import 'package:housing_flutter_app/widgets/bar/app_bar/list_screen_appbar.dart';

import '../../../app/manager/compare_manager.dart';
import '../../../data/network/property/models/property_model.dart';
import '../../../widgets/bar/filter_bar/filter_chip_bar.dart';
import '../../../widgets/empty_state/empty_state.dart';
import '../../home/widgets/unified_comparison_floating_button.dart';
import '../../property/controllers/property_controller.dart';

// class PropertyDetail extends StatefulWidget {
//   final List<Map<String, String>>? filters;
//   final bool isAppBarShow;
//   final Color backgroundColor;
//   final bool isFromSeeAll;
//
//   const PropertyDetail({
//     super.key,
//     this.isAppBarShow = true,
//     this.backgroundColor = ColorRes.white,
//     this.filters,
//     this.isFromSeeAll = false,
//   });
//
//   @override
//   State<PropertyDetail> createState() => _PropertyDetailState();
// }
//
// class _PropertyDetailState extends State<PropertyDetail> {
//   final PropertyController controller = Get.put(
//     PropertyController(),
//     tag: 'listing_view',
//   );
//
//   /// 🔹 User-visible filters only
//   final RxMap<String, String> selectedFilters = <String, String>{}.obs;
//
//   final CompareManager compare = Get.find<CompareManager>();
//
//   /// 🔒 Hard-locked filter (never visible, never removable)
//   static const Map<String, String> _lockedFilters = {
//     "approval_status": "approved",
//   };
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final Map<String, String> uiFilters = {};
//
//       if (widget.filters != null && widget.filters!.isNotEmpty) {
//         for (final filter in widget.filters!) {
//           uiFilters.addAll(filter);
//         }
//       }
//
//       selectedFilters.addAll(uiFilters);
//       _applyFilters();
//     });
//   }
//
//   void _applyFilters() {
//     controller.applyFilters({
//       ..._lockedFilters, // 🔒 always applied
//       ...selectedFilters, // user filters
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: widget.backgroundColor,
//       appBar: ListScreenAppbar(
//         showAppBar: widget.isAppBarShow,
//         title: "Property List",
//         isFormScreen: widget.isFromSeeAll,
//         onBack: () => Get.back(),
//
//         onFilterTap: () async {
//           final result = await Get.to<Map<String, String>>(
//             () => RealEstateFilterScreen(
//               initialFilters: Map<String, String>.from(
//                 selectedFilters.value, // ✅ READ VALUE
//               ),
//             ),
//             transition: Transition.rightToLeft,
//           );
//
//           if (result != null) {
//             selectedFilters
//               ..clear()
//               ..addAll(result);
//             _applyFilters();
//           }
//         },
//       ),
//
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 /// ✅ FIXED Obx — observable is READ
//                 Obx(() {
//                   final filters = selectedFilters.value;
//
//                   return FilterChipsBar(
//                     filters: filters, // plain Map now
//                     onClearAll: () {
//                       selectedFilters.clear();
//                       _applyFilters();
//                     },
//                     onRemoveFilter: (key) {
//                       selectedFilters.remove(key);
//                       _applyFilters();
//                     },
//                     priceRangeFormatter:
//                         (min, max) => formatPriceRange(min, max),
//                   );
//                 }),
//
//                 Expanded(
//                   child: Obx(() {
//                     if (controller.isLoading.value &&
//                         controller.items.isEmpty) {
//                       return BuyerPropertyListScreenShimmer();
//                     }
//
//                     if (!controller.isLoading.value &&
//                         controller.items.isEmpty) {
//                       return const EmptyStateWidget(
//                         icon: Icons.search_off_rounded,
//                         title: "No properties found",
//                         subtitle: "No approved properties available",
//                       );
//                     }
//
//                     return NotificationListener<ScrollNotification>(
//                       onNotification: (notification) {
//                         if (notification.metrics.pixels >=
//                             notification.metrics.maxScrollExtent - 200) {
//                           controller.loadMore();
//                         }
//                         return false;
//                       },
//                       child: RefreshIndicator(
//                         onRefresh: controller.refreshList,
//                         child: ListView.builder(
//                           padding: const EdgeInsets.symmetric(
//                             vertical: AppPadding.small,
//                             horizontal: AppPadding.small,
//                           ),
//                           itemCount: controller.items.length,
//                           itemBuilder: (context, index) {
//                             final Items data = controller.items[index];
//                             return PropertyCardWidget(
//                               property: data,
//                               role: 'Developer',
//                             );
//                           },
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ],
//             ),
//
//             const UnifiedComparisonFloatingButton(bottom: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }

// String formatPriceRange(dynamic min, dynamic max) {
//   double minVal =
//       (min is num) ? min.toDouble() : double.tryParse(min.toString()) ?? 0;
//   double maxVal =
//       (max is num) ? max.toDouble() : double.tryParse(max.toString()) ?? 0;
//
//   if (minVal == 0 && maxVal == 0) return "₹0";
//   if (minVal == 0) return "Up to ${Formatter.formatPrice(maxVal)}";
//   if (maxVal == 0) return "From ${Formatter.formatPrice(minVal)}";
//
//   return "${Formatter.formatPrice(minVal)} - ${Formatter.formatPrice(maxVal)}";
// }

class PropertyDetail extends StatefulWidget {
  final List<Map<String, String>>? filters;
  final bool isAppBarShow;
  final Color backgroundColor;
  final bool isFromSeeAll;

  const PropertyDetail({
    super.key,
    this.isAppBarShow = true,
    this.backgroundColor = ColorRes.white,
    this.filters,
    this.isFromSeeAll = false,
  });

  @override
  State<PropertyDetail> createState() => _PropertyDetailState();
}

class _PropertyDetailState extends State<PropertyDetail> {
  final PropertyController controller = Get.put(
    PropertyController(),
    tag: 'listing_view',
  );

  /// 🔹 User-visible filters only (now regular Map)
  Map<String, String> selectedFilters = {};

  final CompareManager compare = Get.find<CompareManager>();

  /// 🔒 Hard-locked filter (never visible, never removable)
  static const Map<String, String> _lockedFilters = {
    "approval_status": "approved",
  };

  bool _isLoading = true; // ✅ Start with loading state
  List<Items> _items = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Map<String, String> uiFilters = {};

      if (widget.filters != null && widget.filters!.isNotEmpty) {
        for (final filter in widget.filters!) {
          uiFilters.addAll(filter);
        }
      }

      setState(() {
        selectedFilters = uiFilters;
      });
      _applyFilters();
    });

    // Listen to controller changes
    controller.isLoading.listen((loading) {
      if (mounted) {
        setState(() {
          _isLoading = loading;
        });
      }
    });

    controller.items.listen((items) {
      if (mounted) {
        setState(() {
          _items = items;
        });
      }
    });
  }

  void _applyFilters() {
    controller.applyFilters({
      ..._lockedFilters, // 🔒 always applied
      ...selectedFilters, // user filters
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: ListScreenAppbar(
        showAppBar: widget.isAppBarShow,
        title: "Property List",
        isFormScreen: widget.isFromSeeAll,
        onBack: () => Get.back(),

        onFilterTap: () async {
          final result = await Get.to<Map<String, String>>(
            () => RealEstateFilterScreen(
              initialFilters: Map<String, String>.from(selectedFilters),
            ),
            transition: Transition.rightToLeft,
          );

          if (result != null) {
            result.removeWhere((key, value) => value == 'false');
            setState(() {
              selectedFilters = result;
            });
            _applyFilters();
          }
        },
      ),

      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                /// ✅ Using regular setState
                FilterChipsBar(
                  filters: selectedFilters,
                  onClearAll: () {
                    setState(() {
                      selectedFilters.clear();
                    });
                    _applyFilters();
                  },
                  onRemoveFilter: (key) {
                    setState(() {
                      selectedFilters.remove(key);
                    });
                    _applyFilters();
                  },
                  priceRangeFormatter: (min, max) => formatPriceRange(min, max),
                ),

                Expanded(
                  child:
                      _isLoading && _items.isEmpty
                          ? BuyerPropertyListScreenShimmer()
                          : !_isLoading && _items.isEmpty
                          ? const EmptyStateWidget(
                            icon: Icons.search_off_rounded,
                            title: "No properties found",
                            subtitle: "No approved properties available",
                          )
                          : NotificationListener<ScrollNotification>(
                            onNotification: (notification) {
                              if (notification.metrics.pixels ==
                                  notification.metrics.maxScrollExtent) {
                                controller.loadMore();
                              }
                              return false;
                            },
                            child: RefreshIndicator(
                              onRefresh: controller.refreshList,
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppPadding.small,
                                  horizontal: AppPadding.small,
                                ),
                                itemCount: _items.length,
                                itemBuilder: (context, index) {
                                  final Items data = _items[index];
                                  return PropertyCardWidget(
                                    property: data,
                                    role: 'Developer',
                                  );
                                },
                              ),
                            ),
                          ),
                ),
              ],
            ),

            const UnifiedComparisonFloatingButton(bottom: 16),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up listeners if needed
    super.dispose();
  }
}

String formatPriceRange(dynamic min, dynamic max) {
  final double minVal = _parseToDouble(min);
  final double maxVal = _parseToDouble(max);

  if (minVal == 0 && maxVal == 0) return "₹0";
  if (minVal == 0) return "Up to ${Formatter.formatPrice(maxVal)}";
  if (maxVal == 0) return "From ${Formatter.formatPrice(minVal)}";

  return "${Formatter.formatPrice(minVal)} - ${Formatter.formatPrice(maxVal)}";
}

double _parseToDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}
