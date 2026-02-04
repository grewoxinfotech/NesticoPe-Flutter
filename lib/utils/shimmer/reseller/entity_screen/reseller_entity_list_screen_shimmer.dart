import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ResellerEntityListScreenShimmer extends StatelessWidget {
  const ResellerEntityListScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _entityCard();
      },
    );
  }

  Widget _entityCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🔹 Left Side: Thumbnail Placeholder
              Container(
                width: 110,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(16),
                  ),
                ),
              ),

              // 🔹 Right Side: Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Share Icon Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _line(width: 100, height: 16), // Entity Name
                          const Icon(
                            Icons.share,
                            size: 18,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Location Text
                      _line(width: 140, height: 12),
                      const SizedBox(height: 12),

                      // Commission Row
                      Row(
                        children: [
                          _line(width: 80, height: 12), // "Commissions:" label
                          const SizedBox(width: 8),
                          _line(width: 50, height: 12), // Commission Value
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Price Range
                      _line(width: 110, height: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
}
