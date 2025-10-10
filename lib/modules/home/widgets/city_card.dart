// ///MARK:New City Card Widget Change in 13-09-2025
// import 'package:flutter/material.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';

// import 'package:flutter/material.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';

// class CityCard extends StatelessWidget {
//   final String imageUrl;
//   final String cityName;
//   final String propertyCount;

//   const CityCard({
//     super.key,
//     required this.imageUrl,
//     required this.cityName,
//     required this.propertyCount,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 170,
//       margin: const EdgeInsets.only(right: 16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: ColorRes.grey.withOpacity(0.15), width: 0.8),
//         color: ColorRes.white,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//             child: Stack(
//               children: [
//                 Image.network(
//                   imageUrl,
//                   height: 80,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     height: 55,
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [Colors.transparent, Colors.black87],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 10,
//                   left: 12,
//                   child: Text(
//                     cityName,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 16,
//                       color: ColorRes.white,
//                       letterSpacing: 0.5,
//                       shadows: [
//                         Shadow(
//                           color: Colors.black45,
//                           offset: Offset(0, 1),
//                           blurRadius: 4,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Property count section
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(6),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.shade50,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(
//                     Icons.home_work_rounded,
//                     size: 16,
//                     color: Colors.blue.shade600,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     propertyCount,
//                     style: TextStyle(
//                       fontSize: 10,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey.shade800,
//                       letterSpacing: 0.3,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
///MARK:New City Card Widget Change in 15-09-2025
import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

class CityCard extends StatelessWidget {
  final String imageUrl;
  final String cityName;
  final String propertyCount;

  const CityCard({
    super.key,
    required this.imageUrl,
    required this.cityName,
    required this.propertyCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorRes.grey.withOpacity(0.3), width: 0.8),
        color: ColorRes.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Stack(
              children: [
                Image.network(
                  imageUrl,
                  height: 80,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          ColorRes.transparentColor,
                          ColorRes.textPrimary,
                          ColorRes.textSecondary,
                          ColorRes.textPrimary,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cityName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: ColorRes.white,
                          letterSpacing: 0.6,
                          // shadows: [
                          //   Shadow(
                          //     color: Colors.black45,
                          //     offset: Offset(0, 1),
                          //     blurRadius: 4,
                          //   ),
                          // ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "$propertyCount ",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: ColorRes.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Property count section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Explore",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                    letterSpacing: 0.4,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
