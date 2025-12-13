import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/data/network/builder/model/builder_model.dart';
import 'package:housing_flutter_app/modules/builder/controller/all_project_controller.dart';
import 'package:housing_flutter_app/modules/builder/view/project_detail/project_detail.dart';
import 'package:housing_flutter_app/modules/builder/view/widget/project_filter_screen.dart';
import 'package:housing_flutter_app/widgets/bar/app_bar/list_screen_appbar.dart';
import 'package:housing_flutter_app/widgets/bar/filter_bar/filter_chip_bar.dart';
import 'package:housing_flutter_app/widgets/empty_state/empty_state.dart';

import '../../../app/constants/img_res.dart';
import '../../filter_property/view/filter_screen.dart';
import '../../home/widgets/unified_comparison_floating_button.dart';
import '../controller/project_controller.dart';
import 'builder_property_listing.dart';

class AllProjectListScreen extends StatefulWidget {
  final List<Map<String, String>>? filters;
  final bool isAppBarShow;
  final bool isFromSeeAll;

  const AllProjectListScreen({
    super.key,
    this.filters,
    this.isAppBarShow = true,
    this.isFromSeeAll = false,
  });

  @override
  State<AllProjectListScreen> createState() => _AllProjectListScreenState();
}

class _AllProjectListScreenState extends State<AllProjectListScreen> {
  final AllProjectController controller = Get.put(AllProjectController());
  RxMap<String, String> selectedFilters = <String, String>{}.obs;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.filters != null) {
        final Map<String, String> filterMap = {};
        for (var filter in widget.filters!) {
          filterMap.addAll(filter);
        }
        selectedFilters.addAll(filterMap);
        controller.applyFilters(filterMap);
      } else {
        controller.loadInitial();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,

      // appBar: ListScreenAppbar(
      //   showAppBar: widget.isAppBarShow,
      //   title: "Project List",
      //   onBack: () {
      //     Get.back();
      //   },
      //   onFilterTap: () async {
      //     // final result = await Get.to<Map<String, String>>(
      //     //   () => RealEstateFilterScreen(
      //     //     initialFilters: Map<String, String>.from(selectedFilters),
      //     //   ),
      //     //   transition: Transition.rightToLeft,
      //     // );
      //     //
      //     // if (result != null) {
      //     //   selectedFilters
      //     //     ..clear()
      //     //     ..addAll(result);
      //     //
      //     //   controller.applyFilters(Map<String, String>.from(selectedFilters));
      //     // }
      //   },
      // ),
      appBar: ListScreenAppbar(
        showAppBar: widget.isAppBarShow,
        isFormScreen: widget.isFromSeeAll,
        title: "Project List",
        onBack: () {
          Get.back();
        },
        onFilterTap: () async {
          var filters = await showModalBottomSheet<Map<String, String>>(
            context: Get.context!, // or use your BuildContext if available
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder:
                (context) => ProjectFilterSheet(
                  initialFilters: selectedFilters.value,
                  onApply: (filterData) {
                    // ✅ Close sheet and return filters
                    Navigator.pop(context, filterData);
                  },
                ),
          );

          if (filters != null) {
            selectedFilters.value = filters;
            controller.applyFilters(filters);
          }
        },
      ),

      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Obx(() {
                  return FilterChipsBar(
                    filters: selectedFilters.value,
                    onClearAll: () {
                      selectedFilters.clear();
                      controller.applyFilters(<String, String>{});
                    },
                    onRemoveFilter: (key) {
                      selectedFilters.remove(key);
                      controller.applyFilters(
                        Map<String, String>.from(selectedFilters),
                      );
                    },
                  );
                }),

                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value &&
                        controller.items.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!controller.isLoading.value &&
                        controller.items.isEmpty) {
                      return const EmptyStateWidget(
                        icon: Icons.search_off_rounded,
                        title: "No projects found",
                        subtitle: "Try adjusting your search criteria",
                      );
                    }

                    return NotificationListener<ScrollNotification>(
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
                              (context, index) => SizedBox(height: 12),
                          itemCount: controller.items.length,
                          itemBuilder: (context, index) {
                            final data = controller.items[index];

                            return GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => ProjectDetailsScreen(
                                    projectItem: data,
                                    isBuilder: true,
                                  ),
                                );
                              },
                              child: BuilderProjectCard(
                                forHome: true,
                                project: data,
                                width: double.infinity,
                                height: 150,
                                // ✅ Explicitly set height
                                developersName:
                                    data.projectContactInfo?.name ?? 'Unknown',
                                imageUrl:
                                    (data.mediaGallery?.images?.isNotEmpty ??
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
                    );
                  }),
                ),
              ],
            ),
            UnifiedComparisonFloatingButton(bottom: 16),
          ],
        ),
      ),
    );
  }
}
