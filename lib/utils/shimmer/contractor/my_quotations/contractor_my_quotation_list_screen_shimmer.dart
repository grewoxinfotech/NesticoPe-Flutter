import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContractorMyQuotationListScreenShimmer extends StatelessWidget {
  const ContractorMyQuotationListScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _quotationCard();
      },
    );
  }

  Widget _quotationCard() {
    return Container(
      padding: const EdgeInsets.all(12),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _line(width: 100, height: 8),
                    const SizedBox(height: 8),
                    _line(width: 80, height: 16),
                  ],
                ),
                const Spacer(),
                _line(width: 80, height: 20),
              ],
            ),

            SizedBox(height: 16),

            Row(
              children: [
                Icon(Icons.person_outline, size: 16, color: Colors.black),
                SizedBox(width: 8),
                _line(width: 120, height: 10),
              ],
            ),

            Row(
              children: [
                Icon(Icons.phone, size: 16, color: Colors.black),
                SizedBox(width: 8),
                _line(width: 80, height: 10),
              ],
            ),

            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 16, color: Colors.black),
                SizedBox(width: 8),
                _line(width: 150, height: 10),
              ],
            ),

            SizedBox(height: 8),
            Divider(color: Colors.grey.shade300),
            SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    _line(width: 100, height: 12),
                    SizedBox(height: 8),
                    _line(width: 80, height: 18),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _line(width: 100, height: 12),
                    SizedBox(height: 8),
                    _line(width: 80, height: 18),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            _line(width: 150, height: 30),
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
