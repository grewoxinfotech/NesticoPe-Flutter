import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/manager/compare_manager.dart';
import 'package:housing_flutter_app/app/manager/data_masker.dart';
import 'package:housing_flutter_app/app/manager/icon_manager.dart';
import 'package:housing_flutter_app/app/manager/project_compare_manager.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart';
import 'package:housing_flutter_app/modules/property/controllers/overall_rating_controller.dart';
import 'package:housing_flutter_app/modules/saved_property/controllers/property_favorite_controller.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/constants/size_manager.dart';
import '../../../../app/constants/svg_res.dart';
import '../../../../app/utils/bottom_sheet_form.dart';
import '../../../../app/utils/helper_function/user_helper/user_helper.dart';
import '../../../../app/utils/svg_widget.dart';
import '../../../../app/widgets/media/media_preview.dart';
import '../../../../app/widgets/snack_bar/custom_snackbar.dart';
import '../../../../app/widgets/texts/headline_text.dart';
import '../../../../data/database/secure_storage_service.dart';
import '../../../../data/network/builder/model/builder_model.dart';

// import '../../../../data/network/builder/model/builder_projectModel.dart';
import '../../../../widgets/bar/bottom_bar/customer_bottom_bar.dart';
import '../../../../widgets/button/property_action_button.dart';
import '../../../../widgets/map/address_and_map_detail.dart';
import '../../../../widgets/map/near_by_location_map_section.dart';
import '../../../auth/views/login_screen.dart';
import '../../../home/widgets/unified_comparison_floating_button.dart';
import '../../../property/views/property_detail_screen.dart';
import '../../../property/views/widgets/overall_rating_widget.dart';
import '../../../review/controllers/review_controller.dart';
import '../../../review/views/widget/property_project_review_section.dart';
import '../../../review/views/widget/property_review_card.dart';
import '../../../search_property/controller/search_controller.dart';
import '../../controller/builder_form_controller.dart';
import '../../controller/project_controller.dart';
import 'package:get/get.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final ProjectItem? projectItem;
  final String? projectId;

  const ProjectDetailsScreen({super.key, this.projectItem, this.projectId})
    : assert(
        projectItem != null || projectId != null,
        'Either projectItem or projectId must be provided',
      );

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  final projectController = Get.put(ProjectController());
  late final ProjectWizardController wizardController;
  final Rxn<ProjectItem> _project = Rxn<ProjectItem>();
  final RxBool _isLoading = true.obs;
  late final OverallRatingController _overallRatingController;
  late final ReviewController reviewController;
  final RxBool canAddReview = true.obs;
  late final GoogleMapController mapController;

  @override
  void initState() {
    super.initState();

    // Get project ID (from object or direct ID)
    final projectId = widget.projectItem?.id ?? widget.projectId ?? '';

    // Initialize wizard controller
    wizardController = Get.put(
      ProjectWizardController(isBuilderView: false),
      tag: 'project_detail_$projectId',
    );
    mapController = Get.put(GoogleMapController(), tag: 'map_$projectId');
    _overallRatingController = Get.put(
      OverallRatingController(),
      tag: 'rating_$projectId',
    );
    reviewController = Get.put(ReviewController(), tag: 'review_$projectId');

    // Set project if provided
    if (widget.projectItem != null) {
      _project.value = widget.projectItem;
      _isLoading.value = false;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    final projectId = widget.projectItem?.id ?? widget.projectId ?? '';
    Get.delete<ProjectWizardController>(tag: 'project_detail_$projectId');
    _project.close();
    _isLoading.close();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      _isLoading.value = true;
      await projectController.getAllInQuireData(
        widget.projectItem?.id ?? widget.projectId ?? '',
      );

      // Fetch project if only ID was provided
      if (widget.projectItem == null && widget.projectId != null) {
        final fetchedProject = await wizardController.getProjectById(
          widget.projectId!,
        );
        if (fetchedProject == null) {
          // Show error and go back
          if (mounted) {
            Get.snackbar(
              'Error',
              'Project not found',
              snackPosition: SnackPosition.BOTTOM,
            );
            Get.back();
          }
          return;
        }
        _project.value = fetchedProject;
      }

      final currentProject = _project.value;
      if (currentProject == null) return;

      reviewController.filters.value = {"entity_id": currentProject.id ?? ""};
      reviewController.filters.refresh();

      if (currentProject.address.isNotEmpty ?? false) {
        await mapController.fetchAllCategoriesData(currentProject.address);
      }

      // Check review permission
      final user = await SecureStorage.getUserData();
      final userId = user?.user?.id ?? '';

      final exists = await reviewController.isReviewExist(
        entityId: currentProject.id,
        reviewerId: userId,
      );
      canAddReview.value = !exists;

      // Track view
      projectController.addView(currentProject.id);
      _overallRatingController.fetchOverallRating(currentProject.id);
    } finally {
      _isLoading.value = false;
    }
  }

  // Convenience getter
  ProjectItem? get project => _project.value ?? widget.projectItem;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProjectController());

    return Scaffold(
      backgroundColor: ColorRes.white.withOpacity(0.95),
      body: Obx(() {
        // Show loading while fetching project
        if (_isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error if project not found
        if (project == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: ColorRes.leadGreyColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'Project not found',
                  style: TextStyle(
                    fontSize: AppFontSizes.body,
                    color: ColorRes.leadGreyColor,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            CustomScrollView(
              slivers: [
                _buildAppBar(context, project!),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProjectDetails(project!),
                      _buildMediaGallery(project!),
                      _buildConfigurations(controller, project!),
                      SizedBox(height: 12),
                      _buildMapSection(controller, project!),
                      _buildAmenities(project!),
                      SizedBox(height: 12),
                      _buildReviewSection(
                        canAddReview: canAddReview,
                        overallRatingController: _overallRatingController,
                        project: project!,
                        reviewController: reviewController,
                      ),
                      if (project?.brochures.isNotEmpty ?? false) ...[
                        _buildDocuments(controller, project!),
                      ],
                      _buildContactSection(controller, project!),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
            UnifiedComparisonFloatingButton(bottom: 16),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        if (_isLoading.value || project == null) {
          return const SizedBox.shrink();
        }
        return SafeArea(
          child: ReusableBottomBar(
            mainPriceText: project?.getPriceRange() ?? '',
            priceBreakdown: {},
            onPrimaryAction: () {
              if (UserHelper.isGuest) {
                Get.to(() => LoginScreen());
              } else {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder:
                      (context) => DraggableScrollableSheet(
                        expand: false,
                        minChildSize: 0.45,
                        initialChildSize:
                            controller.hasSubmittedInquiry.value ? 0.45 : 0.85,
                        maxChildSize:
                            controller.hasSubmittedInquiry.value ? 0.45 : 0.85,
                        builder:
                            (
                              context,
                              scrollController,
                            ) => SingleChildScrollView(
                              controller: scrollController,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                  left: 16,
                                  right: 16,
                                  top: 16,
                                ),
                                child: ContactOwnerBottom(
                                  // Check if inquiry already submitted
                                  inQuireSubmitted:
                                      controller.hasSubmittedInquiry.value,
                                  titleText: "Contact the Owner",
                                  chatButtonText: "Chat via WhatsApp",
                                  formTitle: "Quick Contact Form",
                                  contactButtonText: "Send Request",
                                  nameIcon: Icons.person,
                                  phoneIcon: Icons.phone,
                                  emailIcon: Icons.email,
                                  allowSellerContact: false,
                                  negotiable: false,
                                  onChatPressed: () {
                                    print("WhatsApp button clicked!");
                                  },
                                  onContactPressed: (
                                    name,
                                    phone,
                                    email,
                                    price,
                                    isNegotiable,
                                    isAllowAllCondition,
                                    planningToBuy,
                                  ) async {
                                    final inquiry = {
                                      "name": name ?? "",
                                      "phone": phone ?? "",
                                      "email": email ?? "",
                                      "agreeToContact":
                                          isAllowAllCondition ?? false,
                                      "meta": {
                                        if (price != null)
                                          "negotiablePrice": price,
                                        if (isNegotiable != null)
                                          "isNegotiable": isNegotiable,
                                        if (planningToBuy != null)
                                          "timePeriod": planningToBuy,
                                      },
                                    };

                                    final success = await controller.addInquiry(
                                      inquiry,
                                      project?.id ?? '',
                                    );

                                    if (success) {
                                      // Mark inquiry as submitted

                                      controller.hasSubmittedInquiry.value =
                                          true;

                                      CustomSnackBar.show(
                                        Get.overlayContext!,
                                        message: "Inquiry Added Successfully",
                                        type: SnackBarType.success,
                                      );

                                      Get.back();
                                      await controller.getAllInQuireData(
                                        project?.id ?? '',
                                      );
                                    } else {
                                      CustomSnackBar.show(
                                        Get.overlayContext!,
                                        message: "Failed to Submit Inquiry",
                                        type: SnackBarType.error,
                                      );
                                    }
                                  },
                                  onAllowSellerContactChanged: (value) {
                                    print("Allow sellers changed: $value");
                                  },
                                  onHomeLoanInterestChanged: (value) {
                                    print("Home loan interest changed: $value");
                                  },
                                ),
                              ),
                            ),
                      ),
                );
              }
            },
            primaryTitle: "View Contact",
          ),
        );
      }),
    );
  }

  Widget _buildAppBar(BuildContext context, ProjectItem project) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: ColorRes.white,

      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.only(left: 12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ColorRes.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: ColorRes.black),
        ),
      ),
      actions: [
        // GestureDetector(
        //   onTap: () {},
        //   child: Container(
        //     margin: const EdgeInsets.only(right: 12),
        //     padding: const EdgeInsets.all(8),
        //     decoration: BoxDecoration(
        //       color: ColorRes.white,
        //       shape: BoxShape.circle,
        //     ),
        //     child: const Icon(Icons.share, color: ColorRes.black),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: EntityActionButtons(
            id: project.id,
            entity: project,
            projectCompareController: Get.find<ProjectCompareManager>(),
            favoriteController: Get.find<PropertyFavoriteController>(),
          ),
        ),
      ],

      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            (project.mediaGallery?.images.first.isNotEmpty ?? false)
                ? CustomImage(
                  type: CustomImageType.network,
                  src: project.mediaGallery?.images.first ?? '',
                  fit: BoxFit.cover,
                )
                : CustomImage(
                  type: CustomImageType.network,
                  src:
                      'https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg?cs=srgb&dl=pexels-binyaminmellish-186077.jpg&fm=jpg',
                  fit: BoxFit.cover,
                ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.projectName,
                    style: const TextStyle(
                      color: ColorRes.white,
                      fontSize: AppFontSizes.large,
                      fontWeight: AppFontWeights.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    project.city,
                    style: TextStyle(
                      color: ColorRes.white,
                      fontSize: AppFontSizes.small,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'RERA ID: ${project.reraId}',
                    style: const TextStyle(
                      color: ColorRes.white,
                      fontSize: AppFontSizes.small,
                    ),
                  ),
                  // const SizedBox(height: 12),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       _buildStatusChip(project.status, ColorRes.success),
                  //       const SizedBox(width: 8),
                  //       _buildStatusChip(
                  //           project.propertyTypes, ColorRes.primary),
                  //       const SizedBox(width: 8),
                  //       _buildStatusChip(project.address, ColorRes.warning),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaGallery(ProjectItem projectItem) {
    if (projectItem.mediaGallery == null) {
      return const SizedBox.shrink();
    }

    final gallery = projectItem.mediaGallery!;
    final allMedia = [
      ...gallery.images.map((e) => {'type': 'image', 'url': e}),
      ...gallery.videos.map((e) => {'type': 'video', 'url': e}),
    ];

    if (allMedia.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: ColorRes.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gallery',
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          /// ✅ Single Horizontal List for both Images & Videos
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: allMedia.length,
              itemBuilder: (context, index) {
                final media = allMedia[index];
                final isVideo = media['type'] == 'video';
                final url = media['url'] ?? '';

                return GestureDetector(
                  onTap: () {
                    // Navigate to preview screen (image or video)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MediaPreviewScreen(url: url),
                      ),
                    );
                  },
                  child: Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          isVideo
                              ? buildVideoThumbnail(
                                url,
                                height: 120,
                                width: 160,
                              )
                              : Image.network(
                                url,
                                fit: BoxFit.cover,
                                height: 120,
                                width: 160,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),

                          /// ✅ Play icon overlay for videos
                          if (isVideo)
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.black45,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: AppFontSizes.caption,
          fontWeight: AppFontWeights.semiBold,
        ),
      ),
    );
  }

  Widget _buildGallerySection(
    ProjectController controller,
    ProjectItem project,
  ) {
    return Container(
      color: ColorRes.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gallery',
            style: TextStyle(
              fontSize: AppFontSizes.large,
              fontWeight: AppFontWeights.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: (project.mediaGallery?.images?.length ?? 0) + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildVideoThumbnail();
                }
                return _buildGalleryItem(
                  project.mediaGallery!.images[index - 1],
                  index == 1
                      ? 'Living Room\nSpacious Interiors'
                      : 'Amenities\nWorld-class',
                  index - 1,
                  controller,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoThumbnail() {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: ColorRes.blackShade26,
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: AssetImage('assets/images/video_thumb.jpg'),
          fit: BoxFit.cover,
          onError: null,
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.play_arrow, color: ColorRes.white, size: 32),
        ),
      ),
    );
  }

  Widget _buildGalleryItem(
    String image,
    String label,
    int index,
    ProjectController controller,
  ) {
    return GestureDetector(
      onTap: () => controller.selectImage(index),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover,
            onError: (_, __) {},
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
            ),
          ),
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(12),
          child: Text(
            label,
            style: const TextStyle(
              color: ColorRes.white,
              fontSize: AppFontSizes.small,
              fontWeight: AppFontWeights.medium,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectDetails(ProjectItem project) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: ColorRes.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Project Details',
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDetailCard(
                  icon: Icons.landscape,
                  label: 'Total Area',
                  value: '${project.projectArea}',
                  color: ColorRes.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDetailCard(
                  icon: Icons.apartment,
                  label: 'Total Units',
                  value: '${project.projectSize?.totalUnits ?? 0}',
                  color: ColorRes.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDetailCard(
                  icon: Icons.business,
                  label: 'Buildings',
                  value: '${project.projectSize?.totalBuildings ?? 0}',
                  color: ColorRes.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDetailCard(
                  icon: Icons.calendar_today,
                  label: 'Possession',
                  value: _formatDate(project.possessionDate),
                  color: ColorRes.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: AppFontSizes.small,
              color: ColorRes.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: AppFontSizes.bodyMedium,
              fontWeight: AppFontWeights.semiBold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Widget _buildConfigurations(
  Widget _buildConfigurations(
    ProjectController controller,
    ProjectItem project,
  ) {
    // Initialize expanded state for each configuration
    controller.initializeExpandedStates(project.configuration.length);

    return Container(
      color: ColorRes.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: const Text(
              'Configurations',
              style: TextStyle(
                fontSize: AppFontSizes.medium,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textPrimary,
              ),
            ),
          ),
          Obx(() {
            // Show only first 2 items initially, or all if expanded
            final displayCount =
                controller.showAllConfigurations.value
                    ? project.configuration.length
                    : math.min(1, project.configuration.length);

            return Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: displayCount,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildConfigurationSection(
                        project.configuration[index],
                        index,
                        controller,
                      ),
                    );
                  },
                ),

                // See More / See Less button
                if (project.configuration.length > 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextButton(
                      onPressed: () {
                        controller.toggleShowAllConfigurations();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: ColorRes.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.showAllConfigurations.value
                                ? 'See Less'
                                : 'See More',
                            style: TextStyle(
                              fontSize: AppFontSizes.bodySmall,
                              fontWeight: AppFontWeights.semiBold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            controller.showAllConfigurations.value
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildConfigurationSection(
    ProjectConfiguration config,
    int configIndex,
    ProjectController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BHK Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: ColorRes.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.medium),
              border: Border.all(
                color: ColorRes.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${config.bhk} BHK Apartments',
                        style: const TextStyle(
                          fontSize: AppFontSizes.bodyMedium,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${config.variants.length} Variant${config.variants.length > 1 ? 's' : ''} Available',
                        style: const TextStyle(
                          fontSize: AppFontSizes.extraSmall,
                          color: ColorRes.primary,
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (config.variants.length > 0) ...[
            const SizedBox(height: 12),

            // Horizontal Variants List
            SizedBox(
              height: 285,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: config.variants.length,
                itemBuilder: (context, variantIndex) {
                  final variant = config.variants[variantIndex];
                  return Container(
                    width: 280,
                    margin: EdgeInsets.only(
                      right: variantIndex < config.variants.length - 1 ? 12 : 0,
                    ),
                    child: _buildVariantCard(variant, variantIndex, controller),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVariantCard(
    ProjectVariant variant,
    int variantIndex,
    ProjectController controller,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        side: BorderSide(color: ColorRes.leadGreyColor[300]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Variant Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: ColorRes.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.medium),
                topRight: Radius.circular(AppRadius.medium),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.apartment, color: ColorRes.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Variant ${variantIndex + 1}',
                  style: const TextStyle(
                    fontSize: AppFontSizes.small,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.white,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Variant Images (Horizontal ListView)
                SizedBox(
                  height: 125, // fixed height for image list
                  child:
                      variant.images.isEmpty
                          ? _buildPlaceholderImage()
                          : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: variant.images.length,
                            padding: const EdgeInsets.all(12),
                            separatorBuilder:
                                (_, __) => const SizedBox(width: 8),
                            itemBuilder: (context, imgIndex) {
                              return Container(
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      variant.images[imgIndex],
                                    ),
                                    fit: BoxFit.cover,
                                    onError: (exception, stackTrace) {},
                                  ),
                                ),
                              );
                            },
                          ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Variant Details Grid
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            _buildDetailRow(
                              'Carpet Area',
                              '${variant.carpetArea.toInt()} sq.ft.',
                            ),
                            const SizedBox(height: 8),
                            _buildDetailRow(
                              'Built-up Area',
                              '${variant.builtUpArea.toInt()} sq.ft.',
                            ),
                            const SizedBox(height: 8),
                            _buildDetailRow(
                              'Price/sq.ft',
                              controller.formatCurrency(
                                variant.pricePerSqFt?.toDouble() ?? 0.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildDetailRow(
                              'Price',
                              controller.formatCurrency(
                                variant.price.toDouble(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 8),
                      // Container(
                      //   padding: EdgeInsets.symmetric(
                      //     horizontal: 12,
                      //     vertical: 8,
                      //   ),
                      //   width: double.infinity,
                      //   decoration: BoxDecoration(
                      //     color: ColorRes.primary.withOpacity(0.05),
                      //     border: Border.all(
                      //       color: ColorRes.primary.withOpacity(0.3),
                      //       width: 1,
                      //     ),
                      //     borderRadius: BorderRadius.circular(8),
                      //   ),
                      //   alignment: Alignment.center,
                      //   child: Text(
                      //     'Contact',
                      //     style: const TextStyle(
                      //       fontSize: AppFontSizes.body,
                      //       fontWeight: AppFontWeights.semiBold,
                      //       color: ColorRes.primary,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppFontSizes.caption,
            color: ColorRes.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: AppFontSizes.small,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        color: ColorRes.leadGreyColor[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 48,
          color: ColorRes.textSecondary,
        ),
      ),
    );
  }

  Widget _buildAmenities(ProjectItem project) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: ColorRes.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Amenities',
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.84,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: project.amenities.length,
            itemBuilder: (context, index) {
              print("Project deatils ${project.amenities.map((e) => e)}");

              return _buildAmenityItem(project.amenities[index], index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityItem(String amenity, int index) {
    final Map<String, String> amenityIcons = {
      'Swimming Pool': AppSvgRes.swimming,
      "Fire Safety": AppSvgRes.fire_extinguisher,
      "CCTV": AppSvgRes.cctv,
      "Club House": AppSvgRes.club,
      "Gymnasium": AppSvgRes.gym,
      "Children Play Area": AppSvgRes.playground,
      "Power Backup": AppSvgRes.battery,
      "Lift": AppSvgRes.elevator,
      "Service Lift": AppSvgRes.elevator,
      "Garden": AppSvgRes.garden,
      "Ev Charging": AppSvgRes.dg,
      "Wifi Connectivity": AppSvgRes.internet_connectivity,
      "Covered Parking": AppSvgRes.covered_parking,
      "Visitor Parking": AppSvgRes.visitor_parking,
      "Maintenance Staff": AppSvgRes.maintenanace_staff,
      "Meditation Area": AppSvgRes.meditation_area,
      "MultiPurpose Hall": AppSvgRes.multi_purpose_hall,
      "Solar Panel": AppSvgRes.solar_panel,
      "Waste Disposal": AppSvgRes.waste_disposal,
      "24x7 Security": AppSvgRes.security,
      "Laundry Service": AppSvgRes.washing,
      "Temple": AppSvgRes.hall,
      "Jogging Track": AppSvgRes.sports,
      "Amphitheatre Theater": AppSvgRes.home_theater,
    };

    final List<Color> amenityColors = [
      ColorRes.blueColor,
      ColorRes.error,
      ColorRes.leadIndigoColor,
      ColorRes.orangeColor,
      ColorRes.leadTealColor,
      ColorRes.lightpurple,
      ColorRes.purpleColor,
      ColorRes.green,
    ];

    // Use a color in sequence or wrap around using modulo
    final color = amenityColors[index % amenityColors.length];
    final icon = amenityIcons[amenity] ?? AppSvgRes.sports;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: AppSvgIcon(assetName: icon, color: color, folder: 'amenities'),
        ),
        const SizedBox(height: 8),
        Text(
          amenity,
          style: const TextStyle(
            fontSize: AppFontSizes.mini,
            fontWeight: AppFontWeights.medium,
            color: ColorRes.textPrimary,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDocuments(ProjectController controller, ProjectItem project) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: ColorRes.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Brochures',
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          if (project.brochures.isNotEmpty)
            ...project.brochures.map((brochure) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildDocumentItem(
                  icon: Icons.description,
                  title: brochure.name ?? '-',
                  onTap: () => controller.downloadDocument(brochure.url),
                ),
              );
            }).toList(),
          if (project.mediaGallery?.documents != null &&
              project.mediaGallery!.documents.isNotEmpty) ...[
            SizedBox(height: 12),
            const Text(
              'Documents',
              style: TextStyle(
                fontSize: AppFontSizes.medium,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            ...project.mediaGallery!.documents.map((document) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildDocumentItem(
                  icon: Icons.description,
                  title: "Document" ?? '-',
                  onTap: () => controller.downloadDocument(document),
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildDocumentItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: ColorRes.border, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorRes.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: ColorRes.primary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: AppFontSizes.bodySmall,
                  fontWeight: AppFontWeights.medium,
                  color: ColorRes.textPrimary,
                ),
              ),
            ),
            const Text(
              'View',
              style: TextStyle(
                fontSize: AppFontSizes.small,
                color: ColorRes.primary,
                fontWeight: AppFontWeights.semiBold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(
    ProjectController controller,
    ProjectItem project,
  ) {
    final contact = project.projectContactInfo;
    if (contact == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: ColorRes.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Team',
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundColor: ColorRes.primary,
                child: Icon(Icons.person, color: ColorRes.white, size: 25),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DataMasker.maskName(contact.name) ?? '-',
                      style: TextStyle(
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                    // const SizedBox(height: 4),
                    Text(
                      DataMasker.maskEmail(contact.email) ?? '-',
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        color: ColorRes.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // IconButton(
              //   onPressed: () => controller.contactSales('phone'),
              //   icon: const Icon(Icons.phone, color: ColorRes.white),
              //   style: IconButton.styleFrom(backgroundColor: ColorRes.primary),
              // ),
              // const SizedBox(width: 8),
              // IconButton(
              //   onPressed: () => controller.contactSales('email'),
              //   icon: const Icon(Icons.email, color: ColorRes.white),
              //   style: IconButton.styleFrom(backgroundColor: ColorRes.primary),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'TBA';

    try {
      final date = DateTime.parse(dateString);
      const months = [
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
    } catch (e) {
      return dateString;
    }
  }

  Widget buildVideoThumbnail(String videoUrl, {double? width, double? height}) {
    return FutureBuilder<Uint8List?>(
      future: VideoThumbnail.thumbnailData(
        video: videoUrl,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 400, // resize for performance
        quality: 75,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: width,
            height: height,
            color: Colors.black12,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return Container(
            width: width,
            height: height,
            color: Colors.black54,
            child: const Icon(Icons.videocam, color: Colors.white, size: 36),
          );
        }

        return Image.memory(
          snapshot.data!,
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
      },
    );
  }

  Container _buildMapSection(
    ProjectController controller,
    ProjectItem projectItem,
  ) {
    return Container(
      color: ColorRes.white,
      child: Column(
        children: [
          if (projectItem.location?.isNotEmpty ?? false) ...[
            const SizedBox(height: 12),
            const TitleWithViewAll(title: 'Location'),
            const SizedBox(height: 8),
            AddressAndMapDetails(
              address: projectItem.address,
              city: projectItem.city,
              state: projectItem.state,
              zipCode: projectItem.zipCode,
            ),
            const SizedBox(height: 12),
          ],

          Obx(() {
            if (mapController.isLoading.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            // Check if any category has data
            final hasData = mapController.allCategoriesData.values.any(
              (places) => places.isNotEmpty,
            );

            if (!hasData || mapController.propertyLatLng.value == null) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  indent: 18,
                  endIndent: 18,
                  color: ColorRes.leadGreyColor.shade300,
                ),
                const SizedBox(height: 12),

                // Embedded Map Preview Section
                NearbyLocationMapSection(
                  address: projectItem.address ?? '',
                  mapController: mapController,
                ),

                const SizedBox(height: 12),
              ],
            );
          }),
        ],
      ),
    );
  }

  Container _buildReviewSection({
    required RxBool canAddReview,
    required ReviewController reviewController,
    required ProjectItem? project,
    required OverallRatingController overallRatingController,
  }) {
    return Container(
      color: ColorRes.white,
      padding: EdgeInsets.only(top: 12),
      child: ReviewSection(
        canAddReview: canAddReview,
        overallController: overallRatingController,
        reviewController: reviewController,
        entityType: "project",
        entityId: project?.id ?? '',
        reviewCardBuilder:
            (context, item) => PropertyReviewCard(reviewItem: item),
        overallWidgetBuilder: (total, rating, details) {
          return OverallRatingWidget(
            totalReviews: total,
            overallRating: rating,
            detailedRatings: details,
          );
        },
      ),
    );
  }
}
