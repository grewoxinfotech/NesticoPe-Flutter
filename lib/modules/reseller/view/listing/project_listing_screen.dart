import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/builder/model/builder_model.dart';
import 'package:housing_flutter_app/modules/reseller/view/listing/property_listing.dart';
import 'package:housing_flutter_app/utils/shimmer/reseller/entity_screen/reseller_entity_list_screen_shimmer.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../data/database/secure_storage_service.dart';
import '../../../../widgets/bar/filter_bar/filter_chip_bar.dart';
import '../../../builder/controller/project_controller.dart';
import '../../../builder/view/project_detail/project_detail.dart';
import '../../../builder/view/widget/project_filter_screen.dart';
import '../../../propert_detail/view/property_details.dart';
import '../../../property/controllers/share_property_controller.dart';
import '../../../seller/module/lead_screen/views/lead_screen_enhanced.dart';
import '../../controller/dashborad_controller/dashboard_controller.dart';
import '../../controller/project/reseller_project_controller.dart';

// Import your necessary files
// import 'package:your_app/controllers/...';
// import 'package:your_app/utils/...';
// import 'package:your_app/widgets/...';

class ProjectListingScreen extends StatefulWidget {
  ProjectListingScreen({Key? key}) : super(key: key);

  @override
  State<ProjectListingScreen> createState() => _ProjectListingScreenState();
}

