import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/widgets/image/custom_image.dart'
    hide ColorRes;
import 'package:nesticope_app/modules/seller/view/seller_profile.dart';

import '../../../../app/constants/color_res.dart';
import '../../../../data/network/top_seller_profile/model/top_seller_profile_model.dart';

class SellerListWidget extends StatelessWidget {
  final List<TopSeller> topSeller;

  const SellerListWidget({Key? key, required this.topSeller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("[TopSeller] topSeller : ${topSeller.map((e) => e.toJson())}");
    return SizedBox(
      height: 140,
      // smaller height
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: topSeller.length,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          final seller = topSeller[index];

          return SizedBox(
            width: 250, // reduced card width
            child: GestureDetector(
              onTap: () {
                Get.to(
                  () => AgentProfilePage(
                    sellerId: seller.id,
                    profilePic: seller.profilePic,
                    isOwner:
                        seller.sellerType!.toLowerCase() == 'owner'
                            ? true
                            : false,
                    // agent: AgentProfile(
                    //   name: "Houselink Properties",
                    //   logoUrl:
                    //       "https://img.freepik.com/premium-vector/man-avatar-profile-picture-isolated-background-avatar-profile-picture-man_1293239-4866.jpg",
                    //   badgeText: "HOUSING EXPERT PRO",
                    //   buyersServed: "600+ Buyers Served",
                    //   listings: "Authentic Listing",
                    //   description:
                    //       "Deal with ready-to-move & under-construction Residential or Commercial.",
                    //   infoTiles: [
                    //     InfoTileData(title: "Experience", value: "8 years"),
                    //     InfoTileData(title: "Properties", value: "54"),
                    //     InfoTileData(title: 'Firm Prop', value: 'Firm'),
                    //   ],
                    //   areas: ["Ghatkopar East", "Vikhroli East"],
                    //   categories: [
                    //     {'type': 'Buy', 'number': 17},
                    //     {'type': 'Rent', 'number': 17},
                    //     {'type': 'PG', 'number': 17},
                    //   ],
                    //   tags: [
                    //     AgentTagData(
                    //       icon: Icons.verified,
                    //       text: "Trusted agent",
                    //       color: ColorRes.success,
                    //     ),
                    //     AgentTagData(
                    //       icon: Icons.star,
                    //       text: "Professional Expert",
                    //       color: ColorRes.homeAmber,
                    //     ),
                    //   ],
                    //   showTags: true,
                    //   showAreas: true,
                    //   isOwner: false,
                    //   showActiveProperties: true,
                    //   showSellerPropertyList: true,
                    // ),
                  ),
                );
              },
              child: SellerCard(
                name:
                    '${((seller.firstName == null) || (seller.lastName == null)) ? seller.username : '${seller.firstName} ${seller.lastName}'}',
                imageUrl: seller.profilePic ?? null,
                experience: seller.sellerType ?? '',
                location: seller.city ?? '',

                properties:
                    seller.sellerType == 'builder'
                        ? seller.counts!.projects!
                        : seller.counts!.properties!,
                sellerType: seller.sellerType ?? '',
              ),
            ),
          );
        },
      ),
    );
  }
}

