// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/app/constants/app_font_sizes.dart';
// import 'package:nesticope_app/app/constants/color_res.dart';
// import 'package:lottie/lottie.dart';
// import 'package:nesticope_app/app/constants/size_manager.dart';

// import '../../../data/network/contractor/model/contractot_service_model/contractor_service_category_model.dart';
// import '../../../utils/global.dart';
// import '../../hire_contractor/controller/hire_contractor_controller.dart';
// import '../../hire_contractor/controller/hire_contractor_filter_controller.dart';
// import '../../hire_contractor/controller/hire_contractor_list_of_profile_controller.dart';
// import '../../hire_contractor/controller/hire_contractor_new_controller.dart';
// import '../../hire_contractor/view/widget/hire_contractor_profilelist.dart';
// import '../../hire_contractor/view/widget/category_service_explorer.dart';

// class TopCategoriesSection extends StatelessWidget {
//   final List<TopCategoryItem> categories;

//   const TopCategoriesSection({super.key, required this.categories});

//   @override
//   Widget build(BuildContext context) {
//     String norm(String s) => s
//         .trim()
//         .toLowerCase()
//         .replaceAll('&', 'and')
//         .replaceAll(RegExp(r'[^a-z0-9]+'), '_');
//     final order = <String, int>{
//       'home_construction': 1,
//       'building_material_supply': 2,
//       'material_supply': 2,
//       'home_services': 3,
//       'interior_design': 4,
//       'packers_and_movers': 5,
//       'packers_movers': 5,
//       'legal_services': 6,
//     };
//     final sorted = [...categories]..sort((a, b) {
//       final ai = order[norm(a.name)] ?? 999;
//       final bi = order[norm(b.name)] ?? 999;
//       return ai.compareTo(bi);
//     });
//     return SizedBox(
//       height: 225, // Increased height to accommodate shadow
//       child: ListView.separated(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 12,
//         ), // Added vertical padding
//         scrollDirection: Axis.horizontal,
//         itemCount: sorted.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 16),

//         itemBuilder: (context, index) {
//           return _CategoryCard(item: sorted[index]);
//         },
//       ),
//     );
//   }
// }

// class _CategoryCard extends StatelessWidget {
//   final TopCategoryItem item;

//   const _CategoryCard({required this.item});

//   @override
//   Widget build(BuildContext context) {
//     final matched = contractorServiceCategories.firstWhere(
//       (c) => c["name"] == item.name,
//       orElse: () => {"icon": Icons.category, "color": Colors.grey},
//     );

//     final fallbackIcon = matched["icon"] as IconData;
//     final fallbackColor = matched["color"] as Color;

//     final controller = Get.put(HireContractorController());
//     final controllerNew = Get.put(HireContractorNewController());
//     final controllerProfileData = Get.put(
//       HireContractorListOfProfileController(),
//     );
//     final controllerFilterData = Get.put(
//       HireContractorFilterProfileController(),
//     );
//     return GestureDetector(
//       onTap: () {
//         Get.to(
//           () => CategoryServiceExplorer(
//             categoryId: item.id,
//             categoryName: item.name,
//           ),
//         );
//       },
//       child: Container(
//         width: 160,
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
//           border:
//               (() {
//                 final key = item.name
//                     .trim()
//                     .toLowerCase()
//                     .replaceAll('&', 'and')
//                     .replaceAll(RegExp(r'[^a-z0-9]+'), '_');

//                 return key == 'home_construction'
//                     ? Border.all(color: ColorRes.primary, width: 1.5)
//                     : null;
//               })(),
//           boxShadow:
//               (() {
//                 final key = item.name
//                     .trim()
//                     .toLowerCase()
//                     .replaceAll('&', 'and')
//                     .replaceAll(RegExp(r'[^a-z0-9]+'), '_');

