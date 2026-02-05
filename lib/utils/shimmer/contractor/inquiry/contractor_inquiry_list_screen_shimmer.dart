import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContractorInquiryListScreenShimmer extends StatelessWidget {
  const ContractorInquiryListScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _inquiryCard();
      },
    );
  }

  Widget _inquiryCard() {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                _line(width: 100, height: 16),
                Row(
                  children: [
                    _line(width: 70, height: 16),
                    Icon(Icons.keyboard_arrow_down_rounded),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.black, size: 16),
                SizedBox(width: 8),
                _line(width: 80, height: 12),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.email, color: Colors.black, size: 16),
                SizedBox(width: 8),
                _line(width: 100, height: 12),
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
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
