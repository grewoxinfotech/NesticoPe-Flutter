import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../data/network/reseller/reseller_dashboard/model/reseller_dashboard_model.dart';
import 'animated_builder_widget.dart';

class PartnerMilestoneRewardScreen extends StatefulWidget {
  final Milestones milestones;

  const PartnerMilestoneRewardScreen({super.key, required this.milestones});

  @override
  State<PartnerMilestoneRewardScreen> createState() =>
      _PartnerMilestoneRewardScreenState();
}

class _PartnerMilestoneRewardScreenState
    extends State<PartnerMilestoneRewardScreen> {
  @override
  Widget build(BuildContext context) {
    final m = widget.milestones;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title Row
          Row(
            children: [
              TiltingIcon(

                icon: Icon(
                  Icons.emoji_events_outlined,
                  color: ColorRes.orangeColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Partner Milestones & Rewards",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ColorRes.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// Total Revenue Section
          AnimatedContainerScaler(
            minScale: 0.95,
            maxScale: 1.20,
            duration: const Duration(seconds: 2),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "TOTAL PLATFORM REVENUE GENERATED",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${Formatter.formatPrice(m.totalFeesGenerated)}",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  /*  const SizedBox(height: 6),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "+12% vs last month",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// Next Reward Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorRes.leadGreyColor.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Text(
                  "Next Reward",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: ColorRes.leadGreyColor.shade600,
                  ),
                ),
                SizedBox(height: 8),
                ScaleIconWidget(
                  duration: const Duration(seconds: 3),
                  minScale: 0.95,
                  maxScale: 1.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 🟩 Needs Section
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: ColorRes.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: ColorRes.leadGreyColor.shade300,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Needs: ",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: ColorRes.leadGreyColor.shade600,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              Formatter.formatPrice(
                                (m.nextMilestone?.limit ?? 0) -
                                    (m.totalFeesGenerated ?? 0),
                              ),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: ColorRes.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // spacing between containers
                      const SizedBox(width: 12),

                      // 🟦 Target Section
                      ScaleIconWidget(
                        duration: const Duration(seconds: 3),
                        minScale: 0.95,
                        maxScale: 1.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: ColorRes.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: ColorRes.purpleColor.shade300,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Target: ",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: ColorRes.leadGreyColor.shade600,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                Formatter.formatPrice(
                                  m.nextMilestone?.limit ?? 0,
                                ),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: ColorRes.purpleColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${m.nextMilestone?.gift ?? '--'}",
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: ColorRes.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ProgressWithLabel(
                  progressValue: (m.progress / 100).clamp(0.0, 1.0),
                  progressColor: Color(0xff5BE2B7),
                  backgroundColor: Color(0xff5BE2B7),
                ),

                /// Progress bar
                /*  ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (m.progress / 100).clamp(0.0, 1.0),
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation(ColorRes.green),
                    minHeight: 8,
                  ),
                ),*/
                const SizedBox(height: 40),

                /// Milestone tags
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 8,
                    children:
                        m.allMilestones
                            .map(
                              (item) => _buildMilestoneTag(
                                item.gift,
                                item.limit.toStringAsFixed(0),
                                m.bonuses.any(
                                  (b) =>
                                      b.rewardUnlocked.toLowerCase() ==
                                      item.gift.toLowerCase(),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// Stats Row
          Obx(() {
            final RxInt unlockedCount = 0.obs;
            final RxInt lockedCount = 0.obs;

            unlockedCount.value = m.allMilestones
                .where((item) => m.bonuses.any(
                  (b) => b.rewardUnlocked.toLowerCase() == item.gift.toLowerCase(),
            ))
                .length;

            lockedCount.value =
                ((m.allMilestones.length - unlockedCount.value).clamp(0, m.allMilestones.length)).toInt();

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: _buildStatBox(unlockedCount.value.toString(), "Unlocked")),
                const SizedBox(width: 8),
                Expanded(child: _buildStatBox(lockedCount.value.toString(), "Locked")),
                const SizedBox(width: 8),
                Expanded(child: _buildStatBox("${m.progress}%", "Overall")),
              ],
            );
          })

        ],
      ),
    );
  }

  Widget _buildStatBox(String value, String label) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: ColorRes.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: ColorRes.textColor,
              fontWeight: AppFontWeights.medium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneTag(String name, String value, bool unlocked) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: unlocked ? ColorRes.green.withOpacity(0.15) : Colors.white,
        border: Border.all(
          color: unlocked ? ColorRes.green : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            unlocked ? Icons.check_circle : Icons.lock_outline,
            color: unlocked ? ColorRes.green : Colors.grey,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            "$name (${Formatter.formatPrice(num.tryParse(value) ?? 0)})",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: unlocked ? ColorRes.green : ColorRes.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
Widget buildPartnerMilestoneRewardShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header
          Row(
            children: [
              Container(height: 24, width: 24, color: Colors.white),
              const SizedBox(width: 8),
              Container(height: 18, width: 180, color: Colors.white),
            ],
          ),
          const SizedBox(height: 20),

          // 🔹 Total Revenue Section
          Container(
            height: 110,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 20),

          // 🔹 Next Reward Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 12, width: 80, color: Colors.white),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(height: 30, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(height: 30, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(height: 16, width: double.infinity, color: Colors.white),
                const SizedBox(height: 15),
                Container(height: 8, width: double.infinity, color: Colors.white),
                const SizedBox(height: 30),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      4,
                          (_) => Container(
                        height: 28,
                        width: 80,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 🔹 Stats Row
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}