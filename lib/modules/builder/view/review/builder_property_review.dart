// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controller/builder_form_controller.dart';
// // import '../../controllers/project_wizard_controller.dart';
//
// class StepReview extends GetView<ProjectWizardController> {
//   final GlobalKey<FormState> formKey;
//   const StepReview({super.key, required this.formKey});
//
//   @override
//   Widget build(BuildContext context) {
//     print('sdhfdeydfhdbfrefbhnerfrjheferfnherfhn');
//     final theme = Theme.of(context);
//     return Obx(() {
//       final p = controller.project.value;
//       return Form(
//         key: formKey,
//         autovalidateMode: AutovalidateMode.onUserInteraction,
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             // padding: const EdgeInsets.all(16),
//             children: [
//               Row(
//                 children: [
//                   Icon(Icons.rule_folder_outlined, color: theme.colorScheme.primary),
//                   const SizedBox(width: 8),
//                   Text('Review your details', style: theme.textTheme.titleMedium),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Basic', style: theme.textTheme.labelLarge),
//                       const SizedBox(height: 8),
//                       _kv('Project Name', p.projectName),
//                       _kv('Area', '${p.projectArea} sq.ft'),
//                       _kv('Buildings', '${p.projectSize.totalBuildings}'),
//                       _kv('Units', '${p.projectSize.totalUnits}'),
//                       _kv('Launch', p.launchDate.toLocal().toString().split(' ').first),
//                       _kv('Possession', p.possessionDate.toLocal().toString().split(' ').first),
//                       _kv('RERA', p.reraId),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Configurations', style: theme.textTheme.labelLarge),
//                       const SizedBox(height: 8),
//                       ...p.configurations.map((c) => Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 4),
//                         child: Text('${c.bhk} BHK - ${c.variants.length} variants'),
//                       )),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Location', style: theme.textTheme.labelLarge),
//                       const SizedBox(height: 8),
//                       _kv('Address', p.address),
//                       _kv('City/State', '${p.city}, ${p.state}'),
//                       _kv('Zip', p.zipCode),
//                       _kv('Location', p.location),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Additional', style: theme.textTheme.labelLarge),
//                       const SizedBox(height: 8),
//                       _kv('Property Type', p.propertyTypes ?? ''),
//                       _kv('Status', p.status),
//                       _kv('Amenities', p.amenities.join(', ')),
//                       _kv('Highlights', p.projectHighlights.join(', ')),
//                       _kv('Contact', '${p.projectContactInfo?.name ?? ''} | ${p.projectContactInfo?.phone ?? ''} | ${p.projectContactInfo?.email ?? ''}'),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
//
//   Widget _kv(String k, String v) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Expanded(flex: 2, child: Text(k, style: const TextStyle(fontWeight: AppFontWeights.semiBold))),
//           Expanded(flex: 3, child: Text(v)),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart'
    hide ColorRes;
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/widgets/media/media_preview.dart';
import '../../../../data/network/builder/model/builder_model.dart';
import '../../controller/builder_form_controller.dart';
import '../media/upload_media_screen.dart';

class StepReview extends GetView<ProjectWizardController> {
  final GlobalKey<FormState> formKey;

