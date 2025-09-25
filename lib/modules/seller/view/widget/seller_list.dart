import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/modules/seller/view/seller_profile.dart';

class SellerListWidget extends StatelessWidget {
  final List<dynamic> propertyList;

  const SellerListWidget({Key? key, required this.propertyList})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190, // smaller height
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: propertyList.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          final property = propertyList[index];
          final seller = property['seller'];

          return SizedBox(
            width: 140, // reduced card width
            child: GestureDetector(
              onTap: () {
                Get.to(
                  () => AgentProfilePage(
                    agent: AgentProfile(
                      name: "Houselink Properties",
                      logoUrl:
                          "https://img.freepik.com/premium-vector/man-avatar-profile-picture-isolated-background-avatar-profile-picture-man_1293239-4866.jpg",
                      badgeText: "HOUSING EXPERT PRO",
                      buyersServed: "600+ Buyers Served",
                      listings: "Authentic Listing",
                      description:
                          "Deal with ready-to-move & under-construction Residential or Commercial.",
                      infoTiles: [
                        InfoTileData(title: "Experience", value: "8 years"),
                        InfoTileData(title: "Properties", value: "54"),
                        InfoTileData(title: 'Firm Prop', value: 'Firm'),
                      ],
                      areas: ["Ghatkopar East", "Vikhroli East"],
                      categories: [
                        {'type': 'Buy', 'number': 17},
                        {'type': 'Rent', 'number': 17},
                        {'type': 'Buy', 'number': 17},
                        {'type': 'Rent', 'number': 17},
                      ],
                      tags: [
                        AgentTagData(
                          icon: Icons.verified,
                          text: "Trusted agent",
                          color: Colors.green,
                        ),
                        AgentTagData(
                          icon: Icons.star,
                          text: "Professional Expert",
                          color: Colors.amber,
                        ),
                      ],
                      showTags: true,
                      showAreas: true,
                      isOwner: false, // 🔥 hides the Areas section
                      showActiveProperties: true,
                      showSellerPropertyList:
                          true, // 🔥 hides SellerPropertyList
                    ),
                  ),
                );
              },
              child: SellerCard(
                name: seller["name"],
                imageUrl: seller["image"],
                experience: seller["experience"],
                location: seller["location"],
                properties: seller["properties_count"],
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
    //     itemCount: propertyList.length,
    //     padding: const EdgeInsets.symmetric(horizontal: 10),
    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //       crossAxisCount: 2,
    //       // mainAxisSpacing: 10,
    //       crossAxisSpacing: 10,
    //       childAspectRatio: 190 / 140, // Adjusted for wider cards
    //     ),
    //     itemBuilder: (context, index) {
    //       final property = propertyList[index];
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
    //                   showSellerPropertyList:
    //                       true, // 🔥 hides SellerPropertyList
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
  final String imageUrl;
  final int experience;
  final String location;
  final int properties;

  const SellerCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.experience,
    required this.location,
    required this.properties,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: Colors.deepOrange,
                    ),
                  );
                },
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 28,
                        color: Colors.grey,
                      ),
                    ),
              ),
            ),

            // Gradient Overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.9),
                    ],
                    stops: const [0.5, 0.7, 1.0],
                  ),
                ),
              ),
            ),

            Positioned(
              left: 10,
              top: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.shade600,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Top Rated',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppFontSizes.mini,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Bottom Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: AppFontSizes.caption,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(
                        Icons.work_outline,
                        size: 12,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "$experience yrs Exp.",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: AppFontSizes.mini,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: AppFontSizes.mini,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Text(
                        "${formatNumber(properties)} Properties",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: AppFontSizes.caption,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
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