//                 return key != 'home_construction'
//                     ? [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.04),
//                         blurRadius: 2,
//                         offset: const Offset(0, 3),
//                       ),
//                     ]
//                     : null;
//               })(),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Align(
//             //   alignment: Alignment.topRight,
//             //   child: Builder(
//             //     builder: (context) {
//             //       final key = item.name
//             //           .trim()
//             //           .toLowerCase()
//             //           .replaceAll('&', 'and')
//             //           .replaceAll(RegExp(r'[^a-z0-9]+'), '_');
//             //       final showBadge = key == 'home_construction';
//             //       if (!showBadge) return  SizedBox(
//             //         height: 20,
//             //       );
//             //       return Container(
//             //         margin: const EdgeInsets.only(left: 8),
//             //         padding: const EdgeInsets.symmetric(
//             //           horizontal: 8,
//             //           vertical: 4,
//             //         ),
//             //         decoration: BoxDecoration(
//             //           color: ColorRes.primary.withOpacity(0.15),
//             //           borderRadius: BorderRadius.circular(24),
//             //           border: Border.all(
//             //             color: ColorRes.primary.withOpacity(0.4),
//             //           ),
//             //         ),
//             //         child: Text(
//             //           'MOST POPULAR',
//             //           style: TextStyle(
//             //             color: ColorRes.primary,
//             //             fontSize: 8,
//             //             fontWeight: AppFontWeights.bold,
//             //             letterSpacing: .3,
//             //           ),
//             //         ),
//             //       );
//             //     },
//             //   ),
//             // ),
//             Align(
//               alignment: Alignment.topRight,
//               child: Builder(
//                 builder: (context) {
//                   final key = item.name
//                       .trim()
//                       .toLowerCase()
//                       .replaceAll('&', 'and')
//                       .replaceAll(RegExp(r'[^a-z0-9]+'), '_');

//                   final showBadge = key == 'home_construction';

//                   return SizedBox(
//                     height: 20,
//                     child:
//                         showBadge
//                             ? Container(
//                               margin: const EdgeInsets.only(left: 8),
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: ColorRes.primary.withOpacity(0.15),
//                                 borderRadius: BorderRadius.circular(24),
//                                 border: Border.all(
//                                   color: ColorRes.primary.withOpacity(0.4),
//                                 ),
//                               ),
//                               child: Text(
//                                 'MOST POPULAR',
//                                 style: TextStyle(
//                                   color: ColorRes.primary,
//                                   fontSize: 8,
//                                   fontWeight: AppFontWeights.bold,
//                                   letterSpacing: .3,
//                                 ),
//                               ),
//                             )
//                             : const SizedBox(), // keeps space
//                   );
//                 },
//               ),
//             ),

//             if (item.icon != null && (item.icon?.isNotEmpty ?? false))
//               SizedBox(
//                 height: 60,

//                 width: 60,
//                 child: Image.asset('assets/images/home_construction_image.png' ?? '', fit: BoxFit.contain),
//               )
//             else
//               Container(
//                 height: 50,
//                 width: 50,
//                 decoration: BoxDecoration(
//                   color: fallbackColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(
//                     12,
//                   ), // 👈 square with rounded corners
//                 ),
//                 child: Icon(fallbackIcon, color: fallbackColor, size: 25),
//               ),

//             const SizedBox(width: 12),

//             Text(
//               item.name.capitalize?.replaceAll("_", " ") ?? '',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: AppFontSizes.medium,
//                 fontWeight: AppFontWeights.semiBold,
//                 color: ColorRes.primary,
//               ),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),

//             const SizedBox(height: 8),

//             /// Description
//             Text(
//               '${item.description?.take(1).map((e) => e.trim().replaceAll('\n', ' ')).join(' ')}',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: AppFontSizes.caption,
//                 color: ColorRes.leadGreyColor.shade600,
//                 fontWeight: AppFontWeights.medium,
//                 height: 1.6,
//               ),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//             // Spacer(),
//             // Divider(color: ColorRes.leadGreyColor.shade300),
//             // SizedBox(height: 2),

