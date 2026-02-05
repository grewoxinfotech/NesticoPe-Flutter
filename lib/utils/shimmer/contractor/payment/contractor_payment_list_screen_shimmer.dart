import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContractorPaymentListScreenShimmer extends StatelessWidget {
  const ContractorPaymentListScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _paymentCard();
      },
    );
  }

  Widget _paymentCard() {
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
            // 🔹 Header Row: Transaction ID and Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _line(width: 100, height: 12), // "Invoice #12345" label
                    const SizedBox(height: 6),
                    _line(width: 140, height: 16), // Project Name Placeholder
                  ],
                ),
                // Status Badge (e.g., Paid / Pending)
                Container(
                  width: 70,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            const Divider(color: Colors.white, thickness: 1),
            const SizedBox(height: 8),

            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 20,
                  color: Colors.grey,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _line(width: 100, height: 16),
                    const SizedBox(height: 8),
                    _line(width: 60, height: 14),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: Colors.grey,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _line(width: 100, height: 16),
                    const SizedBox(height: 8),
                    _line(width: 60, height: 14),
                  ],
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
}
