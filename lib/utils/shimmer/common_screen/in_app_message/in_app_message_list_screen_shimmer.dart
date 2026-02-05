import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class InAppMessageListScreenShimmer extends StatelessWidget{
  const InAppMessageListScreenShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
        7,
              (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 12, right: 12),
            child: _shimmerCard(),
          ),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _line(width: 56, height: 56),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(width: MediaQuery.of(Get.context!).size.width * 0.6, height: 16),
                SizedBox(height: 8),
                _line(width: MediaQuery.of(Get.context!).size.width * 0.6, height: 12),
                SizedBox(height: 4),
                _line(width: MediaQuery.of(Get.context!).size.width * 0.4, height: 12),
                SizedBox(height: 12),
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

