import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/app/widgets/image/custom_image.dart';
import 'package:nesticope_app/app/widgets/shimmer/shimmer_widget.dart';
import 'package:nesticope_app/app/widgets/texts/headline_text.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/builder/model/builder_model.dart';
import 'package:nesticope_app/data/network/top_seller_profile/model/top_builder_profile_model.dart';
import 'package:nesticope_app/modules/builder/view/project_detail/project_detail.dart';
import 'package:nesticope_app/modules/home/controllers/top_builder_controller.dart';
import 'package:nesticope_app/modules/builder/controller/builder_listed_project_controller.dart';
import 'package:nesticope_app/modules/builder/controller/builder_form_controller.dart';
import 'package:nesticope_app/modules/builder/view/property_detail/property_detail.dart';
import 'package:nesticope_app/modules/builder/view/builder_property_listing.dart';
import 'package:nesticope_app/utils/global.dart';
import 'package:nesticope_app/utils/shimmer/seller/builder/project_screen/project_list_screen_shimmer.dart';
import 'package:shimmer/shimmer.dart';
import '../../home/widgets/unified_comparison_floating_button.dart';

class TopDeveloperProfileScreen extends StatefulWidget {
  final String userId;
  final String createdBy;
  const TopDeveloperProfileScreen({
    super.key,
    required this.userId,
    required this.createdBy,
  });

  @override
  State<TopDeveloperProfileScreen> createState() =>
      _TopDeveloperProfileScreenState();
}

class _TopDeveloperProfileScreenState extends State<TopDeveloperProfileScreen> {
  late final String _tag;
  late final TopBuilderController profileController;
  late final ProjectWizardController projectController;
  bool _initialStatusApplied = false;
  final RxString selectedStatus = ''.obs;
  final RxString selectedCity = ''.obs;
  final ScrollController _developerController = ScrollController();
  double _scrollOffset = 0;
  final RxList<ProjectItem> allItemsCache = <ProjectItem>[].obs;

