import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContractorProjectEmployeeListScreenShimmer extends StatelessWidget {
  const ContractorProjectEmployeeListScreenShimmer({super.key});

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
                // 🔹 Employee Avatar Placeholder
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),

                // 🔹 Employee Name and Role Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Name Placeholder
                      _line(width: 130, height: 16),
                      const SizedBox(height: 8),
                      // Project Role / Designation (e.g., Site Supervisor)
                      _line(width: 90, height: 12),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _line(width: double.infinity, height: 20),
            SizedBox(height: 8),
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
