import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ResellerProfileScreenShimmer extends StatelessWidget {
  const ResellerProfileScreenShimmer({super.key});

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
            // 🔹 Header Section (Avatar, Name, Button)
            _staticCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      // Avatar
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
                          _line(width: 40, height: 24), // Name
                          const SizedBox(height: 8),
                          Container(
                            width: 70,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ), // Partner Badge
                          const SizedBox(height: 4),
                          _line(width: 100, height: 14), // Location
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Customize Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 120,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Lead Report Dropdown Placeholder
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(width: 24, height: 24, color: Colors.white),
                      const SizedBox(width: 12),
                      _line(width: 100, height: 16),
                    ],
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Profile Information Section
            _staticCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 12),
                    child: _line(width: 140, height: 18),
                  ),
                  ...List.generate(4, (index) => _inputField()),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Performance Overview Section
            _staticCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 12),
                    child: _line(width: 140, height: 18),
                  ),
                  Row(
                    children: [
                      Expanded(child: _statItem("Total Commission")),
                      Expanded(child: _statItem("Performance Levels")),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _statItem("Success Rate")),
                      Expanded(child: _statItem("Total Sales")),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Account Information
            _staticCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 12),
                    child: _line(width: 140, height: 18),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [_infoPair(), _infoPair()],
                  ),
                  const SizedBox(height: 16),
                  _infoPair(), // Verification Status
                  const SizedBox(height: 20),
                  // Delete Button
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _staticCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: _line(width: 140, height: 18),
    );
  }

  Widget _inputField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
      ),
    );
  }

  Widget _statItem(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _line(width: 100, height: 12), // Label
        const SizedBox(height: 8),
        _line(width: 60, height: 16), // Value
      ],
    );
  }

  Widget _infoPair() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _line(width: 70, height: 10),
        const SizedBox(height: 6),
        _line(width: 90, height: 14),
      ],
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