  @override
  void initState() {
    super.initState();
    _tag = 'top_dev_profile_${widget.userId}';
    print('tag: ${widget.userId}======== ${widget.createdBy}');

    profileController =
        Get.isRegistered<TopBuilderController>(tag: _tag)
            ? Get.find<TopBuilderController>(tag: _tag)
            : Get.put(TopBuilderController(), tag: _tag);
    projectController =
        Get.isRegistered<ProjectWizardController>(tag: _tag)
            ? Get.find<ProjectWizardController>(tag: _tag)
            : Get.put(ProjectWizardController(isBuilderView: false), tag: _tag);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      projectController.youWantWithoutCity.value = true;
      projectController.filters?.remove('city');
      await Future.wait([
        projectController.applyFilters({'created_by': widget.createdBy}),
        profileController.loadSellerProfile(widget.userId),
      ]);
    });

    // Load stored city (if any) to filter projects/developers shown
    SecureStorage.getSelectedCity()
        .then((city) {
          if (city != null && city.isNotEmpty) {
            selectedCity.value = city;
          }
        })
        .catchError((e) {
          log('Error reading selected city: $e');
        });

    ever<List<ProjectItem>>(projectController.items, (list) async {
      if (allItemsCache.isEmpty && list.isNotEmpty) {
        allItemsCache.assignAll(list.toList(growable: false));
        final initialStatus = projectController.builderStatus.value.trim();
        if (initialStatus.isNotEmpty && !_initialStatusApplied) {
          selectedStatus.value = initialStatus;
          final m = initialStatus.toLowerCase();
          final apiStatus = m;
          await projectController.applyFilters({
            'status': apiStatus,
            'created_by': widget.createdBy,
          });
          _initialStatusApplied = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        // Keep default system back behavior to reuse existing previous route.
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: _goToDashboard,
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text(
            'Developer Profile',
            style: TextStyle(fontWeight: AppFontWeights.semiBold),
          ),
          backgroundColor: ColorRes.white,
          elevation: 0,
          centerTitle: false,
        ),
        body: SafeArea(
          child: Obx(() {
            final isLoadingProfile = profileController.isLoading.value;
            final items = projectController.items;
            log('items: sdfdsfsdfsdf${items.length}');

            if (selectedStatus.value.isEmpty &&
                allItemsCache.isEmpty &&
                items.isNotEmpty) {
              allItemsCache.assignAll(items.toList(growable: false));
            }

            final base = allItemsCache.isNotEmpty ? allItemsCache : items;

            final allCount = base.length;
            final upcomingCount =
                base
                    .where(
                      (e) =>
                          (e.status ?? '').toLowerCase().contains('upcoming') ||
                          (e.status ?? '').toLowerCase().contains('new launch'),
                    )
                    .length;
            final ongoingCount =
                base
                    .where(
                      (e) =>
                          (e.status ?? '').toLowerCase().contains('ongoing') ||
                          (e.status ?? '').toLowerCase().contains(
                            'under construction',
                          ),
                    )
                    .length;
            final completedCount =
                base
                    .where(
                      (e) =>
                          (e.status ?? '').toLowerCase().contains('completed'),
                    )
                    .length;

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    await projectController.refreshList();
                    await profileController.loadSellerProfile(widget.userId);
                  },
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildHeader(isLoadingProfile),
                      const SizedBox(height: 12),

                      // --- Featured developer + horizontal list (exclude current profile) ---
                      Obx(() {
                        final cityFilter =
                            selectedCity.value.trim().toLowerCase();

                        final developers =
                            profileController.items.where((d) {
                              // Only remove current user
                              return (d.id ?? '') != widget.userId;
                            }).toList();

                        if (developers.isEmpty) return const SizedBox.shrink();

                        final featured = developers.first;
                        final rest = developers;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const SizedBox(height: 8),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(
                            //     horizontal: 0.0,
                            //   ),
                            //   child: GestureDetector(
                            //     onTap: () async {
                            //       Get.to(
                            //         () => TopDeveloperProfileScreen(
                            //           userId: featured.id ?? '',
                            //           createdBy:
                            //               featured.id ?? featured.id ?? '',
                            //         ),

                            //         routeName: '/developer/${featured.id}',
                            //       );
                            //     },
                            //     child: Container(
                            //       width: 320,
                            //       padding: const EdgeInsets.all(16),
                            //       decoration: BoxDecoration(
                            //         color: Colors.white,
                            //         borderRadius: BorderRadius.circular(16),
                            //         border: Border.all(
                            //           color: Colors.grey.shade100,
                            //         ),
                            //         boxShadow: [
                            //           BoxShadow(
                            //             color: Colors.black.withOpacity(0.04),
                            //             blurRadius: 12,
                            //             offset: const Offset(0, 4),
                            //           ),
                            //         ],
                            //       ),
                            //       child: Column(
                            //         mainAxisSize: MainAxisSize.min,
                            //         children: [
                            //           /// Top Row
                            //           Row(
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.center,
                            //             children: [
                            //               /// Avatar
                            //               ClipRRect(
                            //                 borderRadius: BorderRadius.circular(
                            //                   48,
                            //                 ),
                            //                 child:
                            //                     featured.profilePic != null &&
                            //                             featured
                            //                                 .profilePic!
                            //                                 .isNotEmpty
                            //                         ? CachedNetworkImage(
                            //                           imageUrl:
                            //                               featured.profilePic!,
                            //                           width: 48,
                            //                           height: 48,
                            //                           fit: BoxFit.cover,
                            //                         )
                            //                         : Container(
                            //                           width: 48,
                            //                           height: 48,
                            //                           decoration: BoxDecoration(
                            //                             color: ColorRes.primary
                            //                                 .withOpacity(0.1),
                            //                             shape: BoxShape.circle,
                            //                           ),
                            //                           alignment:
                            //                               Alignment.center,
                            //                           child: Text(
                            //                             (featured.firstName ??
                            //                                     'D')[0]
                            //                                 .toUpperCase(),
                            //                             style: const TextStyle(
                            //                               fontSize: 15,
                            //                               fontWeight:
                            //                                   FontWeight.w600,
                            //                               color:
                            //                                   ColorRes.primary,
                            //                             ),
                            //                           ),
                            //                         ),
                            //               ),

                            //               const SizedBox(width: 14),

                            //               /// Name + Info
                            //               Expanded(
                            //                 child: Column(
                            //                   crossAxisAlignment:
                            //                       CrossAxisAlignment.start,
                            //                   children: [
                            //                     Text(
                            //                       featured.firstName?.capitalize
                            //                               ?.replaceAll(
                            //                                 '_',
                            //                                 ' ',
                            //                               ) ??
                            //                           featured
                            //                               .username
                            //                               ?.capitalize
                            //                               ?.replaceAll(
                            //                                 '_',
                            //                                 ' ',
                            //                               ) ??
                            //                           'Developer',
                            //                       maxLines: 1,
                            //                       overflow:
                            //                           TextOverflow.ellipsis,
                            //                       style: const TextStyle(
                            //                         fontSize: 14,
                            //                         fontWeight: FontWeight.w600,
                            //                         color: Color(0xFF1A1A1A),
                            //                       ),
                            //                     ),
                            //                     const SizedBox(height: 5),

                            //                     /// City Tag
                            //                     Container(
                            //                       padding:
                            //                           const EdgeInsets.symmetric(
                            //                             horizontal: 8,
                            //                             vertical: 3,
                            //                           ),
                            //                       decoration: BoxDecoration(
                            //                         color: ColorRes.primary
                            //                             .withOpacity(0.1),
                            //                         borderRadius:
                            //                             BorderRadius.circular(
                            //                               99,
                            //                             ),
                            //                       ),
                            //                       child: Text(
                            //                         featured.city ?? 'N/A',
                            //                         style: TextStyle(
                            //                           fontSize: 11,
                            //                           fontWeight:
                            //                               FontWeight.w500,
                            //                           color: ColorRes.primary,
                            //                         ),
                            //                       ),
                            //                     ),
                            //                   ],
                            //                 ),
                            //               ),
                            //             ],
                            //           ),

                            //           const SizedBox(height: 14),

                            //           Divider(
                            //             height: 1,
                            //             thickness: 0.5,
                            //             color: ColorRes.leadGreyColor
                            //                 .withOpacity(0.3),
                            //           ),

                            //           const SizedBox(height: 12),

                            //           /// Bottom Row
                            //           Row(
                            //             children: [
                            //               const Icon(
                            //                 Icons.work_outline_rounded,
                            //                 size: 13,
                            //                 color: Colors.grey,
                            //               ),
                            //               const SizedBox(width: 4),
                            //               Text(
                            //                 "${featured.totalExperience ?? 0}+ yrs exp.",
                            //                 style: TextStyle(
                            //                   fontSize: 12,
                            //                   color: Colors.grey.shade700,
                            //                   fontWeight: FontWeight.w500,
                            //                 ),
                            //               ),
                            //               const SizedBox(width: 10),
                            //               const Icon(
                            //                 Icons.location_on_outlined,
                            //                 size: 13,
                            //                 color: Colors.grey,
                            //               ),
                            //               const SizedBox(width: 4),
                            //               Expanded(
                            //                 child: Text(
                            //                   featured.city ?? 'N/A',
                            //                   maxLines: 1,
                            //                   overflow: TextOverflow.ellipsis,
                            //                   style: TextStyle(
                            //                     fontSize: 12,
                            //                     color: Colors.grey.shade700,
                            //                     fontWeight: FontWeight.w500,
                            //                   ),
                            //                 ),
                            //               ),
                            //               const SizedBox(width: 8),

                            //               /// CTA Button
                            //               TextButton(
                            //                 onPressed: () async {
                            //                   Get.to(
                            //                     () => TopDeveloperProfileScreen(
                            //                       userId: featured.id ?? '',
                            //                       createdBy:
                            //                           featured.id ??
                            //                           featured.id ??
                            //                           '',
                            //                     ),

                            //                     routeName:
                            //                         '/developer/${featured.id}',
                            //                   );
                            //                 },
                            //                 style: TextButton.styleFrom(
                            //                   backgroundColor: ColorRes.primary,
                            //                   foregroundColor: Colors.white,
                            //                   padding:
                            //                       const EdgeInsets.symmetric(
                            //                         horizontal: 14,
                            //                         vertical: 6,
                            //                       ),
                            //                   minimumSize: Size.zero,
                            //                   tapTargetSize:
                            //                       MaterialTapTargetSize
                            //                           .shrinkWrap,
                            //                   shape: RoundedRectangleBorder(
                            //                     borderRadius:
                            //                         BorderRadius.circular(8),
                            //                   ),
                            //                 ),
                            //                 child: const Text(
                            //                   "View profile",
                            //                   style: TextStyle(
                            //                     fontSize: 12,
                            //                     fontWeight: FontWeight.w500,
                            //                   ),
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // const SizedBox(height: 12),
                            if (rest.isNotEmpty) ...[
                              Text(
                                "Developers",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: ColorRes.textPrimary,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 140,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  separatorBuilder:
                                      (context, index) => SizedBox(width: 12),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 0,
                                  ),
                                  itemCount: rest.length,
                                  itemBuilder: (context, i) {
                                    final d = rest[i];
                                    return _DeveloperMiniCard(featured: d);
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ],
                        );
                      }),

                      // const SizedBox(height: 8),
                      Text(
                        "Developer Projects",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: ColorRes.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _StatusTabs(
                        selectedStatus: selectedStatus.value,
                        all: allCount,
                        upcoming: upcomingCount,
                        ongoing: ongoingCount,
                        completed: completedCount,
                        onSelect: (status) async {
                          selectedStatus.value = status;
                          log(
                            'status: $status   selectedStatus.value: ${selectedStatus.value}',
                          );
                          if (status.isEmpty) {
                            projectController.builderStatus.value = '';
                            projectController.clearFilter('status');
                            await projectController.applyFilters({
                              'created_by': widget.createdBy,
                            });
                          } else {
                            await projectController.applyFilters({
                              'status': status.toLowerCase(),
                              'created_by': widget.createdBy,
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      if (projectController.isLoading.value && items.isEmpty)
                        const BuilderProjectListShimmer()
                      else if (items.isEmpty &&
                          !projectController.isLoading.value)
                        SizedBox(
                          height: 280,
                          child: Center(
                            child: Text(
                              'No projects found',
                              style: TextStyle(
                                color: ColorRes.leadGreyColor.shade700,
                                fontWeight: AppFontWeights.medium,
                              ),
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              (selectedStatus.value.isEmpty
                                  ? (allItemsCache.isNotEmpty
                                      ? allItemsCache.length
                                      : items.length)
                                  : items.length),
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final displayItems =
                                selectedStatus.value.isEmpty
                                    ? (allItemsCache.isNotEmpty
                                        ? allItemsCache
                                        : items)
                                    : items;
                            final data = displayItems[index];
                            final img =
                                (data.mediaGallery?.images.isNotEmpty ?? false)
                                    ? data.mediaGallery!.images.first
                                    : '';
                            return GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => ProjectDetailsScreen(
                                    projectItem: data,
                                    isBuilder: false,
                                  ),
                                  routeName: '/project/${data.id}',
                                );
                              },
                              child: BuilderProjectCard(
                                project: data,
                                imageUrl: img,
                                developersName:
                                    data.projectContactInfo?.name ?? 'Unknown',
                                projectName: data.projectName ?? 'N/A',
                                location: data.address ?? '',
                                price: data.getPriceRange(),
                                propertySize:
                                    data.projectSize?.totalBuildings
                                        ?.toString() ??
                                    '',
                                height: 410,
                                width: double.infinity,
                                forHome: true,
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                const UnifiedComparisonFloatingButton(bottom: 16),
              ],
            );
          }),
        ),
      ),
    );
  }

  void _goToDashboard() {
    if (Navigator.of(context).canPop()) {
      Get.back();
      return;
    }
    Get.offAllNamed('/dashboard', predicate: (route) => false);
  }

  @override
  void dispose() {
    if (Get.isRegistered<TopBuilderController>(tag: _tag)) {
      Get.delete<TopBuilderController>(tag: _tag, force: true);
    }
    if (Get.isRegistered<ProjectWizardController>(tag: _tag)) {
      Get.delete<ProjectWizardController>(tag: _tag, force: true);
    }
    super.dispose();
  }

  Widget _buildHeader(bool isLoading) {
    if (isLoading || profileController.userModel.value == null) {
      return _HeaderShimmer();
    }
    final user = profileController.userModel.value;
    final nameParts = [
      user?.firstName?.trim() ?? '',
      user?.lastName?.trim() ?? '',
    ].where((e) => e.isNotEmpty).toList(growable: false);
    final name =
        nameParts.isNotEmpty
            ? nameParts.join(' ')
            : (user?.username ?? 'Unknown');
    final cityParts = [
      user?.city?.trim() ?? '',
      user?.state?.trim() ?? '',
    ].where((e) => e.isNotEmpty).toList(growable: false);
    final cityState = cityParts.isNotEmpty ? cityParts.join(', ') : '';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 2,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomImage(
              type:
                  (user?.profilePic?.isNotEmpty ?? false)
                      ? CustomImageType.network
                      : CustomImageType.asset,
              src:
                  (user?.profilePic?.isNotEmpty ?? false)
                      ? user!.profilePic!
                      : imageOfNotAvailable,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: AppFontWeights.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (cityState.isNotEmpty) ...[
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: ColorRes.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          cityState,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: AppFontWeights.medium,
                            color: ColorRes.leadGreyColor.shade700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ColorRes.leadGreyColor.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: ColorRes.leadGreyColor.shade300,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Total Projects: ${allItemsCache.isNotEmpty ? Formatter.formatNumber(allItemsCache.length) : Formatter.formatNumber(projectController.items.length)}',
                        style: TextStyle(
                          fontSize: 10.2,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.leadGreyColor.shade700,
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ColorRes.leadGreyColor.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: ColorRes.leadGreyColor.shade300,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Experience: ${user?.totalExperience ?? 0}',
                        style: TextStyle(
                          fontSize: 10.2,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.leadGreyColor.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _HeaderShimmer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 18, width: 160, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(height: 12, width: 120, color: Colors.white),
                  const SizedBox(height: 10),
                  Container(height: 26, width: 140, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusTabs extends StatelessWidget {
  final String selectedStatus;
  final int all;
  final int upcoming;
  final int ongoing;
  final int completed;
  final ValueChanged<String> onSelect;

  const _StatusTabs({
    required this.selectedStatus,
    required this.all,
    required this.upcoming,
    required this.ongoing,
    required this.completed,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _chip(
            label: 'All ($all)',
            selected: selectedStatus.isEmpty,
            onTap: () => onSelect(''),
          ),
          const SizedBox(width: 8),
          _chip(
            label: 'Upcoming ($upcoming)',
            selected: selectedStatus.toLowerCase() == 'upcoming',
            onTap: () => onSelect('Upcoming'),
          ),
          const SizedBox(width: 8),
          _chip(
            label: 'Ongoing ($ongoing)',
            selected: selectedStatus.toLowerCase() == 'ongoing',
            onTap: () => onSelect('Ongoing'),
          ),
          const SizedBox(width: 8),
          _chip(
            label: 'Completed ($completed)',
            selected: selectedStatus.toLowerCase() == 'completed',
            onTap: () => onSelect('Completed'),
          ),
        ],
      ),
    );
  }

  /// ✅ CHIP WIDGET
  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? ColorRes.primary.withOpacity(0.12) : ColorRes.white,
          borderRadius: BorderRadius.circular(24),
          border:
              selected ? Border.all(color: ColorRes.primary, width: 1.4) : null,

          boxShadow:
              selected
                  ? [
                    BoxShadow(
                      color: ColorRes.primary.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              Icon(Icons.check_circle, size: 14, color: ColorRes.primary),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: AppFontWeights.semiBold,
                color:
                    selected
                        ? ColorRes.primary
                        : ColorRes.leadGreyColor.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuilderProjectCardShimmer extends StatelessWidget {
  const BuilderProjectCardShimmer({super.key});

  Widget _box({
    double height = 12,
    double width = double.infinity,
    double radius = 6,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorRes.leadGreyColor.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Project Name + Date
                  Row(
                    children: [
                      Expanded(child: _box(height: 14)),
                      const SizedBox(width: 10),
                      _box(height: 18, width: 70),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// Location
                  _box(width: 160),

                  const SizedBox(height: 14),

                  /// Developer Card
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _box(width: double.infinity),
                        const SizedBox(height: 8),
                        _box(width: 180),
                        const SizedBox(height: 6),
                        _box(width: 140),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// Configuration Row
                  Row(
                    children: [
                      Expanded(child: _box(height: 28)),
                      const SizedBox(width: 6),
                      Expanded(child: _box(height: 28)),
                      const SizedBox(width: 6),
                      Expanded(child: _box(height: 28)),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// Price + Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _box(width: 90),
                          const SizedBox(height: 6),
                          _box(width: 120, height: 16),
                        ],
                      ),
                      Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuilderProjectListShimmer extends StatelessWidget {
  const BuilderProjectListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => const BuilderProjectCardShimmer(),
    );
  }
}

class _DeveloperMiniCard extends StatelessWidget {
  final BuilderItem featured;

  const _DeveloperMiniCard({Key? key, required this.featured})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final rating = builder.userRating ?? 0.0;
    return GestureDetector(
      onTap: () async {
        Get.to(
          () => TopDeveloperProfileScreen(
            userId: featured.id ?? '',
            createdBy: featured.id ?? featured.id ?? '',
          ),
          routeName: '/developer/${featured.id}',
        );
      },
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Top Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Avatar
                ClipRRect(
                  borderRadius: BorderRadius.circular(48),
                  child:
                      featured.profilePic != null &&
                              featured.profilePic!.isNotEmpty
                          ? CachedNetworkImage(
                            imageUrl: featured.profilePic!,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          )
                          : Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: ColorRes.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              (featured.firstName ?? 'D')[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: ColorRes.primary,
                              ),
                            ),
                          ),
                ),

                const SizedBox(width: 14),

                /// Name + Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        featured.firstName?.capitalize?.replaceAll('_', ' ') ??
                            featured.username?.capitalize?.replaceAll(
                              '_',
                              ' ',
                            ) ??
                            'Developer',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 5),

                      /// City Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: ColorRes.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          featured.city ?? 'N/A',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: ColorRes.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Divider(
              height: 1,
              thickness: 0.5,
              color: ColorRes.leadGreyColor.withOpacity(0.3),
            ),

            const SizedBox(height: 12),

            /// Bottom Row
            Row(
              children: [
                const Icon(
                  Icons.work_outline_rounded,
                  size: 13,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  "${featured.totalExperience ?? 0}+ yrs exp.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.location_on_outlined,
                  size: 13,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    featured.city ?? 'N/A',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                /// CTA Button
                TextButton(
                  onPressed: () async {
                    Get.to(
                      () => TopDeveloperProfileScreen(
                        userId: featured.id ?? '',
                        createdBy: featured.id ?? featured.id ?? '',
                      ),

                      routeName: '/developer/${featured.id}',
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: ColorRes.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "View profile",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