  const StepReview({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      final p = controller.project.value;
      return Form(
        key: formKey,
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              // Hero Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: ColorRes.primary.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: ColorRes.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: ColorRes.primary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.fact_check_rounded,
                            color: ColorRes.white,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Review & Confirm',
                                style: TextStyle(
                                  fontSize: AppFontSizes.medium,
                                  fontWeight: AppFontWeights.semiBold,
                                  color: ColorRes.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Verify all details before submission',
                                style: TextStyle(
                                  fontSize: AppFontSizes.small,
                                  color: ColorRes.textSecondary,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: ColorRes.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ColorRes.primary.withOpacity(0.15),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.home_work,
                            size: 20,
                            color: ColorRes.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              p.projectName,
                              style: TextStyle(
                                fontSize: AppFontSizes.medium,
                                fontWeight: AppFontWeights.semiBold,
                                color: ColorRes.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Key Metrics Grid
              _buildMetricsGrid(theme, p),
              const SizedBox(height: 20),
              // After Key Metrics Grid

              // Before Additional Details
              _buildMediaGallerySection(theme, p),

              // Timeline Section
              _buildTimelineSection(theme, p),
              const SizedBox(height: 20),

              // Configurations
              _buildModernSection(
                theme: theme,
                title: 'Unit Configurations',
                icon: Icons.apartment_rounded,
                child: Column(
                  children:
                      p.configurations.asMap().entries.map((entry) {
                        final config = entry.value;
                        final isLast = entry.key == p.configurations.length - 1;
                        return Column(
                          children: [
                            // _buildConfigCard(theme, config.bhk.toString(), config.variants.length),
                            _buildConfigCardVariant(theme, config, context),
                            if (!isLast) const SizedBox(height: 12),
                          ],
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Location
              _buildModernSection(
                theme: theme,
                title: 'Location',
                icon: Icons.location_on_rounded,
                child: Column(
                  children: [
                    _buildLocationRow(
                      Icons.location_city_rounded,
                      'Address',
                      p.address,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCompactInfo(
                            Icons.location_city,
                            'City',
                            p.city,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildCompactInfo(Icons.map, 'State', p.state),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCompactInfo(
                            Icons.pin_drop,
                            'ZIP',
                            p?.zipCode ?? '',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildCompactInfo(
                            Icons.place,
                            'Area',
                            p.location,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Amenities Section

              // Additional Details
              _buildModernSection(
                theme: theme,
                title: 'Additional Details',
                icon: Icons.info_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (p.propertyTypes != null &&
                        p.propertyTypes!.isNotEmpty) ...[
                      _buildInfoBadge(
                        Icons.business_rounded,
                        'Property Type',
                        p.propertyTypes!,
                      ),
                      const SizedBox(height: 12),
                    ],

                    _buildInfoBadge(Icons.timeline_rounded, 'Status', p.status),
                    if (p.amenities.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _buildFeatureSection(
                        'Amenities',
                        Icons.featured_video_outlined,
                        p.amenities,
                      ),
                    ],
                    if (p.projectHighlights.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 16,
                                color: ColorRes.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Highlight',
                                style: TextStyle(
                                  fontSize: AppFontSizes.bodySmall,
                                  fontWeight: AppFontWeights.semiBold,
                                  color: ColorRes.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: ColorRes.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: ColorRes.primary.withOpacity(0.15),
                              ),
                            ),
                            child: Wrap(
                              children:
                                  p.projectHighlights
                                      .map(
                                        (e) => Text(
                                          ' $e',
                                          style: TextStyle(
                                            fontSize: AppFontSizes.small,
                                            color: ColorRes.textPrimary,
                                            fontWeight: AppFontWeights.medium,
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (p.projectContactInfo != null) ...[
                      const SizedBox(height: 20),
                      _buildContactCard(theme, p.projectContactInfo!),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMetricsGrid(ThemeData theme, dynamic p) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                icon: Icons.square_foot_rounded,
                value: '${p.projectArea}',
                label: 'Sq.Ft',
                color: ColorRes.builderGridPurple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                icon: Icons.apartment_rounded,
                value: '${p.projectSize.totalBuildings}',
                label: 'Buildings',
                color: ColorRes.builderGridPink,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                icon: Icons.meeting_room_rounded,
                value: '${p.projectSize.totalUnits}',
                label: 'Units',
                color: ColorRes.builderGridLightPurple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                icon: Icons.verified_rounded,
                value:
                    p.reraId.length > 8
                        ? '${p.reraId.substring(0, 8)}..'
                        : p.reraId,
                label: 'RERA',
                color: ColorRes.builderGridLightGreen,
                valueSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    double? valueSize,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.02),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              border: Border.all(color: color.withOpacity(0.3), width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12), // Changed from height to width
          Expanded(
            // Wrap Column with Expanded to give it proper constraints
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // Align text to start
              mainAxisSize: MainAxisSize.min,
              // Take minimum vertical space
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: valueSize ?? AppFontSizes.body,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    color: ColorRes.textSecondary,
                    fontWeight: AppFontWeights.medium,
                  ),
                  maxLines: 1, // Added to prevent overflow
                  overflow:
                      TextOverflow.ellipsis, // Added to handle long labels
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection(ThemeData theme, dynamic p) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ColorRes.builderGridLightYellow.withOpacity(0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorRes.builderGridLightYellow.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorRes.builderGridLightYellow.withOpacity(0.08),
                  border: Border.all(
                    color: ColorRes.builderGridLightYellow.withOpacity(0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.schedule_rounded,
                  color: ColorRes.builderGridLightYellow,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Project Timeline',
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDateCard(
                  Icons.rocket_launch_rounded,
                  'Launch',
                  p.launchDate,
                  ColorRes.builderGridLightBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateCard(
                  Icons.key_rounded,
                  'Possession',
                  p.possessionDate,
                  ColorRes.builderGridLightGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard(
    IconData icon,
    String label,
    DateTime date,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  color: ColorRes.textSecondary,
                  fontWeight: AppFontWeights.medium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            date.toLocal().toString().split(' ').first,
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.extraBold,
              color: ColorRes.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernSection({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorRes.leadGreyColor.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: ColorRes.primary.withOpacity(0.06),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ColorRes.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ColorRes.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(icon, size: 18, color: ColorRes.primary),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(18), child: child),
        ],
      ),
    );
  }

  Widget _buildLocationRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: ColorRes.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    fontSize: AppFontSizes.bodySmall,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactInfo(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: ColorRes.primary),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: AppFontSizes.caption,
                  color: ColorRes.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: AppFontSizes.bodySmall,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: ColorRes.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    color: ColorRes.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: AppFontSizes.bodySmall,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureSection(String title, IconData icon, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: ColorRes.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: AppFontSizes.bodySmall,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              items
                  .map(
                    (item) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: ColorRes.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: ColorRes.primary.withOpacity(0.15),
                        ),
                      ),
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: AppFontSizes.small,
                          color: ColorRes.textPrimary,
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildContactCard(ThemeData theme, dynamic contactInfo) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorRes.builderGridLightPurple.withOpacity(0.08),
            ColorRes.builderGridLightPurple.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: ColorRes.builderGridLightPurple.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorRes.builderGridLightPurple.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.contact_phone_rounded,
                  size: 18,
                  color: ColorRes.builderGridLightPurple,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Contact Details',
                style: TextStyle(
                  fontSize: AppFontSizes.bodySmall,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (contactInfo.name != null && contactInfo.name!.isNotEmpty)
            _buildContactItem(Icons.person_rounded, contactInfo.name!),
          if (contactInfo.phone != null && contactInfo.phone!.isNotEmpty)
            _buildContactItem(Icons.phone_rounded, contactInfo.phone!),
          if (contactInfo.email != null && contactInfo.email!.isNotEmpty)
            _buildContactItem(Icons.email_rounded, contactInfo.email!),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: ColorRes.builderGridLightPurple),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: AppFontSizes.bodySmall,
                color: ColorRes.textPrimary,
                fontWeight: AppFontWeights.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. MEDIA GALLERY SECTION
  // Widget _buildMediaGallerySection(ThemeData theme, AddProjectModel p) {
  //   final hasImages = p.imageList != null && p.imageList.isNotEmpty;
  //   final hasVideos = p.videoList != null && p.videoList.isNotEmpty;
  //   final hasBrochure = p.brochure != null && p.brochure!.isNotEmpty;
  //
  //   if (!hasImages && !hasVideos && !hasBrochure) return SizedBox.shrink();
  //
  //   return Column(
  //     children: [
  //       _buildModernSection(
  //         theme: theme,
  //         title: 'Media Gallery',
  //         icon: Icons.photo_library_rounded,
  //         child: Column(
  //           children: [
  //             // Images Preview
  //             if (hasImages) ...[
  //               Row(
  //                 children: [
  //                   Icon(
  //                     Icons.image_rounded,
  //                     size: 16,
  //                     color: ColorRes.primary,
  //                   ),
  //                   const SizedBox(width: 8),
  //                   Text(
  //                     'Project Images',
  //                     style: TextStyle(
  //                       fontSize: AppFontSizes.bodySmall,
  //                       fontWeight: AppFontWeights.semiBold,
  //                       color: ColorRes.textPrimary,
  //                     ),
  //                   ),
  //                   const Spacer(),
  //                   Container(
  //                     padding: const EdgeInsets.symmetric(
  //                       horizontal: 10,
  //                       vertical: 4,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color: ColorRes.primary.withOpacity(0.1),
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     child: Text(
  //                       '${p.imageList.length} Photos',
  //                       style: TextStyle(
  //                         fontSize: AppFontSizes.extraSmall,
  //                         fontWeight: AppFontWeights.semiBold,
  //                         color: ColorRes.primary,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 12),
  //               SizedBox(
  //                 height: 100,
  //                 child: ListView.builder(
  //                   scrollDirection: Axis.horizontal,
  //                   itemCount: p.imageList.length > 5 ? 5 : p.imageList.length,
  //                   itemBuilder: (context, index) {
  //                     final isLast = index == 4 && p.imageList.length > 5;
  //                     return Container(
  //                       width: 120,
  //                       // Fixed width for each item
  //                       height: 100,
  //                       // Fixed height for consistency
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(12),
  //                         border: Border.all(
  //                           color: ColorRes.grey.withOpacity(0.3),
  //                           width: 1,
  //                         ),
  //                       ),
  //                       margin: const EdgeInsets.only(right: 10),
  //                       child: Stack(
  //                         children: [
  //                           ClipRRect(
  //                             borderRadius: BorderRadius.circular(10),
  //                             child: Image.file(
  //                               File(p.imageList[index]),
  //                               width: 140,
  //                               height: 100,
  //                               fit: BoxFit.cover,
  //                               errorBuilder:
  //                                   (context, error, stackTrace) => Container(
  //                                     width: 140,
  //                                     height: 100,
  //                                     decoration: BoxDecoration(
  //                                       color: ColorRes.leadGreyColor.shade200,
  //                                       borderRadius: BorderRadius.circular(12),
  //                                     ),
  //                                     child: Icon(
  //                                       Icons.image,
  //                                       color: ColorRes.leadGreyColor,
  //                                     ),
  //                                   ),
  //                             ),
  //                           ),
  //                           if (isLast)
  //                             Positioned.fill(
  //                               child: Container(
  //                                 decoration: BoxDecoration(
  //                                   color: ColorRes.blackShade54,
  //                                   borderRadius: BorderRadius.circular(12),
  //                                 ),
  //                                 child: Center(
  //                                   child: Text(
  //                                     '+${p.imageList.length - 5}',
  //                                     style: TextStyle(
  //                                       color: ColorRes.white,
  //                                       fontSize: AppFontSizes.medium,
  //                                       fontWeight: AppFontWeights.extraBold,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                         ],
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ],
  //
  //             // Videos Preview
  //             if (hasVideos) ...[
  //               if (hasImages) const SizedBox(height: 20),
  //               Row(
  //                 children: [
  //                   Icon(
  //                     Icons.video_library_rounded,
  //                     size: 16,
  //                     color: ColorRes.builderGridPink,
  //                   ),
  //                   const SizedBox(width: 8),
  //                   Text(
  //                     'Project Videos',
  //                     style: TextStyle(
  //                       fontSize: AppFontSizes.bodySmall,
  //                       fontWeight: AppFontWeights.semiBold,
  //                       color: ColorRes.textPrimary,
  //                     ),
  //                   ),
  //                   const Spacer(),
  //                   Container(
  //                     padding: const EdgeInsets.symmetric(
  //                       horizontal: 10,
  //                       vertical: 4,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color: ColorRes.builderGridPink.withOpacity(0.1),
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     child: Text(
  //                       '${p.videoList.length} Videos',
  //                       style: TextStyle(
  //                         fontSize: AppFontSizes.extraSmall,
  //                         fontWeight: AppFontWeights.semiBold,
  //                         color: ColorRes.builderGridPink,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 12),
  //               SizedBox(
  //                 height: 100,
  //                 child: ListView.builder(
  //                   scrollDirection: Axis.horizontal,
  //                   itemCount: p.videoList.length > 5 ? 5 : p.videoList.length,
  //                   itemBuilder: (context, index) {
  //                     final isLast = index == 4 && p.videoList.length > 5;
  //                     return Container(
  //                       width: 120,
  //                       // Fixed width for each item
  //                       height: 100,
  //                       // Fixed height for consistency
  //                       margin: const EdgeInsets.only(right: 10),
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(12),
  //                         border: Border.all(
  //                           color: ColorRes.grey.withOpacity(0.3),
  //                           width: 1,
  //                         ),
  //                       ),
  //                       child: ClipRRect(
  //                         borderRadius: BorderRadius.circular(10),
  //                         child: Stack(
  //                           fit: StackFit.expand,
  //                           // Now safe because Container has fixed dimensions
  //                           children: [
  //                             FutureBuilder<String?>(
  //                               future: generateVideoThumbnail(
  //                                 p.videoList[index],
  //                               ),
  //                               builder: (context, snapshot) {
  //                                 if (snapshot.connectionState ==
  //                                     ConnectionState.waiting) {
  //                                   return const Center(
  //                                     child: CircularProgressIndicator(
  //                                       strokeWidth: 2,
  //                                     ),
  //                                   );
  //                                 }
  //                                 final thumbPath = snapshot.data;
  //                                 if (thumbPath == null ||
  //                                     !File(thumbPath).existsSync()) {
  //                                   return const Center(
  //                                     child: Icon(
  //                                       Icons.videocam,
  //                                       size: 32,
  //                                       color: ColorRes.leadGreyColor,
  //                                     ),
  //                                   );
  //                                 }
  //                                 return Stack(
  //                                   fit: StackFit.expand,
  //                                   children: [
  //                                     Image.file(
  //                                       File(thumbPath),
  //                                       fit: BoxFit.cover,
  //                                     ),
  //                                     const Center(
  //                                       child: Icon(
  //                                         Icons.play_circle_fill,
  //                                         color: ColorRes.white,
  //                                         size: 32,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 );
  //                               },
  //                             ),
  //                             if (isLast)
  //                               Positioned.fill(
  //                                 child: Container(
  //                                   decoration: BoxDecoration(
  //                                     color: ColorRes.blackShade54,
  //                                     borderRadius: BorderRadius.circular(12),
  //                                   ),
  //                                   child: Center(
  //                                     child: Text(
  //                                       '+${p.videoList.length - 5}',
  //                                       style: TextStyle(
  //                                         color: ColorRes.white,
  //                                         fontSize: AppFontSizes.medium,
  //                                         fontWeight: AppFontWeights.extraBold,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                           ],
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ],
  //
  //             // Brochure
  //             if (hasBrochure) ...[
  //               if (hasImages || hasVideos) const SizedBox(height: 20),
  //               Container(
  //                 padding: const EdgeInsets.all(14),
  //                 decoration: BoxDecoration(
  //                   gradient: LinearGradient(
  //                     begin: Alignment.topLeft,
  //                     end: Alignment.bottomRight,
  //                     colors: [
  //                       ColorRes.builderGridLightPurple.withOpacity(0.08),
  //                       ColorRes.builderGridLightPurple.withOpacity(0.03),
  //                     ],
  //                   ),
  //                   borderRadius: BorderRadius.circular(12),
  //                   border: Border.all(
  //                     color: ColorRes.builderGridLightPurple.withOpacity(0.3),
  //                   ),
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     Container(
  //                       padding: const EdgeInsets.all(10),
  //                       decoration: BoxDecoration(
  //                         color: ColorRes.builderGridLightPurple.withOpacity(
  //                           0.15,
  //                         ),
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       child: Icon(
  //                         Icons.picture_as_pdf_rounded,
  //                         color: ColorRes.builderGridLightPurple,
  //                         size: 24,
  //                       ),
  //                     ),
  //                     const SizedBox(width: 14),
  //                     Expanded(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             'Project Brochure',
  //                             style: TextStyle(
  //                               fontSize: AppFontSizes.bodySmall,
  //                               fontWeight: AppFontWeights.semiBold,
  //                               color: ColorRes.textPrimary,
  //                             ),
  //                           ),
  //                           const SizedBox(height: 4),
  //                           Text(
  //                             '${p.brochure}',
  //                             maxLines: 1,
  //                             overflow: TextOverflow.ellipsis,
  //                             style: TextStyle(
  //                               fontSize: AppFontSizes.small,
  //                               color: ColorRes.textSecondary,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ],
  //         ),
  //       ),
  //       const SizedBox(height: 20),
  //     ],
  //   );
  // }

  Widget _buildMediaGallerySection(ThemeData theme, AddProjectModel p) {
    final hasImages = p.imageList != null && p.imageList.isNotEmpty;
    final hasVideos = p.videoList != null && p.videoList.isNotEmpty;
    final hasBrochure = p.brochure != null && p.brochure!.isNotEmpty;

    if (!hasImages && !hasVideos && !hasBrochure)
      return const SizedBox.shrink();

    return Column(
      children: [
        _buildModernSection(
          theme: theme,
          title: 'Media Gallery',
          icon: Icons.photo_library_rounded,
          child: Column(
            children: [
              // ---------------- IMAGES ----------------
              if (hasImages) ...[
                Row(
                  children: [
                    Icon(
                      Icons.image_rounded,
                      size: 16,
                      color: ColorRes.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Project Images',
                      style: TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ColorRes.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${p.imageList.length} Photos',
                        style: TextStyle(
                          fontSize: AppFontSizes.extraSmall,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: p.imageList.length > 5 ? 5 : p.imageList.length,
                    itemBuilder: (context, index) {
                      final isLast = index == 4 && p.imageList.length > 5;
                      final imagePath = p.imageList[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => MediaPreviewScreen(url: imagePath));
                        },
                        child: Container(
                          width: 120,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: ColorRes.grey.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          margin: const EdgeInsets.only(right: 10),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CustomImage(
                                  type: CustomImageType.network,
                                  src: imagePath,
                                  width: 140,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                // Image.file(
                                //   File(imagePath),
                                //   width: 140,
                                //   height: 100,
                                //   fit: BoxFit.cover,
                                //   errorBuilder:
                                //       (context, error, stackTrace) => Container(
                                //         decoration: BoxDecoration(
                                //           color:
                                //               ColorRes.leadGreyColor.shade200,
                                //           borderRadius: BorderRadius.circular(
                                //             12,
                                //           ),
                                //         ),
                                //         child: Icon(
                                //           Icons.image,
                                //           color: ColorRes.leadGreyColor,
                                //         ),
                                //       ),
                                // ),
                              ),
                              if (isLast)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ColorRes.blackShade54,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '+${p.imageList.length - 5}',
                                        style: TextStyle(
                                          color: ColorRes.white,
                                          fontSize: AppFontSizes.medium,
                                          fontWeight: AppFontWeights.extraBold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],

              // ---------------- VIDEOS ----------------
              if (hasVideos) ...[
                if (hasImages) const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      Icons.video_library_rounded,
                      size: 16,
                      color: ColorRes.builderGridPink,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Project Videos',
                      style: TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ColorRes.builderGridPink.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${p.videoList.length} Videos',
                        style: TextStyle(
                          fontSize: AppFontSizes.extraSmall,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.builderGridPink,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: p.videoList.length > 5 ? 5 : p.videoList.length,
                    itemBuilder: (context, index) {
                      final videoPath = p.videoList[index];
                      final isLast = index == 4 && p.videoList.length > 5;
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => MediaPreviewScreen(url: videoPath));
                        },
                        child: Container(
                          width: 120,
                          height: 100,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: ColorRes.grey.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                FutureBuilder<String?>(
                                  future: generateVideoThumbnail(videoPath),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      );
                                    }
                                    final thumbPath = snapshot.data;
                                    if (thumbPath == null ||
                                        !File(thumbPath).existsSync()) {
                                      return const Center(
                                        child: Icon(
                                          Icons.videocam,
                                          size: 32,
                                          color: ColorRes.leadGreyColor,
                                        ),
                                      );
                                    }
                                    return Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.file(
                                          File(thumbPath),
                                          fit: BoxFit.cover,
                                        ),
                                        const Center(
                                          child: Icon(
                                            Icons.play_circle_fill,
                                            color: ColorRes.white,
                                            size: 32,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                if (isLast)
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: ColorRes.blackShade54,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '+${p.videoList.length - 5}',
                                          style: TextStyle(
                                            color: ColorRes.white,
                                            fontSize: AppFontSizes.medium,
                                            fontWeight:
                                                AppFontWeights.extraBold,
                                          ),
                                        ),
                                      ),
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

              // ---------------- BROCHURE ----------------
              if (hasBrochure) ...[
                if (hasImages || hasVideos) const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ColorRes.builderGridLightPurple.withOpacity(0.08),
                        ColorRes.builderGridLightPurple.withOpacity(0.03),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ColorRes.builderGridLightPurple.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ColorRes.builderGridLightPurple.withOpacity(
                            0.15,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.picture_as_pdf_rounded,
                          color: ColorRes.builderGridLightPurple,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Project Brochure',
                              style: TextStyle(
                                fontSize: AppFontSizes.bodySmall,
                                fontWeight: AppFontWeights.semiBold,
                                color: ColorRes.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${p.brochure}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: AppFontSizes.small,
                                color: ColorRes.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _showVariantBottomSheet(
    BuildContext context,
    ProjectConfiguration config,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          minChildSize: 0.2,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: ColorRes.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: ColorRes.primary.withOpacity(0.08),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: ColorRes.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              config.bhk.toString(),
                              style: TextStyle(
                                fontSize: AppFontSizes.body,
                                fontWeight: AppFontWeights.semiBold,
                                color: ColorRes.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${config.bhk} BHK Configuration',
                                style: TextStyle(
                                  fontSize: AppFontSizes.small,
                                  fontWeight: AppFontWeights.semiBold,
                                  color: ColorRes.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${config.variants.length} Variants Available',
                                style: TextStyle(
                                  fontSize: AppFontSizes.small,
                                  color: ColorRes.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close,
                            color: ColorRes.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Variants list
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      itemCount: config.variants.length,
                      itemBuilder: (context, index) {
                        final variant = config.variants[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: ColorRes.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: ColorRes.primary.withOpacity(0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: ColorRes.leadGreyColor.shade200,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Variant Header
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorRes.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      variant.name,
                                      style: TextStyle(
                                        fontSize: AppFontSizes.bodySmall,
                                        fontWeight: AppFontWeights.extraBold,
                                        color: ColorRes.primary,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  if (variant.availableUnits > 0)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorRes.builderGridLightGreen
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.check_circle,
                                            size: 12,
                                            color:
                                                ColorRes.builderGridLightGreen,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Available',
                                            style: TextStyle(
                                              fontSize: AppFontSizes.extraSmall,
                                              fontWeight:
                                                  AppFontWeights.semiBold,
                                              color:
                                                  ColorRes
                                                      .builderGridLightGreen,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorRes.error.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Sold Out',
                                        style: TextStyle(
                                          fontSize: AppFontSizes.extraSmall,
                                          fontWeight: AppFontWeights.semiBold,
                                          color: ColorRes.error.shade700,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Price
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      ColorRes.builderGridLightGreen
                                          .withOpacity(0.08),
                                      ColorRes.builderGridLightGreen
                                          .withOpacity(0.03),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Price',
                                          style: TextStyle(
                                            fontSize: AppFontSizes.small,
                                            color: ColorRes.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '₹${_formatPrice(variant.price)}',
                                          style: TextStyle(
                                            fontSize: AppFontSizes.body,
                                            fontWeight:
                                                AppFontWeights.extraBold,
                                            color:
                                                ColorRes.builderGridLightGreen,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (variant.pricePerSqFt != null)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Per Sq.Ft',
                                            style: TextStyle(
                                              fontSize: AppFontSizes.small,
                                              color: ColorRes.textSecondary,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '₹${_formatPrice(variant.pricePerSqFt!)}',
                                            style: TextStyle(
                                              fontSize: AppFontSizes.bodySmall,
                                              fontWeight:
                                                  AppFontWeights.semiBold,
                                              color: ColorRes.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Area Details
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildVariantInfoCard(
                                      Icons.square_foot_rounded,
                                      'Built-up Area',
                                      '${variant.builtUpArea}',
                                      ColorRes.builderGridPurple,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _buildVariantInfoCard(
                                      Icons.space_dashboard_rounded,
                                      'Carpet Area',
                                      '${variant.carpetArea}',
                                      ColorRes.builderGridLightPurple,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Units Info
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildVariantInfoCard(
                                      Icons.apartment_rounded,
                                      'Total Units',
                                      '${variant.totalUnits}',
                                      ColorRes.builderGridPink,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _buildVariantInfoCard(
                                      Icons.meeting_room_rounded,
                                      'Available',
                                      '${variant.availableUnits}',
                                      ColorRes.builderGridLightGreen,
                                    ),
                                  ),
                                ],
                              ),

                              // Specifications
                              if (variant.specifications.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                const Divider(),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.checklist_rounded,
                                      size: 16,
                                      color: ColorRes.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Specifications',
                                      style: TextStyle(
                                        fontSize: AppFontSizes.bodySmall,
                                        fontWeight: AppFontWeights.semiBold,
                                        color: ColorRes.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children:
                                      variant.specifications
                                          .map(
                                            (item) => Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: ColorRes.primary
                                                    .withOpacity(0.08),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: ColorRes.primary
                                                      .withOpacity(0.15),
                                                ),
                                              ),
                                              child: Text(
                                                item,
                                                style: TextStyle(
                                                  fontSize: AppFontSizes.small,
                                                  color: ColorRes.textPrimary,
                                                  fontWeight:
                                                      AppFontWeights.medium,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVariantInfoCard(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: AppFontSizes.extraSmall,
                    color: ColorRes.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // Helper function for price formatting
  String _formatPrice(double price) {
    if (price >= 10000000) {
      return '${(price / 10000000).toStringAsFixed(2)} Cr';
    } else if (price >= 100000) {
      return '${(price / 100000).toStringAsFixed(2)} L';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(2)} K';
    }
    return price.toStringAsFixed(2);
  }

  Widget _buildConfigCardVariant(
    ThemeData theme,
    ProjectConfiguration config,
    BuildContext context,
  ) {
    return InkWell(
      onTap: () => _showVariantBottomSheet(context, config),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: ColorRes.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: ColorRes.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  config.bhk.toString(),
                  style: TextStyle(
                    fontSize: AppFontSizes.body,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${config.bhk} BHK Configuration',
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.apartment,
                        size: 14,
                        color: ColorRes.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${config.variants.length} variant${config.variants.length > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: AppFontSizes.extraSmall,
                          color: ColorRes.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: ColorRes.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
