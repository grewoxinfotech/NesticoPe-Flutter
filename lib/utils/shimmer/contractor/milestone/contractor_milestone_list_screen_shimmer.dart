import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContractorMilestoneListScreenShimmer extends StatelessWidget {
  const ContractorMilestoneListScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _milestoneCard();
      },
    );
  }

  Widget _milestoneCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _line(width: 60, height: 16),
                        const SizedBox(width: 8),
                        _line(width: 40, height: 16),
                        SizedBox(width: 8),
                        _line(width: 40, height: 16),
                      ],
                    ),
                    SizedBox(height: 8),
                    _line(width: 100, height: 14),
                  ],
                ),
                _circle(size: 40),
              ],
            ),
            SizedBox(height: 8),
            _line(width: 100, height: 14),
            SizedBox(height: 8),
            Divider(color: Colors.grey.shade300),
            SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _line(width: 50, height: 16),
                      SizedBox(height: 8),
                      _line(width: 30, height: 14),
                    ],
                  ),
                ),
                Container(width: 1, height: 32, color: Colors.grey.shade300),

                Expanded(
                  child: Column(
                    children: [
                      _line(width: 50, height: 16),
                      SizedBox(height: 8),
                      _line(width: 30, height: 14),
                    ],
                  ),
                ),
                Container(width: 1, height: 32, color: Colors.grey.shade300),
                Expanded(
                  child: Column(
                    children: [
                      _line(width: 50, height: 16),
                      SizedBox(height: 8),
                      _line(width: 30, height: 14),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                _line(width: 80, height: 14),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded, size: 16),
                SizedBox(width: 8),
                Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                _line(width: 80, height: 14),
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

  Widget _circle({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}
