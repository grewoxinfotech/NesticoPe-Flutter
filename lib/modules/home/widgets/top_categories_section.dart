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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:lottie/lottie.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/app/widgets/image/custom_image.dart';

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

class _CategoryCard extends StatelessWidget {
  final TopCategoryItem item;

  const _CategoryCard({required this.item});

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

  @override
  Widget build(BuildContext context) {
    Get.put(HireContractorController());
    Get.put(HireContractorNewController());
    Get.put(HireContractorListOfProfileController());
    Get.put(HireContractorFilterProfileController());
    final assetPath = _assetFor(item.name);
    final key = item.name
        .trim()
        .toLowerCase()
        .replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    final isHomeConstruction = key == 'home_construction';

    return GestureDetector(
      onTap: () {
        Get.to(
          () => CategoryServiceExplorer(
            categoryId: item.id,
            categoryName: item.name,
          ),
        );
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
              child: CustomImage(
                type: CustomImageType.asset,
                src: assetPath,
                fit: BoxFit.cover,

                // height: 170,
                // width: double.infinity,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
              ),
              borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
              boxShadow: isHomeConstruction
                  ? [
                BoxShadow(
                  color: ColorRes.primary.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ] : null,
              border: isHomeConstruction
                  ? Border.all(color: ColorRes.primary, width: 2.5)
                  : null,
            ),
          ),
          if (isHomeConstruction)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: ColorRes.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Most Popular',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppFontSizes.caption,
                    fontWeight: AppFontWeights.bold,
                  ),
                ),
              ),
            ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: Text(
              item.name.capitalize?.replaceAll("_", " ") ?? '',

              style: const TextStyle(
                color: Colors.white,
                fontWeight: AppFontWeights.semiBold,
                fontSize: AppFontSizes.small,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
