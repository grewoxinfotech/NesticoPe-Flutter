import 'dart:developer';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nesticope_app/app/manager/compare_manager.dart';
import 'package:nesticope_app/app/manager/data_masker.dart';
import 'package:nesticope_app/app/manager/icon_manager.dart';
import 'package:nesticope_app/app/manager/project_compare_manager.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/app/widgets/image/custom_image.dart'
    hide ColorRes, imageOfNotAvailable;
import 'package:nesticope_app/modules/builder/view/project_detail/widgets/model_render_screen.dart';
import 'package:nesticope_app/modules/property/controllers/overall_rating_controller.dart';
import 'package:nesticope_app/modules/reseller/view/lead_overview/widget/lead_follow_up_screen.dart';
import 'package:nesticope_app/modules/review/views/widget/add_property_review.dart';
import 'package:nesticope_app/modules/saved_property/controllers/property_favorite_controller.dart';
import 'package:nesticope_app/utils/logger/app_logger.dart';
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
import '../../../../utils/global.dart';
import '../../../../widgets/New folder/inputs/text_field.dart';
import '../../../../widgets/bar/bottom_bar/customer_bottom_bar.dart';
import '../../../../widgets/button/button.dart';
import '../../../../widgets/button/property_action_button.dart';
import '../../../../widgets/map/address_and_map_detail.dart';
import '../../../../widgets/map/near_by_location_map_section.dart';
import '../../../../widgets/messages/snack_bar.dart';
import '../../../auth/views/login_screen.dart';
import '../../../common/lead_components/lead_card_widget.dart';
import '../../../home/widgets/unified_comparison_floating_button.dart';
import '../../../performance_score/views/performance_score_screen.dart';
import '../../../property/views/property_detail_screen.dart';
import '../../../property/views/widgets/overall_rating_widget.dart';
import '../../../reseller/view/lead/lead_screen.dart';
import '../../../review/controllers/review_controller.dart';
import '../../../review/views/widget/property_project_review_section.dart';
import '../../../review/views/widget/property_review_card.dart';
import '../../../search_property/controller/search_controller.dart';
import '../../../seller/view/widget/seller_property_approval_history.dart';
import '../../controller/builder_form_controller.dart';
import '../../controller/builder_listed_project_controller.dart';
import '../../controller/project_controller.dart';
import 'package:get/get.dart';
import '../../../home/controllers/contact_controller.dart';
import '../../../../app/utils/helper_function/contact_helper.dart';

