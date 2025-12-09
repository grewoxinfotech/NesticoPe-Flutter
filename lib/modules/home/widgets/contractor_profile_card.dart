import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/modules/home/widgets/contractor_profile_screen.dart';
import '../../../app/constants/color_res.dart';
import '../../../data/network/contractor/model/contractor_profile_model/contractor_profile_model.dart';
import 'package:get/get.dart';

class ContractorCard extends StatelessWidget {
  final Contractor contractor;

  const ContractorCard({super.key, required this.contractor});

  @override
  Widget build(BuildContext context) {
    final stats = contractor.projectStats;

    return GestureDetector(
      onTap: () {
        Get.to(() => ContractorProfileScreen(contractor: contractor));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          double.tryParse(
                                contractor.overallRating,
                              )?.toStringAsFixed(0) ??
                              '0',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "(${contractor.totalReviews})",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// ===================== EXPERIENCE + PLAN =====================
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: ColorRes.primary),
                const SizedBox(width: 6),

                Text(
                  "${contractor.totalExperience} yrs",
                  style: TextStyle(
                    fontSize: AppFontSizes.bodySmall,
                    fontWeight: AppFontWeights.medium,
                  ),
                ),

                const Spacer(),

                // Container(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 14,
                //     vertical: 6,
                //   ),
                //   decoration: BoxDecoration(
                //     color: Colors.blue.shade50,
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Text(
                //     contractor.subscription.planName ?? "Free Plan",
                //     style: const TextStyle(
                //       color: Colors.blue,
                //       fontSize: 12,
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                // ),
              ],
            ),

            const SizedBox(height: 8),
            Divider(color: ColorRes.leadGreyColor.shade300, thickness: 1),
            const SizedBox(height: 8),

            /// ===================== STATS ROW =====================
            Row(
              children: [
                /// Pending
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        stats.pendingProjects.toString(),
                        style: TextStyle(
                          fontSize: AppFontSizes.bodySmall,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Pending",
                        style: TextStyle(
                          fontSize: AppFontSizes.bodySmall,
                          fontWeight: AppFontWeights.medium,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                /// In Progress
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        stats.inProgressProjects.toString(),
                        style: TextStyle(
                          fontSize: AppFontSizes.bodySmall,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.warning,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "In Progress",
                        style: TextStyle(
                          fontSize: AppFontSizes.bodySmall,
                          fontWeight: AppFontWeights.medium,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
