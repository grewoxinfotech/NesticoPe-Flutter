import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/manager/data_masker.dart';
import 'package:housing_flutter_app/app/manager/icon_manager.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/constants/size_manager.dart';
import '../../../../data/network/builder/model/builder_model.dart';
import '../../../../data/network/builder/model/builder_projectModel.dart';
import '../../controller/project_controller.dart';
import 'package:get/get.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final ProjectItem projectItem;

  const ProjectDetailsScreen({super.key, required this.projectItem});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProjectController());

    return Scaffold(
      backgroundColor: ColorRes.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, projectItem),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProjectDetails(projectItem),
                _buildConfigurations(controller, projectItem),
                _buildAmenities(projectItem),
                _buildDocuments(controller, projectItem),
                _buildContactSection(controller, projectItem),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
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
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorRes.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.share, color: ColorRes.black),
          ),
        ),
      ],

      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    project.mediaGallery?.images?.first ?? '',
                  ),
                  fit: BoxFit.cover,
                  onError: (_, __) {},
                ),
              ),
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
  //     ProjectController controller,
  //     ProjectItem project,
  //     ) {
  //   // Initialize variant indices
  //   controller.initializeVariantIndices(project.configuration.length);
  //
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //         child: const Text(
  //           'Configurations',
  //           style: TextStyle(
  //             fontSize: AppFontSizes.medium,
  //             fontWeight: AppFontWeights.semiBold,
  //             color: ColorRes.textPrimary,
  //           ),
  //         ),
  //       ),
  //       SizedBox(
  //         height: 420,
  //         child: PageView.builder(
  //           controller: controller.configPageController,
  //           onPageChanged: (index) {
  //             controller.updateConfigPage(index);
  //           },
  //           itemCount: project.configuration.length,
  //           itemBuilder: (context, index) {
  //             print('Current index ${project.configuration[index].bhk}');
  //             return Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 16),
  //               child: _buildConfigurationCard(
  //                 project.configuration[index],
  //                 index,
  //                 controller,
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //       const SizedBox(height: 12),
  //       _buildDotIndicators(controller, project.configuration.length),
  //       const SizedBox(height: 16),
  //     ],
  //   );
  // }
  //
  // Widget _buildConfigurationCard(
  //     Configuration config,
  //     int configIndex,
  //     ProjectController controller,
  //     ) {
  //   return Obx(() {
  //     final currentVariantIndex = controller.variantIndexMap[configIndex] ?? 0;
  //     final variant = config.variants[currentVariantIndex];
  //     print("Current Length ${config.variants.length}  ${config.variants.length > 1} ${controller.variantIndexMap[configIndex]}");
  //     final hasMultipleVariants = config.variants.length > 1;
  //
  //     return Card(
  //       elevation: 2,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(AppRadius.medium),
  //         side: BorderSide(color: ColorRes.leadGreyColor[300]!, width: 1),
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.all(16),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // Header with BHK title and variant navigation button
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         '${config.bhk} BHK Apartments',
  //                         style: const TextStyle(
  //                           fontSize: AppFontSizes.large,
  //                           fontWeight: AppFontWeights.semiBold,
  //                           color: ColorRes.textPrimary,
  //                         ),
  //                       ),
  //                       const SizedBox(height: 4),
  //                       Text(
  //                         'Starting from ${controller.formatCurrency(config.variants.first.price.toDouble())}',
  //                         style: const TextStyle(
  //                           fontSize: AppFontSizes.small,
  //                           color: ColorRes.textSecondary,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 if (hasMultipleVariants)
  //                   Container(
  //                     decoration: BoxDecoration(
  //                       color: ColorRes.primary,
  //                       borderRadius: BorderRadius.circular(8),
  //                     ),
  //                     child: Material(
  //                       color: Colors.transparent,
  //                       child: InkWell(
  //                         borderRadius: BorderRadius.circular(8),
  //                         onTap: () => _showVariantSelector(
  //                           config,
  //                           configIndex,
  //                           controller,
  //                         ),
  //                         child: Padding(
  //                           padding: const EdgeInsets.symmetric(
  //                             horizontal: 12,
  //                             vertical: 8,
  //                           ),
  //                           child: Row(
  //                             mainAxisSize: MainAxisSize.min,
  //                             children: [
  //                               Text(
  //                                 'Variant ${currentVariantIndex + 1}/${config.variants.length}',
  //                                 style: const TextStyle(
  //                                   fontSize: AppFontSizes.small,
  //                                   fontWeight: AppFontWeights.medium,
  //                                   color: ColorRes.white,
  //                                 ),
  //                               ),
  //                               const SizedBox(width: 4),
  //                               const Icon(
  //                                 Icons.arrow_drop_down,
  //                                 color: ColorRes.white,
  //                                 size: 20,
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //               ],
  //             ),
  //             const SizedBox(height: 16),
  //
  //             // Variant images
  //             SizedBox(
  //               height: 180,
  //               child: variant.images.isEmpty
  //                   ? _buildPlaceholderImage()
  //                   : PageView.builder(
  //                 itemCount: variant.images.length,
  //                 itemBuilder: (context, imgIndex) {
  //                   return Container(
  //                     margin: const EdgeInsets.symmetric(horizontal: 4),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(12),
  //                       image: DecorationImage(
  //                         image: NetworkImage(variant.images[imgIndex]),
  //                         fit: BoxFit.cover,
  //                         onError: (exception, stackTrace) {},
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //
  //             // Variant details
  //             Container(
  //               padding: const EdgeInsets.all(12),
  //               decoration: BoxDecoration(
  //                 color: ColorRes.leadGreyColor[50],
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: Column(
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: _buildDetailItem(
  //                           'Carpet Area',
  //                           '${variant.carpetArea.toInt()} sq.ft.',
  //                         ),
  //                       ),
  //                       Expanded(
  //                         child: _buildDetailItem(
  //                           'Built-up Area',
  //                           '${variant.builtUpArea.toInt()} sq.ft.',
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 12),
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: _buildDetailItem(
  //                           'Price/sq.ft',
  //                           controller.formatCurrency(
  //                             variant.pricePerSqFt.toDouble(),
  //                           ),
  //                         ),
  //                       ),
  //                       Expanded(
  //                         child: _buildDetailItem(
  //                           'Available',
  //                           '${variant.availableUnits}/${variant.totalUnits}',
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   });
  // }
  //
  // Widget _buildDetailItem(String label, String value) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         label,
  //         style: const TextStyle(
  //           fontSize: AppFontSizes.caption,
  //           color: ColorRes.textSecondary,
  //         ),
  //       ),
  //       const SizedBox(height: 4),
  //       Text(
  //         value,
  //         style: const TextStyle(
  //           fontSize: AppFontSizes.bodyMedium,
  //           fontWeight: AppFontWeights.medium,
  //           color: ColorRes.textPrimary,
  //         ),
  //       ),
  //     ],
  //   );
  // }
  //
  // Widget _buildPlaceholderImage() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: ColorRes.leadGreyColor[100],
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: const Center(
  //       child: Icon(
  //         Icons.image_outlined,
  //         size: 48,
  //         color: ColorRes.textSecondary,
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildDotIndicators(ProjectController controller, int count) {
  //   return Obx(() => Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: List.generate(
  //       count,
  //           (index) => Container(
  //         margin: const EdgeInsets.symmetric(horizontal: 4),
  //         width: controller.currentConfigPage.value == index ? 24 : 8,
  //         height: 8,
  //         decoration: BoxDecoration(
  //           color: controller.currentConfigPage.value == index
  //               ? ColorRes.primary
  //               : ColorRes.leadGreyColor[300],
  //           borderRadius: BorderRadius.circular(4),
  //         ),
  //       ),
  //     ),
  //   ));
  // }
  //
  // void _showVariantSelector(
  //     Configuration config,
  //     int configIndex,
  //     ProjectController controller,
  //     ) {
  //   Get.bottomSheet(
  //     Container(
  //       padding: const EdgeInsets.all(16),
  //       decoration: const BoxDecoration(
  //         color: ColorRes.white,
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //       ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const Text(
  //             'Select Variant',
  //             style: TextStyle(
  //               fontSize: AppFontSizes.large,
  //               fontWeight: AppFontWeights.semiBold,
  //               color: ColorRes.textPrimary,
  //             ),
  //           ),
  //           const SizedBox(height: 16),
  //           ListView.builder(
  //             shrinkWrap: true,
  //             itemCount: config.variants.length,
  //             itemBuilder: (context, index) {
  //               final variant = config.variants[index];
  //
  //               return Obx(() {
  //                 final isSelected = controller.variantIndexMap.value[configIndex] == index;
  //
  //                 return ListTile(
  //                   contentPadding: const EdgeInsets.symmetric(
  //                     horizontal: 8,
  //                     vertical: 4,
  //                   ),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(8),
  //                     side: BorderSide(
  //                       color: isSelected
  //                           ? ColorRes.primary
  //                           : ColorRes.leadGreyColor[300]!,
  //                       width: isSelected ? 2 : 1,
  //                     ),
  //                   ),
  //                   selected: isSelected,
  //                   selectedTileColor: ColorRes.primary.withOpacity(0.1),
  //                   leading: Container(
  //                     width: 50,
  //                     height: 50,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(8),
  //                       image: variant.images.isNotEmpty
  //                           ? DecorationImage(
  //                         image: NetworkImage(variant.images.first),
  //                         fit: BoxFit.cover,
  //                       )
  //                           : null,
  //                       color: ColorRes.leadGreyColor[100],
  //                     ),
  //                     child: variant.images.isEmpty
  //                         ? const Icon(Icons.image_outlined, size: 24)
  //                         : null,
  //                   ),
  //                   title: Text(
  //                     'Variant ${index + 1}',
  //                     style: TextStyle(
  //                       fontWeight: isSelected
  //                           ? AppFontWeights.semiBold
  //                           : AppFontWeights.medium,
  //                     ),
  //                   ),
  //                   subtitle: Text(
  //                     '${variant.carpetArea.toInt()} sq.ft. • ${controller.formatCurrency(variant.price.toDouble())}',
  //                     style: const TextStyle(fontSize: AppFontSizes.small),
  //                   ),
  //                   trailing: isSelected
  //                       ? const Icon(
  //                     Icons.check_circle,
  //                     color: ColorRes.primary,
  //                   )
  //                       : null,
  //                   onTap: () {
  //                     controller.updateVariantIndex(configIndex, index);
  //                     Get.back();
  //                   },
  //                 );
  //               });
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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

          const SizedBox(height: 12),

          // Horizontal Variants List
          SizedBox(
            height: 340,
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
                      const SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: ColorRes.primary.withOpacity(0.05),
                          border: Border.all(
                            color: ColorRes.primary.withOpacity(0.3),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Contact',
                          style: const TextStyle(
                            fontSize: AppFontSizes.body,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.primary,
                          ),
                        ),
                      ),
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
              return _buildAmenityItem(project.amenities[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityItem(String amenity) {
    final Map<String, IconData> amenityIcons = {
      'Swimming Pool': Icons.pool,
      'Gymnasium': Icons.fitness_center,
      'Parking': Icons.local_parking,
      '24/7 Security': Icons.security,
      'Club House': Icons.house,
      'Spa & Sauna': Icons.spa,
      'Games Room': Icons.sports_esports,
      'Green Park': Icons.park,
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

    return Column(
      children: [
        SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: (amenityColors[amenity.length % amenityColors.length] ??
                    ColorRes.primary)
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            IconManager.getAmenitiesIcon(amenity),
            color:
                amenityColors[amenity.length % amenityColors.length] ??
                ColorRes.primary,
            size: 25,
          ),
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
            'Documents',
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
              'Download',
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
            'Contact Sales Team',
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
}