class SellerCard extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final String? city;
  final String? state;
  final String? sellerType;
  final bool isPremium;
  final bool isActive;
  final int? properties;
  final int? projects;
  final String? experience;
  final String? location; // optional if provided separately

  const SellerCard({
    super.key,
    required this.name,
    this.imageUrl,
    this.city,
    this.state,
    this.sellerType,
    this.isPremium = false,
    this.isActive = false,
    this.properties,
    this.projects,
    this.experience,
    this.location,
  });

  @override
  Widget build(BuildContext context) {
    log("sller name $name");
    final displayLocation =
        location ??
        [
          if (city != null && city!.isNotEmpty) city!,
          if (state != null && state!.isNotEmpty) state!,
        ].join(', ');

    final inventoryText =
        sellerType?.toLowerCase() == 'builder'
            ? '${projects ?? 0} Projects'
            : '${properties ?? 0} Properties';

    /*return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      child: Column(
mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 🧑 Profile Row
          CircleAvatar(
            radius: 25,
            backgroundColor: ColorRes.primary.withOpacity(0.1),
            backgroundImage:
            imageUrl != null && imageUrl!.isNotEmpty
                ? NetworkImage(imageUrl!)
                : null,
            child:
            imageUrl == null || imageUrl!.isEmpty
                ? const Icon(
              Icons.person,
              color: ColorRes.primary,
              size: 25,
            )
                : null,
          ),
          const SizedBox(width: 12),
        */ /*  Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar


              // Info

            ],
          ),*/ /*
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.isNotEmpty ? name : "Unknown Seller",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: AppFontSizes.bodySmall,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textPrimary,
                ),
              ),
              const SizedBox(height: 4),

              // 🏢 Seller Type + Location
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 14,
                    color: ColorRes.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    (sellerType ?? 'Owner'),
                    style: const TextStyle(
                      fontSize: AppFontSizes.caption,
                      color: ColorRes.textSecondary,
                    ),
                  ),
                  if (displayLocation.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: ColorRes.textSecondary,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        displayLocation,
                        style: const TextStyle(
                          fontSize: AppFontSizes.caption,
                          color: ColorRes.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),

              // 💼 Experience row
              // if (experience != null && experience!.isNotEmpty) ...[
              //   const SizedBox(height: 6),
              //   Row(
              //     children: [
              //       const Icon(Icons.work_outline,
              //           size: 14, color: ColorRes.textSecondary),
              //       const SizedBox(width: 4),
              //       Text(
              //         "$experience experience",
              //         style: const TextStyle(
              //           fontSize: AppFontSizes.caption,
              //           color: ColorRes.textSecondary,
              //         ),
              //       ),
              //     ],
              //   ),
              // ],
              const SizedBox(height: 6),
              //
              // // 🏅 Badges
              // Row(
              //   children: [
              //     if (isPremium)
              //       Container(
              //         padding: const EdgeInsets.symmetric(
              //           horizontal: 8,
              //           vertical: 3,
              //         ),
              //         decoration: BoxDecoration(
              //           color: Colors.amber.withOpacity(0.2),
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //         child: const Row(
              //           children: [
              //             Icon(Icons.star, size: 14, color: Colors.amber),
              //             SizedBox(width: 3),
              //             Text(
              //               "Premium",
              //               style: TextStyle(
              //                 fontSize: AppFontSizes.caption,
              //                 fontWeight: AppFontWeights.medium,
              //                 color: Colors.amber,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     if (isPremium) const SizedBox(width: 8),
              //     Container(
              //       padding: const EdgeInsets.symmetric(
              //         horizontal: 8,
              //         vertical: 3,
              //       ),
              //       decoration: BoxDecoration(
              //         color: Colors.green.withOpacity(0.15),
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //       child: const Row(
              //         children: [
              //           Icon(Icons.circle, size: 8, color: Colors.green),
              //           SizedBox(width: 4),
              //           Text(
              //             "Active",
              //             style: TextStyle(
              //               fontSize: AppFontSizes.caption,
              //               fontWeight: AppFontWeights.medium,
              //               color: Colors.green,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),

          const SizedBox(height: 14),

          // 🏘️ Inventory Section
          Row(
            children: [
              const Icon(
                Icons.home_work_outlined,
                color: ColorRes.primary,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Text(
                    //   "Inventory",
                    //   style: TextStyle(
                    //     fontSize: AppFontSizes.caption,
                    //     color: ColorRes.textSecondary,
                    //   ),
                    // ),
                    Text(
                      inventoryText,
                      style: const TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );*/

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPremium ? const Color(0xFFFFC107) : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- Top Row (Profile + Name + Badges)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey.shade200,
                backgroundImage:
                    imageUrl != null && imageUrl!.isNotEmpty
                        ? NetworkImage(imageUrl!)
                        : null,
                child:
                    (imageUrl == null || imageUrl!.isEmpty)
                        ? const Icon(Icons.person, size: 32, color: Colors.grey)
                        : null,
              ),
              const SizedBox(width: 12),

              // Name + Location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      name.isNotEmpty ? name : "Unknown Seller",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Location
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            displayLocation.isNotEmpty
                                ? displayLocation
                                : "Location not available",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: AppFontWeights.medium,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    if (isPremium || (sellerType?.isNotEmpty ?? false))
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: ColorRes.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: ColorRes.primary.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            if (isPremium)
                              const Icon(
                                Icons.workspace_premium,
                                size: 16,
                                color: Color(0xFFFFC107),
                              ),
                            if (isPremium) const SizedBox(width: 4),
                            Text(
                              '${isPremium ? "PREMIUM " : ""}${sellerType?.toUpperCase() ?? ""}',
                              style: TextStyle(
                                color: ColorRes.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Premium + SellerType Badge
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Properties / Projects Count
              Row(
                children: [
                  Icon(Icons.home_outlined, color: ColorRes.primary, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    inventoryText,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              // View Portfolio Li
            ],
          ),
        ],
      ),
    );
  }
}

