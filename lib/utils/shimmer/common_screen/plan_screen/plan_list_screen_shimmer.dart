import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PlanListScreenShimmer extends StatelessWidget {
  final int count;
  const PlanListScreenShimmer({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 12, right: 12),
          child: _shimmerCard(),
        ),
      ),
    );
  }

  Widget _shimmerCard() {
    return Container(
      // The static container acting as the "Card" background
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        // The child acts as the mask
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Plan Title (e.g., "Gold")
            Container(
              width: 80,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(6),
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 Feature List Items
            // Simulating 5 rows of features (Icon + Text)
            _featureRow(width: 180),
            const SizedBox(height: 16),
            _featureRow(width: 140),
            const SizedBox(height: 16),
            _featureRow(width: 160),
            const SizedBox(height: 16),
            _featureRow(width: 120),
            const SizedBox(height: 16),
            _featureRow(width: 130),

            const SizedBox(height: 16),

            // 🔹 "Show more" placeholder
            Container(
              width: 90,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            const SizedBox(height: 32),

            // 🔹 "Select Plan" Button
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureRow({required double width}) {
    return Row(
      children: [
        // Tick/Cross Icon Placeholder
        Container(
          width: 16,
          height: 16,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        // Text Line
        Container(
          width: width,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
