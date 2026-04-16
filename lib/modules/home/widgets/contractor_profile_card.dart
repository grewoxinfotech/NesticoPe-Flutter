import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/modules/home/controllers/contractor_profile_service_controller/contractor_profile_service_controller.dart';
import 'package:nesticope_app/modules/home/widgets/contractor_profile_screen.dart';

import '../../../app/constants/color_res.dart';
import '../../../app/manager/compare_manager.dart';
import '../../../data/network/contractor/model/contractor_profile_model/contractor_profile_model.dart';
import 'package:get/get.dart';

// import '../../property_price_trend/view/widget/price_formate.dart' as Formatter;
import '../controllers/contractor_profile_controller/contractor_compare_manager.dart';

// class ContractorCard extends StatelessWidget {
//   final Contractor contractor;

//   const ContractorCard({super.key, required this.contractor});

//   @override
//   Widget build(BuildContext context) {
//     final rating = double.tryParse(contractor.overallRating) ?? 0;
//     final contractorServiceController = Get.put(
//       ContractorServiceController(contractorId: contractor.userId),
//       tag: contractor.userId,
//     );

//     return GestureDetector(
//       onTap: () {
//         Get.to(() => ContractorProfileDetailsScreen(contractor: contractor));
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: ColorRes.surface,
//           borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 6,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),

//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             /// PROFILE IMAGE
//             Stack(
//               children: [
//                 CircleAvatar(
//                   radius: 40,
//                   backgroundColor: Colors.grey.shade100,
//                   backgroundImage:
//                       contractor.imageUrl.isNotEmpty
//                           ? NetworkImage(contractor.imageUrl)
//                           : null,
//                   child:
//                       contractor.imageUrl.isEmpty
//                           ? const Icon(
//                             Icons.engineering,
//                             size: 32,
//                             color: Colors.orange,
//                           )
//                           : null,
//                 ),

//                 /// VERIFIED BADGE
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: Container(
//                     height: 22,
//                     width: 22,
//                     decoration: BoxDecoration(
//                       color: ColorRes.primary,
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 2),
//                     ),
//                     child: const Icon(
//                       Icons.check,
//                       size: 14,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             /// NAME
//             Text(
//               (contractor.firstName.isEmpty || contractor.lastName.isEmpty)
//                   ? contractor.username
//                   : "${contractor.firstName} ${contractor.lastName}",
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: ColorRes.textColor,
//               ),
//             ),

//             const SizedBox(height: 4),

//             /// SERVICE TYPE
//             // Obx(() {
//             //   //        final services = contractorServiceController.items
//             //   // .map((e) => e.serviceName)
//             //   // .where((e) => e.isNotEmpty)
//             //   // .toList();
//             //   final services =
//             //       contractorServiceController.items
//             //           .map((e) => e.serviceName)
//             //           .toList();

//             //   return AutoServiceText(services: services);
//             // }),
//             Obx(() {
//               final services =
//                   contractorServiceController.items
//                       .map((e) => e.serviceName)
//                       .toList();

//               return AutoServiceText(services: services);
//             }),

//             const SizedBox(height: 8),

