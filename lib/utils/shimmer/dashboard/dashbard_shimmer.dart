import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(height: 20, width: 100, color: Colors.white),
              Row(
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 35,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: List.generate(
            4,
            (index) => Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        buildMonthlyPerformanceShimmer(),
        const SizedBox(height: 20),
        buildDailyGoalsShimmer(),
        const SizedBox(height: 20),
        buildPartnerMilestoneRewardShimmer(),
        const SizedBox(height: 20),

        buildBestResellerOnTheMonthShimmer(),
      ],
    );
  }

  Widget buildMonthlyPerformanceShimmer() {
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
            // Header shimmer
            Row(
              children: [
                Container(height: 24, width: 24, color: Colors.white),
                const SizedBox(width: 8),
                Container(height: 18, width: 120, color: Colors.white),
              ],
            ),
            const SizedBox(height: 20),

            // Level Card shimmer
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(height: 16),

            // Progress shimmer
            Container(height: 14, width: double.infinity, color: Colors.white),
            const SizedBox(height: 10),
            Container(height: 10, width: 100, color: Colors.white),
            const SizedBox(height: 30),

            // Unlock message shimmer
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 30),

            // Level Up Journey shimmer
            Row(
              children: [
                Container(height: 40, width: 40, color: Colors.white),
                const SizedBox(width: 8),
                Container(height: 16, width: 100, color: Colors.white),
              ],
            ),
            const SizedBox(height: 20),
            Container(height: 60, width: double.infinity, color: Colors.white),
            const SizedBox(height: 20),

            // Unlock Bronze shimmer section
            Container(
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 20),

            // Commission & Leads shimmer cards
            Container(height: 80, width: double.infinity, color: Colors.white),
            const SizedBox(height: 12),
            Container(height: 80, width: double.infinity, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget buildDailyGoalsShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header Section Placeholder
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Progress Bar Placeholder
            Container(
              height: 20,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            const SizedBox(height: 12),

            // 🔹 Number Row Placeholder
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                (_) => Container(height: 12, width: 20, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Stats Section Placeholders
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
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
                  Container(
                    height: 16,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 8,
                    width: double.infinity,
                    color: Colors.white,
                  ),
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

  Widget buildBestResellerOnTheMonthShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header Section
            Row(
              children: [
                Container(height: 24, width: 24, color: Colors.white),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 16, width: 160, color: Colors.white),
                    const SizedBox(height: 6),
                    Container(height: 12, width: 80, color: Colors.white),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🔹 Commission Card
            Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 12),

            // 🔹 Level Card
            Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 12),

            // 🔹 Leads Card
            Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Motivational Banner
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
