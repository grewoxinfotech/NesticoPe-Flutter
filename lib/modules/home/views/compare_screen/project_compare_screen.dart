import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/app/widgets/image/custom_image.dart'
    hide ColorRes;
import 'package:nesticope_app/app/manager/project_compare_manager.dart';
import 'package:nesticope_app/data/network/builder/model/builder_model.dart';
import 'package:nesticope_app/modules/builder/view/all_project_list_screen.dart';
import 'package:nesticope_app/modules/builder/view/project_detail/project_detail.dart';
import 'package:nesticope_app/modules/new_project/view/latest_project.dart';

import '../../../../app/utils/helper_function/user_helper/user_helper.dart';
import '../../../../app/widgets/snack_bar/custom_snackbar.dart';
import '../../../../data/database/secure_storage_service.dart';
import '../../../../data/network/auth/model/user_model.dart';
import '../../../../data/network/property/services/property_contacted_service.dart';
import '../../../../widgets/New folder/inputs/text_field.dart';
import '../../../../widgets/messages/snack_bar.dart';
import '../../../auth/views/login_screen.dart';
import '../../../builder/controller/project_controller.dart';
import '../../../property_rating/view/widget/read_more_or_less.dart';
import 'comapre_screen.dart';

class ProjectCompareScreen extends StatefulWidget {
  const ProjectCompareScreen({super.key});

  @override
  State<ProjectCompareScreen> createState() => _ProjectCompareScreenState();
}

class _ProjectCompareScreenState extends State<ProjectCompareScreen> {
  final projectController = Get.put(ProjectController());
  final PropertyContactedService _contactedService = PropertyContactedService();
  final PageController _projectCardsController = PageController(
    viewportFraction: 0.94,
  );
  final PageController _comparisonCardsController = PageController();
  int _currentProjectCard = 0;
  String? _activeProjectId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final selected = ProjectCompareManager.to.selectedList;

