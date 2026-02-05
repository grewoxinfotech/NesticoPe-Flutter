import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContractorSuccessStoryScreenShimmer extends StatelessWidget {
  const ContractorSuccessStoryScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return _successStoryCard();
  }

  Widget _successStoryCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: _staticCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔹 Story Media Placeholder (Image/Video)
              Container(
                height: 220,
                width: double.infinity,
                color: Colors.white,
                child: Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    size: 48,
                    color: Colors.grey.shade100,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Project Category/Label
                    Container(
                      width: 80,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 🔹 Success Story Title
                    _line(width: 240, height: 22),
                    const SizedBox(height: 8),
                    _line(width: 180, height: 22),

                    const SizedBox(height: 16),

                    // 🔹 Description/Quote Placeholder
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _line(width: double.infinity, height: 14),
                        const SizedBox(height: 6),
                        _line(width: double.infinity, height: 14),
                        const SizedBox(height: 6),
                        _line(width: 200, height: 14),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Divider(color: Colors.white, thickness: 1),
                    const SizedBox(height: 16),

                    // 🔹 Footer: Client Info & Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            _line(width: 100, height: 14),
                          ],
                        ),
                        _line(width: 70, height: 12),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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
}