//             // /// Rating Row (only if available)
//             // Row(
//             //   children: [
//             //     Icon(Icons.star, color: ColorRes.homeAmber, size: 15),
//             //     const SizedBox(width: 6),
//             //     Text(
//             //       item.averageRating.toStringAsFixed(1),
//             //       style: TextStyle(
//             //         fontWeight: FontWeight.w700,
//             //         color: ColorRes.textColor,
//             //         fontSize: 12,
//             //       ),
//             //     ),
//             //     const SizedBox(width: 6),
//             //     Text(
//             //       '(${item.serviceCount} services)',
//             //       style: TextStyle(
//             //         fontSize: 10,
//             //         fontWeight: FontWeight.w500,
//             //         color: Colors.grey.shade600,
//             //       ),
//             //     ),
//             //   ],
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:lottie/lottie.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/app/widgets/image/custom_image.dart';
import 'package:nesticope_app/modules/insights/views/insights_screen.dart';

import '../../../data/network/contractor/model/contractot_service_model/contractor_service_category_model.dart';
import '../../../utils/global.dart';
import '../../hire_contractor/controller/hire_contractor_controller.dart';
import '../../hire_contractor/controller/hire_contractor_filter_controller.dart';
import '../../hire_contractor/controller/hire_contractor_list_of_profile_controller.dart';
import '../../hire_contractor/controller/hire_contractor_new_controller.dart';
import '../../hire_contractor/view/widget/hire_contractor_profilelist.dart';
import '../../hire_contractor/view/widget/category_service_explorer.dart';

class TopCategoriesSection extends StatelessWidget {
  final List<TopCategoryItem> categories;

