import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';
import 'package:housing_flutter_app/data/network/builder/model/builder_model.dart';

import '../../../app/constants/size_manager.dart';
import '../../../app/manager/property/property_pricemanager.dart';
import '../../../app/manager/property_highlight_manager.dart';
import '../controller/builder_form_controller.dart';
import 'builder_form_screen.dart';

class BuilderPropertyListing extends StatelessWidget {
  const BuilderPropertyListing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ProjectWizardController());
    final controller = Get.find<ProjectWizardController>();
    return Scaffold(
      backgroundColor: ColorRes.leadGreyColor[50],
      appBar: AppBar(
        title: Text(
          'My Properties',
          style: TextStyle(fontWeight: AppFontWeights.bold),
        ),
        backgroundColor: ColorRes.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.items.isEmpty) {
          return const Center(child: Text('No projects found'));
        }

        return ListView.builder(
          itemCount: controller.items.length,
          itemBuilder: (context, index) {
            final ProjectModel data = controller.items[index];

            return Padding(
              padding: const EdgeInsets.all(12),
              child: GestureDetector(
                onTap: () {
                  // 👉 Navigate to project detail screen here
                  // Get.to(() => ProjectDetailScreen(project: data));
                },
                child: BuilderProjectCard(
                  project: data,
                  developersName: data.projectContactInfo?.name ?? 'Unknown',
                  imageUrl:
                      data.imageList.isNotEmpty
                          ? data.imageList.first
                          : IMGRes.home3,
                  projectName:
                      data.projectName.isNotEmpty ? data.projectName : 'N/A',
                  location:
                      data.address.isNotEmpty ? data.address : 'Not specified',
                  price: '₹500',
                  // You can format dynamic price here
                  propertySize: data.projectSize.totalBuildings.toString(),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

// class BuilderProjectCard extends StatelessWidget {
//   final ProjectModel project;
//   final String imageUrl;
//   final String projectName;
//   final String location;
//   final String developersName;
//   final String propertySize;
//   final String price;
//   final double height;
//   final double width;
//
//   const BuilderProjectCard({
//     Key? key,
//     required this.imageUrl,
//     required this.projectName,
//     required this.location,
//     required this.developersName,
//     required this.propertySize,
//     required this.price,
//     this.height = 400,
//     this.width = double.infinity,
//     required this.project,
//   }) : super(key: key);
//
//   String _getConfigurationText() {
//
//     if (project.configurations.isEmpty) return '';
//
//     final bhkList = project.configurations.map((c) => '${c.bhk} BHK').toSet().toList();
//     if (bhkList.length > 2) {
//       return '${bhkList.first} - ${bhkList.last}';
//     }
//     return bhkList.join(', ');
//   }
//
//   Color _getStatusColor() {
//     switch (project.status.toLowerCase()) {
//       case 'ongoing':
//       case 'under construction':
//         return Colors.orange;
//       case 'completed':
//         return Colors.green;
//       case 'upcoming':
//       case 'new launch':
//         return Colors.blue;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   String _formatDate(DateTime date) {
//     final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
//     return '${months[date.month - 1]} ${date.year}';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<ProjectWizardController>();
//     final configText = _getConfigurationText();
//
//
//     return Container(
//       height: height,
//       width: width,
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: ColorRes.leadGreyColor.withOpacity(0.3),width: 1),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(14),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 // Project Image
//                 Image.network(
//                   imageUrl??'https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg',
//                   height: 160,
//                   width: width,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Image.network('https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg',height: 160,width: width,fit: BoxFit.cover,);
//                   },
//                 ),
//
//                 // Gradient overlay
//                 Positioned.fill(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Colors.black.withOpacity(0.4),
//                           Colors.transparent,
//                           Colors.transparent,
//                         ],
//                         stops: const [0.0, 0.3, 1.0],
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 // Status Badge
//                 Positioned(
//                   top: 12,
//                   left: 12,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: _getStatusColor(),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       project.status.toUpperCase(),
//                       style:  TextStyle(
//                         color: Colors.white,
//                         fontSize: AppFontSizes.extraSmall,
//                         fontWeight: AppFontWeights.semiBold,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 if (project.reraId.isNotEmpty)
//                   Positioned(
//                     top: 12,
//                     right: 60,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.verified_outlined,
//                             size: 14,
//                             color: Colors.green[700],
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             'RERA',
//                             style: TextStyle(
//                               color: ColorRes.green[700],
//                               fontSize: AppFontSizes.extraSmall,
//                               fontWeight: AppFontWeights.semiBold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                 // Edit Button
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: Material(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     elevation: 4,
//                     child: InkWell(
//                       onTap: () async {
//                         final result = await Get.to(
//                               () => ProjectWizardView(isFromEdit: true),
//                           arguments: project.id,
//                           binding: BindingsBuilder(() async {
//                             final wizardController = Get.put(ProjectWizardController());
//                             await wizardController.updateProjectData(project);
//                           }),
//                         );
//
//                         if (result == true) {
//                           controller.loadInitial();
//                         }
//                       },
//                       borderRadius: BorderRadius.circular(12),
//                       child: Container(
//                         padding: const EdgeInsets.all(8),
//                         child: Icon(
//                           Icons.edit_outlined,
//                           size: 18,
//                           color: ColorRes.primary,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Top Section
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Project Name with Possession Badge
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   projectName,
//                                   style: TextStyle(
//                                     fontSize: AppFontSizes.medium + 1,
//                                     fontWeight: AppFontWeights.bold,
//                                     color: ColorRes.textPrimary,
//                                     height: 1.2,
//                                     letterSpacing: -0.2,
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//                                 decoration: BoxDecoration(
//                                   color: ColorRes.primary.withOpacity(0.12),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Icon(
//                                       Icons.event_available,
//                                       size: 10,
//                                       color: ColorRes.primary,
//                                     ),
//                                     const SizedBox(width: 3),
//                                     Text(
//                                       _formatDate(project.possessionDate),
//                                       style: TextStyle(
//                                         fontSize: 9,
//                                         color: ColorRes.primary,
//                                         fontWeight: AppFontWeights.semiBold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 4),
//
//                           // Location
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.location_on,
//                                 size: 10,
//                                 color: ColorRes.leadGreyColor,
//                               ),
//                               const SizedBox(width: 4),
//                               Expanded(
//                                 child: Text(
//                                   location,
//                                   style: TextStyle(
//                                     fontSize: AppFontSizes.caption,
//                                     color: ColorRes.leadGreyColor,
//                                     fontWeight: AppFontWeights.medium,
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//
//                           // Developer Info Card - Compact
//                           Container(
//                             width: double.infinity,
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   ColorRes.primary.withOpacity(0.08),
//                                   ColorRes.primary.withOpacity(0.04),
//                                 ],
//                               ),
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(
//                                 color: ColorRes.primary.withOpacity(0.15),
//                                 width: 0.5,
//                               ),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.all(4),
//                                       decoration: BoxDecoration(
//                                         color: ColorRes.primary.withOpacity(0.15),
//                                         borderRadius: BorderRadius.circular(4),
//                                       ),
//                                       child: Icon(
//                                         Icons.business,
//                                         size: 10,
//                                         color: ColorRes.primary,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 6),
//                                     Expanded(
//                                       child: Text(
//                                         developersName,
//                                         style: TextStyle(
//                                           fontSize: AppFontSizes.small,
//                                           color: ColorRes.primary,
//                                           fontWeight: AppFontWeights.bold,
//                                         ),
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 6),
//                                 Row(
//                                   children: [
//                                     Icon(
//                                       Icons.email_outlined,
//                                       size: 9,
//                                       color: ColorRes.textColor.withOpacity(0.6),
//                                     ),
//                                     const SizedBox(width: 4),
//                                     Expanded(
//                                       child: Text(
//                                         project.projectContactInfo?.email ?? 'No Email',
//                                         style: TextStyle(
//                                           fontSize: 9,
//                                           color: ColorRes.textColor,
//                                           fontWeight: AppFontWeights.medium,
//                                         ),
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 3),
//                                 Row(
//                                   children: [
//                                     Icon(
//                                       Icons.phone_outlined,
//                                       size: 9,
//                                       color: ColorRes.textColor.withOpacity(0.6),
//                                     ),
//                                     const SizedBox(width: 4),
//                                     Expanded(
//                                       child: Text(
//                                         project.projectContactInfo?.phone ?? 'No Phone',
//                                         style: TextStyle(
//                                           fontSize: 9,
//                                           color: ColorRes.textColor,
//                                           fontWeight: AppFontWeights.medium,
//                                         ),
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           // Configuration and Units - Compact
//                           if (configText.isNotEmpty || project.projectSize.totalUnits > 0)
//                             Padding(
//                               padding: const EdgeInsets.only(top: 6),
//                               child: Row(
//                                 children: [
//                                   if (configText.isNotEmpty) ...[
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//                                       decoration: BoxDecoration(
//                                         color: Colors.blue.withOpacity(0.12),
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Icon(
//                                             Icons.home_outlined,
//                                             size: 9,
//                                             color: ColorRes.blueColor[700],
//                                           ),
//                                           const SizedBox(width: 3),
//                                           Text(
//                                             configText,
//                                             style: TextStyle(
//                                               fontSize: 9,
//                                               color: ColorRes.blueColor[700],
//                                               fontWeight: AppFontWeights.bold,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     const SizedBox(width: 4),
//                                   ],
//                                   if (project.projectSize.totalUnits > 0)
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//                                       decoration: BoxDecoration(
//                                         color: Colors.orange.withOpacity(0.12),
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Icon(
//                                             Icons.apartment_outlined,
//                                             size: 9,
//                                             color: Colors.orange[700],
//                                           ),
//                                           const SizedBox(width: 3),
//                                           Text(
//                                             '${project.projectSize.totalUnits} Units',
//                                             style: TextStyle(
//                                               fontSize: 9,
//                                               color: Colors.orange[700],
//                                               fontWeight: AppFontWeights.bold,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                         ],
//                       ),
//
//                       // Bottom Section - Compact
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Divider
//                           Container(
//                             height: 1,
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   ColorRes.grey.withOpacity(0.05),
//                                   ColorRes.grey.withOpacity(0.15),
//                                   ColorRes.grey.withOpacity(0.05),
//                                 ],
//                               ),
//                             ),
//                             margin: const EdgeInsets.symmetric(vertical: 6),
//                           ),
//
//                           // Property Size
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//                             decoration: BoxDecoration(
//                               color: ColorRes.textSecondary.withOpacity(0.08),
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(
//                                   Icons.square_foot_outlined,
//                                   size: 10,
//                                   color: ColorRes.textSecondary,
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   propertySize,
//                                   style: TextStyle(
//                                     fontSize: 9,
//                                     color: ColorRes.textSecondary,
//                                     fontWeight: AppFontWeights.semiBold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//
//                           // Price with CTA
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Starting from',
//                                       style: TextStyle(
//                                         fontSize: 8,
//                                         color: ColorRes.grey,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 2),
//                                     Text(
//                                       price,
//                                       style: TextStyle(
//                                         fontSize: AppFontSizes.medium + 2,
//                                         fontWeight: AppFontWeights.bold,
//                                         color: ColorRes.primary,
//                                         letterSpacing: -0.5,
//                                         height: 1.1,
//                                       ),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       ColorRes.primary,
//                                       ColorRes.primary.withOpacity(0.8),
//                                     ],
//                                   ),
//                                   borderRadius: BorderRadius.circular(8),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: ColorRes.primary.withOpacity(0.25),
//                                       blurRadius: 4,
//                                       offset: const Offset(0, 2),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Icon(
//                                   Icons.arrow_forward,
//                                   size: 14,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//
//
//
//             // Content Section
//             // Expanded(
//             //   child: Padding(
//             //     padding: const EdgeInsets.all(16.0),
//             //     child: Column(
//             //       crossAxisAlignment: CrossAxisAlignment.start,
//             //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //       children: [
//             //         Column(
//             //           crossAxisAlignment: CrossAxisAlignment.start,
//             //           children: [
//             //             // Project Name
//             //             Row(
//             //               children: [
//             //                 Expanded(
//             //                   child: Text(
//             //                     projectName,
//             //                     style: TextStyle(
//             //                       fontSize: AppFontSizes.large,
//             //                       fontWeight: AppFontWeights.semiBold,
//             //                       color: ColorRes.textPrimary,
//             //                       height: 1.2,
//             //                     ),
//             //                     maxLines: 1,
//             //                     overflow: TextOverflow.ellipsis,
//             //                   ),
//             //                 ),
//             //                 SizedBox(width: 10,),
//             //                 Row(
//             //                   children: [
//             //                     Icon(
//             //                       Icons.calendar_today_outlined,
//             //                       size: 12,
//             //                       color: ColorRes.textSecondary,
//             //                     ),
//             //                     const SizedBox(width: 4),
//             //                     Text(
//             //                       _formatDate(project.possessionDate),
//             //                       style: TextStyle(
//             //                         fontSize: AppFontSizes.caption,
//             //                         color: ColorRes.textSecondary,
//             //                         fontWeight: AppFontWeights.medium,
//             //                       ),
//             //                     ),
//             //                   ],
//             //                 ),
//             //               ],
//             //             ),
//             //             const SizedBox(height: 4),
//             //
//             //             // Location
//             //             Row(
//             //               children: [
//             //                 Expanded(
//             //                   child: Text(
//             //                     location,
//             //                     style: TextStyle(
//             //                       fontSize: AppFontSizes.small,
//             //                       color: ColorRes.leadGreyColor,
//             //                       fontWeight: AppFontWeights.medium,
//             //                       height: 1.3,
//             //                     ),
//             //                     maxLines: 1,
//             //                     overflow: TextOverflow.ellipsis,
//             //                   ),
//             //                 ),
//             //               ],
//             //             ),
//             //             const SizedBox(height: 10),
//             //
//             //             // Developer Name Badge
//             //             Container(
//             //               width: double.infinity,
//             //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             //               decoration: BoxDecoration(
//             //                 color: ColorRes.primary.withOpacity(0.05),
//             //                 borderRadius: BorderRadius.circular(8),
//             //               ),
//             //               child: Column(
//             //                 crossAxisAlignment: CrossAxisAlignment.start,
//             //                 children: [
//             //                   Text(
//             //                     developersName,
//             //                     style: TextStyle(
//             //                       fontSize: AppFontSizes.medium,
//             //                       color: ColorRes.primary,
//             //                       fontWeight: AppFontWeights.medium,
//             //                     ),
//             //                     maxLines: 1,
//             //                     overflow: TextOverflow.ellipsis,
//             //
//             //                   ),
//             //
//             //                   Text(
//             //                     project.projectContactInfo?.email??'No Email',
//             //                     style: TextStyle(
//             //                       fontSize: AppFontSizes.caption,
//             //                       color: ColorRes.textColor,
//             //                       fontWeight: AppFontWeights.medium,
//             //                     ),
//             //                     maxLines: 1,
//             //                     overflow: TextOverflow.ellipsis,
//             //                   ),
//             //                   Text(
//             //                     project.projectContactInfo?.phone??'No Phone',
//             //                     style: TextStyle(
//             //                       fontSize: AppFontSizes.small,
//             //                       color: ColorRes.textColor,
//             //                       fontWeight: AppFontWeights.regular,
//             //                     ),
//             //                     maxLines: 1,
//             //                     overflow: TextOverflow.ellipsis,
//             //                   ),
//             //                 ],
//             //               ),
//             //             ),
//             //
//             //             // Configuration and Units Info
//             //             if (configText.isNotEmpty || project.projectSize.totalUnits > 0)
//             //               Padding(
//             //                 padding: const EdgeInsets.only(top: 10),
//             //                 child: Row(
//             //                   children: [
//             //                     if (configText.isNotEmpty) ...[
//             //                       Container(
//             //                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//             //                         decoration: BoxDecoration(
//             //                           color: Colors.blue.withOpacity(0.1),
//             //                           borderRadius: BorderRadius.circular(6),
//             //                         ),
//             //                         child: Row(
//             //                           mainAxisSize: MainAxisSize.min,
//             //                           children: [
//             //                             Icon(
//             //                               Icons.home_outlined,
//             //                               size: 12,
//             //                               color: ColorRes.blueColor[700],
//             //                             ),
//             //                             const SizedBox(width: 4),
//             //                             Text(
//             //                               configText,
//             //                               style: TextStyle(
//             //                                 fontSize: AppFontSizes.caption,
//             //                                 color: ColorRes.blueColor[700],
//             //                                 fontWeight: AppFontWeights.semiBold,
//             //                               ),
//             //                             ),
//             //                           ],
//             //                         ),
//             //                       ),
//             //                       const SizedBox(width: 8),
//             //                     ],
//             //                     if (project.projectSize.totalUnits > 0)
//             //                       Container(
//             //                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//             //                         decoration: BoxDecoration(
//             //                           color: Colors.orange.withOpacity(0.1),
//             //                           borderRadius: BorderRadius.circular(6),
//             //                         ),
//             //                         child: Row(
//             //                           mainAxisSize: MainAxisSize.min,
//             //                           children: [
//             //                             Icon(
//             //                               Icons.apartment_outlined,
//             //                               size: 12,
//             //                               color: Colors.orange[700],
//             //                             ),
//             //                             const SizedBox(width: 4),
//             //                             Text(
//             //                               '${project.projectSize.totalUnits} Units',
//             //                               style: TextStyle(
//             //                                 fontSize: 11,
//             //                                 color: Colors.orange[700],
//             //                                 fontWeight: FontWeight.w600,
//             //                               ),
//             //                             ),
//             //                           ],
//             //                         ),
//             //                       ),
//             //                   ],
//             //                 ),
//             //               ),
//             //           ],
//             //         ),
//             //
//             //         // Bottom Section
//             //         Column(
//             //           crossAxisAlignment: CrossAxisAlignment.start,
//             //           children: [
//             //             // Divider
//             //             Container(
//             //               height: 1,
//             //               color: ColorRes.grey.withOpacity(0.15),
//             //               margin: const EdgeInsets.only(bottom: 10),
//             //             ),
//             //
//             //             // Property Size and Possession
//             //             Row(
//             //               children: [
//             //                 Expanded(
//             //                   child: Row(
//             //                     children: [
//             //                       Icon(
//             //                         Icons.square_foot_outlined,
//             //                         size: 14,
//             //                         color: ColorRes.textSecondary,
//             //                       ),
//             //                       const SizedBox(width: 4),
//             //                       Flexible(
//             //                         child: Text(
//             //                           propertySize,
//             //                           style: TextStyle(
//             //                             fontSize: AppFontSizes.caption,
//             //                             color: ColorRes.textSecondary,
//             //                             fontWeight: AppFontWeights.medium,
//             //                           ),
//             //                           maxLines: 1,
//             //                           overflow: TextOverflow.ellipsis,
//             //                         ),
//             //                       ),
//             //                     ],
//             //                   ),
//             //                 ),
//             //                 const SizedBox(width: 8),
//             //
//             //               ],
//             //             ),
//             //             const SizedBox(height: 8),
//             //
//             //             // Price
//             //             Row(
//             //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //               children: [
//             //                 Expanded(
//             //                   child: Column(
//             //                     crossAxisAlignment: CrossAxisAlignment.start,
//             //                     children: [
//             //                       Text(
//             //                         'Starting from',
//             //                         style: TextStyle(
//             //                           fontSize: 10,
//             //                           color: ColorRes.grey,
//             //                           fontWeight: FontWeight.w500,
//             //                         ),
//             //                       ),
//             //                       const SizedBox(height: 2),
//             //                       Text(
//             //                         price,
//             //                         style: TextStyle(
//             //                           fontSize: AppFontSizes.subtitle + 3,
//             //                           fontWeight: AppFontWeights.bold,
//             //                           color: ColorRes.primary,
//             //                           letterSpacing: -0.5,
//             //                         ),
//             //                         maxLines: 1,
//             //                         overflow: TextOverflow.ellipsis,
//             //                       ),
//             //                     ],
//             //                   ),
//             //                 ),
//             //                 Container(
//             //                   padding: const EdgeInsets.all(6),
//             //                   decoration: BoxDecoration(
//             //                     color: ColorRes.primary.withOpacity(0.1),
//             //                     shape: BoxShape.circle,
//             //                   ),
//             //                   child: Icon(
//             //                     Icons.arrow_forward,
//             //                     size: 16,
//             //                     color: ColorRes.primary,
//             //                   ),
//             //                 ),
//             //               ],
//             //             ),
//             //           ],
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class BuilderProjectCard extends StatelessWidget {
  final ProjectModel project;
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
  }) : super(key: key);

  String _getConfigurationText() {
    if (project.configurations.isEmpty) return '';

    final bhkList =
        project.configurations.map((c) => '${c.bhk} BHK').toSet().toList();
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
    final configText = _getConfigurationText();

    return Container(
      height: height,
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
        borderRadius: BorderRadius.circular(15),
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
                        fontSize: AppFontSizes.mini,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                  ),
                ),
                // RERA Badge
                if (project.reraId.isNotEmpty)
                  Positioned(
                    top: 10,
                    right: 52,
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
                              ProjectWizardController(),
                            );
                            await wizardController.updateProjectData(project);
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
            ),

            // Content Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
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
                                  fontSize: AppFontSizes.bodyMedium,
                                  fontWeight: AppFontWeights.semiBold,
                                  color: ColorRes.textPrimary,
                                  height: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
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
                                    _formatDate(project.possessionDate),
                                    style: TextStyle(
                                      fontSize: AppFontSizes.extraSmall,
                                      color: ColorRes.primary,
                                      fontWeight: AppFontWeights.semiBold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Location
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 11,
                              color: ColorRes.leadGreyColor,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                location,
                                style: TextStyle(
                                  fontSize: AppFontSizes.caption,
                                  color: ColorRes.leadGreyColor,
                                  fontWeight: AppFontWeights.medium,
                                  height: 1.2,
                                ),
                                maxLines: 1,

                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Developer Info Card
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
                        if (configText.isNotEmpty ||
                            project.projectSize.totalUnits > 0)
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
                                          configText,
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
                                        Icons.square_foot_outlined,
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
                              if (project.projectSize.totalUnits > 0)
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
                                          '${project.projectSize.totalUnits} Units',
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
                      ],
                    ),

                    // Bottom Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Divider
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            color: ColorRes.grey.withOpacity(0.1),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        SizedBox(height: 8),
                        //
                        // // Property Size
                        //

                        // Price with CTA
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                  const SizedBox(height: 4),
                                  Text(
                                    price,
                                    style: TextStyle(
                                      fontSize: AppFontSizes.large,
                                      fontWeight: AppFontWeights.bold,
                                      color: ColorRes.primary,

                                      height: 1.1,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
