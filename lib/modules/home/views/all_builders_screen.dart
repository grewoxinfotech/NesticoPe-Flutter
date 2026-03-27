import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/app/widgets/shimmer/shimmer_widget.dart';
import 'package:nesticope_app/modules/home/controllers/top_builder_all_controller.dart';
import 'package:nesticope_app/modules/seller/view/widget/builder_list_top.dart';
import 'package:nesticope_app/data/network/top_seller_profile/model/top_builder_profile_model.dart';
import 'package:shimmer/shimmer.dart';

class AllBuildersScreen extends StatefulWidget {
  const AllBuildersScreen({super.key});

  @override
  State<AllBuildersScreen> createState() => _AllBuildersScreenState();
}

class _AllBuildersScreenState extends State<AllBuildersScreen> {
  late final TopBuilderAllController topBuilderAllController;

  @override
  initState() {
    super.initState();

    topBuilderAllController = Get.put(TopBuilderAllController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Top Builders",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),

        backgroundColor: ColorRes.white,
      ),
      body: Obx(() {
        if (topBuilderAllController.isLoading.value &&
            topBuilderAllController.items.isEmpty) {
          return ListView.builder(
            itemCount: 4,
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemBuilder: (context, index) => const BuilderCardShimmer(),
          );
        }
        final List<BuilderItem> items = topBuilderAllController.items;
        if (items.isEmpty) {
          return Center(
            child: RefreshIndicator(
              onRefresh: () => topBuilderAllController.refreshTopBuilderAll(),
              child: Text(
                "No builders found",
                style: TextStyle(color: Colors.black54),
              ),
            ),
          );
        }
        log(
          'Check All Builder Data : ${items.map((e) => e.toMap()).toString()}',
        );
        return RefreshIndicator(
          onRefresh: () => topBuilderAllController.refreshTopBuilderAll(),
          child:
              (items.isNotEmpty ?? false)
                  ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final builder = items[index];
                        return BuilderCard(builder: builder);
                      },
                    ),
                  )
                  : ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 250),
                      Center(
                        child: Text(
                          "No employees found.\nPull down to refresh 🔄",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColorRes.leadGreyColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
        );
      }),
    );
  }
}

// class BuilderCardShimmer extends StatelessWidget {
//   const BuilderCardShimmer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 2,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Shimmer.fromColors(
//         baseColor: Colors.grey.shade300,
//         highlightColor: Colors.grey.shade100,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Profile Image
//             Container(
//               width: 48,
//               height: 48,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),

//             const SizedBox(width: 12),

//             /// Content
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// Name
//                   Container(
//                     height: 16,
//                     width: 150,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   ),

//                   const SizedBox(height: 6),

//                   /// Location
//                   Container(
//                     height: 12,
//                     width: 120,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   ),

//                   const SizedBox(height: 12),

//                   /// Projects | Experience
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               height: 10,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                             ),
//                             const SizedBox(height: 6),
//                             Container(
//                               height: 16,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(width: 16),

//                       Container(
//                         height: 28,
//                         width: 1,
//                         color: Colors.white,
//                       ),

//                       const SizedBox(width: 16),

//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               height: 10,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                             ),
//                             const SizedBox(height: 6),
//                             Container(
//                               height: 16,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(width: 10),

//             /// Arrow Button
//             Container(
//               height: 40,
//               width: 40,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class BuilderCardShimmer extends StatelessWidget {
  const BuilderCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Profile Image with badge placeholder
            Stack(
              clipBehavior: Clip.none,
              children: [
                /// Circular avatar
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),

                /// Verification badge
                Positioned(
                  bottom: 0,
                  right: -4,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Name
            Container(
              height: 16,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            const SizedBox(height: 8),

            /// Location row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  height: 12,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Divider
            Container(height: 1, width: double.infinity, color: Colors.white),

            const SizedBox(height: 12),

            /// Projects | Divider | Experience
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// Projects column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          height: 18,
                          width: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                /// Vertical divider
                Container(height: 36, width: 1, color: Colors.white),

                /// Experience column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          height: 18,
                          width: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// View Profile Button
            Container(
              height: 44,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuilderStatusTileShimmer extends StatelessWidget {
  const _BuilderStatusTileShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color:
            Colors
                .white, // Background needs to be white for Shimmer to paint over it properly
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Label Skeleton
          Container(
            width: 110,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          // Count Badge Skeleton
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ],
      ),
    );
  }
}
