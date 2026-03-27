// import 'dart:developer';

// import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import 'package:nesticope_app/app/constants/color_res.dart';
// import 'package:nesticope_app/app/constants/size_manager.dart';
// import 'package:nesticope_app/app/utils/formater/formater.dart';
// import 'package:nesticope_app/app/widgets/image/custom_image.dart';
// import 'package:nesticope_app/data/network/top_seller_profile/model/top_builder_profile_model.dart';
// import 'package:nesticope_app/modules/builder/controller/builder_form_controller.dart';
// import 'package:nesticope_app/modules/builder/view/all_project_list_screen.dart';
// import 'package:nesticope_app/modules/home/controllers/top_builder_controller.dart';
// import 'package:nesticope_app/utils/global.dart';
// import '../top_developer_profile_screen.dart';

// class BuilderCard extends StatefulWidget {
//   final BuilderItem builder;
//   const BuilderCard({super.key, required this.builder});

//   @override
//   State<BuilderCard> createState() => _BuilderCardState();
// }

// class _BuilderCardState extends State<BuilderCard> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final totalProjects = widget.builder.projectStats?.total ?? 0;
//     final completed = widget.builder.projectStats?.completed ?? 0;
//     final ongoing = widget.builder.projectStats?.ongoing ?? 0;
//     final upcoming = widget.builder.projectStats?.upcoming ?? 0;
//     final experience = widget.builder.totalExperience ?? 0;
//     final name = _safeName(widget.builder);
//     final cityState = _formatCityState(
//       widget.builder.city,
//       widget.builder.state,
//     );

//     return GestureDetector(
//       onTap: () async {
//         final userId = widget.builder.id ?? '';
//         final createdBy = widget.builder.id ?? '';
//         log('BuilderCard: ${widget.builder.toMap()},');
//         final tag = 'top_dev_profile_$userId';
//         final projectController =
//             Get.isRegistered<ProjectWizardController>(tag: tag)
//                 ? Get.find<ProjectWizardController>(tag: tag)
//                 : Get.put(
//                   ProjectWizardController(isBuilderView: false),
//                   tag: tag,
//                 );
//         final profileController =
//             Get.isRegistered<TopBuilderController>(tag: tag)
//                 ? Get.find<TopBuilderController>(tag: tag)
//                 : Get.put(TopBuilderController(), tag: tag);

//         projectController.fetchCreatedBy(
//           created: createdBy,
//           isItem: true,
//           withoutCity: true,
//         );
//         projectController.withoutCityFilter();
//         await profileController.loadSellerProfile(userId);
//         if (userId.isNotEmpty && createdBy.isNotEmpty) {
//           Get.to(
//             () =>
//                 TopDeveloperProfileScreen(userId: userId, createdBy: createdBy),
//           );
//         }
//       },
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: ColorRes.white,
//           borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 2,

//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             /// Profile Image
//             // ClipRRect(
//             //       borderRadius: BorderRadius.circular(12),
//             //       child: CustomImage(
//             //         type:
//             //             (widget.builder.profilePic?.isNotEmpty ?? false)
//             //                 ? CustomImageType.network
//             //                 : CustomImageType.asset,
//             //         src:
//             //             (widget.builder.profilePic?.isNotEmpty ?? false)
//             //                 ? widget.builder.profilePic!
//             //                 : imageOfNotAvailable,
//             //         width: 48,
//             //         height: 48,
//             //         fit: BoxFit.cover,
//             //       ),
//             //     ),
//             ///============================================================
//             // ClipRRect(
//             //   borderRadius: BorderRadius.circular(12),
//             //   child:
//             //       (widget.builder.profilePic?.isNotEmpty ?? false)
//             //           ? CustomImage(
//             //             type: CustomImageType.network,
//             //             src: widget.builder.profilePic!,
//             //             width: 55,
//             //             height: 55,
//             //             fit: BoxFit.cover,
//             //           )
//             //           : Container(
//             //             width: 48,
//             //             height: 48,
//             //             alignment: Alignment.center,
//             //             color: Colors.grey.shade300,
//             //             child: Text(
//             //               (name?.isNotEmpty ?? false)
//             //                   ? name![0].toUpperCase()
//             //                   : 'N',
//             //               style: const TextStyle(
//             //                 fontSize: 18,
//             //                 fontWeight: FontWeight.bold,
//             //               ),
//             //             ),
//             //           ),
//             // ),
//             //                 IMPORTANT CODE
//             //./===================================================================
//             ClipOval(
//   child: (widget.builder.profilePic?.isNotEmpty ?? false)
//       ? CustomImage(
//           type: CustomImageType.network,
//           src: widget.builder.profilePic!,
//           width: 55,
//           height: 55,
//           fit: BoxFit.cover,
//         )
//       : Container(
//           width: 55,
//           height: 55,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: Colors.grey.shade300,
//             shape: BoxShape.circle,
//           ),
//           child: Text(
//             (name?.isNotEmpty ?? false)
//                 ? name![0].toUpperCase()
//                 : 'N',
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
// ),
//             const SizedBox(width: 12),

