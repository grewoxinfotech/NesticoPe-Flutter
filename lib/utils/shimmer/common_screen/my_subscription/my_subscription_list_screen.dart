import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MySubscriptionListScreenShimmer extends StatelessWidget {
  const MySubscriptionListScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 7,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _historyItem();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _historyItem() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              _line(width: 100, height: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _line(width: 80, height: 16),
                    const SizedBox(width: 8),
                    _line(width: 40, height: 16),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          _line(width: 140, height: 16),
          SizedBox(height: 8),
          _line(width: 140, height: 16),
          SizedBox(height: 8),
          _line(width: 50, height: 16),
        ],
      ),
    );
  }

  Widget _sectionTitle({required double width}) {
    return Container(
      width: width,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
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