  const TopCategoriesSection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    String norm(String s) => s
        .trim()
        .toLowerCase()
        .replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    final order = <String, int>{
      'home_construction': 1,
      'building_material_supply': 2,
      'material_supply': 2,
      'home_services': 3,
      'interior_design': 4,
      'packers_and_movers': 5,
      'packers_movers': 5,
      'legal_services': 6,
    };
    final sorted = [...categories]..sort((a, b) {
      final ai = order[norm(a.name)] ?? 999;
      final bi = order[norm(b.name)] ?? 999;
      return ai.compareTo(bi);
    });
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        return _CategoryCard(item: sorted[index]);
      },
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final TopCategoryItem item;

  const _CategoryCard({required this.item});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double scrollOffset = 0;

  String norm(String s) => s
      .trim()
      .toLowerCase()
      .replaceAll('&', 'and')
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_');

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _assetFor(String name) {
    final key = name
        .trim()
        .toLowerCase()
        .replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    if (key == 'home_construction') {
      return 'assets/images/home_construction_image.png';
    } else if (key == 'material_supply' || key == 'building_material_supply') {
      return 'assets/images/material_supply_image.png';
    } else if (key == 'interior_design' || key == 'interio_design') {
      return 'assets/images/interio_design_image.png';
    } else if (key == 'packers_and_movers' ||
        key == 'packers_movers' ||
        key == 'packer_and_mover') {
      return 'assets/images/packer_and_mover_image.png';
    } else if (key == 'home_services' || key == 'home_service') {
      return 'assets/images/home_service_image.png';
    } else if (key == 'legal_services' || key == 'legal_service') {
      return 'assets/images/legal_service_image.png';
    }
    return 'assets/images/not_available_image.png';
  }

  // @override
  @override
  Widget build(BuildContext context) {
    Get.put(HireContractorController());
    Get.put(HireContractorNewController());
    Get.put(HireContractorListOfProfileController());
    Get.put(HireContractorFilterProfileController());

    String norm(String s) => s
        .trim()
        .toLowerCase()
        .replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_');

    final key = norm(widget.item.name);
    final isPopular = key == 'home_construction';

    /// 🎨 Gradient map
   final gradientMap = {
      'home_construction': [
        Color(0xFF00F5A0), // neon green
        Color.fromARGB(255, 0, 147, 245), // aqua blue
      ],

      'interior_design': [
        Color(0xFFFFD200), // bright yellow
        Color(0xFFFF6A00), // orange
      ],

      'packers_and_movers': [
        Color(0xFFFF512F), // orange red
        Color(0xFFDD2476), // pink
      ],

      'legal_services': [
        Color(0xFF7F00FF), // electric purple
        Color(0xFFE100FF), // neon magenta
      ],

      'home_services': [
        Color(0xFF00C6FF), // sky blue
        Color(0xFF0072FF), // deep blue
      ],

      'material_supply': [
        Color(0xFFFF9A00), // bright amber
        Color(0xFFFF3D00), // strong orange red
      ],

      'building_material_supply': [
        Color.fromARGB(255, 67, 208, 233), // bright green
        Color.fromARGB(255, 69, 56, 249), // mint cyan
      ],
    };


    final colors =
        gradientMap[key] ??
        [ColorRes.primary, ColorRes.primary.withOpacity(0.7)];

    /// 🎯 Icon map
    final svgMap = {
      'home_construction': [
        'assets/svg/service/build-svgrepo-com.svg',
        'assets/svg/service/building-construction-svgrepo-com.svg',
      ],
      'interior_design': [
        'assets/svg/service/desk-svgrepo-com.svg',
        'assets/svg/service/lamp-svgrepo-com.svg',
      ],
      'packers_and_movers': [
        'assets/svg/service/truck-svgrepo-com.svg',
        'assets/svg/service/giftbox-gift-svgrepo-com.svg',
      ],
      'legal_services': [
        'assets/svg/service/legal-issue-svgrepo-com.svg',
        'assets/svg/service/agreement-contract-a4-paper-svgrepo-com.svg',
      ],
      'home_services': [
        'assets/svg/service/plumber-svgrepo-com.svg',
        'assets/svg/service/painting-roller-outline-svgrepo-com.svg',
      ],
      'material_supply': [
        'assets/svg/service/bricks-svgrepo-com.svg',
        'assets/svg/service/bulldozers-svgrepo-com.svg',
      ],
      'building_material_supply': [
        'assets/svg/service/bricks-svgrepo-com.svg',

        'assets/svg/service/bulldozers-svgrepo-com.svg',
      ],
    };

    // return GestureDetector(
    //   onTap: () {
    //     Get.to(
    //       () => CategoryServiceExplorer(
    //         categoryId: widget.item.id,
    //         categoryName: widget.item.name,
    //       ),
    //     );
    //   },
    //   child: Container(
    //     // padding: const EdgeInsets.all(10),
    //     decoration: BoxDecoration(
    //       border:
    //           isPopular
    //               ? Border.all(color: ColorRes.primary, width: 2)
    //               : Border.all(color: Colors.transparent),
    //       gradient: LinearGradient(
    //         colors: colors,
    //         begin: Alignment.topLeft,
    //         end: Alignment.bottomRight,
    //       ),
    //       borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
    //       boxShadow: [
    //         BoxShadow(
    //           color: colors.first.withOpacity(0.25),
    //           blurRadius: 10,
    //           offset: const Offset(0, 6),
    //         ),
    //       ],
    //     ),
    //     child: Stack(
    //       children: [
    //         /// 🔥 Faded Icon (background)
    //         Positioned.fill(
    //       child: CustomPaint(painter: DiagonalDashPatternPainter()),
    //     ),
    //         Positioned(
    //           right: -5,
    //           bottom: -5,
    //           child: Icon(
    //             iconMap[key] ?? Icons.home,
    //             size: 80,
    //             color: Colors.white.withOpacity(0.3),
    //           ),
    //         ),

    //         Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             /// ⭐ Badge
    //             if (isPopular)
    //               Positioned(
    //                 top: 8,
    //                 left: 8,
    //                 child: Container(
    //                   margin: const EdgeInsets.only(left: 8, top: 8),
    //                   padding: const EdgeInsets.symmetric(
    //                     horizontal: 6,
    //                     vertical: 2,
    //                   ),
    //                   decoration: BoxDecoration(
    //                     color: Colors.black.withOpacity(0.2),
    //                     borderRadius: BorderRadius.circular(10),
    //                   ),
    //                   child: const Text(
    //                     'Most Popular',
    //                     style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: AppFontSizes.caption,
    //                       fontWeight: AppFontWeights.bold,
    //                     ),
    //                   ),
    //                 ),
    //               ),

    //             // const Spacer(),

    //             /// 🧾 Title
    //             Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Text(
    //                 widget.item.name.capitalize?.replaceAll("_", " ") ?? '',
    //                 // maxLines: 2,
    //                 // overflow: TextOverflow.ellipsis,
    //                 style: TextStyle(
    //                   color: Colors.white,
    //                   fontWeight: AppFontWeights.semiBold,
    //                   fontSize: 12,
    //                 ),
    //               ),
    //             ),

    //             const SizedBox(height: 6),

    //             /// 🎯 CTA Button
    //             // Container(
    //             //   padding: const EdgeInsets.symmetric(
    //             //     horizontal: 10,
    //             //     vertical: 5,
    //             //   ),
    //             //   decoration: BoxDecoration(
    //             //     color: Colors.white,
    //             //     borderRadius: BorderRadius.circular(20),
    //             //   ),
    //             //   child: const Text(
    //             //     "BOOK NOW",
    //             //     style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
    //             //   ),
    //             // ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return GestureDetector(
      onTap: () {

        print("Contractor data ${widget.item.id}");
        Get.to(
          () => CategoryServiceExplorer(
            categoryId: widget.item.id,
            categoryName: widget.item.name,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border:
              isPopular
                  ? Border.all(color: ColorRes.homeYellow, width: 2)
                  : null,
          borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
        ),
        child: Stack(
          children: [
            // /// 🎨 BACKGROUND GRADIENT
            //  Positioned.fill(
            //                     child: CustomPaint(
            //                       painter: CardPatternPainter(
            //                         color1: gradientMap[key]![0],
            //                         color2: gradientMap[key]![1],
            //                       ),
            //                     ),
            //                   ),

            /// 🎯 ICON
            Positioned(
              right: -8,
              bottom: -8,
              child: SvgPicture.asset(
                (svgMap[key] ??
                    [
                      'assets/svg/service/build-svgrepo-com.svg',
                      'assets/svg/service/bricks-svgrepo-com.svg',
                    ])[0],
                width: 72,
                height: 72,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.22),
                  BlendMode.srcIn,
                ),
              ),
            ),

            /// 🖼️ SVG IMAGE 2 — top-right (smaller, slightly more visible)
            Positioned(
              left: 10,
              top: 30,
              child: SvgPicture.asset(
                (svgMap[key] ??
                    [
                      'assets/svg/service/build-svgrepo-com.svg',
                      'assets/svg/service/bricks-svgrepo-com.svg',
                    ])[1],
                width: 50,
                height: 50,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.45),
                  BlendMode.srcIn,
                ),
              ),
            ),

            /// ⭐ BADGE (FIXED POSITION)
            if (isPopular)
              Positioned(
                top: 8,
                left: 4,
                child: _buildShinyText("Most Popular"),
              ),

            /// 🧾 TITLE
            Positioned(
              left: 8,
              bottom: 10,
              right: 10,
              child: Text(
                widget.item.name.capitalize?.replaceAll("_", " ") ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: AppFontWeights.semiBold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomPainter _getPainter(String name) {
    final key = norm(name);

    if (key == 'home_construction') {
      return AdvancedDashPatternPainter(
        animationValue: _controller.value,
        scrollOffset: scrollOffset,
      );
    }

    if (key == 'interior_design') {
      return WaveDashedPatternPainter();
    }

    if (key == 'packers_and_movers') {
      return WaveDashedPatternPainter();
    }

    return SmartDashPatternPainter();
  }

  Widget _buildShinyText(String text) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        /// 🎯 Smooth pulse scale
        final scale = 1 + (0.04 * sin(_controller.value * 2 * 3.1416));

        return Transform.scale(
          scale: scale,

          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: ColorRes.homeYellow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                /// ✨ Shimmer text
                ShaderMask(
                  blendMode: BlendMode.srcATop,
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      begin: Alignment(-1.5 + _controller.value * 3, 0),
                      end: Alignment(-0.5 + _controller.value * 3, 0),
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.8),
                        Colors.white,
                        Colors.white.withOpacity(0.8),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.4, 0.5, 0.6, 1.0],
                    ).createShader(bounds);
                  },
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: ColorRes.textPrimary,
                      fontSize: AppFontSizes.caption,
                      fontWeight: AppFontWeights.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class WaveDashedPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.2)
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round;

    const spacingX = 24.0;
    const spacingY = 20.0;
    const dashLength = 8.0;

    for (double x = 0; x < size.width; x += spacingX) {
      for (double y = 0; y < size.height; y += spacingY) {
        final waveOffset = 6 * ((x / spacingX) % 2 == 0 ? 1 : -1);

        canvas.drawLine(
          Offset(x, y + waveOffset),
          Offset(x + dashLength, y - waveOffset),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SmartDashPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.2)
          ..strokeWidth = 1.3
          ..strokeCap = StrokeCap.round;

    const spacing = 26.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        final isEven = ((x ~/ spacing) + (y ~/ spacing)) % 2 == 0;

        if (isEven) {
          // horizontal dash
          canvas.drawLine(Offset(x, y), Offset(x + 6, y), paint);
        } else {
          // vertical dash
          canvas.drawLine(Offset(x, y), Offset(x, y + 6), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DiagonalDashPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.4)
          ..strokeWidth = 1.4
          ..strokeCap = StrokeCap.round;

    const spacing = 22.0;
    const dashLength = 10.0;

    for (double x = -size.height; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashLength, dashLength), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AdvancedDashPatternPainter extends CustomPainter {
  final double animationValue; // 0 → 1
  final double scrollOffset;
  final double opacity;
  final double density;

  AdvancedDashPatternPainter({
    required this.animationValue,
    required this.scrollOffset,
    this.opacity = 0.4,
    this.density = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    /// 🎨 Animated Gradient
    final gradient = LinearGradient(
      begin: Alignment(-1 + animationValue * 2, -1),
      end: Alignment(1 + animationValue * 2, 1),
      colors: [
        Colors.white.withOpacity(opacity * 0.4),
        Colors.white.withOpacity(opacity),
        Colors.white.withOpacity(opacity * 0.4),
      ],
    );

    final paint =
        Paint()
          ..strokeWidth = 1.4
          ..strokeCap = StrokeCap.round
          ..shader = gradient.createShader(
            Rect.fromLTWH(0, 0, size.width, size.height),
          );

    /// 🎯 Dynamic spacing (density control)
    final spacing = 24.0 / density;
    const dashLength = 10.0;

    /// 🌊 Parallax
    final parallax = scrollOffset * 0.15;

    for (double x = -spacing; x < size.width + spacing; x += spacing) {
      for (double y = -spacing; y < size.height + spacing; y += spacing) {
        /// 🔁 Flow animation
        final animatedX = x + (animationValue * spacing);

        /// 🎯 Slight wave offset (adds uniqueness)
        final wave = 4 * ((y / spacing) % 2 == 0 ? 1 : -1);

        final finalY = y + parallax + wave;

        canvas.drawLine(
          Offset(animatedX, finalY),
          Offset(animatedX + dashLength, finalY + dashLength),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant AdvancedDashPatternPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.scrollOffset != scrollOffset ||
        oldDelegate.opacity != opacity ||
        oldDelegate.density != density;
  }
}