extension StringCap on String {
  String get capitalizeFirst =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;
}

extension CapExtension on String {
  String get capitalizeFirst =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;
}
// class SellerCard extends StatelessWidget {
//   final String name;
//   final String? imageUrl;
//   final String experience;
//   final String location;
//   final int properties;
//   final String sellerType;
//
//   const SellerCard({
//     super.key,
//     required this.name,
//     this.imageUrl,
//     required this.experience,
//     required this.location,
//     required this.properties,
//     required this.sellerType,
//   });
//
//   // @override
//   // Widget build(BuildContext context) {
//   //   return Container(
//   //     margin: const EdgeInsets.only(right: 10),
//   //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
//   //     child: ClipRRect(
//   //       borderRadius: BorderRadius.circular(14),
//   //       child: Stack(
//   //         children: [
//   //           Positioned.fill(
//   //             child: CustomImage(
//   //               type:
//   //                   imageUrl != null
//   //                       ? CustomImageType.network
//   //                       : CustomImageType.asset,
//   //               src: imageUrl ?? '',
//   //               fit: BoxFit.cover,
//   //             ),
//   //           ),
//   //
//   //           // Gradient Overlay
//   //           Positioned.fill(
//   //             child: DecoratedBox(
//   //               decoration: BoxDecoration(
//   //                 gradient: LinearGradient(
//   //                   begin: Alignment.topCenter,
//   //                   end: Alignment.bottomCenter,
//   //                   colors: [
//   //                     ColorRes.transparentColor,
//   //                     ColorRes.black.withOpacity(0.7),
//   //                     ColorRes.black.withOpacity(0.9),
//   //                   ],
//   //                   stops: const [0.5, 0.7, 1.0],
//   //                 ),
//   //               ),
//   //             ),
//   //           ),
//   //
//   //           Positioned(
//   //             left: 10,
//   //             top: 10,
//   //             child: Container(
//   //               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//   //               decoration: BoxDecoration(
//   //                 color: ColorRes.homedeepOrange.shade600,
//   //                 borderRadius: BorderRadius.circular(4),
//   //               ),
//   //               child: Text(
//   //                 'Top Rated',
//   //                 style: TextStyle(
//   //                   color: ColorRes.white,
//   //                   fontSize: AppFontSizes.mini,
//   //                   fontWeight: AppFontWeights.semiBold,
//   //                 ),
//   //               ),
//   //             ),
//   //           ),
//   //
//   //           // Bottom Content
//   //           Padding(
//   //             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//   //             child: Column(
//   //               crossAxisAlignment: CrossAxisAlignment.start,
//   //               mainAxisAlignment: MainAxisAlignment.end,
//   //               children: [
//   //                 Text(
//   //                   name,
//   //                   maxLines: 1,
//   //                   overflow: TextOverflow.ellipsis,
//   //                   style: TextStyle(
//   //                     color: ColorRes.white,
//   //                     fontWeight: AppFontWeights.semiBold,
//   //                     fontSize: AppFontSizes.caption,
//   //                   ),
//   //                 ),
//   //
//   //                 const SizedBox(height: 4),
//   //
//   //                 Row(
//   //                   children: [
//   //                     Icon(
//   //                       Icons.work_outline,
//   //                       size: 12,
//   //                       color: ColorRes.whiteShade,
//   //                     ),
//   //                     const SizedBox(width: 4),
//   //                     Text(
//   //                       "$experience yrs Exp.",
//   //                       style: TextStyle(
//   //                         color: ColorRes.white.withOpacity(0.9),
//   //                         fontSize: AppFontSizes.mini,
//   //                       ),
//   //                     ),
//   //                   ],
//   //                 ),
//   //
//   //                 const SizedBox(height: 4),
//   //
//   //                 Row(
//   //                   mainAxisSize: MainAxisSize.min,
//   //                   children: [
//   //                     Icon(
//   //                       Icons.location_on_outlined,
//   //                       size: 12,
//   //                       color: ColorRes.white.withOpacity(0.9),
//   //                     ),
//   //                     const SizedBox(width: 3),
//   //                     Expanded(
//   //                       child: Text(
//   //                         location,
//   //                         maxLines: 1,
//   //                         overflow: TextOverflow.ellipsis,
//   //                         style: TextStyle(
//   //                           fontSize: AppFontSizes.mini,
//   //                           color: ColorRes.white.withOpacity(0.9),
//   //                         ),
//   //                       ),
//   //                     ),
//   //                   ],
//   //                 ),
//   //
//   //                 const SizedBox(height: 4),
//   //
//   //                 Row(
//   //                   children: [
//   //                     Text(
//   //                       "${formatNumber(properties)} Properties",
//   //                       style: TextStyle(
//   //                         color: ColorRes.white,
//   //                         fontSize: AppFontSizes.caption,
//   //                         fontWeight: AppFontWeights.semiBold,
//   //                       ),
//   //                     ),
//   //                     const SizedBox(width: 3),
//   //                     const Icon(
//   //                       Icons.arrow_forward_ios,
//   //                       color: ColorRes.white,
//   //                       size: 10,
//   //                     ),
//   //                   ],
//   //                 ),
//   //               ],
//
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(right: 10),
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(14),
//         child: Stack(
//           children: [
//             // 🔹 Background image (blurred)
//             Positioned.fill(
//               child: ImageFiltered(
//                 imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
//                 child: CustomImage(
//                   type:
//                       imageUrl != null
//                           ? CustomImageType.network
//                           : CustomImageType.asset,
//                   src: imageUrl ?? '',
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//
//             // 🔹 Gradient Overlay
//             Positioned.fill(
//               child: DecoratedBox(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       ColorRes.transparentColor,
//                       ColorRes.black.withOpacity(0.5),
//                       ColorRes.black.withOpacity(0.9),
//                     ],
//                     stops: const [0.5, 0.7, 1.0],
//                   ),
//                 ),
//               ),
//             ),
//
//             // 🔹 "Top Rated" badge
//             Positioned(
//               left: 10,
//               top: 10,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//                 decoration: BoxDecoration(
//                   color: ColorRes.homedeepOrange.shade600,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Text(
//                   'Top Rated',
//                   style: TextStyle(
//                     color: ColorRes.white,
//                     fontSize: AppFontSizes.mini,
//                     fontWeight: AppFontWeights.semiBold,
//                   ),
//                 ),
//               ),
//             ),
//
//             // 🔹 Foreground content
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   // 🟠 Circular avatar on top of blurred bg
//                   SizedBox(height: 30),
//                   Center(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: ColorRes.primary, width: 2.0),
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(50),
//                         child: CustomImage(
//                           height: 70,
//                           width: 70,
//                           type: CustomImageType.network,
//                           src: imageUrl,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   Spacer(),
//
//                   Text(
//                     name,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       color: ColorRes.white,
//                       fontWeight: AppFontWeights.semiBold,
//                       fontSize: AppFontSizes.caption,
//                     ),
//                   ),
//
//                   const SizedBox(height: 4),
//
//                   if (location != null && location.isNotEmpty) ...[
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.location_on_outlined,
//                           size: 12,
//                           color: ColorRes.white.withOpacity(0.9),
//                         ),
//                         const SizedBox(width: 3),
//                         Flexible(
//                           child: Text(
//                             location,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontSize: AppFontSizes.mini,
//                               color: ColorRes.white.withOpacity(0.9),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 4),
//                   ],
//
//                   Row(
//                     children: [
//                       Text(
//                         "${formatNumber(properties)} ${sellerType == "owner" ? 'Properties' : 'Projects'}",
//                         style: TextStyle(
//                           color: ColorRes.white,
//                           fontSize: AppFontSizes.caption,
//                           fontWeight: AppFontWeights.semiBold,
//                         ),
//                       ),
//                       const SizedBox(width: 3),
//                       const Icon(
//                         Icons.arrow_forward_ios,
//                         color: ColorRes.white,
//                         size: 10,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

String formatNumber(int number) {
  if (number >= 1000000000) {
    return "${(number / 1000000000).toStringAsFixed(1)}B";
  } else if (number >= 1000000) {
    return "${(number / 1000000).toStringAsFixed(1)}M";
  } else if (number >= 1000) {
    return "${(number / 1000).toStringAsFixed(1)}K";
  } else {
    return number.toString();
  }
}
