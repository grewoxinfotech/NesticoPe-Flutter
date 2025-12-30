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

import '../../../property_rating/view/widget/read_more_or_less.dart';

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
                              onTap: () {
                                // Get.to(
                                //   () => ProjectDetailsScreen(projectItem: item),
                                // );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorRes.primary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Visit',
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
