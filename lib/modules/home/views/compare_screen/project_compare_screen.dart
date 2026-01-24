import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart'
    hide ColorRes;
import 'package:housing_flutter_app/app/manager/project_compare_manager.dart';
import 'package:housing_flutter_app/data/network/builder/model/builder_model.dart';
import 'package:housing_flutter_app/modules/new_project/view/latest_project.dart';

import '../../../../app/utils/helper_function/user_helper/user_helper.dart';
import '../../../../app/widgets/snack_bar/custom_snackbar.dart';
import '../../../../data/database/secure_storage_service.dart';
import '../../../../widgets/New folder/inputs/text_field.dart';
import '../../../../widgets/messages/snack_bar.dart';
import '../../../auth/views/login_screen.dart';
import '../../../builder/controller/project_controller.dart';
import '../../../property_rating/view/widget/read_more_or_less.dart';
import 'comapre_screen.dart';

class ProjectCompareScreen extends StatelessWidget {
  const ProjectCompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.leadGreyColor[50],
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
          IconButton(
            icon: const Icon(Icons.more_vert, color: ColorRes.black, size: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.medium),
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

            // If only 1 project selected
            if (selected.length == 1) {
              final item = selected[0];
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProjectCardForCompare(
                      item: item,
                      onRemove: () {
                        ProjectCompareManager.to.remove(item.id);
                      },
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(
                              Icons.add_circle_outline,
                              size: 25,
                              color: ColorRes.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Select one more project to compare',
                            style: TextStyle(
                              fontSize: AppFontSizes.medium,
                              fontWeight: AppFontWeights.medium,
                              color: ColorRes.leadGreyColor[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            final a = selected[0];
            final b = selected[1];
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProjectCardForCompare(
                    item: a,
                    onRemove: () {
                      ProjectCompareManager.to.remove(a.id);
                    },
                  ),
                  const SizedBox(height: AppSpacing.small),
                  ProjectCardForCompare(
                    item: b,
                    onRemove: () {
                      ProjectCompareManager.to.remove(b.id);
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Detailed Comparison',
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.bold,
                      color: ColorRes.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ProjectComparisonTable(a: a, b: b),
                  const SizedBox(height: 10),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class ProjectCardForCompare extends StatelessWidget {
  final ProjectItem item;
  final VoidCallback? onRemove;

  const ProjectCardForCompare({super.key, required this.item, this.onRemove});

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
    // final projectController = Get.find<ProjectController>();
    return Material(
      color: ColorRes.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      shadowColor: ColorRes.black.withOpacity(0.06),
      child: Container(
        height: 115,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 1),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                // Image Section
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(11),
                  ),
                  child:
                      (_firstImage(item).isNotEmpty)
                          ? CustomImage(
                            type: CustomImageType.network,
                            src: _firstImage(item),
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
                          _title(item),
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
                          item.address,
                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            color: ColorRes.leadGreyColor[600],
                            height: 1.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // SizedBox(height: 10,),
                        // Status Badge
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(item.status),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item.status.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: AppFontSizes.mini,
                                  fontWeight: AppFontWeights.medium,
                                  color: ColorRes.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Price Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                _price(item),
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
                            GestureDetector(
                              onTap:
                                  (UserHelper.isGuest)
                                      ? () => Get.to(() => LoginScreen())
                                      : () async {
                                        try {
                                          final user =
                                              await SecureStorage.getUserData();

                                          if (user == null) {
                                            NesticoPeSnackBar.showAwesomeSnackbar(
                                              title: 'Error',
                                              message:
                                                  'No user data found. Please log in.',
                                              contentType: ContentType.failure,
                                            );
                                            return;
                                          }

                                          final fullName =
                                              user.user?.fullName ?? '';
                                          final firstName =
                                              user.user?.firstName ?? '';
                                          final username =
                                              user.user?.username ?? '';
                                          final email = user.user?.email ?? '';
                                          final phone = user.user?.phone ?? '';

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
                                              contentType: ContentType.failure,
                                            );
                                            return;
                                          }

                                          addInquiryFromProject(
                                            displayName,
                                            email,
                                            phone,
                                            item.id,
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
                                            contentType: ContentType.failure,
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
                                  'Contact Now',
                                  style: TextStyle(
                                    fontWeight: AppFontWeights.semiBold,
                                    fontSize: AppFontSizes.small,
                                    color: ColorRes.white,
                                  ),
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
            // Remove button
            if (onRemove != null)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onRemove,
                  child: const Icon(
                    Icons.cancel,
                    color: ColorRes.error,
                    size: 16,
                  ),
                ),
              ),
          ],
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

    final _nameController = TextEditingController(text: name);
    final _emailController = TextEditingController(text: email);
    final _phoneController = TextEditingController(text: phone);

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
                          controller: _nameController,
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
                          controller: _emailController,
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
                          controller: _phoneController,
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
                                "name": name ?? "",
                                "phone": phone ?? "",
                                "email": email ?? "",
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
                                controller.hasSubmittedInquiry.value = true;
                                CustomSnackBar.show(
                                  Get.overlayContext!,
                                  message: "Inquiry Added Successfully",
                                  type: SnackBarType.success,
                                );
                                Get.back();
                                await controller.getAllInQuireData(
                                  item.id ?? '',
                                );
                                await controller.getHasInQuireData(
                                  item.id ?? '',
                                );
                              } else {
                                Get.back();
                                CustomSnackBar.show(
                                  Get.overlayContext!,
                                  message: "Failed to Submit Inquiry",
                                  type: SnackBarType.error,
                                );
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
  final ProjectItem a;
  final ProjectItem b;

  const _ProjectComparisonTable({required this.a, required this.b});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.grey.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          _header(),

          // Comparison Rows - Only show if both values exist
          if (!_shouldHide(a.projectName, b.projectName))
            _ComparisonRow(
              icon: Icons.apartment_outlined,
              label: 'Project Name',
              valueA: a.projectName,
              valueB: b.projectName,
            ),

          if (!_shouldHide(a.address, b.address))
            _ComparisonRow(
              icon: Icons.location_on_outlined,
              label: 'Location',
              valueA: a.address,
              isAddress: true,
              valueB: b.address,
            ),

          if (!_shouldHide(a.projectArea, b.projectArea))
            _ComparisonRow(
              icon: Icons.landscape_outlined,
              label: 'Project Area',
              valueA: a.projectArea,
              valueB: b.projectArea,
            ),

          if (!_shouldHide(a.status, b.status))
            _ComparisonRow(
              icon: Icons.construction_outlined,
              label: 'Status',
              valueA: a.status.capitalize ?? a.status,
              valueB: b.status.capitalize ?? b.status,
            ),

          if (!_shouldHide(_getTotalUnits(a), _getTotalUnits(b)))
            _ComparisonRow(
              icon: Icons.home_work_outlined,
              label: 'Total Units',
              valueA: _getTotalUnits(a),
              valueB: _getTotalUnits(b),
              highlightB:
                  (b.projectSize?.totalUnits ?? 0) >
                  (a.projectSize?.totalUnits ?? 0),
            ),

          if (!_shouldHide(_getTotalBuildings(a), _getTotalBuildings(b)))
            _ComparisonRow(
              icon: Icons.business_outlined,
              label: 'Buildings',
              valueA: _getTotalBuildings(a),
              valueB: _getTotalBuildings(b),
              highlightB:
                  (b.projectSize?.totalBuildings ?? 0) >
                  (a.projectSize?.totalBuildings ?? 0),
            ),

          if (!_shouldHide(_getConfigurations(a), _getConfigurations(b)))
            _ComparisonRow(
              icon: Icons.bed_outlined,
              label: 'Configurations',
              valueA: _getConfigurations(a),
              valueB: _getConfigurations(b),
            ),

          if (!_shouldHide(_getPossessionDate(a), _getPossessionDate(b)))
            _ComparisonRow(
              icon: Icons.event_available_outlined,
              label: 'Possession',
              valueA: _getPossessionDate(a),
              valueB: _getPossessionDate(b),
            ),

          if (!_shouldHide(_getAmenities(a), _getAmenities(b)))
            _ComparisonRow(
              icon: Icons.checklist_rtl,
              label: 'Amenities',
              isAddress: true,
              valueA: _getAmenities(a),
              valueB: _getAmenities(b),
              highlightB: b.amenities.length > a.amenities.length,
            ),

          if (!_shouldHide(a.getPriceRange(), b.getPriceRange()))
            _ComparisonRow(
              icon: Icons.currency_rupee,
              label: 'Price Range',
              valueA: a.getPriceRange(),
              valueB: b.getPriceRange(),
              isLast: true,
            ),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: ColorRes.leadGreyColor[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Features',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.small,
              fontWeight: AppFontWeights.medium,
            ),
          ),
          Expanded(
            child: Text(
              a.projectName,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.medium,
              ),
            ),
          ),
          Expanded(
            child: Text(
              b.projectName,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldHide(String? a, String? b) {
    bool empty(String? v) =>
        v == null || v.trim().isEmpty || v == '-' || v == '0';
    return empty(a) && empty(b);
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
