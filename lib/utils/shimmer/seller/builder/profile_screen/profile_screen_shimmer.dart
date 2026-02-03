import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreenShimmer extends StatelessWidget {
  const ProfileScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Profile Header Card (Always visible container, shimmering contents)
          _staticSectionCard(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Circular Avatar
                      Container(
                        width: 85,
                        height: 85,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _line(width: 100, height: 22), // Name placeholder
                          const SizedBox(height: 10),
                          _line(width: 70, height: 24), // Badge placeholder
                          const SizedBox(height: 10),
                          _line(width: 130, height: 16), // Location placeholder
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Customize Button Placeholder
                  Container(
                    width: 110,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 🔹 Personal Info Section (Static Title, Shimmering Fields)
          _sectionTitleShimmer(),

          _staticSectionCard(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                children: List.generate(
                  8,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _fieldPlaceholder(),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 🔹 Business Details Section
          _sectionTitleShimmer(),

          _staticSectionCard(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                children: List.generate(
                  5,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _fieldPlaceholder(),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 🔹 Seller Details (Two column layout)
          _sectionTitleShimmer(),
          _staticSectionCard(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _detailColumn(labelWidth: 80, valueWidth: 100),
                  _detailColumn(labelWidth: 120, valueWidth: 40),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 🔹 Account Information
          _sectionTitleShimmer(),

          _staticSectionCard(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                children: [
                  _fieldPlaceholder(),
                  const SizedBox(height: 16),
                  _fieldPlaceholder(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40), // Bottom padding
        ],
      ),
    );
  }

  // 1. Static Card Wrapper (Ensures card shapes are always visible)
  Widget _staticSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: child,
    );
  }

  // 2. Static Section Header Text
  Widget _sectionTitleShimmer() {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 18, // same as font size
          width: 140, // approximate title width
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  // 3. Shimmer Line (used as content mask)
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

  // 4. Input Field Mask
  Widget _fieldPlaceholder() {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  // 5. Detail Column for Seller Info
  Widget _detailColumn({
    required double labelWidth,
    required double valueWidth,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _line(width: labelWidth, height: 10),
        const SizedBox(height: 8),
        _line(width: valueWidth, height: 18),
      ],
    );
  }
}
