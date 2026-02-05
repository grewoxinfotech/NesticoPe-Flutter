import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContractorMyServiceListScreenShimmer extends StatelessWidget {
  const ContractorMyServiceListScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _serviceCard();
      },
    );
  }

  Widget _serviceCard() {
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
              children: [
                Expanded(child: _line(width: double.infinity, height: 20)),
                const SizedBox(width: 24),
                _line(width: 50, height: 20),
                const SizedBox(width: 8),
                _line(width: 50, height: 20),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _line(width: 100, height: 20),
                _line(width: 60, height: 20),
              ],
            ),
            SizedBox(height: 16),
            _line(width: double.infinity, height: 20),
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
}
