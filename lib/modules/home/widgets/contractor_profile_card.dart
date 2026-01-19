import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/modules/home/widgets/contractor_profile_screen.dart';
import '../../../app/constants/color_res.dart';
import '../../../app/manager/compare_manager.dart';
import '../../../data/network/contractor/model/contractor_profile_model/contractor_profile_model.dart';
import 'package:get/get.dart';

import '../controllers/contractor_profile_controller/contractor_compare_manager.dart';

class ContractorCard extends StatelessWidget {
  final Contractor contractor;

  const ContractorCard({super.key, required this.contractor});

  @override
  Widget build(BuildContext context) {
    final ContractorCompareManager compare = Get.put(ContractorCompareManager(), permanent: true);
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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
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
                  backgroundImage: contractor.imageUrl.isNotEmpty
                      ? NetworkImage(contractor.imageUrl)
                      : null,
                  onBackgroundImageError: contractor.imageUrl.isNotEmpty
                      ? (_, __) {}
                      : null, // Only set this when imageUrl is not empty
                  child: contractor.imageUrl.isEmpty
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (contractor.firstName.isEmpty || contractor.lastName.isEmpty)
                                    ? contractor.username
                                    : "${contractor.firstName} ${contractor.lastName}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: AppFontSizes.medium,
                                  fontWeight: AppFontWeights.semiBold,
                                  color: ColorRes.textColor,
                                ),
                              ),

                              SizedBox(height: 6),
                              Text(
                                "${contractor.totalExperience}+ years experience",
                                style: const TextStyle(
                                  fontSize: AppFontSizes.small,
                                  fontWeight: AppFontWeights.medium,
                                  color: ColorRes.textSecondary,
                                ),
                              ),
                            ],
                          ),

                          Spacer(),

                          // Compare icon button
                          GestureDetector(
                            onTap: () {
                               compare.toggle(contractor, max: 2);
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
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.compare_arrows,
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

                      const SizedBox(height: 4),

                      // Experience
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// ===================== RATING ROW =====================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        final rating =
                            double.tryParse(contractor.overallRating) ?? 0;
                        if (index < rating.floor()) {
                          return const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          );
                        } else if (index < rating) {
                          return const Icon(
                            Icons.star_half,
                            color: Colors.amber,
                            size: 16,
                          );
                        } else {
                          return Icon(
                            Icons.star_border,
                            color: Colors.amber.shade400,
                            size: 16,
                          );
                        }
                      }),
                    ),
                    const SizedBox(width: 6),

                    Text(
                      (double.tryParse(
                            contractor.overallRating,
                          )?.toStringAsFixed(1)) ??
                          '0.0',
                      style: const TextStyle(
                        fontWeight: AppFontWeights.semiBold,
                        fontSize: AppFontSizes.bodySmall,
                        color: ColorRes.textColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "(${contractor.totalReviews} review${contractor.totalReviews == 1 ? '' : 's'})",
                      style: const TextStyle(
                        fontSize: AppFontSizes.caption,
                        color: ColorRes.textSecondary,
                      ),
                    ),
                  ],
                ),
               if(contractor.contractorType != null && contractor.contractorType!.isNotEmpty)...[
                 Container(
                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                     decoration: BoxDecoration(
                       color: ColorRes.primary.withOpacity(0.05),
                       borderRadius: BorderRadius.circular(6),
                       border: Border.all(color: ColorRes.primary.withOpacity(0.3)),
                     ),
                     child: Text(
                         contractor.contractorType!,
                         style: TextStyle(
                           fontSize: AppFontSizes.caption,
                           fontWeight: AppFontWeights.medium,
                           color: ColorRes.primary,
                         ))
                 )
               ]
              ],
            ),

            const SizedBox(height: 8),
            Divider(color: ColorRes.border, thickness: 1),
            const SizedBox(height: 8),

            /// ===================== SERVICES ROW =====================
            // Row(
            //   children: [
            //     const Icon(Icons.work_history_outlined, size: 16,
            //         color: ColorRes.textSecondary),
            //     const SizedBox(width: 6),
            //     Text(
            //       'Total Services: ${contractor.totalServices}',
            //       style: const TextStyle(
            //         fontSize: AppFontSizes.small,
            //         color: ColorRes.textColor,
            //       ),
            //     ),
            //     const Spacer(),
            //     Text(
            //       'Active Services: ${contractor.activeServices}',
            //       style: const TextStyle(
            //         fontSize: AppFontSizes.small,
            //         color: ColorRes.textColor,
            //       ),
            //     ),
            //   ],
            // ),
            //
            // const SizedBox(height: 10),

            /// ===================== PROJECT STATUS BADGES =====================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _buildStatContainer(
                    title: 'Total Services',
                    value: contractor.totalServices.toString(),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildStatContainer(
                    title: 'Active Services',
                    value: contractor.activeServices.toString(),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildStatContainer(
                    title: 'Complete Projects',
                    value: contractor.projectStats.completedProjects.toString(),
                  ),
                ),
              ],
            ),
            //
            // if (contractor.subscription.hasPremiumPlan) ...[
            //   const SizedBox(height: 12),
            //   Container(
            //     width: double.infinity,
            //     padding: const EdgeInsets.symmetric(vertical: 8),
            //     decoration: BoxDecoration(
            //       color: Colors.lightBlue.shade50,
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     child: Center(
            //       child: Text(
            //         "${contractor.subscription.planName ??
            //             'Pro Plan'} - \$${contractor.subscription
            //             .planAmount}/mo",
            //         style: const TextStyle(
            //           color: ColorRes.primary,
            //           fontWeight: AppFontWeights.semiBold,
            //           fontSize: AppFontSizes.small,
            //         ),
            //       ),
            //     ),
            //   ),
            // ],
          ],
        ),
      ),
    );

    /// ===================== BADGE BUILDER =====================

    /*  return GestureDetector(
      onTap: () {
        Get.to(() => ContractorProfileScreen(contractor: contractor));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===================== TOP ROW =====================
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.orange.shade50,
                  child: const Icon(
                    Icons.engineering,
                    size: 30,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contractor.username,
                      style:  TextStyle(
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textColor
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "${contractor.totalExperience} years experience",
                      style: TextStyle(
                        fontSize: AppFontSizes.caption,
                        fontWeight: AppFontWeights.medium,
                        color: ColorRes.leadGreyColor.shade600
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ⭐ Numeric Rating
                // ⭐ Star Icons
                Row(
                  children: List.generate(5, (index) {
                    final rating = double.tryParse(contractor.overallRating) ?? 0;
                    if (index < rating.floor()) {
                      // Full yellow star
                      return const Icon(Icons.star, color: Colors.amber, size: 16);
                    } else if (index < rating) {
                      // Half star (optional)
                      return const Icon(Icons.star_half, color: Colors.amber, size: 16);
                    } else {
                      // Empty star with yellow border
                      return Icon(Icons.star_border, color: Colors.amber.shade400, size: 16);
                    }
                  }),
                ),

                const SizedBox(width: 6),
                Text(
                  (double.tryParse(contractor.overallRating)?.toStringAsFixed(1)) ?? '0.0',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                // const SizedBox(width: 6),

                const SizedBox(width: 6),

                // 📊 Review count
                Text(
                  "(${contractor.totalReviews} review${contractor.totalReviews == 1 ? '' : 's'})",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            /// ===================== EXPERIENCE + PLAN =====================


            const SizedBox(height: 8),
            Divider(color: ColorRes.leadGreyColor.shade300, thickness: 1),
            const SizedBox(height: 8),

            /// ===================== STATS ROW =====================
            Row(
              children: [
                Icon(Icons.work_history_outlined,size: 16),
                Text('Total Services: ${contractor.totalServices}'),
                Spacer(),
                Text('Active: ${contractor.activeServices}')


              ],
            ),
            // Row(
            //   children: [
            //     /// Pending
            //     Expanded(
            //       child: Column(
            //         children: [
            //           Text(
            //             stats.pendingProjects.toString(),
            //             style: TextStyle(
            //               fontSize: AppFontSizes.bodySmall,
            //               fontWeight: AppFontWeights.semiBold,
            //               color: ColorRes.primary,
            //             ),
            //           ),
            //           const SizedBox(height: 4),
            //           Text(
            //             "Pending",
            //             style: TextStyle(
            //               fontSize: AppFontSizes.bodySmall,
            //               fontWeight: AppFontWeights.medium,
            //               color: Colors.grey,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //
            //     /// In Progress
            //     Expanded(
            //       child: Column(
            //         children: [
            //           Text(
            //             stats.inProgressProjects.toString(),
            //             style: TextStyle(
            //               fontSize: AppFontSizes.bodySmall,
            //               fontWeight: AppFontWeights.semiBold,
            //               color: ColorRes.warning,
            //             ),
            //           ),
            //           const SizedBox(height: 4),
            //           Text(
            //             "In Progress",
            //             style: TextStyle(
            //               fontSize: AppFontSizes.bodySmall,
            //               fontWeight: AppFontWeights.medium,
            //               color: Colors.grey,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );*/
  }
}

Widget _buildStatContainer({required String title, required String value}) {
  return Container(
    width: 95, // fixed width for consistent alignment
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
    decoration: BoxDecoration(
      color: ColorRes.background,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: ColorRes.border, width: 1),
    ),
    child: Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: AppFontSizes.caption,
            color: ColorRes.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: AppFontSizes.medium,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textColor,
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
