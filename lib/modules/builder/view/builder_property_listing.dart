import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';
import 'package:housing_flutter_app/app/manager/project_compare_manager.dart';
import 'package:housing_flutter_app/app/widgets/snack_bar/custom_snackbar.dart';
import 'package:housing_flutter_app/data/network/builder/model/builder_model.dart';
import 'package:housing_flutter_app/modules/builder/controller/project_controller.dart';
import 'package:housing_flutter_app/modules/builder/view/project_detail/project_detail.dart';

import '../../../app/constants/size_manager.dart';
import '../../../app/manager/property/property_pricemanager.dart';
import '../../../app/manager/property_highlight_manager.dart';

// import '../../../data/network/builder/model/builder_projectModel.dart';
import '../../../data/database/secure_storage_service.dart';
import '../../../widgets/bar/filter_bar/filter_chip_bar.dart';
import '../../propert_detail/view/property_details.dart';
import '../../reseller/view/listing/property_listing.dart';
import '../../reseller/widget/reseller_filter/resseller_property_filter.dart';
import '../../saved_property/controllers/property_favorite_controller.dart';
import '../controller/builder_form_controller.dart';
import 'builder_form_screen.dart';

class BuilderPropertyListing extends StatefulWidget {
  const BuilderPropertyListing({Key? key}) : super(key: key);

  @override
  State<BuilderPropertyListing> createState() => _BuilderPropertyListingState();
}