//             /// Builder Details
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// Name
//                   Text(
//                     name.capitalize ?? 'No Default Name',
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black87,
//                     ),
//                   ),

//                   const SizedBox(height: 4),

//                   /// Location
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.location_on_outlined,
//                         size: 14,
//                         color: ColorRes.leadGreyColor.shade700,
//                       ),
//                       const SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           cityState,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                             color: ColorRes.leadGreyColor.shade700,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 10),

//                   /// Projects | Experience
//                   Row(
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "PROJECTS",
//                             style: TextStyle(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w600,
//                               color: ColorRes.leadGreyColor.shade700,
//                             ),
//                           ),
//                           Text(
//                             "${Formatter.formatNumber(totalProjects)}",

//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: ColorRes.primary,
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(width: 16),

//                       Container(
//                         height: 28,
//                         width: 1,
//                         color: Colors.grey.shade300,
//                       ),

//                       const SizedBox(width: 16),

//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "EXPERIENCE",
//                             style: TextStyle(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w600,
//                               color: ColorRes.leadGreyColor.shade700,
//                             ),
//                           ),
//                           Text(
//                             '${experience.toString()} years',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: ColorRes.textColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             /// Arrow Button
//             Container(
//               height: 40,
//               width: 40,

//               decoration: BoxDecoration(
//                 color: Colors.grey.shade100,
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(Icons.arrow_forward, color: ColorRes.primary),
//             ),
//           ],
//         ),
//       ),
//       // child: Container(
//       //   padding: const EdgeInsets.all(14),
//       //   decoration: BoxDecoration(
//       //     color: ColorRes.white,
//       //     borderRadius: BorderRadius.circular(16),
//       //     // border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
//       //     boxShadow: [
//       //       BoxShadow(
//       //         color: Colors.black.withOpacity(0.04),
//       //         blurRadius: 2,
//       //         offset: const Offset(2, 3),
//       //       ),
//       //     ],
//       //   ),
//       //   child: Column(
//       //     crossAxisAlignment: CrossAxisAlignment.start,
//       //     children: [
//       //       Row(
//       //         crossAxisAlignment: CrossAxisAlignment.start,
//       //         children: [
//       // ClipRRect(
//       //   borderRadius: BorderRadius.circular(12),
//       //   child: CustomImage(
//       //     type:
//       //         (widget.builder.profilePic?.isNotEmpty ?? false)
//       //             ? CustomImageType.network
//       //             : CustomImageType.asset,
//       //     src:
//       //         (widget.builder.profilePic?.isNotEmpty ?? false)
//       //             ? widget.builder.profilePic!
//       //             : imageOfNotAvailable,
//       //     width: 48,
//       //     height: 48,
//       //     fit: BoxFit.cover,
//       //   ),
//       // ),
//       //           const SizedBox(width: 10),
//       //           Expanded(
//       //             child: Column(
//       //               crossAxisAlignment: CrossAxisAlignment.start,
//       //               children: [
//       //                 Text(
//       //                   name,
//       //                   maxLines: 1,
//       //                   overflow: TextOverflow.ellipsis,
//       //                   style: const TextStyle(
//       //                     fontSize: 16,
//       //                     fontWeight: FontWeight.w700,
//       //                     color: Colors.black87,
//       //                   ),
//       //                 ),
//       //                 const SizedBox(height: 4),
//       //                 Row(
//       //                   children: [
//       //                     Icon(
//       //                       Icons.location_on_outlined,

