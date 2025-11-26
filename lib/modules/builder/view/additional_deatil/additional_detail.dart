// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// // import '../../../data/validators/project_validators.dart';
// import '../../controller/builder_form_controller.dart';
// import '../../model/config_model.dart';
// import '../widget/common_builder_textfield.dart';
// import '../widget/validation/validation.dart';
//
// class StepAdditional extends GetView<ProjectWizardController> {
//   final GlobalKey<FormState> formKey;
//
//   const StepAdditional({super.key, required this.formKey});
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     const amenityDummy = <String>[
//       'Gym',
//       'Swimming Pool',
//       'Playground',
//       'Club House',
//       'Garden',
//       'CCTV',
//       'Lift',
//       'Power Backup',
//       'Intercom',
//       'Cafeteria',
//     ];
//     return Obx(() {
//       final p = controller.project.value;
//       return Form(
//         key: formKey,
//         autovalidateMode: AutovalidateMode.onUserInteraction,
//         child: SingleChildScrollView(
//           child: Column(
//             // padding: const EdgeInsets.all(16),
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Icon(
//                     Icons.more_horiz_outlined,
//                     color: theme.colorScheme.primary,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Additional Details',
//                     style: theme.textTheme.titleMedium,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//
//               DropdownButtonFormField<String>(
//                 value:
//                     p.propertyTypes?.isEmpty == true ? null : p.propertyTypes,
//                 items: const [
//                   DropdownMenuItem(
//                     value: 'apartment',
//                     child: Text('Apartment'),
//                   ),
//                   DropdownMenuItem(value: 'house', child: Text('House')),
//                   DropdownMenuItem(value: 'villa', child: Text('Villa')),
//                   DropdownMenuItem(value: 'plot', child: Text('Plot')),
//                   DropdownMenuItem(value: 'office', child: Text('Office')),
//                   DropdownMenuItem(value: 'shop', child: Text('Shop')),
//                   DropdownMenuItem(value: 'showroom', child: Text('Showroom')),
//                   DropdownMenuItem(
//                     value: 'warehouse',
//                     child: Text('Warehouse'),
//                   ),
//                   DropdownMenuItem(value: 'other', child: Text('Other')),
//                 ],
//                 isExpanded: true,
//                 decoration: InputDecoration(
//                   labelText: 'Property Type',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: Colors.grey.shade300,
//                       width: 1,
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: Colors.grey.shade300,
//                       width: 1,
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: Colors.grey.shade300,
//                       width: 1,
//                     ),
//                   ),
//                 ),
//                 onChanged:
//                     (v) =>
//                         controller.project.update((x) => x!.propertyTypes = v),
//               ),
//               const SizedBox(height: 12),
//               DropdownButtonFormField<String>(
//                 value: p.status,
//                 items: const [
//                   DropdownMenuItem(value: 'upcoming', child: Text('Upcoming')),
//                   DropdownMenuItem(value: 'ongoing', child: Text('Ongoing')),
//                   DropdownMenuItem(
//                     value: 'completed',
//                     child: Text('Completed'),
//                   ),
//                 ],
//                 isExpanded: true,
//                 decoration: InputDecoration(
//                   labelText: 'Status',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: Colors.grey.shade300,
//                       width: 1,
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: Colors.grey.shade300,
//                       width: 1,
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: Colors.grey.shade300,
//                       width: 1,
//                     ),
//                   ),
//                 ),
//                 onChanged:
//                     (v) => controller.project.update(
//                       (x) => x!.status = v ?? 'upcoming',
//                     ),
//               ),
//               const SizedBox(height: 12),
//               Text('Amenities', style: theme.textTheme.labelMedium),
//               const SizedBox(height: 6),
//               DropdownButtonFormField<String>(
//                 value: null,
//                 hint: const Text('Select amenity'),
//                 items:
//                     amenityDummy
//                         .map((a) => DropdownMenuItem(value: a, child: Text(a)))
//                         .toList(),
//                 isExpanded: true,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: Colors.grey.shade300,
//                       width: 1,
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: Colors.grey.shade300,
//                       width: 1,
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: Colors.grey.shade300,
//                       width: 1,
//                     ),
//                   ),
//                 ),
//                 onChanged: (v) {
//                   if (v == null) return;
//                   if (!p.amenities.contains(v)) {
//                     controller.project.update(
//                       (x) => x!.amenities = [...p.amenities, v],
//                     );
//                   }
//                 },
//               ),
//               const SizedBox(height: 8),
//               Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//                 children: [
//                   ...p.amenities.map(
//                     (a) => Chip(
//                       label: Text(a),
//                       onDeleted:
//                           () => controller.project.update(
//                             (x) =>
//                                 x!.amenities =
//                                     p.amenities.where((e) => e != a).toList(),
//                           ),
//                     ),
//                   ),
//                   if (p.amenities.isEmpty)
//                     Text(
//                       'No amenities selected',
//                       style: theme.textTheme.bodySmall,
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               CommonTextField(
//                 label: 'Project Highlights (comma separated)',
//                 initialValue: p.projectHighlights.join(', '),
//                 onSaved:
//                     (v) => controller.project.update(
//                       (x) =>
//                           x!.projectHighlights =
//                               (v ?? '')
//                                   .split(',')
//                                   .map((e) => e.trim())
//                                   .where((e) => e.isNotEmpty)
//                                   .toList(),
//                     ),
//               ),
//               const SizedBox(height: 12),
//               // Brochure / Media placeholder (UI only)
//               OutlinedButton.icon(
//                 onPressed: () {
//                   Get.snackbar('Info', 'Brochure upload UI-only placeholder');
//                 },
//                 icon: const Icon(Icons.upload_file),
//                 label: const Text('Upload Brochure (UI only)'),
//               ),
//               const SizedBox(height: 12),
//               Text('Contact Info'),
//               Row(
//                 children: [
//                   Expanded(
//                     child: CommonTextField(
//                       label: 'Name',
//                       initialValue: p.projectContactInfo?.name ?? '',
//                       onSaved: (v) {
//                         controller.project.update((x) {
//                           x!.projectContactInfo ??= ProjectContactInfo();
//                           x.projectContactInfo!.name = v?.trim();
//                         });
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: CommonTextField(
//                       label: 'Phone',
//                       initialValue: p.projectContactInfo?.phone ?? '',
//                       onSaved: (v) {
//                         controller.project.update((x) {
//                           x!.projectContactInfo ??= ProjectContactInfo();
//                           x.projectContactInfo!.phone = v?.trim();
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               CommonTextField(
//                 label: 'Email',
//                 initialValue: p.projectContactInfo?.email ?? '',
//                 validator: ProjectValidators.email,
//                 onSaved: (v) {
//                   controller.project.update((x) {
//                     x!.projectContactInfo ??= ProjectContactInfo();
//                     x.projectContactInfo!.email = v?.trim();
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
// import '../../../../app/constants/color_res.dart';
// import '../../../../app/manager/icon_manager.dart';
// import '../../../../app/utils/svg_widget.dart';
// import '../../controller/builder_form_controller.dart';
// import '../../model/config_model.dart';
// import '../widget/common_builder_textfield.dart';
// import '../widget/validation/validation.dart';
//
// class StepAdditional extends GetView<ProjectWizardController> {
//   final GlobalKey<FormState> formKey;
//
//   const StepAdditional({super.key, required this.formKey});
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     const amenityDummy = <String>[
//       'Gym',
//       'Swimming Pool',
//       'Playground',
//       'Club House',
//       'Garden',
//       'CCTV',
//       'Lift',
//       'Power Backup',
//       'Intercom',
//       'Cafeteria',
//     ];
//
//     return Obx(() {
//       final p = controller.project.value;
//       return Form(
//         key: formKey,
//         autovalidateMode: AutovalidateMode.onUserInteraction,
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header Section
//               const SizedBox(height: 20),
//               _buildSectionHeader(
//                 theme: theme,
//                 icon: Icons.details_outlined,
//                 title: 'Additional Details',
//                 subtitle: 'Enhance your project listing with more information',
//               ),
//               const SizedBox(height: 20),
//
//               // Property Type & Status Card
//               _buildCard(
//                 theme: theme,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     buildBuilderDefaultHeaderText('Property Information'),
//                     const SizedBox(height: 16),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Amenities Card
//               _buildCard(
//                 theme: theme,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.stars_outlined,
//                           size: 20,
//                           color: theme.colorScheme.primary,
//                         ),
//                         const SizedBox(width: 8),
//                         buildBuilderDefaultText('Amenities'),
//                         SizedBox(height: 8),
//
//                       ],
//                     ),
//                     Obx(
//                           () {
//                         final amenitiesList = IconManager.allAmenities;
//
//                         return Wrap(
//                           spacing: 8,
//                           runSpacing: 8,
//                           children: amenitiesList.map((e) {
//                             final isSelected = controller.selectedListOfAmenities.contains(e.title);
//
//                             return Padding(
//                               padding: const EdgeInsets.all(4.0),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   controller.addBuilderAmenities(e.title);
//                                   print("Selected Amenities ${controller.selectedListOfAmenities}");
//                                 },
//                                 child: Container(
//                                   width: 95,
//                                   height: 110,
//                                   decoration: BoxDecoration(
//                                     color: isSelected
//                                         ? Theme.of(context).primaryColor.withOpacity(0.1)
//                                         : ColorRes.white,
//                                     borderRadius: BorderRadius.circular(12),
//                                     border: Border.all(
//                                       color: isSelected
//                                           ? Theme.of(context).primaryColor
//                                           : Colors.grey.shade300,
//                                       width: 1,
//                                     ),
//                                   ),
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 8,
//                                     horizontal: 12,
//                                   ),
//                                   alignment: Alignment.center,
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       AppSvgIcon(
//                                         assetName: e.key,
//                                         size: 25,
//                                         folder: 'amenities',
//                                         color: isSelected
//                                             ? Theme.of(context).primaryColor
//                                             : Colors.grey.shade600,
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         e.title,
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                           color: isSelected
//                                               ? Theme.of(context).primaryColor
//                                               : Colors.black,
//                                           fontWeight: AppFontWeights.regular,
//                                           fontSize: 10,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         );
//                       },
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Project Highlights Card
//               _buildCard(
//                 theme: theme,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.highlight_outlined,
//                           size: 20,
//                           color: theme.colorScheme.primary,
//                         ),
//                         const SizedBox(width: 8),
//                      buildBuilderDefaultText('Project Highlights')
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     CommonTextField(
//                       label: '',
//                       initialValue: p.projectHighlights.join(', '),
//                       hint:
//                           'e.g., Prime location, Modern architecture, Eco-friendly',
//                       onSaved:
//                           (v) => controller.project.update(
//                             (x) =>
//                                 x!.projectHighlights =
//                                     (v ?? '')
//                                         .split(',')
//                                         .map((e) => e.trim())
//                                         .where((e) => e.isNotEmpty)
//                                         .toList(),
//                           ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Documents Card
//               _buildCard(
//                 theme: theme,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.description_outlined,
//                           size: 20,
//                           color: theme.colorScheme.primary,
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           'Project Documents',
//                           style: theme.textTheme.titleSmall?.copyWith(
//                             fontWeight: AppFontWeights.semibold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Upload brochures and other documents',
//                       style: theme.textTheme.bodySmall?.copyWith(
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     OutlinedButton.icon(
//                       onPressed: () {
//                         Get.snackbar(
//                           'Info',
//                           'Brochure upload functionality will be implemented',
//                           snackPosition: SnackPosition.BOTTOM,
//                         );
//                       },
//                       icon: const Icon(Icons.upload_file_outlined),
//                       label: const Text('Upload Brochure'),
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 24,
//                           vertical: 12,
//                         ),
//                         side: BorderSide(color: theme.colorScheme.primary),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Contact Information Card
//               _buildCard(
//                 theme: theme,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.contact_phone_outlined,
//                           size: 20,
//                           color: theme.colorScheme.primary,
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           'Contact Information',
//                           style: theme.textTheme.titleSmall?.copyWith(
//                             fontWeight: AppFontWeights.semibold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Provide contact details for inquiries',
//                       style: theme.textTheme.bodySmall?.copyWith(
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: CommonTextField(
//                             label: 'Contact Name',
//                             initialValue: p.projectContactInfo?.name ?? '',
//                             prefixIcon: Icon(Icons.person_outline),
//                             onSaved: (v) {
//                               controller.project.update((x) {
//                                 x!.projectContactInfo ??= ProjectContactInfo();
//                                 x.projectContactInfo!.name = v?.trim();
//                               });
//                             },
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: CommonTextField(
//                             label: 'Phone Number',
//                             initialValue: p.projectContactInfo?.phone ?? '',
//                             prefixIcon: Icon(Icons.phone_outlined),
//                             keyboardType: TextInputType.phone,
//                             onSaved: (v) {
//                               controller.project.update((x) {
//                                 x!.projectContactInfo ??= ProjectContactInfo();
//                                 x.projectContactInfo!.phone = v?.trim();
//                               });
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     CommonTextField(
//                       label: 'Email Address',
//                       initialValue: p.projectContactInfo?.email ?? '',
//                       prefixIcon: Icon(Icons.email_outlined),
//                       keyboardType: TextInputType.emailAddress,
//                       validator: ProjectValidators.email,
//                       onSaved: (v) {
//                         controller.project.update((x) {
//                           x!.projectContactInfo ??= ProjectContactInfo();
//                           x.projectContactInfo!.email = v?.trim();
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       );
//     });
//   }
//
//
//
//   Widget _buildSectionHeader({
//     required ThemeData theme,
//     required IconData icon,
//     required String title,
//     String? subtitle,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(icon, color: theme.colorScheme.primary, size: 20),
//             const SizedBox(width: 12),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: AppFontSizes.bodySmall,
//                 fontWeight: AppFontWeights.semibold,
//                 color: ColorRes.textSecondary,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCard({required ThemeData theme, required Widget child}) {
//     return child;
//   }
//
//   Widget _buildDropdown({
//     required ThemeData theme,
//     required String? value,
//     String? label,
//     required String hint,
//     required IconData icon,
//     required List<DropdownMenuItem<String>> items,
//     required void Function(String?) onChanged,
//   }) {
//     return SizedBox(
//       height: 50,
//       child: DropdownButtonFormField<String>(
//         value: value,
//         style: TextStyle(fontSize: AppFontSizes.bodySmall),
//         items: items,
//         isExpanded: true,
//         hint: Text(hint, style: TextStyle(fontSize: AppFontSizes.bodySmall)),
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon, size: 20),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.grey.shade300),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.grey.shade300),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
//           ),
//           filled: true,
//           fillColor: Colors.grey.shade50,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 16,
//           ),
//         ),
//         onChanged: onChanged,
//       ),
//     );
//   }
// }
//
// Text buildBuilderDefaultText(String text) {
//   return Text(
//     '$text',
//     style: const TextStyle(
//       fontSize: AppFontSizes.small,
//       fontWeight: AppFontWeights.medium,
//       color: ColorRes.textSecondary,
//     ),
//   );
// }
//
// Text buildBuilderDefaultHeaderText(String text) {
//   return Text(
//     '$text',
//     style: const TextStyle(
//       fontSize: AppFontSizes.medium,
//       fontWeight: AppFontWeights.medium,
//       color: ColorRes.textSecondary,
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/manager/icon_manager.dart';
import '../../../../app/utils/svg_widget.dart';
import '../../../../data/network/builder/model/builder_model.dart';
import '../../controller/builder_form_controller.dart';
import '../widget/common_builder_textfield.dart';
import '../widget/validation/validation.dart';

class StepAdditional extends GetView<ProjectWizardController> {
  final GlobalKey<FormState> formKey;

  const StepAdditional({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final p = controller.project.value;
      return Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              const SizedBox(height: 20),
              buildBuilderDefaultHeaderText('Additional Details'),
              const SizedBox(height: 20),

              // Property Type & Status Card
              _buildCard(
                theme: theme,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildBuilderDefaultText('Property Type'),
                    const SizedBox(height: 16),
                    builderPropertyType(controller),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Amenities Card
              _buildCard(
                theme: theme,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildBuilderDefaultText('Amenities'),
                    const SizedBox(height: 12),
                    Obx(() {
                      final amenitiesList = IconManager.allAmenities;
                      final showAll = controller.showAllAmenities.value;
                      final displayList =
                      showAll
                          ? amenitiesList
                          : amenitiesList.take(9).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                            displayList.map((e) {
                              final isSelected = controller
                                  .project.value.amenities
                                  .contains(e.title);

                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: GestureDetector(
                                  onTap: () {
                                    controller.addBuilderAmenities(e.title);
                                    print(
                                      "Selected Amenities ${controller
                                          .project.value.amenities}",
                                    );
                                  },
                                  child: Container(
                                    width: 95,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      color:
                                      isSelected
                                          ? Theme
                                          .of(context)
                                          .primaryColor
                                          .withOpacity(0.1)
                                          : ColorRes.white,
                                      borderRadius: BorderRadius.circular(
                                        12,
                                      ),
                                      border: Border.all(
                                        color:
                                        isSelected
                                            ? Theme
                                            .of(
                                          context,
                                        )
                                            .primaryColor
                                            : ColorRes.leadGreyColor.shade300,
                                        width: 1,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 12,
                                    ),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AppSvgIcon(
                                          assetName: e.key,
                                          size: 25,
                                          folder: 'amenities',
                                          color:
                                          isSelected
                                              ? Theme
                                              .of(
                                            context,
                                          )
                                              .primaryColor
                                              : ColorRes.leadGreyColor.shade600,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          e.title,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                            isSelected
                                                ? Theme
                                                .of(
                                              context,
                                            )
                                                .primaryColor
                                                : ColorRes.black,
                                            fontWeight: AppFontWeights.regular,
                                            fontSize: AppFontSizes.extraSmall,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          if (amenitiesList.length > 9)
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: GestureDetector(
                                onTap: controller.toggleAmenitiesView,
                                child: Row(
                                  children: [
                                    Text(
                                      showAll ? 'Show Less' : 'Read More',
                                      style: TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontSize: AppFontSizes.small,
                                        fontWeight: AppFontWeights.semiBold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      showAll
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: theme.colorScheme.primary,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              buildBuilderDefaultText('Property Status'),
              SizedBox(height: 8,),
              Obx(
                    () =>
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children:
                      controller.propertyStatusList
                          .map(
                            (e) =>
                            buildChoice(
                              title: e.capitalize.toString(),
                              selected:
                              controller.selectedPropertyStatus.value == e,
                              onTap: () {
                                controller.setCommonMethodValue(
                                  controller.selectedPropertyStatus,
                                  e,
                                );
                              },
                            ),
                      )
                          .toList(),
                    ),
              ),
              // Wrap(
              //   children: ['Completed','Ongoing','Launch'].map((e) => buildChoice(title: title, selected: selected, onTap: onTap),),
              // ),

              // Project Highlights Card
              SizedBox(height: 16,),
              _buildCard(
                theme: theme,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildBuilderDefaultText('Project Highlights'),
                    const SizedBox(height: 8),
                    CommonTextField(
                      label: '',
                      maxLine: 4,
                      minLine: 1,
                      initialValue: p.projectHighlights.join(', '),
                      hint:
                      'e.g. Modern architecture',
                      onSaved:
                          (v) =>
                          controller.project.update(
                                (x) =>
                            x!.projectHighlights =
                                (v ?? '')
                                    .split(',')
                                    .map((e) => e.trim())
                                    .where((e) => e.isNotEmpty)
                                    .toList(),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),


              // Contact Information Card
              _buildCard(
                theme: theme,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildBuilderDefaultHeaderText('Contact Information'),
                    const SizedBox(height: 8),
                    // SizedBox(height: 16),

                    CommonTextField(
                      label: 'Contact Name',
                      hint: 'e.g John Mark',
                      initialValue: p.projectContactInfo?.name ?? '',
                      prefixIcon: Icon(Icons.person_outline, size: 20,
                        color: ColorRes.primary,),
                      onSaved: (v) {
                        controller.project.update((x) {
                          x!.projectContactInfo ??= ProjectContactInfo();
                          x.projectContactInfo!.name = v?.trim();
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    CommonTextField(
                      label: 'Phone Number',
                      hint: '+91',
                      initialValue: p.projectContactInfo?.phone ?? '',
                      prefixIcon: Icon(Icons.phone_outlined, size: 20,
                        color: ColorRes.primary,),
                      keyboardType: TextInputType.phone,
                      onSaved: (v) {
                        controller.project.update((x) {
                          x!.projectContactInfo ??= ProjectContactInfo();
                          x.projectContactInfo!.phone = v?.trim();
                        });
                      },
                    ),

                    const SizedBox(height: 8),
                    CommonTextField(
                      label: 'Email Address',
                      hint: 'jhone@gmail.com',
                      initialValue: p.projectContactInfo?.email ?? '',
                      prefixIcon: Icon(Icons.email_outlined, size: 20,
                        color: ColorRes.primary,),
                      keyboardType: TextInputType.emailAddress,
                      validator: ProjectValidators.email,
                      onSaved: (v) {
                        controller.project.update((x) {
                          x!.projectContactInfo ??= ProjectContactInfo();
                          x.projectContactInfo!.email = v?.trim();
                        });
                      },

                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    });
  }

  // Widget _buildSectionHeader({
  //   required ThemeData theme,
  //   required IconData icon,
  //   required String title,
  //   String? subtitle,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         children: [
  //           Text(
  //             title,
  //             style: TextStyle(
  //               fontSize: AppFontSizes.body,
  //               fontWeight: AppFontWeights.regular,
  //               color: ColorRes.textSecondary,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget _buildCard({required ThemeData theme, required Widget child}) {
    return child;
  }

//   Widget _buildDropdown({
//     required ThemeData theme,
//     required String? value,
//     String? label,
//     required String hint,
//     required IconData icon,
//     required List<DropdownMenuItem<String>> items,
//     required void Function(String?) onChanged,
//   }) {
//     return SizedBox(
//       height: 50,
//       child: DropdownButtonFormField<String>(
//         value: value,
//         style: TextStyle(fontSize: AppFontSizes.bodySmall),
//         items: items,
//         isExpanded: true,
//         hint: Text(hint, style: TextStyle(fontSize: AppFontSizes.bodySmall)),
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon, size: 20),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.grey.shade300),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.grey.shade300),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
//           ),
//           filled: true,
//           fillColor: Colors.grey.shade50,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 16,
//           ),
//         ),
//         onChanged: onChanged,
//       ),
//     );
//   }
// }
}

Text buildBuilderDefaultText(String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: AppFontSizes.small,
      fontWeight: AppFontWeights.medium,
      color: ColorRes.textSecondary,
    ),
  );
}

Text buildBuilderDefaultHeaderText(String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: AppFontSizes.body,
      fontWeight: AppFontWeights.medium,
      color: ColorRes.textSecondary,
    ),
  );
}

Widget builderPropertyType(ProjectWizardController controller) {
  final items = IconManager.items;

  return Obx(
    () => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = controller.builderPropertyType.value == item.title;

          return GestureDetector(
            onTap: () => controller.selectedBuilderPropertyType(item.title),
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? ColorRes.primary.withOpacity(0.1)
                        : ColorRes.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? ColorRes.transparentColor : ColorRes.leadGreyColor.shade300,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppSvgIcon(
                    assetName: item.key,
                    size: 24,
                    color: isSelected ? ColorRes.primary : ColorRes.leadGreyColor.shade600,
                    folder: 'amenities',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: AppFontWeights.medium,
                      color: isSelected ? ColorRes.primary : ColorRes.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    ),
  );
}
