import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CalenderScreenShimmer extends StatelessWidget {
  const CalenderScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 16,),
          // Event List Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerText(width: 140, height: 18), // Date header e.g. "February 5, 2026"
                const SizedBox(height: 12),
                _eventCardShimmer(),
                const SizedBox(height: 24),
                _shimmerText(width: 140, height: 18), // Date header e.g. "February 6, 2026"
                const SizedBox(height: 12),
                ...List.generate(5, (index) {
                  return Column(
                    children: [
                      _eventCardShimmer(),
                      const SizedBox(height: 8),

                    ],
                  );
                },),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _calendarCardShimmer() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          children: [
            // Month Navigation Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.chevron_left, color: Colors.black),
                _shimmerText(width: 120, height: 16),
                const Icon(Icons.chevron_right, color: Colors.black),
              ],
            ),
            const SizedBox(height: 24),

            // Days of week header (S M T W T F S)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) => _shimmerText(width: 15, height: 12)),
            ),
            const SizedBox(height: 16),

            // Calendar Grid (5 rows)
            Column(
              children: List.generate(5, (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (index) => _shimmerCircle(size: 24)),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _eventCardShimmer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          children: [
            // Red dot indicator placeholder
            _shimmerCircle(size: 10),
            const SizedBox(width: 12),

            // Title and time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shimmerText(width: 100, height: 16),
                  const SizedBox(height: 6),
                  _shimmerText(width: 150, height: 12),
                ],
              ),
            ),

            // Chip and Menu
            _shimmerText(width: 60, height: 24), // "Personal" chip
            const SizedBox(width: 8),
            const Icon(Icons.more_vert, size: 20, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _shimmerText({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _shimmerCircle({required double size}) {
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