//       //                       size: 14,
//       //                       color: ColorRes.leadGreyColor.shade700,
//       //                     ),
//       //                     const SizedBox(width: 4),
//       //                     Expanded(
//       //                       child: Text(
//       //                         cityState,
//       //                         maxLines: 1,
//       //                         overflow: TextOverflow.ellipsis,
//       //                         style: TextStyle(
//       //                           fontSize: 12,
//       //                           fontWeight: FontWeight.w600,
//       //                           color: ColorRes.leadGreyColor.shade700,
//       //                         ),
//       //                       ),
//       //                     ),
//       //                   ],
//       //                 ),
//       //               ],
//       //             ),
//       //           ),
//       //         ],
//       //       ),

//       //       const SizedBox(height: 10),
//       //       Row(
//       //         children: [
//       //           Text(
//       //             "$totalProjects",
//       //             style: const TextStyle(
//       //               fontSize: 14,
//       //               fontWeight: FontWeight.w700,
//       //               color: Colors.black87,
//       //             ),
//       //           ),
//       //           const SizedBox(width: 6),
//       //           Text(
//       //             "Total Projects",
//       //             style: TextStyle(
//       //               fontSize: 12,
//       //               fontWeight: FontWeight.w500,
//       //               color: ColorRes.leadGreyColor.shade700,
//       //             ),
//       //           ),
//       //           const SizedBox(width: 16),
//       //           Text(
//       //             "$experience",
//       //             style: const TextStyle(
//       //               fontSize: 14,
//       //               fontWeight: FontWeight.w700,
//       //               color: Colors.black87,
//       //             ),
//       //           ),
//       //           const SizedBox(width: 6),
//       //           Text(
//       //             "Experience",
//       //             style: TextStyle(
//       //               fontSize: 12,
//       //               fontWeight: FontWeight.w500,
//       //               color: ColorRes.leadGreyColor.shade700,
//       //             ),
//       //           ),
//       //         ],
//       //       ),

//       //       // const SizedBox(height: 12),
//       //       // const SizedBox(height: 2),
//       //       // _BuilderStatusTile(
//       //       //   label: "Ready to Move",
//       //       //   count: completed,
//       //       //   filterlabel: "completed",
//       //       //   userId: widget.builder.id ?? '',
//       //       // ),
//       //       // const SizedBox(height: 8),
//       //       // _BuilderStatusTile(
//       //       //   label: "Under Construction",
//       //       //   count: ongoing,
//       //       //   filterlabel: "ongoing",
//       //       //   userId: widget.builder.id ?? '',
//       //       // ),
//       //       // const SizedBox(height: 8),
//       //       // _BuilderStatusTile(
//       //       //   label: "New Launch",
//       //       //   count: upcoming,
//       //       //   filterlabel: "upcoming",
//       //       //   userId: widget.builder.id ?? '',
//       //       // ),
//       //     ],
//       //   ),
//       // ),
//     );
//   }

//   String _safeName(BuilderItem b) {
//     if ((b.firstName?.isNotEmpty ?? false) ||
//         (b.lastName?.isNotEmpty ?? false)) {
//       return [
//         b.firstName,
//         b.lastName,
//       ].where((e) => (e ?? '').isNotEmpty).join(' ');
//     }
//     return b.username ?? 'Unknown';
//   }

//   String _formatCityState(String? city, String? state) {
//     final c = (city ?? '').trim();
//     final s = (state ?? '').trim();
//     if (c.isEmpty && s.isEmpty) return '—';
//     if (c.isNotEmpty && s.isNotEmpty) return "$c, $s";
//     return c.isNotEmpty ? c : s;
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/app/widgets/image/custom_image.dart';
import 'package:nesticope_app/data/network/top_seller_profile/model/top_builder_profile_model.dart';
import 'package:nesticope_app/modules/builder/controller/builder_form_controller.dart';
import 'package:nesticope_app/modules/builder/view/all_project_list_screen.dart';
import 'package:nesticope_app/modules/home/controllers/top_builder_controller.dart';
import 'package:nesticope_app/utils/global.dart';
import '../top_developer_profile_screen.dart';

