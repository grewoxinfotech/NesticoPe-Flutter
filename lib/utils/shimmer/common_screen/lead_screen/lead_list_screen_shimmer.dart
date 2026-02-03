import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LeadListScreenShimmer extends StatelessWidget {
  const LeadListScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _shimmerCard();
      },
    );
  }

  Widget _shimmerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
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
        // The child here acts as the mask.
        // Solid colors become the shimmering parts.
        // Transparent parts show the white container background.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Section (Avatar + Info + Date) ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),

                // Name & Contact Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name Line
                      Container(
                        width: 120,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Phone Line
                      Container(
                        width: 100,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Email Line
                      Container(
                        width: 150,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),

                // Date (Top Right)
                Container(
                  width: 40,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // --- Divider Line ---
            Container(height: 1, width: double.infinity, color: Colors.black),

            const SizedBox(height: 16),

            // --- Chips Row ---
            Row(
              children: [
                _shimmerChip(width: 60),
                const SizedBox(width: 8),
                _shimmerChip(width: 80),
                const SizedBox(width: 8),
                _shimmerChip(width: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerChip({required double width}) {
    return Container(
      height: 32,
      width: width,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