      loadData(selected[0].id ?? '');
      loadDataSecond(selected[1].id ?? '');
    });
  }

  Future<void> loadData(String propertyId) async {
    try {
      final UserModel user = await SecureStorage.getUserData() ?? UserModel();
      final userId = user.user?.id ?? '';
      projectController.isCompareProjectFirst.value = await _contactedService
          .fetchHasInquiries(userId, itemId: propertyId);
    } catch (e, s) {
      log(
        '[PropertyDetail] ERROR in _loadData',
        error: e,
        stackTrace: s,
        level: 1000,
      );
    }
  }

  Future<void> loadDataSecond(String propertyId) async {
    try {
      final UserModel user = await SecureStorage.getUserData() ?? UserModel();
      final userId = user.user?.id ?? '';

      final inquiries = await _contactedService.fetchContactedInquiries(userId);
      projectController.inquiryResponse.assignAll(inquiries);

      final result = projectController.inquiryResponse.any(
        (e) => e.propertyId == propertyId,
      );

      projectController.isCompareProjectSecond.value = result;
      // await controller.getAllInQuireData(propertyId);
      // await controller.getHasInQuireData(propertyId);
    } catch (e, s) {
      log(
        '[PropertyDetail] ERROR in _loadData',
        error: e,
        stackTrace: s,
        level: 1000,
      );
    }
  }

  void _syncTopWithBottom(int index) {
    if (!_projectCardsController.hasClients) return;
    final current = _projectCardsController.page?.round() ?? 0;
    if (current == index) return;
    _projectCardsController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void _syncBottomWithTop(int index) {
    if (!_comparisonCardsController.hasClients) return;
    final current = _comparisonCardsController.page?.round() ?? 0;
    if (current == index) return;
    _comparisonCardsController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _projectCardsController.dispose();
    _comparisonCardsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Project Comparison',
          style: TextStyle(
            color: ColorRes.black,
            fontWeight: AppFontWeights.bold,
          ),
        ),
        actions: [
          if (ProjectCompareManager.to.selectedList.length < 5)
            TextButton(
              onPressed:
                  () => Get.to(
                    () => AllProjectListScreen(isbuilder: false),
                    transition: Transition.fadeIn,

                    duration: Duration(milliseconds: 250),
                  ),
              child: Text(
                '+ Add',
                style: TextStyle(
                  // fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.medium,
                  color: ColorRes.primary,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          final selected = ProjectCompareManager.to.selectedList;

          // If no projects selected
          if (selected.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.compare_arrows,
                      size: 64,
                      color: ColorRes.leadGreyColor[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No projects selected',
                      style: TextStyle(
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.leadGreyColor[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select projects from Explore Projects to compare',
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        color: ColorRes.leadGreyColor[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // // If only 1 project selected
          // if (selected.length == 1) {
          //   final item = selected[0];
          //   return SingleChildScrollView(
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Obx(
          //           () => ProjectCardForCompare(
          //             item: item,
          //             isSubmitted:
          //                 projectController.isCompareProjectFirst.value,
          //             onRemove: () {
          //               ProjectCompareManager.to.remove(item.id);
          //             },
          //           ),
          //         ),
          //         const SizedBox(height: 24),
          //         Center(
          //           child: Column(
          //             children: [
          //               GestureDetector(
          //                 onTap: () {
          //                   Get.back();
          //                 },
          //                 child: const Icon(
          //                   Icons.add_circle_outline,
          //                   size: 25,
          //                   color: ColorRes.primary,
          //                 ),
          //               ),
          //               const SizedBox(height: 12),
          //               Text(
          //                 'Select one more project to compare',
          //                 style: TextStyle(
          //                   fontSize: AppFontSizes.medium,
          //                   fontWeight: AppFontWeights.medium,
          //                   color: ColorRes.leadGreyColor[700],
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   );
          // }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                SizedBox(
                  height: 116,
                  child: PageView.builder(
                    controller: _projectCardsController,
                    itemCount: selected.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentProjectCard = index;
                      });
                      _syncBottomWithTop(index);
                    },
                    itemBuilder: (context, index) {
                      final item = selected[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ProjectCardForCompare(
                          item: item,
                          isActive: item.id == _activeProjectId,
                          isSubmitted:
                              projectController.isCompareProjectFirst.value,
                          onRemove: () {
                            ProjectCompareManager.to.remove(item.id);
                          },
                        ),
                      );
                    },
                  ),
                ),
                if (selected.length > 1) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      selected.length,
                      (index) => GestureDetector(
                        onTap: () {
                          _projectCardsController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                          );
                          _syncBottomWithTop(index);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentProjectCard == index ? 18 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color:
                                _currentProjectCard == index
                                    ? ColorRes.primary
                                    : ColorRes.leadGreyColor.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.medium),
                  child: Text(
                    'Detailed Comparison',
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.bold,
                      color: ColorRes.black,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _ProjectComparisonTable(
                  items: selected,
                  pageController: _comparisonCardsController,
                  currentPage: _currentProjectCard,
                  onPageChanged: (index) {
                    _syncTopWithBottom(index);
                    setState(() {
                      _currentProjectCard = index;
                    });
                  },
                  onActiveChange: (id) {
                    setState(() {
                      _activeProjectId = id;
                    });
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class ProjectCardForCompare extends StatefulWidget {
  final ProjectItem item;
  final VoidCallback? onRemove;
  final bool isSubmitted;
  final bool isActive;

  const ProjectCardForCompare({
    super.key,
    required this.item,
    this.onRemove,
    required this.isSubmitted,
    this.isActive = false,
  });

  @override
  State<ProjectCardForCompare> createState() => _ProjectCardForCompareState();
}

class _ProjectCardForCompareState extends State<ProjectCardForCompare> {
  final projectController = Get.put(ProjectController());

  String _firstImage(ProjectItem i) {
    final imgs = i.mediaGallery?.images;
    if (imgs != null && imgs.isNotEmpty) return imgs.first;
    return '';
  }

  String _title(ProjectItem i) {
    return i.projectName;
  }

  String _price(ProjectItem i) {
    return i.getPriceRange();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () {
          Get.to(() => ProjectDetailsScreen(projectItem: widget.item));
        },
        child: Material(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(12),
          elevation: 1,
          shadowColor: ColorRes.black.withOpacity(0.06),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow:
                  widget.isActive
                      ? [
                        BoxShadow(
                          color: ColorRes.primary.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 2,

                          offset: const Offset(0, 3),
                        ),
                      ],
              border:
                  widget.isActive
                      ? Border.all(color: ColorRes.primary, width: 2)
                      : null,
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    // Image Section
                    ClipRRect(
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(10),
                      ),
                      child:
                          (_firstImage(widget.item).isNotEmpty)
                              ? CustomImage(
                                type: CustomImageType.network,
                                src: _firstImage(widget.item),
                                width: 120,
                                height: 121,
                                fit: BoxFit.cover,
                              )
                              : Container(
                                width: 120,
                                height: 121,
                                color: ColorRes.leadGreyColor.shade200,
                                child: const Icon(
                                  Icons.image,
                                  color: ColorRes.grey,
                                ),
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
                            Text(
                              _title(widget.item),
                              style: const TextStyle(
                                fontSize: AppFontSizes.bodyMedium,
                                fontWeight: AppFontWeights.semiBold,
                                color: ColorRes.textColor,
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            // Address
                            Text(
                              widget.item.address,
                              style: TextStyle(
                                fontSize: AppFontSizes.extraSmall,
                                fontWeight: AppFontWeights.medium,
                                color: ColorRes.leadGreyColor[700],
                                height: 1.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // SizedBox(height: 10,),
                            // Status Badge
                            // Row(
                            //   mainAxisSize: MainAxisSize.min,
                            //   children: [
                            //     Container(
                            //       padding: const EdgeInsets.symmetric(
                            //         horizontal: 8,
                            //         vertical: 3,
                            //       ),
                            //       decoration: BoxDecoration(
                            //         color: _getStatusColor(widget.item.status),
                            //         borderRadius: BorderRadius.circular(4),
                            //       ),
                            //       child: Text(
                            //         widget.item.status.toUpperCase(),
                            //         style: const TextStyle(
                            //           fontSize: AppFontSizes.mini,
                            //           fontWeight: AppFontWeights.medium,
                            //           color: ColorRes.white,
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),

                            // Price Row
                            Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    _price(widget.item),
                                    style: const TextStyle(
                                      fontSize: AppFontSizes.medium,
                                      fontWeight: AppFontWeights.bold,
                                      color: ColorRes.textColor,
                                      height: 1,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 10),
                                if (widget.isSubmitted) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorRes.success.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: ColorRes.success,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.check_circle_outline,
                                          color: ColorRes.success,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Submitted',
                                          style: TextStyle(
                                            color: ColorRes.success,
                                            fontSize: AppFontSizes.small,
                                            fontWeight: AppFontWeights.semiBold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ] else ...[
                                  GestureDetector(
                                    onTap:
                                        (UserHelper.isGuest)
                                            ? () {
                                              // try {
                                              //   if (Get.context == null) {
                                              //     NesticoPeSnackBar.showAwesomeSnackbar(
                                              //       title: 'Error',
                                              //       message:
                                              //           'UI not ready to show dialog.',
                                              //       contentType:
                                              //           ContentType.failure,
                                              //     );
                                              //     return;
                                              //   }

                                              //   addInquiryFromProject(
                                              //     '',
                                              //     '',
                                              //     '',
                                              //     widget.item.id,
                                              //     'sell',
                                              //     "project",
                                              //   );
                                              // } catch (e, s) {
                                              //   debugPrint(
                                              //     '❌ Error in Get Offer button: $e',
                                              //   );
                                              //   debugPrint('$s');

                                              //   NesticoPeSnackBar.showAwesomeSnackbar(
                                              //     title: 'Error',
                                              //     message:
                                              //         'Something went wrong. Please try again.',
                                              //     contentType:
                                              //         ContentType.failure,
                                              //   );
                                              // }
                                              Get.to(() => LoginScreen());
                                            }
                                            : () async {
                                              try {
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

                                                if (Get.context == null) {
                                                  NesticoPeSnackBar.showAwesomeSnackbar(
                                                    title: 'Error',
                                                    message:
                                                        'UI not ready to show dialog.',
                                                    contentType:
                                                        ContentType.failure,
                                                  );
                                                  return;
                                                }

                                                addInquiryFromProject(
                                                  displayName,
                                                  email,
                                                  phone,
                                                  widget.item.id,
                                                  'sell',
                                                  "project",
                                                );
                                              } catch (e, s) {
                                                debugPrint(
                                                  '❌ Error in Get Offer button: $e',
                                                );
                                                debugPrint('$s');

                                                NesticoPeSnackBar.showAwesomeSnackbar(
                                                  title: 'Error',
                                                  message:
                                                      'Something went wrong. Please try again.',
                                                  contentType:
                                                      ContentType.failure,
                                                );
                                              }
                                            },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorRes.primary,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '${projectController.hasSubmittedInquiry.value ? 'Submitted' : 'Contact Now'}',
                                        style: TextStyle(
                                          fontWeight: AppFontWeights.semiBold,
                                          fontSize: AppFontSizes.small,
                                          color: ColorRes.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
                // Remove button
                if (widget.onRemove != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: widget.onRemove,
                      child: Icon(
                        Icons.cancel,
                        color: ColorRes.error,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
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
                                /*  CustomSnackBar.show(
                                  Get.overlayContext!,
                                  message: "Inquiry Added Successfully",
                                  type: SnackBarType.success,
                                );*/
                                Get.back();

                                await controller.getAllInQuireData(
                                  widget.item.id ?? '',
                                );
                                await controller.getHasInQuireData(
                                  widget.item.id ?? '',
                                );
                              } else {
                                Get.back();
                                /*CustomSnackBar.show(
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
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
}

class _ProjectComparisonTable extends StatelessWidget {
  final List<ProjectItem> items;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int>? onPageChanged;
  final ValueChanged<String>? onActiveChange;
  const _ProjectComparisonTable({
    required this.items,
    required this.pageController,
    required this.currentPage,
    this.onPageChanged,
    this.onActiveChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 616,
          child: PageView.builder(
            controller: pageController,
            itemCount: items.length,
            onPageChanged: (i) {
              onPageChanged?.call(i);
              final item = items[i];
              onActiveChange?.call(item.id);
            },
            itemBuilder: (context, index) {
              final item = items[index];
              return _ProjectDetailsCard(item: item);
            },
          ),
        ),
        const SizedBox(height: 12),
        if (items.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              items.length,
              (index) => GestureDetector(
                onTap: () {
                  pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  onPageChanged?.call(index);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color:
                        currentPage == index
                            ? ColorRes.primary
                            : ColorRes.leadGreyColor[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ProjectDetailsCard extends StatelessWidget {
  final ProjectItem item;
  const _ProjectDetailsCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.grey.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
            decoration: BoxDecoration(
              color: ColorRes.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.projectName,
                    style: const TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.bold,
                      color: ColorRes.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Column(
            spacing: 5,
            children: [
              _row('Location', item.address),
              Divider(color: ColorRes.leadGreyColor.shade300),
              _row('Project Area', item.projectArea),
              Divider(color: ColorRes.leadGreyColor.shade300),
              _row('Status', item.status.capitalize ?? item.status),
              Divider(color: ColorRes.leadGreyColor.shade300),
              _row('Total Units', _getTotalUnits(item)),
              Divider(color: ColorRes.leadGreyColor.shade300),
              _row('Buildings', _getTotalBuildings(item)),
              Divider(color: ColorRes.leadGreyColor.shade300),
              _row('Configurations', _getConfigurations(item)),
              Divider(color: ColorRes.leadGreyColor.shade300),
              _row('Possession', _getPossessionDate(item)),
              Divider(color: ColorRes.leadGreyColor.shade300),
              _row('Amenities', _getAmenities(item)),
              Divider(color: ColorRes.leadGreyColor.shade300),
              _row('Price Range', item.getPriceRange()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppFontSizes.caption,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.leadGreyColor[700],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTotalUnits(ProjectItem item) {
    final units = item.projectSize?.totalUnits;
    return units != null && units > 0 ? units.toString() : '-';
  }

  String _getTotalBuildings(ProjectItem item) {
    final buildings = item.projectSize?.totalBuildings;
    return buildings != null && buildings > 0 ? buildings.toString() : '-';
  }

  String _getConfigurations(ProjectItem item) {
    if (item.configuration.isEmpty) return '-';
    final configs = item.configuration.map((c) => '${c.bhk} BHK').toSet();
    return configs.join(', ');
  }

  String _getPossessionDate(ProjectItem item) {
    if (item.possessionDate == null || item.possessionDate!.isEmpty) {
      return '-';
    }
    try {
      final date = DateTime.parse(item.possessionDate!);
      return '${_getMonthName(date.month)} ${date.year}';
    } catch (e) {
      return item.possessionDate ?? '-';
    }
  }

  String _getMonthName(int month) {
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
    return months[month - 1];
  }

  String _getAmenities(ProjectItem item) {
    if (item.amenities.isEmpty) return '-';
    return item.amenities.take(4).join(', ');
  }
}

class _ComparisonRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isAddress;
  final String valueA;
  final String valueB;
  final bool highlightB;
  final bool isLast;

  const _ComparisonRow({
    required this.icon,
    required this.label,
    required this.valueA,
    required this.valueB,
    this.isAddress = false,
    this.highlightB = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        border:
            isLast
                ? null
                : Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppFontSizes.caption,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.leadGreyColor[700],
              ),
            ),
          ),

          Expanded(
            child:
                (isAddress)
                    ? ReadMoreClass(
                      description: valueA,
                      trimLines: 3,
                      size: AppFontSizes.small,
                      colorClickableText: ColorRes.primary,
                    )
                    : Text(
                      valueA,

                      style: const TextStyle(
                        fontSize: AppFontSizes.small,
                        fontWeight: AppFontWeights.medium,
                        color: ColorRes.textColor,
                      ),
                    ),
          ),

          Expanded(
            child: Container(
              padding:
                  highlightB ? const EdgeInsets.symmetric(vertical: 6) : null,
              child:
                  (isAddress)
                      ? ReadMoreClass(
                        description: valueB,
                        trimLines: 3,
                        size: AppFontSizes.small,
                        colorClickableText: ColorRes.primary,
                      )
                      : Text(
                        valueB,

                        style: const TextStyle(
                          fontSize: AppFontSizes.small,
                          fontWeight: AppFontWeights.medium,
                          color: ColorRes.textColor,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