class BuilderCard extends StatefulWidget {
  final BuilderItem builder;
  const BuilderCard({super.key, required this.builder});

  @override
  State<BuilderCard> createState() => _BuilderCardState();
}

class _BuilderCardState extends State<BuilderCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final totalProjects = widget.builder.projectStats?.total ?? 0;
    final completed = widget.builder.projectStats?.completed ?? 0;
    final ongoing = widget.builder.projectStats?.ongoing ?? 0;
    final upcoming = widget.builder.projectStats?.upcoming ?? 0;
    final experience = widget.builder.totalExperience ?? 0;
    final name = _safeName(widget.builder);
    final cityState = _formatCityState(
      widget.builder.city,
      widget.builder.state,
    );

    return GestureDetector(
      onTap: () async {
        // final userId = widget.builder.id ?? '';
        // final createdBy = widget.builder.id ?? '';
        // log('BuilderCard: ${widget.builder.toMap()},');
        // final tag = 'top_dev_profile_$userId';
        // final projectController =
        //     Get.isRegistered<ProjectWizardController>(tag: tag)
        //         ? Get.find<ProjectWizardController>(tag: tag)
        //         : Get.put(
        //           ProjectWizardController(isBuilderView: false),
        //           tag: tag,
        //         );
        // final profileController =
        //     Get.isRegistered<TopBuilderController>(tag: tag)
        //         ? Get.find<TopBuilderController>(tag: tag)
        //         : Get.put(TopBuilderController(), tag: tag);

        // projectController.fetchCreatedBy(
        //   created: createdBy,
        //   isItem: true,
        //   withoutCity: true,
        // );
        // projectController.withoutCityFilter();
        // await profileController.loadSellerProfile(userId);
        // if (userId.isNotEmpty && createdBy.isNotEmpty) {
        //   Get.to(
        //     () =>
        //         TopDeveloperProfileScreen(userId: userId, createdBy: createdBy),
        //   );
        // }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Profile Image with verification badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipOval(
                  child:
                      (widget.builder.profilePic?.isNotEmpty ?? false)
                          ? CustomImage(
                            type: CustomImageType.network,
                            src: widget.builder.profilePic!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                          : Container(
                            width: 80,
                            height: 80,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.teal.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              (name?.isNotEmpty ?? false)
                                  ? name![0].toUpperCase()
                                  : 'N',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                ),
                // Verification badge
                Positioned(
                  bottom: 0,
                  right: -4,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: ColorRes.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Name
            Text(
              name.capitalize ?? 'No Default Name',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 4),

            /// Location
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: ColorRes.leadGreyColor.shade700,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    cityState,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: ColorRes.leadGreyColor.shade700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// Divider
            Divider(color: Colors.grey.shade200, height: 1),

            const SizedBox(height: 14),

            /// Projects | Experience
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// Projects
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "PROJECTS",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: ColorRes.leadGreyColor.shade600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.apartment,
                          size: 18,
                       color: ColorRes.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${Formatter.formatNumber(totalProjects)}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: AppFontWeights.semiBold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                /// Vertical Divider
                Container(height: 36, width: 1, color: Colors.grey.shade300),

                /// Experience
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "EXPERIENCE",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: ColorRes.leadGreyColor.shade600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                         Icon(
                          Icons.work_outline_outlined,
                          size: 18,
                          color: ColorRes.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${experience.toString()} Yrs',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: AppFontWeights.semiBold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// View Profile Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // final userId = widget.builder.id ?? '';
                  // final createdBy = widget.builder.id ?? '';
                  // final tag = 'top_dev_profile_$userId';
                  // final projectController =
                  //     Get.isRegistered<ProjectWizardController>(tag: tag)
                  //         ? Get.find<ProjectWizardController>(tag: tag)
                  //         : Get.put(
                  //             ProjectWizardController(isBuilderView: false),
                  //             tag: tag,
                  //           );
                  // final profileController =
                  //     Get.isRegistered<TopBuilderController>(tag: tag)
                  //         ? Get.find<TopBuilderController>(tag: tag)
                  //         : Get.put(TopBuilderController(), tag: tag);

                  // projectController.fetchCreatedBy(
                  //   created: createdBy,
                  //   isItem: true,
                  //   withoutCity: true,
                  // );
                  // projectController.withoutCityFilter();
                  // await profileController.loadSellerProfile(userId);
                  // if (userId.isNotEmpty && createdBy.isNotEmpty) {
                  //   Get.to(
                  //     () => TopDeveloperProfileScreen(
                  //         userId: userId, createdBy: createdBy),
                  //   );
                  // }
                  final userId = widget.builder.id ?? '';
                  final createdBy = widget.builder.id ?? '';
                  log('BuilderCard: ${widget.builder.toMap()},');
                  final tag = 'top_dev_profile_$userId';
                  final projectController =
                      Get.isRegistered<ProjectWizardController>(tag: tag)
                          ? Get.find<ProjectWizardController>(tag: tag)
                          : Get.put(
                            ProjectWizardController(isBuilderView: false),
                            tag: tag,
                          );
                  final profileController =
                      Get.isRegistered<TopBuilderController>(tag: tag)
                          ? Get.find<TopBuilderController>(tag: tag)
                          : Get.put(TopBuilderController(), tag: tag);

                  projectController.fetchCreatedBy(
                    created: createdBy,
                    isItem: true,
                    withoutCity: true,
                  );
                  projectController.withoutCityFilter();
                  await profileController.loadSellerProfile(userId);
                  if (userId.isNotEmpty && createdBy.isNotEmpty) {
                    Get.to(
                      () => TopDeveloperProfileScreen(
                        userId: userId,
                        createdBy: createdBy,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorRes.primary,

                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child:  Text(
                  'View Profile',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _safeName(BuilderItem b) {
    if ((b.firstName?.isNotEmpty ?? false) ||
        (b.lastName?.isNotEmpty ?? false)) {
      return [
        b.firstName,
        b.lastName,
      ].where((e) => (e ?? '').isNotEmpty).join(' ');
    }
    return b.username ?? 'Unknown';
  }

  String _formatCityState(String? city, String? state) {
    final c = (city ?? '').trim();
    final s = (state ?? '').trim();
    if (c.isEmpty && s.isEmpty) return '—';
    if (c.isNotEmpty && s.isNotEmpty) return "$c, $s";
    return c.isNotEmpty ? c : s;
  }
}

class _BuilderStatusTile extends StatefulWidget {
  final String label;
  final int count;
  final String filterlabel;
  final String userId;

  const _BuilderStatusTile({
    required this.label,
    required this.count,
    required this.filterlabel,
    required this.userId,
  });

  @override
  State<_BuilderStatusTile> createState() => _BuilderStatusTileState();
}

class _BuilderStatusTileState extends State<_BuilderStatusTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final tag = 'top_dev_profile_${widget.userId}';
        final projectController =
            Get.isRegistered<ProjectWizardController>(tag: tag)
                ? Get.find<ProjectWizardController>(tag: tag)
                : Get.put(
                  ProjectWizardController(isBuilderView: false),
                  tag: tag,
                );
        final profileController =
            Get.isRegistered<TopBuilderController>(tag: tag)
                ? Get.find<TopBuilderController>(tag: tag)
                : Get.put(TopBuilderController(), tag: tag);

        projectController.fetchCreatedBy(
          created: widget.userId,
          isItem: true,
          withoutCity: true,
        );
        projectController.withoutCityFilter();
        projectController.builderStatus.value = widget.filterlabel;
        profileController.loadSellerProfile(widget.userId);

        log(
          'Check any the filter label ${projectController.builderStatus.value}, ${tag}',
        );
        Get.to(
          () => TopDeveloperProfileScreen(
            userId: widget.userId,
            createdBy: widget.userId,
          ),
        );
        setState(() {});
        // status apply will be handled after initial list load in profile screen
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: ColorRes.leadGreyColor.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: ColorRes.leadGreyColor.shade800,
              ),
            ),
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: ColorRes.leadGreyColor.shade300,
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                "${widget.count}",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: ColorRes.leadGreyColor.shade800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