// class _ProjectListingScreenState extends State<ProjectListingScreen> {
//   final DashboardController controller = Get.put(DashboardController());
//   // final ShareProjectController shareProjectController = Get.put(
//   //   ShareProjectController(),
//   // );
//
//   /// ✅ USE RESELLER CONTROLLER
//   late final ResellerProjectController projectController;
//   late final resellerId;
//
//   // Multi-select state
//   final RxBool isSelectionMode = false.obs;
//   final RxList<String> selectedProjectIds = <String>[].obs;
//   final RxMap<String, String> selectedFilters = <String, String>{}.obs;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       _loadData();
//
//       // await fetchResellerAssignProject();
//     });
//   }
//
//   Future<void> _loadData() async {
//     final user = await SecureStorage.getUserData();
//     if (user != null) {
//       resellerId = user.user?.id;
//     }
//     projectController = Get.put(
//       ResellerProjectController(resellerId: resellerId),
//     );
//   }
//
//   /// ✅ Assigned reseller projects
//   // Future<void> fetchResellerAssignProject() async {
//   //   try {
//   //     final user = await SecureStorage.getUserData();
//   //     final userId = user?.user?.id;
//   //
//   //     if (userId != null && userId.isNotEmpty) {
//   //       final filter = {"assignedTo": userId};
//   //
//   //       log("Applying reseller assigned filter → $filter");
//   //
//   //       await projectController.applyFilters(filter);
//   //     } else {
//   //       print("⚠️ User ID is null or empty");
//   //     }
//   //   } catch (e) {
//   //     print("❌ Error fetching reseller projects: $e");
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorRes.white,
//
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(kToolbarHeight),
//         child: AppBar(
//           backgroundColor: ColorRes.white,
//           elevation: 0,
//           automaticallyImplyLeading: false,
//           title: Text(
//             'Project Listing',
//             style: TextStyle(
//               color: ColorRes.textColor,
//               fontWeight: AppFontWeights.bold,
//               fontSize: getResponsiveFontSize(
//                 context,
//                 AppFontSizes.large,
//                 AppFontSizes.body,
//               ),
//             ),
//           ),
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(1),
//             child: Container(color: ColorRes.leadGreyColor[200], height: 1),
//           ),
//           actions: [
//             GestureDetector(
//               onTap: () async {
//                 if (!Get.isRegistered<ProjectController>())
//                   Get.put(ProjectController());
//                 // final result = await Get.to(() => ResellerProjectFilter());
//                 final result = await Get.to<Map<String, String>>(
//                   () => ProjectFilterScreen(
//                     initialFilters: selectedFilters.value,
//                     onApply: (filterData) {
//                       // Return selected filters to previous screen
//                       Get.back(result: filterData);
//                     },
//                   ),
//                   transition: Transition.downToUp,
//                   // optional for sheet-like slide-up effect
//                   duration: const Duration(milliseconds: 300),
//                 );
//
//                 if (result != null) {
//                   final newFilter = convertFiltersToString(result);
//                   final user = await SecureStorage.getUserData();
//                   final userId = user?.user?.id;
//
//                   if (userId != null && userId.isNotEmpty) {
//                     newFilter["assignedTo"] = userId;
//
//                     log("Applying filter → $newFilter");
//
//                     selectedFilters
//                       ..clear()
//                       ..addAll(newFilter);
//
//                     await projectController.applyFilters(
//                       Map<String, String>.from(selectedFilters),
//                     );
//                   }
//                 }
//               },
//               child: const Icon(Icons.filter_list),
//             ),
//             const SizedBox(width: 8),
//           ],
//         ),
//       ),
//
//       body: Column(
//         children: [
//           /// Active Filter Chips
//           Obx(() {
//             return FilterChipsBar(
//               filters: selectedFilters.value,
//               onClearAll: () {
//                 selectedFilters.clear();
//                 projectController.clearAllFilters();
//               },
//               onRemoveFilter: (key) {
//                 selectedFilters.remove(key);
//                 projectController.applyFilters(
//                   Map<String, String>.from(selectedFilters),
//                 );
//               },
//               priceRangeFormatter: (min, max) => formatPriceRange(min, max),
//             );
//           }),
//
//           /// Projects Grid
//           Expanded(
//             child: Obx(() {
//               if (projectController.isLoading.value &&
//                   projectController.items.isEmpty) {
//                 return Center(
//                   child: CircularProgressIndicator(color: ColorRes.primary),
//                 );
//               }
//
//               if (!projectController.isLoading.value &&
//                   projectController.items.isEmpty) {
//                 return const Center(child: Text("No Listing Yet."));
//               }
//
//               return NotificationListener<ScrollEndNotification>(
//                 onNotification: (scrollEnd) {
//                   final metrics = scrollEnd.metrics;
//                   if (metrics.atEdge && metrics.pixels != 0) {
//                     projectController.loadMore();
//                   }
//                   return false;
//                 },
//                 child: RefreshIndicator(
//                   onRefresh: projectController.refreshResellerProjects,
//                   child: ProjectsGrid(
//                     isSelectionMode: isSelectionMode,
//                     selectedProjectIds: selectedProjectIds,
//                     resellerProjectController: projectController,
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _ProjectListingScreenState extends State<ProjectListingScreen> {
  final DashboardController controller = Get.put(DashboardController());

  /// ✅ USE RESELLER CONTROLLER - Make it nullable initially
  ResellerProjectController? projectController;
  String? resellerId;

  // Multi-select state
  final RxBool isSelectionMode = false.obs;
  final RxList<String> selectedProjectIds = <String>[].obs;
  final RxMap<String, String> selectedFilters = <String, String>{}.obs;
  final RxBool isInitialized = false.obs; // Add this to track initialization

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadData();
    });
  }

  Future<void> _loadData() async {
    final user = await SecureStorage.getUserData();
    if (user != null) {
      resellerId = user.user?.id;
    }
    projectController = Get.put(
      ResellerProjectController(resellerId: resellerId ?? ''),
    );
    isInitialized.value = true; // Mark as initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: ColorRes.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Project Listing',
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
            GestureDetector(
              onTap: () async {
                if (!Get.isRegistered<ProjectController>())
                  Get.put(ProjectController());
                // final result = await Get.to(() => ResellerProjectFilter());
                final result = await Get.to<Map<String, String>>(
                  () => ProjectFilterScreen(
                    initialFilters: selectedFilters.value,
                    onApply: (filterData) {
                      filterData.removeWhere((key, value) => ( value == 'false'),);
                      Get.back(result: filterData);
                    },
                  ),
                  transition: Transition.downToUp,
                  // optional for sheet-like slide-up effect
                  duration: const Duration(milliseconds: 300),
                );

                if (result != null) {
                  final newFilter = convertFiltersToString(result);
                  final user = await SecureStorage.getUserData();
                  final userId = user?.user?.id;

                  if (userId != null && userId.isNotEmpty) {
                    newFilter["assignedTo"] = userId;

                    log("Applying filter → $newFilter");

                    selectedFilters
                      ..clear()
                      ..addAll(newFilter);

                    await projectController?.applyFilters(
                      Map<String, String>.from(selectedFilters),
                    );
                  }
                }
              },
              child: const Icon(Icons.filter_list),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),

      body: Obx(() {
        // Check if controller is initialized
        if (!isInitialized.value || projectController == null) {
          return Center(
            child: CircularProgressIndicator(color: ColorRes.primary),
          );
        }

        return Column(
          children: [
            /// Active Filter Chips
            FilterChipsBar(
              filters: selectedFilters.value,
              onClearAll: () {
                selectedFilters.clear();
                projectController!.clearAllFilters();
              },
              onRemoveFilter: (key) {
                selectedFilters.remove(key);
                projectController!.applyFilters(
                  Map<String, String>.from(selectedFilters),
                );
              },
              priceRangeFormatter: (min, max) => formatPriceRange(min, max),
            ),

            /// Projects Grid
            Expanded(
              child: Obx(() {
                if (projectController!.isLoading.value &&
                    projectController!.items.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(color: ColorRes.primary),
                  );
                }

                if (!projectController!.isLoading.value &&
                    projectController!.items.isEmpty) {
                  return const Center(child: Text("No Listing Yet."));
                }

                return NotificationListener<ScrollEndNotification>(
                  onNotification: (scrollEnd) {
                    final metrics = scrollEnd.metrics;
                    if (metrics.atEdge && metrics.pixels != 0) {
                      projectController!.loadMore();
                    }
                    return false;
                  },
                  child: RefreshIndicator(
                    onRefresh: projectController!.refreshResellerProjects,
                    child: ProjectsGrid(
                      isSelectionMode: isSelectionMode,
                      selectedProjectIds: selectedProjectIds,
                      resellerProjectController: projectController!,
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}

// Import your necessary files
// import 'package:your_app/controllers/...';
// import 'package:your_app/models/project_model.dart';
// import 'package:your_app/widgets/...';

class ProjectsGrid extends StatelessWidget {
  final RxBool isSelectionMode;
  final RxList<String> selectedProjectIds;
  final ResellerProjectController resellerProjectController;

  const ProjectsGrid({
    Key? key,
    required this.isSelectionMode,
    required this.selectedProjectIds,
    required this.resellerProjectController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Loading state
      if (resellerProjectController.isLoading.value &&
          resellerProjectController.items.isEmpty) {
        return ResellerEntityListScreenShimmer();
      }

      // Empty state
      if (resellerProjectController.items.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: ColorRes.leadGreyColor[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No Projects found',
                style: TextStyle(
                  fontSize: AppFontSizes.large,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.leadGreyColor[600],
                ),
              ),
              const SizedBox(height: 8),
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

      // List
      return Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.separated(
          itemCount: resellerProjectController.items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final project = resellerProjectController.items[index];

            return ProjectCard(
              key: ValueKey(project.id),
              project: project,
              isSelected: selectedProjectIds.contains(project.id),
              isSelectionMode: isSelectionMode.value,
            );
          },
        ),
      );
    });
  }
}

/// Project Card Widget
class ProjectCard extends StatelessWidget {
  final ProjectItem project;
  final bool isSelected;
  final bool isSelectionMode;

  const ProjectCard({
    Key? key,
    required this.project,
    required this.isSelected,
    required this.isSelectionMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SharePropertyController controller =
        Get.find<SharePropertyController>();
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
          Get.to(
            () => ProjectDetailsScreen(projectId: project.id, isBuilder: true),
          );
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
              /// Image Section
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(11),
                    ),
                    child: _buildProjectImage(),
                  ),

                  /// (Optional) Selection Overlay
                  if (isSelectionMode)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: isSelected ? ColorRes.primary : ColorRes.white,
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
                                ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                                : null,
                      ),
                    ),
                ],
              ),

              /// Content Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Title + Action
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              project.projectName ?? 'Unnamed Project',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: AppFontSizes.bodyMedium,
                                fontWeight: AppFontWeights.semiBold,
                                color: ColorRes.textColor,
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () async {
                              await controller.getPropertyLinkByIdInReseller(
                                project.id ?? '',
                              );
                            },
                            child: const Icon(Icons.share, size: 16),
                          ),
                        ],
                      ),

                      /// Location
                      Text(
                        project.location ?? 'Location not available',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: AppFontSizes.caption,
                          color: ColorRes.leadGreyColor[600],
                          height: 1.3,
                        ),
                      ),

                      /// Amenities / Meta (placeholder like facilities)
                      Row(
                        children: [
                          Text(
                            'Commissions: ',
                            style: TextStyle(
                              fontSize: AppFontSizes.caption,
                              color: ColorRes.leadGreyColor[600],
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            project.getCommisionRange() ??
                                'Residential Project',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: AppFontSizes.small,
                              color: ColorRes.success,
                              fontWeight: AppFontWeights.bold,
                            ),
                          ),
                        ],
                      ),

                      /// Price + CTA
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              project.getPriceRange(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: AppFontSizes.body,
                                fontWeight: AppFontWeights.bold,
                                color: ColorRes.textColor,
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

  /// Image Builder
  Widget _buildProjectImage() {
    final images = project.mediaGallery?.images;
    final imageUrl =
        (images != null && images.isNotEmpty) ? images.first : null;

    return Image.network(
      imageUrl ?? 'https://via.placeholder.com/150',
      width: 110,
      height: 121,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 110,
      height: 121,
      color: Colors.grey[200],
      child: Icon(Icons.apartment, size: 40, color: Colors.grey[400]),
    );
  }

  String _formatPrice(dynamic price) {
    if (price == null) return 'Price N/A';
    try {
      final numPrice = double.parse(price.toString());
      if (numPrice >= 10000000) {
        return '₹${(numPrice / 10000000).toStringAsFixed(2)} Cr';
      } else if (numPrice >= 100000) {
        return '₹${(numPrice / 100000).toStringAsFixed(2)} Lac';
      }
      return '₹${numPrice.toStringAsFixed(0)}';
    } catch (_) {
      return 'Price N/A';
    }
  }
}

