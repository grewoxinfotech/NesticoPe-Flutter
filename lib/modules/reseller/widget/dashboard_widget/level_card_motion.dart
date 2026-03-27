import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math';

import '../../../../app/constants/color_res.dart';

class LevelCard extends StatefulWidget {
  final String levelName;
  final List<String> benefits;

  const LevelCard({
    super.key,
    required this.levelName,
    required this.benefits,
  });

  @override
  State<LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<LevelCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds:3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildBenefit(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 12,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                color: Color(0xFF2E2E2E),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
           color: Color(0xffFAF5F0),
            borderRadius: BorderRadius.circular(20),

           border: Border.all(color: ColorRes.homeYellow,width: 1)
          ),
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  // Smooth up-down + subtle left-right motion
                  final double dy = sin(_controller.value * 2 * pi) * 4;  // vertical
                  final double dx = cos(_controller.value * 1 * pi) * 1;  // horizontal (slightly increased)

                  return Transform.translate(
                    offset: Offset(dx, dy),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xff725AB7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.local_florist,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),
             /* Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xff725AB7),
                  borderRadius: BorderRadius.circular(30),

                ),
                child: Text(
                  widget.levelName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),*/
              buildLevelBadge(widget.levelName),
              const SizedBox(height: 12),
              Text(
                "${widget.levelName} Level",
                style:  TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff725AB7),
                ),
              ),

              const SizedBox(height: 12),
              ...widget.benefits.take(2).map((b) => buildBenefit(b)).toList(),
            ],
          ),
        ),

        SizedBox(height: 20,),

        // ✨ Floating star animation
        AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            // Move only vertically (up & down)
            final double dy = sin(_controller.value * 2 * pi) * 8; // adjust amplitude (8 = smooth)
            return Positioned(
              right: 20,
              top: 10 + dy, // only Y position changes
              child: const Icon(
                Icons.star,
                color: Colors.amberAccent,
                size: 20,
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            // Move only vertically (up & down)
            final double dy = sin(_controller.value * 2 * pi) * 8; // adjust amplitude (8 = smooth)
            return Positioned(
              bottom: 20,
              left: 20,
              top: 10 + dy, // only Y position changes
              child: const Icon(
                Icons.star,
                color: Colors.amberAccent,
                size: 20,
              ),
            );
          },
        ),

      ],
    );
  }
}





Widget buildLevelBadge(String text) {
  return IntrinsicWidth(
    child: Stack(
      alignment: Alignment.center,
      children: [
        // Shimmer moving across the badge
        // Shimmer.fromColors(
        //   baseColor: const Color(0xff725AB7),
        //   highlightColor: Colors.white.withOpacity(0.2),
        //   period: const Duration(seconds: 5),
        //   child: Container(
        //     height: 30,
        //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        //     decoration: BoxDecoration(
        //       color: const Color(0xff725AB7),
        //       borderRadius: BorderRadius.circular(30),
        //       border: Border.all(
        //         color: const Color(0xff725AB7).withOpacity(0.4),
        //         width: 1,
        //       ),
        //     ),
        //   ),
        // ),
                Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xff725AB7),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xff725AB7).withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                ),

        // Visible text on top
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
          child: Text(
            text.toUpperCase(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    ),
  );
}




