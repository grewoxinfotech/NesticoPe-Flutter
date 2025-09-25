// import 'package:flutter/material.dart';
// import 'package:housing_flutter_app/app/widgets/cards/banner_card_with_text.dart';
// import '../../../../app/constants/img_res.dart';
//
// class CityFilterList extends StatefulWidget {
//   const CityFilterList({super.key});
//
//   @override
//   State<CityFilterList> createState() => _CityFilterListState();
// }
//
// class _CityFilterListState extends State<CityFilterList> {
//   final List<String> cities = [
//     "Mumbai",
//     "Delhi",
//     "Bangalore",
//     "Pune",
//     "Chennai",
//     "Kolkata",
//     "Hyderabad",
//   ];
//
//   final List<String> images = [
//     IMGRes.city1,
//     IMGRes.city2,
//     IMGRes.city3,
//     IMGRes.city4,
//     IMGRes.city5,
//     IMGRes.city6,
//     IMGRes.city7,
//   ];
//
//   int selectedIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 100,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         itemCount: cities.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 12),
//         itemBuilder: (context, index) {
//           final isSelected = selectedIndex == index;
//
//           return NesticoPeBannerCardWithText(
//             imageUrl: images[index],
//           //  title: cities[index],
//             price: "1200",
//             location: cities[index],
//             propertySize: "2BHK, 1200 sqft",
//             height: 100,
//             width: 150,
//             isCenterText: true,
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import '../../../../app/constants/img_res.dart';
//
// class CityFilterList extends StatefulWidget {
//   const CityFilterList({super.key});
//
//   @override
//   State<CityFilterList> createState() => _CityFilterListState();
// }
//
// class _CityFilterListState extends State<CityFilterList> {
//   final List<String> cities = [
//     "Mumbai",
//     "Delhi",
//     "Bangalore",
//     "Pune",
//     "Chennai",
//     "Kolkata",
//     "Hyderabad",
//   ];
//
//   final List<String> images = [
//     IMGRes.city1,
//     IMGRes.city2,
//     IMGRes.city3,
//     IMGRes.city4,
//     IMGRes.city5,
//     IMGRes.city6,
//     IMGRes.city7,
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 125,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         itemCount: cities.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 16),
//         itemBuilder: (context, index) {
//           return GestureDetector(
//             onTap: () {},
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CircleAvatar(
//                   radius: 45,
//                   backgroundImage: AssetImage(images[index]),
//                   backgroundColor: Colors.grey[200],
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   cities[index],
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import '../../../../app/constants/img_res.dart';
//
// class CityFilterList extends StatefulWidget {
//   const CityFilterList({super.key});
//
//   @override
//   State<CityFilterList> createState() => _CityFilterListState();
// }
//
// class _CityFilterListState extends State<CityFilterList>
//     with TickerProviderStateMixin {
//   final List<String> cities = [
//     "Mumbai",
//     "Delhi",
//     "Bangalore",
//     "Pune",
//     "Chennai",
//     "Kolkata",
//     "Hyderabad",
//   ];
//
//   final List<String> images = [
//     IMGRes.city1,
//     IMGRes.city2,
//     IMGRes.city3,
//     IMGRes.city4,
//     IMGRes.city5,
//     IMGRes.city6,
//     IMGRes.city7,
//   ];
//
//   final List<Color> gradientColors = [
//     const Color(0xFF6366F1),
//     const Color(0xFF8B5CF6),
//     const Color(0xFFEC4899),
//     const Color(0xFFEF4444),
//     const Color(0xFFF59E0B),
//     const Color(0xFF10B981),
//     const Color(0xFF06B6D4),
//   ];
//
//   int selectedIndex = -1;
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _rotationAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
//     );
//     _rotationAnimation = Tween<double>(begin: 0.0, end: 0.02).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 140,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         itemCount: cities.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 16),
//         itemBuilder: (context, index) {
//           final isSelected = selectedIndex == index;
//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 selectedIndex = selectedIndex == index ? -1 : index;
//               });
//               if (isSelected) {
//                 _animationController.forward().then((_) {
//                   _animationController.reverse();
//                 });
//               }
//             },
//             child: AnimatedBuilder(
//               animation: _animationController,
//               builder: (context, child) {
//                 return Transform.scale(
//                   scale: isSelected ? _scaleAnimation.value : 1.0,
//                   child: Transform.rotate(
//                     angle: isSelected ? _rotationAnimation.value : 0.0,
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 400),
//                       curve: Curves.easeOutCubic,
//                       width: 95,
//                       margin: EdgeInsets.only(top: isSelected ? 0 : 8),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         gradient: isSelected
//                             ? LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                             gradientColors[index].withOpacity(0.8),
//                             gradientColors[index],
//                           ],
//                         )
//                             : null,
//                         color: isSelected ? null : Colors.white,
//                         boxShadow: [
//                           BoxShadow(
//                             color: isSelected
//                                 ? gradientColors[index].withOpacity(0.4)
//                                 : Colors.black.withOpacity(0.08),
//                             blurRadius: isSelected ? 20 : 8,
//                             offset: Offset(0, isSelected ? 8 : 4),
//                             spreadRadius: isSelected ? 2 : 0,
//                           ),
//                         ],
//                         border: isSelected
//                             ? null
//                             : Border.all(
//                           color: Colors.grey.withOpacity(0.1),
//                           width: 1,
//                         ),
//                       ),
//                       child: Stack(
//                         children: [
//                           // Glassmorphism effect for selected state
//                           if (isSelected)
//                             Positioned.fill(
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(20),
//                                   gradient: LinearGradient(
//                                     begin: Alignment.topLeft,
//                                     end: Alignment.bottomRight,
//                                     colors: [
//                                       Colors.white.withOpacity(0.2),
//                                       Colors.white.withOpacity(0.1),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           Padding(
//                             padding: const EdgeInsets.all(12),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 // Floating badge effect
//                                 Stack(
//                                   clipBehavior: Clip.none,
//                                   children: [
//                                     Container(
//                                       width: 60,
//                                       height: 60,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(16),
//                                         border: isSelected
//                                             ? Border.all(
//                                           color: Colors.white.withOpacity(0.3),
//                                           width: 2,
//                                         )
//                                             : null,
//                                       ),
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.circular(14),
//                                         child: Stack(
//                                           fit: StackFit.expand,
//                                           children: [
//                                             Image.asset(
//                                               images[index],
//                                               fit: BoxFit.cover,
//                                             ),
//                                             // Overlay for unselected state
//                                             if (!isSelected)
//                                               Container(
//                                                 decoration: BoxDecoration(
//                                                   gradient: LinearGradient(
//                                                     begin: Alignment.topCenter,
//                                                     end: Alignment.bottomCenter,
//                                                     colors: [
//                                                       Colors.transparent,
//                                                       Colors.black.withOpacity(0.3),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     // Floating selection indicator
//                                     if (isSelected)
//                                       Positioned(
//                                         top: -8,
//                                         right: -8,
//                                         child: AnimatedContainer(
//                                           duration: const Duration(milliseconds: 300),
//                                           width: 24,
//                                           height: 24,
//                                           decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             shape: BoxShape.circle,
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: gradientColors[index].withOpacity(0.5),
//                                                 blurRadius: 8,
//                                                 spreadRadius: 1,
//                                               ),
//                                             ],
//                                           ),
//                                           child: Icon(
//                                             Icons.star_rounded,
//                                             color: gradientColors[index],
//                                             size: 16,
//                                           ),
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 12),
//                                 Text(
//                                   cities[index],
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.w700,
//                                     color: isSelected
//                                         ? Colors.white
//                                         : Colors.grey[800],
//                                     letterSpacing: 0.2,
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   textAlign: TextAlign.center,
//                                 ),
//                                 // Animated dots indicator
//                                 if (isSelected)
//                                   Container(
//                                     margin: const EdgeInsets.only(top: 4),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: List.generate(3, (dotIndex) {
//                                         return AnimatedContainer(
//                                           duration: Duration(
//                                             milliseconds: 200 + (dotIndex * 100),
//                                           ),
//                                           margin: const EdgeInsets.symmetric(horizontal: 1.5),
//                                           width: 4,
//                                           height: 4,
//                                           decoration: BoxDecoration(
//                                             color: Colors.white.withOpacity(0.8),
//                                             shape: BoxShape.circle,
//                                           ),
//                                         );
//                                       }),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// GestureDetector(
// onTap: () {
// setState(() {
// selectedIndex = index;
// });
// },
// child: Column(
// mainAxisSize: MainAxisSize.min,
// children: [
// Container(
// decoration: BoxDecoration(
// shape: BoxShape.circle,
// border:
// isSelected
// ? Border.all(color: Colors.blueAccent, width: 3)
//     : null,
// ),
// padding: const EdgeInsets.all(2),
// child: ClipOval(
// child: Image.asset(
// images[index],
// width: 70,
// height: 70,
// fit: BoxFit.cover,
// ),
// ),
// ),
// const SizedBox(height: 8),
// Text(
// cities[index],
// style: TextStyle(
// fontSize: 14,
// fontWeight: FontWeight.w500,
// color: isSelected ? Colors.blueAccent : Colors.black87,
// ),
// ),
// ],
// ),
// );

