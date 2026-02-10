import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BuyerMyVisitListScreenShimmer extends StatelessWidget {
  const BuyerMyVisitListScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _visitCard();
      },
    );
  }

  Widget _visitCard() {
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
            // 🔹 Property Header Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                // Property Thumbnail Placeholder
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _line(width: 140, height: 16), // Property Name
                    const SizedBox(height: 8),
                    _line(width: 180, height: 16), // Location/Address
                  ],
                ),
                _line(width: 100, height: 16), // Status
              ],
            ),

            const SizedBox(height: 16),
            const Divider(color: Colors.white, thickness: 1),
            const SizedBox(height: 16),

            // 🔹 Visit Date and Time Row
            _iconDetail(Icons.calendar_today, 90),
            const SizedBox(height: 16),
            _iconDetail(Icons.location_on_outlined, 90),
            const SizedBox(height: 16),
            _iconDetail(Icons.note, 90),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _iconDetail(IconData icon, double textWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.white),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _line(width: textWidth, height: 14),
            SizedBox(height: 4),
            _line(width: 150, height: 12),
          ],
        ),
      ],
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