import '../builder_leads.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final ProjectItem? projectItem;
  final String? projectId;
  final bool isBuilder;
  final bool isFromPanel;

  const ProjectDetailsScreen({
    super.key,
    this.projectItem,
    this.projectId,
    this.isBuilder = false,
    this.isFromPanel = false,
  }) : assert(
         projectItem != null || projectId != null,
         'Either projectItem or projectId must be provided',
       );

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  final projectController = Get.put(ProjectController());
  late final ProjectWizardController wizardController;
  final Rxn<ProjectItem> project = Rxn<ProjectItem>();
  final RxBool _isLoading = true.obs;
  late final OverallRatingController _overallRatingController;
  late final ReviewController reviewController;
  final RxBool canAddReview = true.obs;
  late final GoogleMapSearchController mapController;
  late final BuilderProjectListController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.put(BuilderProjectListController());

    // Get project ID (from object or direct ID)
    final projectId = widget.projectItem?.id ?? widget.projectId ?? '';

    // Initialize wizard controller
    wizardController = Get.put(
      ProjectWizardController(isBuilderView: false),
      tag: 'project_detail_$projectId',
    );
    mapController = Get.put(GoogleMapSearchController(), tag: 'map_$projectId');
    _overallRatingController = Get.put(
      OverallRatingController(),
      tag: 'rating_$projectId',
    );
    reviewController = Get.put(ReviewController(), tag: 'review_$projectId');

    // Set project if provided
    // if (widget.projectItem != null) {
    //   _project.value = widget.projectItem;
    //   _isLoading.value = false;
    // }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppLogger(
        "Check the score card come null from backend ",
        widget.projectItem?.toJson(),
      );
      _loadData();
    });
  }

  @override
  void dispose() {
    final projectId = widget.projectItem?.id ?? widget.projectId ?? '';
    Get.delete<ProjectWizardController>(tag: 'project_detail_$projectId');
    project.close();
    _isLoading.close();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      _isLoading.value = true;
      final projectId = widget.projectItem?.id ?? widget.projectId ?? '';
      await projectController.getAllInQuireData(
        widget.projectItem?.id ?? widget.projectId ?? '',
      );
      await projectController.getHasInQuireData(
        widget.projectItem?.id ?? widget.projectId ?? '',
      );

      // Fetch project if only ID was provided

      final fetchedProject = await wizardController.getProjectById(projectId);
      if (fetchedProject == null) {
        // Show error and go back
        if (mounted) {
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Error',
            message: 'Project not found',
            contentType: ContentType.failure,
          );
          Get.back();
        }
        return;
      }
      project.value = fetchedProject;
      AppLogger(
        "Check the score card come null from backend ",
        fetchedProject?.toJson(),
      );

      final currentProject = project.value;
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

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProjectController());
    AppLogger.structured(
      '🔍 Building ProjectDetailsScreen for project ID:',
      project?.toJson(),
    );

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

        AppLogger.structured("project Overview Screen ", project?.toJson());

        return Stack(
          children: [
            CustomScrollView(
              slivers: [
                _buildAppBar(context, project.value!, widget.isFromPanel),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProjectDetails(project.value!),
                      _buildMediaGallery(project.value!),
                      _buildConfigurations(controller, project.value!),
                      // SizedBox(height: 8),
                      _buildMapSection(controller, project.value!),
                      _buildAmenities(project.value!),
                      // SizedBox(height: 8),
                      _buildContactSection(controller, project.value!),
                      _buildReviewSection(
                        canAddReview: canAddReview,
                        overallRatingController: _overallRatingController,
                        project: project.value!,
                        reviewController: reviewController,
                      ),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        color: ColorRes.leadGreyColor.shade200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleWithViewAll(
                              title: 'Limited Time Offer!',
                              subTitle:
                                  "Limited-time! Get an exclusive offer on this property.",
                              isSubTitle: true,
                            ),

                            const SizedBox(height: 12),

                            // Conditional Area
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                children: [
                                  Obx(() {
                                    if (controller.hasSubmittedInquiry.value) {
                                      return SizedBox(
                                        height: 48,
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            NesticoPeSnackBar.showAwesomeSnackbar(
                                              title: 'Already Inquired',
                                              message:
                                                  'You have already submitted inquiry',
                                              contentType: ContentType.warning,
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: ColorRes.error,
                                            foregroundColor: ColorRes.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                            ),
                                          ),
                                          child: const Text(
                                            'Already Inquired',
                                            style: TextStyle(
                                              fontSize: AppFontSizes.medium,
                                              fontWeight:
                                                  AppFontWeights.semiBold,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return NesticoPeButton(
                                        title: 'Get Offer',
                                        backgroundColor: ColorRes.error,
                                        height: 36,
                                        onTap: () async {
                                          try {
                                            if (UserHelper.isGuest) {
                                              Get.to(() => LoginScreen());
                                              return;
                                            }
                                            final user =
                                                await SecureStorage.getUserData();
                                            if (user == null) {
                                              NesticoPeSnackBar.showAwesomeSnackbar(
                                                title: 'Error',
                                                message:
                                                    'No user data found. Please log in.',
                                                contentType:
                                                    ContentType.failure,
                                              );
                                              return;
                                            }
                                            final fullName =
                                                user.user?.fullName ?? '';
                                            final firstName =
                                                user.user?.firstName ?? '';
                                            final username =
                                                user.user?.username ?? '';
                                            final email =
                                                user.user?.email ?? '';
                                            final phone =
                                                user.user?.phone ?? '';
                                            final displayName =
                                                (firstName.isEmpty
                                                        ? username
                                                        : fullName)
                                                    .trim();
                                            final inquiry = {
                                              "name": displayName,
                                              "phone": phone,
                                              "email": email,
                                              "agreeToContact": true,
                                              "meta": {
                                                "inquiryType": "sell",
                                                "type": "project",
                                              },
                                            };
                                            final success = await controller
                                                .addInquiry(
                                                  inquiry,
                                                  project?.value?.id ?? '',
                                                );
                                            if (success) {
                                              controller
                                                  .hasSubmittedInquiry
                                                  .value = true;
                                              NesticoPeSnackBar.showAwesomeSnackbar(
                                                title: 'Success',
                                                message:
                                                    'Inquiry Added Successfully',
                                                contentType:
                                                    ContentType.success,
                                              );
                                              await controller
                                                  .getAllInQuireData(
                                                    project?.value?.id ?? '',
                                                  );
                                              await controller
                                                  .getHasInQuireData(
                                                    project?.value?.id ?? '',
                                                  );
                                            } else {
                                              NesticoPeSnackBar.showAwesomeSnackbar(
                                                title: 'Error',
                                                message:
                                                    'Failed to Submit Inquiry',
                                                contentType:
                                                    ContentType.failure,
                                              );
                                            }
                                          } catch (e, s) {
                                            debugPrint(
                                              '❌ Error in Get Offer button: $e',
                                            );
                                            debugPrint('$s');
                                            NesticoPeSnackBar.showAwesomeSnackbar(
                                              title: 'Error',
                                              message:
                                                  'Something went wrong. Please try again.',
                                              contentType: ContentType.failure,
                                            );
                                          }
                                        },
                                      );
                                    }
                                  }),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),

                      if (project?.value?.brochures.isNotEmpty ?? false) ...[
                        _buildDocuments(controller, project.value!),
                      ],
                      const SizedBox(height: 8),
                      _buildSupportContactSection(),

                      if (widget.isBuilder) ...[
                        if (project?.value?.scoreBreakdown != null) ...[
                          PerformanceScoreWidget(
                            score: project!.value!.scoreBreakdown!,
                            showDivider: false,
                            color: ColorRes.white,
                            margin: 8,
                            project: project.value,
                          ),
                        ],
                        SizedBox(height: 8),
                      ],

                      if (widget.isBuilder) ...[
                        // ListTile(
                        //   tileColor: ColorRes.white,
                        //   title: Text(
                        //     'Approval History',
                        //     style: TextStyle(
                        //       fontSize: AppFontSizes.medium,
                        //       fontWeight: AppFontWeights.semiBold,
                        //     ),
                        //   ),
                        //   leading: Icon(Icons.history, color: ColorRes.primary),
                        //   trailing: Icon(Icons.arrow_forward_ios_rounded),
                        //   onTap: () {
                        // Get.to(
                        //   () => SellerPropertyApprovalHistory(
                        //     propertyId: project?.value?.id ?? '',
                        //     isProject: true,
                        //   ),
                        // );
                        //   },
                        // ),
                        _buildMenuItem(
                          iconColor: ColorRes.primary,
                          title: "Approval History",
                          icon: Icons.history,
                          onTap: () {
                            Get.to(
                              () => SellerPropertyApprovalHistory(
                                propertyId: project?.value?.id ?? '',
                                isProject: true,
                              ),
                            );
                          },
                          iconBg: ColorRes.primary.withOpacity(0.1),
                          subtitle: 'View timeline of approvals',
                        ),
                        const SizedBox(height: 8),
                        // ListTile(
                        //   tileColor: ColorRes.white,
                        //   title: Text(
                        //     'Leads',
                        //     style: TextStyle(
                        //       fontSize: AppFontSizes.medium,
                        //       fontWeight: AppFontWeights.semiBold,
                        //     ),
                        //   ),
                        //   leading: Icon(
                        //     Icons.leaderboard_outlined,
                        //     color: ColorRes.primary,
                        //   ),
                        //   trailing: Icon(Icons.arrow_forward_ios_rounded),
                        //   onTap: () {
                        //     log(
                        //       "Check it is from project pass project id ${project?.value?.id}",
                        //     );

                        //     Get.to(
                        //       () => CommonLeadScreen(
                        //         title: 'Project Buyer Leads',
                        //         controllerTag: 'project',
                        //         entityId: project?.value?.id,
                        //         showActionButton: true,
                        //         showDataMasking: false,
                        //         onLoadMore: (controller, id) async {
                        //           if (id != null) {
                        //             controller.loadMorePropertyLeads(id);
                        //           } else {
                        //             controller.loadMore();
                        //           }
                        //         },

                        //         /// 👇 Custom lead card builder
                        //         leadCardBuilder: (lead, onTap) {
                        //           return LeadCardWidget(
                        //             lead: lead,
                        //             isCompact:
                        //                 MediaQuery.of(context).size.width < 600,
                        //             showDataMasking: false,
                        //             onTap: onTap,
                        //           );
                        //         },
                        //       ),
                        //     );
                        //   },
                        // ),
                        _buildMenuItem(
                          iconColor: ColorRes.green,
                          title: "Leads",
                          icon: Icons.label_important_outline,
                          onTap: () {
                            Get.to(
                              () => CommonLeadScreen(
                                title: 'Project Buyer Leads',
                                controllerTag: 'project',
                                entityId: project?.value?.id,
                                showActionButton: true,
                                showDataMasking: false,
                                onLoadMore: (controller, id) async {
                                  if (id != null) {
                                    controller.loadMorePropertyLeads(id);
                                  } else {
                                    controller.loadMore();
                                  }
                                },

                                /// 👇 Custom lead card builder
                                leadCardBuilder: (lead, onTap) {
                                  return LeadCardWidget(
                                    lead: lead,
                                    isCompact:
                                        MediaQuery.of(context).size.width < 600,
                                    showDataMasking: false,
                                    onTap: onTap,
                                  );
                                },
                              ),
                            );
                          },
                          iconBg: ColorRes.green.withOpacity(0.1),

                          subtitle: 'New potential buyers',
                        ),
                        const SizedBox(height: 8),
                      ],
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
            mainPriceText: project?.value?.getPriceRange() ?? '',
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
                                  propertyStatus: "",
                                  projectConfiguration:
                                      project.value?.configuration ?? [],
                                  isProject: 'project',
                                  inQuireSubmitted:
                                      controller.hasSubmittedInquiry.value,
                                  listingType: "sell",
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
                                    inquiryListing,
                                    isBookSiteVisit,
                                    planningToBuy,
                                    date,
                                    time,
                                    roomInfo,
                                    selectedVariant,
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
                                        if (selectedVariant != null)
                                          "selectedVariant": selectedVariant,
                                        if (inquiryListing != null &&
                                            (inquiryListing?.isNotEmpty ??
                                                false))
                                          "inquiryType":
                                              inquiryListing.toLowerCase(),
                                        if (date != null)
                                          "visitDate":
                                              '${date.day}-${date.month}-${date.year}',
                                        if (time != null)
                                          "visitTime":
                                              '${time.hour.toString().padLeft(2, '0')}:'
                                              '${time.minute.toString().padLeft(2, '0')}',
                                      },
                                    };

                                    final success = await controller.addInquiry(
                                      inquiry,
                                      project.value?.id ?? '',
                                    );

                                    if (success) {
                                      // Mark inquiry as submitted

                                      controller.hasSubmittedInquiry.value =
                                          true;

                                      NesticoPeSnackBar.showAwesomeSnackbar(
                                        title: 'Success',
                                        message: "Inquiry Added Successfully",
                                        contentType: ContentType.success,
                                      );

                                      Get.back();
                                      await controller.getAllInQuireData(
                                        project.value?.id ?? '',
                                      );
                                      await controller.getHasInQuireData(
                                        project.value?.id ?? '',
                                      );
                                    } else {
                                      NesticoPeSnackBar.showAwesomeSnackbar(
                                        title: 'Error',
                                        message: "Failed to Submit Inquiry",
                                        contentType: ContentType.failure,
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
            primaryTitle:
                controller.hasSubmittedInquiry.value
                    ? "Submitted"
                    : "View Contact",
          ),
        );
      }),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            color: ColorRes.white,
            child: Row(
              children: [
                /// Icon Box
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),

                const SizedBox(width: 14),

                /// Title + Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: AppFontSizes.medium,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.leadGreyColor[900],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: AppFontSizes.caption,
                          color: ColorRes.leadGreyColor[600],
                        ),
                      ),
                    ],
                  ),
                ),

                /// Arrow
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: ColorRes.leadGreyColor[500],
                ),
              ],
            ),
          ),

          /// Divider
          if (showDivider)
            Divider(
              height: 1,
              thickness: 1,
              color: ColorRes.leadGreyColor.shade200,
            ),
        ],
      ),
    );
  }

  void addInquiryFromProject(
    String name,
    String email,
    String phone,
    String propertyID,
    String propertyType,
    String type,
  ) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final controller = Get.find<ProjectController>();

    final nameController = TextEditingController(text: name);
    final emailController = TextEditingController(text: email);
    final phoneController = TextEditingController(text: phone);

    Get.dialog(
      Dialog(
        backgroundColor: ColorRes.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          decoration: BoxDecoration(
            color: ColorRes.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: ColorRes.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Get Offer Price",
                          style: TextStyle(
                            fontSize: AppFontSizes.body,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => Get.back(),
                        borderRadius: BorderRadius.circular(50),
                        child: const Icon(
                          Icons.close_rounded,
                          color: ColorRes.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                // Body
                Flexible(
                  flex: 1,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NesticoPeTextField(
                          controller: nameController,
                          title: "Name",
                          hintText: 'Enter your name',
                          prefixIcon: Icons.person_outline,
                          isRequired: true,
                          validator:
                              (value) =>
                                  value == null || value.trim().isEmpty
                                      ? 'Name is required'
                                      : null,
                        ),
                        const SizedBox(height: 16),

                        NesticoPeTextField(
                          controller: emailController,
                          hintText: 'Enter your email',
                          prefixIcon: Icons.email_outlined,
                          title: "Email",
                          keyboardType: TextInputType.emailAddress,
                          isRequired: true,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email is required';
                            }
                            if (!GetUtils.isEmail(value.trim())) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        NesticoPeTextField(
                          controller: phoneController,
                          hintText: 'Enter your phone number',
                          title: "Phone",
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          isRequired: true,
                          maxLength: 10,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Phone is required';
                            }
                            if (!GetUtils.isPhoneNumber(value.trim())) {
                              return 'Enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer Buttons
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ColorRes.white,
                    border: Border(
                      top: BorderSide(
                        color: ColorRes.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: ColorRes.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: AppFontSizes.medium,
                              fontWeight: AppFontWeights.semiBold,
                              color: ColorRes.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // perform your submission logic here
                              final inquiry = {
                                "name": nameController.text ?? "",
                                "phone": phoneController.text ?? "",
                                "email": emailController.text ?? "",
                                "agreeToContact": true,
                                "meta": {
                                  "inquiryType": "$propertyType",
                                  "type": "$type",
                                },
                              };

                              print('Submitting inquiry: ${inquiry}');

                              final success = await controller.addInquiry(
                                inquiry,
                                propertyID ?? '',
                              );

                              if (success) {
                                if (UserHelper.isGuest) {
                                  controller.hasSubmittedInquiry.value = true;
                                  var inquiryData = {
                                    'property': propertyID,
                                    "email": emailController.text ?? "",
                                    "success": success,
                                  };
                                  final exists =
                                      await SecureStorage.hasPropertyInquiry(
                                        propertyID,
                                      );

                                  if (!exists) {
                                    await SecureStorage.addPropertyInquiry(
                                      inquiryData,
                                    );
                                  }
                                }
                                controller.hasSubmittedInquiry.value = true;
                                /*      CustomSnackBar.show(
                                  Get.overlayContext!,
                                  message: "Inquiry Added Successfully",
                                  type: SnackBarType.success,
                                );*/
                                Get.back();
                                await controller.getAllInQuireData(
                                  widget.projectItem?.id ?? '',
                                );
                                await controller.getHasInQuireData(
                                  widget?.projectItem?.id ?? '',
                                );
                              } else {
                                Get.back();
                                /* CustomSnackBar.show(
                                  Get.overlayContext!,
                                  message: "Failed to Submit Inquiry",
                                  type: SnackBarType.error,
                                );*/
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorRes.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.send, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Request Offer Price',

                                style: TextStyle(
                                  fontSize: AppFontSizes.medium,
                                  fontWeight: AppFontWeights.semiBold,
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
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    ProjectItem project,
    bool isFromPanel,
  ) {
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
        if (!isFromPanel) ...[
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
      ],

      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // ✅ Safely handle empty image list
            (project.mediaGallery?.images.isNotEmpty ?? false)
                ? CustomImage(
                  type: CustomImageType.network,
                  src: project.mediaGallery!.images.first,
                  fit: BoxFit.cover,
                )
                : CustomImage(
                  type: CustomImageType.asset,
                  src: imageOfNotAvailable,
                  fit: BoxFit.cover,
                ),

            // Dark overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),

            // Project details
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
                    '${project.city} ,${project.state}',
                    style: const TextStyle(
                      color: ColorRes.white,
                      fontSize: AppFontSizes.small,
                      fontWeight: AppFontWeights.semiBold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xffBFFD89),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'RERA ID: ${project.reraId}',
                      style: const TextStyle(
                        color: Color(0xff477914),
                        fontSize: AppFontSizes.caption,
                        fontWeight: AppFontWeights.bold,
                      ),
                    ),
                  ),
                  // Text(
                  //   'Last Updated : ${Formatter.formatDate(project.updatedAt)}',
                  //   style: const TextStyle(
                  //     color: ColorRes.white,
                  //     fontSize: AppFontSizes.small,
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
      margin: EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: ColorRes.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Text(
          //   'Gallery',
          //   style: TextStyle(
          //     fontSize: AppFontSizes.medium,
          //     fontWeight: AppFontWeights.semiBold,
          //     color: ColorRes.textPrimary,
          //   ),
          // ),
          TitleWithViewAll(
            title: 'Gallery',
            icon: Icons.photo_library,
            iconBgColor: ColorRes.white,
            iconColor: ColorRes.success,

            showIcon: true,
          ),
          const SizedBox(height: 12),

          /// ✅ Single Horizontal List for both Images & Videos
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      // padding: const EdgeInsets.all(16),
      color: Color(0xffF1F4F6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWithViewAll(
            title: 'Project Details',
            icon: Icons.apartment,
            iconBgColor: ColorRes.white,
            iconColor: ColorRes.primary,

            showIcon: true,
          ),
          // const Text(
          //   'Project Details',
          //   style: TextStyle(
          //     fontSize: AppFontSizes.medium,
          //     fontWeight: AppFontWeights.semiBold,
          //     color: ColorRes.textPrimary,
          //   ),
          // ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
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
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
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
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 15),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: AppFontWeights.medium,
              color: ColorRes.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.bold,
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Color.fromARGB(255, 234, 241, 237),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          //   child: const Text(
          //     'Configurations',
          //     style: TextStyle(
          //       fontSize: AppFontSizes.medium,
          //       fontWeight: AppFontWeights.semiBold,
          //       color: ColorRes.textPrimary,
          //     ),
          //   ),
          // ),
          TitleWithViewAll(
            title: 'Configurations',
            icon: Icons.settings,
            iconBgColor: ColorRes.white,
            iconColor: ColorRes.builderGridPurple,

            showIcon: true,
          ),
          const SizedBox(height: 12),
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
                                ? 'See Less Variants'
                                : 'See More Variants',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // BHK Header
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: ColorRes.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppRadius.medium),
            // border: Border.all(
            //   color: ColorRes.primary.withOpacity(0.3),
            //   width: 1,
            // ),
            // boxShadow: [
            //     BoxShadow(
            //       color: Colors.black.withOpacity(0.10),
            //       blurRadius: 16,
            //       offset: const Offset(0, 4),
            //     ),
            //   ],
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
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,

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
    );
  }

  Widget _buildVariantCard(
    ProjectVariant variant,
    int variantIndex,
    ProjectController controller,
  ) {
    return Container(
      // // elevation: 2,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(AppRadius.medium),
      //   side: BorderSide(color: ColorRes.leadGreyColor[300]!, width: 1),
      // ),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.apartment,
                      color: ColorRes.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${variant.buildingName}',
                      style: const TextStyle(
                        fontSize: AppFontSizes.small,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.white,
                      ),
                    ),
                  ],
                ),
                if (variant.models.isNotEmpty &&
                    variant.models.first.toString().trim().isNotEmpty)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'View 3D',
                          style: TextStyle(
                            fontSize: AppFontSizes.small,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.white,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(
                                    () => ModelRenderScreen(
                                      modelUrl: variant.models.first,
                                      iosModelUrl: variant.models.first,
                                    ),
                                  );
                                },
                        ),
                      ],
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
                            const SizedBox(height: 8),
                            _buildDetailRow(
                              'Available Units',

                              "${variant.totalUnits}/${variant.availableUnits}",
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
            fontWeight: AppFontWeights.medium,
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
      width: double.infinity, // 👈 fixed width
      height: 150, // optional — adjust based on layout
      decoration: BoxDecoration(
        color: ColorRes.leadGreyColor[100],

        image: const DecorationImage(
          image: AssetImage('assets/images/not_available_image.png'),
          fit: BoxFit.cover, // 👈 makes image fill the entire box
        ),
      ),
    );
  }

  // Widget _buildAmenities(ProjectItem project) {
  //   return Container(
  //     margin: const EdgeInsets.only(top: 8),
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //     color: ColorRes.white,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           'Amenities',
  //           style: TextStyle(
  //             fontSize: AppFontSizes.medium,
  //             fontWeight: AppFontWeights.semiBold,
  //             color: ColorRes.textPrimary,
  //           ),
  //         ),
  //         GridView.builder(
  //           shrinkWrap: true,
  //           padding: EdgeInsets.zero,
  //           physics: const NeverScrollableScrollPhysics(),
  //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 3,
  //             childAspectRatio: 0.99,
  //             crossAxisSpacing: 10,
  //             mainAxisSpacing: 1,
  //           ),
  //           itemCount: project.amenities.length,
  //           itemBuilder: (context, index) {
  //             return _buildAmenityItem(
  //               project.amenities[index].toLowerCase().replaceAll(" ", "_"),
  //               index,
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  bool _showAllAmenities = false;

  Widget _buildAmenities(ProjectItem project) {
    final totalAmenities = project.amenities.length;
    final visibleCount =
        (!_showAllAmenities && totalAmenities > 6) ? 6 : totalAmenities;

    return Container(
      // margin: const EdgeInsets.only(top: 8),
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

          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.99,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: visibleCount,
            itemBuilder: (context, index) {
              return _buildAmenityItem(
                project.amenities[index].toLowerCase().replaceAll(" ", "_"),
                index,
              );
            },
          ),

          /// 👉 Show More / Show Less button
          if (totalAmenities > 6)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showAllAmenities = !_showAllAmenities;
                  });
                },
                child: Center(
                  child: Text(
                    _showAllAmenities ? 'Show Less' : 'Show More',
                    style: const TextStyle(
                      fontSize: AppFontSizes.small,
                      fontWeight: AppFontWeights.medium,
                      color: ColorRes.primary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAmenityItem(String amenity, int index) {
    final Map<String, String> amenityIcons = {
      // 🏊 Lifestyle
      'swimming_pool': AppSvgRes.swimming,
      'gym': AppSvgRes.gym,
      'gymnasium': AppSvgRes.gym,
      'club_house': AppSvgRes.club,
      'community_hall': AppSvgRes.hall,
      'multipurpose_hall': AppSvgRes.multi_purpose_hall,
      'children_play_area': AppSvgRes.playground,
      'meditation_area': AppSvgRes.meditation_area,
      'garden': AppSvgRes.garden,
      'gardens': AppSvgRes.garden,
      'gated_community': AppSvgRes.security,
      'jogging_track': AppSvgRes.jogging,
      'amphitheatre': AppSvgRes.home_theater,
      'temple': AppSvgRes.temple ?? AppSvgRes.hall,

      // 🔐 Safety & Security
      '24x7_security': AppSvgRes.security,
      'cctv': AppSvgRes.cctv,
      'cctv_surveillance': AppSvgRes.cctv,
      'intercom': AppSvgRes.intercom ?? AppSvgRes.security,
      'fire_safety': AppSvgRes.fire_extinguisher,

      // ⚡ Utilities
      'power_backup': AppSvgRes.battery,
      'lift': AppSvgRes.elevator,
      'service_lift': AppSvgRes.elevator,
      'solar_panels': AppSvgRes.solar_panel,
      'ev_charging': AppSvgRes.dg,
      'wi-fi_connectivity': AppSvgRes.internet_connectivity,

      // 🚗 Parking
      'covered_parking': AppSvgRes.covered_parking,
      'visitor_parking': AppSvgRes.visitor_parking,

      // 🧹 Services
      'maintenance_staff': AppSvgRes.maintenanace_staff,
      'waste_disposal': AppSvgRes.waste_disposal,
      'laundry_service': AppSvgRes.washing,
    };

    final List<Color> amenityColors = [
      ColorRes.blueColor,
      ColorRes.error,
      ColorRes.leadIndigoColor,
      ColorRes.orangeColor,
      ColorRes.leadTealColor,
      ColorRes.primary,
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
          capitalizeEachWord(amenity),
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
      // margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: ColorRes.homeYellowDark.withOpacity(0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TitleWithViewAll(
                  title: 'Owner Details',
                  icon: Icons.person_outlined,
                  iconBgColor: ColorRes.white,
                  iconColor: ColorRes.deepPurpleColor,
                  showIcon: true,
                ),
              ),
              SizedBox(width: 12),
              GestureDetector(
                onTap: () async {
                  if (!canAddReview.value) return;
                  final result = await Get.to(
                    () => AddReviewScreen(
                      entityType: "project",
                      entityId: project.id ?? '',
                    ),
                  );
                  if (result == true) {
                    canAddReview.value = false;
                    reviewController.refreshList();
                    _overallRatingController.fetchOverallRating(
                      project.id ?? '',
                    );
                  }
                },
                child: Obx(() {
                  final enabled = canAddReview.value;
                  final label = enabled ? "Add Review" : "Reviewed";
                  final color =
                      enabled ? ColorRes.deepPurpleColor : ColorRes.green;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color),
                    ),
                    child: Row(
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              SizedBox(width: 12),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
              decoration: BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 2,

                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportContactSection() {
    final cc =
        Get.isRegistered<ContactController>()
            ? Get.find<ContactController>()
            : Get.put(ContactController());
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Support Team',
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (cc.primaryPhone.value.isEmpty) {
                      await cc.loadContacts(reset: true);
                    }
                    final number = cc.primaryPhone.value;
                    if (number.isNotEmpty) {
                      await ContactHelper.openDialer(number);
                    }
                  },
                  icon: const Icon(Icons.call, size: 18),
                  label: const Text('Call'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorRes.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    if (cc.primaryPhone.value.isEmpty) {
                      await cc.loadContacts(reset: true);
                    }
                    final number = cc.primaryPhone.value;
                    if (number.isNotEmpty) {
                      await ContactHelper.openWhatsApp(
                        number,
                        message:
                            'Hi, I need assistance regarding this project.',
                      );
                    }
                  },
                  icon: Image.asset(
                    'assets/images/whatsapp.png',
                    width: 18,
                    height: 18,
                  ),
                  label: const Text('Chat with Us'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: ColorRes.primary),
                    foregroundColor: ColorRes.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
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

  Container _buildMapSection(
    ProjectController controller,
    ProjectItem projectItem,
  ) {
    return Container(
      color: ColorRes.leadGreyColor.shade50,
      padding: const EdgeInsets.symmetric(vertical: 12),

      child: Column(
        children: [
          if (projectItem.location?.isNotEmpty ?? false) ...[
            const SizedBox(height: 12),
            TitleWithViewAll(
              title: 'Location',
              icon: Icons.location_on,
              // color: ColorRes.textPrimary,
              showIcon: true,
              iconBgColor: Colors.white,
              iconColor: ColorRes.primary,
            ),
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
                // Divider(
                //   indent: 18,
                //   endIndent: 18,
                //   color: ColorRes.leadGreyColor.shade300,
                // ),
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
      // padding: EdgeInsets.only(top: 12),
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
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
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
