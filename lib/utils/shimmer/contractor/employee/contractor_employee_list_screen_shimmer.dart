import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContractorEmployeeListScreenShimmer extends StatelessWidget {
  const ContractorEmployeeListScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _employeeCard();
      },
    );
  }

  Widget _employeeCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
                // 🔹 Employee Avatar Circle
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),

                // 🔹 Employee Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name Placeholder
                      _line(width: 120, height: 16),
                      const SizedBox(height: 6),
                      // Role/Designation Placeholder
                      _line(width: 80, height: 12),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: Colors.black),
                SizedBox(width: 6),
                _line(width: 80, height: 12),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.work_outline_rounded, size: 16, color: Colors.black),
                SizedBox(width: 6),
                _line(width: 80, height: 12),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _line(width: 120, height: 45)),
                SizedBox(width: 12),
                Expanded(child: _line(width: 120, height: 45)),
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
