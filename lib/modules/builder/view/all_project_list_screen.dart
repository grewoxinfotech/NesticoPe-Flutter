// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/app/constants/color_res.dart';
// import 'package:nesticope_app/data/network/builder/model/builder_model.dart';
// import 'package:nesticope_app/modules/builder/controller/all_project_controller.dart';
// import 'package:nesticope_app/modules/builder/view/project_detail/project_detail.dart';
// import 'package:nesticope_app/modules/builder/view/widget/project_filter_screen.dart';
// import 'package:nesticope_app/widgets/bar/app_bar/list_screen_appbar.dart';
// import 'package:nesticope_app/widgets/bar/filter_bar/filter_chip_bar.dart';
// import 'package:nesticope_app/widgets/empty_state/empty_state.dart';
//
// import '../../../app/constants/img_res.dart';
// import '../../filter_property/view/filter_screen.dart';
// import '../../home/widgets/unified_comparison_floating_button.dart';
// import '../controller/project_controller.dart';
// import 'builder_property_listing.dart';
//
// class AllProjectListScreen extends StatefulWidget {
//   final List<Map<String, String>>? filters;
//   final bool isAppBarShow;
//   final bool isFromSeeAll;
//   final bool isbuilder;
//
//   const AllProjectListScreen({
//     super.key,
//     this.filters,
//     this.isAppBarShow = true,
//     this.isFromSeeAll = false,
//     this.isbuilder = true,
//   });
//
//   @override
//   State<AllProjectListScreen> createState() => _AllProjectListScreenState();
// }
//
// class _AllProjectListScreenState extends State<AllProjectListScreen> {
//   final AllProjectController controller = Get.put(AllProjectController());
//   RxMap<String, String> selectedFilters = <String, String>{}.obs;
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
//       backgroundColor: ColorRes.white,
//
//       // appBar: ListScreenAppbar(
//       //   showAppBar: widget.isAppBarShow,
//       //   title: "Project List",
//       //   onBack: () {
//       //     Get.back();
//       //   },
//       //   onFilterTap: () async {
//       //     // final result = await Get.to<Map<String, String>>(
//       //     //   () => RealEstateFilterScreen(
//       //     //     initialFilters: Map<String, String>.from(selectedFilters),
//       //     //   ),
//       //     //   transition: Transition.rightToLeft,
//       //     // );
//       //     //
//       //     // if (result != null) {
//       //     //   selectedFilters
//       //     //     ..clear()
//       //     //     ..addAll(result);
//       //     //
//       //     //   controller.applyFilters(Map<String, String>.from(selectedFilters));
//       //     // }
//       //   },
//       // ),
//       // appBar: ListScreenAppbar(
//       //   showAppBar: widget.isAppBarShow,
//       //   isFormScreen: widget.isFromSeeAll,
//       //   title: "Project List",
//       //   onBack: () {
//       //     Get.back();
//       //   },
//       //   onFilterTap: () async {
//       //     var filters = await showModalBottomSheet<Map<String, String>>(
//       //       context: Get.context!, // or use your BuildContext if available
//       //       isScrollControlled: true,
//       //       backgroundColor: Colors.transparent,
//       //       builder:
//       //           (context) => ProjectFilterSheet(
//       //             initialFilters: selectedFilters.value,
//       //             onApply: (filterData) {
//       //               // ✅ Close sheet and return filters
//       //               Navigator.pop(context, filterData);
//       //             },
//       //           ),
//       //     );
//       //
//       //     if (filters != null) {
//       //       selectedFilters.value = filters;
//       //       controller.applyFilters(filters);
//       //     }
//       //   },
//       // ),
//       appBar: ListScreenAppbar(
//         showAppBar: widget.isAppBarShow,
//         isFormScreen: widget.isFromSeeAll,
//         title: "Project List",
//         onBack: () {
//           Get.back();
//         },
//         onFilterTap: () async {
//           // ✅ Navigate using Get.to a
//           // nd await result
//           final filters = await Get.to<Map<String, String>>(
//             () => ProjectFilterScreen(
//               initialFilters: selectedFilters.value,
//               onApply: (filterData) {
//                 // Return selected filters to previous screen
//                 Get.back(result: filterData);
//               },
//             ),
//             transition: Transition.downToUp,
//             // optional for sheet-like slide-up effect
//             duration: const Duration(milliseconds: 300),
//           );
//
//           // ✅ Apply filters if returned
//           if (filters != null) {
//             selectedFilters.value = filters;
//             controller.applyFilters(filters);
//           }
//         },
//       ),
//
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               children: [
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
//                   );
//                 }),
//
//                 Expanded(
//                   child: Obx(() {
//                     if (controller.isLoading.value &&
//                         controller.items.isEmpty) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//
//                     if (!controller.isLoading.value &&
//                         controller.items.isEmpty) {
//                       return const EmptyStateWidget(
//                         icon: Icons.search_off_rounded,
//                         title: "No projects found",
//                         subtitle: "Try adjusting your search criteria",
//                       );
//                     }
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
//                         child: ListView.separated(
//                           padding: const EdgeInsets.all(12),
//                           separatorBuilder:
//                               (context, index) => SizedBox(height: 12),
//                           itemCount: controller.items.length,
//                           itemBuilder: (context, index) {
//                             final data = controller.items[index];
//
//                             return GestureDetector(
//                               onTap: () {
//                                 Get.to(
//                                   () => ProjectDetailsScreen(
//                                     projectItem: data,
//                                     isBuilder: widget.isbuilder,
//                                   ),
//                                 );
//                               },
//                               child: BuilderProjectCard(
//                                 forHome: true,
//                                 project: data,
//                                 width: double.infinity,
//                                 height: 150,
//                                 // ✅ Explicitly set height
//                                 developersName:
//                                     data.projectContactInfo?.name ?? 'Unknown',
//                                 imageUrl:
//                                     (data.mediaGallery?.images?.isNotEmpty ??
//                                             false)
//                                         ? data.mediaGallery!.images.first
//                                         : IMGRes.home3,
//                                 projectName:
//                                     data.projectName.isNotEmpty
//                                         ? data.projectName
//                                         : 'N/A',
//                                 location:
//                                     data.address.isNotEmpty
//                                         ? data.address
//                                         : 'Not specified',
//                                 price: data.getPriceRange(),
//                                 propertySize:
//                                     data.projectSize?.totalBuildings
//                                         ?.toString() ??
//                                     '—',
//                               ),
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

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/data/network/builder/model/builder_model.dart';
import 'package:nesticope_app/modules/builder/controller/all_project_controller.dart';
import 'package:nesticope_app/modules/builder/view/project_detail/project_detail.dart';
import 'package:nesticope_app/modules/builder/view/widget/project_filter_screen.dart';
import 'package:nesticope_app/widgets/bar/app_bar/list_screen_appbar.dart';
import 'package:nesticope_app/widgets/bar/filter_bar/filter_chip_bar.dart';
import 'package:nesticope_app/widgets/empty_state/empty_state.dart';

import '../../../app/constants/img_res.dart';
import '../../../utils/shimmer/buyer/project/buyer_project_list_screen_shimmer.dart';
import '../../home/widgets/unified_comparison_floating_button.dart';
import '../../reseller/view/listing/property_listing.dart'
    show convertFiltersToString;
import 'builder_property_listing.dart';

// class AllProjectListScreen extends StatefulWidget {
//   final List<Map<String, String>>? filters;
//   final bool isAppBarShow;
//   final bool isFromSeeAll;
//   final bool isbuilder;
//
//   const AllProjectListScreen({
//     super.key,
//     this.filters,
//     this.isAppBarShow = true,
//     this.isFromSeeAll = false,
//     this.isbuilder = true,
//   });
//
//   @override
//   State<AllProjectListScreen> createState() => _AllProjectListScreenState();
// }
//
// class _AllProjectListScreenState extends State<AllProjectListScreen> {
//   /// ✅ Isolated controller instance
//   final AllProjectController controller = Get.put(
//     AllProjectController(),
//     tag: 'project_list_view',
//   );
//
//   /// 🔹 User-visible filters only
//   final RxMap<String, String> selectedFilters = <String, String>{}.obs;
//
//   /// 🔒 Hard-locked filter (never shown, never removed)
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
//   /// 🔁 Always merges locked + user filters
//   void _applyFilters() {
//     controller.applyFilters({..._lockedFilters, ...selectedFilters});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorRes.white,
//       appBar: ListScreenAppbar(
//         showAppBar: widget.isAppBarShow,
//         isFormScreen: widget.isFromSeeAll,
//         title: "Project List",
//         onBack: () => Get.back(),
//
//         onFilterTap: () async {
//           final result = await Get.to<Map<String, String>>(
//             () => ProjectFilterScreen(
//               initialFilters: Map<String, String>.from(
//                 selectedFilters.value, // ✅ read observable
//               ),
//               onApply: (filterData) {
//                 Get.back(result: filterData);
//               },
//             ),
//             transition: Transition.downToUp,
//             duration: const Duration(milliseconds: 300),
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
//                 /// ✅ Safe Obx usage
//                 Obx(() {
//                   final filters = selectedFilters.value;
//
//                   return FilterChipsBar(
//                     filters: filters, // no locked filters here
//                     onClearAll: () {
//                       selectedFilters.clear();
//                       _applyFilters();
//                     },
//                     onRemoveFilter: (key) {
//                       selectedFilters.remove(key);
//                       _applyFilters();
//                     },
//                   );
//                 }),
//
//                 Expanded(
//                   child: Obx(() {
//                     if (controller.isLoading.value &&
//                         controller.items.isEmpty) {
//                       return BuyerProjectListScreenShimmer();
//                     }
//
//                     if (!controller.isLoading.value &&
//                         controller.items.isEmpty) {
//                       return const EmptyStateWidget(
//                         icon: Icons.search_off_rounded,
//                         title: "No projects found",
//                         subtitle: "No approved projects available",
//                       );
//                     }
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
//                         child: ListView.separated(
//                           padding: const EdgeInsets.all(12),
//                           separatorBuilder:
//                               (_, __) => const SizedBox(height: 12),
//                           itemCount: controller.items.length,
//                           itemBuilder: (context, index) {
//                             final ProjectItem data = controller.items[index];
//
//                             return GestureDetector(
//                               onTap: () {
//                                 Get.to(
//                                   () => ProjectDetailsScreen(
//                                     projectItem: data,
//                                     isBuilder: widget.isbuilder,
//                                   ),
//                                 );
//                               },
//                               child: BuilderProjectCard(
//                                 forHome: true,
//                                 project: data,
//                                 width: double.infinity,
//                                 height: 150,
//                                 developersName:
//                                     data.projectContactInfo?.name ?? 'Unknown',
//                                 imageUrl:
//                                     (data.mediaGallery?.images?.isNotEmpty ??
//                                             false)
//                                         ? data.mediaGallery!.images.first
//                                         : IMGRes.home3,
//                                 projectName:
//                                     data.projectName.isNotEmpty
//                                         ? data.projectName
//                                         : 'N/A',
//                                 location:
//                                     data.address.isNotEmpty
//                                         ? data.address
//                                         : 'Not specified',
//                                 price: data.getPriceRange(),
//                                 propertySize:
//                                     data.projectSize?.totalBuildings
//                                         ?.toString() ??
//                                     '—',
//                               ),
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

class AllProjectListScreen extends StatefulWidget {
  final List<Map<String, String>>? filters;
  final bool isAppBarShow;
  final bool isFromSeeAll;
  final bool isbuilder;
  final bool withoutApprovalAndVerification;

  const AllProjectListScreen({
    super.key,
    this.filters,
    this.isAppBarShow = true,
    this.isFromSeeAll = false,
    this.isbuilder = true,
    this.withoutApprovalAndVerification = false,
  });

  @override
  State<AllProjectListScreen> createState() => _AllProjectListScreenState();
}

class _AllProjectListScreenState extends State<AllProjectListScreen> {
  /// ✅ Isolated controller instance
  final AllProjectController controller = Get.put(
    AllProjectController(),
    tag: 'project_list_view',
  );

  /// 🔹 User-visible filters only (now regular Map)
  Map<String, String> selectedFilters = {};

  /// 🔒 Hard-locked filter (never shown, never removed)
  static const Map<String, String> _lockedFilters = {
    "approval_status": "approved",
    "isVerified": "true",
  };

  bool _isLoading = true; // ✅ Start with loading state
  List<ProjectItem> _items = [];

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

  /// 🔁 Always merges locked + user filters
  void _applyFilters() {
    if (widget.withoutApprovalAndVerification) {
      selectedFilters.removeWhere(
        (key, value) => key == 'approval_status' || key == 'isVerified',
      );
    }

    if (widget.withoutApprovalAndVerification) {
      controller.applyFilters({..._lockedFilters, ...selectedFilters});
    } else {
      controller.applyFilters({...selectedFilters});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: ListScreenAppbar(
        showAppBar: widget.isAppBarShow,
        isFormScreen: widget.isFromSeeAll,
        showIconWithText: true,
        title: "Project List",
        onBack: () => Get.back(),

        onFilterTap: () async {
          final result = await Get.to(
            () => ResellerProjectFilterScreen(
              isProjectItemBuyerFilter: true,
              /* initialFilters: Map<String, String>.from(selectedFilters),
              onApply: (filterData) {
                filterData.removeWhere((key, value) => ( value == 'false'),);

                Get.back(result: filterData);
              },*/
            ),
            transition: Transition.downToUp,
            duration: const Duration(milliseconds: 300),
          );

          if (result != null) {
            final newFilter = convertFiltersToString(result);
            setState(() {
              selectedFilters
                ..clear()
                ..addAll(newFilter);
              // selectedFilters = newFilter;
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
                ),

                Expanded(
                  child:
                      _isLoading && _items.isEmpty
                          ? BuyerProjectListScreenShimmer()
                          : !_isLoading && _items.isEmpty
                          ? const EmptyStateWidget(
                            icon: Icons.search_off_rounded,
                            title: "No projects found",
                            subtitle: "No approved projects available",
                          )
                          : NotificationListener<ScrollNotification>(
                            onNotification: (scrollEnd) {
                              final metrics = scrollEnd.metrics;
                              if (metrics.atEdge && metrics.pixels != 0) {
                                controller.loadMore();
                              }
                              return false;
                            },
                            child: RefreshIndicator(
                              onRefresh: controller.refreshList,
                              child: ListView.separated(
                                padding: const EdgeInsets.all(12),
                                separatorBuilder:
                                    (_, __) => const SizedBox(height: 12),
                                itemCount: _items.length,
                                itemBuilder: (context, index) {
                                  final ProjectItem data = _items[index];

                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        () => ProjectDetailsScreen(
                                          projectItem: data,
                                          isFromPanel: true,
                                          isBuilder: widget.isbuilder,
                                        ),
                                      );
                                    },
                                    child: BuilderProjectCard(
                                      forHome: true,
                                      project: data,
                                      width: double.infinity,
                                      height: 150,
                                      developersName:
                                          data.projectContactInfo?.name ??
                                          'Unknown',
                                      imageUrl:
                                          (data
                                                      .mediaGallery
                                                      ?.images
                                                      ?.isNotEmpty ??
                                                  false)
                                              ? data.mediaGallery!.images.first
                                              : IMGRes.home3,
                                      projectName:
                                          data.projectName.isNotEmpty
                                              ? data.projectName
                                              : 'N/A',
                                      location:
                                          data.address.isNotEmpty
                                              ? data.address
                                              : 'Not specified',
                                      price: data.getPriceRange(),
                                      propertySize:
                                          data.projectSize?.totalBuildings
                                              ?.toString() ??
                                          '—',
                                    ),
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