//             /// RATING
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.star, color: Colors.amber, size: 18),
//                 const SizedBox(width: 4),
//                 Text(
//                   rating.toStringAsFixed(1),
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             /// STATS ROW
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildStat(
//                   "EXP.",
//                   "${Formatter.formatNumber(contractor.totalExperience)} Years",
//                 ),
//                 _buildStat(
//                   "SERVICES",
//                   "${Formatter.formatNumber(contractor.totalServices)}",
//                 ),

//                 _buildStat(
//                   "PROJECTS",
//                   "${Formatter.formatNumber(contractor.projectStats.completedProjects)}",
//                 ),
//               ],
//             ),

//             const SizedBox(height: 18),

//             /// CONTACT BUTTON
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: () {},
//                 icon: const Icon(Icons.chat_bubble_outline),
//                 label: const Text("Contact Professional"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: ColorRes.primary,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// STAT WIDGET
//   Widget _buildStat(String label, String value) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 11,
//             color: ColorRes.textSecondary,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: ColorRes.textColor,
//           ),
//         ),
//       ],
//     );
//   }
// }
class ContractorCard extends StatelessWidget {
  final Contractor contractor;

  const ContractorCard({super.key, required this.contractor});

  @override
  Widget build(BuildContext context) {
    // final contractorServiceController = Get.put(
    //   ContractorServiceController(contractorId: contractor.userId),
    //   tag: contractor.userId,
    // );
    final ContractorCompareManager compare = Get.put(
      ContractorCompareManager(),
      permanent: true,
    );
    final rating = double.tryParse(contractor.overallRating) ?? 0;
    final stats = contractor.projectStats;
    return GestureDetector(
      onTap: () {
        Get.to(() => ContractorProfileDetailsScreen(contractor: contractor));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorRes.surface,
          borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
          // border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 2,

              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===================== TOP ROW =====================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.grey.shade100,
                  backgroundImage:
                      contractor.imageUrl.isNotEmpty
                          ? NetworkImage(contractor.imageUrl)
                          : null,
                  onBackgroundImageError:
                      contractor.imageUrl.isNotEmpty
                          ? (_, __) {}
                          : null, // Only set this when imageUrl is not empty
                  child:
                      contractor.imageUrl.isEmpty
                          ? const Icon(
                            Icons.engineering,
                            color: Colors.orange,
                            size: 28,
                          )
                          : null,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Contractor name
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        (contractor.firstName.isEmpty ||
                                                contractor.lastName.isEmpty)
                                            ? contractor.username.capitalize?.replaceAll('_', ' ')??''
                                            : "${contractor.firstName.capitalize?.replaceAll('_', ' ')} ${contractor.lastName.capitalize?.replaceAll('_', ' ')}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: AppFontSizes.medium,
                                          fontWeight: AppFontWeights.semiBold,
                                          color: ColorRes.textColor,
                                        ),
                                      ),
                                    ),
                                    // Spacer(),
                                    SizedBox(width: 12),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.star_rounded,
                                              color: Colors.amber,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              rating.toStringAsFixed(1),
                                              style: const TextStyle(
                                                fontSize: AppFontSizes.small,
                                                fontWeight: AppFontWeights.bold,
                                                color: ColorRes.primary,
                                              ),
                                            ),
                                           const SizedBox(width: 6),
                                            Text(
                                              "(${Formatter.formatNumber(contractor.totalReviews)} review${contractor.totalReviews == 1 ? '' : 's'})",
                                              style: TextStyle(
                                                fontSize: AppFontSizes.caption,
                                                color:
                                                    ColorRes
                                                        .leadGreyColor
                                                        .shade700,
                                                fontWeight: AppFontWeights.medium,
                                              ),
                                            ),

                                          ],
                                        ),
                                       
                                      ],
                                    ),
                                  ],
                                ),

                                SizedBox(height: 6),
                                Text(
                                  "${Formatter.formatNumber(contractor.totalExperience)} years experience",
                                  style: const TextStyle(
                                    fontSize: AppFontSizes.small,
                                    fontWeight: AppFontWeights.medium,
                                    color: ColorRes.textSecondary,
                                  ),
                                ),

                                SizedBox(height: 6),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (contractor.subscription.hasPremiumPlan) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: ColorRes.builderGridLightYellow
                                    .withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8),

                                border: Border.all(
                                  color: ColorRes.builderGridLightYellow
                                      .withOpacity(0.5),

                                  width: 1.2,
                                ),
                              ),
                              child: const Text(
                                'PREMIUM',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: AppFontWeights.semiBold,
                                  color: ColorRes.builderGridLightYellow,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ] else ...[
                            SizedBox(height: 12),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 8),
                              if ((contractor.contractorType?.isNotEmpty ??
                                      false) &&
                                  contractor.contractorType != null) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorRes.primary.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: ColorRes.primary.withOpacity(0.5),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Text(
                                    contractor.contractorType?.toUpperCase() ??
                                        '',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: AppFontWeights.semiBold,
                                      color: ColorRes.primary,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ] else ...[
                                SizedBox(height: 12),
                              ],
                            ],
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              compare.toggle(contractor, max: 5);
                            },
                            child: Obx(() {
                              final selected = compare.isSelected(
                                contractor.userId,
                              );
                              return Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                  color:
                                      selected
                                          ? ColorRes.primary
                                          : ColorRes.surface,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color:
                                        selected
                                            ? ColorRes.primary
                                            : ColorRes.border,
                                    width: 1.2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.compare_arrows_rounded,
                                  color:
                                      selected
                                          ? ColorRes.white
                                          : ColorRes.primary,
                                  size: 18,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),

                      // Experience
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            AutoServiceText(
              services: contractor.services.map((e) => e.serviceName).toList(),
            ),

            /// ===================== RATING ROW =====================
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Row(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         Row(
            //           children: List.generate(5, (index) {
            //             final rating =
            //                 double.tryParse(contractor.overallRating) ?? 0;
            //             if (index < rating.floor()) {
            //               return const Icon(
            //                 Icons.star,
            //                 color: Colors.amber,
            //                 size: 16,
            //               );
            //             } else if (index < rating) {
            //               return const Icon(
            //                 Icons.star_half,
            //                 color: Colors.amber,
            //                 size: 16,
            //               );
            //             } else {
            //               return Icon(
            //                 Icons.star_border,
            //                 color: Colors.amber.shade400,
            //                 size: 16,
            //               );
            //             }
            //           }),
            //         ),
            //         const SizedBox(width: 6),

            //         Text(
            //           (double.tryParse(
            //                 contractor.overallRating,
            //               )?.toStringAsFixed(1)) ??
            //               '0.0',
            //           style: const TextStyle(
            //             fontWeight: AppFontWeights.semiBold,
            //             fontSize: AppFontSizes.bodySmall,
            //             color: ColorRes.textColor,
            //           ),
            //         ),
            //         const SizedBox(width: 4),
            //         Text(
            //           "(${contractor.totalReviews} review${contractor.totalReviews == 1 ? '' : 's'})",
            //           style: const TextStyle(
            //             fontSize: AppFontSizes.caption,
            //             color: ColorRes.textSecondary,
            //           ),
            //         ),
            //       ],
            //     ),
            //     // if (contractor.contractorType != null &&
            //     //     contractor.contractorType!.isNotEmpty) ...[
            //     //   Container(
            //     //     padding: const EdgeInsets.symmetric(
            //     //       horizontal: 8,
            //     //       vertical: 4,
            //     //     ),
            //     //     decoration: BoxDecoration(
            //     //       color: ColorRes.primary.withOpacity(0.05),
            //     //       borderRadius: BorderRadius.circular(6),
            //     //       border: Border.all(
            //     //         color: ColorRes.primary.withOpacity(0.3),
            //     //       ),
            //     //     ),
            //     //     child: Text(
            //     //       contractor.contractorType!,
            //     //       style: TextStyle(
            //     //         fontSize: AppFontSizes.caption,
            //     //         fontWeight: AppFontWeights.medium,
            //     //         color: ColorRes.primary,
            //     //       ),
            //     //     ),
            //     //   ),
            //     // ],
            //   ],
            // ),
            // const SizedBox(height: 6),
            // Divider(color: ColorRes.border, thickness: 1),
            const SizedBox(height: 12),

            /// ===================== PROJECT STATUS BADGES =====================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _buildStatContainer(
                    title: 'SERVICES',
                    value: Formatter.formatNumber(contractor.totalServices),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildStatContainer(
                    title: 'ACTIVE',
                    value: Formatter.formatNumber(contractor.activeServices),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildStatContainer(
                    title: 'DONE',
                    value: Formatter.formatNumber(
                      contractor.projectStats.completedProjects,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// ===================== HIRE NOW BUTTON =====================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: handle hire now
                  Get.to(
                    () =>
                        ContractorProfileDetailsScreen(contractor: contractor),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorRes.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'View Profile',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            //
          ],
        ),
      ),
    );

    /// ===================== BADGE BUILDER ====================
  }
}

///=============================Important Note=============================
// class ContractorCard extends StatelessWidget {
//   final Contractor contractor;

//   const ContractorCard({super.key, required this.contractor});

//   @override
//   Widget build(BuildContext context) {
//     final ContractorCompareManager compare = Get.put(
//       ContractorCompareManager(),
//       permanent: true,
//     );
//     final stats = contractor.projectStats;
//     return GestureDetector(
//       onTap: () {
//         Get.to(() => ContractorProfileDetailsScreen(contractor: contractor));
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: ColorRes.surface,
//           borderRadius: BorderRadius.circular(12),
//           // border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 2,

//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// ===================== TOP ROW =====================
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                   radius: 26,
//                   backgroundColor: Colors.grey.shade100,
//                   backgroundImage:
//                       contractor.imageUrl.isNotEmpty
//                           ? NetworkImage(contractor.imageUrl)
//                           : null,
//                   onBackgroundImageError:
//                       contractor.imageUrl.isNotEmpty
//                           ? (_, __) {}
//                           : null, // Only set this when imageUrl is not empty
//                   child:
//                       contractor.imageUrl.isEmpty
//                           ? const Icon(
//                             Icons.engineering,
//                             color: Colors.orange,
//                             size: 28,
//                           )
//                           : null,
//                 ),

//                 const SizedBox(width: 12),

//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           // Contractor name
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 (contractor.firstName.isEmpty ||
//                                         contractor.lastName.isEmpty)
//                                     ? contractor.username
//                                     : "${contractor.firstName} ${contractor.lastName}",
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(
//                                   fontSize: AppFontSizes.medium,
//                                   fontWeight: AppFontWeights.semiBold,
//                                   color: ColorRes.textColor,
//                                 ),
//                               ),

//                               SizedBox(height: 6),
//                               Text(
//                                 "${contractor.totalExperience}+ years experience",
//                                 style: const TextStyle(
//                                   fontSize: AppFontSizes.small,
//                                   fontWeight: AppFontWeights.medium,
//                                   color: ColorRes.textSecondary,
//                                 ),
//                               ),
//                             ],
//                           ),

//                           Spacer(),

//                           // Compare icon button
//                           GestureDetector(
//                             onTap: () {
//                               compare.toggle(contractor, max: 2);
//                             },
//                             child: Obx(() {
//                               final selected = compare.isSelected(
//                                 contractor.userId,
//                               );
//                               return Container(
//                                 height: 32,
//                                 width: 32,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       selected
//                                           ? ColorRes.primary
//                                           : ColorRes.surface,
//                                   borderRadius: BorderRadius.circular(8),
//                                   border: Border.all(
//                                     color:
//                                         selected
//                                             ? ColorRes.primary
//                                             : ColorRes.border,
//                                     width: 1.2,
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.05),
//                                       blurRadius: 4,
//                                       offset: const Offset(0, 2),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Icon(
//                                   Icons.compare_arrows,
//                                   color:
//                                       selected
//                                           ? ColorRes.white
//                                           : ColorRes.primary,
//                                   size: 18,
//                                 ),
//                               );
//                             }),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 4),

//                       // Experience
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 8),

//             /// ===================== RATING ROW =====================
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Row(
//                       children: List.generate(5, (index) {
//                         final rating =
//                             double.tryParse(contractor.overallRating) ?? 0;
//                         if (index < rating.floor()) {
//                           return const Icon(
//                             Icons.star,
//                             color: Colors.amber,
//                             size: 16,
//                           );
//                         } else if (index < rating) {
//                           return const Icon(
//                             Icons.star_half,
//                             color: Colors.amber,
//                             size: 16,
//                           );
//                         } else {
//                           return Icon(
//                             Icons.star_border,
//                             color: Colors.amber.shade400,
//                             size: 16,
//                           );
//                         }
//                       }),
//                     ),
//                     const SizedBox(width: 6),

//                     Text(
//                       (double.tryParse(
//                             contractor.overallRating,
//                           )?.toStringAsFixed(1)) ??
//                           '0.0',
//                       style: const TextStyle(
//                         fontWeight: AppFontWeights.semiBold,
//                         fontSize: AppFontSizes.bodySmall,
//                         color: ColorRes.textColor,
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       "(${contractor.totalReviews} review${contractor.totalReviews == 1 ? '' : 's'})",
//                       style: const TextStyle(
//                         fontSize: AppFontSizes.caption,
//                         color: ColorRes.textSecondary,
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (contractor.contractorType != null &&
//                     contractor.contractorType!.isNotEmpty) ...[
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: ColorRes.primary.withOpacity(0.05),
//                       borderRadius: BorderRadius.circular(6),
//                       border: Border.all(
//                         color: ColorRes.primary.withOpacity(0.3),
//                       ),
//                     ),
//                     child: Text(
//                       contractor.contractorType!,
//                       style: TextStyle(
//                         fontSize: AppFontSizes.caption,
//                         fontWeight: AppFontWeights.medium,
//                         color: ColorRes.primary,
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             ),

//             const SizedBox(height: 8),
//             Divider(color: ColorRes.border, thickness: 1),
//             const SizedBox(height: 8),

//             /// ===================== PROJECT STATUS BADGES =====================
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Expanded(
//                   child: _buildStatContainer(
//                     title: 'Total\nServices',
//                     value: contractor.totalServices.toString(),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: _buildStatContainer(
//                     title: 'Active\nServices',
//                     value: contractor.activeServices.toString(),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: _buildStatContainer(
//                     title: 'Complete\nProjects',
//                     value: contractor.projectStats.completedProjects.toString(),
//                   ),
//                 ),
//               ],
//             ),
//             //

//           ],
//         ),
//       ),
//     );
//     /// ===================== BADGE BUILDER ====================
//   }
// }

// Widget _buildStatContainer({required String title, required String value}) {
//   return Container(
//     width: 95, // fixed width for consistent alignment
//     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
//     decoration: BoxDecoration(
//       color: ColorRes.background,
//       borderRadius: BorderRadius.circular(10),
//       border: Border.all(color: ColorRes.border, width: 1),
//     ),
//     child: Column(
//       children: [
//         Text(
//           title,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             fontSize: AppFontSizes.caption,
//             color: ColorRes.textSecondary,
//           ),
//         ),
//         const SizedBox(height: 6),
//         Text(
//           Formatter.formatNumber(num.parse(value)),
//           style: const TextStyle(
//             fontSize: AppFontSizes.medium,
//             fontWeight: AppFontWeights.semiBold,
//             color: ColorRes.textColor,
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildStatContainer({required String title, required String value}) {
//   return Column(
//     children: [
//       Text(
//         title,
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//           fontSize: AppFontSizes.caption,
//           fontWeight: AppFontWeights.medium,
//           color: ColorRes.textSecondary,
//         ),
//       ),
//       const SizedBox(height: 6),
//       Text(
//         Formatter.formatNumber(num.parse(value)),
//         style: const TextStyle(
//           fontSize: AppFontSizes.medium,
//           fontWeight: AppFontWeights.semiBold,
//           color: ColorRes.textColor,
//         ),
//       ),
//     ],
//   );
// }

Widget _buildStatContainer({required String title, required String value}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
    decoration: BoxDecoration(
      color: const Color(0xFFF2F4F8),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.extraSmall,
            fontWeight: AppFontWeights.medium,
            color: Colors.grey.shade600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    ),
  );
}

Widget _buildBadge(String text, Color bgColor, Color textColor) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: AppFontSizes.caption,
        fontWeight: AppFontWeights.medium,
        color: textColor,
      ),
    ),
  );
}

