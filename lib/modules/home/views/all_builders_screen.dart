import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/widgets/shimmer/shimmer_widget.dart';
import 'package:housing_flutter_app/modules/home/controllers/top_builder_all_controller.dart';
import 'package:housing_flutter_app/modules/seller/view/widget/builder_list_top.dart';
import 'package:housing_flutter_app/data/network/top_seller_profile/model/top_builder_profile_model.dart';
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
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        title: const Text(
          "Top Builders",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: ColorRes.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Obx(() {
        if (topBuilderAllController.isLoading.value &&
            topBuilderAllController.items.isEmpty) {
          return  ListView.builder(
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


class BuilderCardShimmer extends StatelessWidget {
  const BuilderCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12,vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorRes.white,

        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image Skeleton
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name Skeleton
                      Container(
                        width: double.infinity,
                        height: 16,
                        margin: const EdgeInsets.only(right: 40, top: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // City/State Location Skeleton
                      Container(
                        width: 120,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Stats Row Skeleton (Projects & Experience)
            Row(
              children: [
                Container(
                  width: 100,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 90,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Status Tiles Skeleton (Ready to move, Under Construction, etc.)
            const _BuilderStatusTileShimmer(),
            const SizedBox(height: 8),
            const _BuilderStatusTileShimmer(),
            const SizedBox(height: 8),
            const _BuilderStatusTileShimmer(),
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
        color: Colors.white, // Background needs to be white for Shimmer to paint over it properly
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