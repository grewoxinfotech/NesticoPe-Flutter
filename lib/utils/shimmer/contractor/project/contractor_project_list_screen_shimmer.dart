import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ContractorProjectListScreenShimmer extends StatelessWidget {
  const ContractorProjectListScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        return _contractorProjectCard();
      },
    );
  }

  Widget _contractorProjectCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Project Name and Date Badge Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _line(width: 160, height: 20), // Project Title
                      // Date/Calendar Badge Placeholder
                      Container(
                        width: 80,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 🔹 Location Text Row
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 16,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 4),
                      _line(width: 180, height: 14),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.currency_rupee_rounded,
                        size: 16,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 4),
                      _line(width: 180, height: 14),
                    ],
                  ),
                  SizedBox(height: 12),

                  // 🔹 Price Footer Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          _line(width: 80, height: 16),
                          _line(width: 30, height: 16),
                        ],
                      ), // "Starting from" label
                      const SizedBox(height: 8),
                      _line(
                        width: MediaQuery.of(Get.context!).size.width * 0.82,
                        height: 12,
                      ), // Price range
                    ],
                  ),
                ],
              ),
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