import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';
import 'package:housing_flutter_app/app/widgets/cards/banner_card_with_text.dart';
import '../../../../app/constants/img_res.dart';

class CityFilterList extends StatefulWidget {
  const CityFilterList({super.key});

  @override
  State<CityFilterList> createState() => _CityFilterListState();
}

class _CityFilterListState extends State<CityFilterList> {
  final List<String> cities = [
    "Mumbai",
    "Delhi",
    "Bangalore",
    "Pune",
    "Chennai",
    "Kolkata",
    "Hyderabad",
  ];

  final List<String> images = [
    IMGRes.city1,
    IMGRes.city2,
    IMGRes.city3,
    IMGRes.city4,
    IMGRes.city5,
    IMGRes.city6,
    IMGRes.city7,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: cities.length,
        separatorBuilder: (_, __) =>  SizedBox(width: AppSpacing.small),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: NesticoPeCardWithText(title: cities[index], imageUrl: images[index], opacity: ColorRes.black,isCenterText: true,height: 100,),
            // child: Column(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     CircleAvatar(
            //       radius: 45,
            //       backgroundImage: AssetImage(images[index]),
            //       backgroundColor: Colors.grey[200],
            //     ),
            //     const SizedBox(height: 6),
            //     Text(
            //       cities[index],
            //       style: TextStyle(
            //         fontSize: 12,
            //         fontWeight: FontWeight.w500,
            //         color: Colors.black87,
            //       ),
            //       maxLines: 1,
            //       overflow: TextOverflow.ellipsis,
            //     ),
            //   ],
            // ),
          );
        },
      ),
    );
  }
}