class _BuilderPropertyListingState extends State<BuilderPropertyListing> {
  final RxList<String> selectedPropertyIds = <String>[].obs;
  final RxMap<String, String> selectedFilters = <String, String>{}.obs;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProjectWizardController>(tag: "builder");
    final projectController = Get.put(ProjectController());
    return Scaffold(
      backgroundColor: ColorRes.leadGreyColor.shade100,
      appBar: AppBar(
        title: Text(
          'My Project',
          style: TextStyle(fontWeight: AppFontWeights.bold),
        ),
        backgroundColor: ColorRes.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () async {
              final result = await Get.to(() => ResellerPropertyFilter());

              if (result != null) {
                // Use the filter result
                final newFilter = convertFiltersToString(result);
                final user = await SecureStorage.getUserData();
                final userId = user?.user?.id;

                if (userId != null && userId.isNotEmpty) {
                  newFilter["created_by"] = userId;
                  log("New Filter ${newFilter}");
                  await controller.applyFilters(newFilter);
                  selectedFilters
                    ..clear()
                    ..addAll(newFilter);

                  controller.applyFilters(
                    Map<String, String>.from(selectedFilters),
                  );
                  print(
                    "Filter Project applied: $result   t   ${selectedFilters.value}",
                  );
                  // Example: {'bhk': 5, 'city': 'Surat', 'state': 'Gujarat'}
                }
              }
            },
          ),
        ],
      ),
      // body: Obx(() {
      //   if (controller.isLoading.value && controller.items.isEmpty) {
      //     return const Center(child: CircularProgressIndicator());
      //   }
      //
      //   if (!controller.isLoading.value && controller.items.isEmpty) {
      //     return const Center(child: Text('No projects found'));
      //   }
      //
      //   return ListView.builder(
      //     itemCount: controller.items.length,
      //     itemBuilder: (context, index) {
      //       final ProjectItem data = controller.items[index];
      //
      //       return Padding(
      //         padding: const EdgeInsets.all(12),
      //         child: GestureDetector(
      //           onTap: () {
      //             Get.to(() => ProjectDetailsScreen(projectItem: data));
      //           },
      //           child: BuilderProjectCard(
      //             project: data,
      //             developersName: data.projectContactInfo?.name ?? 'Unknown',
      //             imageUrl:
      //                 (data.mediaGallery?.images?.isNotEmpty ?? false)
      //                     ? data.mediaGallery!.images.first
      //                     : IMGRes.home3,
      //             projectName:
      //                 (data.projectName ?? '').isNotEmpty
      //                     ? data.projectName!
      //                     : 'N/A',
      //             location:
      //                 (data.address ?? '').isNotEmpty
      //                     ? data.address!
      //                     : 'Not specified',
      //             price: '₹500',
      //             propertySize:
      //                 data.projectSize?.totalBuildings?.toString() ?? '',
      //           ),
      //         ),
      //       );
      //     },
      //   );
      // }),
      body: SafeArea(
        child: Column(
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
                priceRangeFormatter: (min, max) => formatPriceRange(min, max),
              );
            }),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.items.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!controller.isLoading.value && controller.items.isEmpty) {
                  return const Center(child: Text('No projects found'));
                }

                return ListView.builder(
                  itemCount: controller.items.length,
                  itemBuilder: (context, index) {
                    final data = controller.items[index];
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: GestureDetector(
                        onTap: () {
                          log("Project Item Tapped: ${data.toJson()}");

                          Get.to(() => ProjectDetailsScreen(projectItem: data));
                        },
                        child: BuilderProjectCard(
                          project: data,
                          developersName:
                              data.projectContactInfo?.name ?? 'Unknown',
                          imageUrl:
                              (data.mediaGallery?.images?.isNotEmpty ?? false)
                                  ? data.mediaGallery!.images.first
                                  : IMGRes.home3,
                          projectName:
                              (data.projectName ?? '').isNotEmpty
                                  ? data.projectName!
                                  : 'N/A',
                          location:
                              (data.address ?? '').isNotEmpty
                                  ? data.address!
                                  : 'Not specified',
                          price: data.getPriceRange(),
                          propertySize:
                              data.projectSize?.totalBuildings?.toString() ??
                              '',
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class BuilderProjectCard extends StatelessWidget {
  final bool forHome;
  final ProjectItem project;
  final String imageUrl;
  final String projectName;
  final String location;
  final String developersName;
  final String propertySize;
  final String price;
  final double height;
  final double width;

  const BuilderProjectCard({
    Key? key,
    required this.imageUrl,
    required this.projectName,
    required this.location,
    required this.developersName,
    required this.propertySize,
    required this.price,
    this.height = 410,
    this.width = double.infinity,
    required this.project,
    this.forHome = false,
  }) : super(key: key);

  String _getConfigurationText() {
    if (project.configuration.isEmpty) return '';

    final bhkList =
        project.configuration.map((c) => '${c.bhk} BHK').toSet().toList();
    if (bhkList.length > 2) {
      return '${bhkList.first} - ${bhkList.last}';
    }
    return bhkList.join(', ');
  }

  Color _getStatusColor() {
    switch (project.status.toLowerCase()) {
      case 'ongoing':
      case 'under construction':
        return ColorRes.orangeColor;
      case 'completed':
        return ColorRes.green;
      case 'upcoming':
      case 'new launch':
        return ColorRes.blueColor;
      default:
        return ColorRes.leadGreyColor;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProjectWizardController>();
    final PropertyFavoriteController favoriteController =
        Get.find<PropertyFavoriteController>();
    final compare = Get.put(ProjectCompareManager());
    final configText = _getConfigurationText();
    bool isFavorite = false;

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
        border: Border.all(
          color: ColorRes.leadGreyColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Stack(
              children: [
                Image.network(
                  imageUrl ??
                      'https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg',
                  height: 140,
                  width: width,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg',
                      height: 140,
                      width: width,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.3, 1.0],
                      ),
                    ),
                  ),
                ),

                // Status Badge
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      project.status.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppFontSizes.caption,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                  ),
                ),
                // Favorite & Compare Buttons (Only for home view, not for builder's own projects)
                if (forHome)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Compare toggle
                        GestureDetector(
                          onTap: () {
                            compare.toggle(project, max: 2);
                          },
                          child: Obx(() {
                            final selected = compare.isSelected(project.id);
                            return CircleAvatar(
                              backgroundColor:
                                  selected ? ColorRes.primary : ColorRes.white,
                              radius: 16,
                              child: Icon(
                                Icons.compare_arrows,
                                color:
                                    selected
                                        ? ColorRes.white
                                        : ColorRes.primary,
                                size: 18,
                              ),
                            );
                          }),
                        ),
                        const SizedBox(width: 8),
                        // Favorite toggle
                        GestureDetector(
                          onTap: () {
                            favoriteController.toggleFavorite(project.id);
                          },
                          child: Obx(() {
                            isFavorite = favoriteController.favorites.contains(
                              project.id,
                            );
                            return CircleAvatar(
                              backgroundColor: ColorRes.white,
                              radius: 16,
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    isFavorite
                                        ? ColorRes.error
                                        : ColorRes.leadGreyColor,
                                size: 18,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                // RERA Badge
                if (!forHome) ...[
                  if (project.reraId.isNotEmpty)
                    Positioned(
                      top: 10,
                      right: forHome ? 8 : 52,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: ColorRes.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_outlined,
                              size: 12,
                              color: ColorRes.green[700],
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'RERA',
                              style: TextStyle(
                                color: ColorRes.green[700],
                                fontSize: AppFontSizes.mini,
                                fontWeight: AppFontWeights.semiBold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
                if (!forHome) ...[
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      elevation: 3,
                      child: InkWell(
                        onTap: () async {
                          final result = await Get.to(
                            () => CreateProjectScreen(isFromEdit: true),
                            arguments: project.id,
                            binding: BindingsBuilder(() async {
                              final wizardController = Get.put(
                                ProjectWizardController(isBuilderView: true),
                              );
                              await wizardController.updateProjectData(
                                project.toAddProjectModel(),
                              );

                              debugPrint(
                                "Project For Edit: ${project.toAddProjectModel().configurations.map((e) => e.toJson())}",
                              );
                            }),
                          );

                          if (result == true) {
                            controller.loadInitial();
                          }
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: ColorRes.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project Name with Possession
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              projectName,
                              style: TextStyle(
                                fontSize: AppFontSizes.body,

                                fontWeight: AppFontWeights.semiBold,
                                color: ColorRes.textPrimary,
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (project.possessionDate != null &&
                              project.possessionDate!.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: ColorRes.primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.event_available,
                                    size: 10,
                                    color: ColorRes.primary,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    _formatDate(
                                      DateTime.tryParse(
                                        project.possessionDate!,
                                      )!,
                                    ),
                                    style: TextStyle(
                                      fontSize: AppFontSizes.mini,
                                      color: ColorRes.primary,
                                      fontWeight: AppFontWeights.medium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Location
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              location,
                              style: TextStyle(
                                fontSize: AppFontSizes.caption,
                                color: ColorRes.leadGreyColor.shade700,
                                fontWeight: AppFontWeights.regular,
                                height: 1.2,
                              ),
                              maxLines: 1,

                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      // Developer Info Card
                      if (!forHome) ...[
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: ColorRes.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: ColorRes.primary.withOpacity(0.3),
                              width: 0.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.business,
                                    size: 14,
                                    color: ColorRes.primary,
                                  ),
                                  const SizedBox(width: 7),
                                  Expanded(
                                    child: Text(
                                      developersName,
                                      style: TextStyle(
                                        fontSize: AppFontSizes.small,
                                        color: ColorRes.primary,
                                        fontWeight: AppFontWeights.semiBold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 7),
                              Row(
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    size: 14,
                                    color: ColorRes.textColor.withOpacity(0.6),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      project.projectContactInfo?.email ??
                                          'No Email',
                                      style: TextStyle(
                                        fontSize: AppFontSizes.extraSmall,
                                        color: ColorRes.textColor,
                                        fontWeight: AppFontWeights.medium,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone_outlined,
                                    size: 14,
                                    color: ColorRes.textColor.withOpacity(0.6),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      project.projectContactInfo?.phone ??
                                          'No Phone',
                                      style: TextStyle(
                                        fontSize: AppFontSizes.extraSmall,
                                        color: ColorRes.textColor,
                                        fontWeight: AppFontWeights.medium,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        // Configuration and Units
                        if (project.projectSize?.totalUnits != null &&
                            (configText.isNotEmpty ||
                                project.projectSize!.totalUnits > 0))
                          Row(
                            children: [
                              if (configText.isNotEmpty) ...[
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorRes.blueColor.withOpacity(
                                        0.12,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.home_outlined,
                                          size: 14,
                                          color: ColorRes.blueColor[700],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          configText.split(",").first,
                                          style: TextStyle(
                                            fontSize: AppFontSizes.extraSmall,
                                            color: ColorRes.blueColor[700],
                                            fontWeight: AppFontWeights.semiBold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                              ],
                              Expanded(
                                child: Container(
                                  width: 80,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorRes.textSecondary.withOpacity(
                                      0.08,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.business,
                                        size: 14,
                                        color: ColorRes.textSecondary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        propertySize,
                                        style: TextStyle(
                                          fontSize: AppFontSizes.extraSmall,
                                          color: ColorRes.textSecondary,
                                          fontWeight: AppFontWeights.semiBold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              if (project.projectSize?.totalUnits != null &&
                                  project.projectSize!.totalUnits > 0)
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.apartment_outlined,
                                          size: 14,
                                          color: ColorRes.orangeColor[700],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${project.projectSize?.totalUnits ?? 0} Units',
                                          style: TextStyle(
                                            fontSize: AppFontSizes.extraSmall,
                                            color: ColorRes.orangeColor[700],
                                            fontWeight: AppFontWeights.semiBold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      ] else ...[
                        SizedBox.shrink(),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Bottom Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Starting from',
                              style: TextStyle(
                                fontSize: AppFontSizes.extraSmall,
                                color: ColorRes.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              price,
                              style: TextStyle(
                                fontSize: AppFontSizes.body,
                                fontWeight: AppFontWeights.semiBold,
                                color: ColorRes.primary,

                                height: 1.1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: ColorRes.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          size: 15,
                          color: Colors.white,
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
