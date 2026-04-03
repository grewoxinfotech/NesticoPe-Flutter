import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BuyerHireContractorListScreenShimmer extends StatelessWidget {
  final bool embedded;
  final EdgeInsetsGeometry? padding;
  const BuyerHireContractorListScreenShimmer({
    super.key,
    this.embedded = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (embedded) {
      return Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Column(
          children: List.generate(
            6,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: index == 5 ? 0 : 16),
              child: _contractorCard(),
            ),
          ),
        ),
      );
    } else {
      return ListView.separated(
        padding: padding ?? const EdgeInsets.all(16),
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return _contractorCard();
        },
      );
    }
  }

  Widget _contractorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header Row: Profile and Basic Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Contractor/Company Avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _line(width: 160, height: 18), // Company Name
                      const SizedBox(height: 8),
                      // Rating & Experience Row
                      Row(
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          _line(width: 80, height: 12),
                        ],
                      ),
                    ],
                  ),
                ),
                // Verification Badge Placeholder
                _circle(size: 24),
              ],
            ),

            const SizedBox(height: 16),

            // 🔹 Expertise/Service Chips
            Row(
              children: [
                _chip(width: 70),
                const SizedBox(width: 8),
                _chip(width: 90),
                const SizedBox(width: 8),
                _chip(width: 60),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(color: Colors.white, thickness: 1),
            const SizedBox(height: 16),

            // 🔹 Footer: Pricing and Call to Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _line(width: 100, height: 12), // "Rates starting from"
                    const SizedBox(height: 6),
                    _line(width: 120, height: 20), // Price/Rate Value
                  ],
                ),
                // "Hire" or "View Profile" Button
                Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _line({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _chip({required double width}) {
    return Container(
      width: width,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _circle({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}