class ResellerProjectFilter extends StatefulWidget {
  const ResellerProjectFilter({Key? key}) : super(key: key);

  @override
  State<ResellerProjectFilter> createState() => _ResellerProjectFilterState();
}

class _ResellerProjectFilterState extends State<ResellerProjectFilter> {
  // Filter Controllers
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();

  // Selected filters
  String? selectedProjectType;
  String? selectedStatus;
  String? selectedCity;
  String? selectedDeveloper;

  // Filter options
  final List<String> projectTypes = [
    'Residential',
    'Commercial',
    'Mixed Use',
    'Industrial',
    'Township',
  ];

  final List<String> statusOptions = [
    'Under Construction',
    'Ready to Move',
    'New Launch',
    'Completed',
  ];

  @override
  void dispose() {
    projectNameController.dispose();
    locationController.dispose();
    minPriceController.dispose();
    maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        backgroundColor: ColorRes.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Filter Projects',
          style: TextStyle(
            color: ColorRes.textColor,
            fontWeight: AppFontWeights.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _clearAllFilters,
            child: Text('Clear All', style: TextStyle(color: ColorRes.primary)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Name
            _buildSectionTitle('Project Name'),
            _buildTextField(
              controller: projectNameController,
              hint: 'Enter project name',
              icon: Icons.business,
            ),
            const SizedBox(height: 20),

            // Location
            _buildSectionTitle('Location'),
            _buildTextField(
              controller: locationController,
              hint: 'Enter location',
              icon: Icons.location_on,
            ),
            const SizedBox(height: 20),

            // Project Type
            _buildSectionTitle('Project Type'),
            _buildDropdown(
              value: selectedProjectType,
              items: projectTypes,
              hint: 'Select project type',
              onChanged: (value) {
                setState(() {
                  selectedProjectType = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Status
            _buildSectionTitle('Project Status'),
            _buildDropdown(
              value: selectedStatus,
              items: statusOptions,
              hint: 'Select status',
              onChanged: (value) {
                setState(() {
                  selectedStatus = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Price Range
            _buildSectionTitle('Price Range'),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: minPriceController,
                    hint: 'Min Price',
                    icon: Icons.currency_rupee,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: maxPriceController,
                    hint: 'Max Price',
                    icon: Icons.currency_rupee,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Developer (optional)
            _buildSectionTitle('Developer'),
            _buildTextField(
              controller: TextEditingController(),
              hint: 'Enter developer name',
              icon: Icons.apartment,
            ),
            const SizedBox(height: 40),

            // Apply Filters Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorRes.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: ColorRes.textColor,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ColorRes.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint),
          icon: const Icon(Icons.arrow_drop_down),
          items:
              items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      projectNameController.clear();
      locationController.clear();
      minPriceController.clear();
      maxPriceController.clear();
      selectedProjectType = null;
      selectedStatus = null;
      selectedCity = null;
      selectedDeveloper = null;
    });
  }

  void _applyFilters() {
    final filters = <String, dynamic>{};

    if (projectNameController.text.isNotEmpty) {
      filters['projectName'] = projectNameController.text;
    }

    if (locationController.text.isNotEmpty) {
      filters['location'] = locationController.text;
    }

    if (selectedProjectType != null) {
      filters['projectType'] = selectedProjectType;
    }

    if (selectedStatus != null) {
      filters['status'] = selectedStatus;
    }

    if (minPriceController.text.isNotEmpty) {
      filters['minPrice'] = minPriceController.text;
    }

    if (maxPriceController.text.isNotEmpty) {
      filters['maxPrice'] = maxPriceController.text;
    }

    Get.back(result: filters);
  }
}
