import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart';
import 'package:housing_flutter_app/modules/seller/view/seller_profile.dart';

import '../../../../app/constants/color_res.dart';
import '../../../../data/network/top_seller_profile/model/top_seller_profile_model.dart';

class SellerListWidget extends StatelessWidget {
  final List<TopSeller> topSeller;

  const SellerListWidget({Key? key, required this.topSeller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("[TopSeller] topSeller : ${topSeller.map((e) => e.firstName)}");
    return SizedBox(
      height: 190, // smaller height
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: topSeller.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          final seller = topSeller[index];

          return SizedBox(
            width: 140, // reduced card width
            child: GestureDetector(
              onTap: () {
                // Get.to(
                //   () => AgentProfilePage(
                //     agent: AgentProfile(
                //       name: "Houselink Properties",
                //       logoUrl:
                //           "https://img.freepik.com/premium-vector/man-avatar-profile-picture-isolated-background-avatar-profile-picture-man_1293239-4866.jpg",
                //       badgeText: "HOUSING EXPERT PRO",
                //       buyersServed: "600+ Buyers Served",
                //       listings: "Authentic Listing",
                //       description:
                //           "Deal with ready-to-move & under-construction Residential or Commercial.",
                //       infoTiles: [
                //         InfoTileData(title: "Experience", value: "8 years"),
                //         InfoTileData(title: "Properties", value: "54"),
                //         InfoTileData(title: 'Firm Prop', value: 'Firm'),
                //       ],
                //       areas: ["Ghatkopar East", "Vikhroli East"],
                //       categories: [
                //         {'type': 'Buy', 'number': 17},
                //         {'type': 'Rent', 'number': 17},
                //         {'type': 'PG', 'number': 17},
                //       ],
                //       tags: [
                //         AgentTagData(
                //           icon: Icons.verified,
                //           text: "Trusted agent",
                //           color: ColorRes.success,
                //         ),
                //         AgentTagData(
                //           icon: Icons.star,
                //           text: "Professional Expert",
                //           color: ColorRes.homeAmber,
                //         ),
                //       ],
                //       showTags: true,
                //       showAreas: true,
                //       isOwner: false, // 🔥 hides the Areas section
                //       showActiveProperties: true,
                //       showSellertopSeller:
                //           true, // 🔥 hides SellertopSeller
                //     ),
                //   ),
                // );
              },
              child: SellerCard(
                name: '${seller.firstName} ${seller.lastName}',
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
    // return SizedBox(
    //   height: 390, // smaller height
    //   child: GridView.builder(
    //     scrollDirection: Axis.horizontal,
    //     itemCount: topSeller.length,
    //     padding: const EdgeInsets.symmetric(horizontal: 10),
    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //       crossAxisCount: 2,
    //       // mainAxisSpacing: 10,
    //       crossAxisSpacing: 10,
    //       childAspectRatio: 190 / 140, // Adjusted for wider cards
    //     ),
    //     itemBuilder: (context, index) {
    //       final property = topSeller[index];
    //       final seller = property['seller'];
    //
    //       return SizedBox(
    //         width: 140, // reduced card width
    //         child: GestureDetector(
    //           onTap: () {
    //             Get.to(
    //               () => AgentProfilePage(
    //                 agent: AgentProfile(
    //                   name: "Houselink Properties",
    //                   logoUrl:
    //                       "https://img.freepik.com/premium-vector/man-avatar-profile-picture-isolated-background-avatar-profile-picture-man_1293239-4866.jpg",
    //                   badgeText: "HOUSING EXPERT PRO",
    //                   buyersServed: "600+ Buyers Served",
    //                   listings: "Authentic Listing",
    //                   description:
    //                       "Deal with ready-to-move & under-construction Residential or Commercial.",
    //                   infoTiles: [
    //                     InfoTileData(title: "Experience", value: "8 years"),
    //                     InfoTileData(title: "Properties", value: "54"),
    //                     InfoTileData(title: 'Firm Prop', value: 'Firm'),
    //                   ],
    //                   areas: ["Ghatkopar East", "Vikhroli East"],
    //                   categories: [
    //                     {'type': 'Buy', 'number': 17},
    //                     {'type': 'Rent', 'number': 17},
    //                     {'type': 'Buy', 'number': 17},
    //                     {'type': 'Rent', 'number': 17},
    //                   ],
    //                   tags: [
    //                     AgentTagData(
    //                       icon: Icons.verified,
    //                       text: "Trusted agent",
    //                       color: Colors.green,
    //                     ),
    //                     AgentTagData(
    //                       icon: Icons.star,
    //                       text: "Professional Expert",
    //                       color: Colors.amber,
    //                     ),
    //                   ],
    //                   showTags: true,
    //                   showAreas: true,
    //                   isOwner: false,
    //                   // 🔥 hides the Areas section
    //                   showActiveProperties: true,
    //                   showSellertopSeller:
    //                       true, // 🔥 hides SellertopSeller
    //                 ),
    //               ),
    //             );
    //           },
    //           child: SellerCard(
    //             name: seller["name"],
    //             imageUrl: seller["image"],
    //             experience: seller["experience"],
    //             location: seller["location"],
    //             properties: seller["properties_count"],
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}

class SellerCard extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final String experience;
  final String location;
  final int properties;
  final String sellerType;

  const SellerCard({
    super.key,
    required this.name,
    this.imageUrl,
    required this.experience,
    required this.location,
    required this.properties,
    required this.sellerType,
  });

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     margin: const EdgeInsets.only(right: 10),
  //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(14),
  //       child: Stack(
  //         children: [
  //           Positioned.fill(
  //             child: CustomImage(
  //               type:
  //                   imageUrl != null
  //                       ? CustomImageType.network
  //                       : CustomImageType.asset,
  //               src: imageUrl ?? '',
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //
  //           // Gradient Overlay
  //           Positioned.fill(
  //             child: DecoratedBox(
  //               decoration: BoxDecoration(
  //                 gradient: LinearGradient(
  //                   begin: Alignment.topCenter,
  //                   end: Alignment.bottomCenter,
  //                   colors: [
  //                     ColorRes.transparentColor,
  //                     ColorRes.black.withOpacity(0.7),
  //                     ColorRes.black.withOpacity(0.9),
  //                   ],
  //                   stops: const [0.5, 0.7, 1.0],
  //                 ),
  //               ),
  //             ),
  //           ),
  //
  //           Positioned(
  //             left: 10,
  //             top: 10,
  //             child: Container(
  //               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
  //               decoration: BoxDecoration(
  //                 color: ColorRes.homedeepOrange.shade600,
  //                 borderRadius: BorderRadius.circular(4),
  //               ),
  //               child: Text(
  //                 'Top Rated',
  //                 style: TextStyle(
  //                   color: ColorRes.white,
  //                   fontSize: AppFontSizes.mini,
  //                   fontWeight: AppFontWeights.semiBold,
  //                 ),
  //               ),
  //             ),
  //           ),
  //
  //           // Bottom Content
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 Text(
  //                   name,
  //                   maxLines: 1,
  //                   overflow: TextOverflow.ellipsis,
  //                   style: TextStyle(
  //                     color: ColorRes.white,
  //                     fontWeight: AppFontWeights.semiBold,
  //                     fontSize: AppFontSizes.caption,
  //                   ),
  //                 ),
  //
  //                 const SizedBox(height: 4),
  //
  //                 Row(
  //                   children: [
  //                     Icon(
  //                       Icons.work_outline,
  //                       size: 12,
  //                       color: ColorRes.whiteShade,
  //                     ),
  //                     const SizedBox(width: 4),
  //                     Text(
  //                       "$experience yrs Exp.",
  //                       style: TextStyle(
  //                         color: ColorRes.white.withOpacity(0.9),
  //                         fontSize: AppFontSizes.mini,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //
  //                 const SizedBox(height: 4),
  //
  //                 Row(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Icon(
  //                       Icons.location_on_outlined,
  //                       size: 12,
  //                       color: ColorRes.white.withOpacity(0.9),
  //                     ),
  //                     const SizedBox(width: 3),
  //                     Expanded(
  //                       child: Text(
  //                         location,
  //                         maxLines: 1,
  //                         overflow: TextOverflow.ellipsis,
  //                         style: TextStyle(
  //                           fontSize: AppFontSizes.mini,
  //                           color: ColorRes.white.withOpacity(0.9),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //
  //                 const SizedBox(height: 4),
  //
  //                 Row(
  //                   children: [
  //                     Text(
  //                       "${formatNumber(properties)} Properties",
  //                       style: TextStyle(
  //                         color: ColorRes.white,
  //                         fontSize: AppFontSizes.caption,
  //                         fontWeight: AppFontWeights.semiBold,
  //                       ),
  //                     ),
  //                     const SizedBox(width: 3),
  //                     const Icon(
  //                       Icons.arrow_forward_ios,
  //                       color: ColorRes.white,
  //                       size: 10,
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            // 🔹 Background image (blurred)
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: CustomImage(
                  type:
                      imageUrl != null
                          ? CustomImageType.network
                          : CustomImageType.asset,
                  src: imageUrl ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 🔹 Gradient Overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ColorRes.transparentColor,
                      ColorRes.black.withOpacity(0.5),
                      ColorRes.black.withOpacity(0.9),
                    ],
                    stops: const [0.5, 0.7, 1.0],
                  ),
                ),
              ),
            ),

            // 🔹 "Top Rated" badge
            Positioned(
              left: 10,
              top: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: ColorRes.homedeepOrange.shade600,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Top Rated',
                  style: TextStyle(
                    color: ColorRes.white,
                    fontSize: AppFontSizes.mini,
                    fontWeight: AppFontWeights.semiBold,
                  ),
                ),
              ),
            ),

            // 🔹 Foreground content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // 🟠 Circular avatar on top of blurred bg
                  SizedBox(height: 30),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ColorRes.primary, width: 2.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CustomImage(
                          height: 70,
                          width: 70,
                          type: CustomImageType.network,
                          src: imageUrl,
                        ),
                      ),
                    ),
                  ),

                  Spacer(),

                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: ColorRes.white,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: AppFontSizes.caption,
                    ),
                  ),

                  const SizedBox(height: 4),

                  if (location != null && location.isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 12,
                          color: ColorRes.white.withOpacity(0.9),
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: AppFontSizes.mini,
                              color: ColorRes.white.withOpacity(0.9),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),
                  ],

                  Row(
                    children: [
                      Text(
                        "${formatNumber(properties)} ${sellerType == "owner" ? 'Properties' : 'Projects'}",
                        style: TextStyle(
                          color: ColorRes.white,
                          fontSize: AppFontSizes.caption,
                          fontWeight: AppFontWeights.semiBold,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: ColorRes.white,
                        size: 10,
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
}

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
