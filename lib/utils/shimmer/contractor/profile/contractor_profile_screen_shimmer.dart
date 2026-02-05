import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContractorProfileScreenShimmer extends StatelessWidget {
  const ContractorProfileScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Profile Header Section
            _staticCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      // Profile Image Circle
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _line(width: 140, height: 20), // Name placeholder
                          const SizedBox(height: 8),
                          _line(width: 100, height: 18),
                          const SizedBox(height: 8),
                          _line(width: 80, height: 14),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Customize Profile Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 130,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 Performance Overview (Grid of stats)

            // 🔹 Profile Information Fields
            _staticCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Profile Information"),
                  SizedBox(height: 12),
                  ...List.generate(
                    6,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _fieldPlaceholder(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            _staticCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Performance Overview"),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 2.5,
                    children: [
                      _statItem(),
                      _statItem(),
                      _statItem(),
                      _statItem(),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 Account Settings/Info
            Column(
              children: [
                _fieldPlaceholder(),
                const SizedBox(height: 12),
                _fieldPlaceholder(),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _staticCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: _line(width: 150, height: 18),
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

  Widget _fieldPlaceholder() {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
    );
  }

  Widget _statItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _line(width: 80, height: 12),
        const SizedBox(height: 6),
        _line(width: 40, height: 18),
      ],
    );
  }
}
