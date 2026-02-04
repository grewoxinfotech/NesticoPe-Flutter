import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VisitListScreenShimmer extends StatelessWidget {
  const VisitListScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 2,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _staticVisitCard(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: _visitCardSkeleton(),
          ),
        );
      },
    );
  }

  /// 🔹 Extracted skeleton for readability
  Widget _visitCardSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _circle(50),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _line(width: 120, height: 18),
                  const SizedBox(height: 6),
                  _line(width: 150, height: 14),
                ],
              ),
            ),
            _pill(width: 80, height: 30),
          ],
        ),

        const SizedBox(height: 16),
        const Divider(color: Colors.black),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(child: _infoBox()),
            const SizedBox(width: 12),
            Expanded(child: _infoBox()),
          ],
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _line(width: 60, height: 14),
              const SizedBox(height: 8),
              _line(width: double.infinity, height: 12),
              const SizedBox(height: 4),
              _line(width: 200, height: 12),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            const Icon(Icons.access_time, size: 16, color: Colors.black),
            const SizedBox(width: 6),
            _line(width: 140, height: 12),
          ],
        ),

        const SizedBox(height: 24),

        _button(height: 50),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(child: _button(height: 50)),
            const SizedBox(width: 12),
            Expanded(child: _button(height: 50)),
          ],
        ),
      ],
    );
  }

  // ───────────────── helpers ─────────────────

  Widget _staticVisitCard({required Widget child}) {
    return Container(
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

  Widget _infoBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _square(16),
              const SizedBox(width: 8),
              _line(width: 40, height: 10),
            ],
          ),
          const SizedBox(height: 8),
          _line(width: 80, height: 14),
        ],
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

  Widget _circle(double size) => Container(
    width: size,
    height: size,
    decoration: const BoxDecoration(
      color: Colors.black,
      shape: BoxShape.circle,
    ),
  );

  Widget _square(double size) =>
      Container(width: size, height: size, color: Colors.black);

  Widget _pill({required double width, required double height}) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(20),
    ),
  );

  Widget _button({required double height}) => Container(
    height: height,
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(12),
    ),
  );
}
