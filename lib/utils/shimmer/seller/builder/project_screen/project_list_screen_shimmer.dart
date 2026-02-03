// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
//
// class ProjectListScreenShimmer extends StatelessWidget {
//   const ProjectListScreenShimmer({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       padding: const EdgeInsets.all(16),
//       itemCount: 4,
//       separatorBuilder: (_, __) => const SizedBox(height: 16),
//       itemBuilder: (context, index) {
//         return Shimmer.fromColors(
//           baseColor: Colors.grey.shade300,
//           highlightColor: Colors.grey.shade100,
//           child: _shimmerCard(),
//         );
//       },
//     );
//   }
//
//   Widget _shimmerCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // 🔹 Image Placeholder
//           Container(
//             height: 70,
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//             ),
//           ),
//
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _line(width: 140, height: 18), // Project name
//                 const SizedBox(height: 8),
//                 _line(width: 220, height: 14), // Location
//
//                 const SizedBox(height: 16),
//
//                 // 🔹 Builder Card
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     color: Colors.white,
//                     border: Border.all(color: Colors.grey.shade300),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _line(width: 80, height: 14),
//                       const SizedBox(height: 8),
//                       _line(width: 180, height: 14),
//                       const SizedBox(height: 8),
//                       _line(width: 120, height: 14),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 16),
//
//                 // 🔹 Info Chips
//                 Row(
//                   children: [
//                     _chip(width: 70),
//                     const SizedBox(width: 8),
//                     _chip(width: 40),
//                     const SizedBox(width: 8),
//                     _chip(width: 80),
//                   ],
//                 ),
//
//                 const SizedBox(height: 16),
//
//                 // 🔹 Price + Arrow
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _line(width: 120, height: 18),
//                     Container(
//                       height: 40,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _line({required double width, required double height}) {
//     return Container(
//       height: height,
//       width: width,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(6),
//       ),
//     );
//   }
//
//   Widget _chip({required double width}) {
//     return Container(
//       height: 28,
//       width: width,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProjectListScreenShimmer extends StatelessWidget {
  const ProjectListScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _shimmerCard();
      },
    );
  }

  Widget _shimmerCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ), // Subtle border for definition
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
            Container(height: 150, color: Colors.white),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _line(width: 140, height: 18),
                  const SizedBox(height: 8),
                  _line(width: 220, height: 14),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      _chip(width: 70),
                      const SizedBox(width: 8),
                      _chip(width: 40),
                      const SizedBox(width: 8),
                      _chip(width: 80),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _line(width: 120, height: 18),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _chip({required double width}) {
    return Container(
      height: 28,
      width: width,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