class AutoServiceText extends StatefulWidget {
  final List<String> services;

  const AutoServiceText({super.key, required this.services});

  @override
  State<AutoServiceText> createState() => _AutoServiceTextState();
}

class _AutoServiceTextState extends State<AutoServiceText> {
  final PageController _pageController = PageController();
  int page = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted || widget.services.isEmpty) return;

      page++;

      if (page >= widget.services.length) {
        page = 0;
      }

      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.services.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: ColorRes.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorRes.primary.withOpacity(0.2)),
        ),
        alignment: Alignment.center,
        child: Text(
          "No Services Available",
          style: TextStyle(
            fontSize: 13,
            color: ColorRes.leadGreyColor.shade600,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: ColorRes.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorRes.primary.withOpacity(0.2)),
      ),
      child: SizedBox(
        height: 20, // Fixed height for PageView
        width: double.infinity,
        child: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.services.length,
          itemBuilder: (context, index) {
            return Align(
              alignment: Alignment.center,
              child: Text(
                widget.services[index].capitalize?.replaceAll("_", " ") ??
                    "No Service",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: ColorRes.primary,
                  fontWeight: AppFontWeights.semiBold,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
// class AutoServiceText extends StatefulWidget {
//   final List<String> services;

//   const AutoServiceText({super.key, required this.services});

//   @override
//   State<AutoServiceText> createState() => _AutoServiceTextState();
// }

// class _AutoServiceTextState extends State<AutoServiceText> {
//   int index = 0;
//   Timer? timer;

//   @override
//   void initState() {
//     super.initState();

//     timer = Timer.periodic(const Duration(seconds: 2), (_) {
//       if (!mounted || widget.services.isEmpty) return;

//       setState(() {
//         index = (index + 1) % widget.services.length;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.services.isEmpty) {
//       return const Text(
//         "Interior Design",
//         style: TextStyle(fontSize: 13, color: Colors.grey),
//       );
//     }

//     return SizedBox(
//       height: 20,
//       width: 140,
//       child: ClipRect(
//         child: AnimatedSwitcher(
//           duration: const Duration(milliseconds: 500),
//           transitionBuilder: (child, animation) {
//             return SlideTransition(
//               position: Tween<Offset>(
//                 begin: const Offset(1, 0), // slide from right
//                 end: Offset.zero,
//               ).animate(animation),
//               child: child,
//             );
//           },
//           child: Text(
//             widget.services[index].capitalize?.replaceAll("_", " ")??"No Service",
//             key: ValueKey(widget.services[index]),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style:  TextStyle(fontSize: 12, color: ColorRes.textSecondary),
//           ),
//         ),
//       ),
//     );
//   }
// }
